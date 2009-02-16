Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbZBPPZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbZBPPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZBPPZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:25:48 -0500
Received: from cmpxchg.org ([85.214.51.133]:53707 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZBPPZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:25:48 -0500
Date: Mon, 16 Feb 2009 16:27:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/8] slab: introduce kzfree()
Message-ID: <20090216152751.GA27520@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org> <20090216144725.572446535@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216144725.572446535@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 03:29:27PM +0100, Johannes Weiner wrote:
> kzfree() is a wrapper for kfree() that additionally zeroes the
> underlying memory before releasing it to the slab allocator.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Nick Piggin <npiggin@suse.de>
> ---
>  include/linux/slab.h |    1 +
>  mm/util.c            |   19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -127,6 +127,7 @@ int kmem_ptr_validate(struct kmem_cache 
>  void * __must_check __krealloc(const void *, size_t, gfp_t);
>  void * __must_check krealloc(const void *, size_t, gfp_t);
>  void kfree(const void *);
> +void kzfree(const void *);
>  size_t ksize(const void *);
>  
>  /*
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -129,6 +129,25 @@ void *krealloc(const void *p, size_t new
>  }
>  EXPORT_SYMBOL(krealloc);
>  
> +/**
> + * kzfree - like kfree but zero memory
> + * @p: object to free memory of
> + *
> + * The memory of the object @p points to is zeroed before freed.
> + * If @p is %NULL, kzfree() does nothing.
> + */
> +void kzfree(const void *p)
> +{
> +	size_t ks;
> +	void *mem = (void *)p;
> +
> +	if (unlikely(ZERO_OR_NULL_PTR(mem)))
> +		return;
> +	ks = ksize(mem);
> +	memset(mem, 0, ks);
> +	kfree(mem);
> +}

Sorry, please fold this delta:

--- a/mm/util.c
+++ b/mm/util.c
@@ -147,6 +147,7 @@ void kzfree(const void *p)
 	memset(mem, 0, ks);
 	kfree(mem);
 }
+EXPORT_SYMBOL(kzfree);
 
 /*
  * strndup_user - duplicate an existing string from user space
