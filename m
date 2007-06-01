Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbXFAUDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbXFAUDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762918AbXFAUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:03:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762764AbXFAUC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:02:58 -0400
From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Subject: [PATCH] lib: add idr_for_each()
Date: Fri,  1 Jun 2007 16:02:42 -0400
Message-Id: <11807281632412-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an iterator function for the idr data structure.  Compared
to just iterating through the idr with an integer and idr_find, this
iterator is (almost, but not quite) linear in the number of elements,
as opposed to the number of integers in the range covered by the idr.  This
makes a difference for sparse idrs, but more importantly, it's a nicer
way to iterate through the elements.

The drm subsystem is moving to idr for tracking contexts and drawables, and
with this change, we can use the idr exclusively for tracking these
resources.

Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
---
 include/linux/idr.h |    2 +
 lib/idr.c           |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 8268034..d71735e 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -78,6 +78,8 @@ void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new(struct idr *idp, void *ptr, int *id);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+int idr_for_each(struct idr *idp,
+		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
diff --git a/lib/idr.c b/lib/idr.c
index 305117c..dd43be5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -404,6 +404,61 @@ void *idr_find(struct idr *idp, int id)
 EXPORT_SYMBOL(idr_find);
 
 /**
+ * idr_for_each - iterate through all stored pointers
+ * @idp: idr handle
+ * @fn: function to be called for each pointer
+ * @data: data passed back to callback function
+ *
+ * Iterate over the pointers registered with the given idr.  The
+ * callback function will be called for each pointer currently
+ * registered, passing the id, the pointer and the data pointer passed
+ * to this function.  It is not safe to modify the idr tree while in
+ * the callback, so functions such as idr_get_new and idr_remove are
+ * not allowed.
+ *
+ * We check the return of @fn each time. If it returns anything other
+ * than 0, we break out and return that value.
+ *
+ * The caller must serialize idr_find() vs idr_get_new() and idr_remove().
+ */
+int idr_for_each(struct idr *idp,
+		 int (*fn)(int id, void *p, void *data), void *data)
+{
+	int n, id, max, error = 0;
+	struct idr_layer *p;
+	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer **paa = &pa[0];
+
+	n = idp->layers * IDR_BITS;
+	p = idp->top;
+	max = 1 << n;
+
+	id = 0;
+	while (id < max) {
+		while (n > 0 && p) {
+			n -= IDR_BITS;
+			*paa++ = p;
+			p = p->ary[(id >> n) & IDR_MASK];
+		}
+
+		if (p) {
+			error = fn(id, (void *)p, data);
+			if (error)
+				break;
+		}
+
+		id += 1 << n;
+		while (n < fls(id)) {
+			n += IDR_BITS;
+			p = *--paa;
+		}
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(idr_for_each);
+
+/**
  * idr_replace - replace pointer for given id
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
-- 
1.5.0.6

