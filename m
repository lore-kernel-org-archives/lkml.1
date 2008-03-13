Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYCMInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYCMInp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYCMIng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:43:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbYCMInf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:43:35 -0400
Date: Thu, 13 Mar 2008 01:41:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-Id: <20080313014106.782aa3c7.akpm@linux-foundation.org>
In-Reply-To: <20080313040022.GJ12370@sgi.com>
References: <20080313040022.GJ12370@sgi.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 21:00:22 -0700 akepner@sgi.com wrote:

> 
> Introduce a new interface for passing architecture-specific
> attributes when memory is mapped and unmapped for DMA. Give
> the interface a default implementation which ignores
> attributes. Also introduce the dma_{set|get}_attr() interface
> for setting and retrieving individual attributes. Define one 
> attribute DMA_ATTR_BARRIER in anticipation of its use by ia64/sn.
> 
> ...
>
> diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
> index e69de29..05b6e91 100644
> --- a/include/linux/dma-attrs.h
> +++ b/include/linux/dma-attrs.h
> @@ -0,0 +1,55 @@
> +#ifndef _DMA_ATTR_H
> +#define _DMA_ATTR_H
> +
> +enum dma_attr {
> +	DMA_ATTR_BARRIER,
> +	DMA_ATTR_MAX,
> +};
> +
> +struct dma_attrs {
> +	unsigned flags;
> +};

Please comment the above.  Describe the semantic meaning of the enums and
how they are mapped into `struct dma_attrs' (which is what I assume they
do).  I see there's a documentation update here so if you think it's best
to direct the code reader to that file then fine, add a suitable reference.

Why did we need to implement a struct for a plain old flags word?

> +#define __DMA_ATTRS_INIT() { .flags = 0, }

Does this need to exist?

> +#define DECLARE_DMA_ATTRS(x) struct dma_attrs x = __DMA_ATTRS_INIT()

This is a definition, not a declaration.  Please rename it to
DEFINE_DMA_ATTRS().

> +#define INIT_DMA_ATTRS(x) (x)->flags = 0;

So if I do

	if (expr)
		INIT_DMA_ATTRS(bar);
	else
		something_else();

it won't compile.

Golden rule: implement not in cpp that which can be implemented in C.

static inline void init_dma_attrs(struct dma_attrs *attrs)
{
	attrs->flags = 0;
}

is much nicer, no?

> +#ifdef ARCH_USES_DMA_ATTRS

There is no precedent for ARCH_USES_*.

There is a little bit of precedent for ARCH_HAVE_*

There is lots of precendence for ARCH_HAS_*.

We don't like ARCH_HAS_* anyway ;) What can we do to get rid of this? 
Ideally, make it available on all architectures at zero cost to those which
don't need it.  If that is impractical (why?) then it is preferable to do
this in Kconfig.

> +/*
> + * dma_set_attr - set a specific attribute
> + * may be called with a null attrs
> + */
> +static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
> +{
> +	if (!attrs)
> +		return 0;
> +	if (attr < DMA_ATTR_MAX) {
> +		attrs->flags |= (1 << attr);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}

Is there any non-buggy reason why code would pass an out-of-range attribute
into this function?  If not, BUG_ON() would be appropriate treatment.

This function might already be too large to inline, and a BUG_ON() might
make it larger.

> +/*
> + * dma_get_attr - check for a specific attribute
> + * may be called with a null attrs
> + */
> +static inline int dma_get_attr(struct dma_attrs *attrs, enum dma_attr attr)
> +{
> +	if (!attrs)
> +		return 0;
> +	if (attr < DMA_ATTR_MAX) {
> +		int ret = attrs->flags & (1 << attr);
> +		return !!ret;
> +	}
> +	return -EINVAL;
> +}

The two callers to this function just do a WARN_ON_ONCE() if it failed.  It
looks like adding a BUG_ON() and removing those WARN_ONs is the way to go.

> +#else /* !ARCH_USES_DMA_ATTRS */
> +static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
> +{
> +	return 0;
> +}

We have a dma_set_attr() stub but no dma_get_attr() stub?

> +#endif /* ARCH_USES_DMA_ATTRS */
> +#endif /* _DMA_ATTR_H */

