Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZIKSu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZIKSu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZIKSuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:50:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZIKSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:40 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
In-Reply-To: <20090911848.933193846@firstfloor.org>
To: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/21] HWPOISON: shmem: call set_page_dirty() with locked page
Message-Id: <20090911184843.32078B1757@basil.firstfloor.org>
Date: Fri, 11 Sep 2009 20:48:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

The dirtying of page and set_page_dirty() can be moved into the page lock.

- In shmem_write_end(), the page was dirtied while the page lock was held,
  but it's being marked dirty just after dropping the page lock.
- In shmem_symlink(), both dirtying and marking can be moved into page lock.

It's valuable for the hwpoison code to know whether one bad page can be dropped
without losing data. It mainly judges by testing the PG_dirty bit after taking
the page lock. So it becomes important that the dirtying of page and the
marking of dirtiness are both done inside the page lock. Which is a common
practice, but sadly not a rule.

The noticeable exceptions are
- mapped pages
- pages with buffer_heads
The above pages could go dirty at any time. Fortunately the hwpoison will
unmap the page and release the buffer_heads beforehand anyway.

Many other types of pages (eg. metadata pages) can also be dirtied at will by
their owners, the hwpoison code cannot do meaningful things to them anyway. 
Only the dirtiness of pagecache pages owned by regular files are interested.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/mm/shmem.c
===================================================================
--- linux.orig/mm/shmem.c
+++ linux/mm/shmem.c
@@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
-	unlock_page(page);
 	set_page_dirty(page);
+	unlock_page(page);
 	page_cache_release(page);
 
 	return copied;
@@ -1968,13 +1968,13 @@ static int shmem_symlink(struct inode *d
 			iput(inode);
 			return error;
 		}
-		unlock_page(page);
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
 		kunmap_atomic(kaddr, KM_USER0);
 		set_page_dirty(page);
+		unlock_page(page);
 		page_cache_release(page);
 	}
 	if (dir->i_mode & S_ISGID)
