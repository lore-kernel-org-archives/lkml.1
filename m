Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYISUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYISUIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYISUID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:08:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60247 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751371AbYISUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:08:01 -0400
Date: Fri, 19 Sep 2008 15:08:00 -0500
From: Dean Nelson <dcn@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [PATCH 3/3] switch non-standard SYSCALL_VECTOR allocation to use vector_irq v2
Message-ID: <20080919200800.GD6528@sgi.com>
References: <20080919200212.GA6528@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919200212.GA6528@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the current use of used_vectors[] for the allocation of a non-standard
SYSCALL_VECTOR by also using the per_cpu variable vector_irq[].

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/x86/kernel/traps_32.c            |   16 ++++++++++------
 drivers/lguest/interrupts_and_traps.c |   28 ++++++++++++++++++++++------
 include/asm-x86/irq.h                 |    3 ---
 3 files changed, 32 insertions(+), 15 deletions(-)

Index: linux/arch/x86/kernel/traps_32.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_32.c	2008-09-19 11:01:10.000000000 -0500
+++ linux/arch/x86/kernel/traps_32.c	2008-09-19 12:35:32.000000000 -0500
@@ -63,9 +63,6 @@
 
 #include "mach_traps.h"
 
-DECLARE_BITMAP(used_vectors, NR_VECTORS);
-EXPORT_SYMBOL_GPL(used_vectors);
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -1185,6 +1182,8 @@ asmlinkage void math_emulate(long arg)
 void __init trap_init(void)
 {
 	int i;
+	int ret;
+	unsigned long flags;
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1232,10 +1231,15 @@ void __init trap_init(void)
 	set_system_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
-		set_bit(i, used_vectors);
+	spin_lock_irqsave(&vector_lock, flags);
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
+		ret = grab_irq_vector(NON_IRQ_DESC, i, &cpu_possible_map);
+		BUG_ON(ret != i);
+	}
 
-	set_bit(SYSCALL_VECTOR, used_vectors);
+	ret = grab_irq_vector(NON_IRQ_DESC, SYSCALL_VECTOR, &cpu_possible_map);
+	BUG_ON(ret != SYSCALL_VECTOR);
+	spin_unlock_irqrestore(&vector_lock, flags);
 
 	/*
 	 * Should be a barrier for any external CPU state:
Index: linux/include/asm-x86/irq.h
===================================================================
--- linux.orig/include/asm-x86/irq.h	2008-09-19 11:09:32.000000000 -0500
+++ linux/include/asm-x86/irq.h	2008-09-19 12:35:32.000000000 -0500
@@ -44,9 +44,6 @@ extern unsigned int do_IRQ(struct pt_reg
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 
-/* Interrupt vector management */
-extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
-
 struct irq_desc;
 extern int grab_irq_vector(struct irq_desc *desc, unsigned int vector,
 			   cpumask_t *new_domain_mask);
Index: linux/drivers/lguest/interrupts_and_traps.c
===================================================================
--- linux.orig/drivers/lguest/interrupts_and_traps.c	2008-09-19 11:01:10.000000000 -0500
+++ linux/drivers/lguest/interrupts_and_traps.c	2008-09-19 12:41:02.000000000 -0500
@@ -221,19 +221,35 @@ bool check_syscall_vector(struct lguest 
 
 int init_interrupts(void)
 {
+	unsigned long flags;
+	int ret;
+
 	/* If they want some strange system call vector, reserve it now */
-	if (syscall_vector != SYSCALL_VECTOR
-	    && test_and_set_bit(syscall_vector, used_vectors)) {
-		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
-		return -EBUSY;
+	if (syscall_vector != SYSCALL_VECTOR) {
+		spin_lock_irqsave(&vector_lock, flags);
+		ret = grab_irq_vector(NON_IRQ_DESC, syscall_vector,
+				      &cpu_possible_map);
+		spin_unlock_irqrestore(&vector_lock, flags);
+		if (ret != syscall_vector) {
+			printk(KERN_WARNING "lg: couldn't reserve syscall %u\n",
+			       syscall_vector);
+			return ret;
+		}
 	}
 	return 0;
 }
 
 void free_interrupts(void)
 {
-	if (syscall_vector != SYSCALL_VECTOR)
-		clear_bit(syscall_vector, used_vectors);
+	int cpu;
+
+	if (syscall_vector != SYSCALL_VECTOR) {
+		for_each_possible_cpu(cpu) {
+			BUG_ON(per_cpu(vector_irq, cpu)[syscall_vector] !=
+			       NON_IRQ_DESC);
+			per_cpu(vector_irq, cpu)[syscall_vector] = NULL;
+		}
+	}
 }
 
 /*H:220 Now we've got the routines to deliver interrupts, delivering traps like
