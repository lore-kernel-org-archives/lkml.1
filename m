Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXBSOdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXBSOdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbXBSOdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:33:49 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:45783 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbXBSOds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:33:48 -0500
To: linux-kernel@vger.kernel.org
CC: devel@openvz.org
Subject: [PATCH] ecryptfs lower_file handling issues 
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Mon, 19 Feb 2007 17:34:13 +0300
Message-ID: <87wt2ew716.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


1)Function ecryptfs_do_readpage() calls flush_dcache_page(lower_page),
  but lower_page was't changed here. So remove this line.

2)prepare_write ret val was ignored in ecryptfs_write_inode_size_to_header().
If error happends we can't call commit_write, just do cleanup and fial.
It is issue easy to reproduce with full lower_fs, in this case prepare_write()
will return ENOSPC.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------------

--=-=-=
Content-Disposition: inline; filename=diff-mm-ecryptfs-mmap-fix-2_6_20-mm2

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 1e5d2ba..0cebb75 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -238,7 +238,6 @@ int ecryptfs_do_readpage(struct file *file, struct page *page,
 	lower_page_data = kmap_atomic(lower_page, KM_USER1);
 	memcpy(page_data, lower_page_data, PAGE_CACHE_SIZE);
 	kunmap_atomic(lower_page_data, KM_USER1);
-	flush_dcache_page(lower_page);
 	kunmap_atomic(page_data, KM_USER0);
 	flush_dcache_page(page);
 	rc = 0;
@@ -454,6 +453,12 @@ static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	}
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
+	if (rc) {
+		ecryptfs_printk(KERN_ERR, "Error preparing header page "
+			"write\n");
+		ecryptfs_release_lower_page(header_page);
+		goto out;
+	}
 	file_size = (u64)i_size_read(inode);
 	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
 	file_size = cpu_to_be64(file_size);

--=-=-=--

