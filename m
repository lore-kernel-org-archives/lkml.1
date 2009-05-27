Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZE0NCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZE0NCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbZE0NBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:01:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763071AbZE0NBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:01:09 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] vfs: Unmap underlying metadata of new data buffers only when buffer is mapped
Date: Wed, 27 May 2009 15:01:05 +0200
Message-Id: <1243429268-3028-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do delayed allocation of some buffer, we want to signal to VFS that
the buffer is new (set buffer_new) so that it properly zeros out everything.
But we don't have the buffer mapped yet so we cannot really unmap underlying
metadata in this state. Make VFS avoid doing unmapping of metadata when the
buffer is not yet mapped.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ddfcade..3d0bced 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1683,8 +1683,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
+						bh->b_blocknr);
 			}
 		}
 		bh = bh->b_this_page;
@@ -1869,8 +1870,9 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 			if (err)
 				break;
 			if (buffer_new(bh)) {
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				if (buffer_mapped(bh))
+					unmap_underlying_metadata(bh->b_bdev,
+						bh->b_blocknr);
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
@@ -2683,7 +2685,7 @@ int nobh_write_begin(struct file *file, struct address_space *mapping,
 			goto failed;
 		if (!buffer_mapped(bh))
 			is_mapped_to_disk = 0;
-		if (buffer_new(bh))
+		if (buffer_new(bh) && buffer_mapped(bh))
 			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 		if (PageUptodate(page)) {
 			set_buffer_uptodate(bh);
-- 
1.6.0.2

