Return-Path: <linux-kernel-owner+w=401wt.eu-S1946103AbXBPUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946103AbXBPUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946107AbXBPUMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:12:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946103AbXBPUMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:12:37 -0500
Date: Fri, 16 Feb 2007 12:12:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH] 9p: add write-cache support to loose cache mode (take
 3)
Message-Id: <20070216121226.f2382a17.akpm@linux-foundation.org>
In-Reply-To: <1171640221420-git-send-email-ericvh@gmail.com>
References: <11715506591894-git-send-email-ericvh@gmail.com>
	<1171640221420-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 09:37:01 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:

> +static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
> +{
> +	char *buffer = NULL;
> +	struct address_space *mapping = page->mapping;
> +	int retval = -EIO;
> +	loff_t offset = 0;
> +	pgoff_t end_index;
> +	int count = PAGE_CACHE_SIZE;
> +	struct file *filp = v9fs_find_file(page);
> +	struct inode *inode = mapping->host;
> +
> +	dprintk(DEBUG_VFS, "page: %p\n", page);
> +
> +	if ((!inode) || (!filp))
> +		goto UnlockPage;
> +
> +	end_index = inode->i_size >> PAGE_CACHE_SHIFT;
> +
> +	/* complicated case at end of file */
> +	if (page->index >= end_index) {
> +		/* things got complicated... */
> +		count = inode->i_size & (PAGE_CACHE_SIZE - 1);
> +		if (page->index >= end_index + 1 || !count)
> +			return 0;	/* truncated - don't care */
> +	}
> +
> +	buffer = kmap(page);
> +	offset = ((loff_t) page->index << PAGE_CACHE_SHIFT);
> +	page_cache_get(page);
> +	retval = v9fs_write(filp, NULL, buffer, count, &offset);
> +
>  	kunmap(page);
> +
> +      UnlockPage:
>  	unlock_page(page);
> +	page_cache_release(page);
> +
>  	return retval;
>  }

The page_cache_get/release here aren't needed: lock_page suffices.

Are you sure the page refcounting is right if the `goto UnlockPage'
happens?

Can that goto actually happen??
