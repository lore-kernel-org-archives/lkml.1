Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbZIHW5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbZIHW5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZIHW5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:57:42 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57539 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZIHW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:57:38 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 04/20] ceph: ref counted buffer
Date: Tue,  8 Sep 2009 15:56:25 -0700
Message-Id: <1252450601-17610-5-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1252450601-17610-4-git-send-email-sage@newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
 <1252450601-17610-2-git-send-email-sage@newdream.net>
 <1252450601-17610-3-git-send-email-sage@newdream.net>
 <1252450601-17610-4-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ceph_buffer is a simple ref-counted buffer.  We transparently
choose between kmalloc for small buffers and vmalloc for large ones.

This is used for allocating memory for xattr data, among other things.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/buffer.h |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/buffer.h

diff --git a/fs/ceph/buffer.h b/fs/ceph/buffer.h
new file mode 100644
index 0000000..b4ccb94
--- /dev/null
+++ b/fs/ceph/buffer.h
@@ -0,0 +1,93 @@
+#ifndef __FS_CEPH_BUFFER_H
+#define __FS_CEPH_BUFFER_H
+
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include "ceph_debug.h"
+
+/*
+ * a simple reference counted buffer.
+ *
+ * use kmalloc for small sizes (<= one page), vmalloc for larger
+ * sizes.
+ */
+struct ceph_buffer {
+	atomic_t nref;
+	struct kvec vec;
+	size_t alloc_len;
+	bool is_static, is_vmalloc;
+};
+
+static inline void ceph_buffer_init_static(struct ceph_buffer *b)
+{
+	atomic_set(&b->nref, 1);
+	b->vec.iov_base = NULL;
+	b->vec.iov_len = 0;
+	b->alloc_len = 0;
+	b->is_static = true;
+}
+
+static inline struct ceph_buffer *ceph_buffer_new(gfp_t gfp)
+{
+	struct ceph_buffer *b;
+
+	b = kmalloc(sizeof(*b), gfp);
+	if (!b)
+		return NULL;
+	atomic_set(&b->nref, 1);
+	b->vec.iov_base = NULL;
+	b->vec.iov_len = 0;
+	b->alloc_len = 0;
+	b->is_static = false;
+	return b;
+}
+
+static inline int ceph_buffer_alloc(struct ceph_buffer *b, int len, gfp_t gfp)
+{
+	if (len <= PAGE_SIZE) {
+		b->vec.iov_base = kmalloc(len, gfp);
+		b->is_vmalloc = false;
+	} else {
+		b->vec.iov_base = __vmalloc(len, gfp, PAGE_KERNEL);
+		b->is_vmalloc = true;
+	}
+	if (!b->vec.iov_base)
+		return -ENOMEM;
+	b->alloc_len = len;
+	b->vec.iov_len = len;
+	return 0;
+}
+
+static inline struct ceph_buffer *ceph_buffer_get(struct ceph_buffer *b)
+{
+	atomic_inc(&b->nref);
+	return b;
+}
+
+static inline void ceph_buffer_put(struct ceph_buffer *b)
+{
+	if (b && atomic_dec_and_test(&b->nref)) {
+		if (b->vec.iov_base) {
+			if (b->is_vmalloc)
+				vfree(b->vec.iov_base);
+			else
+				kfree(b->vec.iov_base);
+		}
+		kfree(b);
+	}
+}
+
+static inline struct ceph_buffer *ceph_buffer_new_alloc(int len, gfp_t gfp)
+{
+	struct ceph_buffer *b = ceph_buffer_new(gfp);
+
+	if (b && ceph_buffer_alloc(b, len, gfp) < 0) {
+		ceph_buffer_put(b);
+		b = NULL;
+	}
+	return b;
+}
+
+#endif
-- 
1.5.6.5

