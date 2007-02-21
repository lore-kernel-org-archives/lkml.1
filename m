Return-Path: <linux-kernel-owner+w=401wt.eu-S1423065AbXBUUNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423065AbXBUUNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423077AbXBUUNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:13:35 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60700 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423065AbXBUUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:13:33 -0500
Date: Wed, 21 Feb 2007 14:13:16 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dmitriy Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] eCryptfs: resolve lower page unlocking problem
Message-ID: <20070221201316.GA3762@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <87d54loqsb.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d54loqsb.fsf@sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 07:50:44PM +0300, Dmitriy Monakhov wrote:
> eCryptfs lower file handling code has several issues:
>   - Retval from prepare_write()/commit_writ() was't checked to equality 
>     to AOP_TRUNCATED_PAGE.
>   - In some places page was't unmapped and unlocked after error.

I reworked Dmitriy's patch to apply cleanly against the more recent
version in the -mm tree.

---
eCryptfs lower file handling code has several issues:
  - Retval from prepare_write()/commit_write() wasn't checked to equality
    to AOP_TRUNCATED_PAGE.
  - In some places page wasn't unmapped and unlocked after error.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/mmap.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 92a4147..09160ad 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -422,9 +422,11 @@ out:
 	return rc;
 }
 
-static void ecryptfs_release_lower_page(struct page *lower_page)
+static
+void ecryptfs_release_lower_page(struct page *lower_page, int page_locked)
 {
-	unlock_page(lower_page);
+	if (page_locked)
+		unlock_page(lower_page);
 	page_cache_release(lower_page);
 }
 
@@ -454,6 +456,13 @@ static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	}
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
+	if (rc) {
+		if (rc == AOP_TRUNCATED_PAGE)
+			ecryptfs_release_lower_page(header_page, 0);
+		else
+			ecryptfs_release_lower_page(header_page, 1);
+		goto out;
+	}
 	file_size = (u64)i_size_read(inode);
 	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
 	file_size = cpu_to_be64(file_size);
@@ -465,7 +474,10 @@ static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
-	ecryptfs_release_lower_page(header_page);
+	if (rc == AOP_TRUNCATED_PAGE)
+		ecryptfs_release_lower_page(header_page, 0);
+	else
+		ecryptfs_release_lower_page(header_page, 1);
 	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
 out:
@@ -572,7 +584,10 @@ int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
 	}
 out:
 	if (rc && (*lower_page)) {
-		ecryptfs_release_lower_page(*lower_page);
+		if (rc == AOP_TRUNCATED_PAGE)
+			ecryptfs_release_lower_page(*lower_page, 0);
+		else
+			ecryptfs_release_lower_page(*lower_page, 1);
 		(*lower_page) = NULL;
 	}
 	return rc;
@@ -588,16 +603,19 @@ ecryptfs_commit_lower_page(struct page *lower_page, struct inode *lower_inode,
 			   struct file *lower_file, int byte_offset,
 			   int region_size)
 {
+	int page_locked = 1;
 	int rc = 0;
 
 	rc = lower_inode->i_mapping->a_ops->commit_write(
 		lower_file, lower_page, byte_offset, region_size);
+	if (rc == AOP_TRUNCATED_PAGE)
+		page_locked = 0;
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR,
 				"Error committing write; rc = [%d]\n", rc);
 	} else
 		rc = 0;
-	ecryptfs_release_lower_page(lower_page);
+	ecryptfs_release_lower_page(lower_page, page_locked);
 	return rc;
 }
 
-- 
1.4.4.4

