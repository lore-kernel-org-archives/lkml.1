Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZLALtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZLALtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZLALtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:49:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57514 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZLALtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:49:49 -0500
Message-ID: <4B1502E3.4000304@cs.helsinki.fi>
Date: Tue, 01 Dec 2009 13:49:55 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: Q, slab, kmemleak_erase() and redzone?
References: <15109.1258733696@jrobl> <84144f020911220135l466247c5i9612386fcc30a28c@mail.gmail.com> <6801.1259046382@jrobl>
In-Reply-To: <6801.1259046382@jrobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp kirjoitti:
> Pekka Enberg:
>> We are setting an element in the per CPU array to NULL so the the
>> kmemleak code in ____cache_alloc() is safe. Red-zoning is done at the
>> _object_ which is not touched by kmemleak. Looking at the oops, it
>> does seem likely that you have a bug in your module (or in some other
>> part of the kernel).
> 
> Thanks for reply.
> In ____cache_alloc(), the variable 'ac' is assigned before
> cache_alloc_refill() call, and it is used for the parameter of
> kmemleak_erase(). The value may be changed by cache_alloc_refill(),
> isn't it?

No. The pointer returned by cpu_cache_get() is not changed by 
cache_alloc_refill(). The contents of the array might change, yes. That 
said, we should check if objp is NULL before calling kmemleak_erase(). 
Catalin?

> In this case, kmemleak_erase() receives the incorrect pointer and sets
> NULL to somewhere else which may be redzone?
> 
> How about this fix?
> If cpu_cache_get() call is heavy and we cannot ignore it when KMEMLEAK
> is disabled, then a new wrapper may be necessary.
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 71e0a1f..3f3e018 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3104,6 +3104,7 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  	} else {
>  		STATS_INC_ALLOCMISS(cachep);
>  		objp = cache_alloc_refill(cachep, flags);
> +		ac = cpu_cache_get(cachep);
>  	}
>  	/*
>  	 * To avoid a false negative, if an object that is in one of the
> 
> 
> 
> J. R. Okajima

