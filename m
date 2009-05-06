Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbZEFKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbZEFKjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZEFKjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:39:10 -0400
Received: from verein.lst.de ([213.95.11.210]:48475 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZEFKjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:39:09 -0400
Date: Wed, 6 May 2009 12:38:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: rostedt@goodmis.org, mingo@elte.hu, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sh: remove stray markers
Message-ID: <20090506103854.GA23811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/sh has a couple of stray markers without any users introduced
in commit 3d58695edbfac785161bf282dc11fd42a483d6c9.  Remove them in
preparation of removing the markers in favour of the TRACE_EVENT
macro (and also because we don't keep dead code around).

Paul, are you okay putting this in via the tracing tree?  I'd like
to have all marker removals queued up there so we can kill it in one
go once 2.6.31 opens.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-tip/arch/sh/kernel/process_32.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/process_32.c	2009-05-06 10:35:22.000000000 +0000
+++ linux-2.6-tip/arch/sh/kernel/process_32.c	2009-05-06 10:35:25.000000000 +0000
@@ -119,8 +119,6 @@
 	pid = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 		      &regs, 0, NULL, NULL);
 
-	trace_mark(kernel_arch_kthread_create, "pid %d fn %p", pid, fn);
-
 	return pid;
 }
 
Index: linux-2.6-tip/arch/sh/kernel/process_64.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/process_64.c	2009-05-06 10:35:22.000000000 +0000
+++ linux-2.6-tip/arch/sh/kernel/process_64.c	2009-05-06 10:35:36.000000000 +0000
@@ -323,7 +323,6 @@
 int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 {
 	struct pt_regs regs;
-	int pid;
 
 	memset(&regs, 0, sizeof(regs));
 	regs.regs[2] = (unsigned long)arg;
@@ -333,12 +332,8 @@
 	regs.sr = (1 << 30);
 
 	/* Ok, create the new process.. */
-	pid = do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0,
 		      &regs, 0, NULL, NULL);
-
-	trace_mark(kernel_arch_kthread_create, "pid %d fn %p", pid, fn);
-
-	return pid;
 }
 
 /*
Index: linux-2.6-tip/arch/sh/kernel/sys_sh.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/sys_sh.c	2009-05-06 10:35:22.000000000 +0000
+++ linux-2.6-tip/arch/sh/kernel/sys_sh.c	2009-05-06 10:35:41.000000000 +0000
@@ -79,8 +79,6 @@
 	version = call >> 16; /* hack for backward compatibility */
 	call &= 0xffff;
 
-	trace_mark(kernel_arch_ipc_call, "call %u first %d", call, first);
-
 	if (call <= SEMTIMEDOP)
 		switch (call) {
 		case SEMOP:
Index: linux-2.6-tip/arch/sh/mm/fault_32.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/mm/fault_32.c	2009-05-06 10:35:22.000000000 +0000
+++ linux-2.6-tip/arch/sh/mm/fault_32.c	2009-05-06 10:35:59.000000000 +0000
@@ -249,9 +249,6 @@
 {
 	int ret = 0;
 
-	trace_mark(kernel_arch_trap_entry, "trap_id %d ip #p%ld",
-		   trap >> 5, instruction_pointer(regs));
-
 #ifdef CONFIG_KPROBES
 	if (!user_mode(regs)) {
 		preempt_disable();
@@ -327,6 +324,5 @@
 
 	ret = 0;
 out:
-	trace_mark(kernel_arch_trap_exit, MARK_NOARGS);
 	return ret;
 }
