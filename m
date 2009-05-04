Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbZEDIte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbZEDIte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEDItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:49:23 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34536 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZEDItW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e58qYQMkloidwdqyAdCAxv63cpZtxFhFXH+FDYvUsP8oDHf4FAXXuq4BK4gDfzs1vZ
         QkGkuRVNGmSV8OqbPuGb100Q7CGh2PL5+ec49mQcXpuewXzmO4me2PSXemr9aRdfCsQk
         QUwICz9mgVQQUA2aL0b0rDbWKu8IY+v1ZbQbs=
Date: Mon, 4 May 2009 12:49:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504084916.GB4173@lenovo>
References: <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241425941.21088.19.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, May 04, 2009 at 11:32:21AM +0300]
| Hi Cyrill,
| 
| On Mon, 2009-05-04 at 12:14 +0400, Cyrill Gorcunov wrote:
| > mm: introduce __GFP_PANIC
| > 
| > Sometime we need that memory obtained via kmalloc
| > should always be granted. If there is no enough
| > memory we just can't go further.
| > 
| > For such a case we introduce __GFP_PANIC panic
| > modificator. If memory can't be granted -- we just
| > panic.
| > 
| > Note that __GFP_PANIC implicitly turn off failslab
| > facility on such kind calls.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| >  include/linux/gfp.h      |   13 ++++++++++---
| >  include/linux/slab_def.h |    1 +
| >  mm/failslab.c            |    3 +++
| >  mm/page_alloc.c          |   17 +++++++++++++++--
| >  4 files changed, 29 insertions(+), 5 deletions(-)
| > 
| > Index: linux-2.6.git/include/linux/gfp.h
| > =====================================================================
| > --- linux-2.6.git.orig/include/linux/gfp.h
| > +++ linux-2.6.git/include/linux/gfp.h
| > @@ -7,6 +7,7 @@
| >  #include <linux/topology.h>
| >  
| >  struct vm_area_struct;
| > +void oom_panic(gfp_t gfp_mask, unsigned int order);
| >  
| >  /*
| >   * GFP bitmasks..
| > @@ -58,7 +59,9 @@ struct vm_area_struct;
| >  #define __GFP_NOTRACK	((__force gfp_t)0)
| >  #endif
| >  
| > -#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
| > +#define __GFP_PANIC	((__force gfp_t)0x400000u) /* Panic on page alloction failure */
| > +
| > +#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
| >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
| >  
| >  /* This equals 0, but use constants in case they ever change */
| > @@ -196,8 +199,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
| >  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
| >  						unsigned int order)
| >  {
| > -	if (unlikely(order >= MAX_ORDER))
| > +	if (unlikely(order >= MAX_ORDER)) {
| > +		oom_panic(gfp_mask, order);
| 
| This...
| 
| >  		return NULL;
| > +	}
| >  
| >  	/* Unknown node is current node */
| >  	if (nid < 0)
| > @@ -212,8 +217,10 @@ extern struct page *alloc_pages_current(
| >  static inline struct page *
| >  alloc_pages(gfp_t gfp_mask, unsigned int order)
| >  {
| > -	if (unlikely(order >= MAX_ORDER))
| > +	if (unlikely(order >= MAX_ORDER)) {
| > +		oom_panic(gfp_mask, order);
| 
| ...this...
| 
| >  		return NULL;
| > +	}
| >  
| >  	return alloc_pages_current(gfp_mask, order);
| >  }
| > Index: linux-2.6.git/include/linux/slab_def.h
| > =====================================================================
| > --- linux-2.6.git.orig/include/linux/slab_def.h
| > +++ linux-2.6.git/include/linux/slab_def.h
| > @@ -143,6 +143,7 @@ static __always_inline void *kmalloc(siz
| >  			i++;
| >  #include <linux/kmalloc_sizes.h>
| >  #undef CACHE
| > +		oom_panic(flags, get_order(size));
| 
| ...and this look fishy. They're static inlines that get expanded
| everywhere and they're known to be performance sensitive paths. I don't
| see much point in checking for >= MAX_ORDER at all because we will get a
| nice oops anyway for that.

Yep, I noticed that it is really ugly cases to put oom_panic
here. But shouldn't we cover all the sites? If I'm not missing
something, for slab with builtin constant greater then KMALLOC_MAX_SIZE
the kmalloc caller could get NULL even if __GFP_PANIC specified.
Which in turn means __GFP_PANIC just doesn't work properly here.

Anyway, I'll update the patch with fixes you proposed should be done.
Wait a bit :)

| 
| __GFP_PANIC is an annotation saying that it's okay for a particular
| call-site not to check for NULL because we never expect to run out of
| memory at that point. But we don't really need to panic() for all the
| possible *errors*, just for the out-of-memory case.
| 
| 			Pekka
| 

Which means, __GFP_PANIC will not grant the guarantee to a caller
that he will not get NULL deref even with __GFP_PANIC specified?

Perhaps I missing something...

	-- Cyrill
