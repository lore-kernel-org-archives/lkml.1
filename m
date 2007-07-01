Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbXGAHnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbXGAHnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXGAHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:38:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46831 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbXGAHie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:38:34 -0400
Subject: [EXT4 set 9][PATCH 1/5]Morecleanups:ext4-zero_user_page
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Sun, 01 Jul 2007 03:38:32 -0400
Message-Id: <1183275512.4010.137.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() in ext4 where possible.


Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc4-mm2/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/inode.c
+++ linux-2.6.22-rc4-mm2/fs/ext4/inode.c
@@ -1830,7 +1830,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;

 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1847,10 +1846,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length, KM_USER0);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1903,10 +1899,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}

-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);

 	BUFFER_TRACE(bh, "zeroed end of block");



