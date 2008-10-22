Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYJVSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYJVSzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbYJVSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYJVSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:39 -0400
Message-Id: <20081022185137.247900443@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 14:43:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/11] ftrace: remove mcount set
Content-Disposition: inline; filename=ftrace-remove-mcount-set.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch dependent function ftrace_mcount_set was only used by the daemon
start up code. This patch removes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/arm/kernel/ftrace.c     |   13 -------------
 arch/powerpc/kernel/ftrace.c |   17 -----------------
 arch/x86/kernel/ftrace.c     |    7 -------
 include/linux/ftrace.h       |    1 -
 kernel/trace/ftrace.c        |    9 ---------
 5 files changed, 47 deletions(-)

Index: linux-compile.git/arch/arm/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/arm/kernel/ftrace.c	2008-10-22 13:10:52.000000000 -0400
+++ linux-compile.git/arch/arm/kernel/ftrace.c	2008-10-22 13:23:54.000000000 -0400
@@ -95,19 +95,6 @@ int ftrace_update_ftrace_func(ftrace_fun
 	return ret;
 }
 
-int ftrace_mcount_set(unsigned long *data)
-{
-	unsigned long pc, old;
-	unsigned long *addr = data;
-	unsigned char *new;
-
-	pc = (unsigned long)&mcount_call;
-	memcpy(&old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(pc, *addr);
-	*addr = ftrace_modify_code(pc, (unsigned char *)&old, new);
-	return 0;
-}
-
 /* run from kstop_machine */
 int __init ftrace_dyn_arch_init(void *data)
 {
Index: linux-compile.git/arch/powerpc/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/powerpc/kernel/ftrace.c	2008-10-22 13:10:52.000000000 -0400
+++ linux-compile.git/arch/powerpc/kernel/ftrace.c	2008-10-22 13:23:54.000000000 -0400
@@ -126,23 +126,6 @@ notrace int ftrace_update_ftrace_func(ft
 	return ret;
 }
 
-notrace int ftrace_mcount_set(unsigned long *data)
-{
-	unsigned long ip = (long)(&mcount_call);
-	unsigned long *addr = data;
-	unsigned char old[MCOUNT_INSN_SIZE], *new;
-
-	/*
-	 * Replace the mcount stub with a pointer to the
-	 * ip recorder function.
-	 */
-	memcpy(old, &mcount_call, MCOUNT_INSN_SIZE);
-	new = ftrace_call_replace(ip, *addr);
-	*addr = ftrace_modify_code(ip, old, new);
-
-	return 0;
-}
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* This is running in kstop_machine */
Index: linux-compile.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/ftrace.c	2008-10-22 13:16:35.000000000 -0400
+++ linux-compile.git/arch/x86/kernel/ftrace.c	2008-10-22 13:23:54.000000000 -0400
@@ -105,13 +105,6 @@ notrace int ftrace_update_ftrace_func(ft
 	return ret;
 }
 
-notrace int ftrace_mcount_set(unsigned long *data)
-{
-	/* mcount is initialized as a nop */
-	*data = 0;
-	return 0;
-}
-
 int __init ftrace_dyn_arch_init(void *data)
 {
 	extern const unsigned char ftrace_test_p6nop[];
Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-22 13:17:29.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-22 13:23:54.000000000 -0400
@@ -71,7 +71,6 @@ extern int ftrace_ip_converted(unsigned 
 extern unsigned char *ftrace_nop_replace(void);
 extern unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr);
 extern int ftrace_dyn_arch_init(void *data);
-extern int ftrace_mcount_set(unsigned long *data);
 extern int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 			      unsigned char *new_code);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:21:46.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:23:54.000000000 -0400
@@ -606,7 +606,6 @@ static int ftrace_update_code(void *igno
 
 static int __ftrace_modify_code(void *data)
 {
-	unsigned long addr;
 	int *command = data;
 
 	if (*command & FTRACE_ENABLE_CALLS) {
@@ -625,14 +624,6 @@ static int __ftrace_modify_code(void *da
 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
 		ftrace_update_ftrace_func(ftrace_trace_function);
 
-	if (*command & FTRACE_ENABLE_MCOUNT) {
-		addr = (unsigned long)ftrace_record_ip;
-		ftrace_mcount_set(&addr);
-	} else if (*command & FTRACE_DISABLE_MCOUNT) {
-		addr = (unsigned long)ftrace_stub;
-		ftrace_mcount_set(&addr);
-	}
-
 	return 0;
 }
 

-- 
