Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZC3Vzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZC3Vzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZC3Vzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:55:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38222 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZC3Vzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:55:32 -0400
Message-ID: <49D13FCE.3020106@us.ibm.com>
Date: Mon, 30 Mar 2009 14:55:26 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re:  glibc hacks for requeue_pi
References: <20090330213306.606.9540.stgit@Aeon>
In-Reply-To: <20090330213306.606.9540.stgit@Aeon>
Content-Type: multipart/mixed;
 boundary="------------060306000605070902060600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060306000605070902060600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch is what we used to test glibc with requeue_pi.
As a prototype we deleted the assembly optimizations and just updated
the .c implementation.  Credit for the prototype goes to Sripathi Kodi.

Thanks,

--
Darren Hart







--------------060306000605070902060600
Content-Type: text/x-diff;
 name="glibc_requeue_pi_prototype_v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="glibc_requeue_pi_prototype_v3.patch"

diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_broadcast.c glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_broadcast.c
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_broadcast.c	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_broadcast.c	2009-03-26 14:38:53.000000000 +0530
@@ -27,11 +27,39 @@
 #include <shlib-compat.h>
 #include <kernel-features.h>
 
+#define FUTEX_CMP_REQUEUE 4
+#define FUTEX_REQUEUE_PI 12
+#define FUTEX_CMP_REQUEUE_PI   13
+
+/* Returns non-zero if error happened, zero if success.  */
+#define lll_futex_requeue(futexp, nr_wake, nr_move, mutex, val) \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+    __ret = INTERNAL_SYSCALL (futex, __err, 6,                                \
+                              (futexp), FUTEX_CMP_REQUEUE, (nr_wake),         \
+                              (nr_move), (mutex), (val));                     \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err);                                  \
+  })
+
+
+/* Returns non-zero if error happened, zero if success.  */
+#define lll_futex_requeue_pi(futexp, nr_wake, nr_move, mutex, val) \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+    __ret = INTERNAL_SYSCALL (futex, __err, 6,                                \
+                              (futexp), FUTEX_CMP_REQUEUE_PI, (nr_wake),         \
+                              (nr_move), (mutex), (val));                     \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err);                                  \
+  })
 
 int
 __pthread_cond_broadcast (cond)
      pthread_cond_t *cond;
 {
+  int err;
+
   /* Make sure we are alone.  */
   lll_mutex_lock (cond->__data.__lock);
 
@@ -57,9 +85,25 @@ __pthread_cond_broadcast (cond)
       pthread_mutex_t *mut = (pthread_mutex_t *) cond->__data.__mutex;
 
       /* XXX: Kernel so far doesn't support requeue to PI futex.  */
-      if (__builtin_expect (mut->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP,
+/*      if (__builtin_expect (mut->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP,
 			    0))
 	goto wake_all;
+*/
+	/* requeue_pi */
+	/* This code assumes  that lll_futex_requeue_pi returns 0 on success */
+      if (mut->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+	{
+	  err = lll_futex_requeue_pi (&cond->__data.__futex, 1,  INT_MAX,
+				       &mut->__data.__lock,  futex_val);
+	  /* FIXME: We now return any error other than ENOSYS to application */
+	  if (!err)
+	    return 0;
+	  else if (err != ENOSYS)
+	    return err;
+	  else /* It is ENOSYS */
+	    goto wake_all;
+	}
+
 
       /* lll_futex_requeue returns 0 for success and non-zero
 	 for errors.  */
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_signal.c glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_signal.c
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_signal.c	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_signal.c	2009-03-26 14:43:08.000000000 +0530
@@ -27,11 +27,48 @@
 #include <shlib-compat.h>
 #include <kernel-features.h>
 
+#define FUTEX_OP_CLEAR_WAKE_IF_GT_ONE ((4 << 24) | 1)
+#define FUTEX_WAKE_OP           5
+
+#define FUTEX_REQUEUE_PI 12
+#define FUTEX_CMP_REQUEUE_PI   13
+
+/* Returns non-zero if error happened, zero if success.  */
+#define lll_futex_requeue_pi(futexp, nr_wake, nr_move, mutex, val) \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+    __ret = INTERNAL_SYSCALL (futex, __err, 6,                                \
+                              (futexp), FUTEX_REQUEUE_PI, (nr_wake),         \
+                              (nr_move), (mutex), (val));                     \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err);                                  \
+  })
+
+
+/* Returns non-zero if error happened, zero if success.  */
+#define lll_futex_wake_unlock(futexp, nr_wake, nr_wake2, futexp2) \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+                                                                              \
+    __ret = INTERNAL_SYSCALL (futex, __err, 6,                                \
+                              (futexp), FUTEX_WAKE_OP, (nr_wake),             \
+                              (nr_wake2), (futexp2),                          \
+                              FUTEX_OP_CLEAR_WAKE_IF_GT_ONE);                 \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err);                                  \
+  })
+
 
 int
 __pthread_cond_signal (cond)
      pthread_cond_t *cond;
 {
+  int err;
+
+  /* Needed for requeue_pi.  */
+  pthread_mutex_t *mut = (pthread_mutex_t *) cond->__data.__mutex;
+  int futex_val = cond->__data.__futex;
+
   /* Make sure we are alone.  */
   lll_mutex_lock (cond->__data.__lock);
 
@@ -42,6 +79,21 @@ __pthread_cond_signal (cond)
       ++cond->__data.__wakeup_seq;
       ++cond->__data.__futex;
 
+      /* requeue_pi: requeue 1 waiter */
+      /* This code assumes  that lll_futex_requeue_pi returns 0 on success */
+      if (mut->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+        { 
+	  err = lll_futex_requeue_pi (&cond->__data.__futex, 1, 0, &mut->__data.__lock,
+				       futex_val);
+	  /* FIXME: We now return any error other than ENOSYS to application 
+	   * In case of ENOSYS we fall through this code to call lll_futex_wake_unlock*/
+	  if (!err)
+	    goto requeued;
+	  else if (err != ENOSYS)
+	    return err;
+        }
+
+
       /* Wake one.  */
       if (! __builtin_expect (lll_futex_wake_unlock (&cond->__data.__futex, 1,
 						     1, &cond->__data.__lock),
@@ -51,6 +103,8 @@ __pthread_cond_signal (cond)
       lll_futex_wake (&cond->__data.__futex, 1);
     }
 
+requeued:
+
   /* We are done.  */
   lll_mutex_unlock (cond->__data.__lock);
 
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_timedwait.c glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_timedwait.c
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_timedwait.c	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_timedwait.c	2009-03-26 14:43:08.000000000 +0530
@@ -39,6 +39,18 @@ struct _condvar_cleanup_buffer
   unsigned int bc_seq;
 };
 
+#define FUTEX_WAIT_REQUEUE_PI 11
+
+#define lll_futex_timed_wait_requeue_pi(futexp, val, time, mutex) 	      \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+    __ret = INTERNAL_SYSCALL (futex, __err, 5,                                \
+                              (futexp), FUTEX_WAIT_REQUEUE_PI, (val), time, (mutex)); \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err)? -__ret : __ret;                  \
+  })
+
+
 int
 __pthread_cond_timedwait (cond, mutex, abstime)
      pthread_cond_t *cond;
@@ -151,9 +163,18 @@ __pthread_cond_timedwait (cond, mutex, a
       /* Enable asynchronous cancellation.  Required by the standard.  */
       cbuffer.oldtype = __pthread_enable_asynccancel ();
 
-      /* Wait until woken by signal or broadcast.  */
-      err = lll_futex_timed_wait (&cond->__data.__futex,
+      /* requeue_pi */
+      if (mutex->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+	{
+	  err = lll_futex_timed_wait_requeue_pi (&cond->__data.__futex,
+						 futex_val, &rt, &mutex->__data.__lock);
+	} else
+	{
+
+	  /* Wait until woken by signal or broadcast.  */
+	  err = lll_futex_timed_wait (&cond->__data.__futex,
 				  futex_val, &rt);
+	}
 
       /* Disable asynchronous cancellation.  */
       __pthread_disable_asynccancel (cbuffer.oldtype);
@@ -205,7 +226,11 @@ __pthread_cond_timedwait (cond, mutex, a
   __pthread_cleanup_pop (&buffer, 0);
 
   /* Get the mutex before returning.  */
-  err = __pthread_mutex_cond_lock (mutex);
+  /* With requeue_pi, the lock is held in the kernel, so just return 0 to application */
+  if (mutex->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+    return 0;
+  else
+    err = __pthread_mutex_cond_lock (mutex);
 
   return err ?: result;
 }
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_wait.c glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_wait.c
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/pthread/pthread_cond_wait.c	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/pthread/pthread_cond_wait.c	2009-03-26 14:43:09.000000000 +0530
@@ -87,6 +87,17 @@ __condvar_cleanup (void *arg)
   __pthread_mutex_cond_lock (cbuffer->mutex);
 }
 
+#define FUTEX_WAIT_REQUEUE_PI 11
+
+#define lll_futex_wait_requeue_pi(futexp, val, mutex) \
+  ({                                                                          \
+    INTERNAL_SYSCALL_DECL (__err);                                            \
+    long int __ret;                                                           \
+    __ret = INTERNAL_SYSCALL (futex, __err, 5,                                \
+                              (futexp), FUTEX_WAIT_REQUEUE_PI, (val), 0, (mutex)); \
+    INTERNAL_SYSCALL_ERROR_P (__ret, __err)? -__ret : __ret;                  \
+  })
+
 
 int
 __pthread_cond_wait (cond, mutex)
@@ -145,9 +156,25 @@ __pthread_cond_wait (cond, mutex)
       /* Enable asynchronous cancellation.  Required by the standard.  */
       cbuffer.oldtype = __pthread_enable_asynccancel ();
 
+      /* requeue_pi */
+      if (mutex->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+        {
+	  err = lll_futex_wait_requeue_pi (&cond->__data.__futex,
+					futex_val, &mutex->__data.__lock);
+	    /* If error is ENOSYS, we fall through this code to call lll_futex_wait.
+	     * Return any other error to application, for now 
+	     * FIXME: Find out what other errors can come from the kernel */
+	    if (!err)
+	      goto requeued;
+	    else if (err != ENOSYS)
+	      return err;
+        }
+
       /* Wait until woken by signal or broadcast.  */
       lll_futex_wait (&cond->__data.__futex, futex_val);
 
+requeued:
+
       /* Disable asynchronous cancellation.  */
       __pthread_disable_asynccancel (cbuffer.oldtype);
 
@@ -173,6 +200,10 @@ __pthread_cond_wait (cond, mutex)
   /* If pthread_cond_destroy was called on this varaible already,
      notify the pthread_cond_destroy caller all waiters have left
      and it can be successfully destroyed.  */
+
+  /* FIXME: With requeue_pi, the below check won't work properly. Hence test cases
+   * that call cond_destroy may not work correctly */
+
   if (cond->__data.__total_seq == -1ULL
       && cond->__data.__nwaiters < (1 << COND_CLOCK_BITS))
     lll_futex_wake (&cond->__data.__nwaiters, 1);
@@ -184,7 +215,11 @@ __pthread_cond_wait (cond, mutex)
   __pthread_cleanup_pop (&buffer, 0);
 
   /* Get the mutex before returning.  */
-  return __pthread_mutex_cond_lock (mutex);
+  /* With requeue_pi, the lock is held in the kernel, so just return 0 to application */
+  if (mutex->__data.__kind & PTHREAD_MUTEX_PRIO_INHERIT_NP)
+    return 0;
+  else
+    return __pthread_mutex_cond_lock (mutex);
 }
 
 versioned_symbol (libpthread, __pthread_cond_wait, pthread_cond_wait,
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_broadcast.S glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_broadcast.S
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_broadcast.S	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_broadcast.S	1970-01-01 05:30:00.000000000 +0530
@@ -1,143 +0,0 @@
-/* Copyright (C) 2002, 2003, 2004, 2005, 2006 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-   Contributed by Ulrich Drepper <drepper@redhat.com>, 2002.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, write to the Free
-   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-   02111-1307 USA.  */
-
-#include <sysdep.h>
-#include <shlib-compat.h>
-#include <lowlevelcond.h>
-#include <kernel-features.h>
-#include <pthread-pi-defines.h>
-
-#ifdef UP
-# define LOCK
-#else
-# define LOCK lock
-#endif
-
-#define SYS_futex		202
-#define FUTEX_WAIT		0
-#define FUTEX_WAKE		1
-#define FUTEX_REQUEUE		3
-#define FUTEX_CMP_REQUEUE	4
-
-#define EINVAL			22
-
-
-	.text
-
-	/* int pthread_cond_broadcast (pthread_cond_t *cond) */
-	.globl	__pthread_cond_broadcast
-	.type	__pthread_cond_broadcast, @function
-	.align	16
-__pthread_cond_broadcast:
-
-	/* Get internal lock.  */
-	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jnz	1f
-
-2:	addq	$cond_futex, %rdi
-	movq	total_seq-cond_futex(%rdi), %r9
-	cmpq	wakeup_seq-cond_futex(%rdi), %r9
-	jna	4f
-
-	/* Cause all currently waiting threads to recognize they are
-	   woken up.  */
-	movq	%r9, wakeup_seq-cond_futex(%rdi)
-	movq	%r9, woken_seq-cond_futex(%rdi)
-	addq	%r9, %r9
-	movl	%r9d, (%rdi)
-	incl	broadcast_seq-cond_futex(%rdi)
-
-	/* Get the address of the mutex used.  */
-	movq	dep_mutex-cond_futex(%rdi), %r8
-
-	/* Unlock.  */
-	LOCK
-	decl	cond_lock-cond_futex(%rdi)
-	jne	7f
-
-8:	cmpq	$-1, %r8
-	je	9f
-
-	/* XXX: The kernel so far doesn't support requeue to PI futex.  */
-	testl	$PI_BIT, MUTEX_KIND(%r8)
-	jne	9f
-
-	/* Wake up all threads.  */
-	movl	$FUTEX_CMP_REQUEUE, %esi
-	movl	$SYS_futex, %eax
-	movl	$1, %edx
-	movl	$0x7fffffff, %r10d
-	syscall
-
-	/* For any kind of error, which mainly is EAGAIN, we try again
-	   with WAKE.  The general test also covers running on old
-	   kernels.  */
-	cmpq	$-4095, %rax
-	jae	9f
-
-10:	xorl	%eax, %eax
-	retq
-
-	.align	16
-	/* Unlock.  */
-4:	LOCK
-	decl	cond_lock-cond_futex(%rdi)
-	jne	5f
-
-6:	xorl	%eax, %eax
-	retq
-
-	/* Initial locking failed.  */
-1:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-#if cond_lock != 0
-	subq	$cond_lock, %rdi
-#endif
-	jmp	2b
-
-	/* Unlock in loop requires wakeup.  */
-5:	addq	$cond_lock-cond_futex, %rdi
-	callq	__lll_mutex_unlock_wake
-	jmp	6b
-
-	/* Unlock in loop requires wakeup.  */
-7:	addq	$cond_lock-cond_futex, %rdi
-	callq	__lll_mutex_unlock_wake
-	subq	$cond_lock-cond_futex, %rdi
-	jmp	8b
-
-9:	/* The futex requeue functionality is not available.  */
-	movl	$0x7fffffff, %edx
-	movl	$FUTEX_WAKE, %esi
-	movl	$SYS_futex, %eax
-	syscall
-	jmp	10b
-	.size	__pthread_cond_broadcast, .-__pthread_cond_broadcast
-versioned_symbol (libpthread, __pthread_cond_broadcast, pthread_cond_broadcast,
-		  GLIBC_2_3_2)
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_signal.S glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_signal.S
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_signal.S	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_signal.S	1970-01-01 05:30:00.000000000 +0530
@@ -1,127 +0,0 @@
-/* Copyright (C) 2002, 2003, 2004, 2005 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-   Contributed by Ulrich Drepper <drepper@redhat.com>, 2002.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, write to the Free
-   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-   02111-1307 USA.  */
-
-#include <sysdep.h>
-#include <shlib-compat.h>
-#include <lowlevelcond.h>
-#include <kernel-features.h>
-
-#ifdef UP
-# define LOCK
-#else
-# define LOCK lock
-#endif
-
-#define SYS_futex		202
-#define FUTEX_WAIT		0
-#define FUTEX_WAKE		1
-#define FUTEX_WAKE_OP		5
-
-#define FUTEX_OP_CLEAR_WAKE_IF_GT_ONE	((4 << 24) | 1)
-
-#define EINVAL			22
-
-
-	.text
-
-	/* int pthread_cond_signal (pthread_cond_t *cond) */
-	.globl	__pthread_cond_signal
-	.type	__pthread_cond_signal, @function
-	.align	16
-__pthread_cond_signal:
-
-	/* Get internal lock.  */
-	movq	%rdi, %r8
-	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jnz	1f
-
-2:	addq	$cond_futex, %rdi
-	movq	total_seq(%r8), %rcx
-	cmpq	wakeup_seq(%r8), %rcx
-	jbe	4f
-
-	/* Bump the wakeup number.  */
-	addq	$1, wakeup_seq(%r8)
-	addl	$1, (%rdi)
-
-	/* Wake up one thread.  */
-	movl	$FUTEX_WAKE_OP, %esi
-	movl	$SYS_futex, %eax
-	movl	$1, %edx
-	movl	$1, %r10d
-#if cond_lock != 0
-	addq	$cond_lock, %r8
-#endif
-	movl	$FUTEX_OP_CLEAR_WAKE_IF_GT_ONE, %r9d
-	syscall
-#if cond_lock != 0
-	subq	$cond_lock, %r8
-#endif
-	/* For any kind of error, we try again with WAKE.
-	   The general test also covers running on old kernels.  */
-	cmpq	$-4095, %rax
-	jae	7f
-
-	xorl	%eax, %eax
-	retq
-
-7:	movl	$FUTEX_WAKE, %esi
-	movl	$SYS_futex, %eax
-	/* %rdx should be 1 already from $FUTEX_WAKE_OP syscall.
-	movl	$1, %edx  */
-	syscall
-
-	/* Unlock.  */
-4:	LOCK
-#if cond_lock == 0
-	decl	(%r8)
-#else
-	decl	cond_lock(%r8)
-#endif
-	jne	5f
-
-6:	xorl	%eax, %eax
-	retq
-
-	/* Initial locking failed.  */
-1:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-#if cond_lock != 0
-	subq	$cond_lock, %rdi
-#endif
-	jmp	2b
-
-	/* Unlock in loop requires wakeup.  */
-5:
-	movq	%r8, %rdi
-	callq	__lll_mutex_unlock_wake
-	jmp	6b
-	.size	__pthread_cond_signal, .-__pthread_cond_signal
-versioned_symbol (libpthread, __pthread_cond_signal, pthread_cond_signal,
-		  GLIBC_2_3_2)
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_timedwait.S glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_timedwait.S
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_timedwait.S	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_timedwait.S	1970-01-01 05:30:00.000000000 +0530
@@ -1,470 +0,0 @@
-/* Copyright (C) 2002, 2003, 2004, 2005 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-   Contributed by Ulrich Drepper <drepper@redhat.com>, 2002.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, write to the Free
-   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-   02111-1307 USA.  */
-
-#include <sysdep.h>
-#include <shlib-compat.h>
-#include <lowlevelcond.h>
-#include <pthread-errnos.h>
-
-#ifdef UP
-# define LOCK
-#else
-# define LOCK lock
-#endif
-
-#define SYS_futex		202
-#define FUTEX_WAIT		0
-#define FUTEX_WAKE		1
-
-/* For the calculation see asm/vsyscall.h.  */
-#define VSYSCALL_ADDR_vgettimeofday	0xffffffffff600000
-
-
-	.text
-
-/* int pthread_cond_timedwait (pthread_cond_t *cond, pthread_mutex_t *mutex,
-			       const struct timespec *abstime)  */
-	.globl	__pthread_cond_timedwait
-	.type	__pthread_cond_timedwait, @function
-	.align	16
-__pthread_cond_timedwait:
-.LSTARTCODE:
-	pushq	%r12
-.Lpush_r12:
-	pushq	%r13
-.Lpush_r13:
-	pushq	%r14
-.Lpush_r14:
-#define FRAME_SIZE 80
-	subq	$FRAME_SIZE, %rsp
-.Lsubq:
-
-	cmpq	$1000000000, 8(%rdx)
-	movl	$EINVAL, %eax
-	jae	18f
-
-	/* Stack frame:
-
-	   rsp + 80
-	            +--------------------------+
-	   rsp + 48 | cleanup buffer           |
-	            +--------------------------+
-	   rsp + 40 | old wake_seq value       |
-	            +--------------------------+
-	   rsp + 24 | timeout value            |
-	            +--------------------------+
-	   rsp + 16 | mutex pointer            |
-	            +--------------------------+
-	   rsp +  8 | condvar pointer          |
-	            +--------------------------+
-	   rsp +  4 | old broadcast_seq value  |
-	            +--------------------------+
-	   rsp +  0 | old cancellation mode    |
-	            +--------------------------+
-	*/
-
-	cmpq	$-1, dep_mutex(%rdi)
-
-	/* Prepare structure passed to cancellation handler.  */
-	movq	%rdi, 8(%rsp)
-	movq	%rsi, 16(%rsp)
-	movq	%rdx, %r13
-
-	je	22f
-	movq	%rsi, dep_mutex(%rdi)
-
-	/* Get internal lock.  */
-22:	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jnz	1f
-
-	/* Unlock the mutex.  */
-2:	movq	16(%rsp), %rdi
-	xorl	%esi, %esi
-	callq	__pthread_mutex_unlock_usercnt
-
-	testl	%eax, %eax
-	jne	16f
-
-	movq	8(%rsp), %rdi
-	incq	total_seq(%rdi)
-	incl	cond_futex(%rdi)
-	addl	$(1 << clock_bits), cond_nwaiters(%rdi)
-
-	/* Install cancellation handler.  */
-#ifdef PIC
-	leaq	__condvar_cleanup(%rip), %rsi
-#else
-	leaq	__condvar_cleanup, %rsi
-#endif
-	leaq	48(%rsp), %rdi
-	movq	%rsp, %rdx
-	callq	__pthread_cleanup_push
-
-	/* Get and store current wakeup_seq value.  */
-	movq	8(%rsp), %rdi
-	movq	wakeup_seq(%rdi), %r9
-	movl	broadcast_seq(%rdi), %edx
-	movq	%r9, 40(%rsp)
-	movl	%edx, 4(%rsp)
-
-	/* Get the current time.  */
-8:
-#ifdef __NR_clock_gettime
-	/* Get the clock number.  Note that the field in the condvar
-	   structure stores the number minus 1.  */
-	movq	8(%rsp), %rdi
-	movl	cond_nwaiters(%rdi), %edi
-	andl	$((1 << clock_bits) - 1), %edi
-	/* Only clocks 0 and 1 are allowed so far.  Both are handled in the
-	   kernel.  */
-	leaq	24(%rsp), %rsi
-	movl	$__NR_clock_gettime, %eax
-	syscall
-# ifndef __ASSUME_POSIX_TIMERS
-	cmpq	$-ENOSYS, %rax
-	je	19f
-# endif
-
-	/* Compute relative timeout.  */
-	movq	(%r13), %rcx
-	movq	8(%r13), %rdx
-	subq	24(%rsp), %rcx
-	subq	32(%rsp), %rdx
-#else
-	leaq	24(%rsp), %rdi
-	xorl	%esi, %esi
-	movq	$VSYSCALL_ADDR_vgettimeofday, %rax
-	callq	*%rax
-
-	/* Compute relative timeout.  */
-	movq	32(%rsp), %rax
-	movl	$1000, %edx
-	mul	%rdx		/* Milli seconds to nano seconds.  */
-	movq	(%r13), %rcx
-	movq	8(%r13), %rdx
-	subq	24(%rsp), %rcx
-	subq	%rax, %rdx
-#endif
-	jns	12f
-	addq	$1000000000, %rdx
-	decq	%rcx
-12:	testq	%rcx, %rcx
-	movq	8(%rsp), %rdi
-	movq	$-ETIMEDOUT, %r14
-	js	6f
-
-	/* Store relative timeout.  */
-21:	movq	%rcx, 24(%rsp)
-	movq	%rdx, 32(%rsp)
-
-	movl	cond_futex(%rdi), %r12d
-
-	/* Unlock.  */
-	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	3f
-
-4:	callq	__pthread_enable_asynccancel
-	movl	%eax, (%rsp)
-
-	leaq	24(%rsp), %r10
-#if FUTEX_WAIT == 0
-	xorl	%esi, %esi
-#else
-	movl	$FUTEX_WAIT, %esi
-#endif
-	movq	%r12, %rdx
-	addq	$cond_futex, %rdi
-	movl	$SYS_futex, %eax
-	syscall
-	movq	%rax, %r14
-
-	movl	(%rsp), %edi
-	callq	__pthread_disable_asynccancel
-
-	/* Lock.  */
-	movq	8(%rsp), %rdi
-	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jne	5f
-
-6:	movl	broadcast_seq(%rdi), %edx
-
-	movq	woken_seq(%rdi), %rax
-
-	movq	wakeup_seq(%rdi), %r9
-
-	cmpl	4(%rsp), %edx
-	jne	23f
-
-	cmpq	40(%rsp), %r9
-	jbe	15f
-
-	cmpq	%rax, %r9
-	ja	9f
-
-15:	cmpq	$-ETIMEDOUT, %r14
-	jne	8b
-
-13:	incq	wakeup_seq(%rdi)
-	incl	cond_futex(%rdi)
-	movl	$ETIMEDOUT, %r14d
-	jmp	14f
-
-23:	xorq	%r14, %r14
-	jmp	24f
-
-9:	xorq	%r14, %r14
-14:	incq	woken_seq(%rdi)
-
-24:	subl	$(1 << clock_bits), cond_nwaiters(%rdi)
-
-	/* Wake up a thread which wants to destroy the condvar object.  */
-	cmpq	$0xffffffffffffffff, total_seq(%rdi)
-	jne	25f
-	movl	cond_nwaiters(%rdi), %eax
-	andl	$~((1 << clock_bits) - 1), %eax
-	jne	25f
-
-	addq	$cond_nwaiters, %rdi
-	movl	$SYS_futex, %eax
-	movl	$FUTEX_WAKE, %esi
-	movl	$1, %edx
-	syscall
-	subq	$cond_nwaiters, %rdi
-
-25:	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	10f
-
-	/* Remove cancellation handler.  */
-11:	movq	48+CLEANUP_PREV(%rsp), %rdx
-	movq	%rdx, %fs:CLEANUP
-
-	movq	16(%rsp), %rdi
-	callq	__pthread_mutex_cond_lock
-
-	testq	%rax, %rax
-	cmoveq	%r14, %rax
-
-18:	addq	$FRAME_SIZE, %rsp
-.Laddq:
-	popq	%r14
-.Lpop_r14:
-	popq	%r13
-.Lpop_r13:
-	popq	%r12
-.Lpop_r12:
-
-	retq
-
-	/* Initial locking failed.  */
-1:
-.LSbl1:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-	jmp	2b
-
-	/* Unlock in loop requires wakeup.  */
-3:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-	jmp	4b
-
-	/* Locking in loop failed.  */
-5:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-#if cond_lock != 0
-	subq	$cond_lock, %rdi
-#endif
-	jmp	6b
-
-	/* Unlock after loop requires wakeup.  */
-10:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-	jmp	11b
-
-	/* The initial unlocking of the mutex failed.  */
-16:	movq	8(%rsp), %rdi
-	movq	%rax, (%rsp)
-	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	17f
-
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-
-17:	movq	(%rsp), %rax
-	jmp	18b
-
-#if defined __NR_clock_gettime && !defined __ASSUME_POSIX_TIMERS
-	/* clock_gettime not available.  */
-19:	leaq	24(%rsp), %rdi
-	xorl	%esi, %esi
-	movq	$VSYSCALL_ADDR_vgettimeofday, %rax
-	callq	*%rax
-
-	/* Compute relative timeout.  */
-	movq	32(%rsp), %rax
-	movl	$1000, %edx
-	mul	%rdx		/* Milli seconds to nano seconds.  */
-	movq	(%r13), %rcx
-	movq	8(%r13), %rdx
-	subq	24(%rsp), %rcx
-	subq	%rax, %rdx
-	jns	20f
-	addq	$1000000000, %rdx
-	decq	%rcx
-20:	testq	%rcx, %rcx
-	movq	8(%rsp), %rdi
-	movq	$-ETIMEDOUT, %r14
-	js	6b
-	jmp	21b
-#endif
-.LENDCODE:
-	.size	__pthread_cond_timedwait, .-__pthread_cond_timedwait
-versioned_symbol (libpthread, __pthread_cond_timedwait, pthread_cond_timedwait,
-		  GLIBC_2_3_2)
-
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAME:
-	.long	L(ENDCIE)-L(STARTCIE)		# Length of the CIE.
-.LSTARTCIE:
-	.long	0				# CIE ID.
-	.byte	1				# Version number.
-#ifdef SHARED
-	.string	"zR"				# NUL-terminated augmentation
-						# string.
-#else
-	.ascii	"\0"				# NUL-terminated augmentation
-						# string.
-#endif
-	.uleb128 1				# Code alignment factor.
-	.sleb128 -8				# Data alignment factor.
-	.byte	16				# Return address register
-						# column.
-#ifdef SHARED
-	.uleb128 1				# Augmentation value length.
-	.byte	0x1b				# Encoding: DW_EH_PE_pcrel
-						# + DW_EH_PE_sdata4.
-#endif
-	.byte 0x0c				# DW_CFA_def_cfa
-	.uleb128 7
-	.uleb128 8
-	.byte	0x90				# DW_CFA_offset, column 0x8
-	.uleb128 1
-	.align 8
-.LENDCIE:
-
-	.long	.LENDFDE-.LSTARTFDE		# Length of the FDE.
-.LSTARTFDE:
-	.long	.LSTARTFDE-.LSTARTFRAME		# CIE pointer.
-#ifdef SHARED
-	.long	.LSTARTCODE-.			# PC-relative start address
-						# of the code
-#else
-	.long	.LSTARTCODE			# Start address of the code.
-#endif
-	.long	.LENDCODE-.LSTARTCODE		# Length of the code.
-#ifdef SHARED
-	.uleb128 0				# No augmentation data.
-#endif
-	.byte	0x40+.Lpush_r12-.LSTARTCODE	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 16
-	.byte	0x8c				# DW_CFA_offset %r12
-	.uleb128 2
-	.byte	0x40+.Lpush_r13-.Lpush_r12	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 24
-	.byte	0x8d				# DW_CFA_offset %r13
-	.uleb128 3
-	.byte	0x40+.Lpush_r14-.Lpush_r13	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 32
-	.byte	0x84				# DW_CFA_offset %r14
-	.uleb128 4
-	.byte	0x40+.Lsubq-.Lpush_r14		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 32+FRAME_SIZE
-	.byte	3				# DW_CFA_advance_loc2
-	.2byte	.Laddq-.Lsubq
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 32
-	.byte	0x40+.Lpop_r14-.Laddq		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 24
-	.byte	0xce				# DW_CFA_restore %r14
-	.byte	0x40+.Lpop_r13-.Lpop_r14	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 16
-	.byte	0xcd				# DW_CFA_restore %r13
-	.byte	0x40+.Lpop_r12-.Lpop_r13	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 8
-	.byte	0xcc				# DW_CFA_restore %r12
-	.byte	0x40+.LSbl1-.Lpop_r12		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 32+FRAME_SIZE
-	.byte	0x8c				# DW_CFA_offset %r12
-	.uleb128 2
-	.byte	0x8d				# DW_CFA_offset %r13
-	.uleb128 3
-	.byte	0x84				# DW_CFA_offset %r14
-	.uleb128 4
-	.align	8
-.LENDFDE:
diff -uprN glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S
--- glibc-2.5-20061008T1257_org/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S	2009-01-19 13:52:14.000000000 +0530
+++ glibc-2.5-20061008T1257/nptl/sysdeps/unix/sysv/linux/x86_64/pthread_cond_wait.S	1970-01-01 05:30:00.000000000 +0530
@@ -1,429 +0,0 @@
-/* Copyright (C) 2002, 2003, 2004, 2005, 2006 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-   Contributed by Ulrich Drepper <drepper@redhat.com>, 2002.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Lesser General Public License for more details.
-
-   You should have received a copy of the GNU Lesser General Public
-   License along with the GNU C Library; if not, write to the Free
-   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
-   02111-1307 USA.  */
-
-#include <sysdep.h>
-#include <shlib-compat.h>
-#include <lowlevelcond.h>
-#include <tcb-offsets.h>
-
-#ifdef UP
-# define LOCK
-#else
-# define LOCK lock
-#endif
-
-#define SYS_futex		202
-#define FUTEX_WAIT		0
-#define FUTEX_WAKE		1
-
-
-	.text
-
-	.align	16
-	.type	__condvar_cleanup, @function
-	.globl	__condvar_cleanup
-	.hidden	__condvar_cleanup
-__condvar_cleanup:
-	pushq	%r12
-
-	/* Get internal lock.  */
-	movq	%rdi, %r8
-	movq	8(%rdi), %rdi
-	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jz	1f
-
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-#if cond_lock != 0
-	subq	$cond_lock, %rdi
-#endif
-
-1:	movl	broadcast_seq(%rdi), %edx
-	cmpl	4(%r8), %edx
-	jne	3f
-
-	/* We increment the wakeup_seq counter only if it is lower than
-	   total_seq.  If this is not the case the thread was woken and
-	   then canceled.  In this case we ignore the signal.  */
-	movq	total_seq(%rdi), %rax
-	cmpq	wakeup_seq(%rdi), %rax
-	jbe	6f
-	incq	wakeup_seq(%rdi)
-	incl	cond_futex(%rdi)
-6:	incq	woken_seq(%rdi)
-
-3:	subl	$(1 << clock_bits), cond_nwaiters(%rdi)
-
-	/* Wake up a thread which wants to destroy the condvar object.  */
-	xorq	%r12, %r12
-	cmpq	$0xffffffffffffffff, total_seq(%rdi)
-	jne	4f
-	movl	cond_nwaiters(%rdi), %eax
-	andl	$~((1 << clock_bits) - 1), %eax
-	jne	4f
-
-	addq	$cond_nwaiters, %rdi
-	movl	$SYS_futex, %eax
-	movl	$FUTEX_WAKE, %esi
-	movl	$1, %edx
-	syscall
-	subq	$cond_nwaiters, %rdi
-	movl	$1, %r12d
-
-4:	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	je	2f
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-
-	/* Wake up all waiters to make sure no signal gets lost.  */
-2:	testq	%r12, %r12
-	jnz	5f
-	addq	$cond_futex, %rdi
-	movl	$FUTEX_WAKE, %esi
-	movl	$0x7fffffff, %edx
-	movl	$SYS_futex, %eax
-	syscall
-
-5:	movq	16(%r8), %rdi
-	callq	__pthread_mutex_cond_lock
-
-	popq	%r12
-
-	retq
-	.size	__condvar_cleanup, .-__condvar_cleanup
-
-
-/* int pthread_cond_wait (pthread_cond_t *cond, pthread_mutex_t *mutex)  */
-	.globl	__pthread_cond_wait
-	.type	__pthread_cond_wait, @function
-	.align	16
-__pthread_cond_wait:
-.LSTARTCODE:
-	pushq	%r12
-.Lpush_r12:
-#define FRAME_SIZE 64
-	subq	$FRAME_SIZE, %rsp
-.Lsubq:
-	/* Stack frame:
-
-	   rsp + 64
-	            +--------------------------+
-	   rsp + 32 | cleanup buffer           |
-		    +--------------------------+
-	   rsp + 24 | old wake_seq value       |
-	            +--------------------------+
-	   rsp + 16 | mutex pointer            |
-	            +--------------------------+
-	   rsp +  8 | condvar pointer          |
-	            +--------------------------+
-	   rsp +  4 | old broadcast_seq value  |
-	            +--------------------------+
-	   rsp +  0 | old cancellation mode    |
-	            +--------------------------+
-	*/
-
-	cmpq	$-1, dep_mutex(%rdi)
-
-		/* Prepare structure passed to cancellation handler.  */
-	movq	%rdi, 8(%rsp)
-	movq	%rsi, 16(%rsp)
-
-	je	15f
-	movq	%rsi, dep_mutex(%rdi)
-
-	/* Get internal lock.  */
-15:	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jne	1f
-
-	/* Unlock the mutex.  */
-2:	movq	16(%rsp), %rdi
-	xorl	%esi, %esi
-	callq	__pthread_mutex_unlock_usercnt
-
-	testl	%eax, %eax
-	jne	12f
-
-	movq	8(%rsp), %rdi
-	incq	total_seq(%rdi)
-	incl	cond_futex(%rdi)
-	addl	$(1 << clock_bits), cond_nwaiters(%rdi)
-
-	/* Install cancellation handler.  */
-#ifdef PIC
-	leaq	__condvar_cleanup(%rip), %rsi
-#else
-	leaq	__condvar_cleanup, %rsi
-#endif
-	leaq	32(%rsp), %rdi
-	movq	%rsp, %rdx
-	callq	__pthread_cleanup_push
-
-	/* Get and store current wakeup_seq value.  */
-	movq	8(%rsp), %rdi
-	movq	wakeup_seq(%rdi), %r9
-	movl	broadcast_seq(%rdi), %edx
-	movq	%r9, 24(%rsp)
-	movl	%edx, 4(%rsp)
-
-	/* Unlock.  */
-8:	movl	cond_futex(%rdi), %r12d
-	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	3f
-
-4:	callq	__pthread_enable_asynccancel
-	movl	%eax, (%rsp)
-
-	movq	8(%rsp), %rdi
-	xorq	%r10, %r10
-	movq	%r12, %rdx
-	addq	$cond_futex-cond_lock, %rdi
-	movl	$SYS_futex, %eax
-#if FUTEX_WAIT == 0
-	xorl	%esi, %esi
-#else
-	movl	$FUTEX_WAIT, %esi
-#endif
-	syscall
-
-	movl	(%rsp), %edi
-	callq	__pthread_disable_asynccancel
-
-	/* Lock.  */
-	movq	8(%rsp), %rdi
-	movl	$1, %esi
-	xorl	%eax, %eax
-	LOCK
-#if cond_lock == 0
-	cmpxchgl %esi, (%rdi)
-#else
-	cmpxchgl %esi, cond_lock(%rdi)
-#endif
-	jnz	5f
-
-6:	movl	broadcast_seq(%rdi), %edx
-
-	movq	woken_seq(%rdi), %rax
-
-	movq	wakeup_seq(%rdi), %r9
-
-	cmpl	4(%rsp), %edx
-	jne	16f
-
-	cmpq	24(%rsp), %r9
-	jbe	8b
-
-	cmpq	%rax, %r9
-	jna	8b
-
-	incq	woken_seq(%rdi)
-
-	/* Unlock */
-16:	subl	$(1 << clock_bits), cond_nwaiters(%rdi)
-
-	/* Wake up a thread which wants to destroy the condvar object.  */
-	cmpq	$0xffffffffffffffff, total_seq(%rdi)
-	jne	17f
-	movl	cond_nwaiters(%rdi), %eax
-	andl	$~((1 << clock_bits) - 1), %eax
-	jne	17f
-
-	addq	$cond_nwaiters, %rdi
-	movl	$SYS_futex, %eax
-	movl	$FUTEX_WAKE, %esi
-	movl	$1, %edx
-	syscall
-	subq	$cond_nwaiters, %rdi
-
-17:	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	10f
-
-	/* Remove cancellation handler.  */
-11:	movq	32+CLEANUP_PREV(%rsp), %rdx
-	movq	%rdx, %fs:CLEANUP
-
-	movq	16(%rsp), %rdi
-	callq	__pthread_mutex_cond_lock
-14:	addq	$FRAME_SIZE, %rsp
-.Laddq:
-
-	popq	%r12
-.Lpop_r12:
-
-	/* We return the result of the mutex_lock operation.  */
-	retq
-
-	/* Initial locking failed.  */
-1:
-.LSbl1:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-	jmp	2b
-
-	/* Unlock in loop requires wakeup.  */
-3:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-	jmp	4b
-
-	/* Locking in loop failed.  */
-5:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_lock_wait
-#if cond_lock != 0
-	subq	$cond_lock, %rdi
-#endif
-	jmp	6b
-
-	/* Unlock after loop requires wakeup.  */
-10:
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-	jmp	11b
-
-	/* The initial unlocking of the mutex failed.  */
-12:	movq	%rax, %r10
-	movq	8(%rsp), %rdi
-	LOCK
-#if cond_lock == 0
-	decl	(%rdi)
-#else
-	decl	cond_lock(%rdi)
-#endif
-	jne	13f
-
-#if cond_lock != 0
-	addq	$cond_lock, %rdi
-#endif
-	callq	__lll_mutex_unlock_wake
-
-13:	movq	%r10, %rax
-	jmp	14b
-.LENDCODE:
-	.size	__pthread_cond_wait, .-__pthread_cond_wait
-versioned_symbol (libpthread, __pthread_cond_wait, pthread_cond_wait,
-		  GLIBC_2_3_2)
-
-
-	.section .eh_frame,"a",@progbits
-.LSTARTFRAME:
-	.long	L(ENDCIE)-L(STARTCIE)		# Length of the CIE.
-.LSTARTCIE:
-	.long	0				# CIE ID.
-	.byte	1				# Version number.
-#ifdef SHARED
-	.string	"zR"				# NUL-terminated augmentation
-						# string.
-#else
-	.ascii	"\0"				# NUL-terminated augmentation
-						# string.
-#endif
-	.uleb128 1				# Code alignment factor.
-	.sleb128 -8				# Data alignment factor.
-	.byte	16				# Return address register
-						# column.
-#ifdef SHARED
-	.uleb128 1				# Augmentation value length.
-	.byte	0x1b				# Encoding: DW_EH_PE_pcrel
-						# + DW_EH_PE_sdata4.
-#endif
-	.byte 0x0c				# DW_CFA_def_cfa
-	.uleb128 7
-	.uleb128 8
-	.byte	0x90				# DW_CFA_offset, column 0x8
-	.uleb128 1
-	.align 8
-.LENDCIE:
-
-	.long	.LENDFDE-.LSTARTFDE		# Length of the FDE.
-.LSTARTFDE:
-	.long	.LSTARTFDE-.LSTARTFRAME		# CIE pointer.
-#ifdef SHARED
-	.long	.LSTARTCODE-.			# PC-relative start address
-						# of the code
-#else
-	.long	.LSTARTCODE			# Start address of the code.
-#endif
-	.long	.LENDCODE-.LSTARTCODE		# Length of the code.
-#ifdef SHARED
-	.uleb128 0				# No augmentation data.
-#endif
-	.byte	0x40+.Lpush_r12-.LSTARTCODE	# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 16
-	.byte	0x8c				# DW_CFA_offset %r12
-	.uleb128 2
-	.byte	0x40+.Lsubq-.Lpush_r12		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 16+FRAME_SIZE
-	.byte	3				# DW_CFA_advance_loc2
-	.2byte	.Laddq-.Lsubq
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 16
-	.byte	0x40+.Lpop_r12-.Laddq		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 8
-	.byte	0xcc				# DW_CFA_restore %r12
-	.byte	0x40+.LSbl1-.Lpop_r12		# DW_CFA_advance_loc+N
-	.byte	14				# DW_CFA_def_cfa_offset
-	.uleb128 80
-	.byte	0x8c				# DW_CFA_offset %r12
-	.uleb128 2
-	.align	8
-.LENDFDE:

--------------060306000605070902060600--
