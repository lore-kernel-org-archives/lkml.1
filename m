Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbXFMNg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbXFMNg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXFMNgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:36:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59939 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXFMNgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:36:47 -0400
Date: Wed, 13 Jun 2007 14:36:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dmitriy Monakhov <dmonakhov@sw.ru>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] new aop loop fix
In-Reply-To: <20070613134631.GB13815@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com>
References: <20070613134631.GB13815@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: 
X-Brightmail-Tracker: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Dmitriy Monakhov wrote:

> 	loop.c code itself is not perfect. In fact before Nick's patch
> 	partial write was't possible. Assumption what write chunks are
> 	always page aligned is realy weird ( see "index++" line).
> 
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>

I'm interested, because I'm trying to chase down an -mm bug which
occasionally leaves me with 1k of zeroes where it shouldn't (in a
1k bsize ext2 looped over tmpfs).  The length of time for this to
happen varies a lot, so bisection has been misleading: maybe the
problem lies in Nick's patches, maybe it does not.

But I don't understand your fix below at all.  _If_ you need to
change the handling of index, then you need to change the handling
of offset too, don't you?

But what's wrong with how inded was handled anyway?  Yes, it might
be being incremented at the bottom of the loop when we haven't
reached the end of this page, but in that case we're not going
round the loop again anyway: len will now be 0.  So no problem.

One of us is missing something: please enlighten me - thanks.

Hugh

> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 4bab9b1..8726da5 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -215,7 +215,6 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
>  	int len, ret;
>  
>  	mutex_lock(&mapping->host->i_mutex);
> -	index = pos >> PAGE_CACHE_SHIFT;
>  	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
>  	bv_offs = bvec->bv_offset;
>  	len = bvec->bv_len;
> @@ -226,6 +225,7 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
>  		struct page *page;
>  		void *fsdata;
>  
> +		index = pos >> PAGE_CACHE_SHIFT;
>  		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
>  		size = PAGE_CACHE_SIZE - offset;
>  		if (size > len)
> @@ -255,7 +255,6 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
>  		bv_offs += copied;
>  		len -= copied;
>  		offset = 0;
> -		index++;
>  		pos += copied;
>  	}
>  	ret = 0;
