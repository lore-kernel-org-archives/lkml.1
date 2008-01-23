Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYAWFAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYAWFAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYAWE77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:59:59 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:5349 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYAWE75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:59:57 -0500
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] dma: dma_{un}map_{single|sg}_attrs() interface
X-Message-Flag: Warning: May contain useful information
References: <20080122024251.GJ30022@sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 22 Jan 2008 20:59:50 -0800
In-Reply-To: <20080122024251.GJ30022@sgi.com> (akepner@sgi.com's message of "Mon, 21 Jan 2008 18:42:51 -0800")
Message-ID: <adawsq1qgqh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2008 04:59:51.0151 (UTC) FILETIME=[C91D07F0:01C85D7C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- a/include/linux/dma-attrs.h
 > +++ b/include/linux/dma-attrs.h
 > @@ -0,0 +1,33 @@
 > +#ifndef _DMA_ATTR_H
 > +#define _DMA_ATTR_H
 > +
 > +#include <linux/bug.h>
 > +
 > +enum {
 > +	DMA_ATTR_INVALID,
 > +	DMA_ATTR_BARRIER,
 > +	DMA_ATTR_FOO,
 > +	DMA_ATTR_GOO,
 > +	DMA_ATTR_MAX,
 > +};
 > +
 > +struct dma_attrs {
 > +	unsigned flags;
 > +};
 > +
 > +static inline int dma_set_attr(struct dma_attrs *attrs, unsigned attr) {

maybe this would be cleaner if you named the DMA_ATTR enum and used
that instead of unsigned here (and below)?

 > +	BUG_ON(attrs == NULL);

does this BUG_ON() buy us much?  It seems the only thing we would fail
to oops on is if someone did dma_set_attr(NULL, INVALID) and I'm not
sure it's worth it to BUG here.

 > +	if (attr > DMA_ATTR_INVALID && attr < DMA_ATTR_MAX) {
 > +		attrs->flags = (1 << attr);
 > +		return 0;
 > +	}
 > +	return 1;

returning -EINVAL here instead of 1 would probably be more "kernelish".

 > +}
 > +
 > +static inline int dma_get_attr(struct dma_attrs *attrs, unsigned attr) {
 > +	if (attrs) 
 > +		 return attrs->flags & (1 << attr);

so it's OK to pass attrs == NULL into dma_get_attr() but not into
dma_set_attr()?  seems kind of odd.

 > +	return 0;
 > +}

It seems you're missing a way to initialize a struct dma_attrs.  How
do I clear the flags field to start with?

A macro like DEFINE_DMA_ATTRS() that initializes things for you (like
LIST_HEAD or DEFINE_SPIN_LOCK) would probably be a good thing to have
as well.

Also I guess you could test ARCH_USES_DMA_ATTRS in this file and stub
everything out and define an empty structure if it's not defined.
save a few bytes of stack etc.

 > +
 > +#endif /* _DMA_ATTR_H */
