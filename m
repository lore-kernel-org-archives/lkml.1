Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXEaQle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXEaQle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXEaQl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:41:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbXEaQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:41:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] rd: Remove ramdisk_set_page_dirty
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<465A55E7.50904@yahoo.com.au>
	<m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
	<465A6078.6010804@yahoo.com.au> <465A6197.5010402@yahoo.com.au>
	<m1veed82mz.fsf@ebiederm.dsl.xmission.com>
	<465BB6C2.7050704@yahoo.com.au>
	<m164695hqm.fsf@ebiederm.dsl.xmission.com>
	<20070531085556.11649c70.akpm@linux-foundation.org>
Date: Thu, 31 May 2007 10:40:03 -0600
In-Reply-To: <20070531085556.11649c70.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 31 May 2007 08:55:56 -0700")
Message-ID: <m11wgx3q1o.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The generic function __set_page_dirty_buffers called by default by
set_page_dirty appears to be a correct superset of ramdisk_set_page_dirty.
So remove the specialized ramdisk version.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/rd.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index 56b2b54..26b4c6f 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -114,37 +114,10 @@ static int ramdisk_readpage(struct file *file, struct page *page)
 	return 0;
 }
 
-/*
- * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
- * want them to contribute to dirty memory accounting.
- */
-static int ramdisk_set_page_dirty(struct page *page)
-{
-	struct address_space * const mapping = page_mapping(page);
-
-	spin_lock(&mapping->private_lock);
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-
-		do {
-			set_buffer_uptodate(bh);
-			set_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
-	}
-	spin_unlock(&mapping->private_lock);
-
-	if (!TestSetPageDirty(page))
-		return 1;
-	return 0;
-}
-
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= simple_prepare_write,
 	.commit_write	= simple_commit_write,
-	.set_page_dirty	= ramdisk_set_page_dirty,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
-- 
1.5.1.1.181.g2de0

