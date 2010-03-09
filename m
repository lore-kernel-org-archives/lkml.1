Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0CIRBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:01:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59060 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab0CIRBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:01:41 -0500
Date: Tue, 9 Mar 2010 17:01:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-allocator: Under memory pressure, wait on
	pressure to relieve instead of congestion
Message-ID: <20100309170123.GG4883@csn.ul.ie>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <1268048904-19397-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003090946180.28897@router.home> <4B966F93.9060207@linux.vnet.ibm.com> <alpine.DEB.2.00.1003091005310.28897@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003091005310.28897@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:09:11AM -0600, Christoph Lameter wrote:
> On Tue, 9 Mar 2010, Christian Ehrhardt wrote:
> 
> > > What happens if memory becomes available in another zone? Lets say we are
> > > waiting on HIGHMEM and memory in ZONE_NORMAL becomes available?
> >
> > Do you mean the same as Nick asked or another aspect of it?
> > citation:
> > "I mean the other way around. If that zone's watermarks are not met, then why
> > shouldn't it be woken up by other zones reaching their watermarks."
> 
> Just saw that exchange. Yes it is similar. Mel only thought about NUMA
> but the situation can also occur in !NUMA because multiple zones do not
> require NUMA.
> 

True, although rare. Elsewhere I suggested that the wait could be on a
per-node basis instead of per-zone. My main concern there would be
adding a new hot cache line in the page free path or an unfortunate mix
of zone and node logic. I'm not fully convinced it's worth it but will
check it out.

> If a process goes to sleep on an allocation that has a preferred zone of
> HIGHMEM then other processors may free up memory in ZONE_DMA and
> ZONE_NORMAL and therefore memory may become available but the process will
> continue to sleep.
> 

Until it's timeout at least. It's still better than the current
situation of sleeping on congestion.

The ideal would be waiting on a per-node basis. I'm just not liking having
to look up the node structure when freeing a patch of pages and making a
cache line in there unnecessarily hot.

> The wait structure needs to be placed in the pgdat structure to make it
> node specific.
> 
> But then an overallocated node may stall processes. If that node is full
> of unreclaimable memory then the process may never wake up?
> 

Processes wake after a timeout.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
