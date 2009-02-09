Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZBIXQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZBIXQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZBIXQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:16:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbZBIXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:16:32 -0500
Date: Mon, 9 Feb 2009 15:16:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David VomLehn (dvomlehn)" <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Propagate CRAMFS uncompression errors
Message-Id: <20090209151630.4d87ad13.akpm@linux-foundation.org>
In-Reply-To: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
References: <FF038EB85946AA46B18DFEE6E6F8A2899507E0@xmb-rtp-218.amer.cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 21:55:29 -0500
"David VomLehn (dvomlehn)" <dvomlehn@cisco.com> wrote:

> If cramfs_uncompress_block detects an error uncompressing it will
> return a zero value. This patch checks the return value and propagates
> the error back up to the block layer.
> 
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  fs/cramfs/inode.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index a07338d..6ff8a5e 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -493,7 +493,15 @@ static int cramfs_readpage(struct file *file,
> struct page * page)

Your email client is wordwrapping the patches.

>  	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE -
> bytes_filled);
>  	kunmap(page);
>  	flush_dcache_page(page);
> -	SetPageUptodate(page);
> +
> +	if (bytes_filled == 0) {
> +		ClearPageUptodate(page);
> +		SetPageError(page);
> +	}
> +
> +	else
> +		SetPageUptodate(page);
> +
>  	unlock_page(page);
>  	return 0;

A more typical code layout would be

	if (bytes_filled == 0) {
		ClearPageUptodate(page);
		SetPageError(page);
	} else
		SetPageUptodate(page);

or (better, IMO):

	if (bytes_filled == 0) {
		ClearPageUptodate(page);
		SetPageError(page);
	} else {
		SetPageUptodate(page);
	}


This patch will incorrectly cause the driver to report an IO error if
the (page->index < maxblock) test returns false.  For example, a
pread() which is wholly outside the end-of-file should return zero, not
-EIO.

cramfs_readpage() handles this case very strangely, although not
obviously buggily.  Probably this function never even gets called for a
read wholly outside i_size.

How does this version look to you?

--- a/fs/cramfs/inode.c~propagate-cramfs-uncompression-errors
+++ a/fs/cramfs/inode.c
@@ -488,12 +488,19 @@ static int cramfs_readpage(struct file *
 				 compr_len);
 			mutex_unlock(&read_mutex);
 		}
-	} else
-		pgdata = kmap(page);
-	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
+
+		if (bytes_filled == 0) {
+			/* Decompression error */
+			ClearPageUptodate(page);
+			SetPageError(page);
+		} else {
+			memset(pgdata + bytes_filled, 0,
+					PAGE_CACHE_SIZE - bytes_filled);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+		kunmap(page);
+	}
 	unlock_page(page);
 	return 0;
 }
_

After applying, this is what we have:

static int cramfs_readpage(struct file *file, struct page * page)
{
	struct inode *inode = page->mapping->host;
	u32 maxblock, bytes_filled;
	void *pgdata;

	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
	bytes_filled = 0;
	if (page->index < maxblock) {
		struct super_block *sb = inode->i_sb;
		u32 blkptr_offset = OFFSET(inode) + page->index*4;
		u32 start_offset, compr_len;

		start_offset = OFFSET(inode) + maxblock*4;
		mutex_lock(&read_mutex);
		if (page->index)
			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
		mutex_unlock(&read_mutex);
		pgdata = kmap(page);
		if (compr_len == 0)
			; /* hole */
		else if (compr_len > (PAGE_CACHE_SIZE << 1))
			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
		else {
			mutex_lock(&read_mutex);
			bytes_filled = cramfs_uncompress_block(pgdata,
				 PAGE_CACHE_SIZE,
				 cramfs_read(sb, start_offset, compr_len),
				 compr_len);
			mutex_unlock(&read_mutex);
		}

		if (bytes_filled == 0) {
			/* Decompression error */
			ClearPageUptodate(page);
			SetPageError(page);
		} else {
			memset(pgdata + bytes_filled, 0,
					PAGE_CACHE_SIZE - bytes_filled);
			flush_dcache_page(page);
			SetPageUptodate(page);
		}
		kunmap(page);
	}
	unlock_page(page);
	return 0;
}

