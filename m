Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYA0GGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYA0GGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbYA0GEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:04:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbYA0GEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:46 -0500
Date: Sat, 26 Jan 2008 22:04:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRAMFS: Uncompressed files support
Message-Id: <20080126220404.5c128ca3.akpm@linux-foundation.org>
In-Reply-To: <20080122022345.GA3678@party>
References: <20080122022345.GA3678@party>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 11:23:45 +0900 Kyungmin Park <kmpark@infradead.org> wrote:
> Hi,
> 
> This patch enables the uncompressed files support in cramfs.
> 
> The word 'uncompressed file' is from linear cramfs (aka Application XIP).
> In linear cramfs, it is used to suport XIP on NOR. However it is also helpful on OneNAND. It makes a filesystem faster by removing compression overhead.
> In XIP mode it runs XIP, But non-XIP mode. It copies data to ram and runs.
> 
> In my simple test, copy busybox (compressed or uncompressed).
> It reduces the about 50% time saving from 0.40s to 0.19s.
> Yes, it incrases the file system size, but nowadays flash has big capacity.
> It's trade-off between size and performance.
> 
> Also this patch uses the page cache directly.
> In previous implementation, it used the local buffer. why?
> It's already uncompressed and fits to page size. So It uses the page directly to remove useless memory copy.
> 
> It's compatible the existing linear cramfs image and original one.
> 
> Any comments are welcome.
> 
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index 3d194a2..edba28f 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c

I don't know what kernel this is against but it generates a lot of rejects
against present mainline.

> @@ -40,6 +40,7 @@ static DEFINE_MUTEX(read_mutex);
>  #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
>  #define OFFSET(x)	((x)->i_ino)
>  
> +#define CRAMFS_INODE_IS_XIP(x)	((x)->i_mode & S_ISVTX)
>  
>  static int cramfs_iget5_test(struct inode *inode, void *opaque)
>  {
> @@ -143,8 +144,9 @@ static int next_buffer;
>  /*
>   * Returns a pointer to a buffer containing at least LEN bytes of
>   * filesystem starting at byte offset OFFSET into the filesystem.
> + * If the @pg has the page, it returns the page buffer address
>   */
> -static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned int len)
> +static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned int len, struct page **pg)
>  {
>  	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
>  	struct page *pages[BLKS_PER_BUF];
> @@ -174,6 +176,22 @@ static void *cramfs_read(struct super_block *sb, unsigned int offset, unsigned i
>  
>  	devsize = mapping->host->i_size >> PAGE_CACHE_SHIFT;
>  
> +	/*
> +	 * Use page directly either 
> +	 * - uncompressed page or
> +	 * - comprssed page which has all required data
> +	 */
> +	if (pg && offset + len <= PAGE_CACHE_SIZE) {
> +		struct page *page = NULL;
> +		page = read_mapping_page(mapping, blocknr, NULL);
> +		if (!IS_ERR(page)) {
> +			*pg = page;
> +			data = kmap(page);
> +			data += offset;
> +			return data;
> +		}
> +	}

Are you sure about the kmap/kunmap handling in this patch?  It looks like
it might be unbalanced.



