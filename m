Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbXHVQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbXHVQYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbXHVQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:24:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:56088 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbXHVQYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qePYj60hWpYfKEGCCTBXu0BNpD1+7BH0el5wcNrc3kiA9U8H8NrP6m0iw9xAXZfafG4ZSMCWWZgLMeWn93MagZZtTMxnFyap7cpg3xhrJ0CRbDIdSqQWJxs1CuxxDS6jB3KQJ/Tpd2oflhZpr9FGGMEMcNAIT4/rW7RHOHpGGks=
Message-ID: <84144f020708220924y6d707d50md1c95eeb58d5ce7@mail.gmail.com>
Date: Wed, 22 Aug 2007 19:24:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] SLUB: use have_arch_cmpxchg()
Cc: "Christoph Lameter" <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20070822150248.GB8504@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821231216.GA29691@Krystal> <20070821233938.GD29691@Krystal>
	 <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
	 <20070821234702.GE29691@Krystal>
	 <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
	 <20070822000323.GG29691@Krystal>
	 <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
	 <20070822002616.GA1400@Krystal>
	 <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
	 <20070822150248.GB8504@Krystal>
X-Google-Sender-Auth: 3053ac86289df684
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Cons:
> - Does not help code readability, i.e.:
>
> if (have_arch_cmpxchg())
>         preempt_disable();
> else
>         local_irq_save(flags);

Heh, that's an understatement, as now slub is starting to look a bit
like slab... ;-)  We need to hide that if-else maze into helper
functions for sure.

On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> --- slab.orig/mm/slub.c 2007-08-22 10:28:22.000000000 -0400
> +++ slab/mm/slub.c      2007-08-22 10:51:53.000000000 -0400
> @@ -1450,7 +1450,8 @@ static void *__slab_alloc(struct kmem_ca
>         void **freelist = NULL;
>         unsigned long flags;
>
> -       local_irq_save(flags);
> +       if (have_arch_cmpxchg())
> +               local_irq_save(flags);

I haven't been following on the cmpxchg_local() discussion too much so
the obvious question is: why do we do local_irq_save() for the _has_
cmpxchg() case here...

On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> @@ -1553,8 +1556,12 @@ static void __always_inline *slab_alloc(
>  {
>         void **object;
>         struct kmem_cache_cpu *c;
> +       unsigned long flags;
>
> -       preempt_disable();
> +       if (have_arch_cmpxchg())
> +               preempt_disable();
> +       else
> +               local_irq_save(flags);

...and preempt_disable() here?

On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> +       if (have_arch_cmpxchg()) {
> +               if (unlikely(cmpxchg_local(&c->freelist, object,
> +                               object[c->offset]) != object))
> +                       goto redo;
> +               preempt_enable();
> +       } else {
> +               c->freelist = object[c->offset];
> +               local_irq_restore(flags);
> +       }

If you move the preempt_enable/local_irq_restore pair outside of the
if-else block, you can make a static inline function slob_get_object()
that does:

    static inline bool slob_get_object(struct kmem_cache *c, void **object)
    {
        if (have_arch_cmpxchg()) {
            if (unlikely(cmpxchg_local(&c->freelist, object,
                    object[c->offset]) != object))
                return false;
        } else {
            c->freelist = object[c->offset];
        }
        return true;
    }

And let the compiler optimize out the branch for the non-cmpxchg case.
Same for the reverse case too (i.e. slob_put_object).

                                Pekka
