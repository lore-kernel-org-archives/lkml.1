Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZK2L2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZK2L2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 06:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZK2L2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 06:28:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:44540 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754228AbZK2L2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 06:28:33 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX18NdGomfVQNmIT5o82FOmnJAfLL16j/bL7YujcvIY
	w1tVLR3Z8EDRXO
Date: Mon, 30 Nov 2009 00:28:33 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] reiser4: generic_sync_sb_inodes doesn't exist
 anymore
Message-Id: <20091130002833.1102d033.buchner.johannes@gmx.at>
In-Reply-To: <1259389684-18625-4-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-3-git-send-email-buchner.johannes@gmx.at>
	<1259389684-18625-4-git-send-email-buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> generic_sync_sb_inodes was removed in d8a8559cd7a9cc,
> writeback_inodes_sb and sync_inodes_sb should replace them.
Second version, now also fixes the last comments relating to
generic_sync_sb_inodes.

---
 fs/reiser4/context.h   |    2 +-
 fs/reiser4/entd.c      |    4 +++-
 fs/reiser4/super_ops.c |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/fs/reiser4/entd.c
===================================================================
--- linux.orig/fs/reiser4/entd.c
+++ linux/fs/reiser4/entd.c
@@ -241,7 +241,9 @@ static void entd_flush(struct super_bloc
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		writeback_inodes_sb(super);
+		if (rq->wbc->sync_mode == WB_SYNC_ALL)
+			sync_inodes_sb(super);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
 	reiser4_writeout(super, rq->wbc);
Index: linux/fs/reiser4/super_ops.c
===================================================================
--- linux.orig/fs/reiser4/super_ops.c
+++ linux/fs/reiser4/super_ops.c
@@ -384,7 +384,7 @@ static void reiser4_clear_inode(struct i
  * @wbc:
  *
  * This method is called by background and non-backgound writeback. Reiser4's
- * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
+ * implementation uses writeback/sync_inodes_sb to call reiser4_writepages for
  * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
  * mapping - dirty pages get into atoms. Writeout is called to flush some
  * atoms.
@@ -412,7 +412,9 @@ static void reiser4_sync_inodes(struct s
 	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
 	 * into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	writeback_inodes_sb(super);
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		sync_inodes_sb(super);
 
 	/* flush goes here */
 	wbc->nr_to_write = to_write;
Index: linux/fs/reiser4/context.h
===================================================================
--- linux.orig/fs/reiser4/context.h
+++ linux/fs/reiser4/context.h
@@ -66,7 +66,7 @@ struct reiser4_context {
 	/* count non-trivial jnode_set_dirty() calls */
 	unsigned long nr_marked_dirty;
 
-	/* reiser4_sync_inodes calls (via generic_sync_sb_inodes)
+	/* reiser4_sync_inodes calls (via writeback/sync_inodes_sb)
 	 * reiser4_writepages for each of dirty inodes. Reiser4_writepages
 	 * captures pages. When number of pages captured in one
 	 * reiser4_sync_inodes reaches some threshold - some atoms get
