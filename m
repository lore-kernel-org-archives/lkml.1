Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbXHQVA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbXHQVA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764339AbXHQVAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:00:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34434 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764208AbXHQVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:00:40 -0400
Date: Sat, 18 Aug 2007 02:43:19 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
In-Reply-To: <20070817112253.e6a7cb33.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com> <1187132149.2618.2.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
 <20070817112253.e6a7cb33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Andrew Morton wrote:

> On Wed, 15 Aug 2007 05:12:41 +0530 (IST)
> Satyam Sharma <satyam@infradead.org> wrote:
> 
> > [PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
> > 
> > Considering kfree(NULL) would normally occur only in error paths and
> > kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for
> > the condition check in SLUB's and SLOB's kfree() to optimize for the
> > common case. SLAB has this already.
> 
> I went through my current versions of slab/slub/slub and came up with this:
> 
> diff -puN mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slob.c
> [...]
> @@ -484,7 +484,7 @@ size_t ksize(const void *block)
>  {
>  	struct slob_page *sp;
>  
> -	if (ZERO_OR_NULL_PTR(block))
> +	if (unlikely(ZERO_OR_NULL_PTR(block)))
>  		return 0;
>  
>  	sp = (struct slob_page *)virt_to_page(block);
> diff -puN mm/slub.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slub.c
> [...]
> @@ -2434,7 +2434,7 @@ size_t ksize(const void *object)
>  	struct page *page;
>  	struct kmem_cache *s;
>  
> -	if (ZERO_OR_NULL_PTR(object))
> +	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return 0;
>  
>  	page = get_object_page(object);

Hmm, I didn't know ksize(NULL) was also allowed to succeed (and
return 0).

<checking around>

Oh yes, of course. We want krealloc(NULL) cases to behave
consistently as expected, and letting ksize(NULL) return 0 means
the code for krealloc() can lose an extra "if (!p)" check that
would otherwise have been required. Cool.


> Which is getting pretty idiotic:
> 
> akpm:/usr/src/25> grep ZERO_OR_NULL_PTR */*.c
> mm/slab.c:              BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
> mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
> mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
> mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
> mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
> mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
> mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
> mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(object)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(x)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
> mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
> 
> are we seeing a pattern here?  We could stick the unlikely inside
> ZERO_OR_NULL_PTR() itself.  That's a little bit sleazy though - there might
> be future callsites at which it is likely, who knows?

Well, all the above callsites genuinely appear to benefit from unlikely.
And it's unlikely (English word, this here :-) ZERO_OR_NULL_PTR would grow
callsites outside of mm/ especially considering the implementation
(or even the knowledge) of the ZERO_SIZE_PTR concept is something we'd
ideally want to abstract away from other generic callsites, I imagine.


Satyam
