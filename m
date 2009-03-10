Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZCJBLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZCJBLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZCJBLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:11:22 -0400
Received: from relais.videotron.ca ([24.201.245.36]:47434 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZCJBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:11:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 09 Mar 2009 21:11:12 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       minchan.kim@gmail.com, linux@arm.linux.org.uk
Subject: Re: [PATCH] atomic highmem kmap page pinning
In-reply-to: <20090309133121.eab3bbd9.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0903092107240.30483@xanadu.home>
References: <alpine.LFD.2.00.0903071731120.30483@xanadu.home>
 <20090309133121.eab3bbd9.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Andrew Morton wrote:

> On Sat, 07 Mar 2009 17:42:44 -0500 (EST)
> Nicolas Pitre <nico@cam.org> wrote:
> 
> > 
> > Discussion about this patch is settling, so I'd like to know if there 
> > are more comments, or if official ACKs could be provided.  If people 
> > agree I'd like to carry this patch in my ARM highmem patch series since 
> > a couple things depend on this.
> > 
> > Andrew: You seemed OK with the original one.  Does this one pass your 
> > grottiness test?
> > 
> > Anyone else?
> 
> OK by me.

Thanks.

> > +/*
> > + * Most architectures have no use for kmap_high_get(), so let's abstract
> > + * the disabling of IRQ out of the locking in that case to save on a
> > + * potential useless overhead.
> > + */
> > +#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> > +#define spin_lock_kmap()             spin_lock_irq(&kmap_lock)
> > +#define spin_unlock_kmap()           spin_unlock_irq(&kmap_lock)
> > +#define spin_lock_kmap_any(flags)    spin_lock_irqsave(&kmap_lock, flags)
> > +#define spin_unlock_kmap_any(flags)  spin_unlock_irqrestore(&kmap_lock, flags)
> > +#else
> > +#define spin_lock_kmap()             spin_lock(&kmap_lock)
> > +#define spin_unlock_kmap()           spin_unlock(&kmap_lock)
> > +#define spin_lock_kmap_any(flags)    \
> > +	do { spin_lock(&kmap_lock); (void)(flags); } while (0)
> > +#define spin_unlock_kmap_any(flags)  \
> > +	do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
> > +#endif
> 
> It's a little bit misleading to discover that a "function" called
> spin_lock_kmap() secretly does an irq_disable().  Perhaps just remove
> the "spin_" from all these identifiers?

OK, done.


Nicolas
