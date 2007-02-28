Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbXB1VuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbXB1VuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXB1Vtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:49:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXB1Vtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:49:45 -0500
Date: Wed, 28 Feb 2007 22:42:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 09/12] syslets: x86, mark async unsafe syscalls
Message-ID: <20070228214207.GI2305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228213938.GA945@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

mark clone() and fork() as not available for async execution.
Both need an intact user context beneath them to work.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/kernel/ioport.c  |    6 ++++++
 arch/i386/kernel/ldt.c     |    3 +++
 arch/i386/kernel/process.c |    6 ++++++
 arch/i386/kernel/vm86.c    |    6 ++++++
 4 files changed, 21 insertions(+)

Index: linux/arch/i386/kernel/ioport.c
===================================================================
--- linux.orig/arch/i386/kernel/ioport.c
+++ linux/arch/i386/kernel/ioport.c
@@ -62,6 +62,9 @@ asmlinkage long sys_ioperm(unsigned long
 	struct tss_struct * tss;
 	unsigned long *bitmap;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
 	if (turn_on && !capable(CAP_SYS_RAWIO))
@@ -139,6 +142,9 @@ asmlinkage long sys_iopl(unsigned long u
 	unsigned int old = (regs->eflags >> 12) & 3;
 	struct thread_struct *t = &current->thread;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	if (level > 3)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
Index: linux/arch/i386/kernel/ldt.c
===================================================================
--- linux.orig/arch/i386/kernel/ldt.c
+++ linux/arch/i386/kernel/ldt.c
@@ -233,6 +233,9 @@ asmlinkage int sys_modify_ldt(int func, 
 {
 	int ret = -ENOSYS;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	switch (func) {
 	case 0:
 		ret = read_ldt(ptr, bytecount);
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -750,6 +750,9 @@ struct task_struct fastcall * __switch_t
 
 asmlinkage int sys_fork(struct pt_regs regs)
 {
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	return do_fork(SIGCHLD, regs.esp, &regs, 0, NULL, NULL);
 }
 
@@ -759,6 +762,9 @@ asmlinkage int sys_clone(struct pt_regs 
 	unsigned long newsp;
 	int __user *parent_tidptr, *child_tidptr;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	clone_flags = regs.ebx;
 	newsp = regs.ecx;
 	parent_tidptr = (int __user *)regs.edx;
Index: linux/arch/i386/kernel/vm86.c
===================================================================
--- linux.orig/arch/i386/kernel/vm86.c
+++ linux/arch/i386/kernel/vm86.c
@@ -209,6 +209,9 @@ asmlinkage int sys_vm86old(struct pt_reg
 	struct task_struct *tsk;
 	int tmp, ret = -EPERM;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	tsk = current;
 	if (tsk->thread.saved_esp0)
 		goto out;
@@ -239,6 +242,9 @@ asmlinkage int sys_vm86(struct pt_regs r
 	int tmp, ret;
 	struct vm86plus_struct __user *v86;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	tsk = current;
 	switch (regs.ebx) {
 		case VM86_REQUEST_IRQ:
