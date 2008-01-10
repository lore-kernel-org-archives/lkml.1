Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYAJJGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYAJJGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbYAJJGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:06:13 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36111 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbYAJJGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:06:10 -0500
To: mingo@elte.hu
CC: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20080110073215.GA11506@elte.hu> (message from Ingo Molnar on
	Thu, 10 Jan 2008 08:32:16 +0100)
Subject: Re: uml and -regparm=3
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <20080110073215.GA11506@elte.hu>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1JCtMI-0007jw-5U@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 10 Jan 2008 10:05:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > FASTCALL is defined empty in -mm, but UML is not compiled with 
> > -mregparm=3 and so this breaks things (I noticed problems with 
> > rwsem_down_write_failed).
> > 
> > Tried recompiling UML with -mregparm=3, but that resulted in a strange 
> > failure immediately after startup:
> > 
> > |%Gï¿½%@: Invalid argument
> > 
> > What's up?
> 
> Miklos, could you try the fix below?
> 
> In general most FASTCALL/fastcall uses are bogus, except for code where 
> a function that takes parameters is implemented in assembly with a 
> regparm calling convention. The fix is to introduce the "asmregparm" 
> attribute to mark such function prototypes with regparm(3). This is the 
> opposite of asmlinkage. [asmlinkage forced regparm(0)]

Thanks.  Patch works, but needed to add asmregparm to the definitions
as well, plus added default define into <linux/linkage.h> (updated
patch below).

Miklos
----

Subject: x86: fix UML calling convention
From: Ingo Molnar <mingo@elte.hu>

introduce the "asmregparm" calling convention: for functions
implemented in assembly with a fixed regparm input parameters
calling convention.

mark the semaphore and rwsem slowpath functions with that.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/asm-x86/linkage.h
===================================================================
--- linux.orig/include/asm-x86/linkage.h	2008-01-09 21:16:29.000000000 +0100
+++ linux/include/asm-x86/linkage.h	2008-01-10 09:38:17.000000000 +0100
@@ -9,6 +9,11 @@
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
 #define prevent_tail_call(ret) __asm__ ("" : "=r" (ret) : "0" (ret))
+/*
+ * For 32-bit UML - mark functions implemented in assembly that use
+ * regparm input parameters:
+ */
+#define asmregparm __attribute__((regparm(3)))
 #endif
 
 #ifdef CONFIG_X86_ALIGNMENT_16
Index: linux/include/asm-x86/rwsem.h
===================================================================
--- linux.orig/include/asm-x86/rwsem.h	2008-01-09 21:16:29.000000000 +0100
+++ linux/include/asm-x86/rwsem.h	2008-01-10 09:55:07.000000000 +0100
@@ -44,10 +44,14 @@
 
 struct rwsem_waiter;
 
-extern struct rw_semaphore *FASTCALL(rwsem_down_read_failed(struct rw_semaphore *sem));
-extern struct rw_semaphore *FASTCALL(rwsem_down_write_failed(struct rw_semaphore *sem));
-extern struct rw_semaphore *FASTCALL(rwsem_wake(struct rw_semaphore *));
-extern struct rw_semaphore *FASTCALL(rwsem_downgrade_wake(struct rw_semaphore *sem));
+extern asmregparm struct rw_semaphore *
+ rwsem_down_read_failed(struct rw_semaphore *sem);
+extern asmregparm struct rw_semaphore *
+ rwsem_down_write_failed(struct rw_semaphore *sem);
+extern asmregparm struct rw_semaphore *
+ rwsem_wake(struct rw_semaphore *);
+extern asmregparm struct rw_semaphore *
+ rwsem_downgrade_wake(struct rw_semaphore *sem);
 
 /*
  * the semaphore definition
Index: linux/include/asm-x86/semaphore_32.h
===================================================================
--- linux.orig/include/asm-x86/semaphore_32.h	2008-01-09 21:16:29.000000000 +0100
+++ linux/include/asm-x86/semaphore_32.h	2008-01-10 09:38:17.000000000 +0100
@@ -83,10 +83,10 @@ static inline void init_MUTEX_LOCKED (st
 	sema_init(sem, 0);
 }
 
-void __down_failed(void /* special register calling convention */);
-int  __down_failed_interruptible(void  /* params in registers */);
-int  __down_failed_trylock(void  /* params in registers */);
-void __up_wakeup(void /* special register calling convention */);
+extern asmregparm void __down_failed(atomic_t *count_ptr);
+extern asmregparm int  __down_failed_interruptible(atomic_t *count_ptr);
+extern asmregparm int  __down_failed_trylock(atomic_t *count_ptr);
+extern asmregparm void __up_wakeup(atomic_t *count_ptr);
 
 /*
  * This is ugly, but we want the default case to fall through.
Index: linux/lib/rwsem.c
===================================================================
--- linux.orig/lib/rwsem.c	2008-01-09 21:16:30.000000000 +0100
+++ linux/lib/rwsem.c	2008-01-10 09:55:55.000000000 +0100
@@ -187,7 +187,7 @@ rwsem_down_failed_common(struct rw_semap
 /*
  * wait for the read lock to be granted
  */
-struct rw_semaphore __sched *
+asmregparm struct rw_semaphore __sched *
 rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
@@ -201,7 +201,7 @@ rwsem_down_read_failed(struct rw_semapho
 /*
  * wait for the write lock to be granted
  */
-struct rw_semaphore __sched *
+asmregparm struct rw_semaphore __sched *
 rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
@@ -216,7 +216,7 @@ rwsem_down_write_failed(struct rw_semaph
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
-struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
+asmregparm struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
@@ -236,7 +236,7 @@ struct rw_semaphore *rwsem_wake(struct r
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
-struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
+asmregparm struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
Index: linux/include/linux/linkage.h
===================================================================
--- linux.orig/include/linux/linkage.h	2008-01-09 21:16:04.000000000 +0100
+++ linux/include/linux/linkage.h	2008-01-10 10:01:52.000000000 +0100
@@ -13,6 +13,10 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
+#ifndef asmregparm
+#define asmregparm
+#endif
+
 #ifndef prevent_tail_call
 # define prevent_tail_call(ret) do { } while (0)
 #endif
