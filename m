Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCUMVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCUMVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXCUMVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:21:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:37030 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXCUMVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Kel6uPR/nckiDVRnbo3Z6sLx1clXwzXTn2e5vO7RHMMV66k6UOKfF9OSYzSIvE5QccxTOAvP+3ulCr6pGR/j+Eodxx3Q3jjGtkxcxC/6AYl1v3PDJu0iEg2rH//XQwdf311/FsNY0pBp0l0A9QBdiwVHaPFlVGOsr7H533aZHEs=
Message-ID: <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
Date: Wed, 21 Mar 2007 14:21:16 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070321102231.7288f231.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321102231.7288f231.dada1@cosmosbay.com>
X-Google-Sender-Auth: ba850d10dda7e8ef
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> In order to avoid a cache miss in kmem_cache_free() on NUMA and reduce hot path
> length, we could exploit the following common facts.

It would be nice if you could cc me for slab patches.

On 3/21/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> -static inline void page_set_cache(struct page *page, struct kmem_cache *cache)
> +static inline void page_set_cache_slab_nodeid(struct page *page,
> +       struct kmem_cache *cache, struct slab *slab, int nodeid)
>  {
> +       page->lru.prev = (struct list_head *)slab;
> +#ifdef KEEP_NODEID_IN_PAGE
> +       page->lru.next = (struct list_head *)((long)cache + nodeid);
> +#else
>         page->lru.next = (struct list_head *)cache;
> +#endif
> +#ifdef KEEP_NODEID_IN_SLAB
> +       slab->nodeid = nodeid;
> +#endif

Can we please have a slab_get_nid() and slab_set_nid() instead which
reduces the need for #ifdefs?
