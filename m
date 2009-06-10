Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZFJNSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZFJNSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZFJNR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:17:59 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:36707 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398AbZFJNRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:17:54 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
       Jerome Glisse <jglisse@redhat.com>
Subject: [RFC][PATCH] drm: Add the TTM GPU memory manager subsystem.
Date: Wed, 10 Jun 2009 15:17:54 +0200
Message-Id: <1244639874-14503-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTM is a GPU memory manager subsystem designed for use with GPU
devices with various memory types (On-card VRAM, AGP,
PCI apertures etc.). It's essentially a helper library that assists
the DRM driver in creating and managing persistent buffer objects.

TTM manages placement of data and CPU map setup and teardown on
data movement. It can also optionally manage synchronization of
data on a per-buffer-object level.

TTM takes care to provide an always valid virtual user-space address
to a buffer object which makes user-space sub-allocation of
big buffer objects feasible.

TTM uses a fine-grained per buffer-object locking scheme, taking
care to release all relevant locks when waiting for the GPU.
Although this implies some locking overhead, it's probably a big
win for devices with multiple command submission mechanisms, since
the lock contention will be minimal.

TTM can be used with whatever user-space interface the driver
chooses, including GEM. It's used by the upcoming Radeon KMS DRM driver 
and is also the GPU memory management core of various new experimental
DRM drivers.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/Kconfig               |    8 +
 drivers/gpu/drm/Makefile              |    2 +-
 drivers/gpu/drm/ttm/Makefile          |    9 +
 drivers/gpu/drm/ttm/ttm_agp_backend.c |  150 +++
 drivers/gpu/drm/ttm/ttm_bo.c          | 1698 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_bo_util.c     |  561 +++++++++++
 drivers/gpu/drm/ttm/ttm_bo_vm.c       |  454 +++++++++
 drivers/gpu/drm/ttm/ttm_global.c      |  114 +++
 drivers/gpu/drm/ttm/ttm_memory.c      |  234 +++++
 drivers/gpu/drm/ttm/ttm_module.c      |   50 +
 drivers/gpu/drm/ttm/ttm_tt.c          |  635 ++++++++++++
 include/drm/ttm/ttm_bo_api.h          |  618 ++++++++++++
 include/drm/ttm/ttm_bo_driver.h       |  867 +++++++++++++++++
 include/drm/ttm/ttm_memory.h          |  153 +++
 include/drm/ttm/ttm_module.h          |   58 ++
 include/drm/ttm/ttm_placement.h       |   92 ++
 16 files changed, 5702 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/Makefile
 create mode 100644 drivers/gpu/drm/ttm/ttm_agp_backend.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_util.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_bo_vm.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_global.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_memory.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_module.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_tt.c
 create mode 100644 include/drm/ttm/ttm_bo_api.h
 create mode 100644 include/drm/ttm/ttm_bo_driver.h
 create mode 100644 include/drm/ttm/ttm_memory.h
 create mode 100644 include/drm/ttm/ttm_module.h
 create mode 100644 include/drm/ttm/ttm_placement.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f5d46e7..64a57ad 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -18,6 +18,14 @@ menuconfig DRM
 	  details.  You should also select and configure AGP
 	  (/dev/agpgart) support.
 
+config DRM_TTM
+	tristate "TTM memory manager"
+	depends on DRM
+	help
+	  GPU memory management subsystem for devices with multiple
+	  GPU memory types. Will be enabled automatically if a device driver
+	  uses it.
+
 config DRM_TDFX
 	tristate "3dfx Banshee/Voodoo3+"
 	depends on DRM && PCI
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 4ec5061..4e89ab0 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -26,4 +26,4 @@ obj-$(CONFIG_DRM_I915)  += i915/
 obj-$(CONFIG_DRM_SIS)   += sis/
 obj-$(CONFIG_DRM_SAVAGE)+= savage/
 obj-$(CONFIG_DRM_VIA)	+=via/
-
+obj-$(CONFIG_DRM_TTM)	+= ttm/
diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
new file mode 100644
index 0000000..0686829
--- /dev/null
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the drm device driver.  This driver provides support for the
+
+ccflags-y := -Iinclude/drm
+ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
+	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o
+
+
+obj-m += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
new file mode 100644
index 0000000..e8f6d22
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -0,0 +1,150 @@
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
+ *          Keith Packard.
+ */
+
+#include "ttm/ttm_module.h"
+#include "ttm/ttm_bo_driver.h"
+#ifdef TTM_HAS_AGP
+#include "ttm/ttm_placement.h"
+#include <linux/agp_backend.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <asm/agp.h>
+
+struct ttm_agp_backend {
+	struct ttm_backend backend;
+	struct agp_memory *mem;
+	struct agp_bridge_data *bridge;
+};
+
+static int ttm_agp_populate(struct ttm_backend *backend,
+			    unsigned long num_pages, struct page **pages,
+			    struct page *dummy_read_page)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct page **cur_page, **last_page = pages + num_pages;
+	struct agp_memory *mem;
+
+	mem = agp_allocate_memory(agp_be->bridge, num_pages, AGP_USER_MEMORY);
+	if (unlikely(mem == NULL))
+		return -ENOMEM;
+
+	mem->page_count = 0;
+	for (cur_page = pages; cur_page < last_page; ++cur_page) {
+		struct page *page = *cur_page;
+		if (!page)
+			page = dummy_read_page;
+
+		mem->memory[mem->page_count++] =
+		    phys_to_gart(page_to_phys(page));
+	}
+	agp_be->mem = mem;
+	return 0;
+}
+
+static int ttm_agp_bind(struct ttm_backend *backend, struct ttm_mem_reg *bo_mem)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct agp_memory *mem = agp_be->mem;
+	int cached = (bo_mem->placement & TTM_PL_FLAG_CACHED);
+	int ret;
+
+	mem->is_flushed = 1;
+	mem->type = (cached) ? AGP_USER_CACHED_MEMORY : AGP_USER_MEMORY;
+
+	ret = agp_bind_memory(mem, bo_mem->mm_node->start);
+	if (ret)
+		printk(KERN_ERR TTM_PFX "AGP Bind memory failed.\n");
+
+	return ret;
+}
+
+static int ttm_agp_unbind(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+
+	if (agp_be->mem->is_bound)
+		return agp_unbind_memory(agp_be->mem);
+	else
+		return 0;
+}
+
+static void ttm_agp_clear(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+	struct agp_memory *mem = agp_be->mem;
+
+	if (mem) {
+		ttm_agp_unbind(backend);
+		agp_free_memory(mem);
+	}
+	agp_be->mem = NULL;
+}
+
+static void ttm_agp_destroy(struct ttm_backend *backend)
+{
+	struct ttm_agp_backend *agp_be =
+	    container_of(backend, struct ttm_agp_backend, backend);
+
+	if (agp_be->mem)
+		ttm_agp_clear(backend);
+	kfree(agp_be);
+}
+
+static struct ttm_backend_func ttm_agp_func = {
+	.populate = ttm_agp_populate,
+	.clear = ttm_agp_clear,
+	.bind = ttm_agp_bind,
+	.unbind = ttm_agp_unbind,
+	.destroy = ttm_agp_destroy,
+};
+
+struct ttm_backend *ttm_agp_backend_init(struct ttm_bo_device *bdev,
+					 struct agp_bridge_data *bridge)
+{
+	struct ttm_agp_backend *agp_be;
+
+	agp_be = kmalloc(sizeof(*agp_be), GFP_KERNEL);
+	if (!agp_be)
+		return NULL;
+
+	agp_be->mem = NULL;
+	agp_be->bridge = bridge;
+	agp_be->backend.func = &ttm_agp_func;
+	agp_be->backend.bdev = bdev;
+	return &agp_be->backend;
+}
+EXPORT_SYMBOL(ttm_agp_backend_init);
+
+#endif
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
new file mode 100644
index 0000000..1587aec
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -0,0 +1,1698 @@
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
+#include "ttm/ttm_module.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement.h"
+#include <linux/jiffies.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/file.h>
+#include <linux/module.h>
+
+#define TTM_ASSERT_LOCKED(param)
+#define TTM_DEBUG(fmt, arg...)
+#define TTM_BO_HASH_ORDER 13
+
+static int ttm_bo_setup_vm(struct ttm_buffer_object *bo);
+static void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo);
+static int ttm_bo_swapout(struct ttm_mem_shrink *shrink);
+
+static inline uint32_t ttm_bo_type_flags(unsigned type)
+{
+	return 1 << (type);
+}
+
+static void ttm_bo_release_list(struct kref *list_kref)
+{
+	struct ttm_buffer_object *bo =
+	    container_of(list_kref, struct ttm_buffer_object, list_kref);
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	BUG_ON(atomic_read(&bo->list_kref.refcount));
+	BUG_ON(atomic_read(&bo->kref.refcount));
+	BUG_ON(atomic_read(&bo->cpu_writers));
+	BUG_ON(bo->sync_obj != NULL);
+	BUG_ON(bo->mem.mm_node != NULL);
+	BUG_ON(!list_empty(&bo->lru));
+	BUG_ON(!list_empty(&bo->ddestroy));
+
+	if (bo->ttm)
+		ttm_tt_destroy(bo->ttm);
+	if (bo->destroy)
+		bo->destroy(bo);
+	else {
+		ttm_mem_global_free(bdev->mem_glob, bo->acc_size, false);
+		kfree(bo);
+	}
+}
+
+int ttm_bo_wait_unreserved(struct ttm_buffer_object *bo, bool interruptible)
+{
+
+	if (interruptible) {
+		int ret = 0;
+
+		ret = wait_event_interruptible(bo->event_queue,
+					       atomic_read(&bo->reserved) == 0);
+		if (unlikely(ret != 0))
+			return -ERESTART;
+	} else {
+		wait_event(bo->event_queue, atomic_read(&bo->reserved) == 0);
+	}
+	return 0;
+}
+
+static void ttm_bo_add_to_lru(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	if (!(bo->mem.placement & TTM_PL_FLAG_NO_EVICT)) {
+
+		BUG_ON(!list_empty(&bo->lru));
+
+		man = &bdev->man[bo->mem.mem_type];
+		list_add_tail(&bo->lru, &man->lru);
+		kref_get(&bo->list_kref);
+
+		if (bo->ttm != NULL) {
+			list_add_tail(&bo->swap, &bdev->swap_lru);
+			kref_get(&bo->list_kref);
+		}
+	}
+}
+
+/**
+ * Call with the lru_lock held.
+ */
+
+static int ttm_bo_del_from_lru(struct ttm_buffer_object *bo)
+{
+	int put_count = 0;
+
+	if (!list_empty(&bo->swap)) {
+		list_del_init(&bo->swap);
+		++put_count;
+	}
+	if (!list_empty(&bo->lru)) {
+		list_del_init(&bo->lru);
+		++put_count;
+	}
+
+	/*
+	 * TODO: Add a driver hook to delete from
+	 * driver-specific LRU's here.
+	 */
+
+	return put_count;
+}
+
+int ttm_bo_reserve_locked(struct ttm_buffer_object *bo,
+			  bool interruptible,
+			  bool no_wait, bool use_sequence, uint32_t sequence)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		if (use_sequence && bo->seq_valid &&
+			(sequence - bo->val_seq < (1 << 31))) {
+			return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&bdev->lru_lock);
+		ret = ttm_bo_wait_unreserved(bo, interruptible);
+		spin_lock(&bdev->lru_lock);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	if (use_sequence) {
+		bo->val_seq = sequence;
+		bo->seq_valid = true;
+	} else {
+		bo->seq_valid = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ttm_bo_reserve);
+
+static void ttm_bo_ref_bug(struct kref *list_kref)
+{
+	BUG();
+}
+
+int ttm_bo_reserve(struct ttm_buffer_object *bo,
+		   bool interruptible,
+		   bool no_wait, bool use_sequence, uint32_t sequence)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int put_count = 0;
+	int ret;
+
+	spin_lock(&bdev->lru_lock);
+	ret = ttm_bo_reserve_locked(bo, interruptible, no_wait, use_sequence,
+				    sequence);
+	if (likely(ret == 0))
+		put_count = ttm_bo_del_from_lru(bo);
+	spin_unlock(&bdev->lru_lock);
+
+	while (put_count--)
+		kref_put(&bo->list_kref, ttm_bo_ref_bug);
+
+	return ret;
+}
+
+void ttm_bo_unreserve(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	spin_lock(&bdev->lru_lock);
+	ttm_bo_add_to_lru(bo);
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	spin_unlock(&bdev->lru_lock);
+}
+EXPORT_SYMBOL(ttm_bo_unreserve);
+
+/*
+ * Call bo->mutex locked.
+ */
+
+static int ttm_bo_add_ttm(struct ttm_buffer_object *bo, bool zero_alloc)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret = 0;
+	uint32_t page_flags = 0;
+
+	TTM_ASSERT_LOCKED(&bo->mutex);
+	bo->ttm = NULL;
+
+	switch (bo->type) {
+	case ttm_bo_type_device:
+		if (zero_alloc)
+			page_flags |= TTM_PAGE_FLAG_ZERO_ALLOC;
+	case ttm_bo_type_kernel:
+		bo->ttm = ttm_tt_create(bdev, bo->num_pages << PAGE_SHIFT,
+					page_flags, bdev->dummy_read_page);
+		if (unlikely(bo->ttm == NULL))
+			ret = -ENOMEM;
+		break;
+	case ttm_bo_type_user:
+		bo->ttm = ttm_tt_create(bdev, bo->num_pages << PAGE_SHIFT,
+					page_flags | TTM_PAGE_FLAG_USER,
+					bdev->dummy_read_page);
+		if (unlikely(bo->ttm == NULL))
+			ret = -ENOMEM;
+		break;
+
+		ret = ttm_tt_set_user(bo->ttm, current,
+				      bo->buffer_start, bo->num_pages);
+		if (unlikely(ret != 0))
+			ttm_tt_destroy(bo->ttm);
+		break;
+	default:
+		printk(KERN_ERR TTM_PFX "Illegal buffer object type\n");
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
+				  struct ttm_mem_reg *mem,
+				  bool evict, bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	bool old_is_pci = ttm_mem_reg_is_pci(bdev, &bo->mem);
+	bool new_is_pci = ttm_mem_reg_is_pci(bdev, mem);
+	struct ttm_mem_type_manager *old_man = &bdev->man[bo->mem.mem_type];
+	struct ttm_mem_type_manager *new_man = &bdev->man[mem->mem_type];
+	int ret = 0;
+
+	if (old_is_pci || new_is_pci ||
+	    ((mem->placement & bo->mem.placement & TTM_PL_MASK_CACHING) == 0))
+		ttm_bo_unmap_virtual(bo);
+
+	/*
+	 * Create and bind a ttm if required.
+	 */
+
+	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && (bo->ttm == NULL)) {
+		ret = ttm_bo_add_ttm(bo, false);
+		if (ret)
+			goto out_err;
+
+		ret = ttm_tt_set_placement_caching(bo->ttm, mem->placement);
+		if (ret)
+			return ret;
+
+		if (mem->mem_type != TTM_PL_SYSTEM) {
+			ret = ttm_tt_bind(bo->ttm, mem);
+			if (ret)
+				goto out_err;
+		}
+
+		if (bo->mem.mem_type == TTM_PL_SYSTEM) {
+
+			struct ttm_mem_reg *old_mem = &bo->mem;
+			uint32_t save_flags = old_mem->placement;
+
+			*old_mem = *mem;
+			mem->mm_node = NULL;
+			ttm_flag_masked(&save_flags, mem->placement,
+					TTM_PL_MASK_MEMTYPE);
+			goto moved;
+		}
+
+	}
+
+	if (!(old_man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
+	    !(new_man->flags & TTM_MEMTYPE_FLAG_FIXED))
+		ret = ttm_bo_move_ttm(bo, evict, no_wait, mem);
+	else if (bdev->driver->move)
+		ret = bdev->driver->move(bo, evict, interruptible,
+					 no_wait, mem);
+	else
+		ret = ttm_bo_move_memcpy(bo, evict, no_wait, mem);
+
+	if (ret)
+		goto out_err;
+
+moved:
+	if (bo->evicted) {
+		ret = bdev->driver->invalidate_caches(bdev, bo->mem.placement);
+		if (ret)
+			printk(KERN_ERR TTM_PFX "Can not flush read caches\n");
+		bo->evicted = false;
+	}
+
+	if (bo->mem.mm_node) {
+		spin_lock(&bo->lock);
+		bo->offset = (bo->mem.mm_node->start << PAGE_SHIFT) +
+		    bdev->man[bo->mem.mem_type].gpu_offset;
+		bo->cur_placement = bo->mem.placement;
+		spin_unlock(&bo->lock);
+	}
+
+	return 0;
+
+out_err:
+	new_man = &bdev->man[bo->mem.mem_type];
+	if ((new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && bo->ttm) {
+		ttm_tt_unbind(bo->ttm);
+		ttm_tt_destroy(bo->ttm);
+		bo->ttm = NULL;
+	}
+
+	return ret;
+}
+
+/**
+ * If bo idle, remove from delayed- and lru lists, and unref.
+ * If not idle, and already on delayed list, do nothing.
+ * If not idle, and not on delayed list, put on delayed list,
+ *   up the list_kref and schedule a delayed list check.
+ */
+
+static int ttm_bo_cleanup_refs(struct ttm_buffer_object *bo, bool remove_all)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+	int ret;
+
+	spin_lock(&bo->lock);
+	(void) ttm_bo_wait(bo, false, false, !remove_all);
+
+	if (!bo->sync_obj) {
+		int put_count;
+
+		spin_unlock(&bo->lock);
+
+		spin_lock(&bdev->lru_lock);
+		ret = ttm_bo_reserve_locked(bo, false, false, false, 0);
+		BUG_ON(ret);
+		if (bo->ttm)
+			ttm_tt_unbind(bo->ttm);
+
+		if (!list_empty(&bo->ddestroy)) {
+			list_del_init(&bo->ddestroy);
+			kref_put(&bo->list_kref, ttm_bo_ref_bug);
+		}
+		if (bo->mem.mm_node) {
+			drm_mm_put_block(bo->mem.mm_node);
+			bo->mem.mm_node = NULL;
+		}
+		put_count = ttm_bo_del_from_lru(bo);
+		spin_unlock(&bdev->lru_lock);
+
+		atomic_set(&bo->reserved, 0);
+
+		while (put_count--)
+			kref_put(&bo->list_kref, ttm_bo_release_list);
+
+		return 0;
+	}
+
+	spin_lock(&bdev->lru_lock);
+	if (list_empty(&bo->ddestroy)) {
+		void *sync_obj = bo->sync_obj;
+		void *sync_obj_arg = bo->sync_obj_arg;
+
+		kref_get(&bo->list_kref);
+		list_add_tail(&bo->ddestroy, &bdev->ddestroy);
+		spin_unlock(&bdev->lru_lock);
+		spin_unlock(&bo->lock);
+
+		if (sync_obj)
+			driver->sync_obj_flush(sync_obj, sync_obj_arg);
+		schedule_delayed_work(&bdev->wq,
+				      ((HZ / 100) < 1) ? 1 : HZ / 100);
+		ret = 0;
+
+	} else {
+		spin_unlock(&bdev->lru_lock);
+		spin_unlock(&bo->lock);
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
+/**
+ * Traverse the delayed list, and call ttm_bo_cleanup_refs on all
+ * encountered buffers.
+ */
+
+static int ttm_bo_delayed_delete(struct ttm_bo_device *bdev, bool remove_all)
+{
+	struct ttm_buffer_object *entry, *nentry;
+	struct list_head *list, *next;
+	int ret;
+
+	spin_lock(&bdev->lru_lock);
+	list_for_each_safe(list, next, &bdev->ddestroy) {
+		entry = list_entry(list, struct ttm_buffer_object, ddestroy);
+		nentry = NULL;
+
+		/*
+		 * Protect the next list entry from destruction while we
+		 * unlock the lru_lock.
+		 */
+
+		if (next != &bdev->ddestroy) {
+			nentry = list_entry(next, struct ttm_buffer_object,
+					    ddestroy);
+			kref_get(&nentry->list_kref);
+		}
+		kref_get(&entry->list_kref);
+
+		spin_unlock(&bdev->lru_lock);
+		ret = ttm_bo_cleanup_refs(entry, remove_all);
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+
+		spin_lock(&bdev->lru_lock);
+		if (nentry) {
+			bool next_onlist = !list_empty(next);
+			spin_unlock(&bdev->lru_lock);
+			kref_put(&nentry->list_kref, ttm_bo_release_list);
+			spin_lock(&bdev->lru_lock);
+			/*
+			 * Someone might have raced us and removed the
+			 * next entry from the list. We don't bother restarting
+			 * list traversal.
+			 */
+
+			if (!next_onlist)
+				break;
+		}
+		if (ret)
+			break;
+	}
+	ret = !list_empty(&bdev->ddestroy);
+	spin_unlock(&bdev->lru_lock);
+
+	return ret;
+}
+
+static void ttm_bo_delayed_workqueue(struct work_struct *work)
+{
+	struct ttm_bo_device *bdev =
+	    container_of(work, struct ttm_bo_device, wq.work);
+
+	if (ttm_bo_delayed_delete(bdev, false)) {
+		schedule_delayed_work(&bdev->wq,
+				      ((HZ / 100) < 1) ? 1 : HZ / 100);
+	}
+}
+
+static void ttm_bo_release(struct kref *kref)
+{
+	struct ttm_buffer_object *bo =
+	    container_of(kref, struct ttm_buffer_object, kref);
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	if (likely(bo->vm_node != NULL)) {
+		rb_erase(&bo->vm_rb, &bdev->addr_space_rb);
+		drm_mm_put_block(bo->vm_node);
+		bo->vm_node = NULL;
+	}
+	write_unlock(&bdev->vm_lock);
+	ttm_bo_cleanup_refs(bo, false);
+	kref_put(&bo->list_kref, ttm_bo_release_list);
+	write_lock(&bdev->vm_lock);
+}
+
+void ttm_bo_unref(struct ttm_buffer_object **p_bo)
+{
+	struct ttm_buffer_object *bo = *p_bo;
+	struct ttm_bo_device *bdev = bo->bdev;
+
+	*p_bo = NULL;
+	write_lock(&bdev->vm_lock);
+	kref_put(&bo->kref, ttm_bo_release);
+	write_unlock(&bdev->vm_lock);
+}
+EXPORT_SYMBOL(ttm_bo_unref);
+
+static int ttm_bo_evict(struct ttm_buffer_object *bo, unsigned mem_type,
+			bool interruptible, bool no_wait)
+{
+	int ret = 0;
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_reg evict_mem;
+	uint32_t proposed_placement;
+
+	if (bo->mem.mem_type != mem_type)
+		goto out;
+
+	spin_lock(&bo->lock);
+	ret = ttm_bo_wait(bo, false, interruptible, no_wait);
+	spin_unlock(&bo->lock);
+
+	if (ret && ret != -ERESTART) {
+		printk(KERN_ERR TTM_PFX "Failed to expire sync object before "
+		       "buffer eviction.\n");
+		goto out;
+	}
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	evict_mem = bo->mem;
+	evict_mem.mm_node = NULL;
+
+	proposed_placement = bdev->driver->evict_flags(bo);
+
+	ret = ttm_bo_mem_space(bo, proposed_placement,
+			       &evict_mem, interruptible, no_wait);
+	if (unlikely(ret != 0 && ret != -ERESTART))
+		ret = ttm_bo_mem_space(bo, TTM_PL_FLAG_SYSTEM,
+				       &evict_mem, interruptible, no_wait);
+
+	if (ret) {
+		if (ret != -ERESTART)
+			printk(KERN_ERR TTM_PFX
+			       "Failed to find memory space for "
+			       "buffer 0x%p eviction.\n", bo);
+		goto out;
+	}
+
+	ret = ttm_bo_handle_move_mem(bo, &evict_mem, true, interruptible,
+				     no_wait);
+	if (ret) {
+		if (ret != -ERESTART)
+			printk(KERN_ERR TTM_PFX "Buffer eviction failed\n");
+		goto out;
+	}
+
+	spin_lock(&bdev->lru_lock);
+	if (evict_mem.mm_node) {
+		drm_mm_put_block(evict_mem.mm_node);
+		evict_mem.mm_node = NULL;
+	}
+	spin_unlock(&bdev->lru_lock);
+	bo->evicted = true;
+out:
+	return ret;
+}
+
+/**
+ * Repeatedly evict memory from the LRU for @mem_type until we create enough
+ * space, or we've evicted everything and there isn't enough space.
+ */
+static int ttm_bo_mem_force_space(struct ttm_bo_device *bdev,
+				  struct ttm_mem_reg *mem,
+				  uint32_t mem_type,
+				  bool interruptible, bool no_wait)
+{
+	struct drm_mm_node *node;
+	struct ttm_buffer_object *entry;
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+	struct list_head *lru;
+	unsigned long num_pages = mem->num_pages;
+	int put_count = 0;
+	int ret;
+
+retry_pre_get:
+	ret = drm_mm_pre_get(&man->manager);
+	if (unlikely(ret != 0))
+		return ret;
+
+	spin_lock(&bdev->lru_lock);
+	do {
+		node = drm_mm_search_free(&man->manager, num_pages,
+					  mem->page_alignment, 1);
+		if (node)
+			break;
+
+		lru = &man->lru;
+		if (list_empty(lru))
+			break;
+
+		entry = list_first_entry(lru, struct ttm_buffer_object, lru);
+		kref_get(&entry->list_kref);
+
+		ret =
+		    ttm_bo_reserve_locked(entry, interruptible, no_wait,
+					  false, 0);
+
+		if (likely(ret == 0))
+			put_count = ttm_bo_del_from_lru(entry);
+
+		spin_unlock(&bdev->lru_lock);
+
+		if (unlikely(ret != 0))
+			return ret;
+
+		while (put_count--)
+			kref_put(&entry->list_kref, ttm_bo_ref_bug);
+
+		ret = ttm_bo_evict(entry, mem_type, interruptible, no_wait);
+
+		ttm_bo_unreserve(entry);
+
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+		if (ret)
+			return ret;
+
+		spin_lock(&bdev->lru_lock);
+	} while (1);
+
+	if (!node) {
+		spin_unlock(&bdev->lru_lock);
+		return -ENOMEM;
+	}
+
+	node = drm_mm_get_block_atomic(node, num_pages, mem->page_alignment);
+	if (unlikely(!node)) {
+		spin_unlock(&bdev->lru_lock);
+		goto retry_pre_get;
+	}
+
+	spin_unlock(&bdev->lru_lock);
+	mem->mm_node = node;
+	mem->mem_type = mem_type;
+	return 0;
+}
+
+static bool ttm_bo_mt_compatible(struct ttm_mem_type_manager *man,
+				 bool disallow_fixed,
+				 uint32_t mem_type,
+				 uint32_t mask, uint32_t *res_mask)
+{
+	uint32_t cur_flags = ttm_bo_type_flags(mem_type);
+
+	if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) && disallow_fixed)
+		return false;
+
+	if ((cur_flags & mask & TTM_PL_MASK_MEM) == 0)
+		return false;
+
+	if ((mask & man->available_caching) == 0)
+		return false;
+	if (mask & man->default_caching)
+		cur_flags |= man->default_caching;
+	else if (mask & TTM_PL_FLAG_CACHED)
+		cur_flags |= TTM_PL_FLAG_CACHED;
+	else if (mask & TTM_PL_FLAG_WC)
+		cur_flags |= TTM_PL_FLAG_WC;
+	else
+		cur_flags |= TTM_PL_FLAG_UNCACHED;
+
+	*res_mask = cur_flags;
+	return true;
+}
+
+/**
+ * Creates space for memory region @mem according to its type.
+ *
+ * This function first searches for free space in compatible memory types in
+ * the priority order defined by the driver.  If free space isn't found, then
+ * ttm_bo_mem_force_space is attempted in priority order to evict and find
+ * space.
+ */
+int ttm_bo_mem_space(struct ttm_buffer_object *bo,
+		     uint32_t proposed_placement,
+		     struct ttm_mem_reg *mem,
+		     bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man;
+
+	uint32_t num_prios = bdev->driver->num_mem_type_prio;
+	const uint32_t *prios = bdev->driver->mem_type_prio;
+	uint32_t i;
+	uint32_t mem_type = TTM_PL_SYSTEM;
+	uint32_t cur_flags = 0;
+	bool type_found = false;
+	bool type_ok = false;
+	bool has_eagain = false;
+	struct drm_mm_node *node = NULL;
+	int ret;
+
+	mem->mm_node = NULL;
+	for (i = 0; i < num_prios; ++i) {
+		mem_type = prios[i];
+		man = &bdev->man[mem_type];
+
+		type_ok = ttm_bo_mt_compatible(man,
+					       bo->type == ttm_bo_type_user,
+					       mem_type, proposed_placement,
+					       &cur_flags);
+
+		if (!type_ok)
+			continue;
+
+		if (mem_type == TTM_PL_SYSTEM)
+			break;
+
+		if (man->has_type && man->use_type) {
+			type_found = true;
+			do {
+				ret = drm_mm_pre_get(&man->manager);
+				if (unlikely(ret))
+					return ret;
+
+				spin_lock(&bdev->lru_lock);
+				node = drm_mm_search_free(&man->manager,
+							  mem->num_pages,
+							  mem->page_alignment,
+							  1);
+				if (unlikely(!node)) {
+					spin_unlock(&bdev->lru_lock);
+					break;
+				}
+				node = drm_mm_get_block_atomic(node,
+							       mem->num_pages,
+							       mem->
+							       page_alignment);
+				spin_unlock(&bdev->lru_lock);
+			} while (!node);
+		}
+		if (node)
+			break;
+	}
+
+	if ((type_ok && (mem_type == TTM_PL_SYSTEM)) || node) {
+		mem->mm_node = node;
+		mem->mem_type = mem_type;
+		mem->placement = cur_flags;
+		return 0;
+	}
+
+	if (!type_found)
+		return -EINVAL;
+
+	num_prios = bdev->driver->num_mem_busy_prio;
+	prios = bdev->driver->mem_busy_prio;
+
+	for (i = 0; i < num_prios; ++i) {
+		mem_type = prios[i];
+		man = &bdev->man[mem_type];
+
+		if (!man->has_type)
+			continue;
+
+		if (!ttm_bo_mt_compatible(man,
+					  bo->type == ttm_bo_type_user,
+					  mem_type,
+					  proposed_placement, &cur_flags))
+			continue;
+
+		ret = ttm_bo_mem_force_space(bdev, mem, mem_type,
+					     interruptible, no_wait);
+
+		if (ret == 0 && mem->mm_node) {
+			mem->placement = cur_flags;
+			return 0;
+		}
+
+		if (ret == -ERESTART)
+			has_eagain = true;
+	}
+
+	ret = (has_eagain) ? -ERESTART : -ENOMEM;
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_mem_space);
+
+int ttm_bo_wait_cpu(struct ttm_buffer_object *bo, bool no_wait)
+{
+	int ret = 0;
+
+	if ((atomic_read(&bo->cpu_writers) > 0) && no_wait)
+		return -EBUSY;
+
+	ret = wait_event_interruptible(bo->event_queue,
+				       atomic_read(&bo->cpu_writers) == 0);
+
+	if (ret == -ERESTARTSYS)
+		ret = -ERESTART;
+
+	return ret;
+}
+
+int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
+		       uint32_t proposed_placement,
+		       bool interruptible, bool no_wait)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret = 0;
+	struct ttm_mem_reg mem;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+
+	/*
+	 * FIXME: It's possible to pipeline buffer moves.
+	 * Have the driver move function wait for idle when necessary,
+	 * instead of doing it here.
+	 */
+
+	spin_lock(&bo->lock);
+	ret = ttm_bo_wait(bo, false, interruptible, no_wait);
+	spin_unlock(&bo->lock);
+
+	if (ret)
+		return ret;
+
+	mem.num_pages = bo->num_pages;
+	mem.size = mem.num_pages << PAGE_SHIFT;
+	mem.page_alignment = bo->mem.page_alignment;
+
+	/*
+	 * Determine where to move the buffer.
+	 */
+
+	ret = ttm_bo_mem_space(bo, proposed_placement, &mem,
+			       interruptible, no_wait);
+	if (ret)
+		goto out_unlock;
+
+	ret = ttm_bo_handle_move_mem(bo, &mem, false, interruptible, no_wait);
+
+out_unlock:
+	if (ret && mem.mm_node) {
+		spin_lock(&bdev->lru_lock);
+		drm_mm_put_block(mem.mm_node);
+		spin_unlock(&bdev->lru_lock);
+	}
+	return ret;
+}
+
+static int ttm_bo_mem_compat(uint32_t proposed_placement,
+			     struct ttm_mem_reg *mem)
+{
+	if ((proposed_placement & mem->placement & TTM_PL_MASK_MEM) == 0)
+		return 0;
+	if ((proposed_placement & mem->placement & TTM_PL_MASK_CACHING) == 0)
+		return 0;
+
+	return 1;
+}
+
+int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
+			       uint32_t proposed_placement,
+			       bool interruptible, bool no_wait)
+{
+	int ret;
+
+	BUG_ON(!atomic_read(&bo->reserved));
+	bo->proposed_placement = proposed_placement;
+
+	TTM_DEBUG("Proposed placement 0x%08lx, Old flags 0x%08lx\n",
+		  (unsigned long)proposed_placement,
+		  (unsigned long)bo->mem.placement);
+
+	/*
+	 * Check whether we need to move buffer.
+	 */
+
+	if (!ttm_bo_mem_compat(bo->proposed_placement, &bo->mem)) {
+		ret = ttm_bo_move_buffer(bo, bo->proposed_placement,
+					 interruptible, no_wait);
+		if (ret) {
+			if (ret != -ERESTART)
+				printk(KERN_ERR TTM_PFX
+				       "Failed moving buffer. "
+				       "Proposed placement 0x%08x\n",
+				       bo->proposed_placement);
+			if (ret == -ENOMEM)
+				printk(KERN_ERR TTM_PFX
+				       "Out of aperture space or "
+				       "DRM memory quota.\n");
+			return ret;
+		}
+	}
+
+	/*
+	 * We might need to add a TTM.
+	 */
+
+	if (bo->mem.mem_type == TTM_PL_SYSTEM && bo->ttm == NULL) {
+		ret = ttm_bo_add_ttm(bo, true);
+		if (ret)
+			return ret;
+	}
+	/*
+	 * Validation has succeeded, move the access and other
+	 * non-mapping-related flag bits from the proposed flags to
+	 * the active flags
+	 */
+
+	ttm_flag_masked(&bo->mem.placement, bo->proposed_placement,
+			~TTM_PL_MASK_MEMTYPE);
+
+	return 0;
+}
+EXPORT_SYMBOL(ttm_buffer_object_validate);
+
+int
+ttm_bo_check_placement(struct ttm_buffer_object *bo,
+		       uint32_t set_flags, uint32_t clr_flags)
+{
+	uint32_t new_mask = set_flags | clr_flags;
+
+	if ((bo->type == ttm_bo_type_user) &&
+	    (clr_flags & TTM_PL_FLAG_CACHED)) {
+		printk(KERN_ERR TTM_PFX
+		       "User buffers require cache-coherent memory.\n");
+		return -EINVAL;
+	}
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (new_mask & TTM_PL_FLAG_NO_EVICT) {
+			printk(KERN_ERR TTM_PFX "Need to be root to modify"
+			       " NO_EVICT status.\n");
+			return -EINVAL;
+		}
+
+		if ((clr_flags & bo->mem.placement & TTM_PL_MASK_MEMTYPE) &&
+		    (bo->mem.placement & TTM_PL_FLAG_NO_EVICT)) {
+			printk(KERN_ERR TTM_PFX
+			       "Incompatible memory specification"
+			       " for NO_EVICT buffer.\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+int ttm_buffer_object_init(struct ttm_bo_device *bdev,
+			   struct ttm_buffer_object *bo,
+			   unsigned long size,
+			   enum ttm_bo_type type,
+			   uint32_t flags,
+			   uint32_t page_alignment,
+			   unsigned long buffer_start,
+			   bool interruptible,
+			   struct file *persistant_swap_storage,
+			   size_t acc_size,
+			   void (*destroy) (struct ttm_buffer_object *))
+{
+	int ret = 0;
+	unsigned long num_pages;
+
+	size += buffer_start & ~PAGE_MASK;
+	num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (num_pages == 0) {
+		printk(KERN_ERR TTM_PFX "Illegal buffer object size.\n");
+		return -EINVAL;
+	}
+	bo->destroy = destroy;
+
+	spin_lock_init(&bo->lock);
+	kref_init(&bo->kref);
+	kref_init(&bo->list_kref);
+	atomic_set(&bo->cpu_writers, 0);
+	atomic_set(&bo->reserved, 1);
+	init_waitqueue_head(&bo->event_queue);
+	INIT_LIST_HEAD(&bo->lru);
+	INIT_LIST_HEAD(&bo->ddestroy);
+	INIT_LIST_HEAD(&bo->swap);
+	bo->bdev = bdev;
+	bo->type = type;
+	bo->num_pages = num_pages;
+	bo->mem.mem_type = TTM_PL_SYSTEM;
+	bo->mem.num_pages = bo->num_pages;
+	bo->mem.mm_node = NULL;
+	bo->mem.page_alignment = page_alignment;
+	bo->buffer_start = buffer_start & PAGE_MASK;
+	bo->priv_flags = 0;
+	bo->mem.placement = (TTM_PL_FLAG_SYSTEM | TTM_PL_FLAG_CACHED);
+	bo->seq_valid = false;
+	bo->persistant_swap_storage = persistant_swap_storage;
+	bo->acc_size = acc_size;
+
+	ret = ttm_bo_check_placement(bo, flags, 0ULL);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	/*
+	 * If no caching attributes are set, accept any form of caching.
+	 */
+
+	if ((flags & TTM_PL_MASK_CACHING) == 0)
+		flags |= TTM_PL_MASK_CACHING;
+
+	/*
+	 * For ttm_bo_type_device buffers, allocate
+	 * address space from the device.
+	 */
+
+	if (bo->type == ttm_bo_type_device) {
+		ret = ttm_bo_setup_vm(bo);
+		if (ret)
+			goto out_err;
+	}
+
+	ret = ttm_buffer_object_validate(bo, flags, interruptible, false);
+	if (ret)
+		goto out_err;
+
+	ttm_bo_unreserve(bo);
+	return 0;
+
+out_err:
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	return ret;
+}
+EXPORT_SYMBOL(ttm_buffer_object_init);
+
+static inline size_t ttm_bo_size(struct ttm_bo_device *bdev,
+				 unsigned long num_pages)
+{
+	size_t page_array_size = (num_pages * sizeof(void *) + PAGE_SIZE - 1) &
+	    PAGE_MASK;
+
+	return bdev->ttm_bo_size + 2 * page_array_size;
+}
+
+int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+			     unsigned long size,
+			     enum ttm_bo_type type,
+			     uint32_t flags,
+			     uint32_t page_alignment,
+			     unsigned long buffer_start,
+			     bool interruptible,
+			     struct file *persistant_swap_storage,
+			     struct ttm_buffer_object **p_bo)
+{
+	struct ttm_buffer_object *bo;
+	int ret;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+
+	size_t acc_size =
+	    ttm_bo_size(bdev, (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
+
+	if (unlikely(bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size, false);
+		return -ENOMEM;
+	}
+
+	ret = ttm_buffer_object_init(bdev, bo, size, type, flags,
+				     page_alignment, buffer_start,
+				     interruptible,
+				     persistant_swap_storage, acc_size, NULL);
+	if (likely(ret == 0))
+		*p_bo = bo;
+
+	return ret;
+}
+
+static int ttm_bo_leave_list(struct ttm_buffer_object *bo,
+			     uint32_t mem_type, bool allow_errors)
+{
+	int ret;
+
+	spin_lock(&bo->lock);
+	ret = ttm_bo_wait(bo, false, false, false);
+	spin_unlock(&bo->lock);
+
+	if (ret && allow_errors)
+		goto out;
+
+	if (bo->mem.mem_type == mem_type)
+		ret = ttm_bo_evict(bo, mem_type, false, false);
+
+	if (ret) {
+		if (allow_errors) {
+			goto out;
+		} else {
+			ret = 0;
+			printk(KERN_ERR TTM_PFX "Cleanup eviction failed\n");
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int ttm_bo_force_list_clean(struct ttm_bo_device *bdev,
+				   struct list_head *head,
+				   unsigned mem_type, bool allow_errors)
+{
+	struct ttm_buffer_object *entry;
+	int ret;
+	int put_count;
+
+	/*
+	 * Can't use standard list traversal since we're unlocking.
+	 */
+
+	spin_lock(&bdev->lru_lock);
+
+	while (!list_empty(head)) {
+		entry = list_first_entry(head, struct ttm_buffer_object, lru);
+		kref_get(&entry->list_kref);
+		ret = ttm_bo_reserve_locked(entry, false, false, false, 0);
+		put_count = ttm_bo_del_from_lru(entry);
+		spin_unlock(&bdev->lru_lock);
+		while (put_count--)
+			kref_put(&entry->list_kref, ttm_bo_ref_bug);
+		BUG_ON(ret);
+		ret = ttm_bo_leave_list(entry, mem_type, allow_errors);
+		ttm_bo_unreserve(entry);
+		kref_put(&entry->list_kref, ttm_bo_release_list);
+		spin_lock(&bdev->lru_lock);
+	}
+
+	spin_unlock(&bdev->lru_lock);
+
+	return 0;
+}
+
+int ttm_bo_clean_mm(struct ttm_bo_device *bdev, unsigned mem_type)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+	int ret = -EINVAL;
+
+	if (mem_type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR TTM_PFX "Illegal memory type %d\n", mem_type);
+		return ret;
+	}
+
+	if (!man->has_type) {
+		printk(KERN_ERR TTM_PFX "Trying to take down uninitialized "
+		       "memory manager type %u\n", mem_type);
+		return ret;
+	}
+
+	man->use_type = false;
+	man->has_type = false;
+
+	ret = 0;
+	if (mem_type > 0) {
+		ttm_bo_force_list_clean(bdev, &man->lru, mem_type, false);
+
+		spin_lock(&bdev->lru_lock);
+		if (drm_mm_clean(&man->manager))
+			drm_mm_takedown(&man->manager);
+		else
+			ret = -EBUSY;
+
+		spin_unlock(&bdev->lru_lock);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_clean_mm);
+
+int ttm_bo_evict_mm(struct ttm_bo_device *bdev, unsigned mem_type)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem_type];
+
+	if (mem_type == 0 || mem_type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR TTM_PFX
+		       "Illegal memory manager memory type %u.\n",
+		       mem_type);
+		return -EINVAL;
+	}
+
+	if (!man->has_type) {
+		printk(KERN_ERR TTM_PFX
+		       "Memory type %u has not been initialized.\n",
+		       mem_type);
+		return 0;
+	}
+
+	return ttm_bo_force_list_clean(bdev, &man->lru, mem_type, true);
+}
+EXPORT_SYMBOL(ttm_bo_evict_mm);
+
+int ttm_bo_init_mm(struct ttm_bo_device *bdev, unsigned type,
+		   unsigned long p_offset, unsigned long p_size)
+{
+	int ret = -EINVAL;
+	struct ttm_mem_type_manager *man;
+
+	if (type >= TTM_NUM_MEM_TYPES) {
+		printk(KERN_ERR TTM_PFX "Illegal memory type %d\n", type);
+		return ret;
+	}
+
+	man = &bdev->man[type];
+	if (man->has_type) {
+		printk(KERN_ERR TTM_PFX
+		       "Memory manager already initialized for type %d\n",
+		       type);
+		return ret;
+	}
+
+	ret = bdev->driver->init_mem_type(bdev, type, man);
+	if (ret)
+		return ret;
+
+	ret = 0;
+	if (type != TTM_PL_SYSTEM) {
+		if (!p_size) {
+			printk(KERN_ERR TTM_PFX
+			       "Zero size memory manager type %d\n",
+			       type);
+			return ret;
+		}
+		ret = drm_mm_init(&man->manager, p_offset, p_size);
+		if (ret)
+			return ret;
+	}
+	man->has_type = true;
+	man->use_type = true;
+	man->size = p_size;
+
+	INIT_LIST_HEAD(&man->lru);
+
+	return 0;
+}
+EXPORT_SYMBOL(ttm_bo_init_mm);
+
+int ttm_bo_device_release(struct ttm_bo_device *bdev)
+{
+	int ret = 0;
+	unsigned i = TTM_NUM_MEM_TYPES;
+	struct ttm_mem_type_manager *man;
+
+	while (i--) {
+		man = &bdev->man[i];
+		if (man->has_type) {
+			man->use_type = false;
+			if ((i != TTM_PL_SYSTEM) && ttm_bo_clean_mm(bdev, i)) {
+				ret = -EBUSY;
+				printk(KERN_ERR TTM_PFX
+				       "DRM memory manager type %d "
+				       "is not clean.\n", i);
+			}
+			man->has_type = false;
+		}
+	}
+
+	if (!cancel_delayed_work(&bdev->wq))
+		flush_scheduled_work();
+
+	while (ttm_bo_delayed_delete(bdev, true))
+		;
+
+	spin_lock(&bdev->lru_lock);
+	if (list_empty(&bdev->ddestroy))
+		TTM_DEBUG("Delayed destroy list was clean\n");
+
+	if (list_empty(&bdev->man[0].lru))
+		TTM_DEBUG("Swap list was clean\n");
+	spin_unlock(&bdev->lru_lock);
+
+	ttm_mem_unregister_shrink(bdev->mem_glob, &bdev->shrink);
+	BUG_ON(!drm_mm_clean(&bdev->addr_space_mm));
+	write_lock(&bdev->vm_lock);
+	drm_mm_takedown(&bdev->addr_space_mm);
+	write_unlock(&bdev->vm_lock);
+
+	__free_page(bdev->dummy_read_page);
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_device_release);
+
+/*
+ * This function is intended to be called on drm driver load.
+ * If you decide to call it from firstopen, you must protect the call
+ * from a potentially racing ttm_bo_driver_finish in lastclose.
+ * (This may happen on X server restart).
+ */
+
+int ttm_bo_device_init(struct ttm_bo_device *bdev,
+		       struct ttm_mem_global *mem_glob,
+		       struct ttm_bo_driver *driver, uint64_t file_page_offset)
+{
+	int ret = -EINVAL;
+
+	bdev->dummy_read_page = NULL;
+	rwlock_init(&bdev->vm_lock);
+	spin_lock_init(&bdev->lru_lock);
+
+	bdev->driver = driver;
+	bdev->mem_glob = mem_glob;
+
+	memset(bdev->man, 0, sizeof(bdev->man));
+
+	bdev->dummy_read_page = alloc_page(__GFP_ZERO | GFP_DMA32);
+	if (unlikely(bdev->dummy_read_page == NULL)) {
+		ret = -ENOMEM;
+		goto out_err0;
+	}
+
+	/*
+	 * Initialize the system memory buffer type.
+	 * Other types need to be driver / IOCTL initialized.
+	 */
+	ret = ttm_bo_init_mm(bdev, TTM_PL_SYSTEM, 0, 0);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	bdev->addr_space_rb = RB_ROOT;
+	ret = drm_mm_init(&bdev->addr_space_mm, file_page_offset, 0x10000000);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	INIT_DELAYED_WORK(&bdev->wq, ttm_bo_delayed_workqueue);
+	bdev->nice_mode = true;
+	INIT_LIST_HEAD(&bdev->ddestroy);
+	INIT_LIST_HEAD(&bdev->swap_lru);
+	bdev->dev_mapping = NULL;
+	ttm_mem_init_shrink(&bdev->shrink, ttm_bo_swapout);
+	ret = ttm_mem_register_shrink(mem_glob, &bdev->shrink);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR TTM_PFX
+		       "Could not register buffer object swapout.\n");
+		goto out_err2;
+	}
+
+	bdev->ttm_bo_extra_size =
+		ttm_round_pot(sizeof(struct ttm_tt)) +
+		ttm_round_pot(sizeof(struct ttm_backend));
+
+	bdev->ttm_bo_size = bdev->ttm_bo_extra_size +
+		ttm_round_pot(sizeof(struct ttm_buffer_object));
+
+	return 0;
+out_err2:
+	ttm_bo_clean_mm(bdev, 0);
+out_err1:
+	__free_page(bdev->dummy_read_page);
+out_err0:
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_device_init);
+
+/*
+ * buffer object vm functions.
+ */
+
+bool ttm_mem_reg_is_pci(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_FIXED)) {
+		if (mem->mem_type == TTM_PL_SYSTEM)
+			return false;
+
+		if (man->flags & TTM_MEMTYPE_FLAG_CMA)
+			return false;
+
+		if (mem->placement & TTM_PL_FLAG_CACHED)
+			return false;
+	}
+	return true;
+}
+
+int ttm_bo_pci_offset(struct ttm_bo_device *bdev,
+		      struct ttm_mem_reg *mem,
+		      unsigned long *bus_base,
+		      unsigned long *bus_offset, unsigned long *bus_size)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	*bus_size = 0;
+	if (!(man->flags & TTM_MEMTYPE_FLAG_MAPPABLE))
+		return -EINVAL;
+
+	if (ttm_mem_reg_is_pci(bdev, mem)) {
+		*bus_offset = mem->mm_node->start << PAGE_SHIFT;
+		*bus_size = mem->num_pages << PAGE_SHIFT;
+		*bus_base = man->io_offset;
+	}
+
+	return 0;
+}
+
+void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	loff_t offset = (loff_t) bo->addr_space_offset;
+	loff_t holelen = ((loff_t) bo->mem.num_pages) << PAGE_SHIFT;
+
+	if (!bdev->dev_mapping)
+		return;
+
+	unmap_mapping_range(bdev->dev_mapping, offset, holelen, 1);
+}
+
+static void ttm_bo_vm_insert_rb(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct rb_node **cur = &bdev->addr_space_rb.rb_node;
+	struct rb_node *parent = NULL;
+	struct ttm_buffer_object *cur_bo;
+	unsigned long offset = bo->vm_node->start;
+	unsigned long cur_offset;
+
+	while (*cur) {
+		parent = *cur;
+		cur_bo = rb_entry(parent, struct ttm_buffer_object, vm_rb);
+		cur_offset = cur_bo->vm_node->start;
+		if (offset < cur_offset)
+			cur = &parent->rb_left;
+		else if (offset > cur_offset)
+			cur = &parent->rb_right;
+		else
+			BUG();
+	}
+
+	rb_link_node(&bo->vm_rb, parent, cur);
+	rb_insert_color(&bo->vm_rb, &bdev->addr_space_rb);
+}
+
+/**
+ * ttm_bo_setup_vm:
+ *
+ * @bo: the buffer to allocate address space for
+ *
+ * Allocate address space in the drm device so that applications
+ * can mmap the buffer and access the contents. This only
+ * applies to ttm_bo_type_device objects as others are not
+ * placed in the drm device address space.
+ */
+
+static int ttm_bo_setup_vm(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	int ret;
+
+retry_pre_get:
+	ret = drm_mm_pre_get(&bdev->addr_space_mm);
+	if (unlikely(ret != 0))
+		return ret;
+
+	write_lock(&bdev->vm_lock);
+	bo->vm_node = drm_mm_search_free(&bdev->addr_space_mm,
+					 bo->mem.num_pages, 0, 0);
+
+	if (unlikely(bo->vm_node == NULL)) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	bo->vm_node = drm_mm_get_block_atomic(bo->vm_node,
+					      bo->mem.num_pages, 0);
+
+	if (unlikely(bo->vm_node == NULL)) {
+		write_unlock(&bdev->vm_lock);
+		goto retry_pre_get;
+	}
+
+	ttm_bo_vm_insert_rb(bo);
+	write_unlock(&bdev->vm_lock);
+	bo->addr_space_offset = ((uint64_t) bo->vm_node->start) << PAGE_SHIFT;
+
+	return 0;
+out_unlock:
+	write_unlock(&bdev->vm_lock);
+	return ret;
+}
+
+int ttm_bo_wait(struct ttm_buffer_object *bo,
+		bool lazy, bool interruptible, bool no_wait)
+{
+	struct ttm_bo_driver *driver = bo->bdev->driver;
+	void *sync_obj;
+	void *sync_obj_arg;
+	int ret = 0;
+
+	if (likely(bo->sync_obj == NULL))
+		return 0;
+
+	while (bo->sync_obj) {
+
+		if (driver->sync_obj_signaled(bo->sync_obj, bo->sync_obj_arg)) {
+			void *tmp_obj = bo->sync_obj;
+			bo->sync_obj = NULL;
+			clear_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
+			spin_unlock(&bo->lock);
+			driver->sync_obj_unref(&tmp_obj);
+			spin_lock(&bo->lock);
+			continue;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		sync_obj = driver->sync_obj_ref(bo->sync_obj);
+		sync_obj_arg = bo->sync_obj_arg;
+		spin_unlock(&bo->lock);
+		ret = driver->sync_obj_wait(sync_obj, sync_obj_arg,
+					    lazy, interruptible);
+		if (unlikely(ret != 0)) {
+			driver->sync_obj_unref(&sync_obj);
+			spin_lock(&bo->lock);
+			return ret;
+		}
+		spin_lock(&bo->lock);
+		if (likely(bo->sync_obj == sync_obj &&
+			   bo->sync_obj_arg == sync_obj_arg)) {
+			void *tmp_obj = bo->sync_obj;
+			bo->sync_obj = NULL;
+			clear_bit(TTM_BO_PRIV_FLAG_MOVING,
+				  &bo->priv_flags);
+			spin_unlock(&bo->lock);
+			driver->sync_obj_unref(&sync_obj);
+			driver->sync_obj_unref(&tmp_obj);
+			spin_lock(&bo->lock);
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ttm_bo_wait);
+
+void ttm_bo_unblock_reservation(struct ttm_buffer_object *bo)
+{
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+}
+
+int ttm_bo_block_reservation(struct ttm_buffer_object *bo, bool interruptible,
+			     bool no_wait)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		if (no_wait)
+			return -EBUSY;
+		else if (interruptible) {
+			ret = wait_event_interruptible
+			    (bo->event_queue, atomic_read(&bo->reserved) == 0);
+			if (unlikely(ret != 0))
+				return -ERESTART;
+		} else {
+			wait_event(bo->event_queue,
+				   atomic_read(&bo->reserved) == 0);
+		}
+	}
+	return 0;
+}
+
+int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait)
+{
+	int ret = 0;
+
+	/*
+	 * Using ttm_bo_reserve instead of ttm_bo_block_reservation
+	 * makes sure the lru lists are updated.
+	 */
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+	if (unlikely(ret != 0))
+		return ret;
+	spin_lock(&bo->lock);
+	ret = ttm_bo_wait(bo, false, true, no_wait);
+	spin_unlock(&bo->lock);
+	if (likely(ret == 0))
+		atomic_inc(&bo->cpu_writers);
+	ttm_bo_unreserve(bo);
+	return ret;
+}
+
+void ttm_bo_synccpu_write_release(struct ttm_buffer_object *bo)
+{
+	if (atomic_dec_and_test(&bo->cpu_writers))
+		wake_up_all(&bo->event_queue);
+}
+
+/**
+ * A buffer object shrink method that tries to swap out the first
+ * buffer object on the bo_global::swap_lru list.
+ */
+
+static int ttm_bo_swapout(struct ttm_mem_shrink *shrink)
+{
+	struct ttm_bo_device *bdev =
+	    container_of(shrink, struct ttm_bo_device, shrink);
+	struct ttm_buffer_object *bo;
+	int ret = -EBUSY;
+	int put_count;
+	uint32_t swap_placement = (TTM_PL_FLAG_CACHED | TTM_PL_FLAG_SYSTEM);
+
+	spin_lock(&bdev->lru_lock);
+	while (ret == -EBUSY) {
+		if (unlikely(list_empty(&bdev->swap_lru))) {
+			spin_unlock(&bdev->lru_lock);
+			return -EBUSY;
+		}
+
+		bo = list_first_entry(&bdev->swap_lru,
+				      struct ttm_buffer_object, swap);
+		kref_get(&bo->list_kref);
+
+		/**
+		 * Reserve buffer. Since we unlock while sleeping, we need
+		 * to re-check that nobody removed us from the swap-list while
+		 * we slept.
+		 */
+
+		ret = ttm_bo_reserve_locked(bo, false, true, false, 0);
+		if (unlikely(ret == -EBUSY)) {
+			spin_unlock(&bdev->lru_lock);
+			ttm_bo_wait_unreserved(bo, false);
+			kref_put(&bo->list_kref, ttm_bo_release_list);
+			spin_lock(&bdev->lru_lock);
+		}
+	}
+
+	BUG_ON(ret != 0);
+	put_count = ttm_bo_del_from_lru(bo);
+	spin_unlock(&bdev->lru_lock);
+
+	while (put_count--)
+		kref_put(&bo->list_kref, ttm_bo_ref_bug);
+
+	/**
+	 * Wait for GPU, then move to system cached.
+	 */
+
+	spin_lock(&bo->lock);
+	ret = ttm_bo_wait(bo, false, false, false);
+	spin_unlock(&bo->lock);
+
+	if (unlikely(ret != 0))
+		goto out;
+
+	if ((bo->mem.placement & swap_placement) != swap_placement) {
+		struct ttm_mem_reg evict_mem;
+
+		evict_mem = bo->mem;
+		evict_mem.mm_node = NULL;
+		evict_mem.placement = TTM_PL_FLAG_SYSTEM | TTM_PL_FLAG_CACHED;
+		evict_mem.mem_type = TTM_PL_SYSTEM;
+
+		ret = ttm_bo_handle_move_mem(bo, &evict_mem, true,
+					     false, false);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+
+	ttm_bo_unmap_virtual(bo);
+
+	/**
+	 * Swap out. Buffer will be swapped in again as soon as
+	 * anyone tries to access a ttm page.
+	 */
+
+	ret = ttm_tt_swapout(bo->ttm, bo->persistant_swap_storage);
+out:
+
+	/**
+	 *
+	 * Unreserve without putting on LRU to avoid swapping out an
+	 * already swapped buffer.
+	 */
+
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+	kref_put(&bo->list_kref, ttm_bo_release_list);
+	return ret;
+}
+
+void ttm_bo_swapout_all(struct ttm_bo_device *bdev)
+{
+	while (ttm_bo_swapout(&bdev->shrink) == 0)
+		;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
new file mode 100644
index 0000000..517c845
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -0,0 +1,561 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2009 VMware, Inc., Palo Alto, CA., USA
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
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement.h"
+#include <linux/io.h>
+#include <linux/highmem.h>
+#include <linux/wait.h>
+#include <linux/vmalloc.h>
+#include <linux/version.h>
+#include <linux/module.h>
+
+void ttm_bo_free_old_node(struct ttm_buffer_object *bo)
+{
+	struct ttm_mem_reg *old_mem = &bo->mem;
+
+	if (old_mem->mm_node) {
+		spin_lock(&bo->bdev->lru_lock);
+		drm_mm_put_block(old_mem->mm_node);
+		spin_unlock(&bo->bdev->lru_lock);
+	}
+	old_mem->mm_node = NULL;
+}
+
+int ttm_bo_move_ttm(struct ttm_buffer_object *bo,
+		    bool evict, bool no_wait, struct ttm_mem_reg *new_mem)
+{
+	struct ttm_tt *ttm = bo->ttm;
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	uint32_t save_flags = old_mem->placement;
+	int ret;
+
+	if (old_mem->mem_type != TTM_PL_SYSTEM) {
+		ttm_tt_unbind(ttm);
+		ttm_bo_free_old_node(bo);
+		ttm_flag_masked(&old_mem->placement, TTM_PL_FLAG_SYSTEM,
+				TTM_PL_MASK_MEM);
+		old_mem->mem_type = TTM_PL_SYSTEM;
+		save_flags = old_mem->placement;
+	}
+
+	ret = ttm_tt_set_placement_caching(ttm, new_mem->placement);
+	if (unlikely(ret != 0))
+		return ret;
+
+	if (new_mem->mem_type != TTM_PL_SYSTEM) {
+		ret = ttm_tt_bind(ttm, new_mem);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	ttm_flag_masked(&save_flags, new_mem->placement, TTM_PL_MASK_MEMTYPE);
+	return 0;
+}
+EXPORT_SYMBOL(ttm_bo_move_ttm);
+
+int ttm_mem_reg_ioremap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+			void **virtual)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long bus_base;
+	int ret;
+	void *addr;
+
+	*virtual = NULL;
+	ret = ttm_bo_pci_offset(bdev, mem, &bus_base, &bus_offset, &bus_size);
+	if (ret || bus_size == 0)
+		return ret;
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP))
+		addr = (void *)(((u8 *) man->io_addr) + bus_offset);
+	else {
+		if (mem->placement & TTM_PL_FLAG_WC)
+			addr = ioremap_wc(bus_base + bus_offset, bus_size);
+		else
+			addr = ioremap_nocache(bus_base + bus_offset, bus_size);
+		if (!addr)
+			return -ENOMEM;
+	}
+	*virtual = addr;
+	return 0;
+}
+
+void ttm_mem_reg_iounmap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+			 void *virtual)
+{
+	struct ttm_mem_type_manager *man;
+
+	man = &bdev->man[mem->mem_type];
+
+	if (virtual && (man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP))
+		iounmap(virtual);
+}
+
+static int ttm_copy_io_page(void *dst, void *src, unsigned long page)
+{
+	uint32_t *dstP =
+	    (uint32_t *) ((unsigned long)dst + (page << PAGE_SHIFT));
+	uint32_t *srcP =
+	    (uint32_t *) ((unsigned long)src + (page << PAGE_SHIFT));
+
+	int i;
+	for (i = 0; i < PAGE_SIZE / sizeof(uint32_t); ++i)
+		iowrite32(ioread32(srcP++), dstP++);
+	return 0;
+}
+
+static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
+				unsigned long page)
+{
+	struct page *d = ttm_tt_get_page(ttm, page);
+	void *dst;
+
+	if (!d)
+		return -ENOMEM;
+
+	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
+	dst = kmap(d);
+	if (!dst)
+		return -ENOMEM;
+
+	memcpy_fromio(dst, src, PAGE_SIZE);
+	kunmap(d);
+	return 0;
+}
+
+static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
+				unsigned long page)
+{
+	struct page *s = ttm_tt_get_page(ttm, page);
+	void *src;
+
+	if (!s)
+		return -ENOMEM;
+
+	dst = (void *)((unsigned long)dst + (page << PAGE_SHIFT));
+	src = kmap(s);
+	if (!src)
+		return -ENOMEM;
+
+	memcpy_toio(dst, src, PAGE_SIZE);
+	kunmap(s);
+	return 0;
+}
+
+int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
+		       bool evict, bool no_wait, struct ttm_mem_reg *new_mem)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_type_manager *man = &bdev->man[new_mem->mem_type];
+	struct ttm_tt *ttm = bo->ttm;
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	struct ttm_mem_reg old_copy = *old_mem;
+	void *old_iomap;
+	void *new_iomap;
+	int ret;
+	uint32_t save_flags = old_mem->placement;
+	unsigned long i;
+	unsigned long page;
+	unsigned long add = 0;
+	int dir;
+
+	ret = ttm_mem_reg_ioremap(bdev, old_mem, &old_iomap);
+	if (ret)
+		return ret;
+	ret = ttm_mem_reg_ioremap(bdev, new_mem, &new_iomap);
+	if (ret)
+		goto out;
+
+	if (old_iomap == NULL && new_iomap == NULL)
+		goto out2;
+	if (old_iomap == NULL && ttm == NULL)
+		goto out2;
+
+	add = 0;
+	dir = 1;
+
+	if ((old_mem->mem_type == new_mem->mem_type) &&
+	    (new_mem->mm_node->start <
+	     old_mem->mm_node->start + old_mem->mm_node->size)) {
+		dir = -1;
+		add = new_mem->num_pages - 1;
+	}
+
+	for (i = 0; i < new_mem->num_pages; ++i) {
+		page = i * dir + add;
+		if (old_iomap == NULL)
+			ret = ttm_copy_ttm_io_page(ttm, new_iomap, page);
+		else if (new_iomap == NULL)
+			ret = ttm_copy_io_ttm_page(ttm, old_iomap, page);
+		else
+			ret = ttm_copy_io_page(new_iomap, old_iomap, page);
+		if (ret)
+			goto out1;
+	}
+	mb();
+out2:
+	ttm_bo_free_old_node(bo);
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	ttm_flag_masked(&save_flags, new_mem->placement, TTM_PL_MASK_MEMTYPE);
+
+	if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) && (ttm != NULL)) {
+		ttm_tt_unbind(ttm);
+		ttm_tt_destroy(ttm);
+		bo->ttm = NULL;
+	}
+
+out1:
+	ttm_mem_reg_iounmap(bdev, new_mem, new_iomap);
+out:
+	ttm_mem_reg_iounmap(bdev, &old_copy, old_iomap);
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_move_memcpy);
+
+static void ttm_transfered_destroy(struct ttm_buffer_object *bo)
+{
+	kfree(bo);
+}
+
+/**
+ * ttm_buffer_object_transfer
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @new_obj: A pointer to a pointer to a newly created ttm_buffer_object,
+ * holding the data of @bo with the old placement.
+ *
+ * This is a utility function that may be called after an accelerated move
+ * has been scheduled. A new buffer object is created as a placeholder for
+ * the old data while it's being copied. When that buffer object is idle,
+ * it can be destroyed, releasing the space of the old placement.
+ * Returns:
+ * !0: Failure.
+ */
+
+static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
+				      struct ttm_buffer_object **new_obj)
+{
+	struct ttm_buffer_object *fbo;
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+
+	fbo = kzalloc(sizeof(*fbo), GFP_KERNEL);
+	if (!fbo)
+		return -ENOMEM;
+
+	*fbo = *bo;
+
+	/**
+	 * Fix up members that we shouldn't copy directly:
+	 * TODO: Explicit member copy would probably be better here.
+	 */
+
+	spin_lock_init(&fbo->lock);
+	init_waitqueue_head(&fbo->event_queue);
+	INIT_LIST_HEAD(&fbo->ddestroy);
+	INIT_LIST_HEAD(&fbo->lru);
+	INIT_LIST_HEAD(&fbo->swap);
+	fbo->vm_node = NULL;
+
+	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
+	if (fbo->mem.mm_node)
+		fbo->mem.mm_node->private = (void *)fbo;
+	kref_init(&fbo->list_kref);
+	kref_init(&fbo->kref);
+	fbo->destroy = &ttm_transfered_destroy;
+
+	*new_obj = fbo;
+	return 0;
+}
+
+pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
+{
+#if defined(__i386__) || defined(__x86_64__)
+	if (caching_flags & TTM_PL_FLAG_WC)
+		tmp = pgprot_writecombine(tmp);
+	else if (boot_cpu_data.x86 > 3)
+		tmp = pgprot_noncached(tmp);
+
+#elif defined(__powerpc__)
+	if (!(caching_flags & TTM_PL_FLAG_CACHED)) {
+		pgprot_val(tmp) |= _PAGE_NO_CACHE;
+		if (caching_flags & TTM_PL_FLAG_UNCACHED)
+			pgprot_val(tmp) |= _PAGE_GUARDED;
+	}
+#endif
+#if defined(__ia64__)
+	if (caching_flags & TTM_PL_FLAG_WC)
+		tmp = pgprot_writecombine(tmp);
+	else
+		tmp = pgprot_noncached(tmp);
+#endif
+#if defined(__sparc__)
+	if (!(caching_flags & TTM_PL_FLAG_CACHED))
+		tmp = pgprot_noncached(tmp);
+#endif
+	return tmp;
+}
+
+static int ttm_bo_ioremap(struct ttm_buffer_object *bo,
+			  unsigned long bus_base,
+			  unsigned long bus_offset,
+			  unsigned long bus_size,
+			  struct ttm_bo_kmap_obj *map)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_mem_reg *mem = &bo->mem;
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+
+	if (!(man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP)) {
+		map->bo_kmap_type = ttm_bo_map_premapped;
+		map->virtual = (void *)(((u8 *) man->io_addr) + bus_offset);
+	} else {
+		map->bo_kmap_type = ttm_bo_map_iomap;
+		if (mem->placement & TTM_PL_FLAG_WC)
+			map->virtual = ioremap_wc(bus_base + bus_offset,
+						  bus_size);
+		else
+			map->virtual = ioremap_nocache(bus_base + bus_offset,
+						       bus_size);
+	}
+	return (!map->virtual) ? -ENOMEM : 0;
+}
+
+static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
+			   unsigned long start_page,
+			   unsigned long num_pages,
+			   struct ttm_bo_kmap_obj *map)
+{
+	struct ttm_mem_reg *mem = &bo->mem; pgprot_t prot;
+	struct ttm_tt *ttm = bo->ttm;
+	struct page *d;
+	int i;
+
+	BUG_ON(!ttm);
+	if (num_pages == 1 && (mem->placement & TTM_PL_FLAG_CACHED)) {
+		/*
+		 * We're mapping a single page, and the desired
+		 * page protection is consistent with the bo.
+		 */
+
+		map->bo_kmap_type = ttm_bo_map_kmap;
+		map->page = ttm_tt_get_page(ttm, start_page);
+		map->virtual = kmap(map->page);
+	} else {
+	    /*
+	     * Populate the part we're mapping;
+	     */
+		for (i = start_page; i < start_page + num_pages; ++i) {
+			d = ttm_tt_get_page(ttm, i);
+			if (!d)
+				return -ENOMEM;
+		}
+
+		/*
+		 * We need to use vmap to get the desired page protection
+		 * or to make the buffer object look contigous.
+		 */
+		prot = (mem->placement & TTM_PL_FLAG_CACHED) ?
+			PAGE_KERNEL :
+			ttm_io_prot(mem->placement, PAGE_KERNEL);
+		map->bo_kmap_type = ttm_bo_map_vmap;
+		map->virtual = vmap(ttm->pages + start_page, num_pages,
+				    0, prot);
+	}
+	return (!map->virtual) ? -ENOMEM : 0;
+}
+
+int ttm_bo_kmap(struct ttm_buffer_object *bo,
+		unsigned long start_page, unsigned long num_pages,
+		struct ttm_bo_kmap_obj *map)
+{
+	int ret;
+	unsigned long bus_base;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+
+	BUG_ON(!list_empty(&bo->swap));
+	map->virtual = NULL;
+	if (num_pages > bo->num_pages)
+		return -EINVAL;
+	if (start_page > bo->num_pages)
+		return -EINVAL;
+#if 0
+	if (num_pages > 1 && !DRM_SUSER(DRM_CURPROC))
+		return -EPERM;
+#endif
+	ret = ttm_bo_pci_offset(bo->bdev, &bo->mem, &bus_base,
+				&bus_offset, &bus_size);
+	if (ret)
+		return ret;
+	if (bus_size == 0) {
+		return ttm_bo_kmap_ttm(bo, start_page, num_pages, map);
+	} else {
+		bus_offset += start_page << PAGE_SHIFT;
+		bus_size = num_pages << PAGE_SHIFT;
+		return ttm_bo_ioremap(bo, bus_base, bus_offset, bus_size, map);
+	}
+}
+EXPORT_SYMBOL(ttm_bo_kmap);
+
+void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map)
+{
+	if (!map->virtual)
+		return;
+	switch (map->bo_kmap_type) {
+	case ttm_bo_map_iomap:
+		iounmap(map->virtual);
+		break;
+	case ttm_bo_map_vmap:
+		vunmap(map->virtual);
+		break;
+	case ttm_bo_map_kmap:
+		kunmap(map->page);
+		break;
+	case ttm_bo_map_premapped:
+		break;
+	default:
+		BUG();
+	}
+	map->virtual = NULL;
+	map->page = NULL;
+}
+EXPORT_SYMBOL(ttm_bo_kunmap);
+
+int ttm_bo_pfn_prot(struct ttm_buffer_object *bo,
+		    unsigned long dst_offset,
+		    unsigned long *pfn, pgprot_t *prot)
+{
+	struct ttm_mem_reg *mem = &bo->mem;
+	struct ttm_bo_device *bdev = bo->bdev;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long bus_base;
+	int ret;
+	ret = ttm_bo_pci_offset(bdev, mem, &bus_base, &bus_offset,
+			&bus_size);
+	if (ret)
+		return -EINVAL;
+	if (bus_size != 0)
+		*pfn = (bus_base + bus_offset + dst_offset) >> PAGE_SHIFT;
+	else
+		if (!bo->ttm)
+			return -EINVAL;
+		else
+			*pfn = page_to_pfn(ttm_tt_get_page(bo->ttm,
+							   dst_offset >>
+							   PAGE_SHIFT));
+	*prot = (mem->placement & TTM_PL_FLAG_CACHED) ?
+		PAGE_KERNEL : ttm_io_prot(mem->placement, PAGE_KERNEL);
+
+	return 0;
+}
+
+int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
+			      void *sync_obj,
+			      void *sync_obj_arg,
+			      bool evict, bool no_wait,
+			      struct ttm_mem_reg *new_mem)
+{
+	struct ttm_bo_device *bdev = bo->bdev;
+	struct ttm_bo_driver *driver = bdev->driver;
+	struct ttm_mem_type_manager *man = &bdev->man[new_mem->mem_type];
+	struct ttm_mem_reg *old_mem = &bo->mem;
+	int ret;
+	uint32_t save_flags = old_mem->placement;
+	struct ttm_buffer_object *ghost_obj;
+	void *tmp_obj = NULL;
+
+	spin_lock(&bo->lock);
+	if (bo->sync_obj) {
+		tmp_obj = bo->sync_obj;
+		bo->sync_obj = NULL;
+	}
+	bo->sync_obj = driver->sync_obj_ref(sync_obj);
+	bo->sync_obj_arg = sync_obj_arg;
+	if (evict) {
+		ret = ttm_bo_wait(bo, false, false, false);
+		spin_unlock(&bo->lock);
+		driver->sync_obj_unref(&bo->sync_obj);
+
+		if (ret)
+			return ret;
+
+		ttm_bo_free_old_node(bo);
+		if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
+		    (bo->ttm != NULL)) {
+			ttm_tt_unbind(bo->ttm);
+			ttm_tt_destroy(bo->ttm);
+			bo->ttm = NULL;
+		}
+	} else {
+		/**
+		 * This should help pipeline ordinary buffer moves.
+		 *
+		 * Hang old buffer memory on a new buffer object,
+		 * and leave it to be released when the GPU
+		 * operation has completed.
+		 */
+
+		set_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags);
+		spin_unlock(&bo->lock);
+
+		ret = ttm_buffer_object_transfer(bo, &ghost_obj);
+		if (ret)
+			return ret;
+
+		/**
+		 * If we're not moving to fixed memory, the TTM object
+		 * needs to stay alive. Otherwhise hang it on the ghost
+		 * bo to be unbound and destroyed.
+		 */
+
+		if (!(man->flags & TTM_MEMTYPE_FLAG_FIXED))
+			ghost_obj->ttm = NULL;
+		else
+			bo->ttm = NULL;
+
+		ttm_bo_unreserve(ghost_obj);
+		ttm_bo_unref(&ghost_obj);
+	}
+
+	*old_mem = *new_mem;
+	new_mem->mm_node = NULL;
+	ttm_flag_masked(&save_flags, new_mem->placement, TTM_PL_MASK_MEMTYPE);
+	return 0;
+}
+EXPORT_SYMBOL(ttm_bo_move_accel_cleanup);
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
new file mode 100644
index 0000000..27b146c
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -0,0 +1,454 @@
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
+#include <ttm/ttm_module.h>
+#include <ttm/ttm_bo_driver.h>
+#include <ttm/ttm_placement.h>
+#include <linux/mm.h>
+#include <linux/version.h>
+#include <linux/rbtree.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+#define TTM_BO_VM_NUM_PREFAULT 16
+
+static struct ttm_buffer_object *ttm_bo_vm_lookup_rb(struct ttm_bo_device *bdev,
+						     unsigned long page_start,
+						     unsigned long num_pages)
+{
+	struct rb_node *cur = bdev->addr_space_rb.rb_node;
+	unsigned long cur_offset;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *best_bo = NULL;
+
+	while (likely(cur != NULL)) {
+		bo = rb_entry(cur, struct ttm_buffer_object, vm_rb);
+		cur_offset = bo->vm_node->start;
+		if (page_start >= cur_offset) {
+			cur = cur->rb_right;
+			best_bo = bo;
+			if (page_start == cur_offset)
+				break;
+		} else
+			cur = cur->rb_left;
+	}
+
+	if (unlikely(best_bo == NULL))
+		return NULL;
+
+	if (unlikely((best_bo->vm_node->start + best_bo->num_pages) <
+		     (page_start + num_pages)))
+		return NULL;
+
+	return best_bo;
+}
+
+static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
+	    vma->vm_private_data;
+	struct ttm_bo_device *bdev = bo->bdev;
+	unsigned long bus_base;
+	unsigned long bus_offset;
+	unsigned long bus_size;
+	unsigned long page_offset;
+	unsigned long page_last;
+	unsigned long pfn;
+	struct ttm_tt *ttm = NULL;
+	struct page *page;
+	int ret;
+	int i;
+	bool is_iomem;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	int retval = VM_FAULT_NOPAGE;
+
+	/*
+	 * Work around locking order reversal in fault / nopfn
+	 * between mmap_sem and bo_reserve: Perform a trylock operation
+	 * for reserve, and if it fails, retry the fault after scheduling.
+	 */
+
+	ret = ttm_bo_reserve(bo, true, true, false, 0);
+	if (unlikely(ret != 0)) {
+		if (ret == -EBUSY)
+			set_need_resched();
+		return VM_FAULT_NOPAGE;
+	}
+
+	/*
+	 * Wait for buffer data in transit, due to a pipelined
+	 * move.
+	 */
+
+	spin_lock(&bo->lock);
+	if (test_bit(TTM_BO_PRIV_FLAG_MOVING, &bo->priv_flags)) {
+		ret = ttm_bo_wait(bo, false, true, false);
+		spin_unlock(&bo->lock);
+		if (unlikely(ret != 0)) {
+			retval = (ret != -ERESTART) ?
+			    VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
+			goto out_unlock;
+		}
+	} else
+		spin_unlock(&bo->lock);
+
+
+	ret = ttm_bo_pci_offset(bdev, &bo->mem, &bus_base, &bus_offset,
+				&bus_size);
+	if (unlikely(ret != 0)) {
+		retval = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
+
+	is_iomem = (bus_size != 0);
+
+	page_offset = ((address - vma->vm_start) >> PAGE_SHIFT) +
+	    bo->vm_node->start - vma->vm_pgoff;
+	page_last = ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) +
+	    bo->vm_node->start - vma->vm_pgoff;
+
+	if (unlikely(page_offset >= bo->num_pages)) {
+		retval = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
+
+	/*
+	 * Strictly, we're not allowed to modify vma->vm_page_prot here,
+	 * since the mmap_sem is only held in read mode. However, we
+	 * modify only the caching bits of vma->vm_page_prot and
+	 * consider those bits protected by
+	 * the bo->mutex, as we should be the only writers.
+	 * There shouldn't really be any readers of these bits except
+	 * within vm_insert_mixed()? fork?
+	 *
+	 * TODO: Add a list of vmas to the bo, and change the
+	 * vma->vm_page_prot when the object changes caching policy, with
+	 * the correct locks held.
+	 */
+
+	if (is_iomem) {
+		vma->vm_page_prot = ttm_io_prot(bo->mem.placement,
+						vma->vm_page_prot);
+	} else {
+		ttm = bo->ttm;
+		vma->vm_page_prot = (bo->mem.placement & TTM_PL_FLAG_CACHED) ?
+		    vm_get_page_prot(vma->vm_flags) :
+		    ttm_io_prot(bo->mem.placement, vma->vm_page_prot);
+	}
+
+	/*
+	 * Speculatively prefault a number of pages. Only error on
+	 * first page.
+	 */
+
+	for (i = 0; i < TTM_BO_VM_NUM_PREFAULT; ++i) {
+
+		if (is_iomem)
+			pfn = ((bus_base + bus_offset) >> PAGE_SHIFT) +
+			    page_offset;
+		else {
+			page = ttm_tt_get_page(ttm, page_offset);
+			if (unlikely(!page && i == 0)) {
+				retval = VM_FAULT_OOM;
+				goto out_unlock;
+			} else if (unlikely(!page)) {
+				break;
+			}
+			pfn = page_to_pfn(page);
+		}
+
+		ret = vm_insert_mixed(vma, address, pfn);
+		/*
+		 * Somebody beat us to this PTE or prefaulting to
+		 * an already populated PTE, or prefaulting error.
+		 */
+
+		if (unlikely((ret == -EBUSY) || (ret != 0 && i > 0)))
+			break;
+		else if (unlikely(ret != 0)) {
+			retval =
+			    (ret == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
+			goto out_unlock;
+
+		}
+
+		address += PAGE_SIZE;
+		if (unlikely(++page_offset >= page_last))
+			break;
+	}
+
+out_unlock:
+	ttm_bo_unreserve(bo);
+	return retval;
+}
+
+static void ttm_bo_vm_open(struct vm_area_struct *vma)
+{
+	struct ttm_buffer_object *bo =
+	    (struct ttm_buffer_object *)vma->vm_private_data;
+
+	(void)ttm_bo_reference(bo);
+}
+
+static void ttm_bo_vm_close(struct vm_area_struct *vma)
+{
+	struct ttm_buffer_object *bo =
+	    (struct ttm_buffer_object *)vma->vm_private_data;
+
+	ttm_bo_unref(&bo);
+	vma->vm_private_data = NULL;
+}
+
+static struct vm_operations_struct ttm_bo_vm_ops = {
+	.fault = ttm_bo_vm_fault,
+	.open = ttm_bo_vm_open,
+	.close = ttm_bo_vm_close
+};
+
+int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
+		struct ttm_bo_device *bdev)
+{
+	struct ttm_bo_driver *driver;
+	struct ttm_buffer_object *bo;
+	int ret;
+
+	read_lock(&bdev->vm_lock);
+	bo = ttm_bo_vm_lookup_rb(bdev, vma->vm_pgoff,
+				 (vma->vm_end - vma->vm_start) >> PAGE_SHIFT);
+	if (likely(bo != NULL))
+		ttm_bo_reference(bo);
+	read_unlock(&bdev->vm_lock);
+
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR TTM_PFX
+		       "Could not find buffer object to map.\n");
+		return -EINVAL;
+	}
+
+	driver = bo->bdev->driver;
+	if (unlikely(!driver->verify_access)) {
+		ret = -EPERM;
+		goto out_unref;
+	}
+	ret = driver->verify_access(bo, filp);
+	if (unlikely(ret != 0))
+		goto out_unref;
+
+	vma->vm_ops = &ttm_bo_vm_ops;
+
+	/*
+	 * Note: We're transferring the bo reference to
+	 * vma->vm_private_data here.
+	 */
+
+	vma->vm_private_data = bo;
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	return 0;
+out_unref:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+EXPORT_SYMBOL(ttm_bo_mmap);
+
+int ttm_fbdev_mmap(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
+{
+	if (vma->vm_pgoff != 0)
+		return -EACCES;
+
+	vma->vm_ops = &ttm_bo_vm_ops;
+	vma->vm_private_data = ttm_bo_reference(bo);
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	return 0;
+}
+EXPORT_SYMBOL(ttm_fbdev_mmap);
+
+
+ssize_t ttm_bo_io(struct ttm_bo_device *bdev, struct file *filp,
+		  const char __user *wbuf, char __user *rbuf, size_t count,
+		  loff_t *f_pos, bool write)
+{
+	struct ttm_buffer_object *bo;
+	struct ttm_bo_driver *driver;
+	struct ttm_bo_kmap_obj map;
+	unsigned long dev_offset = (*f_pos >> PAGE_SHIFT);
+	unsigned long kmap_offset;
+	unsigned long kmap_end;
+	unsigned long kmap_num;
+	size_t io_size;
+	unsigned int page_offset;
+	char *virtual;
+	int ret;
+	bool no_wait = false;
+	bool dummy;
+
+	read_lock(&bdev->vm_lock);
+	bo = ttm_bo_vm_lookup_rb(bdev, dev_offset, 1);
+	if (likely(bo != NULL))
+		ttm_bo_reference(bo);
+	read_unlock(&bdev->vm_lock);
+
+	if (unlikely(bo == NULL))
+		return -EFAULT;
+
+	driver = bo->bdev->driver;
+	if (unlikely(driver->verify_access)) {
+		ret = -EPERM;
+		goto out_unref;
+	}
+
+	ret = driver->verify_access(bo, filp);
+	if (unlikely(ret != 0))
+		goto out_unref;
+
+	kmap_offset = dev_offset - bo->vm_node->start;
+	if (unlikely(kmap_offset) >= bo->num_pages) {
+		ret = -EFBIG;
+		goto out_unref;
+	}
+
+	page_offset = *f_pos & ~PAGE_MASK;
+	io_size = bo->num_pages - kmap_offset;
+	io_size = (io_size << PAGE_SHIFT) - page_offset;
+	if (count < io_size)
+		io_size = count;
+
+	kmap_end = (*f_pos + count - 1) >> PAGE_SHIFT;
+	kmap_num = kmap_end - kmap_offset + 1;
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -ERESTART:
+		ret = -EINTR;
+		goto out_unref;
+	case -EBUSY:
+		ret = -EAGAIN;
+		goto out_unref;
+	default:
+		goto out_unref;
+	}
+
+	ret = ttm_bo_kmap(bo, kmap_offset, kmap_num, &map);
+	if (unlikely(ret != 0)) {
+		ttm_bo_unreserve(bo);
+		goto out_unref;
+	}
+
+	virtual = ttm_kmap_obj_virtual(&map, &dummy);
+	virtual += page_offset;
+
+	if (write)
+		ret = copy_from_user(virtual, wbuf, io_size);
+	else
+		ret = copy_to_user(rbuf, virtual, io_size);
+
+	ttm_bo_kunmap(&map);
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	if (unlikely(ret != 0))
+		return -EFBIG;
+
+	*f_pos += io_size;
+
+	return io_size;
+out_unref:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+ssize_t ttm_bo_fbdev_io(struct ttm_buffer_object *bo, const char __user *wbuf,
+			char __user *rbuf, size_t count, loff_t *f_pos,
+			bool write)
+{
+	struct ttm_bo_kmap_obj map;
+	unsigned long kmap_offset;
+	unsigned long kmap_end;
+	unsigned long kmap_num;
+	size_t io_size;
+	unsigned int page_offset;
+	char *virtual;
+	int ret;
+	bool no_wait = false;
+	bool dummy;
+
+	kmap_offset = (*f_pos >> PAGE_SHIFT);
+	if (unlikely(kmap_offset) >= bo->num_pages)
+		return -EFBIG;
+
+	page_offset = *f_pos & ~PAGE_MASK;
+	io_size = bo->num_pages - kmap_offset;
+	io_size = (io_size << PAGE_SHIFT) - page_offset;
+	if (count < io_size)
+		io_size = count;
+
+	kmap_end = (*f_pos + count - 1) >> PAGE_SHIFT;
+	kmap_num = kmap_end - kmap_offset + 1;
+
+	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+
+	switch (ret) {
+	case 0:
+		break;
+	case -ERESTART:
+		return -EINTR;
+	case -EBUSY:
+		return -EAGAIN;
+	default:
+		return ret;
+	}
+
+	ret = ttm_bo_kmap(bo, kmap_offset, kmap_num, &map);
+	if (unlikely(ret != 0)) {
+		ttm_bo_unreserve(bo);
+		return ret;
+	}
+
+	virtual = ttm_kmap_obj_virtual(&map, &dummy);
+	virtual += page_offset;
+
+	if (write)
+		ret = copy_from_user(virtual, wbuf, io_size);
+	else
+		ret = copy_to_user(rbuf, virtual, io_size);
+
+	ttm_bo_kunmap(&map);
+	ttm_bo_unreserve(bo);
+	ttm_bo_unref(&bo);
+
+	if (unlikely(ret != 0))
+		return ret;
+
+	*f_pos += io_size;
+
+	return io_size;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_global.c b/drivers/gpu/drm/ttm/ttm_global.c
new file mode 100644
index 0000000..0b14eb1
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_global.c
@@ -0,0 +1,114 @@
+/**************************************************************************
+ *
+ * Copyright 2008-2009 VMware, Inc., Palo Alto, CA., USA
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
+#include "ttm/ttm_module.h"
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+struct ttm_global_item {
+	struct mutex mutex;
+	void *object;
+	int refcount;
+};
+
+static struct ttm_global_item glob[TTM_GLOBAL_NUM];
+
+void ttm_global_init(void)
+{
+	int i;
+
+	for (i = 0; i < TTM_GLOBAL_NUM; ++i) {
+		struct ttm_global_item *item = &glob[i];
+		mutex_init(&item->mutex);
+		item->object = NULL;
+		item->refcount = 0;
+	}
+}
+
+void ttm_global_release(void)
+{
+	int i;
+	for (i = 0; i < TTM_GLOBAL_NUM; ++i) {
+		struct ttm_global_item *item = &glob[i];
+		BUG_ON(item->object != NULL);
+		BUG_ON(item->refcount != 0);
+	}
+}
+
+int ttm_global_item_ref(struct ttm_global_reference *ref)
+{
+	int ret;
+	struct ttm_global_item *item = &glob[ref->global_type];
+	void *object;
+
+	mutex_lock(&item->mutex);
+	if (item->refcount == 0) {
+		item->object = kmalloc(ref->size, GFP_KERNEL);
+		if (unlikely(item->object == NULL)) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+
+		ref->object = item->object;
+		ret = ref->init(ref);
+		if (unlikely(ret != 0))
+			goto out_err;
+
+		++item->refcount;
+	}
+	ref->object = item->object;
+	object = item->object;
+	mutex_unlock(&item->mutex);
+	return 0;
+out_err:
+	kfree(item->object);
+	mutex_unlock(&item->mutex);
+	item->object = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(ttm_global_item_ref);
+
+void ttm_global_item_unref(struct ttm_global_reference *ref)
+{
+	struct ttm_global_item *item = &glob[ref->global_type];
+
+	mutex_lock(&item->mutex);
+	BUG_ON(item->refcount == 0);
+	BUG_ON(ref->object != item->object);
+	if (--item->refcount == 0) {
+		ref->release(ref);
+		kfree(item->object);
+		item->object = NULL;
+	}
+	mutex_unlock(&item->mutex);
+}
+EXPORT_SYMBOL(ttm_global_item_unref);
+
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
new file mode 100644
index 0000000..87323d4
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -0,0 +1,234 @@
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
+#include "ttm/ttm_memory.h"
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+#define TTM_PFX "[TTM] "
+#define TTM_MEMORY_ALLOC_RETRIES 4
+
+/**
+ * At this point we only support a single shrink callback.
+ * Extend this if needed, perhaps using a linked list of callbacks.
+ * Note that this function is reentrant:
+ * many threads may try to swap out at any given time.
+ */
+
+static void ttm_shrink(struct ttm_mem_global *glob, bool from_workqueue,
+		       uint64_t extra)
+{
+	int ret;
+	struct ttm_mem_shrink *shrink;
+	uint64_t target;
+	uint64_t total_target;
+
+	spin_lock(&glob->lock);
+	if (glob->shrink == NULL)
+		goto out;
+
+	if (from_workqueue) {
+		target = glob->swap_limit;
+		total_target = glob->total_memory_swap_limit;
+	} else if (capable(CAP_SYS_ADMIN)) {
+		total_target = glob->emer_total_memory;
+		target = glob->emer_memory;
+	} else {
+		total_target = glob->max_total_memory;
+		target = glob->max_memory;
+	}
+
+	total_target = (extra >= total_target) ? 0 : total_target - extra;
+	target = (extra >= target) ? 0 : target - extra;
+
+	while (glob->used_memory > target ||
+	       glob->used_total_memory > total_target) {
+		shrink = glob->shrink;
+		spin_unlock(&glob->lock);
+		ret = shrink->do_shrink(shrink);
+		spin_lock(&glob->lock);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+out:
+	spin_unlock(&glob->lock);
+}
+
+static void ttm_shrink_work(struct work_struct *work)
+{
+	struct ttm_mem_global *glob =
+	    container_of(work, struct ttm_mem_global, work);
+
+	ttm_shrink(glob, true, 0ULL);
+}
+
+int ttm_mem_global_init(struct ttm_mem_global *glob)
+{
+	struct sysinfo si;
+	uint64_t mem;
+
+	spin_lock_init(&glob->lock);
+	glob->swap_queue = create_singlethread_workqueue("ttm_swap");
+	INIT_WORK(&glob->work, ttm_shrink_work);
+	init_waitqueue_head(&glob->queue);
+
+	si_meminfo(&si);
+
+	mem = si.totalram - si.totalhigh;
+	mem *= si.mem_unit;
+
+	glob->max_memory = mem >> 1;
+	glob->emer_memory = (mem >> 1) + (mem >> 2);
+	glob->swap_limit = glob->max_memory - (mem >> 3);
+	glob->used_memory = 0;
+	glob->used_total_memory = 0;
+	glob->shrink = NULL;
+
+	mem = si.totalram;
+	mem *= si.mem_unit;
+
+	glob->max_total_memory = mem >> 1;
+	glob->emer_total_memory = (mem >> 1) + (mem >> 2);
+
+	glob->total_memory_swap_limit = glob->max_total_memory - (mem >> 3);
+
+	printk(KERN_INFO TTM_PFX "TTM available graphics memory: %llu MiB\n",
+	       glob->max_total_memory >> 20);
+	printk(KERN_INFO TTM_PFX "TTM available object memory: %llu MiB\n",
+	       glob->max_memory >> 20);
+
+	return 0;
+}
+EXPORT_SYMBOL(ttm_mem_global_init);
+
+void ttm_mem_global_release(struct ttm_mem_global *glob)
+{
+	printk(KERN_INFO TTM_PFX "Used total memory is %llu bytes.\n",
+	       (unsigned long long)glob->used_total_memory);
+	flush_workqueue(glob->swap_queue);
+	destroy_workqueue(glob->swap_queue);
+	glob->swap_queue = NULL;
+}
+EXPORT_SYMBOL(ttm_mem_global_release);
+
+static inline void ttm_check_swapping(struct ttm_mem_global *glob)
+{
+	bool needs_swapping;
+
+	spin_lock(&glob->lock);
+	needs_swapping = (glob->used_memory > glob->swap_limit ||
+			  glob->used_total_memory >
+			  glob->total_memory_swap_limit);
+	spin_unlock(&glob->lock);
+
+	if (unlikely(needs_swapping))
+		(void)queue_work(glob->swap_queue, &glob->work);
+
+}
+
+void ttm_mem_global_free(struct ttm_mem_global *glob,
+			 uint64_t amount, bool himem)
+{
+	spin_lock(&glob->lock);
+	glob->used_total_memory -= amount;
+	if (!himem)
+		glob->used_memory -= amount;
+	wake_up_all(&glob->queue);
+	spin_unlock(&glob->lock);
+}
+
+static int ttm_mem_global_reserve(struct ttm_mem_global *glob,
+				  uint64_t amount, bool himem, bool reserve)
+{
+	uint64_t limit;
+	uint64_t lomem_limit;
+	int ret = -ENOMEM;
+
+	spin_lock(&glob->lock);
+
+	if (capable(CAP_SYS_ADMIN)) {
+		limit = glob->emer_total_memory;
+		lomem_limit = glob->emer_memory;
+	} else {
+		limit = glob->max_total_memory;
+		lomem_limit = glob->max_memory;
+	}
+
+	if (unlikely(glob->used_total_memory + amount > limit))
+		goto out_unlock;
+	if (unlikely(!himem && glob->used_memory + amount > lomem_limit))
+		goto out_unlock;
+
+	if (reserve) {
+		glob->used_total_memory += amount;
+		if (!himem)
+			glob->used_memory += amount;
+	}
+	ret = 0;
+out_unlock:
+	spin_unlock(&glob->lock);
+	ttm_check_swapping(glob);
+
+	return ret;
+}
+
+int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
+			 bool no_wait, bool interruptible, bool himem)
+{
+	int count = TTM_MEMORY_ALLOC_RETRIES;
+
+	while (unlikely(ttm_mem_global_reserve(glob, memory, himem, true)
+			!= 0)) {
+		if (no_wait)
+			return -ENOMEM;
+		if (unlikely(count-- == 0))
+			return -ENOMEM;
+		ttm_shrink(glob, false, memory + (memory >> 2) + 16);
+	}
+
+	return 0;
+}
+
+size_t ttm_round_pot(size_t size)
+{
+	if ((size & (size - 1)) == 0)
+		return size;
+	else if (size > PAGE_SIZE)
+		return PAGE_ALIGN(size);
+	else {
+		size_t tmp_size = 4;
+
+		while (tmp_size < size)
+			tmp_size <<= 1;
+
+		return tmp_size;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/ttm/ttm_module.c b/drivers/gpu/drm/ttm/ttm_module.c
new file mode 100644
index 0000000..59ce819
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_module.c
@@ -0,0 +1,50 @@
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
+ * 	    Jerome Glisse
+ */
+#include <linux/module.h>
+#include <ttm/ttm_module.h>
+
+static int __init ttm_init(void)
+{
+	ttm_global_init();
+	return 0;
+}
+
+static void __exit ttm_exit(void)
+{
+	ttm_global_release();
+}
+
+module_init(ttm_init);
+module_exit(ttm_exit);
+
+MODULE_AUTHOR("Thomas Hellstrom, Jerome Glisse");
+MODULE_DESCRIPTION("TTM memory manager subsystem (for DRM device)");
+MODULE_LICENSE("GPL and additional rights");
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
new file mode 100644
index 0000000..c27ab3a
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -0,0 +1,635 @@
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
+#include <linux/version.h>
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/swap.h>
+#include "ttm/ttm_module.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_placement.h"
+
+static int ttm_tt_swapin(struct ttm_tt *ttm);
+
+#if defined(CONFIG_X86)
+static void ttm_tt_clflush_page(struct page *page)
+{
+	uint8_t *page_virtual;
+	unsigned int i;
+
+	if (unlikely(page == NULL))
+		return;
+
+	page_virtual = kmap_atomic(page, KM_USER0);
+
+	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+		clflush(page_virtual + i);
+
+	kunmap_atomic(page_virtual, KM_USER0);
+}
+
+static void ttm_tt_cache_flush_clflush(struct page *pages[],
+				       unsigned long num_pages)
+{
+	unsigned long i;
+
+	mb();
+	for (i = 0; i < num_pages; ++i)
+		ttm_tt_clflush_page(*pages++);
+	mb();
+}
+#else
+static void ttm_tt_ipi_handler(void *null)
+{
+	;
+}
+#endif
+
+void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages)
+{
+
+#if defined(CONFIG_X86)
+	if (cpu_has_clflush) {
+		ttm_tt_cache_flush_clflush(pages, num_pages);
+		return;
+	}
+#else
+	if (on_each_cpu(ttm_tt_ipi_handler, NULL, 1) != 0)
+		printk(KERN_ERR TTM_PFX
+		       "Timed out waiting for drm cache flush.\n");
+#endif
+}
+
+/**
+ * Allocates storage for pointers to the pages that back the ttm.
+ *
+ * Uses kmalloc if possible. Otherwise falls back to vmalloc.
+ */
+static void ttm_tt_alloc_page_directory(struct ttm_tt *ttm)
+{
+	unsigned long size = ttm->num_pages * sizeof(*ttm->pages);
+	ttm->pages = NULL;
+
+	if (size <= PAGE_SIZE)
+		ttm->pages = kzalloc(size, GFP_KERNEL);
+
+	if (!ttm->pages) {
+		ttm->pages = vmalloc_user(size);
+		if (ttm->pages)
+			ttm->page_flags |= TTM_PAGE_FLAG_VMALLOC;
+	}
+}
+
+static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
+{
+	if (ttm->page_flags & TTM_PAGE_FLAG_VMALLOC) {
+		vfree(ttm->pages);
+		ttm->page_flags &= ~TTM_PAGE_FLAG_VMALLOC;
+	} else {
+		kfree(ttm->pages);
+	}
+	ttm->pages = NULL;
+}
+
+static struct page *ttm_tt_alloc_page(unsigned page_flags)
+{
+	if (page_flags & TTM_PAGE_FLAG_ZERO_ALLOC)
+		return alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+
+	return alloc_page(GFP_HIGHUSER);
+}
+
+static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
+{
+	int write;
+	int dirty;
+	struct page *page;
+	int i;
+	struct ttm_backend *be = ttm->be;
+
+	BUG_ON(!(ttm->page_flags & TTM_PAGE_FLAG_USER));
+	write = ((ttm->page_flags & TTM_PAGE_FLAG_WRITE) != 0);
+	dirty = ((ttm->page_flags & TTM_PAGE_FLAG_USER_DIRTY) != 0);
+
+	if (be)
+		be->func->clear(be);
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		page = ttm->pages[i];
+		if (page == NULL)
+			continue;
+
+		if (page == ttm->dummy_read_page) {
+			BUG_ON(write);
+			continue;
+		}
+
+		if (write && dirty && !PageReserved(page))
+			set_page_dirty_lock(page);
+
+		ttm->pages[i] = NULL;
+		ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE, false);
+		put_page(page);
+	}
+	ttm->state = tt_unpopulated;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+}
+
+static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
+{
+	struct page *p;
+	struct ttm_bo_device *bdev = ttm->bdev;
+	struct ttm_mem_global *mem_glob = bdev->mem_glob;
+	int ret;
+
+	while (NULL == (p = ttm->pages[index])) {
+		p = ttm_tt_alloc_page(ttm->page_flags);
+
+		if (!p)
+			return NULL;
+
+		if (PageHighMem(p)) {
+			ret =
+			    ttm_mem_global_alloc(mem_glob, PAGE_SIZE,
+						 false, false, true);
+			if (unlikely(ret != 0))
+				goto out_err;
+			ttm->pages[--ttm->first_himem_page] = p;
+		} else {
+			ret =
+			    ttm_mem_global_alloc(mem_glob, PAGE_SIZE,
+						 false, false, false);
+			if (unlikely(ret != 0))
+				goto out_err;
+			ttm->pages[++ttm->last_lomem_page] = p;
+		}
+	}
+	return p;
+out_err:
+	put_page(p);
+	return NULL;
+}
+
+struct page *ttm_tt_get_page(struct ttm_tt *ttm, int index)
+{
+	int ret;
+
+	if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
+		ret = ttm_tt_swapin(ttm);
+		if (unlikely(ret != 0))
+			return NULL;
+	}
+	return __ttm_tt_get_page(ttm, index);
+}
+
+int ttm_tt_populate(struct ttm_tt *ttm)
+{
+	struct page *page;
+	unsigned long i;
+	struct ttm_backend *be;
+	int ret;
+
+	if (ttm->state != tt_unpopulated)
+		return 0;
+
+	if (unlikely(ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
+		ret = ttm_tt_swapin(ttm);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	be = ttm->be;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		page = __ttm_tt_get_page(ttm, i);
+		if (!page)
+			return -ENOMEM;
+	}
+
+	be->func->populate(be, ttm->num_pages, ttm->pages,
+			   ttm->dummy_read_page);
+	ttm->state = tt_unbound;
+	return 0;
+}
+
+#ifdef CONFIG_X86
+static inline int ttm_tt_set_page_caching(struct page *p,
+					  enum ttm_caching_state c_state)
+{
+	if (PageHighMem(p))
+		return 0;
+
+	switch (c_state) {
+	case tt_cached:
+		return set_pages_wb(p, 1);
+	case tt_wc:
+	    return set_memory_wc((unsigned long) page_address(p), 1);
+	default:
+		return set_pages_uc(p, 1);
+	}
+}
+#else /* CONFIG_X86 */
+static inline int ttm_tt_set_page_caching(struct page *p,
+					  enum ttm_caching_state c_state)
+{
+	return 0;
+}
+#endif /* CONFIG_X86 */
+
+/*
+ * Change caching policy for the linear kernel map
+ * for range of pages in a ttm.
+ */
+
+static int ttm_tt_set_caching(struct ttm_tt *ttm,
+			      enum ttm_caching_state c_state)
+{
+	int i, j;
+	struct page *cur_page;
+	int ret;
+
+	if (ttm->caching_state == c_state)
+		return 0;
+
+	if (c_state != tt_cached) {
+		ret = ttm_tt_populate(ttm);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+
+	if (ttm->caching_state == tt_cached)
+		ttm_tt_cache_flush(ttm->pages, ttm->num_pages);
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		cur_page = ttm->pages[i];
+		if (likely(cur_page != NULL)) {
+			ret = ttm_tt_set_page_caching(cur_page, c_state);
+			if (unlikely(ret != 0))
+				goto out_err;
+		}
+	}
+
+	ttm->caching_state = c_state;
+
+	return 0;
+
+out_err:
+	for (j = 0; j < i; ++j) {
+		cur_page = ttm->pages[j];
+		if (likely(cur_page != NULL)) {
+			(void)ttm_tt_set_page_caching(cur_page,
+						      ttm->caching_state);
+		}
+	}
+
+	return ret;
+}
+
+int ttm_tt_set_placement_caching(struct ttm_tt *ttm, uint32_t placement)
+{
+	enum ttm_caching_state state;
+
+	if (placement & TTM_PL_FLAG_WC)
+		state = tt_wc;
+	else if (placement & TTM_PL_FLAG_UNCACHED)
+		state = tt_uncached;
+	else
+		state = tt_cached;
+
+	return ttm_tt_set_caching(ttm, state);
+}
+
+static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
+{
+	int i;
+	struct page *cur_page;
+	struct ttm_backend *be = ttm->be;
+
+	if (be)
+		be->func->clear(be);
+	(void)ttm_tt_set_caching(ttm, tt_cached);
+	for (i = 0; i < ttm->num_pages; ++i) {
+		cur_page = ttm->pages[i];
+		ttm->pages[i] = NULL;
+		if (cur_page) {
+			if (page_count(cur_page) != 1)
+				printk(KERN_ERR TTM_PFX
+				       "Erroneous page count. "
+				       "Leaking pages.\n");
+			ttm_mem_global_free(ttm->bdev->mem_glob, PAGE_SIZE,
+					    PageHighMem(cur_page));
+			__free_page(cur_page);
+		}
+	}
+	ttm->state = tt_unpopulated;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+}
+
+void ttm_tt_destroy(struct ttm_tt *ttm)
+{
+	struct ttm_backend *be;
+
+	if (unlikely(ttm == NULL))
+		return;
+
+	be = ttm->be;
+	if (likely(be != NULL)) {
+		be->func->destroy(be);
+		ttm->be = NULL;
+	}
+
+	if (likely(ttm->pages != NULL)) {
+		if (ttm->page_flags & TTM_PAGE_FLAG_USER)
+			ttm_tt_free_user_pages(ttm);
+		else
+			ttm_tt_free_alloced_pages(ttm);
+
+		ttm_tt_free_page_directory(ttm);
+	}
+
+	if (!(ttm->page_flags & TTM_PAGE_FLAG_PERSISTANT_SWAP) &&
+	    ttm->swap_storage)
+		fput(ttm->swap_storage);
+
+	kfree(ttm);
+}
+
+int ttm_tt_set_user(struct ttm_tt *ttm,
+		    struct task_struct *tsk,
+		    unsigned long start, unsigned long num_pages)
+{
+	struct mm_struct *mm = tsk->mm;
+	int ret;
+	int write = (ttm->page_flags & TTM_PAGE_FLAG_WRITE) != 0;
+	struct ttm_mem_global *mem_glob = ttm->bdev->mem_glob;
+
+	BUG_ON(num_pages != ttm->num_pages);
+	BUG_ON((ttm->page_flags & TTM_PAGE_FLAG_USER) == 0);
+
+	/**
+	 * Account user pages as lowmem pages for now.
+	 */
+
+	ret = ttm_mem_global_alloc(mem_glob, num_pages * PAGE_SIZE,
+				   false, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(tsk, mm, start, num_pages,
+			     write, 0, ttm->pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	if (ret != num_pages && write) {
+		ttm_tt_free_user_pages(ttm);
+		ttm_mem_global_free(mem_glob, num_pages * PAGE_SIZE, false);
+		return -ENOMEM;
+	}
+
+	ttm->tsk = tsk;
+	ttm->start = start;
+	ttm->state = tt_unbound;
+
+	return 0;
+}
+
+struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev, unsigned long size,
+			     uint32_t page_flags, struct page *dummy_read_page)
+{
+	struct ttm_bo_driver *bo_driver = bdev->driver;
+	struct ttm_tt *ttm;
+
+	if (!bo_driver)
+		return NULL;
+
+	ttm = kzalloc(sizeof(*ttm), GFP_KERNEL);
+	if (!ttm)
+		return NULL;
+
+	ttm->bdev = bdev;
+
+	ttm->num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	ttm->first_himem_page = ttm->num_pages;
+	ttm->last_lomem_page = -1;
+	ttm->caching_state = tt_cached;
+	ttm->page_flags = page_flags;
+
+	ttm->dummy_read_page = dummy_read_page;
+
+	ttm_tt_alloc_page_directory(ttm);
+	if (!ttm->pages) {
+		ttm_tt_destroy(ttm);
+		printk(KERN_ERR TTM_PFX "Failed allocating page table\n");
+		return NULL;
+	}
+	ttm->be = bo_driver->create_ttm_backend_entry(bdev);
+	if (!ttm->be) {
+		ttm_tt_destroy(ttm);
+		printk(KERN_ERR TTM_PFX "Failed creating ttm backend entry\n");
+		return NULL;
+	}
+	ttm->state = tt_unpopulated;
+	return ttm;
+}
+
+void ttm_tt_unbind(struct ttm_tt *ttm)
+{
+	int ret;
+	struct ttm_backend *be = ttm->be;
+
+	if (ttm->state == tt_bound) {
+		ret = be->func->unbind(be);
+		BUG_ON(ret);
+		ttm->state = tt_unbound;
+	}
+}
+
+int ttm_tt_bind(struct ttm_tt *ttm, struct ttm_mem_reg *bo_mem)
+{
+	int ret = 0;
+	struct ttm_backend *be;
+
+	if (!ttm)
+		return -EINVAL;
+
+	if (ttm->state == tt_bound)
+		return 0;
+
+	be = ttm->be;
+
+	ret = ttm_tt_populate(ttm);
+	if (ret)
+		return ret;
+
+	ret = be->func->bind(be, bo_mem);
+	if (ret) {
+		printk(KERN_ERR TTM_PFX "Couldn't bind backend.\n");
+		return ret;
+	}
+
+	ttm->state = tt_bound;
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER)
+		ttm->page_flags |= TTM_PAGE_FLAG_USER_DIRTY;
+	return 0;
+}
+EXPORT_SYMBOL(ttm_tt_bind);
+
+static int ttm_tt_swapin(struct ttm_tt *ttm)
+{
+	struct address_space *swap_space;
+	struct file *swap_storage;
+	struct page *from_page;
+	struct page *to_page;
+	void *from_virtual;
+	void *to_virtual;
+	int i;
+	int ret;
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER) {
+		ret = ttm_tt_set_user(ttm, ttm->tsk, ttm->start,
+				      ttm->num_pages);
+		if (unlikely(ret != 0))
+			return ret;
+
+		ttm->page_flags &= ~TTM_PAGE_FLAG_SWAPPED;
+		return 0;
+	}
+
+	swap_storage = ttm->swap_storage;
+	BUG_ON(swap_storage == NULL);
+
+	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		from_page = read_mapping_page(swap_space, i, NULL);
+		if (IS_ERR(from_page))
+			goto out_err;
+		to_page = __ttm_tt_get_page(ttm, i);
+		if (unlikely(to_page == NULL))
+			goto out_err;
+
+		preempt_disable();
+		from_virtual = kmap_atomic(from_page, KM_USER0);
+		to_virtual = kmap_atomic(to_page, KM_USER1);
+		memcpy(to_virtual, from_virtual, PAGE_SIZE);
+		kunmap_atomic(to_virtual, KM_USER1);
+		kunmap_atomic(from_virtual, KM_USER0);
+		preempt_enable();
+		page_cache_release(from_page);
+	}
+
+	if (!(ttm->page_flags & TTM_PAGE_FLAG_PERSISTANT_SWAP))
+		fput(swap_storage);
+	ttm->swap_storage = NULL;
+	ttm->page_flags &= ~TTM_PAGE_FLAG_SWAPPED;
+
+	return 0;
+out_err:
+	ttm_tt_free_alloced_pages(ttm);
+	return -ENOMEM;
+}
+
+int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistant_swap_storage)
+{
+	struct address_space *swap_space;
+	struct file *swap_storage;
+	struct page *from_page;
+	struct page *to_page;
+	void *from_virtual;
+	void *to_virtual;
+	int i;
+
+	BUG_ON(ttm->state != tt_unbound && ttm->state != tt_unpopulated);
+	BUG_ON(ttm->caching_state != tt_cached);
+
+	/*
+	 * For user buffers, just unpin the pages, as there should be
+	 * vma references.
+	 */
+
+	if (ttm->page_flags & TTM_PAGE_FLAG_USER) {
+		ttm_tt_free_user_pages(ttm);
+		ttm->page_flags |= TTM_PAGE_FLAG_SWAPPED;
+		ttm->swap_storage = NULL;
+		return 0;
+	}
+
+	if (!persistant_swap_storage) {
+		swap_storage = shmem_file_setup("ttm swap",
+						ttm->num_pages << PAGE_SHIFT,
+						0);
+		if (unlikely(IS_ERR(swap_storage))) {
+			printk(KERN_ERR "Failed allocating swap storage.\n");
+			return -ENOMEM;
+		}
+	} else
+		swap_storage = persistant_swap_storage;
+
+	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
+
+	for (i = 0; i < ttm->num_pages; ++i) {
+		from_page = ttm->pages[i];
+		if (unlikely(from_page == NULL))
+			continue;
+		to_page = read_mapping_page(swap_space, i, NULL);
+		if (unlikely(to_page == NULL))
+			goto out_err;
+
+		preempt_disable();
+		from_virtual = kmap_atomic(from_page, KM_USER0);
+		to_virtual = kmap_atomic(to_page, KM_USER1);
+		memcpy(to_virtual, from_virtual, PAGE_SIZE);
+		kunmap_atomic(to_virtual, KM_USER1);
+		kunmap_atomic(from_virtual, KM_USER0);
+		preempt_enable();
+		set_page_dirty(to_page);
+		mark_page_accessed(to_page);
+		page_cache_release(to_page);
+	}
+
+	ttm_tt_free_alloced_pages(ttm);
+	ttm->swap_storage = swap_storage;
+	ttm->page_flags |= TTM_PAGE_FLAG_SWAPPED;
+	if (persistant_swap_storage)
+		ttm->page_flags |= TTM_PAGE_FLAG_PERSISTANT_SWAP;
+
+	return 0;
+out_err:
+	if (!persistant_swap_storage)
+		fput(swap_storage);
+
+	return -ENOMEM;
+}
diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
new file mode 100644
index 0000000..cd22ab4
--- /dev/null
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -0,0 +1,618 @@
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
+#ifndef _TTM_BO_API_H_
+#define _TTM_BO_API_H_
+
+#include "drm_hashtab.h"
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/rbtree.h>
+#include <linux/bitmap.h>
+
+struct ttm_bo_device;
+
+struct drm_mm_node;
+
+/**
+ * struct ttm_mem_reg
+ *
+ * @mm_node: Memory manager node.
+ * @size: Requested size of memory region.
+ * @num_pages: Actual size of memory region in pages.
+ * @page_alignment: Page alignment.
+ * @placement: Placement flags.
+ *
+ * Structure indicating the placement and space resources used by a
+ * buffer object.
+ */
+
+struct ttm_mem_reg {
+	struct drm_mm_node *mm_node;
+	unsigned long size;
+	unsigned long num_pages;
+	uint32_t page_alignment;
+	uint32_t mem_type;
+	uint32_t placement;
+};
+
+/**
+ * enum ttm_bo_type
+ *
+ * @ttm_bo_type_device:	These are 'normal' buffers that can
+ * be mmapped by user space. Each of these bos occupy a slot in the
+ * device address space, that can be used for normal vm operations.
+ *
+ * @ttm_bo_type_user: These are user-space memory areas that are made
+ * available to the GPU by mapping the buffer pages into the GPU aperture
+ * space. These buffers cannot be mmaped from the device address space.
+ *
+ * @ttm_bo_type_kernel: These buffers are like ttm_bo_type_device buffers,
+ * but they cannot be accessed from user-space. For kernel-only use.
+ */
+
+enum ttm_bo_type {
+	ttm_bo_type_device,
+	ttm_bo_type_user,
+	ttm_bo_type_kernel
+};
+
+struct ttm_tt;
+
+/**
+ * struct ttm_buffer_object
+ *
+ * @bdev: Pointer to the buffer object device structure.
+ * @buffer_start: The virtual user-space start address of ttm_bo_type_user
+ * buffers.
+ * @type: The bo type.
+ * @destroy: Destruction function. If NULL, kfree is used.
+ * @num_pages: Actual number of pages.
+ * @addr_space_offset: Address space offset.
+ * @acc_size: Accounted size for this object.
+ * @kref: Reference count of this buffer object. When this refcount reaches
+ * zero, the object is put on the delayed delete list.
+ * @list_kref: List reference count of this buffer object. This member is
+ * used to avoid destruction while the buffer object is still on a list.
+ * Lru lists may keep one refcount, the delayed delete list, and kref != 0
+ * keeps one refcount. When this refcount reaches zero,
+ * the object is destroyed.
+ * @event_queue: Queue for processes waiting on buffer object status change.
+ * @lock: spinlock protecting mostly synchronization members.
+ * @proposed_placement: Proposed placement for the buffer. Changed only by the
+ * creator prior to validation as opposed to bo->mem.proposed_flags which is
+ * changed by the implementation prior to a buffer move if it wants to outsmart
+ * the buffer creator / user. This latter happens, for example, at eviction.
+ * @mem: structure describing current placement.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object.
+ * @ttm: TTM structure holding system pages.
+ * @evicted: Whether the object was evicted without user-space knowing.
+ * @cpu_writes: For synchronization. Number of cpu writers.
+ * @lru: List head for the lru list.
+ * @ddestroy: List head for the delayed destroy list.
+ * @swap: List head for swap LRU list.
+ * @val_seq: Sequence of the validation holding the @reserved lock.
+ * Used to avoid starvation when many processes compete to validate the
+ * buffer. This member is protected by the bo_device::lru_lock.
+ * @seq_valid: The value of @val_seq is valid. This value is protected by
+ * the bo_device::lru_lock.
+ * @reserved: Deadlock-free lock used for synchronization state transitions.
+ * @sync_obj_arg: Opaque argument to synchronization object function.
+ * @sync_obj: Pointer to a synchronization object.
+ * @priv_flags: Flags describing buffer object internal state.
+ * @vm_rb: Rb node for the vm rb tree.
+ * @vm_node: Address space manager node.
+ * @offset: The current GPU offset, which can have different meanings
+ * depending on the memory type. For SYSTEM type memory, it should be 0.
+ * @cur_placement: Hint of current placement.
+ *
+ * Base class for TTM buffer object, that deals with data placement and CPU
+ * mappings. GPU mappings are really up to the driver, but for simpler GPUs
+ * the driver can usually use the placement offset @offset directly as the
+ * GPU virtual address. For drivers implementing multiple
+ * GPU memory manager contexts, the driver should manage the address space
+ * in these contexts separately and use these objects to get the correct
+ * placement and caching for these GPU maps. This makes it possible to use
+ * these objects for even quite elaborate memory management schemes.
+ * The destroy member, the API visibility of this object makes it possible
+ * to derive driver specific types.
+ */
+
+struct ttm_buffer_object {
+	/**
+	 * Members constant at init.
+	 */
+
+	struct ttm_bo_device *bdev;
+	unsigned long buffer_start;
+	enum ttm_bo_type type;
+	void (*destroy) (struct ttm_buffer_object *);
+	unsigned long num_pages;
+	uint64_t addr_space_offset;
+	size_t acc_size;
+
+	/**
+	* Members not needing protection.
+	*/
+
+	struct kref kref;
+	struct kref list_kref;
+	wait_queue_head_t event_queue;
+	spinlock_t lock;
+
+	/**
+	 * Members protected by the bo::reserved lock.
+	 */
+
+	uint32_t proposed_placement;
+	struct ttm_mem_reg mem;
+	struct file *persistant_swap_storage;
+	struct ttm_tt *ttm;
+	bool evicted;
+
+	/**
+	 * Members protected by the bo::reserved lock only when written to.
+	 */
+
+	atomic_t cpu_writers;
+
+	/**
+	 * Members protected by the bdev::lru_lock.
+	 */
+
+	struct list_head lru;
+	struct list_head ddestroy;
+	struct list_head swap;
+	uint32_t val_seq;
+	bool seq_valid;
+
+	/**
+	 * Members protected by the bdev::lru_lock
+	 * only when written to.
+	 */
+
+	atomic_t reserved;
+
+
+	/**
+	 * Members protected by the bo::lock
+	 */
+
+	void *sync_obj_arg;
+	void *sync_obj;
+	unsigned long priv_flags;
+
+	/**
+	 * Members protected by the bdev::vm_lock
+	 */
+
+	struct rb_node vm_rb;
+	struct drm_mm_node *vm_node;
+
+
+	/**
+	 * Special members that are protected by the reserve lock
+	 * and the bo::lock when written to. Can be read with
+	 * either of these locks held.
+	 */
+
+	unsigned long offset;
+	uint32_t cur_placement;
+};
+
+/**
+ * struct ttm_bo_kmap_obj
+ *
+ * @virtual: The current kernel virtual address.
+ * @page: The page when kmap'ing a single page.
+ * @bo_kmap_type: Type of bo_kmap.
+ *
+ * Object describing a kernel mapping. Since a TTM bo may be located
+ * in various memory types with various caching policies, the
+ * mapping can either be an ioremap, a vmap, a kmap or part of a
+ * premapped region.
+ */
+
+struct ttm_bo_kmap_obj {
+	void *virtual;
+	struct page *page;
+	enum {
+		ttm_bo_map_iomap,
+		ttm_bo_map_vmap,
+		ttm_bo_map_kmap,
+		ttm_bo_map_premapped,
+	} bo_kmap_type;
+};
+
+/**
+ * ttm_bo_reference - reference a struct ttm_buffer_object
+ *
+ * @bo: The buffer object.
+ *
+ * Returns a refcounted pointer to a buffer object.
+ */
+
+static inline struct ttm_buffer_object *
+ttm_bo_reference(struct ttm_buffer_object *bo)
+{
+	kref_get(&bo->kref);
+	return bo;
+}
+
+/**
+ * ttm_bo_wait - wait for buffer idle.
+ *
+ * @bo:  The buffer object.
+ * @interruptible:  Use interruptible wait.
+ * @no_wait:  Return immediately if buffer is busy.
+ *
+ * This function must be called with the bo::mutex held, and makes
+ * sure any previous rendering to the buffer is completed.
+ * Note: It might be necessary to block validations before the
+ * wait by reserving the buffer.
+ * Returns -EBUSY if no_wait is true and the buffer is busy.
+ * Returns -ERESTART if interrupted by a signal.
+ */
+extern int ttm_bo_wait(struct ttm_buffer_object *bo, bool lazy,
+		       bool interruptible, bool no_wait);
+/**
+ * ttm_buffer_object_validate
+ *
+ * @bo: The buffer object.
+ * @proposed_placement: Proposed_placement for the buffer object.
+ * @interruptible: Sleep interruptible if sleeping.
+ * @no_wait: Return immediately if the buffer is busy.
+ *
+ * Changes placement and caching policy of the buffer object
+ * according to bo::proposed_flags.
+ * Returns
+ * -EINVAL on invalid proposed_flags.
+ * -ENOMEM on out-of-memory condition.
+ * -EBUSY if no_wait is true and buffer busy.
+ * -ERESTART if interrupted by a signal.
+ */
+extern int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
+				      uint32_t proposed_placement,
+				      bool interruptible, bool no_wait);
+/**
+ * ttm_bo_unref
+ *
+ * @bo: The buffer object.
+ *
+ * Unreference and clear a pointer to a buffer object.
+ */
+extern void ttm_bo_unref(struct ttm_buffer_object **bo);
+
+/**
+ * ttm_bo_synccpu_write_grab
+ *
+ * @bo: The buffer object:
+ * @no_wait: Return immediately if buffer is busy.
+ *
+ * Synchronizes a buffer object for CPU RW access. This means
+ * blocking command submission that affects the buffer and
+ * waiting for buffer idle. This lock is recursive.
+ * Returns
+ * -EBUSY if the buffer is busy and no_wait is true.
+ * -ERESTART if interrupted by a signal.
+ */
+
+extern int
+ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait);
+/**
+ * ttm_bo_synccpu_write_release:
+ *
+ * @bo : The buffer object.
+ *
+ * Releases a synccpu lock.
+ */
+extern void ttm_bo_synccpu_write_release(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_buffer_object_init
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @bo: Pointer to a ttm_buffer_object to be initialized.
+ * @size: Requested size of buffer object.
+ * @type: Requested type of buffer object.
+ * @flags: Initial placement flags.
+ * @page_alignment: Data alignment in pages.
+ * @buffer_start: Virtual address of user space data backing a
+ * user buffer object.
+ * @interruptible: If needing to sleep to wait for GPU resources,
+ * sleep interruptible.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object. Typically, this would
+ * point to the shmem object backing a GEM object if TTM is used to back a
+ * GEM user interface.
+ * @acc_size: Accounted size for this object.
+ * @destroy: Destroy function. Use NULL for kfree().
+ *
+ * This function initializes a pre-allocated struct ttm_buffer_object.
+ * As this object may be part of a larger structure, this function,
+ * together with the @destroy function,
+ * enables driver-specific objects derived from a ttm_buffer_object.
+ * On successful return, the object kref and list_kref are set to 1.
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid placement flags.
+ * -ERESTART: Interrupted by signal while sleeping waiting for resources.
+ */
+
+extern int ttm_buffer_object_init(struct ttm_bo_device *bdev,
+				  struct ttm_buffer_object *bo,
+				  unsigned long size,
+				  enum ttm_bo_type type,
+				  uint32_t flags,
+				  uint32_t page_alignment,
+				  unsigned long buffer_start,
+				  bool interrubtible,
+				  struct file *persistant_swap_storage,
+				  size_t acc_size,
+				  void (*destroy) (struct ttm_buffer_object *));
+/**
+ * ttm_bo_synccpu_object_init
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @bo: Pointer to a ttm_buffer_object to be initialized.
+ * @size: Requested size of buffer object.
+ * @type: Requested type of buffer object.
+ * @flags: Initial placement flags.
+ * @page_alignment: Data alignment in pages.
+ * @buffer_start: Virtual address of user space data backing a
+ * user buffer object.
+ * @interruptible: If needing to sleep while waiting for GPU resources,
+ * sleep interruptible.
+ * @persistant_swap_storage: Usually the swap storage is deleted for buffers
+ * pinned in physical memory. If this behaviour is not desired, this member
+ * holds a pointer to a persistant shmem object. Typically, this would
+ * point to the shmem object backing a GEM object if TTM is used to back a
+ * GEM user interface.
+ * @p_bo: On successful completion *p_bo points to the created object.
+ *
+ * This function allocates a ttm_buffer_object, and then calls
+ * ttm_buffer_object_init on that object.
+ * The destroy function is set to kfree().
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid placement flags.
+ * -ERESTART: Interrupted by signal while waiting for resources.
+ */
+
+extern int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+				    unsigned long size,
+				    enum ttm_bo_type type,
+				    uint32_t flags,
+				    uint32_t page_alignment,
+				    unsigned long buffer_start,
+				    bool interruptible,
+				    struct file *persistant_swap_storage,
+				    struct ttm_buffer_object **p_bo);
+
+/**
+ * ttm_bo_check_placement
+ *
+ * @bo: the buffer object.
+ * @set_flags: placement flags to set.
+ * @clr_flags: placement flags to clear.
+ *
+ * Performs minimal validity checking on an intended change of
+ * placement flags.
+ * Returns
+ * -EINVAL: Intended change is invalid or not allowed.
+ */
+
+extern int ttm_bo_check_placement(struct ttm_buffer_object *bo,
+				  uint32_t set_flags, uint32_t clr_flags);
+
+/**
+ * ttm_bo_init_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ * @p_offset: offset for managed area in pages.
+ * @p_size: size managed area in pages.
+ *
+ * Initialize a manager for a given memory type.
+ * Note: if part of driver firstopen, it must be protected from a
+ * potentially racing lastclose.
+ * Returns:
+ * -EINVAL: invalid size or memory type.
+ * -ENOMEM: Not enough memory.
+ * May also return driver-specified errors.
+ */
+
+extern int ttm_bo_init_mm(struct ttm_bo_device *bdev, unsigned type,
+			  unsigned long p_offset, unsigned long p_size);
+/**
+ * ttm_bo_clean_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ *
+ * Take down a manager for a given memory type after first walking
+ * the LRU list to evict any buffers left alive.
+ *
+ * Normally, this function is part of lastclose() or unload(), and at that
+ * point there shouldn't be any buffers left created by user-space, since
+ * there should've been removed by the file descriptor release() method.
+ * However, before this function is run, make sure to signal all sync objects,
+ * and verify that the delayed delete queue is empty. The driver must also
+ * make sure that there are no NO_EVICT buffers present in this memory type
+ * when the call is made.
+ *
+ * If this function is part of a VT switch, the caller must make sure that
+ * there are no appications currently validating buffers before this
+ * function is called. The caller can do that by first taking the
+ * struct ttm_bo_device::ttm_lock in write mode.
+ *
+ * Returns:
+ * -EINVAL: invalid or uninitialized memory type.
+ * -EBUSY: There are still buffers left in this memory type.
+ */
+
+extern int ttm_bo_clean_mm(struct ttm_bo_device *bdev, unsigned mem_type);
+
+/**
+ * ttm_bo_evict_mm
+ *
+ * @bdev: Pointer to a ttm_bo_device struct.
+ * @mem_type: The memory type.
+ *
+ * Evicts all buffers on the lru list of the memory type.
+ * This is normally part of a VT switch or an
+ * out-of-memory-space-due-to-fragmentation handler.
+ * The caller must make sure that there are no other processes
+ * currently validating buffers, and can do that by taking the
+ * struct ttm_bo_device::ttm_lock in write mode.
+ *
+ * Returns:
+ * -EINVAL: Invalid or uninitialized memory type.
+ * -ERESTART: The call was interrupted by a signal while waiting to
+ * evict a buffer.
+ */
+
+extern int ttm_bo_evict_mm(struct ttm_bo_device *bdev, unsigned mem_type);
+
+/**
+ * ttm_kmap_obj_virtual
+ *
+ * @map: A struct ttm_bo_kmap_obj returned from ttm_bo_kmap.
+ * @is_iomem: Pointer to an integer that on return indicates 1 if the
+ * virtual map is io memory, 0 if normal memory.
+ *
+ * Returns the virtual address of a buffer object area mapped by ttm_bo_kmap.
+ * If *is_iomem is 1 on return, the virtual address points to an io memory area,
+ * that should strictly be accessed by the iowriteXX() and similar functions.
+ */
+
+static inline void *ttm_kmap_obj_virtual(struct ttm_bo_kmap_obj *map,
+					 bool *is_iomem)
+{
+	*is_iomem = (map->bo_kmap_type == ttm_bo_map_iomap ||
+		     map->bo_kmap_type == ttm_bo_map_premapped);
+	return map->virtual;
+}
+
+/**
+ * ttm_bo_kmap
+ *
+ * @bo: The buffer object.
+ * @start_page: The first page to map.
+ * @num_pages: Number of pages to map.
+ * @map: pointer to a struct ttm_bo_kmap_obj representing the map.
+ *
+ * Sets up a kernel virtual mapping, using ioremap, vmap or kmap to the
+ * data in the buffer object. The ttm_kmap_obj_virtual function can then be
+ * used to obtain a virtual address to the data.
+ *
+ * Returns
+ * -ENOMEM: Out of memory.
+ * -EINVAL: Invalid range.
+ */
+
+extern int ttm_bo_kmap(struct ttm_buffer_object *bo, unsigned long start_page,
+		       unsigned long num_pages, struct ttm_bo_kmap_obj *map);
+
+/**
+ * ttm_bo_kunmap
+ *
+ * @map: Object describing the map to unmap.
+ *
+ * Unmaps a kernel map set up by ttm_bo_kmap.
+ */
+
+extern void ttm_bo_kunmap(struct ttm_bo_kmap_obj *map);
+
+#if 0
+#endif
+
+/**
+ * ttm_fbdev_mmap - mmap fbdev memory backed by a ttm buffer object.
+ *
+ * @vma:       vma as input from the fbdev mmap method.
+ * @bo:        The bo backing the address space. The address space will
+ * have the same size as the bo, and start at offset 0.
+ *
+ * This function is intended to be called by the fbdev mmap method
+ * if the fbdev address space is to be backed by a bo.
+ */
+
+extern int ttm_fbdev_mmap(struct vm_area_struct *vma,
+			  struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_mmap - mmap out of the ttm device address space.
+ *
+ * @filp:      filp as input from the mmap method.
+ * @vma:       vma as input from the mmap method.
+ * @bdev:      Pointer to the ttm_bo_device with the address space manager.
+ *
+ * This function is intended to be called by the device mmap method.
+ * if the device address space is to be backed by the bo manager.
+ */
+
+extern int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
+		       struct ttm_bo_device *bdev);
+
+/**
+ * ttm_bo_io
+ *
+ * @bdev:      Pointer to the struct ttm_bo_device.
+ * @filp:      Pointer to the struct file attempting to read / write.
+ * @wbuf:      User-space pointer to address of buffer to write. NULL on read.
+ * @rbuf:      User-space pointer to address of buffer to read into.
+ * Null on write.
+ * @count:     Number of bytes to read / write.
+ * @f_pos:     Pointer to current file position.
+ * @write:     1 for read, 0 for write.
+ *
+ * This function implements read / write into ttm buffer objects, and is
+ * intended to
+ * be called from the fops::read and fops::write method.
+ * Returns:
+ * See man (2) write, man(2) read. In particular,
+ * the function may return -EINTR if
+ * interrupted by a signal.
+ */
+
+extern ssize_t ttm_bo_io(struct ttm_bo_device *bdev, struct file *filp,
+			 const char __user *wbuf, char __user *rbuf,
+			 size_t count, loff_t *f_pos, bool write);
+
+extern void ttm_bo_swapout_all(struct ttm_bo_device *bdev);
+
+#endif
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
new file mode 100644
index 0000000..62ed733
--- /dev/null
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -0,0 +1,867 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2009 Vmware, Inc., Palo Alto, CA., USA
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
+#ifndef _TTM_BO_DRIVER_H_
+#define _TTM_BO_DRIVER_H_
+
+#include "ttm/ttm_bo_api.h"
+#include "ttm/ttm_memory.h"
+#include "drm_mm.h"
+#include "linux/workqueue.h"
+#include "linux/fs.h"
+#include "linux/spinlock.h"
+
+struct ttm_backend;
+
+struct ttm_backend_func {
+	/**
+	 * struct ttm_backend_func member populate
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 * @num_pages: Number of pages to populate.
+	 * @pages: Array of pointers to ttm pages.
+	 * @dummy_read_page: Page to be used instead of NULL pages in the
+	 * array @pages.
+	 *
+	 * Populate the backend with ttm pages. Depending on the backend,
+	 * it may or may not copy the @pages array.
+	 */
+	int (*populate) (struct ttm_backend *backend,
+			 unsigned long num_pages, struct page **pages,
+			 struct page *dummy_read_page);
+	/**
+	 * struct ttm_backend_func member clear
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * This is an "unpopulate" function. Release all resources
+	 * allocated with populate.
+	 */
+	void (*clear) (struct ttm_backend *backend);
+
+	/**
+	 * struct ttm_backend_func member bind
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 * @bo_mem: Pointer to a struct ttm_mem_reg describing the
+	 * memory type and location for binding.
+	 *
+	 * Bind the backend pages into the aperture in the location
+	 * indicated by @bo_mem. This function should be able to handle
+	 * differences between aperture- and system page sizes.
+	 */
+	int (*bind) (struct ttm_backend *backend, struct ttm_mem_reg *bo_mem);
+
+	/**
+	 * struct ttm_backend_func member unbind
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * Unbind previously bound backend pages. This function should be
+	 * able to handle differences between aperture- and system page sizes.
+	 */
+	int (*unbind) (struct ttm_backend *backend);
+
+	/**
+	 * struct ttm_backend_func member destroy
+	 *
+	 * @backend: Pointer to a struct ttm_backend.
+	 *
+	 * Destroy the backend.
+	 */
+	void (*destroy) (struct ttm_backend *backend);
+};
+
+/**
+ * struct ttm_backend
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @flags: For driver use.
+ * @func: Pointer to a struct ttm_backend_func that describes
+ * the backend methods.
+ *
+ */
+
+struct ttm_backend {
+	struct ttm_bo_device *bdev;
+	uint32_t flags;
+	struct ttm_backend_func *func;
+};
+
+#define TTM_PAGE_FLAG_VMALLOC         (1 << 0)
+#define TTM_PAGE_FLAG_USER            (1 << 1)
+#define TTM_PAGE_FLAG_USER_DIRTY      (1 << 2)
+#define TTM_PAGE_FLAG_WRITE           (1 << 3)
+#define TTM_PAGE_FLAG_SWAPPED         (1 << 4)
+#define TTM_PAGE_FLAG_PERSISTANT_SWAP (1 << 5)
+#define TTM_PAGE_FLAG_ZERO_ALLOC      (1 << 6)
+
+enum ttm_caching_state {
+	tt_uncached,
+	tt_wc,
+	tt_cached
+};
+
+/**
+ * struct ttm_tt
+ *
+ * @dummy_read_page: Page to map where the ttm_tt page array contains a NULL
+ * pointer.
+ * @pages: Array of pages backing the data.
+ * @first_himem_page: Himem pages are put last in the page array, which
+ * enables us to run caching attribute changes on only the first part
+ * of the page array containing lomem pages. This is the index of the
+ * first himem page.
+ * @last_lomem_page: Index of the last lomem page in the page array.
+ * @num_pages: Number of pages in the page array.
+ * @bdev: Pointer to the current struct ttm_bo_device.
+ * @be: Pointer to the ttm backend.
+ * @tsk: The task for user ttm.
+ * @start: virtual address for user ttm.
+ * @swap_storage: Pointer to shmem struct file for swap storage.
+ * @caching_state: The current caching state of the pages.
+ * @state: The current binding state of the pages.
+ *
+ * This is a structure holding the pages, caching- and aperture binding
+ * status for a buffer object that isn't backed by fixed (VRAM / AGP)
+ * memory.
+ */
+
+struct ttm_tt {
+	struct page *dummy_read_page;
+	struct page **pages;
+	long first_himem_page;
+	long last_lomem_page;
+	uint32_t page_flags;
+	unsigned long num_pages;
+	struct ttm_bo_device *bdev;
+	struct ttm_backend *be;
+	struct task_struct *tsk;
+	unsigned long start;
+	struct file *swap_storage;
+	enum ttm_caching_state caching_state;
+	enum {
+		tt_bound,
+		tt_unbound,
+		tt_unpopulated,
+	} state;
+};
+
+#define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */
+#define TTM_MEMTYPE_FLAG_MAPPABLE      (1 << 1)	/* Memory mappable */
+#define TTM_MEMTYPE_FLAG_NEEDS_IOREMAP (1 << 2)	/* Fixed memory needs ioremap
+						   before kernel access. */
+#define TTM_MEMTYPE_FLAG_CMA           (1 << 3)	/* Can't map aperture */
+
+/**
+ * struct ttm_mem_type_manager
+ *
+ * @has_type: The memory type has been initialized.
+ * @use_type: The memory type is enabled.
+ * @flags: TTM_MEMTYPE_XX flags identifying the traits of the memory
+ * managed by this memory type.
+ * @gpu_offset: If used, the GPU offset of the first managed page of
+ * fixed memory or the first managed location in an aperture.
+ * @io_offset: The io_offset of the first managed page of IO memory or
+ * the first managed location in an aperture. For TTM_MEMTYPE_FLAG_CMA
+ * memory, this should be set to NULL.
+ * @io_size: The size of a managed IO region (fixed memory or aperture).
+ * @io_addr: Virtual kernel address if the io region is pre-mapped. For
+ * TTM_MEMTYPE_FLAG_NEEDS_IOREMAP there is no pre-mapped io map and
+ * @io_addr should be set to NULL.
+ * @size: Size of the managed region.
+ * @available_caching: A mask of available caching types, TTM_PL_FLAG_XX,
+ * as defined in ttm_placement_common.h
+ * @default_caching: The default caching policy used for a buffer object
+ * placed in this memory type if the user doesn't provide one.
+ * @manager: The range manager used for this memory type. FIXME: If the aperture
+ * has a page size different from the underlying system, the granularity
+ * of this manager should take care of this. But the range allocating code
+ * in ttm_bo.c needs to be modified for this.
+ * @lru: The lru list for this memory type.
+ *
+ * This structure is used to identify and manage memory types for a device.
+ * It's set up by the ttm_bo_driver::init_mem_type method.
+ */
+
+struct ttm_mem_type_manager {
+
+	/*
+	 * No protection. Constant from start.
+	 */
+
+	bool has_type;
+	bool use_type;
+	uint32_t flags;
+	unsigned long gpu_offset;
+	unsigned long io_offset;
+	unsigned long io_size;
+	void *io_addr;
+	uint64_t size;
+	uint32_t available_caching;
+	uint32_t default_caching;
+
+	/*
+	 * Protected by the bdev->lru_lock.
+	 * TODO: Consider one lru_lock per ttm_mem_type_manager.
+	 * Plays ill with list removal, though.
+	 */
+
+	struct drm_mm manager;
+	struct list_head lru;
+};
+
+/**
+ * struct ttm_bo_driver
+ *
+ * @mem_type_prio: Priority array of memory types to place a buffer object in
+ * if it fits without evicting buffers from any of these memory types.
+ * @mem_busy_prio: Priority array of memory types to place a buffer object in
+ * if it needs to evict buffers to make room.
+ * @num_mem_type_prio: Number of elements in the @mem_type_prio array.
+ * @num_mem_busy_prio: Number of elements in the @num_mem_busy_prio array.
+ * @create_ttm_backend_entry: Callback to create a struct ttm_backend.
+ * @invalidate_caches: Callback to invalidate read caches when a buffer object
+ * has been evicted.
+ * @init_mem_type: Callback to initialize a struct ttm_mem_type_manager
+ * structure.
+ * @evict_flags: Callback to obtain placement flags when a buffer is evicted.
+ * @move: Callback for a driver to hook in accelerated functions to
+ * move a buffer.
+ * If set to NULL, a potentially slow memcpy() move is used.
+ * @sync_obj_signaled: See ttm_fence_api.h
+ * @sync_obj_wait: See ttm_fence_api.h
+ * @sync_obj_flush: See ttm_fence_api.h
+ * @sync_obj_unref: See ttm_fence_api.h
+ * @sync_obj_ref: See ttm_fence_api.h
+ */
+
+struct ttm_bo_driver {
+	const uint32_t *mem_type_prio;
+	const uint32_t *mem_busy_prio;
+	uint32_t num_mem_type_prio;
+	uint32_t num_mem_busy_prio;
+
+	/**
+	 * struct ttm_bo_driver member create_ttm_backend_entry
+	 *
+	 * @bdev: The buffer object device.
+	 *
+	 * Create a driver specific struct ttm_backend.
+	 */
+
+	struct ttm_backend *(*create_ttm_backend_entry)
+	 (struct ttm_bo_device *bdev);
+
+	/**
+	 * struct ttm_bo_driver member invalidate_caches
+	 *
+	 * @bdev: the buffer object device.
+	 * @flags: new placement of the rebound buffer object.
+	 *
+	 * A previosly evicted buffer has been rebound in a
+	 * potentially new location. Tell the driver that it might
+	 * consider invalidating read (texture) caches on the next command
+	 * submission as a consequence.
+	 */
+
+	int (*invalidate_caches) (struct ttm_bo_device *bdev, uint32_t flags);
+	int (*init_mem_type) (struct ttm_bo_device *bdev, uint32_t type,
+			      struct ttm_mem_type_manager *man);
+	/**
+	 * struct ttm_bo_driver member evict_flags:
+	 *
+	 * @bo: the buffer object to be evicted
+	 *
+	 * Return the bo flags for a buffer which is not mapped to the hardware.
+	 * These will be placed in proposed_flags so that when the move is
+	 * finished, they'll end up in bo->mem.flags
+	 */
+
+	 uint32_t(*evict_flags) (struct ttm_buffer_object *bo);
+	/**
+	 * struct ttm_bo_driver member move:
+	 *
+	 * @bo: the buffer to move
+	 * @evict: whether this motion is evicting the buffer from
+	 * the graphics address space
+	 * @interruptible: Use interruptible sleeps if possible when sleeping.
+	 * @no_wait: whether this should give up and return -EBUSY
+	 * if this move would require sleeping
+	 * @new_mem: the new memory region receiving the buffer
+	 *
+	 * Move a buffer between two memory regions.
+	 */
+	int (*move) (struct ttm_buffer_object *bo,
+		     bool evict, bool interruptible,
+		     bool no_wait, struct ttm_mem_reg *new_mem);
+
+	/**
+	 * struct ttm_bo_driver_member verify_access
+	 *
+	 * @bo: Pointer to a buffer object.
+	 * @filp: Pointer to a struct file trying to access the object.
+	 *
+	 * Called from the map / write / read methods to verify that the
+	 * caller is permitted to access the buffer object.
+	 * This member may be set to NULL, which will refuse this kind of
+	 * access for all buffer objects.
+	 * This function should return 0 if access is granted, -EPERM otherwise.
+	 */
+	int (*verify_access) (struct ttm_buffer_object *bo,
+			      struct file *filp);
+
+	/**
+	 * In case a driver writer dislikes the TTM fence objects,
+	 * the driver writer can replace those with sync objects of
+	 * his / her own. If it turns out that no driver writer is
+	 * using these. I suggest we remove these hooks and plug in
+	 * fences directly. The bo driver needs the following functionality:
+	 * See the corresponding functions in the fence object API
+	 * documentation.
+	 */
+
+	bool (*sync_obj_signaled) (void *sync_obj, void *sync_arg);
+	int (*sync_obj_wait) (void *sync_obj, void *sync_arg,
+			      bool lazy, bool interruptible);
+	int (*sync_obj_flush) (void *sync_obj, void *sync_arg);
+	void (*sync_obj_unref) (void **sync_obj);
+	void *(*sync_obj_ref) (void *sync_obj);
+};
+
+#define TTM_NUM_MEM_TYPES 8
+
+#define TTM_BO_PRIV_FLAG_MOVING  0	/* Buffer object is moving and needs
+					   idling before CPU mapping */
+#define TTM_BO_PRIV_FLAG_MAX 1
+/**
+ * struct ttm_bo_device - Buffer object driver device-specific data.
+ *
+ * @mem_glob: Pointer to a struct ttm_mem_global object for accounting.
+ * @driver: Pointer to a struct ttm_bo_driver struct setup by the driver.
+ * @count: Current number of buffer object.
+ * @pages: Current number of pinned pages.
+ * @dummy_read_page: Pointer to a dummy page used for mapping requests
+ * of unpopulated pages.
+ * @shrink: A shrink callback object used for buffre object swap.
+ * @ttm_bo_extra_size: Extra size (sizeof(struct ttm_buffer_object) excluded)
+ * used by a buffer object. This is excluding page arrays and backing pages.
+ * @ttm_bo_size: This is @ttm_bo_extra_size + sizeof(struct ttm_buffer_object).
+ * @man: An array of mem_type_managers.
+ * @addr_space_mm: Range manager for the device address space.
+ * lru_lock: Spinlock that protects the buffer+device lru lists and
+ * ddestroy lists.
+ * @nice_mode: Try nicely to wait for buffer idle when cleaning a manager.
+ * If a GPU lockup has been detected, this is forced to 0.
+ * @dev_mapping: A pointer to the struct address_space representing the
+ * device address space.
+ * @wq: Work queue structure for the delayed delete workqueue.
+ *
+ */
+
+struct ttm_bo_device {
+
+	/*
+	 * Constant after bo device init / atomic.
+	 */
+
+	struct ttm_mem_global *mem_glob;
+	struct ttm_bo_driver *driver;
+	struct page *dummy_read_page;
+	struct ttm_mem_shrink shrink;
+
+	size_t ttm_bo_extra_size;
+	size_t ttm_bo_size;
+
+	rwlock_t vm_lock;
+	/*
+	 * Protected by the vm lock.
+	 */
+	struct ttm_mem_type_manager man[TTM_NUM_MEM_TYPES];
+	struct rb_root addr_space_rb;
+	struct drm_mm addr_space_mm;
+
+	/*
+	 * Might want to change this to one lock per manager.
+	 */
+	spinlock_t lru_lock;
+	/*
+	 * Protected by the lru lock.
+	 */
+	struct list_head ddestroy;
+	struct list_head swap_lru;
+
+	/*
+	 * Protected by load / firstopen / lastclose /unload sync.
+	 */
+
+	bool nice_mode;
+	struct address_space *dev_mapping;
+
+	/*
+	 * Internal protection.
+	 */
+
+	struct delayed_work wq;
+};
+
+/**
+ * ttm_flag_masked
+ *
+ * @old: Pointer to the result and original value.
+ * @new: New value of bits.
+ * @mask: Mask of bits to change.
+ *
+ * Convenience function to change a number of bits identified by a mask.
+ */
+
+static inline uint32_t
+ttm_flag_masked(uint32_t *old, uint32_t new, uint32_t mask)
+{
+	*old ^= (*old ^ new) & mask;
+	return *old;
+}
+
+/**
+ * ttm_tt_create
+ *
+ * @bdev: pointer to a struct ttm_bo_device:
+ * @size: Size of the data needed backing.
+ * @page_flags: Page flags as identified by TTM_PAGE_FLAG_XX flags.
+ * @dummy_read_page: See struct ttm_bo_device.
+ *
+ * Create a struct ttm_tt to back data with system memory pages.
+ * No pages are actually allocated.
+ * Returns:
+ * NULL: Out of memory.
+ */
+extern struct ttm_tt *ttm_tt_create(struct ttm_bo_device *bdev,
+				    unsigned long size,
+				    uint32_t page_flags,
+				    struct page *dummy_read_page);
+
+/**
+ * ttm_tt_set_user:
+ *
+ * @ttm: The struct ttm_tt to populate.
+ * @tsk: A struct task_struct for which @start is a valid user-space address.
+ * @start: A valid user-space address.
+ * @num_pages: Size in pages of the user memory area.
+ *
+ * Populate a struct ttm_tt with a user-space memory area after first pinning
+ * the pages backing it.
+ * Returns:
+ * !0: Error.
+ */
+
+extern int ttm_tt_set_user(struct ttm_tt *ttm,
+			   struct task_struct *tsk,
+			   unsigned long start, unsigned long num_pages);
+
+/**
+ * ttm_ttm_bind:
+ *
+ * @ttm: The struct ttm_tt containing backing pages.
+ * @bo_mem: The struct ttm_mem_reg identifying the binding location.
+ *
+ * Bind the pages of @ttm to an aperture location identified by @bo_mem
+ */
+extern int ttm_tt_bind(struct ttm_tt *ttm, struct ttm_mem_reg *bo_mem);
+
+/**
+ * ttm_ttm_destroy:
+ *
+ * @ttm: The struct ttm_tt.
+ *
+ * Unbind, unpopulate and destroy a struct ttm_tt.
+ */
+extern void ttm_tt_destroy(struct ttm_tt *ttm);
+
+/**
+ * ttm_ttm_unbind:
+ *
+ * @ttm: The struct ttm_tt.
+ *
+ * Unbind a struct ttm_tt.
+ */
+extern void ttm_tt_unbind(struct ttm_tt *ttm);
+
+/**
+ * ttm_ttm_destroy:
+ *
+ * @ttm: The struct ttm_tt.
+ * @index: Index of the desired page.
+ *
+ * Return a pointer to the struct page backing @ttm at page
+ * index @index. If the page is unpopulated, one will be allocated to
+ * populate that index.
+ *
+ * Returns:
+ * NULL on OOM.
+ */
+extern struct page *ttm_tt_get_page(struct ttm_tt *ttm, int index);
+
+/**
+ * ttm_tt_cache_flush:
+ *
+ * @pages: An array of pointers to struct page:s to flush.
+ * @num_pages: Number of pages to flush.
+ *
+ * Flush the data of the indicated pages from the cpu caches.
+ * This is used when changing caching attributes of the pages from
+ * cache-coherent.
+ */
+extern void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages);
+
+/**
+ * ttm_tt_set_placement_caching:
+ *
+ * @ttm A struct ttm_tt the backing pages of which will change caching policy.
+ * @placement: Flag indicating the desired caching policy.
+ *
+ * This function will change caching policy of any default kernel mappings of
+ * the pages backing @ttm. If changing from cached to uncached or
+ * write-combined,
+ * all CPU caches will first be flushed to make sure the data of the pages
+ * hit RAM. This function may be very costly as it involves global TLB
+ * and cache flushes and potential page splitting / combining.
+ */
+extern int ttm_tt_set_placement_caching(struct ttm_tt *ttm, uint32_t placement);
+extern int ttm_tt_swapout(struct ttm_tt *ttm,
+			  struct file *persistant_swap_storage);
+
+/*
+ * ttm_bo.c
+ */
+
+/**
+ * ttm_mem_reg_is_pci
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @mem: A valid struct ttm_mem_reg.
+ *
+ * Returns true if the memory described by @mem is PCI memory,
+ * false otherwise.
+ */
+extern bool ttm_mem_reg_is_pci(struct ttm_bo_device *bdev,
+				   struct ttm_mem_reg *mem);
+
+/**
+ * ttm_bo_mem_space
+ *
+ * @bo: Pointer to a struct ttm_buffer_object. the data of which
+ * we want to allocate space for.
+ * @proposed_placement: Proposed new placement for the buffer object.
+ * @mem: A struct ttm_mem_reg.
+ * @interruptible: Sleep interruptible when sliping.
+ * @no_wait: Don't sleep waiting for space to become available.
+ *
+ * Allocate memory space for the buffer object pointed to by @bo, using
+ * the placement flags in @mem, potentially evicting other idle buffer objects.
+ * This function may sleep while waiting for space to become available.
+ * Returns:
+ * -EBUSY: No space available (only if no_wait == 1).
+ * -ENOMEM: Could not allocate memory for the buffer object, either due to
+ * fragmentation or concurrent allocators.
+ * -ERESTART: An interruptible sleep was interrupted by a signal.
+ */
+extern int ttm_bo_mem_space(struct ttm_buffer_object *bo,
+			    uint32_t proposed_placement,
+			    struct ttm_mem_reg *mem,
+			    bool interruptible, bool no_wait);
+/**
+ * ttm_bo_wait_for_cpu
+ *
+ * @bo: Pointer to a struct ttm_buffer_object.
+ * @no_wait: Don't sleep while waiting.
+ *
+ * Wait until a buffer object is no longer sync'ed for CPU access.
+ * Returns:
+ * -EBUSY: Buffer object was sync'ed for CPU access. (only if no_wait == 1).
+ * -ERESTART: An interruptible sleep was interrupted by a signal.
+ */
+
+extern int ttm_bo_wait_cpu(struct ttm_buffer_object *bo, bool no_wait);
+
+/**
+ * ttm_bo_pci_offset - Get the PCI offset for the buffer object memory.
+ *
+ * @bo Pointer to a struct ttm_buffer_object.
+ * @bus_base On return the base of the PCI region
+ * @bus_offset On return the byte offset into the PCI region
+ * @bus_size On return the byte size of the buffer object or zero if
+ * the buffer object memory is not accessible through a PCI region.
+ *
+ * Returns:
+ * -EINVAL if the buffer object is currently not mappable.
+ * 0 otherwise.
+ */
+
+extern int ttm_bo_pci_offset(struct ttm_bo_device *bdev,
+			     struct ttm_mem_reg *mem,
+			     unsigned long *bus_base,
+			     unsigned long *bus_offset,
+			     unsigned long *bus_size);
+
+extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
+
+/**
+ * ttm_bo_device_init
+ *
+ * @bdev: A pointer to a struct ttm_bo_device to initialize.
+ * @mem_global: A pointer to an initialized struct ttm_mem_global.
+ * @driver: A pointer to a struct ttm_bo_driver set up by the caller.
+ * @file_page_offset: Offset into the device address space that is available
+ * for buffer data. This ensures compatibility with other users of the
+ * address space.
+ *
+ * Initializes a struct ttm_bo_device:
+ * Returns:
+ * !0: Failure.
+ */
+extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
+			      struct ttm_mem_global *mem_glob,
+			      struct ttm_bo_driver *driver,
+			      uint64_t file_page_offset);
+
+/**
+ * ttm_bo_reserve:
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @interruptible: Sleep interruptible if waiting.
+ * @no_wait: Don't sleep while trying to reserve, rather return -EBUSY.
+ * @use_sequence: If @bo is already reserved, Only sleep waiting for
+ * it to become unreserved if @sequence < (@bo)->sequence.
+ *
+ * Locks a buffer object for validation. (Or prevents other processes from
+ * locking it for validation) and removes it from lru lists, while taking
+ * a number of measures to prevent deadlocks.
+ *
+ * Deadlocks may occur when two processes try to reserve multiple buffers in
+ * different order, either by will or as a result of a buffer being evicted
+ * to make room for a buffer already reserved. (Buffers are reserved before
+ * they are evicted). The following algorithm prevents such deadlocks from
+ * occuring:
+ * 1) Buffers are reserved with the lru spinlock held. Upon successful
+ * reservation they are removed from the lru list. This stops a reserved buffer
+ * from being evicted. However the lru spinlock is released between the time
+ * a buffer is selected for eviction and the time it is reserved.
+ * Therefore a check is made when a buffer is reserved for eviction, that it
+ * is still the first buffer in the lru list, before it is removed from the
+ * list. @check_lru == 1 forces this check. If it fails, the function returns
+ * -EINVAL, and the caller should then choose a new buffer to evict and repeat
+ * the procedure.
+ * 2) Processes attempting to reserve multiple buffers other than for eviction,
+ * (typically execbuf), should first obtain a unique 32-bit
+ * validation sequence number,
+ * and call this function with @use_sequence == 1 and @sequence == the unique
+ * sequence number. If upon call of this function, the buffer object is already
+ * reserved, the validation sequence is checked against the validation
+ * sequence of the process currently reserving the buffer,
+ * and if the current validation sequence is greater than that of the process
+ * holding the reservation, the function returns -EAGAIN. Otherwise it sleeps
+ * waiting for the buffer to become unreserved, after which it retries
+ * reserving.
+ * The caller should, when receiving an -EAGAIN error
+ * release all its buffer reservations, wait for @bo to become unreserved, and
+ * then rerun the validation with the same validation sequence. This procedure
+ * will always guarantee that the process with the lowest validation sequence
+ * will eventually succeed, preventing both deadlocks and starvation.
+ *
+ * Returns:
+ * -EAGAIN: The reservation may cause a deadlock.
+ * Release all buffer reservations, wait for @bo to become unreserved and
+ * try again. (only if use_sequence == 1).
+ * -ERESTART: A wait for the buffer to become unreserved was interrupted by
+ * a signal. Release all buffer reservations and return to user-space.
+ */
+extern int ttm_bo_reserve(struct ttm_buffer_object *bo,
+			  bool interruptible,
+			  bool no_wait, bool use_sequence, uint32_t sequence);
+
+/**
+ * ttm_bo_unreserve
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Unreserve a previous reservation of @bo.
+ */
+extern void ttm_bo_unreserve(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_wait_unreserved
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Wait for a struct ttm_buffer_object to become unreserved.
+ * This is typically used in the execbuf code to relax cpu-usage when
+ * a potential deadlock condition backoff.
+ */
+extern int ttm_bo_wait_unreserved(struct ttm_buffer_object *bo,
+				  bool interruptible);
+
+/**
+ * ttm_bo_block_reservation
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @interruptible: Use interruptible sleep when waiting.
+ * @no_wait: Don't sleep, but rather return -EBUSY.
+ *
+ * Block reservation for validation by simply reserving the buffer.
+ * This is intended for single buffer use only without eviction,
+ * and thus needs no deadlock protection.
+ *
+ * Returns:
+ * -EBUSY: If no_wait == 1 and the buffer is already reserved.
+ * -ERESTART: If interruptible == 1 and the process received a signal
+ * while sleeping.
+ */
+extern int ttm_bo_block_reservation(struct ttm_buffer_object *bo,
+				    bool interruptible, bool no_wait);
+
+/**
+ * ttm_bo_unblock_reservation
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Unblocks reservation leaving lru lists untouched.
+ */
+extern void ttm_bo_unblock_reservation(struct ttm_buffer_object *bo);
+
+/*
+ * ttm_bo_util.c
+ */
+
+/**
+ * ttm_bo_move_ttm
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @evict: 1: This is an eviction. Don't try to pipeline.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Optimized move function for a buffer object with both old and
+ * new placement backed by a TTM. The function will, if successful,
+ * free any old aperture space, and set (@new_mem)->mm_node to NULL,
+ * and update the (@bo)->mem placement flags. If unsuccessful, the old
+ * data remains untouched, and it's up to the caller to free the
+ * memory space indicated by @new_mem.
+ * Returns:
+ * !0: Failure.
+ */
+
+extern int ttm_bo_move_ttm(struct ttm_buffer_object *bo,
+			   bool evict, bool no_wait,
+			   struct ttm_mem_reg *new_mem);
+
+/**
+ * ttm_bo_move_memcpy
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @evict: 1: This is an eviction. Don't try to pipeline.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Fallback move function for a mappable buffer object in mappable memory.
+ * The function will, if successful,
+ * free any old aperture space, and set (@new_mem)->mm_node to NULL,
+ * and update the (@bo)->mem placement flags. If unsuccessful, the old
+ * data remains untouched, and it's up to the caller to free the
+ * memory space indicated by @new_mem.
+ * Returns:
+ * !0: Failure.
+ */
+
+extern int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
+			      bool evict,
+			      bool no_wait, struct ttm_mem_reg *new_mem);
+
+/**
+ * ttm_bo_free_old_node
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ *
+ * Utility function to free an old placement after a successful move.
+ */
+extern void ttm_bo_free_old_node(struct ttm_buffer_object *bo);
+
+/**
+ * ttm_bo_move_accel_cleanup.
+ *
+ * @bo: A pointer to a struct ttm_buffer_object.
+ * @sync_obj: A sync object that signals when moving is complete.
+ * @sync_obj_arg: An argument to pass to the sync object idle / wait
+ * functions.
+ * @evict: This is an evict move. Don't return until the buffer is idle.
+ * @no_wait: Never sleep, but rather return with -EBUSY.
+ * @new_mem: struct ttm_mem_reg indicating where to move.
+ *
+ * Accelerated move function to be called when an accelerated move
+ * has been scheduled. The function will create a new temporary buffer object
+ * representing the old placement, and put the sync object on both buffer
+ * objects. After that the newly created buffer object is unref'd to be
+ * destroyed when the move is complete. This will help pipeline
+ * buffer moves.
+ */
+
+extern int ttm_bo_move_accel_cleanup(struct ttm_buffer_object *bo,
+				     void *sync_obj,
+				     void *sync_obj_arg,
+				     bool evict, bool no_wait,
+				     struct ttm_mem_reg *new_mem);
+/**
+ * ttm_io_prot
+ *
+ * @c_state: Caching state.
+ * @tmp: Page protection flag for a normal, cached mapping.
+ *
+ * Utility function that returns the pgprot_t that should be used for
+ * setting up a PTE with the caching model indicated by @c_state.
+ */
+extern pgprot_t ttm_io_prot(enum ttm_caching_state c_state, pgprot_t tmp);
+
+#if (defined(CONFIG_AGP) || (defined(CONFIG_AGP_MODULE) && defined(MODULE)))
+#define TTM_HAS_AGP
+#include <linux/agp_backend.h>
+
+/**
+ * ttm_agp_backend_init
+ *
+ * @bdev: Pointer to a struct ttm_bo_device.
+ * @bridge: The agp bridge this device is sitting on.
+ *
+ * Create a TTM backend that uses the indicated AGP bridge as an aperture
+ * for TT memory. This function uses the linux agpgart interface to
+ * bind and unbind memory backing a ttm_tt.
+ */
+extern struct ttm_backend *ttm_agp_backend_init(struct ttm_bo_device *bdev,
+						struct agp_bridge_data *bridge);
+#endif
+
+#endif
diff --git a/include/drm/ttm/ttm_memory.h b/include/drm/ttm/ttm_memory.h
new file mode 100644
index 0000000..d8b8f04
--- /dev/null
+++ b/include/drm/ttm/ttm_memory.h
@@ -0,0 +1,153 @@
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
+#ifndef TTM_MEMORY_H
+#define TTM_MEMORY_H
+
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/errno.h>
+
+/**
+ * struct ttm_mem_shrink - callback to shrink TTM memory usage.
+ *
+ * @do_shrink: The callback function.
+ *
+ * Arguments to the do_shrink functions are intended to be passed using
+ * inheritance. That is, the argument class derives from struct ttm_mem_srink,
+ * and can be accessed using container_of().
+ */
+
+struct ttm_mem_shrink {
+	int (*do_shrink) (struct ttm_mem_shrink *);
+};
+
+/**
+ * struct ttm_mem_global - Global memory accounting structure.
+ *
+ * @shrink: A single callback to shrink TTM memory usage. Extend this
+ * to a linked list to be able to handle multiple callbacks when needed.
+ * @swap_queue: A workqueue to handle shrinking in low memory situations. We
+ * need a separate workqueue since it will spend a lot of time waiting
+ * for the GPU, and this will otherwise block other workqueue tasks(?)
+ * At this point we use only a single-threaded workqueue.
+ * @work: The workqueue callback for the shrink queue.
+ * @queue: Wait queue for processes suspended waiting for memory.
+ * @lock: Lock to protect the @shrink - and the memory accounting members,
+ * that is, essentially the whole structure with some exceptions.
+ * @emer_memory: Lowmem memory limit available for root.
+ * @max_memory: Lowmem memory limit available for non-root.
+ * @swap_limit: Lowmem memory limit where the shrink workqueue kicks in.
+ * @used_memory: Currently used lowmem memory.
+ * @used_total_memory: Currently used total (lowmem + highmem) memory.
+ * @total_memory_swap_limit: Total memory limit where the shrink workqueue
+ * kicks in.
+ * @max_total_memory: Total memory available to non-root processes.
+ * @emer_total_memory: Total memory available to root processes.
+ *
+ * Note that this structure is not per device. It should be global for all
+ * graphics devices.
+ */
+
+struct ttm_mem_global {
+	struct ttm_mem_shrink *shrink;
+	struct workqueue_struct *swap_queue;
+	struct work_struct work;
+	wait_queue_head_t queue;
+	spinlock_t lock;
+	uint64_t emer_memory;
+	uint64_t max_memory;
+	uint64_t swap_limit;
+	uint64_t used_memory;
+	uint64_t used_total_memory;
+	uint64_t total_memory_swap_limit;
+	uint64_t max_total_memory;
+	uint64_t emer_total_memory;
+};
+
+/**
+ * ttm_mem_init_shrink - initialize a struct ttm_mem_shrink object
+ *
+ * @shrink: The object to initialize.
+ * @func: The callback function.
+ */
+
+static inline void ttm_mem_init_shrink(struct ttm_mem_shrink *shrink,
+				       int (*func) (struct ttm_mem_shrink *))
+{
+	shrink->do_shrink = func;
+}
+
+/**
+ * ttm_mem_register_shrink - register a struct ttm_mem_shrink object.
+ *
+ * @glob: The struct ttm_mem_global object to register with.
+ * @shrink: An initialized struct ttm_mem_shrink object to register.
+ *
+ * Returns:
+ * -EBUSY: There's already a callback registered. (May change).
+ */
+
+static inline int ttm_mem_register_shrink(struct ttm_mem_global *glob,
+					  struct ttm_mem_shrink *shrink)
+{
+	spin_lock(&glob->lock);
+	if (glob->shrink != NULL) {
+		spin_unlock(&glob->lock);
+		return -EBUSY;
+	}
+	glob->shrink = shrink;
+	spin_unlock(&glob->lock);
+	return 0;
+}
+
+/**
+ * ttm_mem_unregister_shrink - unregister a struct ttm_mem_shrink object.
+ *
+ * @glob: The struct ttm_mem_global object to unregister from.
+ * @shrink: A previously registert struct ttm_mem_shrink object.
+ *
+ */
+
+static inline void ttm_mem_unregister_shrink(struct ttm_mem_global *glob,
+					     struct ttm_mem_shrink *shrink)
+{
+	spin_lock(&glob->lock);
+	BUG_ON(glob->shrink != shrink);
+	glob->shrink = NULL;
+	spin_unlock(&glob->lock);
+}
+
+extern int ttm_mem_global_init(struct ttm_mem_global *glob);
+extern void ttm_mem_global_release(struct ttm_mem_global *glob);
+extern int ttm_mem_global_alloc(struct ttm_mem_global *glob, uint64_t memory,
+				bool no_wait, bool interruptible, bool himem);
+extern void ttm_mem_global_free(struct ttm_mem_global *glob,
+				uint64_t amount, bool himem);
+extern size_t ttm_round_pot(size_t size);
+#endif
diff --git a/include/drm/ttm/ttm_module.h b/include/drm/ttm/ttm_module.h
new file mode 100644
index 0000000..889a4c7
--- /dev/null
+++ b/include/drm/ttm/ttm_module.h
@@ -0,0 +1,58 @@
+/**************************************************************************
+ *
+ * Copyright 2008-2009 VMware, Inc., Palo Alto, CA., USA
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
+#ifndef _TTM_MODULE_H_
+#define _TTM_MODULE_H_
+
+#include <linux/kernel.h>
+
+#define TTM_PFX "[TTM]"
+
+enum ttm_global_types {
+	TTM_GLOBAL_TTM_MEM = 0,
+	TTM_GLOBAL_TTM_BO,
+	TTM_GLOBAL_TTM_OBJECT,
+	TTM_GLOBAL_NUM
+};
+
+struct ttm_global_reference {
+	enum ttm_global_types global_type;
+	size_t size;
+	void *object;
+	int (*init) (struct ttm_global_reference *);
+	void (*release) (struct ttm_global_reference *);
+};
+
+extern void ttm_global_init(void);
+extern void ttm_global_release(void);
+extern int ttm_global_item_ref(struct ttm_global_reference *ref);
+extern void ttm_global_item_unref(struct ttm_global_reference *ref);
+
+#endif /* _TTM_MODULE_H_ */
diff --git a/include/drm/ttm/ttm_placement.h b/include/drm/ttm/ttm_placement.h
new file mode 100644
index 0000000..c84ff15
--- /dev/null
+++ b/include/drm/ttm/ttm_placement.h
@@ -0,0 +1,92 @@
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
+#ifndef _TTM_PLACEMENT_H_
+#define _TTM_PLACEMENT_H_
+/*
+ * Memory regions for data placement.
+ */
+
+#define TTM_PL_SYSTEM           0
+#define TTM_PL_TT               1
+#define TTM_PL_VRAM             2
+#define TTM_PL_PRIV0            3
+#define TTM_PL_PRIV1            4
+#define TTM_PL_PRIV2            5
+#define TTM_PL_PRIV3            6
+#define TTM_PL_PRIV4            7
+#define TTM_PL_PRIV5            8
+#define TTM_PL_SWAPPED          15
+
+#define TTM_PL_FLAG_SYSTEM      (1 << TTM_PL_SYSTEM)
+#define TTM_PL_FLAG_TT          (1 << TTM_PL_TT)
+#define TTM_PL_FLAG_VRAM        (1 << TTM_PL_VRAM)
+#define TTM_PL_FLAG_PRIV0       (1 << TTM_PL_PRIV0)
+#define TTM_PL_FLAG_PRIV1       (1 << TTM_PL_PRIV1)
+#define TTM_PL_FLAG_PRIV2       (1 << TTM_PL_PRIV2)
+#define TTM_PL_FLAG_PRIV3       (1 << TTM_PL_PRIV3)
+#define TTM_PL_FLAG_PRIV4       (1 << TTM_PL_PRIV4)
+#define TTM_PL_FLAG_PRIV5       (1 << TTM_PL_PRIV5)
+#define TTM_PL_FLAG_SWAPPED     (1 << TTM_PL_SWAPPED)
+#define TTM_PL_MASK_MEM         0x0000FFFF
+
+/*
+ * Other flags that affects data placement.
+ * TTM_PL_FLAG_CACHED indicates cache-coherent mappings
+ * if available.
+ * TTM_PL_FLAG_SHARED means that another application may
+ * reference the buffer.
+ * TTM_PL_FLAG_NO_EVICT means that the buffer may never
+ * be evicted to make room for other buffers.
+ */
+
+#define TTM_PL_FLAG_CACHED      (1 << 16)
+#define TTM_PL_FLAG_UNCACHED    (1 << 17)
+#define TTM_PL_FLAG_WC          (1 << 18)
+#define TTM_PL_FLAG_SHARED      (1 << 20)
+#define TTM_PL_FLAG_NO_EVICT    (1 << 21)
+
+#define TTM_PL_MASK_CACHING     (TTM_PL_FLAG_CACHED | \
+				 TTM_PL_FLAG_UNCACHED | \
+				 TTM_PL_FLAG_WC)
+
+#define TTM_PL_MASK_MEMTYPE     (TTM_PL_MASK_MEM | TTM_PL_MASK_CACHING)
+
+/*
+ * Access flags to be used for CPU- and GPU- mappings.
+ * The idea is that the TTM synchronization mechanism will
+ * allow concurrent READ access and exclusive write access.
+ * Currently GPU- and CPU accesses are exclusive.
+ */
+
+#define TTM_ACCESS_READ         (1 << 0)
+#define TTM_ACCESS_WRITE        (1 << 1)
+
+#endif
-- 
1.6.2.2

