Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGAHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGAHxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZGAHxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:53:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37945 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAHxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:53:41 -0400
Date: Wed, 1 Jul 2009 09:53:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: git-commits-head@vger.kernel.org
Subject: [PATCH] kmemleak: Fix scheduling-while-atomic bug
Message-ID: <20090701075332.GA17252@elte.hu>
References: <200907010300.n6130rRf026194@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907010300.n6130rRf026194@hera.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/acf4968ec9dea49387ca8b3d36dfaa0850bdb2d5
> Commit:     acf4968ec9dea49387ca8b3d36dfaa0850bdb2d5
> Parent:     4698c1f2bbe44ce852ef1a6716973c1f5401a4c4
> Author:     Catalin Marinas <catalin.marinas@arm.com>
> AuthorDate: Fri Jun 26 17:38:29 2009 +0100
> Committer:  Catalin Marinas <catalin.marinas@arm.com>
> CommitDate: Fri Jun 26 17:38:29 2009 +0100
> 
>     kmemleak: Slightly change the policy on newly allocated objects

I think one of the kmemleak fixes that went upstream yesterday 
caused the following scheduling-while-holding-the-tasklist-lock 
regression/crash on x86:

BUG: sleeping function called from invalid context at mm/kmemleak.c:795
in_atomic(): 1, irqs_disabled(): 0, pid: 1737, name: kmemleak
2 locks held by kmemleak/1737:
 #0:  (scan_mutex){......}, at: [<c10c4376>] kmemleak_scan_thread+0x45/0x86
 #1:  (tasklist_lock){......}, at: [<c10c3bb4>] kmemleak_scan+0x1a9/0x39c
Pid: 1737, comm: kmemleak Not tainted 2.6.31-rc1-tip #59266
Call Trace:
 [<c105ac0f>] ? __debug_show_held_locks+0x1e/0x20
 [<c102e490>] __might_sleep+0x10a/0x111
 [<c10c38d5>] scan_yield+0x17/0x3b
 [<c10c3970>] scan_block+0x39/0xd4
 [<c10c3bc6>] kmemleak_scan+0x1bb/0x39c
 [<c10c4331>] ? kmemleak_scan_thread+0x0/0x86
 [<c10c437b>] kmemleak_scan_thread+0x4a/0x86
 [<c104d73e>] kthread+0x6e/0x73
 [<c104d6d0>] ? kthread+0x0/0x73
 [<c100959f>] kernel_thread_helper+0x7/0x10
kmemleak: 834 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

The bit causing it is highly dubious:

static void scan_yield(void)
{
        might_sleep();

        if (time_is_before_eq_jiffies(next_scan_yield)) {
                schedule();
                next_scan_yield = jiffies + jiffies_scan_yield;
        }
}

It is called deep inside the codepath and in a conditional way, and 
that is what crapped up when one of the new scan_block() uses grew a 
tasklist_lock dependency. Also, we dont need another 'yield' 
primitive in the MM code, we have priorities and other scheduling 
mechanisms to throttle background scanning just fine.

The minimal fix below removes scan_yield() and adds a cond_resched() 
to the outmost (safe) place of the scanning thread. This solves the 
regression.

	Ingo

----------------->

>From 5ba1a8143c502f40b976a0ea1df5e5a10056fcc6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 1 Jul 2009 09:43:53 +0200
Subject: [PATCH] kmemleak: Fix scheduling-while-atomic bug

One of the kmemleak changes caused the following 
scheduling-while-holding-the-tasklist-lock regression on x86:

BUG: sleeping function called from invalid context at mm/kmemleak.c:795
in_atomic(): 1, irqs_disabled(): 0, pid: 1737, name: kmemleak
2 locks held by kmemleak/1737:
 #0:  (scan_mutex){......}, at: [<c10c4376>] kmemleak_scan_thread+0x45/0x86
 #1:  (tasklist_lock){......}, at: [<c10c3bb4>] kmemleak_scan+0x1a9/0x39c
Pid: 1737, comm: kmemleak Not tainted 2.6.31-rc1-tip #59266
Call Trace:
 [<c105ac0f>] ? __debug_show_held_locks+0x1e/0x20
 [<c102e490>] __might_sleep+0x10a/0x111
 [<c10c38d5>] scan_yield+0x17/0x3b
 [<c10c3970>] scan_block+0x39/0xd4
 [<c10c3bc6>] kmemleak_scan+0x1bb/0x39c
 [<c10c4331>] ? kmemleak_scan_thread+0x0/0x86
 [<c10c437b>] kmemleak_scan_thread+0x4a/0x86
 [<c104d73e>] kthread+0x6e/0x73
 [<c104d6d0>] ? kthread+0x0/0x73
 [<c100959f>] kernel_thread_helper+0x7/0x10
kmemleak: 834 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

The bit causing it is highly dubious:

static void scan_yield(void)
{
        might_sleep();

        if (time_is_before_eq_jiffies(next_scan_yield)) {
                schedule();
                next_scan_yield = jiffies + jiffies_scan_yield;
        }
}

It called deep inside the codepath and in a conditional way,
and that is what crapped up when one of the new scan_block()
uses grew a tasklist_lock dependency.

This minimal patch removes that yielding stuff and adds the
proper cond_resched().

The background scanning thread could probably also be reniced
to +10.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/kmemleak.c |   31 +------------------------------
 1 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index eeece2d..e766e1d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -105,7 +105,6 @@
 #define MAX_TRACE		16	/* stack trace length */
 #define REPORTS_NR		50	/* maximum number of reported leaks */
 #define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
-#define MSECS_SCAN_YIELD	10	/* CPU yielding period */
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 
@@ -186,10 +185,7 @@ static atomic_t kmemleak_error = ATOMIC_INIT(0);
 static unsigned long min_addr = ULONG_MAX;
 static unsigned long max_addr;
 
-/* used for yielding the CPU to other tasks during scanning */
-static unsigned long next_scan_yield;
 static struct task_struct *scan_thread;
-static unsigned long jiffies_scan_yield;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
 static unsigned long jiffies_last_scan;
@@ -786,21 +782,6 @@ void kmemleak_no_scan(const void *ptr)
 EXPORT_SYMBOL(kmemleak_no_scan);
 
 /*
- * Yield the CPU so that other tasks get a chance to run.  The yielding is
- * rate-limited to avoid excessive number of calls to the schedule() function
- * during memory scanning.
- */
-static void scan_yield(void)
-{
-	might_sleep();
-
-	if (time_is_before_eq_jiffies(next_scan_yield)) {
-		schedule();
-		next_scan_yield = jiffies + jiffies_scan_yield;
-	}
-}
-
-/*
  * Memory scanning is a long process and it needs to be interruptable. This
  * function checks whether such interrupt condition occured.
  */
@@ -840,15 +821,6 @@ static void scan_block(void *_start, void *_end,
 		if (scan_should_stop())
 			break;
 
-		/*
-		 * When scanning a memory block with a corresponding
-		 * kmemleak_object, the CPU yielding is handled in the calling
-		 * code since it holds the object->lock to avoid the block
-		 * freeing.
-		 */
-		if (!scanned)
-			scan_yield();
-
 		object = find_and_get_object(pointer, 1);
 		if (!object)
 			continue;
@@ -1014,7 +986,7 @@ static void kmemleak_scan(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		scan_yield();
+		cond_resched();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1385,7 +1357,6 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	jiffies_scan_yield = msecs_to_jiffies(MSECS_SCAN_YIELD);
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
