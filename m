Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZKXHGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZKXHGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZKXHGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:06:32 -0500
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:60597 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZKXHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:06:32 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: Q, slab, kmemleak_erase() and redzone? 
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020911220135l466247c5i9612386fcc30a28c@mail.gmail.com>
References: <15109.1258733696@jrobl> <84144f020911220135l466247c5i9612386fcc30a28c@mail.gmail.com>
Date: Tue, 24 Nov 2009 16:06:22 +0900
Message-ID: <6801.1259046382@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka Enberg:
> We are setting an element in the per CPU array to NULL so the the
> kmemleak code in ____cache_alloc() is safe. Red-zoning is done at the
> _object_ which is not touched by kmemleak. Looking at the oops, it
> does seem likely that you have a bug in your module (or in some other
> part of the kernel).

Thanks for reply.
In ____cache_alloc(), the variable 'ac' is assigned before
cache_alloc_refill() call, and it is used for the parameter of
kmemleak_erase(). The value may be changed by cache_alloc_refill(),
isn't it?
In this case, kmemleak_erase() receives the incorrect pointer and sets
NULL to somewhere else which may be redzone?

How about this fix?
If cpu_cache_get() call is heavy and we cannot ignore it when KMEMLEAK
is disabled, then a new wrapper may be necessary.

diff --git a/mm/slab.c b/mm/slab.c
index 71e0a1f..3f3e018 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3104,6 +3104,7 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 	} else {
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
+		ac = cpu_cache_get(cachep);
 	}
 	/*
 	 * To avoid a false negative, if an object that is in one of the



J. R. Okajima
