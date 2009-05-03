Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZECRt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZECRt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 13:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZECRtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 13:49:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:28546 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbZECRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 13:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BVqTxMCAhsbN70VVE53iCbLRigb559HsqZMkLfbMAU/IzIjCIUd246PYwTAKmAOrKE
         URCjlbX6/2YMAS660YWDcqzBMubtEnUkWx/bi7VrdJAXmeO2PcGTtfWCSZ6IG1YnIpdD
         sulAkA7/xoBFJ64fob9mgTcutM/IStUaogn/E=
Date: Sun, 3 May 2009 21:49:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090503174915.GH4615@lenovo>
References: <20090501203123.GA10878@sgi.com> <20090503084847.GA20394@elte.hu> <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com> <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com> <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Sun, May 03, 2009 at 08:38:01PM +0300]
| On Sun, May 3, 2009 at 8:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | > Hi Pekka,
| > | >
| > | > ufortunatelly __alloc_pages_internal is not the only place where
| > | > we do return NULL from kmalloc. As example - failslab facility
| > | > (in slab_alloc call). Anyway -- I'll take a closer look.
| > |
| > | Right. I think failslab needs some fixing _not_ to return NULL if
| > | __GFP_PANIC is set.
| > |
| >
| > Ok, as a first raw draft (_not_ covering all the cases) it could
| > be something like this. It touches only __alloc_pages_internal
| > and we have to bespread as well:
| >
| > 1) alloc_pages with order >= MAX_ORDER (gfp.h)
| > 2) the same for alloc_pages_node (both used by SLOB)
| > 3) all __kmalloc should be explored as well.
| > 4) ???
| >
| > Anyway -- take a look on __alloc_pages_internal part :)
| >
| >        -- Cyrill
| >
| > ---
| >  include/linux/gfp.h |    4 +++-
| >  mm/page_alloc.c     |    8 +++++---
| >  2 files changed, 8 insertions(+), 4 deletions(-)
| >
| > Index: linux-2.6.git/include/linux/gfp.h
| > =====================================================================
| > --- linux-2.6.git.orig/include/linux/gfp.h
| > +++ linux-2.6.git/include/linux/gfp.h
| > @@ -58,7 +58,9 @@ struct vm_area_struct;
| >  #define __GFP_NOTRACK  ((__force gfp_t)0)
| >  #endif
| >
| > -#define __GFP_BITS_SHIFT 22    /* Room for 22 __GFP_FOO bits */
| > +#define __GFP_PANIC    ((__force gfp_t)0x400000u) /* Panic on page alloction failure */
| > +
| > +#define __GFP_BITS_SHIFT 23    /* Room for 23 __GFP_FOO bits */
| >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
| >
| >  /* This equals 0, but use constants in case they ever change */
| > Index: linux-2.6.git/mm/page_alloc.c
| > =====================================================================
| > --- linux-2.6.git.orig/mm/page_alloc.c
| > +++ linux-2.6.git/mm/page_alloc.c
| > @@ -1496,7 +1496,7 @@ __alloc_pages_internal(gfp_t gfp_mask, u
| >        might_sleep_if(wait);
| >
| >        if (should_fail_alloc_page(gfp_mask, order))
| > -               return NULL;
| > +               goto nopage;
| 
| The point of fault injection is to increase coverage out-of-memory
| error handling code. So this doesn't make much sense to me. Why would
| you want to cause a __GFP_PANIC call-sites to panic()? It doesn't help
| testing one bit.
| 
| So I still think you should just fix up should_fail_alloc_page() _not_
| to return true if __GFP_PANIC is set.

Ah, yes, I see. I just though that caller requested to panic
if allocation failed and it''ll got it regardless of the reason.
But for fail injection it doesn't make sence at all indeed. Will
fix, thanks!

...
 
	-- Cyrill
