Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbXIZGuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbXIZGuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXIZGuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:50:12 -0400
Received: from colo.lackof.org ([198.49.126.79]:45268 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXIZGuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:50:10 -0400
Date: Wed, 26 Sep 2007 00:49:50 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: akepner@sgi.com
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA
Message-ID: <20070926064950.GB30430@colo.lackof.org>
References: <20070925235843.GK30013@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925235843.GK30013@sgi.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[+jejb to cc]

On Tue, Sep 25, 2007 at 04:58:43PM -0700, akepner@sgi.com wrote:
> This is a followup to http://lkml.org/lkml/2007/8/24/280
> 
> Despite Grant's desire for a more elegant solution, there's 
> not much new here. I moved the API change from pci.h to 
> dma-mapping.h and removed the pci_ prefix from the name. 

Thanks - but I don't have a better idea either.
I think you are right to just move forward with this until
someone provides a better API.

> Problem Description
> -------------------
> On Altix, DMA may be reordered within the NUMA interconnect.
> This can be a problem with Infiniband, where DMA to Completion Queues 
> allocated in user-space can race with data DMA. This patchset allows 
> a driver to associate a user-space memory region with a "dmaflush" 
> attribute, so that writes to the memory region flush in-flight DMA, 
> preventing the CQ/data race.

Can we define this API to provide the same semantics as the memory
that dma_alloc_coherent() returns?
Did I summarize this correctly?

Defining it terms of completion queues won't mean much to most folks.
Better to add a description of completion queues to the DMA-API.txt if
necessary.  dma_alloc_coherent() API is pretty well understood.

> There are four patches in this set:
> 
>   [1/4] dma: add dma_flags_set_dmaflush() to dma interface

Sorry - this feels like a "color of the shed" argument, but isn't
this about DMA ordering attribute?
"dmaflush" is an action and not an attribute to me.
Is dma_flags_set_coherent() better since it's doing the same thing
as dma_alloc_coherent()?

>   [2/4] dma: redefine dma_flags_set_dmaflush() for sn-ia64
>   [3/4] dma: document dma_flags_set_dmaflush()

This patch updates Documentation/DMA-mapping.txt. But it's a change to
the generic (not PCI specific) API described in DMA-API.txt.
Can you update that as well please?

Upon reading the "2) Platforms that permit DMA reordering", I think I
have been confusing coherency with ordering. I think I have because DMA
is leaving the "PCI domain", crossing an "unordered domain" (NUMA,
interconnect), and then finally hitting the cache coherency "domain"
when it reaches a "far away" memory controller. That's why I've
been thinking of this as a coherency problem.

The description and API uses the word "flush" (which is ok I guess) instead
of describing this in terms of enforcing DMA ordering.  Any DMA write to the
"strongly ordered" region will cause _all_ inflight DMA to be visible
to cache coherency, thus preserving the illusion of strong DMA ordering.

Does that sound right/better to you too?
I don't have chipset docs and some of this is just trying to rephrase
what I've heard before from former SGI employees.

>   [4/4] mthca: allow setting "dmaflush" attribute on user-allocated memory

Besides calling the parameter "dmaflush", it looks fine to me.
(It's either a DMA ordering or coherency attribute depending on how
you want to look at it.)

thanks,
grant

