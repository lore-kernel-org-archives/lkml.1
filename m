Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXIQSrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXIQSrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXIQSoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:44:30 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50389 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996AbXIQSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:44:28 -0400
Message-Id: <20070917184423.396034014@polymtl.ca>
References: <20070917184335.904338974@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 14:43:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 1/2] Seq_file add support for sorted list
Content-Disposition: inline; filename=seq_file_sorted.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 17 Sep 2007 18:44:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for sorted list in seq_file. It aims at changing the way
/proc/modules and kallsyms iterates on the module list to remove a race between
module unload and module/symbol listing.

The list is sorted by ascending list_head pointer address.

Changelog:

When reading the data by small chunks (i.e. byte by byte), the index (ppos) is
incremented by seq_read() directly and no "next" callback is called when going
to the next module.

Therefore, use ppos instead of m->private to deal with the fact that this index
is incremented directly to pass to the next module in seq_read() after the
buffer has been emptied.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 fs/seq_file.c            |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |   20 ++++++++++++++++++++
 2 files changed, 67 insertions(+)

Index: linux-2.6-lttng/fs/seq_file.c
===================================================================
--- linux-2.6-lttng.orig/fs/seq_file.c	2007-08-25 14:39:03.000000000 -0400
+++ linux-2.6-lttng/fs/seq_file.c	2007-08-27 11:11:33.000000000 -0400
@@ -510,3 +510,50 @@ struct list_head *seq_list_next(void *v,
 }
 
 EXPORT_SYMBOL(seq_list_next);
+
+struct list_head *seq_sorted_list_start(struct list_head *head, loff_t *ppos)
+{
+	struct list_head *lh;
+
+	list_for_each(lh, head)
+		if ((unsigned long)lh >= *ppos) {
+			*ppos = (unsigned long)lh;
+			return lh;
+		}
+	return NULL;
+}
+
+EXPORT_SYMBOL(seq_sorted_list_start);
+
+struct list_head *seq_sorted_list_start_head(struct list_head *head,
+		loff_t *ppos)
+{
+	struct list_head *lh;
+
+	if (!*ppos) {
+		*ppos = (unsigned long)head;
+		return head;
+	}
+	list_for_each(lh, head)
+		if ((unsigned long)lh >= *ppos) {
+			*ppos = (long)lh->prev;
+			return lh->prev;
+		}
+	return NULL;
+}
+
+EXPORT_SYMBOL(seq_sorted_list_start_head);
+
+struct list_head *seq_sorted_list_next(void *p, struct list_head *head,
+		loff_t *ppos)
+{
+	struct list_head *lh;
+	void *next;
+
+	lh = ((struct list_head *)p)->next;
+	next = (lh == head) ? NULL : lh;
+	*ppos = next ? (unsigned long)next : -1UL;
+	return next;
+}
+
+EXPORT_SYMBOL(seq_sorted_list_next);
Index: linux-2.6-lttng/include/linux/seq_file.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/seq_file.h	2007-08-25 14:39:03.000000000 -0400
+++ linux-2.6-lttng/include/linux/seq_file.h	2007-08-27 11:11:33.000000000 -0400
@@ -63,5 +63,25 @@ extern struct list_head *seq_list_start_
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+/*
+ * Helpers for iteration over a list sorted by ascending head pointer address.
+ * To be used in contexts where preemption cannot be disabled to insure to
+ * continue iteration on a modified list starting at the same location where it
+ * stopped, or at a following location. It insures that the lost information
+ * will only be in elements added/removed from the list between iterations.
+ * void *pos is only used to get the next list element and may not be a valid
+ * list_head anymore when given to seq_sorted_list_start() or
+ * seq_sorted_list_start_head().
+ */
+extern struct list_head *seq_sorted_list_start(struct list_head *head,
+		loff_t *ppos);
+extern struct list_head *seq_sorted_list_start_head(struct list_head *head,
+		loff_t *ppos);
+/*
+ * next must be called with an existing p node
+ */
+extern struct list_head *seq_sorted_list_next(void *p, struct list_head *head,
+		loff_t *ppos);
+
 #endif
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
