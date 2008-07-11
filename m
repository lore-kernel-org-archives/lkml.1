Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYGKItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYGKItg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYGKIt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:49:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:26733 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYGKIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rG9GUw//HfVl57SZpJusvtJkr3Wqang4qoPlWjCqRdATv2vdcbUGYLTC5SrQ5AL1hc
         b3qLAeGIJHy/yZwzmp4+STCymV+ySBwNtZI5JGwe390P5roGj1JtdWUriyQGC89jSoxK
         MWIVClFk6uhNvsmygdJWOm7v2kjF1qmO6adms=
Message-ID: <84144f020807110149v4806404fjdb9c3e4af3cfdb70@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:49:27 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 3/5] kmemtrace: SLAB hooks.
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080710210611.7c194a70@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	 <20080710210611.7c194a70@linux360.ro>
X-Google-Sender-Auth: 73870cf8d34a27dc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 10, 2008 at 9:06 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLAB allocator, to allow tracing with kmemtrace.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
>  static inline void *kmalloc(size_t size, gfp_t flags)
>  {
> +       void *ret;
> +
>        if (__builtin_constant_p(size)) {
>                int i = 0;
>
> @@ -50,10 +53,17 @@ static inline void *kmalloc(size_t size, gfp_t flags)
>  found:
>  #ifdef CONFIG_ZONE_DMA
>                if (flags & GFP_DMA)
> -                       return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
> -                                               flags);
> +                       ret = kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
> +                                              flags | __GFP_NOTRACE);
> +               else
>  #endif
> -               return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
> +                       ret = kmem_cache_alloc(malloc_sizes[i].cs_cachep,
> +                                              flags | __GFP_NOTRACE);
> +
> +               kmemtrace_mark_alloc(KMEMTRACE_KIND_KERNEL, _THIS_IP_, ret,
> +                                    size, malloc_sizes[i].cs_size, flags);
> +
> +               return ret;

I think this would be cleaner if you'd simply add a new
__kmem_cache_alloc() entry point in SLAB that takes the "kind" as an
argument. That way you wouldn't have to play tricks with GFP flags.
