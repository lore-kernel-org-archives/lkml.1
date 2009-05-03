Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZECRiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZECRiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZECRiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 13:38:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35868 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZECRiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 13:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qJlbkRqyLL2FDY9ZOqFgXls2ap6f43OAxDYZBqx1B9druwANCb7yobuPAMT0y9G4/V
         omZSbxCGK1fIRPhbkX3WJeIwWrCvFbHZ0olT7/KBXUG4wsj/LiBXZsfjyKD9GdUB16/3
         oiCBV2qnXhNVzy7sndC4zVBlm7lX+kwACx5BI=
MIME-Version: 1.0
In-Reply-To: <20090503172338.GG4615@lenovo>
References: <20090501200937.GD4633@lenovo> <20090501203123.GA10878@sgi.com>
	 <20090503084847.GA20394@elte.hu>
	 <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com>
	 <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com>
	 <20090503121228.GC4615@lenovo>
	 <1241353621.27683.3.camel@penberg-laptop>
	 <20090503143824.GF4615@lenovo>
	 <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com>
	 <20090503172338.GG4615@lenovo>
Date: Sun, 3 May 2009 20:38:01 +0300
X-Google-Sender-Auth: 7b1b6f6984ddb6ed
Message-ID: <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com>
Subject: Re: introducing __GFP_PANIC
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 at 8:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | > Hi Pekka,
> | >
> | > ufortunatelly __alloc_pages_internal is not the only place where
> | > we do return NULL from kmalloc. As example - failslab facility
> | > (in slab_alloc call). Anyway -- I'll take a closer look.
> |
> | Right. I think failslab needs some fixing _not_ to return NULL if
> | __GFP_PANIC is set.
> |
>
> Ok, as a first raw draft (_not_ covering all the cases) it could
> be something like this. It touches only __alloc_pages_internal
> and we have to bespread as well:
>
> 1) alloc_pages with order >= MAX_ORDER (gfp.h)
> 2) the same for alloc_pages_node (both used by SLOB)
> 3) all __kmalloc should be explored as well.
> 4) ???
>
> Anyway -- take a look on __alloc_pages_internal part :)
>
>        -- Cyrill
>
> ---
>  include/linux/gfp.h |    4 +++-
>  mm/page_alloc.c     |    8 +++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> Index: linux-2.6.git/include/linux/gfp.h
> =====================================================================
> --- linux-2.6.git.orig/include/linux/gfp.h
> +++ linux-2.6.git/include/linux/gfp.h
> @@ -58,7 +58,9 @@ struct vm_area_struct;
>  #define __GFP_NOTRACK  ((__force gfp_t)0)
>  #endif
>
> -#define __GFP_BITS_SHIFT 22    /* Room for 22 __GFP_FOO bits */
> +#define __GFP_PANIC    ((__force gfp_t)0x400000u) /* Panic on page alloction failure */
> +
> +#define __GFP_BITS_SHIFT 23    /* Room for 23 __GFP_FOO bits */
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>
>  /* This equals 0, but use constants in case they ever change */
> Index: linux-2.6.git/mm/page_alloc.c
> =====================================================================
> --- linux-2.6.git.orig/mm/page_alloc.c
> +++ linux-2.6.git/mm/page_alloc.c
> @@ -1496,7 +1496,7 @@ __alloc_pages_internal(gfp_t gfp_mask, u
>        might_sleep_if(wait);
>
>        if (should_fail_alloc_page(gfp_mask, order))
> -               return NULL;
> +               goto nopage;

The point of fault injection is to increase coverage out-of-memory
error handling code. So this doesn't make much sense to me. Why would
you want to cause a __GFP_PANIC call-sites to panic()? It doesn't help
testing one bit.

So I still think you should just fix up should_fail_alloc_page() _not_
to return true if __GFP_PANIC is set.

>
>  restart:
>        z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */
> @@ -1506,7 +1506,7 @@ restart:
>                 * Happens if we have an empty zonelist as a result of
>                 * GFP_THISNODE being used on a memoryless node
>                 */
> -               return NULL;
> +               goto nopage;
>        }
>
>        page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> @@ -1685,7 +1685,9 @@ nopage:
>                dump_stack();
>                show_mem();
>        }
> -       return page;
> +       if (unlikely(gfp_mask & __GFP_PANIC))
> +               panic("Out of memory: panic due to __GFP_PANIC\n");
> +       return NULL;
>  got_pg:
>        if (kmemcheck_enabled)
>                kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
