Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYHMIkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYHMIkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYHMIjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37090 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYHMIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:20 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: make ubifs_ro_mode() not inline
Date: Wed, 13 Aug 2008 13:17:37 +0300
Message-Id: <1218622675-28853-9-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0284 (UTC) FILETIME=[0A408340:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

We use ubifs_ro_mode() quite a lot, and not in fast-path, so
there is no reason to blow the code up by having it inlined.
Also, we usually want R/O mode change to be seen to other
CPUs as soon as possible, so when we make this a function
call, we will automatically have a memory barrier.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/io.c    |   14 ++++++++++++++
 fs/ubifs/misc.h  |   14 --------------
 fs/ubifs/ubifs.h |    1 +
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 3374f91..054363f 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -54,6 +54,20 @@
 #include "ubifs.h"
 
 /**
+ * ubifs_ro_mode - switch UBIFS to read read-only mode.
+ * @c: UBIFS file-system description object
+ * @err: error code which is the reason of switching to R/O mode
+ */
+void ubifs_ro_mode(struct ubifs_info *c, int err)
+{
+	if (!c->ro_media) {
+		c->ro_media = 1;
+		ubifs_warn("switched to read-only mode, error %d", err);
+		dbg_dump_stack();
+	}
+}
+
+/**
  * ubifs_check_node - check node.
  * @c: UBIFS file-system description object
  * @buf: node to check
diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
index 4beccfc..cd83ffc 100644
--- a/fs/ubifs/misc.h
+++ b/fs/ubifs/misc.h
@@ -80,20 +80,6 @@ static inline struct ubifs_inode *ubifs_inode(const struct inode *inode)
 }
 
 /**
- * ubifs_ro_mode - switch UBIFS to read read-only mode.
- * @c: UBIFS file-system description object
- * @err: error code which is the reason of switching to R/O mode
- */
-static inline void ubifs_ro_mode(struct ubifs_info *c, int err)
-{
-	if (!c->ro_media) {
-		c->ro_media = 1;
-		ubifs_warn("switched to read-only mode, error %d", err);
-		dbg_dump_stack();
-	}
-}
-
-/**
  * ubifs_compr_present - check if compressor was compiled in.
  * @compr_type: compressor type to check
  *
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index e4f89f2..c488d43 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1346,6 +1346,7 @@ extern struct backing_dev_info ubifs_backing_dev_info;
 extern struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
 
 /* io.c */
+void ubifs_ro_mode(struct ubifs_info *c, int err);
 int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len);
 int ubifs_wbuf_seek_nolock(struct ubifs_wbuf *wbuf, int lnum, int offs,
 			   int dtype);
-- 
1.5.4.1

