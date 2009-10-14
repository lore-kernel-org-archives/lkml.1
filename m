Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbZJNKai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbZJNKai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZJNKai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:30:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42863 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbZJNKag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:30:36 -0400
Date: Wed, 14 Oct 2009 11:30:02 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091014103002.GA5027@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091012134328.GB8200@csn.ul.ie> <200910121932.14607.elendil@planet.nl> <200910132238.40867.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200910132238.40867.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 10:38:37PM +0200, Frans Pop wrote:
> On Monday 12 October 2009, Frans Pop wrote:
> > On Monday 12 October 2009, Mel Gorman wrote:
> > > but after some digging around in this general area, I saw this patch
> > >
> > > 4752c93c30 iwlcore: Allow skb allocation from tasklet
> >
> > That is v2.6.30-rc6-773-g4752c93, which is part of the first wireless
> > merge I tested and where I saw no issues. But see below.
> >
> > > This patch increases the number of GFP_ATOMIC allocations that can
> > > occur by allocating GFP_ATOMIC in some cases and GFP_KERNEL in others.
> > > Previously, only GFP_KERNEL was used and I didn't realise this
> > > allocation method was so recent. Problems of this sort have cropped up
> > > before and while there are later changes that suppress some of these
> > > warnings, I believe this is a strong candidate for where the
> > > allocation failures started appearing.
> 
> I have tried reverting this patch and that does make a significant 
> difference, but the results are still not really conclusive.
> I tested the revert on top of:
> - the first net-next-2.6 merge (2ed0e21), i.e. before the mm merge
> - 2.6.31.1
> 

I think this is very significant. Either that change needs to be backed
out or more likely, __GFP_NOWARN needs to be specified and warnings
*only* printed when the RX buffers are really low. My expectation would
be that some GFP_ATOMIC allocations fail during refill but the fact they
fail wakes kswapd to reclaim order-2 pages while the RX buffers in the
pool are consumed.

> In both cases I no longer get SKB errors, but instead (?) I get firmware 
> errors:
> iwlagn 0000:10:00.0: Microcode SW error detected.  Restarting 0x2000000.
> 

I am no wireless expert, but that looks like an separate problem to me.
I don't see how an allocation failure could trigger errors in the
microcode.

I really really hate to say it, but this might need a separate bisection
with 4752c93c30 either reverted or patched as I do below.

> So on the wireless side it does look as if there is more than one change 
> involved. Remember that with .30 I don't get any errors, only relatively 
> mild latencies and skips in the music.
> 

2.6.31 does not appear to have done wireless any favours.

> > I really do think that v2.6.30-rc6-1032-g7ba10a8 could play a role here.
> > That's a fix for v2.6.30-rc1-1131-gaa837e1. So that bug was introduced
> > _before_ the merge 82d0481 and may thus well explain both the latencies
> > I saw _and_ why that merge tested without problems. And that would also
> > go a long way to explain my test results.
> > So I'm going to retest 82d0481 with 7ba10a8 cherry-picked on top.
>                          ^^^^^^^-- should be 45ea4ea
> 
> I've tried this but still don't get any SKB errors, so that bug does not 
> seem to make a difference.
> 
> > > > BISECTION of akpm (mm) MERGE
> > > > ----------------------------
> > > While I didn't spot anything too out of the ordinary here, they did
> > > occur shortly after a number of other page allocator related patches.
> > > One small thing I noticed there is that kswapd is getting woken up
> > > less now than it did previously. Generally, I wouldn't have expected
> > > it to make a difference but it's possible that kswapd is not being
> > > woken up to reclaim at a higher order than it was previously. I have a
> > > patch for this below. It'd be nice if you could apply it and see do
> > > fewer allocation failures occur on current mainline.
> >
> > I'll give that patch a try and report back.
> 
> With your patch on .32-rc4 I still get the SKB errors, so it does not seem 
> to help. The only change there may have been is that the desktop was 
> frozen longer than without the patch, but that is an impression, not a 
> hard fact.
> 

Actually, that's fairly interesting and I think justifies pushing the
patch. Direct reclaim can stall processes in a user-visible manner which kswapd
is meant to avoid in the majority of cases but is tricky to quantify without
instrumenting the kernel to measure direct reclaim frequency and latency (I
have WIP tracepoints for this but it's still a WIP). If you notice shorter
stalls with the patch applied, it means that kswapd really did need to be
informed of the problems.

> Although identifying the problem on the wireless side is important, I still 
> feel that tracing the mm change should have priority as it influences much 
> more than just iwlagn, as the other reports prove.
> 

There still has not been a mm-change identified that makes fragmentation
significantly worse. The majority of the wireless reports have been in this
driver and I think we have the problem commit there. The only other is a
firmware loading problem in e100 after resume that fails to make an atomic
order-5 fail. It's possible that something has changed in resume in the
2.6.31 window there - maybe something like drivers now reload during resume
where they didn't previously or less memory being pushed to swap during resume.

> > > After that, could you edit drivers/net/wireless/iwlwifi/iwl-rx.c and
> > > make the GFP_ATOMIC in iwl_rx_replenish_now() GFP_ATOMIC|__GFP_NOWARN
> > > and see do any of the "serious" allocation failure messages appear.
> 
> For the above reason I've not yet tried this. It seems to me that this 
> change will not really solve anything, but just suppress errors.
> 

I disagree. Harmless allocation errors get suppressed but it still warns when
things get really bad. See the following patch that suppresses the
warnings from GFP_ATOMIC but warns for GFP_KERNEL failures and dumps a
stack on serious allocation failure.

We either need a patch like this or the
GFP_ATOMIC-direct-with-refills-from-tasklet patch needs to be reverted.

=== CUT HERE ===
>From 5fb9f897117bf2701f9fdebe4d008dbe34358ab9 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Wed, 14 Oct 2009 11:19:57 +0100
Subject: [PATCH] iwlwifi: Suppress warnings related to GFP_ATOMIC allocations that do not matter

iwlwifi refills RX buffers in two ways - a direct method using GFP_ATOMIC
and a tasklet method using GFP_KERNEL. There are a number of RX buffers and
there are only serious issues when there are no RX buffers left. The driver
explicitly warns when refills are failing and the buffers are low but it
always warns when a GFP_ATOMIC allocation fails even when there is no
packet loss as a result.

This patch specifies __GFP_NOWARN for the direct refill method that uses
GFP_ATOMIC. To help identify where allocation failures might be coming
from, the stack is dumped when the RX queue is dangerously low.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 drivers/net/wireless/iwlwifi/iwl-rx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl b/Documentation/trace/postprocess/trace-pagealloc-postprocess.pl
old mode 100644
new mode 100755
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8e1bb53..f91a108 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -260,10 +260,12 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
-			    net_ratelimit())
+			    net_ratelimit()) {
 				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
 					 rxq->free_count);
+				dump_stack();
+			}
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
@@ -320,7 +322,7 @@ EXPORT_SYMBOL(iwl_rx_replenish);
 
 void iwl_rx_replenish_now(struct iwl_priv *priv)
 {
-	iwl_rx_allocate(priv, GFP_ATOMIC);
+	iwl_rx_allocate(priv, GFP_ATOMIC|__GFP_NOWARN);
 
 	iwl_rx_queue_restock(priv);
 }
