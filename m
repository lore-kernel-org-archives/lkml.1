Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbYB2SZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbYB2SZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYB2SZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:25:18 -0500
Received: from colo.lackof.org ([198.49.126.79]:54776 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbYB2SZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:25:16 -0500
Date: Fri, 29 Feb 2008 11:25:04 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
Message-ID: <20080229182504.GA18102@colo.lackof.org>
References: <20080228032448.GS11012@sgi.com> <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:45:46PM +1100, Michael Ellerman wrote:
> On Thu, Feb 28, 2008 at 2:24 PM,  <akepner@sgi.com> wrote:
> >
> >  Document the new dma_{un}map_{single|sg}_attrs() functions.
> >
> >  diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
> >  index e69de29..36baea5 100644
> >  --- a/Documentation/DMA-attributes.txt
> >  +++ b/Documentation/DMA-attributes.txt
> >  @@ -0,0 +1,29 @@
> >  +                       DMA attributes
> >  +                       ==============
> >  +
> >  +This document describes the semantics of the DMA attributes that are
> >  +defined in linux/dma-attrs.h.
> >  +
> >  +
> >  +DMA_ATTR_SYNC_ON_WRITE
> >  +----------------------
> >  +
> >  +DMA_ATTR_SYNC_ON_WRITE is used on the IA64_SGI_SN2 architecture.
> >  +It provides a mechanism for devices to explicitly order their DMA
> >  +writes.
> >  +
> >  +On IA64_SGI_SN2 machines, DMA may be reordered within the NUMA
> >  +interconnect. Allowing reordering improves performance, but in some
> >  +situations it may be necessary to ensure that one DMA write is
> >  +complete before another is visible. For example, if the device does
> >  +a DMA write to indicate that data is available in memory, DMA of the
> >  +"completion indication" can race with DMA of data.
> >  +
> >  +When a memory region is mapped with the DMA_ATTR_SYNC_ON_WRITE attribute,
> >  +a write to that region causes all in-flight DMA to be flushed to memory.
> >  +Any pending DMA will complete and be visible in memory before the write
> >  +to the region with the DMA_ATTR_SYNC_ON_WRITE attribute becomes visible.
> 
> 
> I'm not clear how this is all meant to work. Your intial patch says
> this is an interface to pass "architecture-specific
> attributes" from drivers through to the DMA mapping code, which is
> fair enough - we want to do something similar.
> 
> But it's not clear that DMA_ATTR_SYNC_ON_WRITE is architecture
> specific. If I was a driver writer might assume it works on all
> platforms.

That would be a fair assumption. But it is required to be a NOP on
platforms that don't need the "hint" ("attr" or whatever you want
to call it). Specific architectures (SN2 in this case) will need
to implement something.

> And in fact in patch 3/3 you define it in
> linux/dma-attrs.h, so it's not architecture specific.

Correct. The same driver needs to compile on all architectures.

> What is architecture specific is the semantic. DMA_ATTR_SYNC_ON_WRITE
> is defined entirely in terms of what it does on ia64 hardware, and a
> particular flavour thereof.
> 
> It just seems to me we're going to end up with a gazillion flags,
> because DMA_ATTR_SYNC_ON_WRITE isn't quite the same semantic as what
> Power can do. So we'll have to add
> DMA_ATTR_SYNC_ON_WRITE_WRT_OTHER_SYNC_ON_WRITE_MAPPINGS_ONLY and so
> on. Or, we end with subtle driver bugs because the semantics aren't
> clear across platforms.

I agree. Just have to sort those issues out as people come up with them.

> I guess I think the attributes should either be truly arch-specific,
> ie. DMA_ATTR_IA64_SYNC_ON_WRITE. Or we need to come up with some well
> defined, and architecture neutral semantics for what the flags mean.

The latter. I have no intention of adding arch specific flags that
only mean something on one arch. The intent here is to enable
correct functionality on specific arches without impacting
performance on arches that don't need those "attributes".

hth,
grant

> 
> cheers
