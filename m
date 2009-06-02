Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZFBTcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZFBTcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZFBTca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:32:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55717 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZFBTcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:32:18 -0400
Date: Tue, 2 Jun 2009 12:32:16 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, ebiederm@xmission.com, yinghai@kernel.org,
       lcm@us.ibm.com
Subject: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "active" device IRQ interrruption
Message-ID: <20090602193216.GC7282@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Eliminates an issue that can leave the system in an
        unusable state.

This patch addresses an issue where device generated IRQs
are no longer seen by the kernel following IRQ affinity
migration while the device is generating IRQs at a high rate.

I have been able to consistently reproduce the problem on
some of our systems by running the following script (VICTIM_IRQ
specifies the IRQ for the aic94xx device) while a single instance
of the command
  # while true; do find / -exec file {} \;; done
is keeping the filesystem activity and IRQ rate reasonably high.

#!/bin/sh

SYS_CPU_DIR=/sys/devices/system/cpu
VICTIM_IRQ=25
IRQ_MASK=f0

iteration=0
while true; do
  echo $iteration
  echo $IRQ_MASK > /proc/irq/$VICTIM_IRQ/smp_affinity
  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
    echo 0 > $cpudir/online
  done
  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
    echo 1 > $cpudir/online
  done
  iteration=`expr $iteration + 1`
done

The root cause is a known issue already addressed for some
code paths [e.g. ack_apic_level() and the now obsolete
migrate_irq_remapped_level_desc()] where the ioapic can
misbehave when the I/O redirection table register is written
while the Remote IRR bit is set.

The proposed fix uses the same avoidance method and much
of same code that the Interrupt Remapping code previously
used to avoid the same problem.

Successfully tested with Ingo's linux-2.6-tip (32 and 64-bit
builds) on the IBM x460, x3550 M2, x3850, and x3950 M2.

v2: modified to integrate with Yinghai Lu's
    "irq: change ->set_affinity() to return status" changes
    to intersecting/related code.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/kernel/apic/io_apic.c |   68 ++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c	2009-05-14 14:11:00.000000000 -0700
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c	2009-05-14 14:11:32.000000000 -0700
@@ -2296,7 +2296,8 @@ set_desc_affinity(struct irq_desc *desc,
 }

 static int
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+set_ioapic_irq_affinity_desc(struct irq_desc *desc,
+			     const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -2320,6 +2321,71 @@ set_ioapic_affinity_irq_desc(struct irq_
 	return ret;
 }

+static void
+delayed_irq_move(struct work_struct *work)
+{
+	unsigned int irq;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(irq, desc) {
+		if (desc->status & IRQ_MOVE_PENDING) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&desc->lock, flags);
+			if (!desc->chip->set_affinity ||
+			    !(desc->status & IRQ_MOVE_PENDING)) {
+				desc->status &= ~IRQ_MOVE_PENDING;
+				spin_unlock_irqrestore(&desc->lock, flags);
+				continue;
+			}
+			desc->chip->set_affinity(irq, desc->pending_mask);
+			spin_unlock_irqrestore(&desc->lock, flags);
+		}
+	}
+}
+
+static DECLARE_DELAYED_WORK(delayed_irq_move_work, delayed_irq_move);
+
+static int
+set_ioapic_irq_affinity_level_desc(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg = desc->chip_data;
+	int ret = -1;
+
+	mask_IO_APIC_irq_desc(desc);
+	if (io_apic_level_ack_pending(cfg)) {
+		/*
+		 * Interrupt in progress. Migrating irq now will change
+		 * the vector information in the IO-APIC RTE which will
+		 * confuse the EOI broadcast performed by cpu.
+		 * So, we delay the IRQ migration.
+		 */
+		schedule_delayed_work(&delayed_irq_move_work, 1);
+		ret = 0;
+		goto unmask;
+	}
+
+	/* Interrupt not in progress.  We can change the vector
+	 * information in the IO-APIC RTE. */
+	ret = set_ioapic_irq_affinity_desc(desc, desc->pending_mask);
+	desc->status &= ~IRQ_MOVE_PENDING;
+unmask:
+	unmask_IO_APIC_irq_desc(desc);
+	return ret;
+}
+
+static int
+set_ioapic_affinity_irq_desc(struct irq_desc *desc,
+			     const struct cpumask *mask)
+{
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		cpumask_copy(desc->pending_mask, mask);
+		return set_ioapic_irq_affinity_level_desc(desc);
+	}
+	return set_ioapic_irq_affinity_desc(desc, mask);
+}
+
 static int
 set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {

