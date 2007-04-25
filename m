Return-Path: <linux-kernel-owner+w=401wt.eu-S1031095AbXDYPgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031095AbXDYPgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXDYPgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:36:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49732 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754099AbXDYPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:36:08 -0400
Date: Wed, 25 Apr 2007 08:36:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070425113530.GX9715@kernel.dk>
Message-ID: <Pine.LNX.4.64.0704250833240.24452@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070425113530.GX9715@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Jens Axboe wrote:

> I need this patch to actually boot the thing, or it bombs with a NULL
> deref in page_cache_size().

Yeah on 32 bit which I disabled....

> It then boots, doing a little test with 8kb ext2 quickly dies though:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address

> EIP: [<d8149519>] 0xd8149519 SS:ESP 0068:e9049d1c
> 
> That's here:
> 
>         page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
>                                 zonelist, ALLOC_WMARK_LOW|ALLOC_CPUSET);
> ->     if (page)
>                 goto got_pg;

Impossible. page is not dereferenced. Cannot cause a NULL pointer 
deference.

> which doesn't look healthy. Note that this is a 32-bit machine, I
> removed the 32-bit check (devices in this box are fine).


> 
> --- fs/libfs.c~	2007-04-25 13:30:50.000000000 +0200
> +++ fs/libfs.c	2007-04-25 13:31:00.000000000 +0200
> @@ -330,7 +330,7 @@
>  int simple_prepare_write(struct file *file, struct page *page,
>  			unsigned from, unsigned to)
>  {
> -	unsigned int page_size = page_cache_size(file->f_mapping);
> +	unsigned int page_size = page_cache_size(page->mapping);

We do a write operation on a file that has no mapping (and thus no radix 
tree etc etc)? Is that legit?
