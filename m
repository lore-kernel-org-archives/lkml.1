Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbXBUIGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbXBUIGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbXBUIGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:06:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33849 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbXBUIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:06:22 -0500
Date: Wed, 21 Feb 2007 10:06:20 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: clameter@sgi.com, linux-kernel@vger.kernel.org, jsipek@fsl.cs.sunysb.edu,
       unionfs@filesystems.org, bunk@stusta.de, hooanon05@yahoo.co.jp
Subject: [PATCH 1/3] slab: introduce krealloc
Message-ID: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Introduce krealloc() for reallocating memory while preserving contents.

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    1 +
 mm/util.c            |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

Index: 2.6/include/linux/slab.h
===================================================================
--- 2.6.orig/include/linux/slab.h	2007-02-21 09:05:08.000000000 +0200
+++ 2.6/include/linux/slab.h	2007-02-21 09:05:47.000000000 +0200
@@ -72,6 +72,7 @@
  */
 void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
+void *krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 unsigned int ksize(const void *);
 
Index: 2.6/mm/util.c
===================================================================
--- 2.6.orig/mm/util.c	2007-02-21 09:05:49.000000000 +0200
+++ 2.6/mm/util.c	2007-02-21 09:34:32.000000000 +0200
@@ -18,6 +18,40 @@
 }
 EXPORT_SYMBOL(__kzalloc);
 
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ *
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!p))
+		return kmalloc_track_caller(new_size, flags);
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (!ret)
+		return NULL;
+
+	memcpy(ret, p, min(new_size, ksize(p)));
+	kfree(p);
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
 /*
  * kstrdup - allocate space for and copy an existing string
  *
