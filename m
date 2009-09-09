Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZIIQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZIIQzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZIIQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:55:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51874 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbZIIQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:55:41 -0400
Date: Wed, 9 Sep 2009 17:55:46 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090909165545.GK24614@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie> <200909091759.33655.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200909091759.33655.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 05:59:30PM +0200, Frans Pop wrote:
> On Wednesday 09 September 2009, Mel Gorman wrote:
> > Franz, in the full dmesg was there any mention of "SLUB: Unable to
> > allocate memory on node"?
> 
> No, nothing at all. I double checked the kernel log, but it was completely 
> quiet in the hours before and after the messages I already posted.
> 

Ok, that in itself is unexpected.

Pekka, it looks from the stack trace that the failure is from
__alloc_skb and I am guessing the failure path is around here

        size = SKB_DATA_ALIGN(size);
        data = kmalloc_node_track_caller(size + sizeof(struct skb_shared_info),
                        gfp_mask, node);
        if (!data)
                goto nodata;

Why would the SLUB out-of-memory message not appear? It's hardly
tripping up on printk_ratelimit() is it?

> > Also, did you have any slub debug options enabled on the command line?
> 
> Nope.
> 

Ok, just best to rule it out.

Apologies for the scattershot approach to figuring out where the order-2
failures are coming from and am not familiar at all with the driver.

According to the logs, the card is a 4965 AG so I can only assume the relevant
driver code is iwl4965. Since commit 1ea8739648cfff4027c3db0f4cee5de87bfd3886,
this has enabled by default a module option called amsdu_size_8K. At a glance,
it looks like this will guarantee that at least order-1 allocations will be
required. Assaf and other wireless folks, is that intentional? What are the
consequences of defaulting that to being off?

What might have made this worse is commit
4018517a1a69a85c3d61b20fa02f187b80773137 which intends to fix an RX skb
alignment problem but looks like it would have the side-effect of 8192
byte allocations becoming 8448 byte allocations and kmalloc() having to do
an order-2 allocation instead of order-1. The problem with this theory is
that the patches have been in since Nov 2008 but reports are only showing
up now.  Frans, how sure are you that this is a recent problem? Is it readily
reproducible?

Conceivably a better candidate for this problem is commit
4752c93c30441f98f7ed723001b1a5e3e5619829 introduced in May 2009. If there
are less than RX_QUEUE_SIZE/2 left, it starts replenishing buffers. Mohamed,
is it absolutly necessary it use GFP_ATOMIC there? If an allocation fails,
does it always mean frames are dropped or could it just replenish what it
can and try again later printing a warning only if allocation failures are
resulting in packet loss?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
