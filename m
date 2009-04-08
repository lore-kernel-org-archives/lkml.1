Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbZDHVIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbZDHVIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbZDHVHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:07:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58130 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765626AbZDHVHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:07:48 -0400
Date: Wed, 8 Apr 2009 14:07:45 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, garyhade@us.ibm.com, lcm@us.ibm.com
Subject: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered
	active device IRQ interrruption
Message-ID: <20090408210745.GE11159@us.ibm.com>
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
We have seen this problem happen when IRQ affinities are
adjusted in response to CPU offlining but I believe it
could also happen in during user initiated IRQ affinity
changes unrelated to CPU offlining. e.g. while the 
irqbalance daemon is adjusting IRQ affinities when the
system is heavily loaded.

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

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/kernel/apic/io_apic.c |   72 ++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.30-rc1.orig/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:24:11.000000000 -0700
+++ linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:24:23.000000000 -0700
@@ -2331,7 +2331,8 @@ set_desc_affinity(struct irq_desc *desc,
 }
 
 static void
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+set_ioapic_irq_affinity_desc(struct irq_desc *desc,
+			     const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -2352,6 +2353,75 @@ set_ioapic_affinity_irq_desc(struct irq_
 }
 
 static void
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
+
+			desc->chip->set_affinity(irq, desc->pending_mask);
+			spin_unlock_irqrestore(&desc->lock, flags);
+		}
+	}
+}
+
+static DECLARE_DELAYED_WORK(delayed_irq_move_work, delayed_irq_move);
+
+static void
+set_ioapic_irq_affinity_level_desc(struct irq_desc *desc)
+{
+
+	struct irq_cfg *cfg = desc->chip_data;
+
+	mask_IO_APIC_irq_desc(desc);
+
+	if (io_apic_level_ack_pending(cfg)) {
+		/*
+		 * Interrupt in progress. Migrating irq now will change
+		 * the vector information in the IO-APIC RTE which will
+		 * confuse the EOI broadcast performed by cpu.
+		 * So, we delay the irq migration.
+		 */
+		schedule_delayed_work(&delayed_irq_move_work, 1);
+		goto unmask;
+	}
+
+	/* Interrupt not in progress. we can change the vector
+	 * information in the IO-APIC RTE. */
+	set_ioapic_irq_affinity_desc(desc, desc->pending_mask);
+
+	desc->status &= ~IRQ_MOVE_PENDING;
+	cpumask_clear(desc->pending_mask);
+
+unmask:
+	unmask_IO_APIC_irq_desc(desc);
+}
+
+static void
+set_ioapic_affinity_irq_desc(struct irq_desc *desc,
+			     const struct cpumask *mask)
+{
+	if (desc->status & IRQ_LEVEL) {
+		desc->status |= IRQ_MOVE_PENDING;
+		cpumask_copy(desc->pending_mask, mask);
+		set_ioapic_irq_affinity_level_desc(desc);
+		return;
+	}
+	set_ioapic_irq_affinity_desc(desc, mask);
+}
+
+static void
 set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc;
