Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXKXKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXKXKx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 05:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXKXKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 05:53:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:41886 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXKXKxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 05:53:48 -0500
Date: Sat, 24 Nov 2007 13:53:43 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] debug_check_no_locks_freed: fix in_range() checks
Message-ID: <20071124105343.GA2044@tv-sign.ru>
References: <20071120234605.GG23667@elte.hu> <20071121155842.GA864@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121155842.GA864@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten, could you ack/nack this patch?

Torsten Kaiser wrote:
>
> static inline int in_range(const void *start, const void *addr, const void *end)
> {
>         return addr >= start && addr <= end;
> }
> This  will return true, if addr is in the range of start (including)
> to end (including).
>
> But debug_check_no_locks_freed() seems does:
> const void *mem_to = mem_from + mem_len
> -> mem_to is the last byte of the freed range, that fits in_range
> lock_from = (void *)hlock->instance;
> -> first byte of the lock
> lock_to = (void *)(hlock->instance + 1);
> -> first byte of the next lock, not last byte of the lock that is being checked!
>
> The test is:
> if (!in_range(mem_from, lock_from, mem_to) &&
>                                         !in_range(mem_from, lock_to, mem_to))
>                         continue;
> So it tests, if the first byte of the lock is in the range that is freed ->OK
> And if the first byte of the *next* lock is in the range that is freed
> -> Not OK.

We can also simplify in_range checks, we need only 2 comparisons, not 4.
If the lock is not in memory range, it should be either at the left of range
or at the right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 24/kernel/lockdep.c~	2007-11-09 12:57:31.000000000 +0300
+++ 24/kernel/lockdep.c	2007-11-24 13:32:52.000000000 +0300
@@ -3054,11 +3054,6 @@ void __init lockdep_info(void)
 #endif
 }
 
-static inline int in_range(const void *start, const void *addr, const void *end)
-{
-	return addr >= start && addr <= end;
-}
-
 static void
 print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 		     const void *mem_to, struct held_lock *hlock)
@@ -3080,6 +3075,13 @@ print_freed_lock_bug(struct task_struct 
 	dump_stack();
 }
 
+static inline int not_in_range(const void* mem_from, unsigned long mem_len,
+				const void* lock_from, unsigned long lock_len)
+{
+	return lock_from + lock_len <= mem_from ||
+		mem_from + mem_len <= lock_from;
+}
+
 /*
  * Called when kernel memory is freed (or unmapped), or if a lock
  * is destroyed or reinitialized - this code checks whether there is
@@ -3087,7 +3089,6 @@ print_freed_lock_bug(struct task_struct 
  */
 void debug_check_no_locks_freed(const void *mem_from, unsigned long mem_len)
 {
-	const void *mem_to = mem_from + mem_len, *lock_from, *lock_to;
 	struct task_struct *curr = current;
 	struct held_lock *hlock;
 	unsigned long flags;
@@ -3100,14 +3101,11 @@ void debug_check_no_locks_freed(const vo
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		hlock = curr->held_locks + i;
 
-		lock_from = (void *)hlock->instance;
-		lock_to = (void *)(hlock->instance + 1);
-
-		if (!in_range(mem_from, lock_from, mem_to) &&
-					!in_range(mem_from, lock_to, mem_to))
+		if (not_in_range(mem_from, mem_len, hlock->instance,
+					sizeof(*hlock->instance)))
 			continue;
 
-		print_freed_lock_bug(curr, mem_from, mem_to, hlock);
+		print_freed_lock_bug(curr, mem_from, mem_from + mem_len, hlock);
 		break;
 	}
 	local_irq_restore(flags);

