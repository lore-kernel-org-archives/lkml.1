Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYE1Mpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYE1Mpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYE1MpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:45:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35096 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYE1MpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:45:14 -0400
Date: Wed, 28 May 2008 14:54:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Andi Kleen <andi@firstfloor.org>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Message-ID: <20080528125401.GC20824@one.firstfloor.org>
References: <20080526234940.GA1376@xs4all.net> <20080527014720.6db68517.akpm@linux-foundation.org> <20080528024727.GB20824@one.firstfloor.org> <1211963485.28138.14.camel@localhost.localdomain> <20080528014017.9b3d116f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528014017.9b3d116f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	page = dma_alloc_pages(dev, gfp, get_order(size));
> > +	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
> > +	page = dma_alloc_pages(dev,
> > +		(gfp & GFP_DMA) ? gfp | __GFP_NORETRY : gfp, get_order(size));
> >  	if (page == NULL)
> >  		return NULL;
> 
> I guess that's more specifally solving that-which-we-wish-to-solve.

Then the allocator could still be stuck in ZONE_DMA32 on 64bit.

Also d_a_c() does one "speculative" allocation, as in an allocation
where it knows the zone is too large for the mask but it tries anyways
because it often works. In that case too much trying is also not good.

-Andi
