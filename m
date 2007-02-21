Return-Path: <linux-kernel-owner+w=401wt.eu-S1423149AbXBUVVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423149AbXBUVVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423160AbXBUVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:21:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423152AbXBUVVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:21:13 -0500
Date: Wed, 21 Feb 2007 22:15:45 +0100
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
Subject: [patch 09/13] syslets: x86, mark async unsafe syscalls
Message-ID: <20070221211545.GI7579@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0052]
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
@@ -731,6 +731,9 @@ struct task_struct fastcall * __switch_t
 
 asmlinkage int sys_fork(struct pt_regs regs)
 {
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	return do_fork(SIGCHLD, regs.esp, &regs, 0, NULL, NULL);
 }
 
@@ -740,6 +743,9 @@ asmlinkage int sys_clone(struct pt_regs 
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
@@ -208,6 +208,9 @@ asmlinkage int sys_vm86old(struct pt_reg
 	struct task_struct *tsk;
 	int tmp, ret = -EPERM;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	tsk = current;
 	if (tsk->thread.saved_esp0)
 		goto out;
@@ -238,6 +241,9 @@ asmlinkage int sys_vm86(struct pt_regs r
 	int tmp, ret;
 	struct vm86plus_struct __user *v86;
 
+	if (async_syscall(current))
+		return -ENOSYS;
+
 	tsk = current;
 	switch (regs.ebx) {
 		case VM86_REQUEST_IRQ:
