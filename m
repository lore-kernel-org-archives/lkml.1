Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXDVSrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXDVSrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXDVSqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:46:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbXDVSqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:46:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] swsusp: Free more memory
Date: Sun, 22 Apr 2007 20:14:01 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
References: <200704222010.21999.rjw@sisk.pl>
In-Reply-To: <200704222010.21999.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704222014.01941.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the definition of PAGES_FOR_IO to kernel/power/power.h and introduce
SPARE_PAGES representing the number of pages that should be freed by the
swsusp's memory shrinker in addition to PAGES_FOR_IO so that device drivers can
allocate some memory (up to 1 MB total) in their .suspend() routines without
causing the suspend to fail.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/suspend.h |    6 ------
 kernel/power/power.h    |   12 +++++++++++-
 kernel/power/swsusp.c   |    2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc6-mm1/include/linux/suspend.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/suspend.h	2007-04-21 23:24:28.000000000 +0200
+++ linux-2.6.21-rc6-mm1/include/linux/suspend.h	2007-04-21 23:24:44.000000000 +0200
@@ -60,10 +60,4 @@ struct saved_context;
 void __save_processor_state(struct saved_context *ctxt);
 void __restore_processor_state(struct saved_context *ctxt);
 
-/*
- * XXX: We try to keep some more pages free so that I/O operations succeed
- * without paging. Might this be more?
- */
-#define PAGES_FOR_IO	1024
-
 #endif /* _LINUX_SWSUSP_H */
Index: linux-2.6.21-rc6-mm1/kernel/power/power.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/power.h	2007-04-21 23:24:28.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/power/power.h	2007-04-21 23:24:44.000000000 +0200
@@ -14,8 +14,18 @@ struct swsusp_info {
 
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
-extern int pm_suspend_disk(void);
+/*
+ * Keep some memory free so that I/O operations can succeed without paging
+ * [Might this be more than 4 MB?]
+ */
+#define PAGES_FOR_IO	((4096 * 1024) >> PAGE_SHIFT)
+/*
+ * Keep 1 MB of memory free so that device drivers can allocate some pages in
+ * their .suspend() routines without breaking the suspend to disk.
+ */
+#define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
+extern int pm_suspend_disk(void);
 #else
 static inline int pm_suspend_disk(void)
 {
Index: linux-2.6.21-rc6-mm1/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/power/swsusp.c	2007-04-21 22:37:50.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/power/swsusp.c	2007-04-21 23:24:44.000000000 +0200
@@ -233,7 +233,7 @@ int swsusp_shrink_memory(void)
 		long size, highmem_size;
 
 		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO;
+		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
 		tmp = size;
 		size += highmem_size;
 		for_each_zone (zone)

