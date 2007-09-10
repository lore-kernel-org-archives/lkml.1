Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXIJKcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXIJKcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXIJKb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:31:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60701 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbXIJKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:31:57 -0400
Date: Mon, 10 Sep 2007 19:33:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: dushistov@mail.ru, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [33/35] changes in UFS
Message-Id: <20070910193320.b46c99f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes  page->mapping handling in UFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/ufs/dir.c  |   10 +++++-----
 fs/ufs/util.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/ufs/dir.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ufs/dir.c
+++ test-2.6.23-rc4-mm1/fs/ufs/dir.c
@@ -42,7 +42,7 @@ static inline int ufs_match(struct super
 
 static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *dir = mapping->host;
 	int err = 0;
 
@@ -95,7 +95,7 @@ void ufs_set_link(struct inode *dir, str
 	int err;
 
 	lock_page(page);
-	err = __ufs_write_begin(NULL, page->mapping, pos, len,
+	err = __ufs_write_begin(NULL, page_mapping_cache(page), pos, len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	BUG_ON(err);
 
@@ -111,7 +111,7 @@ void ufs_set_link(struct inode *dir, str
 
 static void ufs_check_page(struct page *page)
 {
-	struct inode *dir = page->mapping->host;
+	struct inode *dir = page_inode(page);
 	struct super_block *sb = dir->i_sb;
 	char *kaddr = page_address(page);
 	unsigned offs, rec_len;
@@ -381,7 +381,7 @@ int ufs_add_link(struct dentry *dentry, 
 got_it:
 	pos = page_offset(page) +
 			(char*)de - (char*)page_address(page);
-	err = __ufs_write_begin(NULL, page->mapping, pos, rec_len,
+	err = __ufs_write_begin(NULL, page_mapping_cache(page), pos, rec_len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
@@ -518,7 +518,7 @@ int ufs_delete_entry(struct inode *inode
 		     struct page * page)
 {
 	struct super_block *sb = inode->i_sb;
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	unsigned to = ((char*)dir - kaddr) + fs16_to_cpu(sb, dir->d_reclen);
Index: test-2.6.23-rc4-mm1/fs/ufs/util.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/ufs/util.c
+++ test-2.6.23-rc4-mm1/fs/ufs/util.c
@@ -263,7 +263,7 @@ struct page *ufs_get_locked_page(struct 
 
 		lock_page(page);
 
-		if (unlikely(page->mapping == NULL)) {
+		if (unlikely(!page_is_pagecache(page))) {
 			/* Truncate got there first */
 			unlock_page(page);
 			page_cache_release(page);

