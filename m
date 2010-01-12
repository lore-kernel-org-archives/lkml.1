Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607Ab0ALGj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab0ALGj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203Ab0ALGj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:39:56 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:37151 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814Ab0ALGjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:39:55 -0500
Date: Tue, 12 Jan 2010 17:39:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, dedekind@infradead.org
Subject: [PATCH V4] lib: introduce generic list_sort()
Message-ID: <20100112063916.GA18325@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Is is possible to get this patch into a .33-rcX release so we
don't have to weird cross-tree modifications in the lead up to
.34? It doesn't change any functionality, just moves code around....

Cheers,

Dave.
--

lib: Introduce generic list_sort function

There are two copies of list_sort() in the tree already, one in the DRM code,
another in ubifs. Now XFS needs this as well. Create a generic list_sort()
function from the ubifs version and convert existing users to it so we
don't end up with yet another copy in the tree.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Artem Bityutskiy <dedekind@infradead.org>
---
V4: move to lib/list_sort.c
V3: Export list_sort()
V2: fix a typo

 drivers/gpu/drm/drm_modes.c |   90 ++------------------------------------
 fs/ubifs/gc.c               |   96 +---------------------------------------
 include/linux/list_sort.h   |   12 +++++
 lib/Makefile                |    2 +-
 lib/list_sort.c             |  103 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 121 insertions(+), 182 deletions(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 6d81a02..76d6339 100644
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
+#include <linux/list_sort.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -855,6 +851,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
 
 /**
  * drm_mode_compare - compare modes for favorability
+ * @priv: unused
  * @lh_a: list_head for first mode
  * @lh_b: list_head for second mode
  *
@@ -868,7 +865,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
  * Negative if @lh_a is better than @lh_b, zero if they're equivalent, or
  * positive if @lh_b is better than @lh_a.
  */
-static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
+static int drm_mode_compare(void *priv, struct list_head *lh_a, struct list_head *lh_b)
 {
 	struct drm_display_mode *a = list_entry(lh_a, struct drm_display_mode, head);
 	struct drm_display_mode *b = list_entry(lh_b, struct drm_display_mode, head);
@@ -885,85 +882,6 @@ static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
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
@@ -975,7 +893,7 @@ void list_sort(struct list_head *head,
  */
 void drm_mode_sort(struct list_head *mode_list)
 {
-	list_sort(mode_list, drm_mode_compare);
+	list_sort(NULL, mode_list, drm_mode_compare);
 }
 EXPORT_SYMBOL(drm_mode_sort);
 
diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 618c270..e5a3d8e 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -54,6 +54,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/list_sort.h>
 #include "ubifs.h"
 
 /*
@@ -108,101 +109,6 @@ static int switch_gc_head(struct ubifs_info *c)
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
diff --git a/include/linux/list_sort.h b/include/linux/list_sort.h
new file mode 100644
index 0000000..c81fbef
--- /dev/null
+++ b/include/linux/list_sort.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_LIST_SORT_H
+#define _LINUX_LIST_SORT_H
+
+#include <linux/types.h>
+
+struct list_head;
+
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
+#endif
+
diff --git a/lib/Makefile b/lib/Makefile
index 347ad8d..db66b1b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o
+	 string_helpers.o gcd.o list_sort.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/list_sort.c b/lib/list_sort.c
new file mode 100644
index 0000000..0763672
--- /dev/null
+++ b/lib/list_sort.c
@@ -0,0 +1,103 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list_sort.h>
+#include <linux/slab.h>
+#include <linux/list.h>
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
+ * less than @b, and a positive value if @a is greater than @b. If @a and @b
+ * are equivalent, then it does not matter what this function returns.
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
+EXPORT_SYMBOL(list_sort);
+

