Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZKBQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZKBQS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZKBQSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:18:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:53665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbZKBQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:18:22 -0500
Date: Mon, 2 Nov 2009 16:17:27 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026230001.848830905@sbs-t61.sc.intel.com>
References: <20091026230001.848830905@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Force irq complete move during cpu offline
Message-ID: <tip-a5e74b841930bec78a4684ab9f208b2ddfe7c736@git.kernel.org>
Git-Commit-ID: a5e74b841930bec78a4684ab9f208b2ddfe7c736
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5e74b841930bec78a4684ab9f208b2ddfe7c736
Gitweb:     http://git.kernel.org/tip/a5e74b841930bec78a4684ab9f208b2ddfe7c736
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:36 +0100

x86: Force irq complete move during cpu offline

When a cpu goes offline, fixup_irqs() try to move irq's
currently destined to the offline cpu to a new cpu. But this
attempt will fail if the irq is recently moved to this cpu and
the irq still hasn't arrived at this cpu (for non intr-remapping
platforms this is when we free the vector allocation at the
previous destination) that is about to go offline.

This will endup with the interrupt subsystem still pointing the
irq to the offline cpu, causing that irq to not work any more.

Fix this by forcing the irq to complete its move (its been a
long time we moved the irq to this cpu which we are offlining
now) and then move this irq to a new cpu before this cpu goes
offline.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <20091026230001.848830905@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |   18 +++++++++++++++---
 arch/x86/kernel/irq.c          |    7 +++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ddda6cb..ffd700f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -34,6 +34,7 @@ static inline int irq_canonicalize(int irq)
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
+extern void irq_force_complete_move(int);
 #endif
 
 extern void (*generic_interrupt_extension)(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e9e5b02..4e886ef 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2450,21 +2450,33 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 {
 	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg = desc->chip_data;
-	unsigned vector, me;
+	unsigned me;
 
 	if (likely(!cfg->move_in_progress))
 		return;
 
-	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
 	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
 }
+
+static void irq_complete_move(struct irq_desc **descp)
+{
+	__irq_complete_move(descp, ~get_irq_regs()->orig_ax);
+}
+
+void irq_force_complete_move(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
+
+	__irq_complete_move(&desc, cfg->vector);
+}
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 342bcbc..b10a5e1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -305,6 +305,13 @@ void fixup_irqs(void)
 			continue;
 		}
 
+		/*
+		 * Complete the irq move. This cpu is going down and for
+		 * non intr-remapping case, we can't wait till this interrupt
+		 * arrives at this cpu before completing the irq move.
+		 */
+		irq_force_complete_move(irq);
+
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
 			affinity = cpu_all_mask;
