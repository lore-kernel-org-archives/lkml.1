Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYAJHcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYAJHcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJHcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:32:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYAJHcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:32:46 -0500
Date: Thu, 10 Jan 2008 08:32:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080110073215.GA11506@elte.hu>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> FASTCALL is defined empty in -mm, but UML is not compiled with 
> -mregparm=3 and so this breaks things (I noticed problems with 
> rwsem_down_write_failed).
> 
> Tried recompiling UML with -mregparm=3, but that resulted in a strange 
> failure immediately after startup:
> 
> |%G�%@: Invalid argument
> 
> What's up?

Miklos, could you try the fix below?

In general most FASTCALL/fastcall uses are bogus, except for code where 
a function that takes parameters is implemented in assembly with a 
regparm calling convention. The fix is to introduce the "asmregparm" 
attribute to mark such function prototypes with regparm(3). This is the 
opposite of asmlinkage. [asmlinkage forced regparm(0)]

	Ingo

------------>
Subject: x86: fix UML calling convention
From: Ingo Molnar <mingo@elte.hu>

introduce the "asmregparm" calling convention: for functions
implemented in assembly with a fixed regparm input parameters
calling convention.

mark the semaphore and rwsem slowpath functions with that.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/linkage.h      |    5 +++++
 include/asm-x86/rwsem.h        |   12 ++++++++----
 include/asm-x86/semaphore_32.h |    8 ++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-x86.q/include/asm-x86/linkage.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/linkage.h
+++ linux-x86.q/include/asm-x86/linkage.h
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
Index: linux-x86.q/include/asm-x86/rwsem.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/rwsem.h
+++ linux-x86.q/include/asm-x86/rwsem.h
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
Index: linux-x86.q/include/asm-x86/semaphore_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/semaphore_32.h
+++ linux-x86.q/include/asm-x86/semaphore_32.h
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

