Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbYIREaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbYIREaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYIREaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:30:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35664 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYIREaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:30:21 -0400
Date: Thu, 18 Sep 2008 14:30:19 +1000
From: Simon Horman <horms@verge.net.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Steel <jon.steel@esentire.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: segmentation fault in kimage_add_entry
Message-ID: <20080918043018.GD32516@verge.net.au>
References: <48D0067F.3020007@esentire.com> <m1d4j3g29q.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4j3g29q.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 03:21:53PM -0700, Eric W. Biederman wrote:
> From: Jonathan Steel <jon.steel@esentire.com>
> 
> A segmentation fault can occur in kimage_add_entry in kexec.c when
> loading a kernel image into memory. The fault occurs because a page is
> requested by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the
> function may actually return a page with gfp_mask GFP_HIGHUSER. The high
> mem page is returned because it was swapped with the kernel page due to
> the kernel page being a page that will shortly be copied to.
> 
> This patch ensures that kimage_alloc_page returns a page that was
> created with the correct gfp flags.
> 
> 
> I have verified the change and fixed the whitespace damage of the
> original patch.  Jonathan did a great job of tracking this down
> after he hit the problem. -- Eric
> 
> Signed-off-by: Jonathan Steel <jon.steel@esentire.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

For what it is worth: Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  kernel/kexec.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f3f0d..aef2653 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -753,8 +753,14 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  			*old = addr | (*old & ~PAGE_MASK);
>  
>  			/* The old page I have found cannot be a
> -			 * destination page, so return it.
> +			 * destination page, so return it if it's
> +			 * gfp_flags honor the ones passed in.
>  			 */
> +			if (!(gfp_mask & __GFP_HIGHMEM) &&
> +			    PageHighMem(old_page)) {
> +				kimage_free_pages(old_page);
> +				continue;
> +			}
>  			addr = old_addr;
>  			page = old_page;
>  			break;
> -- 
> 1.5.3.rc6.17.g1911
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

