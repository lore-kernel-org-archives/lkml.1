Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbZKDWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbZKDWVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbZKDWVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:21:19 -0500
Received: from www84.your-server.de ([213.133.104.84]:58817 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbZKDWVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:21:18 -0500
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20091104120019.GK31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
	 <874opaa68v.fsf@basil.nowhere.org> <1257335404.2123.29.camel@wall-e>
	 <20091104120019.GK31511@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Nov 2009 23:21:15 +0100
Message-ID: <1257373275.18448.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

what do you think about this? The following patch implements a more
accurate KSTK_ESP. The usersp of the task will be updated in the device
and apci_timer interrupt. It would be easy to change other interrupts
too. The performance penalty should tiny. 

--- linux-2.6.32-rc5.old/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-04 23:02:53.705275836 +0100
@@ -1000,7 +1000,7 @@
 #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
+extern unsigned long KSTK_ESP(struct task_struct *task);
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
@@ -1052,4 +1052,12 @@
 	return ratio;
 }
 
+#define update_usersp(regs)                                              \
+({                                                                       \
+	unsigned long __stk__ = (unsigned long)task_stack_page(current); \
+	unsigned long __stkp__ = (regs)->sp;                             \
+	if ((__stkp__ < __stk__) || (__stkp__ >= __stk__ + THREAD_SIZE)) \
+		current->thread.usersp = __stkp__;                       \
+})
+
 #endif /* _ASM_X86_PROCESSOR_H */
--- x/linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-11-03 10:11:11.202957393 +0100
@@ -664,3 +664,9 @@
 	return do_arch_prctl(current, code, addr);
 }
 
+unsigned long KSTK_ESP(struct task_struct *task)
+{
+	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
+			(task_pt_regs(task)->sp) : \
+			((task)->thread.usersp);
+}
--- linux-2.6.32-rc5.old/arch/x86/kernel/irq_64.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/arch/x86/kernel/irq_64.c	2009-11-04 22:29:55.762951577 +0100
@@ -53,6 +53,7 @@
 	struct irq_desc *desc;
 
 	stack_overflow_check(regs);
+	update_usersp(regs);
 
 	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
--- linux-2.6.32-rc5.old/arch/x86/kernel/apic/apic.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/arch/x86/kernel/apic/apic.c	2009-11-04 23:12:32.805086991 +0100
@@ -831,6 +831,9 @@
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
+#ifndef CONFIG_X86_32
+	update_usersp(regs);
+#endif
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.

This works in my environment under load, but i have not the oversight if it work
under all circumstances. 

Stefani


