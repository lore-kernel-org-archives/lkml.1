Return-Path: <linux-kernel-owner+w=401wt.eu-S937378AbYBWIj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937378AbYBWIj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937117AbYBWIay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:30:54 -0500
Received: from 1wt.eu ([62.212.114.60]:2081 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936965AbYBWIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:30:53 -0500
Date: Sat, 23 Feb 2008 09:30:44 +0100
From: Willy Tarreau <w@1wt.eu>
To: Unknown <borg@uu3.net>
Cc: linux-kernel@vger.kernel.org, dann frazier <dannf@debian.org>
Subject: Re: PROBLEM: 2.4.36.1 hangs.
Message-ID: <20080223083044.GA24136@1wt.eu>
References: <Pine.LNX.4.64.0802221452350.5082@cube>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802221452350.5082@cube>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first, thanks for your detailed report.

On Fri, Feb 22, 2008 at 03:08:30PM +0100, Unknown wrote:
> 1) 2.4.36.1 hangs (probably during ext2_readdir())
> 
> 2) 2.4.36.1 hangs during compilation of lighttpd-1.4.18.
>    It is probably during ext2_readdir() but I cannot confirm that..
>    Currently it only happens during compilation of lighttpd-1.4.18, always
>    in the same place.
>    Kernel 2.4.36 w/ same options (make oldconfig) works fine.
> 
> Last few lines of 'strace -f make' just before hang:
> [pid 12817] open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
> [pid 12817] fstat64(3, {st_mode=S_IFDIR|0777, st_size=8192, ...}) = 0
> [pid 12817] fcntl64(3, F_SETFD, FD_CLOEXEC) = 0
> [pid 12817] getdents64(3, /* 114 entries */, 4096) = 4088
> [pid 12817] getdents64(3, /* 63 entries */, 4096) = 2424
> [pid 12817] getdents64(3,

OK, could you please try to revert the attached patch (patch -Rp1) to see if
this fixes the problem for you ? Please keep Dann and me in CC as it's not
easy to spot 2.4-related threads on LKML these days!

Thanks,
Willy

----

commit c30306fb287323591c854a0982d9fa5351859b45
Author: dann frazier <dannf@debian.org>
Date:   Mon Jan 21 17:13:06 2008 -0700

    ext2_readdir() filp->f_pos fix
    
    This is a 2.4 backport of a linux-2.6 change by Jan Blunck
    (old-2.6-bkcvs commit 2196b4744393d4f6c06fc4d63b98556d05b90933)
    
    Commit log from 2.6 follows.
    
      [PATCH] ext2_readdir() filp->f_pos fix
    
      If the whole directory is read, ext2_readdir() sets the f_pos to a multiple
      of the page size (because of the conditions of the outer for loop).  This
      sets the wrong f_pos for directory inodes on ext2 partitions with a block
      size differing from the page size.
    
    Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 58b76dd..b158e60 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -240,7 +240,7 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 	loff_t pos = filp->f_pos;
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
-	unsigned offset = pos & ~PAGE_CACHE_MASK;
+	unsigned int offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
@@ -258,8 +258,13 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
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
@@ -283,12 +288,12 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 					ext2_put_page(page);
 					goto done;
 				}
+			filp->f_pos += le16_to_cpu(de->rec_len);
 			}
 		ext2_put_page(page);
 	}
 
 done:
-	filp->f_pos = (n << PAGE_CACHE_SHIFT) | offset;
 	filp->f_version = inode->i_version;
 	UPDATE_ATIME(inode);
 	return 0;
