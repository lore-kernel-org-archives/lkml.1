Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbXBMO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbXBMO0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbXBMOYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbXBMOYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:24:30 -0500
Date: Tue, 13 Feb 2007 15:20:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 07/11] syslets: x86, add create_async_thread() method
Message-ID: <20070213142049.GH638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060529212109.GA2058@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add the create_async_thread() way of creating kernel threads:
these threads first execute a kernel function and when they
return from it they execute user-space.

An architecture must implement this interface before it can turn
CONFIG_ASYNC_SUPPORT on.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/kernel/entry.S     |   25 +++++++++++++++++++++++++
 arch/i386/kernel/process.c   |   31 +++++++++++++++++++++++++++++++
 include/asm-i386/processor.h |    5 +++++
 3 files changed, 61 insertions(+)

Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
@@ -996,6 +996,31 @@ ENTRY(kernel_thread_helper)
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
+ENTRY(async_thread_helper)
+	CFI_STARTPROC
+	/*
+	 * Allocate space on the stack for pt-regs.
+	 * sizeof(struct pt_regs) == 64, and we've got 8 bytes on the
+	 * kernel stack already:
+	 */
+	subl $64-8, %esp
+	CFI_ADJUST_CFA_OFFSET 64
+	movl %edx,%eax
+	push %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	call *%ebx
+	addl $4, %esp
+	CFI_ADJUST_CFA_OFFSET -4
+
+	movl %eax, PT_EAX(%esp)
+
+	GET_THREAD_INFO(%ebp)
+
+	jmp syscall_exit
+	CFI_ENDPROC
+ENDPROC(async_thread_helper)
+
+
 .section .rodata,"a"
 #include "syscall_table.S"
 
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -352,6 +352,37 @@ int kernel_thread(int (*fn)(void *), voi
 EXPORT_SYMBOL(kernel_thread);
 
 /*
+ * This gets run with %ebx containing the
+ * function to call, and %edx containing
+ * the "args".
+ */
+extern void async_thread_helper(void);
+
+/*
+ * Create an async thread
+ */
+int create_async_thread(int (*fn)(void *), void * arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.ebx = (unsigned long) fn;
+	regs.edx = (unsigned long) arg;
+
+	regs.xds = __USER_DS;
+	regs.xes = __USER_DS;
+	regs.xgs = __KERNEL_PDA;
+	regs.orig_eax = -1;
+	regs.eip = (unsigned long) async_thread_helper;
+	regs.xcs = __KERNEL_CS | get_kernel_rpl();
+	regs.eflags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
+
+	/* Ok, create the new task.. */
+	return do_fork(flags | CLONE_VM, 0, &regs, 0, NULL, NULL);
+}
+
+/*
  * Free current thread data structures etc..
  */
 void exit_thread(void)
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -468,6 +468,11 @@ extern void prepare_to_copy(struct task_
  */
 extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
+/*
+ * create an async thread:
+ */
+extern int create_async_thread(int (*fn)(void *), void * arg, unsigned long flags);
+
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
 void show_trace(struct task_struct *task, struct pt_regs *regs, unsigned long *stack);
 
