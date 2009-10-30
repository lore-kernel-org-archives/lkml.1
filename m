Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZJ3BT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZJ3BT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZJ3BTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:19:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44780 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZJ3BTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:19:24 -0400
Message-ID: <4AEA3F15.2070900@us.ibm.com>
Date: Thu, 29 Oct 2009 18:19:17 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com> <4AE63FA3.8040208@us.ibm.com> <200910290939.32485.arnd@arndb.de>
In-Reply-To: <200910290939.32485.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 27 October 2009, Darren Hart wrote:
>> The following C test case demonstrates how this patch could be used to
>> implement interruptible locking. There is an awful lot of debug code and
>> some other relics of a hacked together test in there now, but if anyone
>> wanted to test the futex changes, this will do the trick.
>>
> 
> Your test program uses a signal handler to interrupt the mutex. If you
> are using a signal handler already to implement a user space mutex_cancel,
> why can't you just do a longjmp out of the signal handler rather than
> modifying the kernel?

Interesting... so something like the following diff to the test case?

This works on an unmodfied kernel... although I certainly don't feel
like I understand what it's doing well enough to recommend someone use
this in conjunction with glibc pthread_mutexes and condvars. Seems like
their internal state could suffer from this sort of thing. Hrm... and
this warning in the man pages is worth heeding:

  setjmp() and sigsetjmp() make programs hard to understand and maintain.
  If possible an alternative should be used.

However, if that is the only concern, it's certainly worth risking to
avoid any further complication of the futex code (and glibc!). I'll take
a stab at a pure pthread_mutex implementation and see if anything breaks.
I also need to understand signal handling a bit better to decide if I need
the sigsetjmp and siglongjmp versions.

Thanks for the suggestion!

--
Darren


>From c4fb07a73f8ce6e7d137a7e42634dba819ac4b88 Mon Sep 17 00:00:00 2001
From: Darren Vincent Hart <darren@dvhart.com>
Date: Thu, 29 Oct 2009 18:11:32 -0700
Subject: [PATCH] longjmp implementation

---
 mutexint.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/mutexint.c b/mutexint.c
index 003717f..82a608b 100644
--- a/mutexint.c
+++ b/mutexint.c
@@ -37,6 +37,7 @@
 #include <sys/types.h>
 #include <linux/futex.h>
 #include <errno.h>
+#include <setjmp.h>
 
 /*
  * The futex() call has been removed from the include/futex.h header, implement
@@ -44,7 +45,8 @@
  */
 //#define SYS_futex 202
 #define FUTEX_PRIVATE 128
-#define FUTEX_INTERRUPTIBLE 512
+//#define FUTEX_INTERRUPTIBLE 512
+#define FUTEX_INTERRUPTIBLE 0
 #define futex(uaddr, op, val, timeout, uaddr2, val3) \
 	syscall(SYS_futex, uaddr, op, val, timeout, uaddr2, val3)
 
@@ -59,6 +61,9 @@
 
 #define SIGMUTEXINT SIGRTMIN
 
+/* Need some kind of per-thread variable here */
+jmp_buf env;
+
 /*
  * Implement cmpxchg using gcc atomic builtins.
  * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
@@ -80,6 +85,7 @@ struct mutexint_attr {
 void sigmutexint_handler(int signo)
 {
 	printf("handled cancel signal: %d\n", signo);
+	longjmp(env, 1);
 }
 
 int mutexint_init(struct mutexint *mutex, struct mutexint_attr *attr)
@@ -102,13 +108,18 @@ int mutexint_lock(struct mutexint *mutex)
 			if ((val & FUTEX_WAITERS) || 
 				(val = cmpxchg(&mutex->lock_val, val, val | FUTEX_WAITERS))) {
 				printf("\tinner cmpxchg old_val: 0x%x lock_val: 0x%x\n", val, mutex->lock_val);
-				printf("\tcalling futex_lock_pi:\n");
-				printf("\top: 0x%x\n", FUTEX_LOCK_PI | FUTEX_PRIVATE | FUTEX_INTERRUPTIBLE);
-				printf("\t&lock_val: %p\n", &mutex->lock_val);
-				ret = futex_lock_pi(&mutex->lock_val, val, NULL);
-				if (ret == -1) {
-					ret = -errno;
-					printf("futex_lock_pi returned -1, errno is %d\n", ret);
+				if (setjmp(env)) {
+					printf("mutexint_lock canceled, aborting\n");
+					ret = -EINTR;
+				} else {
+					printf("\tcalling futex_lock_pi:\n");
+					printf("\top: 0x%x\n", FUTEX_LOCK_PI | FUTEX_PRIVATE | FUTEX_INTERRUPTIBLE);
+					printf("\t&lock_val: %p\n", &mutex->lock_val);
+					ret = futex_lock_pi(&mutex->lock_val, val, NULL);
+					if (ret == -1) {
+						ret = -errno;
+						printf("futex_lock_pi returned -1, errno is %d\n", ret);
+					}
 				}
 				/*
 				 * If -EINTR is returned, the lock may no longer
-- 
1.6.0.4


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
