Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXIJKRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXIJKRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXIJKRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:17:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35246 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXIJKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:17:23 -0400
Date: Mon, 10 Sep 2007 19:18:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [24/35] changes in
 MINIX FS
Message-Id: <20070910191854.a79319a0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in MINIXFS


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/minix/dir.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/minix/dir.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/minix/dir.c
+++ test-2.6.23-rc4-mm1/fs/minix/dir.c
@@ -52,7 +52,7 @@ static inline unsigned long dir_pages(st
 
 static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *dir = mapping->host;
 	int err = 0;
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
@@ -281,7 +281,8 @@ int minix_add_link(struct dentry *dentry
 
 got_it:
 	pos = (page->index >> PAGE_CACHE_SHIFT) + p - (char*)page_address(page);
-	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
+	err = __minix_write_begin(NULL,
+				page_mapping_cache(page), pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
 		goto out_unlock;
@@ -307,7 +308,7 @@ out_unlock:
 
 int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = page_address(page);
 	loff_t pos = page_offset(page) + (char*)de - kaddr;
@@ -431,7 +432,7 @@ not_empty:
 void minix_set_link(struct minix_dir_entry *de, struct page *page,
 	struct inode *inode)
 {
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = page_mapping_cache(page);
 	struct inode *dir = mapping->host;
 	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
 	loff_t pos = page_offset(page) +

