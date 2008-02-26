Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbYBZHrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbYBZHrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYBZHrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:47:00 -0500
Received: from adsl-186.flex.com ([206.126.1.185]:37247 "EHLO mail.imodulo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbYBZHq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:46:59 -0500
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 02:46:59 EST
Date: Mon, 25 Feb 2008 21:36:12 -1000
From: Glen Nakamura <glen@imodulo.com>
To: linux-kernel@vger.kernel.org
Cc: w@1wt.eu
Subject: Re: PROBLEM: 2.4.36.1 hangs.
Message-ID: <20080226073612.GA29747@modulo.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223083044.GA24136@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aloha,

The "ext2_readdir() filp->f_pos fix" patch looks weird...
Perhaps the "filp->f_pos += le16_to_cpu(de->rec_len);" line should be
outside of the if statement like the indentation implies?
As it is, filp->f_pos gets corrupted if de->inode is ever zero...
This could possibly explain why I had a few strange directory
entries until I checked the filesystem with:
e2fsck -D -F -f /dev/{ext2 partition}

- glen

Here is an updated (untested) patch:

--- linux-2.4.36.orig/fs/ext2/dir.c
+++ linux-2.4.36/fs/ext2/dir.c
@@ -240,7 +240,7 @@ ext2_readdir (struct file * filp, void *
 	loff_t pos = filp->f_pos;
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
-	unsigned offset = pos & ~PAGE_CACHE_MASK;
+	unsigned int offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
@@ -258,8 +258,13 @@ ext2_readdir (struct file * filp, void *
 		ext2_dirent *de;
 		struct page *page = ext2_get_page(inode, n);
 
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			ext2_error(sb, __FUNCTION__,
+				   "bad page in #%lu",
+				   inode->i_ino);
+			filp->f_pos += PAGE_CACHE_SIZE - offset;
 			continue;
+		}
 		kaddr = page_address(page);
 		if (need_revalidate) {
 			offset = ext2_validate_entry(kaddr, offset, chunk_mask);
@@ -267,7 +272,7 @@ ext2_readdir (struct file * filp, void *
 		}
 		de = (ext2_dirent *)(kaddr+offset);
 		limit = kaddr + PAGE_CACHE_SIZE - EXT2_DIR_REC_LEN(1);
-		for ( ;(char*)de <= limit; de = ext2_next_entry(de))
+		for ( ;(char*)de <= limit; de = ext2_next_entry(de)) {
 			if (de->inode) {
 				int over;
 				unsigned char d_type = DT_UNKNOWN;
@@ -284,11 +289,12 @@ ext2_readdir (struct file * filp, void *
 					goto done;
 				}
 			}
+			filp->f_pos += le16_to_cpu(de->rec_len);
+		}
 		ext2_put_page(page);
 	}
 
 done:
-	filp->f_pos = (n << PAGE_CACHE_SHIFT) | offset;
 	filp->f_version = inode->i_version;
 	UPDATE_ATIME(inode);
 	return 0;
