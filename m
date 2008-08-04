Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYHDMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYHDMWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYHDMWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:22:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60525 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYHDMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:22:06 -0400
Date: Mon, 4 Aug 2008 13:21:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
In-Reply-To: <20080803.011440.137037332.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0808041309390.21768@blonde.site>
References: <20080801092219.GA15691@elte.hu> <20080801.023214.117218567.davem@davemloft.net>
 <Pine.LNX.4.64.0808011246210.18137@blonde.site> <20080803.011440.137037332.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, David Miller wrote:
> 
> It's probably best to not later clear oops_in_progress when we trigger
> an event like this, to ensure that we do actually get any followon
> messages on the console.

Ah, so it was intentional that your patch set oops_in_progess without
ever clearing it again.  Hmm.  I think I'd reword your "probably best"
to "arguably best".  If everything really locks up at this point, then
there is no point to clearing oops_in_progress after; but if the system
manages to resume (arguably) normal operation after, then leaving it
forever oops_in_progess worries me, and differs from current practice.

I think I'd rather clear it afterwards in any public patch; but edit
that out privately if it helps while debugging some particular problem.
I did try to reproduce my spinlock lockups yesterday, but without
success, so have no practical experience one way or the other.

But notice that I shouldn't be messing directly with oops_in_progress:
better to use bust_spinlocks() (oops_in_progress++/-- and wake klogd).

[PATCH] bust_spinlocks while reporting spinlock lockup

Use bust_spinlocks() while reporting spinlock lockup to avoid deadlock
inside printk() or the backtraces.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 lib/spinlock_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.27-rc1/lib/spinlock_debug.c	2008-01-24 22:58:37.000000000 +0000
+++ linux/lib/spinlock_debug.c	2008-08-01 12:41:52.000000000 +0100
@@ -113,6 +113,7 @@ static void __spin_lock_debug(spinlock_t
 		/* lockup suspected: */
 		if (print_once) {
 			print_once = 0;
+			bust_spinlocks(1);
 			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
 					"%s/%d, %p\n",
 				raw_smp_processor_id(), current->comm,
@@ -121,6 +122,7 @@ static void __spin_lock_debug(spinlock_t
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
+			bust_spinlocks(0);
 		}
 	}
 }
