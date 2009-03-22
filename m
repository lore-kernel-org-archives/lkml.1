Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZCVBMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZCVBMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 21:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZCVBMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 21:12:19 -0400
Received: from thunk.org ([69.25.196.29]:35244 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZCVBMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 21:12:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC 1/2] block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
Date: Sat, 21 Mar 2009 21:12:09 -0400
Message-Id: <1237684330-11770-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237684330-11770-1-git-send-email-tytso@mit.edu>
References: <1237684330-11770-1-git-send-email-tytso@mit.edu>
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
index 3cc3a7d..4ea1bbb 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1755,6 +1755,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
@@ -1846,7 +1847,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(WRITE, bh);
+			submit_bh(write_op, bh);
 			nr_underway++;
 		}
 		bh = next;
@@ -1900,7 +1901,7 @@ recover:
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

