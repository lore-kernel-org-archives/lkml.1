Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZIVGgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZIVGgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZIVGgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:36:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:13999 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbZIVGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:35:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,429,1249282800"; 
   d="scan'208";a="495646931"
Subject: [BUGFIX 2/2] x86, mce, inject: Make injected mce valid only during
 faked handler call
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 14:35:58 +0800
Message-Id: <1253601358.15717.758.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, injected mce is valid from MCE is injected
to MCE is processed by faked handler call. It is possible for it to be
consumed by real machine_check_poll. This may confuse real system
error and mce test suite.

To fix this, this patch introduces another flag MCJ_VALID to indacate
the MCE entry is valid for injector but not for handler, while
mce.finished is used to indicate the MCE entry is valid for
handler. mce.finished is enabled only during faked MCE handler call
and protected by IRQ disabling. This make it impossible for real
machine_check_poll to consume it.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/mce.h              |   17 +++++++++++------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   23 ++++++++++++++++-------
 2 files changed, 27 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -38,13 +38,18 @@
 #define MCM_ADDR_MEM	 3	/* memory address */
 #define MCM_ADDR_GENERIC 7	/* generic */
 
-#define MCJ_CTX_MASK		3
+#define _MCJ_NMI_BROADCAST	2    /* do NMI broadcasting */
+#define _MCJ_EXCEPTION		3    /* raise as exception */
+#define _MCJ_VALID		4    /* entry is valid for injector */
+
+#define MCJ_CTX_MASK		0x03
 #define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
-#define MCJ_CTX_RANDOM		0    /* inject context: random */
-#define MCJ_CTX_PROCESS		1    /* inject context: process */
-#define MCJ_CTX_IRQ		2    /* inject context: IRQ */
-#define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
-#define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCJ_CTX_RANDOM		0x00    /* inject context: random */
+#define MCJ_CTX_PROCESS		0x01    /* inject context: process */
+#define MCJ_CTX_IRQ		0x02    /* inject context: IRQ */
+#define MCJ_NMI_BROADCAST	(1 << _MCJ_NMI_BROADCAST)
+#define MCJ_EXCEPTION		(1 << _MCJ_EXCEPTION)
+#define MCJ_VALID		(1 << _MCJ_VALID)
 
 /* Fields are zero when not available */
 struct mce {
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -32,16 +32,16 @@ static void inject_mce(struct mce *m)
 
 	/* Make sure noone reads partially written injectm */
 	i->finished = 0;
+	clear_bit(_MCJ_VALID, (unsigned long *)&i->inject_flags);
 	mb();
 	m->finished = 0;
-	/* First set the fields after finished */
+	clear_bit(_MCJ_VALID, (unsigned long *)&m->inject_flags);
 	i->extcpu = m->extcpu;
 	mb();
-	/* Now write record in order, finished last (except above) */
 	memcpy(i, m, sizeof(struct mce));
 	/* Finally activate it */
 	mb();
-	i->finished = 1;
+	set_bit(_MCJ_VALID, (unsigned long *)&i->inject_flags);
 }
 
 static void raise_poll(struct mce *m)
@@ -51,9 +51,11 @@ static void raise_poll(struct mce *m)
 
 	memset(&b, 0xff, sizeof(mce_banks_t));
 	local_irq_save(flags);
+	m->finished = 1;
 	machine_check_poll(0, &b);
-	local_irq_restore(flags);
 	m->finished = 0;
+	clear_bit(_MCJ_VALID, (unsigned long *)&m->inject_flags);
+	local_irq_restore(flags);
 }
 
 static void raise_exception(struct mce *m, struct pt_regs *pregs)
@@ -69,9 +71,11 @@ static void raise_exception(struct mce *
 	}
 	/* in mcheck exeception handler, irq will be disabled */
 	local_irq_save(flags);
+	m->finished = 1;
 	do_machine_check(pregs, 0);
-	local_irq_restore(flags);
 	m->finished = 0;
+	clear_bit(_MCJ_VALID, (unsigned long *)&m->inject_flags);
+	local_irq_restore(flags);
 }
 
 static cpumask_t mce_inject_cpumask;
@@ -89,6 +93,8 @@ static int mce_raise_notify(struct notif
 		raise_exception(m, args->regs);
 	else if (m->status)
 		raise_poll(m);
+	else
+		clear_bit(_MCJ_VALID, (unsigned long *)&m->inject_flags);
 	return NOTIFY_STOP;
 }
 
@@ -129,7 +135,7 @@ static int raise_local(void)
 		mce_notify_irq();
 		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
 	} else
-		m->finished = 0;
+		clear_bit(_MCJ_VALID, (unsigned long *)&m->inject_flags);
 
 	return ret;
 }
@@ -152,10 +158,13 @@ static void raise_mce(struct mce *m)
 		cpu_clear(get_cpu(), mce_inject_cpumask);
 		for_each_online_cpu(cpu) {
 			struct mce *mcpu = &per_cpu(injectm, cpu);
-			if (!mcpu->finished ||
+			if (!test_bit(_MCJ_VALID,
+				      (unsigned long *)&mcpu->inject_flags) ||
 			    MCJ_CTX(mcpu->inject_flags) != MCJ_CTX_RANDOM)
 				cpu_clear(cpu, mce_inject_cpumask);
 		}
+		/* make sure needed data is available on other CPUs */
+		smp_mb();
 		if (!cpus_empty(mce_inject_cpumask))
 			apic->send_IPI_mask(&mce_inject_cpumask, NMI_VECTOR);
 		start = jiffies;


