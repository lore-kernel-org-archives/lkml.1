Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXDKDid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXDKDid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXDKDib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:31 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:15843 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbXDKDiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=Z6Sl/msufCzYPJfAjtzhVgpHW53bly/zTdLzXlFrmZjLknc11IWg4RU+Zg/P8x/HS92jutlj4u/sMYfOTjoicDyJGl6j9rr0KhNCfJoUDR8coyZyYzqJ1kfWK8UkZfvQkccBx3dC7dla4qbBWhgZq/U94U7bD7qPXISej4W6gZc=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.58520.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 3/13] ecryptfs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ecryptfs/mmap.c linux-2.6.21-rc6-mm1-test/fs/ecryptfs/mmap.c
--- linux-2.6.21-rc6-mm1/fs/ecryptfs/mmap.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ecryptfs/mmap.c	2007-04-09 18:19:34.000000000 -0700
@@ -364,18 +364,14 @@ static int fill_zeros_to_end_of_page(str
 {
 	struct inode *inode = page->mapping->host;
 	int end_byte_in_page;
-	char *page_virt;
 
 	if ((i_size_read(inode) / PAGE_CACHE_SIZE) != page->index)
 		goto out;
 	end_byte_in_page = i_size_read(inode) % PAGE_CACHE_SIZE;
 	if (to > end_byte_in_page)
 		end_byte_in_page = to;
-	page_virt = kmap_atomic(page, KM_USER0);
-	memset((page_virt + end_byte_in_page), 0,
-	       (PAGE_CACHE_SIZE - end_byte_in_page));
-	kunmap_atomic(page_virt, KM_USER0);
-	flush_dcache_page(page);
+	zero_user_page(page, end_byte_in_page,
+		PAGE_CACHE_SIZE - end_byte_in_page);
 out:
 	return 0;
 }
@@ -740,7 +736,6 @@ int write_zeros(struct file *file, pgoff
 {
 	int rc = 0;
 	struct page *tmp_page;
-	char *tmp_page_virt;
 
 	tmp_page = ecryptfs_get1page(file, index);
 	if (IS_ERR(tmp_page)) {
@@ -757,10 +752,7 @@ int write_zeros(struct file *file, pgoff
 		page_cache_release(tmp_page);
 		goto out;
 	}
-	tmp_page_virt = kmap_atomic(tmp_page, KM_USER0);
-	memset(((char *)tmp_page_virt + start), 0, num_zeros);
-	kunmap_atomic(tmp_page_virt, KM_USER0);
-	flush_dcache_page(tmp_page);
+	zero_user_page(tmp_page, start, num_zeros);
 	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
