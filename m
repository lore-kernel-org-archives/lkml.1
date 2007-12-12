Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbXLLUuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbXLLUuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760673AbXLLUtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:49:08 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40751 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXLLUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:49:06 -0500
Date: Wed, 12 Dec 2007 15:47:58 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/6] UML - Get rid of syscall counters
Message-ID: <20071212204758.GA9129@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some syscall counters which haven't been useful in ages.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/kern_util.h        |    1 -
 arch/um/kernel/skas/syscall.c      |    3 ---
 arch/um/kernel/syscall.c           |    3 ---
 include/asm-um/processor-generic.h |    2 --
 4 files changed, 9 deletions(-)

Index: linux-2.6-git/arch/um/include/kern_util.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/kern_util.h	2007-12-12 13:28:42.000000000 -0500
+++ linux-2.6-git/arch/um/include/kern_util.h	2007-12-12 13:36:57.000000000 -0500
@@ -13,7 +13,6 @@ extern int uml_exitcode;
 
 extern int ncpus;
 extern int kmalloc_ok;
-extern int nsyscalls;
 
 #define UML_ROUND_UP(addr) \
 	((((unsigned long) addr) + PAGE_SIZE - 1) & PAGE_MASK)
Index: linux-2.6-git/arch/um/kernel/skas/syscall.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/syscall.c	2007-12-03 23:56:34.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/syscall.c	2007-12-12 13:36:58.000000000 -0500
@@ -17,9 +17,6 @@ void handle_syscall(struct uml_pt_regs *
 
 	syscall_trace(r, 0);
 
-	current->thread.nsyscalls++;
-	nsyscalls++;
-
 	/*
 	 * This should go in the declaration of syscall, but when I do that,
 	 * strace -f -c bash -c 'ls ; ls' breaks, sometimes not tracing
Index: linux-2.6-git/arch/um/kernel/syscall.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/syscall.c	2007-12-03 23:56:34.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/syscall.c	2007-12-12 13:36:58.000000000 -0500
@@ -13,9 +13,6 @@
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
 
-/*  Unlocked, I don't care if this is a bit off */
-int nsyscalls = 0;
-
 long sys_fork(void)
 {
 	long ret;
Index: linux-2.6-git/include/asm-um/processor-generic.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/processor-generic.h	2007-12-12 13:28:42.000000000 -0500
+++ linux-2.6-git/include/asm-um/processor-generic.h	2007-12-12 13:51:08.000000000 -0500
@@ -26,7 +26,6 @@ struct thread_struct {
 	 * as of 2.6.11).
 	 */
 	int forking;
-	int nsyscalls;
 	struct pt_regs regs;
 	int singlestep_syscall;
 	void *fault_addr;
@@ -58,7 +57,6 @@ struct thread_struct {
 #define INIT_THREAD \
 { \
 	.forking		= 0, \
-	.nsyscalls		= 0, \
 	.regs		   	= EMPTY_REGS,	\
 	.fault_addr		= NULL, \
 	.prev_sched		= NULL, \
