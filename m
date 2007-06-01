Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbXFAUDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbXFAUDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762857AbXFAUC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:02:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762250AbXFAUC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:02:58 -0400
From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Subject: [PATCH] lib: add idr_remove_all
Date: Fri,  1 Jun 2007 16:02:43 -0400
Message-Id: <1180728169860-git-send-email-krh@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11807281632412-git-send-email-krh@redhat.com>
References: <11807281632412-git-send-email-krh@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all ids from the given idr tree.  idr_destroy() only frees up
unused, cached idp_layers, but this function will remove all id mappings
and leave all idp_layers unused.

A typical clean-up sequence for objects stored in an idr tree, will
use idr_for_each() to free all objects, if necessay, then
idr_remove_all() to remove all ids, and idr_destroy() to free
up the cached idr_layers.

Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
---
 include/linux/idr.h |    1 +
 lib/idr.c           |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index d71735e..2d1e105 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -82,6 +82,7 @@ int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
+void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
diff --git a/lib/idr.c b/lib/idr.c
index dd43be5..b4d18d4 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -358,6 +358,53 @@ void idr_remove(struct idr *idp, int id)
 EXPORT_SYMBOL(idr_remove);
 
 /**
+ * idr_remove_all - remove all ids from the given idr tree
+ * @idp: idr handle
+ *
+ * idr_destroy() only frees up unused, cached idp_layers, but this
+ * function will remove all id mappings and leave all idp_layers
+ * unused.
+ *
+ * A typical clean-up sequence for objects stored in an idr tree, will
+ * use idr_for_each() to free all objects, if necessay, then
+ * idr_remove_all() to remove all ids, and idr_destroy() to free
+ * up the cached idr_layers.
+ */
+void idr_remove_all(struct idr *idp)
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
+	while (id < max && !error) {
+		while (n > IDR_BITS && p) {
+			n -= IDR_BITS;
+			*paa++ = p;
+			p = p->ary[(id >> n) & IDR_MASK];
+		}
+
+		id += 1 << n;
+		while (n < fls(id)) {
+			if (p) {
+				memset(p, 0, sizeof *p);
+				free_layer(idp, p);
+			}
+			n += IDR_BITS;
+			p = *--paa;
+		}
+	}
+	idp->top = NULL;
+	idp->layers = 0;
+}
+EXPORT_SYMBOL(idr_remove_all);
+
+/**
  * idr_destroy - release all cached layers within an idr tree
  * idp: idr handle
  */
-- 
1.5.0.6

