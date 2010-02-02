Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0BBPcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:32:11 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:59939 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0BBPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:32:08 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 10:32:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=Ba8no7LdU8kmBf18YbTQFOQzDCfsFQI7f33YrFfAgb2x2qVVaMloeaCPcx75ZIaZYv
         IwpZoDdcejm7v6k0dPQqidDfJvzU9aExRkdwLt36jdLzfDibpy2ZXuWZFr1R16v7eOJE
         m/gtoieDocow0vClaHPqWRveYzd8lZGciIN3E=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: [patch 2/7] roll back reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
Date: Tue, 2 Feb 2010 16:24:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002021624.57486.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roll back reiser4-generic_sync_sb_inodes-doesnt-exist-anymore.patch
(wrong stuff)

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/reiser4/context.h   |    2 +-
 fs/reiser4/entd.c      |    4 +---
 fs/reiser4/super_ops.c |    6 ++----
 3 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6.33-rc5-mm1/fs/reiser4/context.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/context.h
+++ linux-2.6.33-rc5-mm1/fs/reiser4/context.h
@@ -66,7 +66,7 @@ struct reiser4_context {
 	/* count non-trivial jnode_set_dirty() calls */
 	unsigned long nr_marked_dirty;
 
-	/* reiser4_sync_inodes calls (via writeback/sync_inodes_sb)
+	/* reiser4_sync_inodes calls (via generic_sync_sb_inodes)
 	 * reiser4_writepages for each of dirty inodes. Reiser4_writepages
 	 * captures pages. When number of pages captured in one
 	 * reiser4_sync_inodes reaches some threshold - some atoms get
Index: linux-2.6.33-rc5-mm1/fs/reiser4/entd.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/entd.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/entd.c
@@ -241,9 +241,7 @@ static void entd_flush(struct super_bloc
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		writeback_inodes_sb(super);
-		if (rq->wbc->sync_mode == WB_SYNC_ALL)
-			sync_inodes_sb(super);
+		generic_sync_sb_inodes(rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
Index: linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/super_ops.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
@@ -384,7 +384,7 @@ static void reiser4_clear_inode(struct i
  * @wbc:
  *
  * This method is called by background and non-backgound writeback. Reiser4's
- * implementation uses writeback/sync_inodes_sb to call reiser4_writepages for
+ * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
  * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
  * mapping - dirty pages get into atoms. Writeout is called to flush some
  * atoms.
@@ -412,9 +412,7 @@ static void reiser4_sync_inodes(struct s
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	writeback_inodes_sb(super);
-	if (wbc->sync_mode == WB_SYNC_ALL)
-		sync_inodes_sb(super);
+	generic_sync_sb_inodes(wbc);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
