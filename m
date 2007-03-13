Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbXCMAI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbXCMAI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXCMAI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:08:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40446 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752918AbXCMAI6 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:08:58 -0400
Date: Tue, 13 Mar 2007 11:08:29 +1100
From: Timothy Shimmin <tes@sgi.com>
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com,
       akpm@osdl.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: stop using kmalloc in xfs_buf_get_noaddr
Message-ID: <73E41C01F3C8F79AD31CEDAF@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070309115511.GA20426@lst.de>
References: <20070307101324.GC30587@lst.de> <20070309115511.GA20426@lst.de>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

--On 9 March 2007 12:55:11 PM +0100 Christoph Hellwig <hch@lst.de> wrote:

> Ed Cashin found a bug in the error handling code for the case where
> a page allocation fails.  Here's the updated version:
>
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-03-08 19:08:38.000000000 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2007-03-09 08:59:15.000000000 +0100
....
> +	for (i = 0; i < page_count; i++) {
> +		bp->b_pages[i] = alloc_page(GFP_KERNEL);
> +		if (!bp->b_pages[i])
> +			goto fail_free_mem;
> +	}
> +	bp->b_flags |= _XBF_PAGES;
> +
> +	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
> +	if (unlikely(error)) {
> +		printk(KERN_WARNING "%s: failed to map pages\n",
> +				__FUNCTION__);
>  		goto fail_free_mem;
> -	bp->b_flags |= _XBF_KMEM_ALLOC;
> +	}
>
>  	xfs_buf_unlock(bp);
>
>  	XB_TRACE(bp, "no_daddr", data);
>  	return bp;
> +
>   fail_free_mem:
> -	kmem_free(data, malloc_len);
> + 	for ( ; i >= 0; i--)
> +		__free_page(bp->b_pages[i]);
>   fail_free_buf:
>  	xfs_buf_free(bp);
>   fail:

It looks like you might need: for (i--; i >= 0; i--)
(or: for (j = 0; j < i; j++) etc.)

Because if the initial alloc_page loop goes to completion then:
  i == pagecount
and if alloc_page loop terminates early then
  bp->b_pages[i] == NULL
So we have gone 1 too far in both cases and need to
start free'ing back one.
Unless I missed something.

--Tim



