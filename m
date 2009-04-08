Return-Path: <linux-kernel-owner+w=401wt.eu-S1765770AbZDHVI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765770AbZDHVI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765410AbZDHVHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:07:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59824 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764351AbZDHVHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:07:40 -0400
Date: Wed, 8 Apr 2009 14:07:35 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org
Cc: linux-kernel@vger.kernel.org, garyhade@us.ibm.com, lcm@us.ibm.com
Subject: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered
	inactive device IRQ interrruption
Message-ID: <20090408210735.GD11159@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Eliminates a race that can leave the system in an
        unusable state

During rapid offlining of multiple CPUs there is a chance
that an IRQ affinity move destination CPU will be offlined
before the IRQ affinity move initiated during the offlining
of a previous CPU completes.  This can happen when the device
is not very active and thus fails to generate the IRQ that is
needed to complete the IRQ affinity move before the move
destination CPU is offlined.  When this happens there is an
-EBUSY return from __assign_irq_vector() during the offlining
of the IRQ move destination CPU which prevents initiation of
a new IRQ affinity move operation to an online CPU.  This
leaves the IRQ affinity set to an offlined CPU.

I have been able to reproduce the problem on some of our
systems using the following script.  When the system is idle
the problem often reproduces during the first CPU offlining
sequence.

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

The proposed fix takes advantage of the fact that when all
CPUs in the old domain are offline there is nothing to be done
by send_cleanup_vector() during the affinity move completion.
So, we simply avoid setting cfg->move_in_progress preventing
the above mentioned -EBUSY return from __assign_irq_vector().
This allows initiation of a new IRQ affinity move to a CPU
that is not going offline.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/kernel/apic/io_apic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.30-rc1.orig/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:23:00.000000000 -0700
+++ linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c	2009-04-08 09:23:16.000000000 -0700
@@ -363,7 +363,8 @@ set_extra_move_desc(struct irq_desc *des
 	struct irq_cfg *cfg = desc->chip_data;
 
 	if (!cfg->move_in_progress) {
-		/* it means that domain is not changed */
+		/* it means that domain has not changed or all CPUs
+		 * in old domain are offline */
 		if (!cpumask_intersects(desc->affinity, mask))
 			cfg->move_desc_pending = 1;
 	}
@@ -1262,8 +1263,11 @@ next:
 		current_vector = vector;
 		current_offset = offset;
 		if (old_vector) {
-			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
+			if (cpumask_intersects(cfg->old_domain,
+					       cpu_online_mask)) {
+				cfg->move_in_progress = 1;
+			}
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
@@ -2492,7 +2496,8 @@ static void irq_complete_move(struct irq
 		if (likely(!cfg->move_desc_pending))
 			return;
 
-		/* domain has not changed, but affinity did */
+		/* domain has not changed or all CPUs in old domain
+		 * are offline, but affinity changed */
 		me = smp_processor_id();
 		if (cpumask_test_cpu(me, desc->affinity)) {
 			*descp = desc = move_irq_desc(desc, me);
