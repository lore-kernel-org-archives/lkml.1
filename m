Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYIKP3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYIKP3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIKP3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:29:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53486 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752787AbYIKP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:29:41 -0400
Date: Thu, 11 Sep 2008 10:29:40 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [RFC 4/4] switch non-standard SYSCALL_VECTOR allocation to use vector_irq[]
Message-ID: <20080911152940.GE13655@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152304.GA13655@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the current use of used_vectors[] for the allocation of a non-standard
SYSCALL_VECTOR by also using the per_cpu variable vector_irq[].

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 arch/x86/kernel/traps_32.c            |   17 +++++++++++------
 drivers/lguest/interrupts_and_traps.c |   28 ++++++++++++++++++++++------
 include/asm-x86/irq.h                 |    3 ---
 3 files changed, 33 insertions(+), 15 deletions(-)

Index: linux/arch/x86/kernel/traps_32.c
===================================================================
--- linux.orig/arch/x86/kernel/traps_32.c	2008-09-10 14:25:23.000000000 -0500
+++ linux/arch/x86/kernel/traps_32.c	2008-09-10 14:25:28.000000000 -0500
@@ -63,9 +63,6 @@
 
 #include "mach_traps.h"
 
-DECLARE_BITMAP(used_vectors, NR_VECTORS);
-EXPORT_SYMBOL_GPL(used_vectors);
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
@@ -1189,6 +1186,8 @@ asmlinkage void math_emulate(long arg)
 void __init trap_init(void)
 {
 	int i;
+	bool ret;
+	unsigned long flags;
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1236,10 +1235,16 @@ void __init trap_init(void)
 	set_system_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
-		set_bit(i, used_vectors);
+	spin_lock_irqsave(&vector_lock, flags);
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++) {
+		ret =__grab_irq_vector(NON_IRQ_DESC, i, &cpu_possible_map);
+		BUG_ON(ret == false);
+	}
 
-	set_bit(SYSCALL_VECTOR, used_vectors);
+	ret = __grab_irq_vector(NON_IRQ_DESC, SYSCALL_VECTOR,
+				&cpu_possible_map);
+	BUG_ON(ret == false);
+	spin_unlock_irqrestore(&vector_lock, flags);
 
 	/*
 	 * Should be a barrier for any external CPU state:
Index: linux/include/asm-x86/irq.h
===================================================================
--- linux.orig/include/asm-x86/irq.h	2008-09-10 14:25:23.000000000 -0500
+++ linux/include/asm-x86/irq.h	2008-09-10 14:25:28.000000000 -0500
@@ -44,9 +44,6 @@ extern unsigned int do_IRQ(struct pt_reg
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 
-/* Interrupt vector management */
-extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
-
 extern spinlock_t vector_lock;
 
 #endif /* ASM_X86__IRQ_H */
Index: linux/drivers/lguest/interrupts_and_traps.c
===================================================================
--- linux.orig/drivers/lguest/interrupts_and_traps.c	2008-09-10 14:25:23.000000000 -0500
+++ linux/drivers/lguest/interrupts_and_traps.c	2008-09-10 14:25:28.000000000 -0500
@@ -221,19 +221,35 @@ bool check_syscall_vector(struct lguest 
 
 int init_interrupts(void)
 {
+	unsigned long flags;
+	bool ret;
+
 	/* If they want some strange system call vector, reserve it now */
-	if (syscall_vector != SYSCALL_VECTOR
-	    && test_and_set_bit(syscall_vector, used_vectors)) {
-		printk("lg: couldn't reserve syscall %u\n", syscall_vector);
-		return -EBUSY;
+	if (syscall_vector != SYSCALL_VECTOR) {
+		spin_lock_irqsave(&vector_lock, flags);
+		ret = __grab_irq_vector(NON_IRQ_DESC, syscall_vector,
+					&cpu_possible_map);
+		spin_unlock_irqrestore(&vector_lock, flags);
+		if (ret == false) {
+			printk("lg: couldn't reserve syscall %u\n",
+			       syscall_vector);
+			return -EBUSY;
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
+		for_each_cpu_mask_nr(cpu, cpu_possible_map) {
+			BUG_ON(per_cpu(vector_irq, cpu)[syscall_vector] !=
+			       NON_IRQ_DESC);
+			per_cpu(vector_irq, cpu)[syscall_vector] = NULL;
+		}
+	}
 }
 
 /*H:220 Now we've got the routines to deliver interrupts, delivering traps like
