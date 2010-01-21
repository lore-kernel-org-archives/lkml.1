Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500Ab0AUOKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0AUOKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004Ab0AUOKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:10:01 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57455 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab0AUOKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:10:00 -0500
Date: Thu, 21 Jan 2010 14:09:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
Message-ID: <20100121140948.GJ5154@csn.ul.ie>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com> <20100120094813.GC5154@csn.ul.ie> <alpine.DEB.2.00.1001201241540.6440@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001201241540.6440@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:48:05PM -0800, David Rientjes wrote:
> On Wed, 20 Jan 2010, Mel Gorman wrote:
> 
> > > With Lee's work on mempolicy-constrained hugepage allocations, there is a 
> > > use-case for this explicit trigger to be exported via sysfs in the 
> > > longterm:
> > 
> > True, although the per-node structures are only available on NUMA making
> > it necessary to have two interfaces. The per-node one is handy enough
> > because it would be just
> > 
> > /sys/devices/system/node/nodeX/compact_node
> > 	When written to, this node is compacted by the writing process
> > 
> > But there does not appear to be a "good" way of having a non-NUMA
> > interface. /sys/devices/system/node does not exist .... Does anyone
> > remember why !NUMA does not have a /sys/devices/system/node/node0? Is
> > there a good reason or was there just no point?
> > 
> 
> There doesn't seem to be a usecase for a fake node0 sysfs entry since it 
> would be a duplication of procfs.
> 

Indeed.

> I think it would be best to create a global /proc/sys/vm/compact trigger 
> that would walk all "compactable" zones system-wide

Easily done.

> and then a per-node 
> /sys/devices/system/node/nodeX/compact trigger for that particular node, 
> both with permissions 0200.
> 

Will work on this as an additional patch. It should be straight-forward
with the only care needing to be taken around memory hotplug as usual.

> It would be helpful to be able to determine what is "compactable" at the 
> same time by adding both global and per-node "compact_order" tunables that 
> would default to HUGETLB_PAGE_ORDER. 

Well, rather than having a separate tunable, writing a number to
/proc/sys/vm/compact could indicate the order if that trigger is now
working system-wide. Would that be suitable?

> Then, the corresponding "compact" 
> trigger would only do work if fill_contig_page_info() shows 
> !free_blocks_suitable for either all zones (global trigger) or each zone 
> in the node's zonelist (per-node trigger).
> 

Do you see a need for proc to act like this? I'm wondering if
try_to_compact_pages() already does what you're looking for except no
process is required to muck around in /proc or /sys.

I somewhat saw the /proc and /sys tunables being used for either debugging or
by a job scheduler that compacted one or more nodes before a new job started.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
