Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbXH3BZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbXH3BZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXH3BZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:25:06 -0400
Received: from ns.suse.de ([195.135.220.2]:36543 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXH3BZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:25:05 -0400
Date: Thu, 30 Aug 2007 03:25:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] fix the max path calculation in radix-tree.c
Message-ID: <20070830012503.GB19405@wotan.suse.de>
References: <x49d4xgy8h1.fsf@segfault.boston.devel.redhat.com> <20070822013546.GB6799@wotan.suse.de> <x49r6lmkol5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r6lmkol5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 05:39:18PM -0400, Jeff Moyer wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > On Tue, Aug 21, 2007 at 03:48:42PM -0400, Jeff Moyer wrote:
> >> Hi,
> >> 
> >> A while back, Nick Piggin introduced a patch to reduce the node memory
> >> usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):
> >> 
> >> -#define RADIX_TREE_MAP_SHIFT	6
> >> +#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
> >> 
> >> Unfortunately, he didn't take into account the fact that the
> >> calculation of the maximum path was based on an assumption of having
> >> to round up:
> >> 
> >> #define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
> >> 
> >> So, if CONFIG_BASE_SMALL is set, you will end up with a
> >> RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
> >> upshot of this is just a bit of wasted memory (one long in the
> >> height_to_maxindex array, an extra pre-allocated radix tree node per
> >> cpu, and extra stack usage in a couple of functions), but it seems
> >> worth getting right.
> >> 
> >> It's also worth noting that I never build with CONFIG_BASE_SMALL.
> >> What I did to test this was duplicate the code in a small user-space
> >> program and check the results of the calculations for max path and the
> >> contents of the height_to_maxindex array.
> >> 
> >
> > OK, after you DIV_ROUND_UP, what is the extra 1 for? For paths, it is because
> > they are NULL terminated paths I guess (without remembering too hard), and for
> > height_to_maxindex array it is needed for 0-height trees I think. So it would
> > be kinda cleaner to have the _real_ MAX_PATH, and two other constants for
> > this array and the paths arrays (that just happen to be identical due to
> > implementation). Don't you think?
> >
> > But that's not to nack this patch. On the contrary I think your logic is
> > correct, and it should be fixed. I didn't check the maths myself but I trust
> > you :)
> 
> Hi, Nick,
> 
> As I said, I wasn't sure what to name the constants for the path and
> height arrays, so I just commented the +1 there.  I've been running

Hi Jeff,

That looks really nice, thanks. No complaints from me.

Acked-by: Nick Piggin <npiggin@suse.de>

> this on one of my 64bit test systems successfully for about a day,
> now.  The one code path I was concerned about was
> radix_tree_node_alloc, since the prealloc array changes size with this
> patch.  I stepped through the code by hand and it looks right to me.
> Additionally, I wrote a kprobe that would simulate the
> kmem_cache_alloc failure.  I then inserted a node at max height into
> an empty tree with preemption disabled.  I verified, using the crash
> utility, that the tree was constructed and filled in properly.
> 
> You can find the kprobe at http://people.redhat.com/jmoyer/radix-tree/.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 514efb2..d2655cb 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -60,9 +60,14 @@ struct radix_tree_path {
>  };
>  
>  #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
> -#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
> +#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
> +					  RADIX_TREE_MAP_SHIFT))
>  
> -static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
> +/*
> + * The height_to_maxindex array needs to be one deeper than the maximum
> + * path as height 0 holds only 1 entry.
> + */
> +static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH + 1] __read_mostly;
>  
>  /*
>   * Radix tree node cache.
> @@ -487,7 +492,11 @@ EXPORT_SYMBOL(radix_tree_tag_set);
>  void *radix_tree_tag_clear(struct radix_tree_root *root,
>  			unsigned long index, unsigned int tag)
>  {
> -	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
> +	/*
> +	 * The radix tree path needs to be one longer than the maximum path
> +	 * since the "list" is null terminated.
> +	 */
> +	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
>  	struct radix_tree_node *slot = NULL;
>  	unsigned int height, shift;
>  
> @@ -882,7 +891,11 @@ static inline void radix_tree_shrink(struct radix_tree_root *root)
>   */
>  void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
>  {
> -	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
> +	/*
> +	 * The radix tree path needs to be one longer than the maximum path
> +	 * since the "list" is null terminated.
> +	 */
> +	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
>  	struct radix_tree_node *slot = NULL;
>  	struct radix_tree_node *to_free;
>  	unsigned int height, shift;
