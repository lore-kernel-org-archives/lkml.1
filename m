Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbXKGJaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbXKGJaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbXKGJ3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:29:44 -0500
Received: from saeurebad.de ([85.214.36.134]:42031 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbXKGJ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:29:43 -0500
Date: Wed, 7 Nov 2007 10:28:22 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 12/23] SLUB: Trigger defragmentation from memory reclaim
Message-ID: <20071107092822.GC6243@cataract>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	akpm@linux-foundatin.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
References: <20071107011130.382244340@sgi.com> <20071107011229.423714790@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107011229.423714790@sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Tue, Nov 06, 2007 at 05:11:42PM -0800, Christoph Lameter wrote:
> Index: linux-2.6/include/linux/slab.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slab.h	2007-11-06 12:37:51.000000000 -0800
> +++ linux-2.6/include/linux/slab.h	2007-11-06 12:53:40.000000000 -0800
> @@ -63,6 +63,7 @@ void kmem_cache_free(struct kmem_cache *
>  unsigned int kmem_cache_size(struct kmem_cache *);
>  const char *kmem_cache_name(struct kmem_cache *);
>  int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
> +int kmem_cache_defrag(int node);

The definition in slab.c always returns 0.  Wouldn't a static inline
function in the header be better?


>   * Returns the number of slab objects which we shrunk.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   */
>  unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> -                       unsigned long lru_pages)
> +                       unsigned long lru_pages, struct zone *zone)
>  {
>         struct shrinker *shrinker;
>         unsigned long ret = 0;
> @@ -210,6 +218,8 @@ unsigned long shrink_slab(unsigned long
>                 shrinker->nr += total_scan;
>         }
>         up_read(&shrinker_rwsem);
> +       if (gfp_mask & __GFP_FS)
> +               kmem_cache_defrag(zone ? zone_to_nid(zone) : -1);
>         return ret;
>  }

What about the objects that kmem_cache_defrag() releases?  Shouldn't
they be counted too?

     ret += kmem_cache_defrag(...)

Or am I overseeing something here?

	Hannes
