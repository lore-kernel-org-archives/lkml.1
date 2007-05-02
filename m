Return-Path: <linux-kernel-owner+w=401wt.eu-S1946156AbXEBA0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946156AbXEBA0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161717AbXEBA0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:26:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946169AbXEBA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:26:48 -0400
Date: Tue, 1 May 2007 17:26:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Message-Id: <20070501172643.270bb061.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
	<a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
	<Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 00:04:31 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> 
> Replace open-coded kmap_atomic() and kunmap_atomic()
> surrounding two memory clear operations with zero_user_page(), as both
> memory operations act on the same page.
> 
> Cc: Nate Diller <nate.diller@gmail.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  fs/buffer.c |   29 ++++++++++-------------------
>  fs/libfs.c  |   10 +++++-----
>  2 files changed, 15 insertions(+), 24 deletions(-)
> 
> Index: linux-2.6.21-rc7-mm2/fs/buffer.c
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/fs/buffer.c	2007-04-27 22:51:27.000000000 -0700
> +++ linux-2.6.21-rc7-mm2/fs/buffer.c	2007-04-29 23:58:48.000000000 -0700
> @@ -1796,19 +1796,12 @@ static int __block_prepare_write(struct 
>  					set_buffer_uptodate(bh);
>  					continue;
>  				}
> -				if (block_end > to || block_start < from) {
> -					void *kaddr;
> -
> -					kaddr = kmap_atomic(page, KM_USER0);
> -					if (block_end > to)
> -						memset(kaddr+to, 0,
> -							block_end-to);
> -					if (block_start < from)
> -						memset(kaddr+block_start,
> -							0, from-block_start);
> -					flush_dcache_page(page);
> -					kunmap_atomic(kaddr, KM_USER0);
> -				}
> +				if (block_end > to)
> +					zero_user_page(page, to,
> +						block_end - to, KM_USER0);
> +				if (block_start < from)
> +					zero_user_page(page, block_start,
> +						from - block_start, KM_USER0);
>  				continue;
>  			}
>  		}
> @@ -2224,7 +2217,6 @@ int nobh_prepare_write(struct page *page
>  	unsigned block_in_page;
>  	unsigned block_start;
>  	sector_t block_in_file;
> -	char *kaddr;
>  	int nr_reads = 0;
>  	int i;
>  	int ret = 0;
> @@ -2264,13 +2256,12 @@ int nobh_prepare_write(struct page *page
>  		if (PageUptodate(page))
>  			continue;
>  		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
> -			kaddr = kmap_atomic(page, KM_USER0);
>  			if (block_start < from)
> -				memset(kaddr+block_start, 0, from-block_start);
> +				zero_user_page(page, block_start,
> +					from - block_start, KM_USER0);
>  			if (block_end > to)
> -				memset(kaddr + to, 0, block_end - to);
> -			flush_dcache_page(page);
> -			kunmap_atomic(kaddr, KM_USER0);
> +				zero_user_page(page, to,
> +					block_end - to, KM_USER0);
>  			continue;
>  		}
>  		if (buffer_uptodate(&map_bh))
> Index: linux-2.6.21-rc7-mm2/fs/libfs.c
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/fs/libfs.c	2007-04-27 22:51:27.000000000 -0700
> +++ linux-2.6.21-rc7-mm2/fs/libfs.c	2007-04-27 22:55:12.000000000 -0700
> @@ -338,11 +338,11 @@ int simple_prepare_write(struct file *fi
>  {
>  	if (!PageUptodate(page)) {
>  		if (to - from != PAGE_CACHE_SIZE) {
> -			void *kaddr = kmap_atomic(page, KM_USER0);
> -			memset(kaddr, 0, from);
> -			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> -			flush_dcache_page(page);
> -			kunmap_atomic(kaddr, KM_USER0);
> +			if (from)
> +				zero_user_page(page, 0, from, KM_USER0);
> +			if (to < PAGE_CACHE_SIZE)
> +				zero_user_page(page, to,
> +					PAGE_CACHE_SIZE - to, KM_USER0);
>  		}
>  	}
>  	return 0;

As Satyam said, this will sometimes cause us to map and unmap the page
twice, and to run flush_dcache_page() twice.  In not-terribly-uncommon
circumstances in very frequently called functions.

Doesn't seem worth it to me.
