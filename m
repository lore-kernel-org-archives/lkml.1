Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0CCAxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:53:19 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54188 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0CCAqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:46 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 05/26] ceph: ref counted buffer
Date: Tue,  2 Mar 2010 16:46:36 -0800
Message-Id: <1267577217-31923-6-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ceph_buffer is a simple ref-counted buffer.  We transparently
choose between kmalloc for small buffers and vmalloc for large ones.

This is currently used only for allocating memory for xattr data.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/buffer.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/buffer.h |   39 +++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/buffer.c
 create mode 100644 fs/ceph/buffer.h

diff --git a/fs/ceph/buffer.c b/fs/ceph/buffer.c
new file mode 100644
index 0000000..b98086c
--- /dev/null
+++ b/fs/ceph/buffer.c
@@ -0,0 +1,78 @@
+
+#include "ceph_debug.h"
+#include "buffer.h"
+#include "decode.h"
+
+struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
+{
+	struct ceph_buffer *b;
+
+	b = kmalloc(sizeof(*b), gfp);
+	if (!b)
+		return NULL;
+
+	b->vec.iov_base = kmalloc(len, gfp | __GFP_NOWARN);
+	if (b->vec.iov_base) {
+		b->is_vmalloc = false;
+	} else {
+		b->vec.iov_base = __vmalloc(len, gfp, PAGE_KERNEL);
+		if (!b->vec.iov_base) {
+			kfree(b);
+			return NULL;
+		}
+		b->is_vmalloc = true;
+	}
+
+	kref_init(&b->kref);
+	b->alloc_len = len;
+	b->vec.iov_len = len;
+	dout("buffer_new %p\n", b);
+	return b;
+}
+
+void ceph_buffer_release(struct kref *kref)
+{
+	struct ceph_buffer *b = container_of(kref, struct ceph_buffer, kref);
+
+	dout("buffer_release %p\n", b);
+	if (b->vec.iov_base) {
+		if (b->is_vmalloc)
+			vfree(b->vec.iov_base);
+		else
+			kfree(b->vec.iov_base);
+	}
+	kfree(b);
+}
+
+int ceph_buffer_alloc(struct ceph_buffer *b, int len, gfp_t gfp)
+{
+	b->vec.iov_base = kmalloc(len, gfp | __GFP_NOWARN);
+	if (b->vec.iov_base) {
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
+int ceph_decode_buffer(struct ceph_buffer **b, void **p, void *end)
+{
+	size_t len;
+
+	ceph_decode_need(p, end, sizeof(u32), bad);
+	len = ceph_decode_32(p);
+	dout("decode_buffer len %d\n", (int)len);
+	ceph_decode_need(p, end, len, bad);
+	*b = ceph_buffer_new(len, GFP_NOFS);
+	if (!*b)
+		return -ENOMEM;
+	ceph_decode_copy(p, (*b)->vec.iov_base, len);
+	return 0;
+bad:
+	return -EINVAL;
+}
diff --git a/fs/ceph/buffer.h b/fs/ceph/buffer.h
new file mode 100644
index 0000000..58d1901
--- /dev/null
+++ b/fs/ceph/buffer.h
@@ -0,0 +1,39 @@
+#ifndef __FS_CEPH_BUFFER_H
+#define __FS_CEPH_BUFFER_H
+
+#include <linux/kref.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/types.h>
+#include <linux/uio.h>
+
+/*
+ * a simple reference counted buffer.
+ *
+ * use kmalloc for small sizes (<= one page), vmalloc for larger
+ * sizes.
+ */
+struct ceph_buffer {
+	struct kref kref;
+	struct kvec vec;
+	size_t alloc_len;
+	bool is_vmalloc;
+};
+
+extern struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp);
+extern void ceph_buffer_release(struct kref *kref);
+
+static inline struct ceph_buffer *ceph_buffer_get(struct ceph_buffer *b)
+{
+	kref_get(&b->kref);
+	return b;
+}
+
+static inline void ceph_buffer_put(struct ceph_buffer *b)
+{
+	kref_put(&b->kref, ceph_buffer_release);
+}
+
+extern int ceph_decode_buffer(struct ceph_buffer **b, void **p, void *end);
+
+#endif
-- 
1.7.0

