Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZEUCoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZEUCoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZEUCoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:44:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54733 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZEUCoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:44:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20090520140045.GA29447@sgi.com>
References: <20090519102003.4EAB.A69D9226@jp.fujitsu.com> <20090520140045.GA29447@sgi.com>
Message-Id: <20090521090549.63B5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 May 2009 11:44:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, May 19, 2009 at 11:53:44AM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > > Current linux policy is, zone_reclaim_mode is enabled by default if the machine
> > > > has large remote node distance. it's because we could assume that large distance 
> > > > mean large server until recently.
> > > > 
> > > > Unfortunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
> > > > memory controller. IOW it's seen as NUMA from software view.
> > > > 
> > > > Some Core i7 machine has large remote node distance, but zone_reclaim don't
> > > > fit desktop and small file server. it cause performance degression.
> > > > 
> > > > Thus, zone_reclaim == 0 is better by default if the machine is small.
> > > 
> > > What if I had a node 0 with 32GB or 128GB of memory.  In that case,
> > > we would have 3GB for DMA32, 125GB for Normal and then a node 1 with
> > > 128GB.  I would suggest that zone reclaim would perform normally and
> > > be beneficial.
> > > 
> > > You are unfairly classifying this as a size of machine problem when it is
> > > really a problem with the underlying zone reclaim code being triggered
> > > due to imbalanced node/zones, part of which is due to a single node
> > > having multiple zones and those multiple zones setting up the conditions
> > > for extremely agressive reclaim.  In other words, you are putting a
> > > bandage in place to hide a problem on your particular hardware.
> > > 
> > > Can RECLAIM_DISTANCE be adjusted so your Ci7 boxes are no longer caught?
> > > Aren't 4 node Ci7 boxes soon to be readily available?  How are your apps
> > > different from my apps in that you are not impacted by node locality?
> > > Are you being too insensitive to node locality?  Conversely am I being
> > > too sensitive?
> > > 
> > > All that said, I would not stop this from going in.  I just think the
> > > selection criteria is rather random.  I think we know the condition we
> > > are trying to avoid which is a small Normal zone on one node and a larger
> > > Normal zone on another causing zone reclaim to be overly agressive.
> > > I don't know how to quantify "small" versus "large".  I would suggest
> > > that a node 0 with 16 or more GB should have zone reclaim on by default
> > > as well.  Can that be expressed in the selection criteria.
> > 
> > I post my opinion as another mail. please see it.
> 
> I don't think you addressed my actual question.  How much of this is
> a result of having a node where 1/4 of the memory is in the 'Normal'
> zone and 3/4 is in the DMA32 zone?  How much is due to the imbalance
> between Node 0 'Normal' and Node 1 'Normal'?  Shouldn't that type of
> sanity check be used for turning on zone reclaim instead of some random
> number of nodes.

I can't catch up your message. Can you post your patch?
Can you explain your sanity check?

Now, I decide to remove "nr_online_nodes >= 4" condition.
Apache regression is really non-sense.

> Even with 128 nodes and 256 cpus, I _NEVER_ see the
> system swapping out before allocating off node so I can certainly not
> reproduce the situation you are seeing.

hmhm. but I don't think we can assume hpc workload.


> 
> The imbalance I have seen was when I had two small memory nodes and two
> large memory nodes and then oversubscribed memory.  In that situation,
> I noticed that the apps on the small memory nodes were more frequently
> impacted.  This unfairness made sense to me and seemed perfectly
> reasonable.


The node imbalancing is ok. example, typical linux init script makes many deamon process
to node0, we can't avoid it and it don't make strange behavior.

but zone imbalancing is bad. I don't want discuss all item again. but you
can google about inter zone reclaim issue instead.



