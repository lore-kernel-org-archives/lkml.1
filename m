Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXDTLFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXDTLFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXDTLFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:05:20 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:53270 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbXDTLFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:05:19 -0400
Date: Fri, 20 Apr 2007 12:05:17 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       shaggy@linux.vnet.ibm.com
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher order pages
Message-ID: <20070420110516.GC12075@skynet.ie>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/04/07 09:35), Christoph Lameter didst pronounce:
> Variable Order Page Cache: Fixup fallback functions
> 
> Fixup the fallback function in fs/libfs.c to be able to handle
> higher order page cache pages.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  fs/libfs.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.21-rc7/fs/libfs.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/fs/libfs.c	2007-04-18 21:52:49.000000000 -0700
> +++ linux-2.6.21-rc7/fs/libfs.c	2007-04-18 21:54:51.000000000 -0700
> @@ -320,8 +320,8 @@ int simple_rename(struct inode *old_dir,
>  
>  int simple_readpage(struct file *file, struct page *page)
>  {
> -	clear_highpage(page);
> -	flush_dcache_page(page);
> +	clear_mapping_page(file->f_mapping, page);
> +	flush_mapping_page(file->f_mapping, page);

right, I think it would be easier to read if patches 3 and 4 were
merged. Personal preference, feel free to ignore

>  	SetPageUptodate(page);
>  	unlock_page(page);
>  	return 0;
> @@ -331,11 +331,15 @@ int simple_prepare_write(struct file *fi
>  			unsigned from, unsigned to)
>  {
>  	if (!PageUptodate(page)) {
> -		if (to - from != PAGE_CACHE_SIZE) {
> +		if (to - from != page_cache_size(file->f_mapping)) {
> +			/*
> +			 * Mapping to higher order pages need to be supported
> +			 * if higher order pages can be in highmem
> +			 */

comments about missing page_cache_size() covered elsewhere. However, I
note that Dave Kleikamp might be interested in this changing of
page_cache_size() from the perspective of page cache tails. I've added
him to the cc so he can take a quick look.

>  			void *kaddr = kmap_atomic(page, KM_USER0);
>  			memset(kaddr, 0, from);
> -			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> -			flush_dcache_page(page);
> +			memset(kaddr + to, 0, page_cache_size(file->f_mapping) - to);
> +			flush_mapping_page(file->f_mapping, page);
>  			kunmap_atomic(kaddr, KM_USER0);
>  		}
>  	}
> @@ -346,7 +350,7 @@ int simple_commit_write(struct file *fil
>  			unsigned from, unsigned to)
>  {
>  	struct inode *inode = page->mapping->host;
> -	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
> +	loff_t pos = ((loff_t)page->index << page_cache_shift(file->f_mapping)) + to;
>  
>  	if (!PageUptodate(page))
>  		SetPageUptodate(page);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
