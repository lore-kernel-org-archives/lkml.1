Return-Path: <linux-kernel-owner+w=401wt.eu-S934163AbZLFUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbZLFUqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbZLFUqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:48 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60044 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757806AbZLFUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:29 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 3/5] drm/ttm: Add TTM execbuf utilities.
Date: Sun,  6 Dec 2009 21:46:26 +0100
Message-Id: <1260132388-28414-4-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1260132388-28414-3-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-3-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Utilities to reserve, unreserve and fence a list of TTM
buffer objects in a deadlock-safe manner.

Used by the vmwgfx driver.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/Makefile           |    2 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c |  117 ++++++++++++++++++++++++++++++++
 include/drm/ttm/ttm_execbuf_util.h     |  107 +++++++++++++++++++++++++++++
 3 files changed, 225 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_execbuf_util.c
 create mode 100644 include/drm/ttm/ttm_execbuf_util.h

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index 4473549..1e138f5 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -4,6 +4,6 @@
 ccflags-y := -Iinclude/drm
 ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
 	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o \
-	ttm_object.o ttm_lock.o
+	ttm_object.o ttm_lock.o ttm_execbuf_util.o
 
 obj-$(CONFIG_DRM_TTM) += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
new file mode 100644
index 0000000..c285c29
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -0,0 +1,117 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+
+#include "ttm/ttm_execbuf_util.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement.h"
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+void ttm_eu_backoff_reservation(struct list_head *list)
+{
+	struct ttm_validate_buffer *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+		if (!entry->reserved)
+			continue;
+
+		entry->reserved = false;
+		ttm_bo_unreserve(bo);
+	}
+}
+EXPORT_SYMBOL(ttm_eu_backoff_reservation);
+
+/*
+ * Reserve buffers for validation.
+ *
+ * If a buffer in the list is marked for CPU access, we back off and
+ * wait for that buffer to become free for GPU access.
+ *
+ * If a buffer is reserved for another validation, the validator with
+ * the highest validation sequence backs off and waits for that buffer
+ * to become unreserved. This prevents deadlocks when validating multiple
+ * buffers in different orders.
+ */
+
+int ttm_eu_reserve_buffers(struct list_head *list, uint32_t val_seq)
+{
+	struct ttm_validate_buffer *entry;
+	int ret;
+
+retry:
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+
+		entry->reserved = false;
+		ret = ttm_bo_reserve(bo, true, false, true, val_seq);
+		if (ret != 0) {
+			ttm_eu_backoff_reservation(list);
+			if (ret == -EAGAIN) {
+				ret = ttm_bo_wait_unreserved(bo, true);
+				if (unlikely(ret != 0))
+					return ret;
+				goto retry;
+			} else
+				return ret;
+		}
+
+		entry->reserved = true;
+		if (unlikely(atomic_read(&bo->cpu_writers) > 0)) {
+			ttm_eu_backoff_reservation(list);
+			ret = ttm_bo_wait_cpu(bo, false);
+			if (ret)
+				return ret;
+			goto retry;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ttm_eu_reserve_buffers);
+
+void ttm_eu_fence_buffer_objects(struct list_head *list, void *sync_obj)
+{
+	struct ttm_validate_buffer *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct ttm_buffer_object *bo = entry->bo;
+		struct ttm_bo_driver *driver = bo->bdev->driver;
+		void *old_sync_obj;
+
+		spin_lock(&bo->lock);
+		old_sync_obj = bo->sync_obj;
+		bo->sync_obj = driver->sync_obj_ref(sync_obj);
+		bo->sync_obj_arg = entry->new_sync_obj_arg;
+		spin_unlock(&bo->lock);
+		ttm_bo_unreserve(bo);
+		entry->reserved = false;
+		if (old_sync_obj)
+			driver->sync_obj_unref(&old_sync_obj);
+	}
+}
+EXPORT_SYMBOL(ttm_eu_fence_buffer_objects);
diff --git a/include/drm/ttm/ttm_execbuf_util.h b/include/drm/ttm/ttm_execbuf_util.h
new file mode 100644
index 0000000..cd2c475
--- /dev/null
+++ b/include/drm/ttm/ttm_execbuf_util.h
@@ -0,0 +1,107 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+#ifndef _TTM_EXECBUF_UTIL_H_
+#define _TTM_EXECBUF_UTIL_H_
+
+#include "ttm/ttm_bo_api.h"
+#include <linux/list.h>
+
+/**
+ * struct ttm_validate_buffer
+ *
+ * @head:           list head for thread-private list.
+ * @bo:             refcounted buffer object pointer.
+ * @new_sync_obj_arg: New sync_obj_arg for @bo, to be used once
+ * adding a new sync object.
+ * @reservied:      Indicates whether @bo has been reserved for validation.
+ */
+
+struct ttm_validate_buffer {
+	struct list_head head;
+	struct ttm_buffer_object *bo;
+	void *new_sync_obj_arg;
+	bool reserved;
+};
+
+/**
+ * function ttm_eu_backoff_reservation
+ *
+ * @list:     thread private list of ttm_validate_buffer structs.
+ *
+ * Undoes all buffer validation reservations for bos pointed to by
+ * the list entries.
+ */
+
+extern void ttm_eu_backoff_reservation(struct list_head *list);
+
+/**
+ * function ttm_eu_reserve_buffers
+ *
+ * @list:    thread private list of ttm_validate_buffer structs.
+ * @val_seq: A unique sequence number.
+ *
+ * Tries to reserve bos pointed to by the list entries for validation.
+ * If the function returns 0, all buffers are marked as "unfenced",
+ * taken off the lru lists and are not synced for write CPU usage.
+ *
+ * If the function detects a deadlock due to multiple threads trying to
+ * reserve the same buffers in reverse order, all threads except one will
+ * back off and retry. This function may sleep while waiting for
+ * CPU write reservations to be cleared, and for other threads to
+ * unreserve their buffers.
+ *
+ * This function may return -ERESTART or -EAGAIN if the calling process
+ * receives a signal while waiting. In that case, no buffers on the list
+ * will be reserved upon return.
+ *
+ * Buffers reserved by this function should be unreserved by
+ * a call to either ttm_eu_backoff_reservation() or
+ * ttm_eu_fence_buffer_objects() when command submission is complete or
+ * has failed.
+ */
+
+extern int ttm_eu_reserve_buffers(struct list_head *list, uint32_t val_seq);
+
+/**
+ * function ttm_eu_fence_buffer_objects.
+ *
+ * @list:        thread private list of ttm_validate_buffer structs.
+ * @sync_obj:    The new sync object for the buffers.
+ *
+ * This function should be called when command submission is complete, and
+ * it will add a new sync object to bos pointed to by entries on @list.
+ * It also unreserves all buffers, putting them on lru lists.
+ *
+ */
+
+extern void ttm_eu_fence_buffer_objects(struct list_head *list, void *sync_obj);
+
+#endif
-- 
1.5.3.2

