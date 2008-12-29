Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYL2UqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYL2UqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYL2UqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:46:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYL2Up7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:45:59 -0500
Date: Mon, 29 Dec 2008 12:45:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] exofs: address_space_operations
Message-Id: <20081229124514.71d29ae0.akpm@linux-foundation.org>
In-Reply-To: <4947C7BD.2050407@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C7BD.2050407@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:22:37 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> OK Now we start to read and write from osd-objects, page-by-page.
> The page index is the object's offset.
> 
>
> ...
>
> +/*
> + * Callback function when writepage finishes.  Check for errors, unlock, clean
> + * up, etc.
> + */
> +void writepage_done(struct osd_request *req, void *p)
> +{
> +	int ret;
> +	struct page *page = (struct page *)p;

unneeded cast

> +	struct inode *inode = page->mapping->host;
> +	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
> +
> +	ret = check_ok(req);
> +	free_osd_req(req);
> +	atomic_dec(&sbi->s_curr_pending);
> +
> +	if (ret) {
> +		if (ret == -ENOSPC)
> +			set_bit(AS_ENOSPC, &page->mapping->flags);
> +		else
> +			set_bit(AS_EIO, &page->mapping->flags);
> +
> +		SetPageError(page);
> +	}
> +
> +	end_page_writeback(page);
> +	unlock_page(page);
> +}
> +
> +/*
> + * Write a page to disk.  page->index gives us the page number.  The page is
> + * locked before this function is called.  We write asynchronously and then the
> + * callback function (writepage_done) is called.  We signify that the operation
> + * has completed by unlocking the page and calling end_page_writeback().
> + */
> +static int exofs_writepage(struct page *page, struct writeback_control *wbc)
> +{
> +	struct inode *inode = page->mapping->host;
> +	struct exofs_i_info *oi = EXOFS_I(inode);
> +	loff_t i_size = i_size_read(inode);
> +	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
> +	unsigned offset = 0;
> +	struct osd_request *req = NULL;
> +	struct exofs_sb_info *sbi;
> +	uint64_t start;
> +	uint64_t len = PAGE_CACHE_SIZE;
> +	unsigned char *kaddr;
> +	int ret = 0;
> +
> +	if (!PageLocked(page))
> +		BUG();

Could use BUG_ON(!PageLocked)

> +	/* if the object has not been created, and we are not in sync mode,
> +	 * just return.  otherwise, wait. */
> +	if (!ObjCreated(oi)) {
> +		if (!Obj2BCreated(oi))
> +			BUG();

BUG_ON()?

> +		if (wbc->sync_mode == WB_SYNC_NONE) {
> +			redirty_page_for_writepage(wbc, page);
> +			unlock_page(page);
> +			ret = 0;
> +			goto out;
> +		} else {
> +			wait_event(oi->i_wq, ObjCreated(oi));
> +		}
> +	}
> +
> +	/* in this case, the page is within the limits of the file */
> +	if (page->index < end_index)
> +		goto do_it;
> +
> +	offset = i_size & (PAGE_CACHE_SIZE - 1);
> +	len = offset;
> +
> +	/*in this case, the page is outside the limits (truncate in progress)*/
> +	if (page->index >= end_index + 1 || !offset) {
> +		unlock_page(page);
> +		goto out;
> +	}
> +
> +do_it:
> +	BUG_ON(PageWriteback(page));
> +	set_page_writeback(page);
> +	start = page->index << PAGE_CACHE_SHIFT;
> +	sbi = inode->i_sb->s_fs_info;
> +
> +	kaddr = page_address(page);
> +
> +	req = prepare_osd_write(sbi->s_dev, sbi->s_pid,
> +			      inode->i_ino + EXOFS_OBJ_OFF, len, start, 0,
> +			      kaddr);

Does prepare_osd_write() modify the memory at *kaddr?  If so, does it
do the needed flush_dcache_page()?

> +                           
> +	if (!req) {
> +		printk(KERN_ERR "ERROR: writepage failed.\n");
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	oi->i_commit_size = min_t(uint64_t, oi->i_commit_size, len + start);
> +
> +	ret = exofs_async_op(req, writepage_done, (void *)page, oi->i_cred);
> +	if (ret) {
> +		free_osd_req(req);
> +		goto fail;
> +	}
> +	atomic_inc(&sbi->s_curr_pending);
> +out:
> +	return ret;
> +fail:
> +	set_bit(AS_EIO, &page->mapping->flags);
> +	end_page_writeback(page);
> +	unlock_page(page);
> +	goto out;
> +}
> +
> +/*
> + * Callback for readpage
> + */
> +int __readpage_done(struct osd_request *req, void *p, int unlock)
> +{
> +	struct page *page = (struct page *)p;

unneeded cast.

> +	struct inode *inode = page->mapping->host;
> +	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
> +	int ret;
> +
> +	ret = check_ok(req);
> +	free_osd_req(req);
> +	atomic_dec(&sbi->s_curr_pending);
> +
> +	if (ret == 0) {
> +
> +		/* Everything is OK */
> +		SetPageUptodate(page);
> +		if (PageError(page))
> +			ClearPageError(page);
> +	} else if (ret == -EFAULT) {
> +		char *kaddr;
> +
> +		/* In this case we were trying to read something that wasn't on
> +		 * disk yet - return a page full of zeroes.  This should be OK,
> +		 * because the object should be empty (if there was a write
> +		 * before this read, the read would be waiting with the page
> +		 * locked */
> +		kaddr = page_address(page);
> +		memset(kaddr, 0, PAGE_CACHE_SIZE);

There is I think a missing flsh_dcache_page() here.  Use of the
(somewhat misnamed) zero_user() would be an appropriate fix and
cleanup.

> +		SetPageUptodate(page);
> +		if (PageError(page))
> +			ClearPageError(page);
> +	} else /* Error */
> +		SetPageError(page);
> +
> +	if (unlock)
> +		unlock_page(page);
> +
> +	return ret;
> +}
> +
> +void readpage_done(struct osd_request *req, void *p)
> +{
> +	__readpage_done(req, p, true);
> +}
> +
> +/*
> + * Read a page from the OSD
> + */
> +static int __readpage_filler(struct page *page, bool is_async_unlock)
> +{
> +	struct osd_request *req = NULL;
> +	struct inode *inode = page->mapping->host;
> +	struct exofs_i_info *oi = EXOFS_I(inode);
> +	ino_t ino = inode->i_ino;
> +	loff_t i_size = i_size_read(inode);
> +	loff_t i_start = page->index << PAGE_CACHE_SHIFT;
> +	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;

Using pgoff_t for this would have some small documentation benefit.

> +	struct super_block *sb = inode->i_sb;
> +	struct exofs_sb_info *sbi = sb->s_fs_info;
> +	uint64_t amount;
> +	unsigned char *kaddr;
> +	int ret = 0;
> +
> +	if (!PageLocked(page))
> +		BUG();

BUG_ON?

> +	if (PageUptodate(page))
> +		goto out;
> +
> +	if (page->index < end_index)
> +		amount = PAGE_CACHE_SIZE;
> +	else
> +		amount = i_size & (PAGE_CACHE_SIZE - 1);
> +
> +	/* this will be out of bounds, or doesn't exist yet */
> +	if ((page->index >= end_index + 1) || !ObjCreated(oi) || !amount
> +	    /*|| (i_start >= oi->i_commit_size)*/) {
> +		kaddr = kmap_atomic(page, KM_USER0);
> +		memset(kaddr, 0, PAGE_CACHE_SIZE);
> +		flush_dcache_page(page);
> +		kunmap_atomic(page, KM_USER0);

There's a flush_dcache_page() ;)

Could use clear_highpage() here.

> +		SetPageUptodate(page);
> +		if (PageError(page))
> +			ClearPageError(page);
> +		if (is_async_unlock)
> +			unlock_page(page);
> +		goto out;
> +	}
> +
> +	if (amount != PAGE_CACHE_SIZE) {
> +		kaddr = kmap_atomic(page, KM_USER0);
> +		memset(kaddr + amount, 0, PAGE_CACHE_SIZE - amount);
> +		flush_dcache_page(page);
> +		kunmap_atomic(page, KM_USER0);

Use zero_user()?

> +	}
> +
> +	kaddr = page_address(page);
> +
> +	req = prepare_osd_read(sbi->s_dev, sbi->s_pid, ino + EXOFS_OBJ_OFF,
> +			       amount, i_start, 0, kaddr);

flush_dcache_page()?

> +	if (!req) {
> +		printk(KERN_ERR "ERROR: readpage failed.\n");
> +		ret = -ENOMEM;
> +		unlock_page(page);
> +		goto out;
> +	}
> +
> +	atomic_inc(&sbi->s_curr_pending);
> +	if (!is_async_unlock) {
> +		exofs_sync_op(req, sbi->s_timeout, oi->i_cred);
> +		ret = __readpage_done(req, page, false);
> +	} else {
> +		ret = exofs_async_op(req, readpage_done, page, oi->i_cred);
> +		if (ret) {
> +			free_osd_req(req);
> +			unlock_page(page);
> +			atomic_dec(&sbi->s_curr_pending);
> +		}
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +static int readpage_filler(struct page *page)
> +{
> +	int ret = __readpage_filler(page, true);
> +
> +	return ret;
> +}
> +
> +/*
> + * We don't need the file
> + */
> +static int exofs_readpage(struct file *file, struct page *page)
> +{
> +	return readpage_filler(page);
> +}
> +
> +/*
> + * We don't need the data
> + */
> +static int readpage_strip(void *data, struct page *page)
> +{
> +	return readpage_filler(page);
> +}
> +
> +/*
> + * read a bunch of pages - usually for readahead
> + */
> +static int exofs_readpages(struct file *file, struct address_space *mapping,
> +			   struct list_head *pages, unsigned nr_pages)
> +{
> +	return read_cache_pages(mapping, pages, readpage_strip, NULL);
> +}
> +
> +struct address_space_operations exofs_aops = {

const.

> +	.readpage	= exofs_readpage,
> +	.readpages	= exofs_readpages,
> +	.writepage	= exofs_writepage,
> +	.write_begin	= exofs_write_begin_export,
> +	.write_end	= simple_write_end,
> +	.writepages	= generic_writepages,
> +};

