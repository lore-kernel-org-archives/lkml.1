Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZC0UYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZC0UYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760136AbZC0UYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:24:37 -0400
Received: from THUNK.ORG ([69.25.196.29]:45714 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761547AbZC0UYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/3] block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
Date: Fri, 27 Mar 2009 16:24:29 -0400
Message-Id: <1238185471-31152-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1238185471-31152-1-git-send-email-tytso@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing synchronous writes because wbc->sync_mode is set to
WBC_SYNC_ALL, send the write request using WRITE_SYNC, so that we
don't unduly block system calls such as fsync().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/buffer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 891e1c7..e7ebd95 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1714,6 +1714,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
@@ -1805,7 +1806,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1859,7 +1860,7 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(WRITE, bh);
+			submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
-- 
1.5.6.3

