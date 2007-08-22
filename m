Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbXHVBgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbXHVBgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXHVBgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:36:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:50556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXHVBfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:35:48 -0400
Date: Wed, 22 Aug 2007 03:35:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] fix the max path calculation in radix-tree.c
Message-ID: <20070822013546.GB6799@wotan.suse.de>
References: <x49d4xgy8h1.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d4xgy8h1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 03:48:42PM -0400, Jeff Moyer wrote:
> Hi,
> 
> A while back, Nick Piggin introduced a patch to reduce the node memory
> usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):
> 
> -#define RADIX_TREE_MAP_SHIFT	6
> +#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
> 
> Unfortunately, he didn't take into account the fact that the
> calculation of the maximum path was based on an assumption of having
> to round up:
> 
> #define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
> 
> So, if CONFIG_BASE_SMALL is set, you will end up with a
> RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
> upshot of this is just a bit of wasted memory (one long in the
> height_to_maxindex array, an extra pre-allocated radix tree node per
> cpu, and extra stack usage in a couple of functions), but it seems
> worth getting right.
> 
> It's also worth noting that I never build with CONFIG_BASE_SMALL.
> What I did to test this was duplicate the code in a small user-space
> program and check the results of the calculations for max path and the
> contents of the height_to_maxindex array.
> 
> Cheers.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 514efb2..67c908f 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -60,7 +60,8 @@ struct radix_tree_path {
>  };
>  
>  #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
> -#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
> +#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
> +					  RADIX_TREE_MAP_SHIFT) + 1)
>  
>  static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
>  

OK, after you DIV_ROUND_UP, what is the extra 1 for? For paths, it is because
they are NULL terminated paths I guess (without remembering too hard), and for
height_to_maxindex array it is needed for 0-height trees I think. So it would
be kinda cleaner to have the _real_ MAX_PATH, and two other constants for
this array and the paths arrays (that just happen to be identical due to
implementation). Don't you think?

But that's not to nack this patch. On the contrary I think your logic is
correct, and it should be fixed. I didn't check the maths myself but I trust
you :)

