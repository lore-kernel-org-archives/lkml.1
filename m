Return-Path: <linux-kernel-owner+w=401wt.eu-S1163494AbYCTAkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163494AbYCTAkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967266AbYCTA2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:28:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43625 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765436AbYCTA2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:28:08 -0400
From: akepner@sgi.com
Date: Wed, 19 Mar 2008 17:26:37 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080320002637.GK1843@sgi.com>
References: <20080313040022.GJ12370@sgi.com> <20080313014106.782aa3c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313014106.782aa3c7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 01:41:06AM -0700, Andrew Morton wrote:

Thanks for the review. 

I have a new patchset which will address most of your comments. 

> On Wed, 12 Mar 2008 21:00:22 -0700 akepner@sgi.com wrote:
> 
> > ...
> >
> > diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
> > index e69de29..05b6e91 100644
> > --- a/include/linux/dma-attrs.h
> > +++ b/include/linux/dma-attrs.h
> > @@ -0,0 +1,55 @@
> > +#ifndef _DMA_ATTR_H
> > +#define _DMA_ATTR_H
> > +
> > +enum dma_attr {
> > +	DMA_ATTR_BARRIER,
> > +	DMA_ATTR_MAX,
> > +};
> > +
> > +struct dma_attrs {
> > +	unsigned flags;
> > +};
> 
> Please comment the above.  Describe the semantic meaning of the enums and
> how they are mapped into `struct dma_attrs' (which is what I assume they
> do).  I see there's a documentation update here so if you think it's best
> to direct the code reader to that file then fine, add a suitable reference.

OK, I've added a reference to the Documentation/DMA-attributes.txt 
file.

> 
> Why did we need to implement a struct for a plain old flags word?

To make the type that carries the attributes opaque, so that it 
could be expanded. It's a bitmap in the latest version.

> 
> > +#define __DMA_ATTRS_INIT() { .flags = 0, }
> 
> Does this need to exist?

No, it's gone from the next patchset.

> 
> > +#define DECLARE_DMA_ATTRS(x) struct dma_attrs x = __DMA_ATTRS_INIT()
> 
> This is a definition, not a declaration.  Please rename it to
> DEFINE_DMA_ATTRS().
>

You're right. Done.

 
> > +#define INIT_DMA_ATTRS(x) (x)->flags = 0;
> 
> So if I do
> 
> 	if (expr)
> 		INIT_DMA_ATTRS(bar);
> 	else
> 		something_else();
> 
> it won't compile.
> 
> Golden rule: implement not in cpp that which can be implemented in C.
> 
> static inline void init_dma_attrs(struct dma_attrs *attrs)
> {
> 	attrs->flags = 0;
> }
> 
> is much nicer, no?
> 

Yes ;-)

> > +#ifdef ARCH_USES_DMA_ATTRS
> 
> There is no precedent for ARCH_USES_*.
> 
> There is a little bit of precedent for ARCH_HAVE_*
> 
> There is lots of precendence for ARCH_HAS_*.
> 
> We don't like ARCH_HAS_* anyway ;) What can we do to get rid of this? 
> Ideally, make it available on all architectures at zero cost to those which
> don't need it.  If that is impractical (why?) then it is preferable to do
> this in Kconfig.
> 

OK, I've changed this to CONFIG_HAVE_DMA_ATTRS, selected in Kconfig.

> > +/*
> > + * dma_set_attr - set a specific attribute
> > + * may be called with a null attrs
> > + */
> > +static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
> > +{
> > +	if (!attrs)
> > +		return 0;
> > +	if (attr < DMA_ATTR_MAX) {
> > +		attrs->flags |= (1 << attr);
> > +		return 0;
> > +	}
> > +	return -EINVAL;
> > +}
> 
> Is there any non-buggy reason why code would pass an out-of-range attribute
> into this function?  If not, BUG_ON() would be appropriate treatment.

Latest version uses BUG_ON().

> 
> ....
> We have a dma_set_attr() stub but no dma_get_attr() stub?
> 

I put a stub in, but dma_get_attr() is only used by arch-specific 
code, and only code that has CONFIG_HAVE_DMA_ATTRS set. 
dma_set_attr() is used by arch-independent code, so it has 
to be there whether CONFIG_HAVE_DMA_ATTRS is set or no.

-- 
Arthur

