Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYKXIRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYKXIRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYKXIRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:17:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55657 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKXIRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:17:36 -0500
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory
	allocation/freeing hooks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1227265627.7015.7.camel@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
	 <1227265627.7015.7.camel@pc1117.cambridge.arm.com>
Date: Mon, 24 Nov 2008 10:19:13 +0200
Message-Id: <1227514753.3718.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, 2008-11-21 at 11:07 +0000, Catalin Marinas wrote:
> Hi Pekka,
> 
> On Thu, 2008-11-20 at 21:30 +0200, Pekka Enberg wrote:
> > > @@ -2610,6 +2611,9 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
> > >                /* Slab management obj is off-slab. */
> > >                slabp = kmem_cache_alloc_node(cachep->slabp_cache,
> > >                                              local_flags & ~GFP_THISNODE, nodeid);
> > > +               /* only scan the list member to avoid false negatives */
> > > +               memleak_scan_area(slabp, offsetof(struct slab, list),
> > > +                                 sizeof(struct list_head));
> > 
> > I find this comment somewhat confusing. Does it mean we _must_ scan
> > the list members to avoid false negatives (i.e. leaks that happened
> > but were not reported) or that if we scan the whole of struct slab, we
> > get false negatives?
> 
> It's been some time since I first added this and I may not remember the
> full details but it's the latter case - it should avoid scanning
> slabp->s_mem because (my understanding) is that it may contain a pointer
> to an allocated block. Kmemleak only allows adding what sections to
> scan, so in this case only the list_head is relevant.
> 
> Let me know if my understanding is correct and I'll make the comment
> more clear.

Well, slab->s_mem simply points to the slab (i.e. page) itself. So I
suppose we need to ignore ->s_mem to avoid scanning the same slab twice?

