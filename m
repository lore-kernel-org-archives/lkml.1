Return-Path: <linux-kernel-owner+w=401wt.eu-S1030724AbXBOTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030724AbXBOTT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXBOTT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:19:26 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39953 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030724AbXBOTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:19:24 -0500
Date: Thu, 15 Feb 2007 14:19:11 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH] 9p: add write-cache support to loose cache mode (take 2)
Message-ID: <20070215191911.GB14473@filer.fsl.cs.sunysb.edu>
References: <11715506591894-git-send-email-ericvh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11715506591894-git-send-email-ericvh@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 08:44:19AM -0600, Eric Van Hensbergen wrote:
...
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index bed48fa..d43d6fb 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -6,6 +6,9 @@
>   *  Copyright (C) 2005 by Eric Van Hensbergen <ericvh@gmail.com>
>   *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
>   *
> + *  Some operations based on code from fs/cifs/file.c
> + *  Copyright (C) International Business Machines  Corp., 2002,2003
> + *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License version 2
>   *  as published by the Free Software Foundation.
> @@ -41,14 +44,14 @@
>  #include "fid.h"
>  
>  /**
> - * v9fs_vfs_readpage - read an entire page in from 9P
> + * v9fs_vfs_readpage_worker - read an entire page in from 9P
>   *
>   * @file: file being read
>   * @page: structure to page
>   *
>   */
>  
> -static int v9fs_vfs_readpage(struct file *filp, struct page *page)
> +static int v9fs_vfs_readpage_worker(struct file *filp, struct page *page)
>  {
>  	char *buffer = NULL;
>  	int retval = -EIO;
> @@ -63,23 +66,21 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
>  	int total = 0;
>  	int result = 0;
>  
> -	dprintk(DEBUG_VFS, "\n");
> -
> +	page_cache_get(page);
>  	buffer = kmap(page);
>  	do {
>  		if (count < rsize)
>  			rsize = count;
>  
>  		result = v9fs_t_read(v9ses, fid, offset, rsize, &fcall);
> -
>  		if (result < 0) {
> -			printk(KERN_ERR "v9fs_t_read returned %d\n",
> -			       result);
> +			printk(KERN_ERR "v9fs_t_read returned %d\n", result);
>  
>  			kfree(fcall);
> -			goto UnmapAndUnlock;
> -		} else
> +			goto io_error;
> +		} else {
>  			offset += result;
> +		}

There are a bunch of places where you have unneeded braces.

>  
>  		memcpy(buffer, fcall->params.rread.data, result);
>  
> @@ -98,12 +99,178 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
>  	SetPageUptodate(page);
>  	retval = 0;
>  
> -UnmapAndUnlock:
> +      io_error:

Indentation...

> +	kunmap(page);
> +	page_cache_release(page);
> +	return retval;
> +}
> +
> +/**
> + * v9fs_prepare_write - prepare for mmap or page-cache I/O
> + *
> + * @file: file being read
> + * @page: structure to page
> + * @from: starting offset
> + * @to: ending offset
> + *
> + */
> +
> +int v9fs_prepare_write(struct file *file, struct page *page,
> +		       unsigned from, unsigned to)
> +{
> +	if(!PageUptodate(page)) {
> +		if (to - from != PAGE_CACHE_SIZE) {
> +			void *kaddr = kmap_atomic(page, KM_USER0);
> +			memset(kaddr, 0, from);
> +			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> +			flush_dcache_page(page);
> +			kunmap_atomic(kaddr, KM_USER0);
> +		}
> +		if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
> +			v9fs_vfs_readpage_worker(file, page);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * v9fs_commit_write - prepare for mmap or page-cache I/O
> + *
> + * @file: file being read
> + * @page: structure to page
> + * @offset: starting offset
> + * @to: ending offset
> + *
> + * TODO: Perhaps I should just do the write here?
> + */
> +
> +int v9fs_commit_write(struct file *file, struct page *page,
> +		       unsigned offset, unsigned to)
> +{
> +        struct inode *inode = page->mapping->host;
> +        loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;

whitespace

> +
> +	dprintk(DEBUG_VFS, "\n");
> +
> +	if(!PageUptodate(page))
> +		SetPageUptodate(page);
> +
> +        /*
> +	 * No need to use i_size_read() here, the i_size
> +	 * cannot change under us because we hold the i_mutex.
> +	 *
> +	 */
> +        if (pos > inode->i_size) {
> +                i_size_write(inode, pos);
> +		/* need to adjust inode on remote */
> +	}
> +        set_page_dirty(page);
> +	dprintk(DEBUG_CURRENT, "inode->size: %llx\n",inode->i_size);
> +
> +	return 0;
> +}
...

Josef "Jeff" Sipek.

-- 
Computer Science is no more about computers than astronomy is about
telescopes.
		- Edsger Dijkstra
