Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCVT1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCVT1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZCVT0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52562 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbZCVT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/12] Move the default_backing_dev_info out of readahead.c and into backing-dev.c
Date: Sun, 22 Mar 2009 20:25:53 +0100
Message-Id: <1237749964-8343-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It really makes no sense to have it in readahead.c, so move it where
it belongs.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   26 +++++++++++++++++++++++++-
 mm/readahead.c   |   25 -------------------------
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8e85874..be68c95 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -2,11 +2,24 @@
 #include <linux/wait.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
 #include <linux/device.h>
 
+void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
+{
+}
+EXPORT_SYMBOL(default_unplug_io_fn);
+
+struct backing_dev_info default_backing_dev_info = {
+	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
+	.state		= 0,
+	.capabilities	= BDI_CAP_MAP_COPY,
+	.unplug_io_fn	= default_unplug_io_fn,
+};
+EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
 
@@ -166,9 +179,20 @@ static __init int bdi_class_init(void)
 	bdi_debug_init();
 	return 0;
 }
-
 postcore_initcall(bdi_class_init);
 
+static int __init default_bdi_init(void)
+{
+	int err;
+
+	err = bdi_init(&default_backing_dev_info);
+	if (!err)
+		bdi_register(&default_backing_dev_info, NULL, "default");
+
+	return err;
+}
+subsys_initcall(default_bdi_init);
+
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
diff --git a/mm/readahead.c b/mm/readahead.c
index bec83c1..9ce303d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -17,19 +17,6 @@
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
-void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-}
-EXPORT_SYMBOL(default_unplug_io_fn);
-
-struct backing_dev_info default_backing_dev_info = {
-	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
-	.state		= 0,
-	.capabilities	= BDI_CAP_MAP_COPY,
-	.unplug_io_fn	= default_unplug_io_fn,
-};
-EXPORT_SYMBOL_GPL(default_backing_dev_info);
-
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.
@@ -233,18 +220,6 @@ unsigned long max_sane_readahead(unsigned long nr)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
 
-static int __init readahead_init(void)
-{
-	int err;
-
-	err = bdi_init(&default_backing_dev_info);
-	if (!err)
-		bdi_register(&default_backing_dev_info, NULL, "default");
-
-	return err;
-}
-subsys_initcall(readahead_init);
-
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-- 
1.6.2.12.g83676

