Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756Ab0ADX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0ADX7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409Ab0ADX7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:59:50 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:35766 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753280Ab0ADX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:59:49 -0500
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH] sort: Introduce generic list_sort function
Date: Tue,  5 Jan 2010 10:54:55 +1100
Message-Id: <1262649295-28427-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two copies of list_sort() in the tree already, one in the DRM code,
another in ubifs. Now XFS needs this as well. Create a generic list_sort()
function from the ubifs version and convert existing users to it so we
don't end up with yet another copy in the tree.

CC: Dave Airlie <airlied@redhat.com>
CC: Artem Bityutskiy <dedekind@infradead.org>
CC: Adrian Hunter <adrian.hunter@nokia.com>

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 drivers/gpu/drm/drm_modes.c |   90 ++--------------------------------------
 fs/ubifs/gc.c               |   95 ------------------------------------------
 include/linux/sort.h        |    5 ++
 lib/sort.c                  |   97 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 181 deletions(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 51f6772..3846ed4 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -1,9 +1,4 @@
 /*
- * The list_sort function is (presumably) licensed under the GPL (see the
- * top level "COPYING" file for details).
- *
- * The remainder of this file is:
- *
  * Copyright © 1997-2003 by The XFree86 Project, Inc.
  * Copyright © 2007 Dave Airlie
  * Copyright © 2007-2008 Intel Corporation
@@ -36,6 +31,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/sort.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -829,6 +825,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
 
 /**
  * drm_mode_compare - compare modes for favorability
+ * @priv: unused
  * @lh_a: list_head for first mode
  * @lh_b: list_head for second mode
  *
@@ -842,7 +839,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
  * Negative if @lh_a is better than @lh_b, zero if they're equivalent, or
  * positive if @lh_b is better than @lh_a.
  */
-static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
+static int drm_mode_compare(void *priv, struct list_head *lh_a, struct list_head *lh_b)
 {
 	struct drm_display_mode *a = list_entry(lh_a, struct drm_display_mode, head);
 	struct drm_display_mode *b = list_entry(lh_b, struct drm_display_mode, head);
@@ -859,85 +856,6 @@ static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
 	return diff;
 }
 
-/* FIXME: what we don't have a list sort function? */
-/* list sort from Mark J Roberts (mjr@znex.org) */
-void list_sort(struct list_head *head,
-	       int (*cmp)(struct list_head *a, struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
-			}
-			p = q;
-		}
-
-		tail->next = list;
-		list->prev = tail;
-
-		if (nmerges <= 1)
-			break;
-
-		insize *= 2;
-	}
-
-	head->next = list;
-	head->prev = list->prev;
-	list->prev->next = head;
-	list->prev = head;
-}
-
 /**
  * drm_mode_sort - sort mode list
  * @mode_list: list to sort
@@ -949,7 +867,7 @@ void list_sort(struct list_head *head,
  */
 void drm_mode_sort(struct list_head *mode_list)
 {
-	list_sort(mode_list, drm_mode_compare);
+	list_sort(NULL, mode_list, drm_mode_compare);
 }
 EXPORT_SYMBOL(drm_mode_sort);
 
diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 618c270..4976e07 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -108,101 +108,6 @@ static int switch_gc_head(struct ubifs_info *c)
 }
 
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
- * @head: the list to sort
- * @cmp: the elements comparison function
- *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
- * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
- * in ascending order.
- *
- * The comparison function @cmp is supposed to return a negative value if @a is
- * than @b, and a positive value if @a is greater than @b. If @a and @b are
- * equivalent, then it does not matter what this function returns.
- */
-static void list_sort(void *priv, struct list_head *head,
-		      int (*cmp)(void *priv, struct list_head *a,
-				 struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	if (list_empty(head))
-		return;
-
-	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(priv, p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
-			}
-			p = q;
-		}
-
-		tail->next = list;
-		list->prev = tail;
-
-		if (nmerges <= 1)
-			break;
-
-		insize *= 2;
-	}
-
-	head->next = list;
-	head->prev = list->prev;
-	list->prev->next = head;
-	list->prev = head;
-}
-
-/**
  * data_nodes_cmp - compare 2 data nodes.
  * @priv: UBIFS file-system description object
  * @a: first data node
diff --git a/include/linux/sort.h b/include/linux/sort.h
index d534da2..99a2ed5 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -3,8 +3,13 @@
 
 #include <linux/types.h>
 
+struct list_head;
+
 void sort(void *base, size_t num, size_t size,
 	  int (*cmp)(const void *, const void *),
 	  void (*swap)(void *, void *, int));
 
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index 926d004..1772c45 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 
 static void u32_swap(void *a, void *b, int size)
 {
@@ -121,3 +122,99 @@ static int sort_test(void)
 
 module_init(sort_test);
 #endif
+
+/**
+ * list_sort - sort a list.
+ * @priv: private data, passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
+ * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
+ * in ascending order.
+ *
+ * The comparison function @cmp is supposed to return a negative value if @a is
+ * than @b, and a positive value if @a is greater than @b. If @a and @b are
+ * equivalent, then it does not matter what this function returns.
+ */
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b))
+{
+	struct list_head *p, *q, *e, *list, *tail, *oldhead;
+	int insize, nmerges, psize, qsize, i;
+
+	if (list_empty(head))
+		return;
+
+	list = head->next;
+	list_del(head);
+	insize = 1;
+	for (;;) {
+		p = oldhead = list;
+		list = tail = NULL;
+		nmerges = 0;
+
+		while (p) {
+			nmerges++;
+			q = p;
+			psize = 0;
+			for (i = 0; i < insize; i++) {
+				psize++;
+				q = q->next == oldhead ? NULL : q->next;
+				if (!q)
+					break;
+			}
+
+			qsize = insize;
+			while (psize > 0 || (qsize > 0 && q)) {
+				if (!psize) {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				} else if (!qsize || !q) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else if (cmp(priv, p, q) <= 0) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				}
+				if (tail)
+					tail->next = e;
+				else
+					list = e;
+				e->prev = tail;
+				tail = e;
+			}
+			p = q;
+		}
+
+		tail->next = list;
+		list->prev = tail;
+
+		if (nmerges <= 1)
+			break;
+
+		insize *= 2;
+	}
+
+	head->next = list;
+	head->prev = list->prev;
+	list->prev->next = head;
+	list->prev = head;
+}
+
-- 
1.6.5

