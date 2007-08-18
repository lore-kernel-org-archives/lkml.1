Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXHRLAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXHRLAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 07:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXHRLAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 07:00:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31851 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbXHRLAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 07:00:41 -0400
Date: Sat, 18 Aug 2007 15:00:59 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] mm: add end_buffer_read helper function
Message-ID: <20070818110059.GB10969@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just move duplicated code from end_buffer_read_XXX
methods to separate helper function.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/buffer.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f95e444..6756524 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -118,10 +118,14 @@ static void buffer_io_error(struct buffer_head *bh)
 }
 
 /*
- * Default synchronous end-of-IO handler..  Just mark it up-to-date and
- * unlock the buffer. This is what ll_rw_block uses too.
+ * End-of-IO handler helper function which does not touch the bh after
+ * unlocking it.
+ * Note: unlock_buffer() sort-of does touch the bh after unlocking it, but
+ * a race there is benign: unlock_buffer() only use the bh's address for
+ * hashing after unlocking the buffer, so it doesn't actually touch the bh
+ * itself.
  */
-void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+static void __end_buffer_read_notouch(struct buffer_head *bh, int uptodate)
 {
 	if (uptodate) {
 		set_buffer_uptodate(bh);
@@ -130,6 +134,15 @@ void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
+}
+
+/*
+ * Default synchronous end-of-IO handler..  Just mark it up-to-date and
+ * unlock the buffer. This is what ll_rw_block uses too.
+ */
+void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
+{
+	__end_buffer_read_notouch(bh, uptodate);
 	put_bh(bh);
 }
 
@@ -2366,21 +2379,10 @@ out_unlock:
  * nobh_prepare_write()'s prereads are special: the buffer_heads are freed
  * immediately, while under the page lock.  So it needs a special end_io
  * handler which does not touch the bh after unlocking it.
- *
- * Note: unlock_buffer() sort-of does touch the bh after unlocking it, but
- * a race there is benign: unlock_buffer() only use the bh's address for
- * hashing after unlocking the buffer, so it doesn't actually touch the bh
- * itself.
  */
 static void end_buffer_read_nobh(struct buffer_head *bh, int uptodate)
 {
-	if (uptodate) {
-		set_buffer_uptodate(bh);
-	} else {
-		/* This happens, due to failed READA attempts. */
-		clear_buffer_uptodate(bh);
-	}
-	unlock_buffer(bh);
+	__end_buffer_read_notouch(bh, uptodate);
 }
 
 /*
-- 
1.5.2.2


