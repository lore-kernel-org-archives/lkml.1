Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZHICmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZHICmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 22:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZHICmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 22:42:44 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:53434 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZHICmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 22:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ph3fwWpTyxxbfXmGIhX2Vi4PwRcCkCRCwh1ZTsQd8Rr5qes/8WENsXlekx89C7s8Ke
         V1b3FXGJp7R6QxGSn7WQlAhyD+qqrUlNF8ma1pdcnUquRhNIazecM2Z7R63vjk2GFCuv
         sw6uQO1NG7KZLtl7cbSdHmPAdFyuFGpwy2BWo=
Date: Sun, 9 Aug 2009 04:42:37 +0200
From: Frederic Weisbecker <fweisbec@GMAIL.COM>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf tools: callchain: Fix sum of
	percentages to be 100% by displaying amount of ignored chains in
	fractal mode
Message-ID: <20090809024235.GA10146@nowhere>
References: <1249690585-9145-4-git-send-email-fweisbec@gmail.com> <tip-84fce09c6b21ef675de079a724c13a205c89520b@git.kernel.org> <20090808122923.GA20064@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808122923.GA20064@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 02:29:23PM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Commit-ID:  84fce09c6b21ef675de079a724c13a205c89520b
> > Gitweb:     http://git.kernel.org/tip/84fce09c6b21ef675de079a724c13a205c89520b
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Sat, 8 Aug 2009 02:16:25 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 8 Aug 2009 13:49:21 +0200
> > 
> > perf tools: callchain: Fix sum of percentages to be 100% by displaying amount of ignored chains in fractal mode
> > 
> > When we filter the callchains below a given percentage, we
> > ignore them and the end result only shows entries that have an
> > upper percentage than the filter threshold.
> > 
> > It seems to users then that we have an imbalance in the
> > percentage, as if the sum inside a profiled branch doesn't
> > reach 100%.
> > 
> > Since in the past there have been real perf report bugs that
> > showed the same sypmtom, it would be nice to assure the user
> > that the data is perfect and trustable and it all sums up to
> > 100.00%.
> > 
> > So fix this by displaying the remaining hits that have been
> > filtered but without more detail than their amount in each
> > branches. Example while filtering below 50%:
> > 
> > 7.73%  [k] delay_tsc
> >                 |
> >                 |--98.22%-- __const_udelay
> >                 |          |
> >                 |          |--86.37%-- ath5k_hw_register_timeout
> >                 |          |          ath5k_hw_noise_floor_calibration
> >                 |          |          ath5k_hw_reset
> >                 |          |          ath5k_reset
> >                 |          |          ath5k_config
> >                 |          |          ieee80211_hw_config
> >                 |          |          |
> >                 |          |          |--88.53%-- ieee80211_scan_work
> >                 |          |          |          worker_thread
> >                 |          |          |          kthread
> >                 |          |          |          child_rip
> >                 |          |           --11.47%-- [...]
> >                 |           --13.63%-- [...]
> >                  --1.78%-- [...]
> 
> i dont seem to be able to get the bracketed numbers. I only get:
> 
>   titan:~> perf record -f -g -a ./hackbench 10
>   titan:~> perf report -g fractal,10.0
> 
> # Samples: 26832
> #
> # Overhead         Command             Shared Object  Symbol
> # ........  ..............  ........................  ......
> #
>      8.69%       hackbench  [kernel]                  [k] copy_user_generic_string
> 
>      6.84%       hackbench  [kernel]                  [k] unix_stream_recvmsg
> 
>      6.07%       hackbench  [kernel]                  [k] sock_alloc_send_pskb
> 
>      4.33%       hackbench  [kernel]                  [k] _spin_lock
> 
>      3.77%       hackbench  [kernel]                  [k] __kmalloc_node_track_caller
> 
>      3.74%       hackbench  [kernel]                  [k] __alloc_skb
>                 |          
>                 |--80.00%-- sock_alloc_send_pskb
>                 |          sock_alloc_send_skb
>                 |          unix_stream_sendmsg
>                 |          __sock_sendmsg
>                 |          sock_aio_write
>                 |          do_sync_write
>                 |          vfs_write
>                 |          sys_write
>                 |          sysenter_dispatch
>                 |          0xf7ffa430
>                 |          0xffadeb0000000014
>                 |          
>                  --20.00%-- sock_alloc_send_skb
>                            unix_stream_sendmsg
>                            __sock_sendmsg
>                            sock_aio_write
>                            do_sync_write
>                            vfs_write
>                            sys_write
>                            sysenter_dispatch
>                            0xf7ffa430
>                            0xffadeb0000000014
> 
>      3.53%       hackbench  [kernel]                  [k] ia32_sysenter_target
> 
>      2.92%       hackbench  [vdso]                    [.] 0x000000f7ffa430
>                 |          
>                 |--66.67%-- 0xf7ffa430
>                 |          0xffadeb0000000014
>                 |          
>                  --33.33%-- 0xf7ffa431
>                            0xffadeb0000000014
> 
>      2.56%       hackbench  [kernel]                  [k] virt_to_head_page
> 
>      2.37%       hackbench  [kernel]                  [k] kmem_cache_alloc_node
> 
>      2.33%       hackbench  [kernel]                  [k] _spin_lock_irqsave
>                 |          
>                 |--78.57%-- remove_wait_queue
>                 |          poll_freewait
>                 |          do_sys_poll
>                 |          sys_poll
>                 |          sysenter_dispatch
>                 |          0xf7ffa430
>                 |          0x1ffadea3c
>                 |          
>                 |--7.14%-- __up_read
>                 |          up_read
>                 |          do_page_fault
>                 |          page_fault
>                 |          0xf7ffa430
>                 |          0xa0df710000000a
>                 |          
>                 |--7.14%-- unix_stream_sendmsg
>                 |          __sock_sendmsg
>                 |          sock_aio_write
>                 |          do_sync_write
>                 |          vfs_write
>                 |          sys_write
>                 |          sysenter_dispatch
>                 |          0xf7ffa430
>                 |          0xffadeb0000000014
>                 |          
>                  --7.14%-- skb_queue_tail
>                            unix_stream_sendmsg
>                            __sock_sendmsg
>                            sock_aio_write
>                            do_sync_write
>                            vfs_write
>                            sys_write
>                            sysenter_dispatch
>                            0xf7ffa430
>                            0xffadeb0000000014
> 
> 
> I dont see the brackets anymore, nor does the 10% limit seem to have 
> been listened to for the 7.14% result above, right?
> 
> 	Ingo


Oh damn. I've been investigating for several hours in the wrong direction
just because this bug triggered only when I wasn't using -s s

Actually, it's just that the other kind of sorting make this bug occur
much more quickly: in the first results. It was then more obvious in these
cases, but the issue was present in every kind of sorting.

Please find the fix below, thanks!

Frederic.

---
>From 52c89279744db58a68fa2339b3c8038e67113fca Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 9 Aug 2009 04:19:15 +0200
Subject: [PATCH] perf tools: callchain: Fix bad rounding of minimum rate

Sometimes we get callchain branches that have a rate under the limit
given by the user.

Say you launched:

perf record -f -g -a ./hackbench 10
perf report -g fractal,10.0

And you get:

2.33%       hackbench  [kernel]                  [k] _spin_lock_irqsave
                |
                |--78.57%-- remove_wait_queue
                |          poll_freewait
                |          do_sys_poll
                |          sys_poll
                |          sysenter_dispatch
                |          0xf7ffa430
                |          0x1ffadea3c
                |
                |--7.14%-- __up_read
                |          up_read
                |          do_page_fault
                |          page_fault
                |          0xf7ffa430
                |          0xa0df710000000a
                ...

It is abnormal to get a 7.14% branch whereas we passed a 10% filter.

The problem is that we round down the minimum threshold.
This happens mostly when we have very low number of events.
If the total amount of your branch is 4 and you have a subranch of 3
events, filtering to 90% will be computed like follows:

limit = 4 * 0.9;

The result is about 3.6, but the cast to integer will round down to 3.
It means that our filter is actually of 75%

We must then explicitly round up the minimum threshold.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/callchain.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index a8e67aa..0114734 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <errno.h>
+#include <math.h>
 
 #include "callchain.h"
 
@@ -112,7 +113,7 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
-	min_hit = node->children_hit * min_percent / 100.0;
+	min_hit = ceil(node->children_hit * min_percent);
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
@@ -126,7 +127,7 @@ static void
 sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
 		     u64 min_hit __used, struct callchain_param *param)
 {
-	__sort_chain_graph_rel(chain_root, param->min_percent);
+	__sort_chain_graph_rel(chain_root, param->min_percent / 100.0);
 	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
-- 
1.6.2.3



