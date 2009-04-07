Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZDGQUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZDGQUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZDGQUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:20:40 -0400
Received: from verein.lst.de ([213.95.11.210]:51407 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbZDGQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:20:39 -0400
Date: Tue, 7 Apr 2009 18:20:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk, neilb@suse.de, agk@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]
Message-ID: <20090407162014.GA11899@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's used by DM and MD and generally useful, so move the bio list
helpers into bio.h.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/dm-bio-list.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-bio-list.h	2009-04-05 13:10:25.427445349 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,117 +0,0 @@
-/*
- * Copyright (C) 2004 Red Hat UK Ltd.
- *
- * This file is released under the GPL.
- */
-
-#ifndef DM_BIO_LIST_H
-#define DM_BIO_LIST_H
-
-#include <linux/bio.h>
-
-#ifdef CONFIG_BLOCK
-
-struct bio_list {
-	struct bio *head;
-	struct bio *tail;
-};
-
-static inline int bio_list_empty(const struct bio_list *bl)
-{
-	return bl->head == NULL;
-}
-
-static inline void bio_list_init(struct bio_list *bl)
-{
-	bl->head = bl->tail = NULL;
-}
-
-#define bio_list_for_each(bio, bl) \
-	for (bio = (bl)->head; bio; bio = bio->bi_next)
-
-static inline unsigned bio_list_size(const struct bio_list *bl)
-{
-	unsigned sz = 0;
-	struct bio *bio;
-
-	bio_list_for_each(bio, bl)
-		sz++;
-
-	return sz;
-}
-
-static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
-{
-	bio->bi_next = NULL;
-
-	if (bl->tail)
-		bl->tail->bi_next = bio;
-	else
-		bl->head = bio;
-
-	bl->tail = bio;
-}
-
-static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
-{
-	bio->bi_next = bl->head;
-
-	bl->head = bio;
-
-	if (!bl->tail)
-		bl->tail = bio;
-}
-
-static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
-{
-	if (!bl2->head)
-		return;
-
-	if (bl->tail)
-		bl->tail->bi_next = bl2->head;
-	else
-		bl->head = bl2->head;
-
-	bl->tail = bl2->tail;
-}
-
-static inline void bio_list_merge_head(struct bio_list *bl,
-				       struct bio_list *bl2)
-{
-	if (!bl2->head)
-		return;
-
-	if (bl->head)
-		bl2->tail->bi_next = bl->head;
-	else
-		bl->tail = bl2->tail;
-
-	bl->head = bl2->head;
-}
-
-static inline struct bio *bio_list_pop(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	if (bio) {
-		bl->head = bl->head->bi_next;
-		if (!bl->head)
-			bl->tail = NULL;
-
-		bio->bi_next = NULL;
-	}
-
-	return bio;
-}
-
-static inline struct bio *bio_list_get(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	bl->head = bl->tail = NULL;
-
-	return bio;
-}
-
-#endif /* CONFIG_BLOCK */
-#endif
Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c	2009-04-05 13:13:29.222444720 +0200
+++ linux-2.6/drivers/md/dm-delay.c	2009-04-05 13:13:32.398573159 +0200
@@ -15,8 +15,6 @@
 
 #include <linux/device-mapper.h>
 
-#include "dm-bio-list.h"
-
 #define DM_MSG_PREFIX "delay"
 
 struct delay_c {
Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c	2009-04-05 13:13:29.242444961 +0200
+++ linux-2.6/drivers/md/dm-mpath.c	2009-04-05 13:13:57.017458602 +0200
@@ -8,7 +8,6 @@
 #include <linux/device-mapper.h>
 
 #include "dm-path-selector.h"
-#include "dm-bio-list.h"
 #include "dm-bio-record.h"
 #include "dm-uevent.h"
 
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c	2009-04-05 13:13:29.255452134 +0200
+++ linux-2.6/drivers/md/dm-raid1.c	2009-04-05 13:13:38.802447942 +0200
@@ -5,7 +5,6 @@
  * This file is released under the GPL.
  */
 
-#include "dm-bio-list.h"
 #include "dm-bio-record.h"
 
 #include <linux/init.h>
Index: linux-2.6/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-region-hash.c	2009-04-05 13:13:29.270445034 +0200
+++ linux-2.6/drivers/md/dm-region-hash.c	2009-04-05 13:13:41.473449954 +0200
@@ -14,7 +14,6 @@
 #include <linux/vmalloc.h>
 
 #include "dm.h"
-#include "dm-bio-list.h"
 
 #define	DM_MSG_PREFIX	"region hash"
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2009-04-05 13:13:29.287445452 +0200
+++ linux-2.6/drivers/md/dm-snap.c	2009-04-05 13:13:43.704446877 +0200
@@ -22,7 +22,6 @@
 #include <linux/workqueue.h>
 
 #include "dm-exception-store.h"
-#include "dm-bio-list.h"
 
 #define DM_MSG_PREFIX "snapshots"
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2009-04-05 13:13:29.300444453 +0200
+++ linux-2.6/drivers/md/dm.c	2009-04-05 13:13:45.999446772 +0200
@@ -6,7 +6,6 @@
  */
 
 #include "dm.h"
-#include "dm-bio-list.h"
 #include "dm-uevent.h"
 
 #include <linux/init.h>
Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c	2009-04-05 13:13:29.316444814 +0200
+++ linux-2.6/drivers/md/raid1.c	2009-04-05 13:13:49.188479487 +0200
@@ -35,7 +35,6 @@
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include "md.h"
-#include "dm-bio-list.h"
 #include "raid1.h"
 #include "bitmap.h"
 
Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2009-04-05 13:13:29.332445594 +0200
+++ linux-2.6/drivers/md/raid10.c	2009-04-05 13:13:52.435605187 +0200
@@ -22,7 +22,6 @@
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
 #include "md.h"
-#include "dm-bio-list.h"
 #include "raid10.h"
 #include "bitmap.h"
 
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2009-04-05 13:10:25.442444604 +0200
+++ linux-2.6/include/linux/bio.h	2009-04-05 13:12:47.685574569 +0200
@@ -501,6 +501,115 @@ static inline int bio_has_data(struct bi
 	return bio && bio->bi_io_vec != NULL;
 }
 
+/*
+ * BIO list managment for use by remapping drivers (e.g. DM or MD).
+ *
+ * A bio_list anchors a singly-linked list of bios chained through the bi_next
+ * member of the bio.  The bio_list also caches the last list member to allow
+ * fast access to the tail.
+ */
+struct bio_list {
+	struct bio *head;
+	struct bio *tail;
+};
+
+static inline int bio_list_empty(const struct bio_list *bl)
+{
+	return bl->head == NULL;
+}
+
+static inline void bio_list_init(struct bio_list *bl)
+{
+	bl->head = bl->tail = NULL;
+}
+
+#define bio_list_for_each(bio, bl) \
+	for (bio = (bl)->head; bio; bio = bio->bi_next)
+
+static inline unsigned bio_list_size(const struct bio_list *bl)
+{
+	unsigned sz = 0;
+	struct bio *bio;
+
+	bio_list_for_each(bio, bl)
+		sz++;
+
+	return sz;
+}
+
+static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = NULL;
+
+	if (bl->tail)
+		bl->tail->bi_next = bio;
+	else
+		bl->head = bio;
+
+	bl->tail = bio;
+}
+
+static inline void bio_list_add_head(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = bl->head;
+
+	bl->head = bio;
+
+	if (!bl->tail)
+		bl->tail = bio;
+}
+
+static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->tail)
+		bl->tail->bi_next = bl2->head;
+	else
+		bl->head = bl2->head;
+
+	bl->tail = bl2->tail;
+}
+
+static inline void bio_list_merge_head(struct bio_list *bl,
+				       struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->head)
+		bl2->tail->bi_next = bl->head;
+	else
+		bl->tail = bl2->tail;
+
+	bl->head = bl2->head;
+}
+
+static inline struct bio *bio_list_pop(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	if (bio) {
+		bl->head = bl->head->bi_next;
+		if (!bl->head)
+			bl->tail = NULL;
+
+		bio->bi_next = NULL;
+	}
+
+	return bio;
+}
+
+static inline struct bio *bio_list_get(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	bl->head = bl->tail = NULL;
+
+	return bio;
+}
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
