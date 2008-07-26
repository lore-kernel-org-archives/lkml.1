Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbYGZW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbYGZW3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYGZW3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 18:29:14 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52778 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYGZW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 18:29:13 -0400
Date: Sat, 26 Jul 2008 23:28:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Kel Modderman <kel@otaku42.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: tmpfs: kernel BUG at mm/shmem.c:814
In-Reply-To: <200807262210.11502.kel@otaku42.de>
Message-ID: <Pine.LNX.4.64.0807262318050.25997@blonde.site>
References: <200807262210.11502.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Kel Modderman wrote:
> 
> I am able to reproduce the triggering of BUG_ON() in shmem_delete_inode
> function of mm/shmem.c, line 814, while testing the insserv program in a dir
> on a tmpfs mount point with Linux 2.6.25.x and 2.6.26.

Outstanding bug report and steps to reproduce: thank you so much.
You should find this fixes it; though we may have some more work to
do, maybe other filesystems are surprised by readahead on directories.


[PATCH] tmpfs: fix kernel BUG in shmem_delete_inode

SuSE's insserve initscript ordering program hits kernel BUG at mm/shmem.c:814
on 2.6.26.  It's using posix_fadvise on directories, and the shmem_readpage
method added in 2.6.23 is letting POSIX_FADV_WILLNEED allocate useless pages
to a tmpfs directory, incrementing i_blocks count but never decrementing it.

Fix this by assigning shmem_aops (pointing to readpage and writepage and
set_page_dirty) only when it's needed, on a regular file or a long symlink.

Many thanks to Kel for outstanding bugreport and steps to reproduce it.

Reported-by: Kel Modderman <kel@otaku42.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---
Other filesystems... ramfs looks as if it would allocate useless pages too,
but should free them, and wouldn't BUG; are there other filesystems to be
surprised by readahead on directories?  I have not looked through yet.

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.26-git/mm/shmem.c	2008-07-26 12:33:28.000000000 +0100
+++ linux/mm/shmem.c	2008-07-26 22:46:28.000000000 +0100
@@ -1513,7 +1513,6 @@ shmem_get_inode(struct super_block *sb, 
 		inode->i_uid = current->fsuid;
 		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
-		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_generation = get_seconds();
@@ -1528,6 +1527,7 @@ shmem_get_inode(struct super_block *sb, 
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
+			inode->i_mapping->a_ops = &shmem_aops;
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
@@ -1929,6 +1929,7 @@ static int shmem_symlink(struct inode *d
 			return error;
 		}
 		unlock_page(page);
+		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
