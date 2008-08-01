Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYHAL6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYHAL6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHAL57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:57:59 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39079 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYHAL56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:57:58 -0400
Date: Fri, 1 Aug 2008 12:57:27 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
In-Reply-To: <20080801.023214.117218567.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0808011246210.18137@blonde.site>
References: <20080729.214503.126934382.davem@davemloft.net>
 <20080731163943.GF26393@elte.hu> <20080801092219.GA15691@elte.hu>
 <20080801.023214.117218567.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, David Miller wrote:
> 
> I think a non-trivial number of people hit that printk deadlock bug,
> but just didn't report it because the machine essentially hard hangs
> silently.  At best you'd see the:
> 
> ========================================
> 
> initial line from lockdep, but often even that doesn't make it to the
> console.

Not just with lockdep.  A couple of months back CONFIG_DEBUG_SPINLOCK
was giving me spinlock debug messages under load on x86_64 duo laptop,
but hung up before showing the intended backtrace.  I added the patch
below, but IIRC shifted over to other issues (and switched from cfq to
anticipatory scheduler, which made a difference) before finding out if
this patch really helped.  If it makes sense to you, please add it in.

Hugh

[PATCH] set oops_in_progress for spinlock lockup

Set oops_in_progress while reporting spinlock lockup,
to avoid deadlock inside printk() or the backtraces.

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
+			oops_in_progress = 1;
 			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
 					"%s/%d, %p\n",
 				raw_smp_processor_id(), current->comm,
@@ -121,6 +122,7 @@ static void __spin_lock_debug(spinlock_t
 #ifdef CONFIG_SMP
 			trigger_all_cpu_backtrace();
 #endif
+			oops_in_progress = 0;
 		}
 	}
 }
