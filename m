Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZKEIUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZKEIUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZKEIUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:20:11 -0500
Received: from www84.your-server.de ([213.133.104.84]:42575 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZKEIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:20:10 -0500
Subject: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
In-Reply-To: <1257239184.4889.15.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 05 Nov 2009 09:19:49 +0100
Message-ID: <1257409189.26874.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a RFC for a more accurate KSTK_ESP implementation for the x86_64
architecture.

Because the usersp will be only updated by a context switch this value
is most of the time outdated. This patch update the per CPU variable
old_rsp in the device and timer interrupt too.  

In my opinion this can be save done if the current stack pointer is
outside the kernel stack of the current task and the instruction pointer
is not inside the kernel.

The old_rsp value will be stored in usersp in case of a context switch.

The KSTK_ESP will get the value from old_rsp in case the task is the
current task, otherwise it will read usersp.

I know about the performance coast, so this is why i ask for comments.

Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>

 include/asm/processor.h |    4 +++-
 kernel/apic/apic.c      |    3 +++
 kernel/irq_64.c         |    1 +
 kernel/process_64.c     |   20 ++++++++++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

--- linux-2.6.32-rc5.old/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-05 08:28:23.765300812 +0100
@@ -1000,7 +1000,7 @@
 #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
 
 #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
-#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
+extern unsigned long KSTK_ESP(struct task_struct *task);
 #endif /* CONFIG_X86_64 */
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
@@ -1052,4 +1052,6 @@
 	return ratio;
 }
 
+extern void update_usersp(struct pt_regs *regs);
+
 #endif /* _ASM_X86_PROCESSOR_H */
--- linux-2.6.32-rc5.old/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/arch/x86/kernel/process_64.c	2009-11-05 08:52:39.965227285 +0100
@@ -664,3 +664,23 @@
 	return do_arch_prctl(current, code, addr);
 }
 
+void update_usersp(struct pt_regs *regs)
+{
+	unsigned long stk = (unsigned long)task_stack_page(current);
+	unsigned long stkp = (regs)->sp; 
+
+	if (((stkp < stk) || (stkp >= stk + THREAD_SIZE))
+	    && regs->ip < PAGE_OFFSET)
+		percpu_write(old_rsp, stkp);
+}
+
+unsigned long KSTK_ESP(struct task_struct *task)
+{
+	if (test_tsk_thread_flag(task, TIF_IA32)) 
+		return task_pt_regs(task)->sp;
+
+	if (task != current)
+		return task->thread.usersp;
+
+	return percpu_read(old_rsp);
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


