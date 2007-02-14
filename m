Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbXBNA0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbXBNA0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXBNA0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:26:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbXBNA0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:26:37 -0500
Date: Tue, 13 Feb 2007 16:26:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       ericvh@gmail.com
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
Message-Id: <20070213162625.0797d156.akpm@linux-foundation.org>
In-Reply-To: <11714109311262-git-send-email-ericvh@gmail.com>
References: <11714109311262-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 17:55:31 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
> +static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
> +{
> +	char *buffer = NULL;
> +	struct address_space *mapping = page->mapping;
> +	int retval = -EIO;
> +	loff_t offset = 0;
> +	loff_t pageoffset = 0;
> +	unsigned long end_index;

Cosmetic detail: pgoff_t here.

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
> +	/* get buffer */
> +	buffer = kmap(page) + pageoffset;

kmap_atomic() is faster and less deadlocky.  But presumably v9fs_write()
prevents that.

> +	offset = ((loff_t) page->index << PAGE_CACHE_SHIFT) + pageoffset;
> +
> +	page_cache_get(page);
> +
> +	retval = v9fs_write(filp, NULL, buffer, count, &offset);
> +
> +	if (retval < 0) {
> +		dprintk(DEBUG_ERROR, "error: %d\n", retval);
> +		ClearPageUptodate(page);
> +		goto UnmapPage;
> +	}

I think you'll find that the ->writepage() caller handles all this.  The
callers also set AS_EIO, which this code forgot.

> +	if (retval < count) {
> +		dprintk(DEBUG_ERROR, "Short write\n");
> +	}
> +
> +	if (offset > inode->i_size) {
> +		inode->i_size = offset;
> +	}

Can this happen??

If so, mark_inode_dirty() seems to be missing.

> +	if (PageError(page))
> +		ClearPageError(page);

Is this needed?

> +	SetPageUptodate(page);

I'd expect that v9fs_writepage() is only ever called against uptodate pages?

> +	retval = 0;
> +
> +      UnmapPage:
>  	kunmap(page);
> +      UnlockPage:
>  	unlock_page(page);
> +	page_cache_release(page);
> +
>  	return retval;
>  }
