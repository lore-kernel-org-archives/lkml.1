Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZLFUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZLFUqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbZLFUqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:35 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60542 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757621AbZLFUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:26 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 1/5] drm/ttm: Add user-space objects.
Date: Sun,  6 Dec 2009 21:46:24 +0100
Message-Id: <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add objects needed for user-space to maintain reference counts on ttm objects.
This is used by the vmwgfx driver which allows user-space to maintain
map-counts on dma buffers, lock-counts on the ttm lock and ref-counts on
gpu surfaces, gpu contexts and dma buffer.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/Makefile     |    3 +-
 drivers/gpu/drm/ttm/ttm_object.c |  452 ++++++++++++++++++++++++++++++++++++++
 include/drm/ttm/ttm_object.h     |  267 ++++++++++++++++++++++
 3 files changed, 721 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_object.c
 create mode 100644 include/drm/ttm/ttm_object.h

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index b0a9de7..a9cc9f8 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -3,6 +3,7 @@
 
 ccflags-y := -Iinclude/drm
 ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
-	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o
+	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o \
+	ttm_object.o
 
 obj-$(CONFIG_DRM_TTM) += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
new file mode 100644
index 0000000..1099aba
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -0,0 +1,452 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
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
+/** @file ttm_ref_object.c
+ *
+ * Base- and reference object implementation for the various
+ * ttm objects. Implements reference counting, minimal security checks
+ * and release on file close.
+ */
+
+/**
+ * struct ttm_object_file
+ *
+ * @tdev: Pointer to the ttm_object_device.
+ *
+ * @lock: Lock that protects the ref_list list and the
+ * ref_hash hash tables.
+ *
+ * @ref_list: List of ttm_ref_objects to be destroyed at
+ * file release.
+ *
+ * @ref_hash: Hash tables of ref objects, one per ttm_ref_type,
+ * for fast lookup of ref objects given a base object.
+ */
+
+#include "ttm/ttm_object.h"
+#include "ttm/ttm_module.h"
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <asm/atomic.h>
+
+struct ttm_object_file {
+	struct ttm_object_device *tdev;
+	rwlock_t lock;
+	struct list_head ref_list;
+	struct drm_open_hash ref_hash[TTM_REF_NUM];
+	struct kref refcount;
+};
+
+/**
+ * struct ttm_object_device
+ *
+ * @object_lock: lock that protects the object_hash hash table.
+ *
+ * @object_hash: hash table for fast lookup of object global names.
+ *
+ * @object_count: Per device object count.
+ *
+ * This is the per-device data structure needed for ttm object management.
+ */
+
+struct ttm_object_device {
+	rwlock_t object_lock;
+	struct drm_open_hash object_hash;
+	atomic_t object_count;
+	struct ttm_mem_global *mem_glob;
+};
+
+/**
+ * struct ttm_ref_object
+ *
+ * @hash: Hash entry for the per-file object reference hash.
+ *
+ * @head: List entry for the per-file list of ref-objects.
+ *
+ * @kref: Ref count.
+ *
+ * @obj: Base object this ref object is referencing.
+ *
+ * @ref_type: Type of ref object.
+ *
+ * This is similar to an idr object, but it also has a hash table entry
+ * that allows lookup with a pointer to the referenced object as a key. In
+ * that way, one can easily detect whether a base object is referenced by
+ * a particular ttm_object_file. It also carries a ref count to avoid creating
+ * multiple ref objects if a ttm_object_file references the same base
+ * object more than once.
+ */
+
+struct ttm_ref_object {
+	struct drm_hash_item hash;
+	struct list_head head;
+	struct kref kref;
+	struct ttm_base_object *obj;
+	enum ttm_ref_type ref_type;
+	struct ttm_object_file *tfile;
+};
+
+static inline struct ttm_object_file *
+ttm_object_file_ref(struct ttm_object_file *tfile)
+{
+	kref_get(&tfile->refcount);
+	return tfile;
+}
+
+static void ttm_object_file_destroy(struct kref *kref)
+{
+	struct ttm_object_file *tfile =
+		container_of(kref, struct ttm_object_file, refcount);
+
+	kfree(tfile);
+}
+
+
+static inline void ttm_object_file_unref(struct ttm_object_file **p_tfile)
+{
+	struct ttm_object_file *tfile = *p_tfile;
+
+	*p_tfile = NULL;
+	kref_put(&tfile->refcount, ttm_object_file_destroy);
+}
+
+
+int ttm_base_object_init(struct ttm_object_file *tfile,
+			 struct ttm_base_object *base,
+			 bool shareable,
+			 enum ttm_object_type object_type,
+			 void (*refcount_release) (struct ttm_base_object **),
+			 void (*ref_obj_release) (struct ttm_base_object *,
+						  enum ttm_ref_type ref_type))
+{
+	struct ttm_object_device *tdev = tfile->tdev;
+	int ret;
+
+	base->shareable = shareable;
+	base->tfile = ttm_object_file_ref(tfile);
+	base->refcount_release = refcount_release;
+	base->ref_obj_release = ref_obj_release;
+	base->object_type = object_type;
+	write_lock(&tdev->object_lock);
+	kref_init(&base->refcount);
+	ret = drm_ht_just_insert_please(&tdev->object_hash,
+					&base->hash,
+					(unsigned long)base, 31, 0, 0);
+	write_unlock(&tdev->object_lock);
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	ret = ttm_ref_object_add(tfile, base, TTM_REF_USAGE, NULL);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	ttm_base_object_unref(&base);
+
+	return 0;
+out_err1:
+	(void)drm_ht_remove_item(&tdev->object_hash, &base->hash);
+out_err0:
+	return ret;
+}
+EXPORT_SYMBOL(ttm_base_object_init);
+
+static void ttm_release_base(struct kref *kref)
+{
+	struct ttm_base_object *base =
+	    container_of(kref, struct ttm_base_object, refcount);
+	struct ttm_object_device *tdev = base->tfile->tdev;
+
+	(void)drm_ht_remove_item(&tdev->object_hash, &base->hash);
+	write_unlock(&tdev->object_lock);
+	if (base->refcount_release) {
+		ttm_object_file_unref(&base->tfile);
+		base->refcount_release(&base);
+	}
+	write_lock(&tdev->object_lock);
+}
+
+void ttm_base_object_unref(struct ttm_base_object **p_base)
+{
+	struct ttm_base_object *base = *p_base;
+	struct ttm_object_device *tdev = base->tfile->tdev;
+
+	*p_base = NULL;
+
+	/*
+	 * Need to take the lock here to avoid racing with
+	 * users trying to look up the object.
+	 */
+
+	write_lock(&tdev->object_lock);
+	(void)kref_put(&base->refcount, &ttm_release_base);
+	write_unlock(&tdev->object_lock);
+}
+EXPORT_SYMBOL(ttm_base_object_unref);
+
+struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file *tfile,
+					       uint32_t key)
+{
+	struct ttm_object_device *tdev = tfile->tdev;
+	struct ttm_base_object *base;
+	struct drm_hash_item *hash;
+	int ret;
+
+	read_lock(&tdev->object_lock);
+	ret = drm_ht_find_item(&tdev->object_hash, key, &hash);
+
+	if (likely(ret == 0)) {
+		base = drm_hash_entry(hash, struct ttm_base_object, hash);
+		kref_get(&base->refcount);
+	}
+	read_unlock(&tdev->object_lock);
+
+	if (unlikely(ret != 0))
+		return NULL;
+
+	if (tfile != base->tfile && !base->shareable) {
+		printk(KERN_ERR TTM_PFX
+		       "Attempted access of non-shareable object.\n");
+		ttm_base_object_unref(&base);
+		return NULL;
+	}
+
+	return base;
+}
+EXPORT_SYMBOL(ttm_base_object_lookup);
+
+int ttm_ref_object_add(struct ttm_object_file *tfile,
+		       struct ttm_base_object *base,
+		       enum ttm_ref_type ref_type, bool *existed)
+{
+	struct drm_open_hash *ht = &tfile->ref_hash[ref_type];
+	struct ttm_ref_object *ref;
+	struct drm_hash_item *hash;
+	struct ttm_mem_global *mem_glob = tfile->tdev->mem_glob;
+	int ret = -EINVAL;
+
+	if (existed != NULL)
+		*existed = true;
+
+	while (ret == -EINVAL) {
+		read_lock(&tfile->lock);
+		ret = drm_ht_find_item(ht, base->hash.key, &hash);
+
+		if (ret == 0) {
+			ref = drm_hash_entry(hash, struct ttm_ref_object, hash);
+			kref_get(&ref->kref);
+			read_unlock(&tfile->lock);
+			break;
+		}
+
+		read_unlock(&tfile->lock);
+		ret = ttm_mem_global_alloc(mem_glob, sizeof(*ref),
+					   false, false);
+		if (unlikely(ret != 0))
+			return ret;
+		ref = kmalloc(sizeof(*ref), GFP_KERNEL);
+		if (unlikely(ref == NULL)) {
+			ttm_mem_global_free(mem_glob, sizeof(*ref));
+			return -ENOMEM;
+		}
+
+		ref->hash.key = base->hash.key;
+		ref->obj = base;
+		ref->tfile = tfile;
+		ref->ref_type = ref_type;
+		kref_init(&ref->kref);
+
+		write_lock(&tfile->lock);
+		ret = drm_ht_insert_item(ht, &ref->hash);
+
+		if (likely(ret == 0)) {
+			list_add_tail(&ref->head, &tfile->ref_list);
+			kref_get(&base->refcount);
+			write_unlock(&tfile->lock);
+			if (existed != NULL)
+				*existed = false;
+			break;
+		}
+
+		write_unlock(&tfile->lock);
+		BUG_ON(ret != -EINVAL);
+
+		ttm_mem_global_free(mem_glob, sizeof(*ref));
+		kfree(ref);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ttm_ref_object_add);
+
+static void ttm_ref_object_release(struct kref *kref)
+{
+	struct ttm_ref_object *ref =
+	    container_of(kref, struct ttm_ref_object, kref);
+	struct ttm_base_object *base = ref->obj;
+	struct ttm_object_file *tfile = ref->tfile;
+	struct drm_open_hash *ht;
+	struct ttm_mem_global *mem_glob = tfile->tdev->mem_glob;
+
+	ht = &tfile->ref_hash[ref->ref_type];
+	(void)drm_ht_remove_item(ht, &ref->hash);
+	list_del(&ref->head);
+	write_unlock(&tfile->lock);
+
+	if (ref->ref_type != TTM_REF_USAGE && base->ref_obj_release)
+		base->ref_obj_release(base, ref->ref_type);
+
+	ttm_base_object_unref(&ref->obj);
+	ttm_mem_global_free(mem_glob, sizeof(*ref));
+	kfree(ref);
+	write_lock(&tfile->lock);
+}
+
+int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
+			      unsigned long key, enum ttm_ref_type ref_type)
+{
+	struct drm_open_hash *ht = &tfile->ref_hash[ref_type];
+	struct ttm_ref_object *ref;
+	struct drm_hash_item *hash;
+	int ret;
+
+	write_lock(&tfile->lock);
+	ret = drm_ht_find_item(ht, key, &hash);
+	if (unlikely(ret != 0)) {
+		write_unlock(&tfile->lock);
+		return -EINVAL;
+	}
+	ref = drm_hash_entry(hash, struct ttm_ref_object, hash);
+	kref_put(&ref->kref, ttm_ref_object_release);
+	write_unlock(&tfile->lock);
+	return 0;
+}
+EXPORT_SYMBOL(ttm_ref_object_base_unref);
+
+void ttm_object_file_release(struct ttm_object_file **p_tfile)
+{
+	struct ttm_ref_object *ref;
+	struct list_head *list;
+	unsigned int i;
+	struct ttm_object_file *tfile = *p_tfile;
+
+	*p_tfile = NULL;
+	write_lock(&tfile->lock);
+
+	/*
+	 * Since we release the lock within the loop, we have to
+	 * restart it from the beginning each time.
+	 */
+
+	while (!list_empty(&tfile->ref_list)) {
+		list = tfile->ref_list.next;
+		ref = list_entry(list, struct ttm_ref_object, head);
+		ttm_ref_object_release(&ref->kref);
+	}
+
+	for (i = 0; i < TTM_REF_NUM; ++i)
+		drm_ht_remove(&tfile->ref_hash[i]);
+
+	write_unlock(&tfile->lock);
+	ttm_object_file_unref(&tfile);
+}
+EXPORT_SYMBOL(ttm_object_file_release);
+
+struct ttm_object_file *ttm_object_file_init(struct ttm_object_device *tdev,
+					     unsigned int hash_order)
+{
+	struct ttm_object_file *tfile = kmalloc(sizeof(*tfile), GFP_KERNEL);
+	unsigned int i;
+	unsigned int j = 0;
+	int ret;
+
+	if (unlikely(tfile == NULL))
+		return NULL;
+
+	rwlock_init(&tfile->lock);
+	tfile->tdev = tdev;
+	kref_init(&tfile->refcount);
+	INIT_LIST_HEAD(&tfile->ref_list);
+
+	for (i = 0; i < TTM_REF_NUM; ++i) {
+		ret = drm_ht_create(&tfile->ref_hash[i], hash_order);
+		if (ret) {
+			j = i;
+			goto out_err;
+		}
+	}
+
+	return tfile;
+out_err:
+	for (i = 0; i < j; ++i)
+		drm_ht_remove(&tfile->ref_hash[i]);
+
+	kfree(tfile);
+
+	return NULL;
+}
+EXPORT_SYMBOL(ttm_object_file_init);
+
+struct ttm_object_device *ttm_object_device_init(struct ttm_mem_global
+						 *mem_glob,
+						 unsigned int hash_order)
+{
+	struct ttm_object_device *tdev = kmalloc(sizeof(*tdev), GFP_KERNEL);
+	int ret;
+
+	if (unlikely(tdev == NULL))
+		return NULL;
+
+	tdev->mem_glob = mem_glob;
+	rwlock_init(&tdev->object_lock);
+	atomic_set(&tdev->object_count, 0);
+	ret = drm_ht_create(&tdev->object_hash, hash_order);
+
+	if (likely(ret == 0))
+		return tdev;
+
+	kfree(tdev);
+	return NULL;
+}
+EXPORT_SYMBOL(ttm_object_device_init);
+
+void ttm_object_device_release(struct ttm_object_device **p_tdev)
+{
+	struct ttm_object_device *tdev = *p_tdev;
+
+	*p_tdev = NULL;
+
+	write_lock(&tdev->object_lock);
+	drm_ht_remove(&tdev->object_hash);
+	write_unlock(&tdev->object_lock);
+
+	kfree(tdev);
+}
+EXPORT_SYMBOL(ttm_object_device_release);
diff --git a/include/drm/ttm/ttm_object.h b/include/drm/ttm/ttm_object.h
new file mode 100644
index 0000000..703ca4d
--- /dev/null
+++ b/include/drm/ttm/ttm_object.h
@@ -0,0 +1,267 @@
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
+/** @file ttm_object.h
+ *
+ * Base- and reference object implementation for the various
+ * ttm objects. Implements reference counting, minimal security checks
+ * and release on file close.
+ */
+
+#ifndef _TTM_OBJECT_H_
+#define _TTM_OBJECT_H_
+
+#include <linux/list.h>
+#include "drm_hashtab.h"
+#include <linux/kref.h>
+#include <ttm/ttm_memory.h>
+
+/**
+ * enum ttm_ref_type
+ *
+ * Describes what type of reference a ref object holds.
+ *
+ * TTM_REF_USAGE is a simple refcount on a base object.
+ *
+ * TTM_REF_SYNCCPU_READ is a SYNCCPU_READ reference on a
+ * buffer object.
+ *
+ * TTM_REF_SYNCCPU_WRITE is a SYNCCPU_WRITE reference on a
+ * buffer object.
+ *
+ */
+
+enum ttm_ref_type {
+	TTM_REF_USAGE,
+	TTM_REF_SYNCCPU_READ,
+	TTM_REF_SYNCCPU_WRITE,
+	TTM_REF_NUM
+};
+
+/**
+ * enum ttm_object_type
+ *
+ * One entry per ttm object type.
+ * Device-specific types should use the
+ * ttm_driver_typex types.
+ */
+
+enum ttm_object_type {
+	ttm_fence_type,
+	ttm_buffer_type,
+	ttm_lock_type,
+	ttm_driver_type0 = 256,
+	ttm_driver_type1
+};
+
+struct ttm_object_file;
+struct ttm_object_device;
+
+/**
+ * struct ttm_base_object
+ *
+ * @hash: hash entry for the per-device object hash.
+ * @type: derived type this object is base class for.
+ * @shareable: Other ttm_object_files can access this object.
+ *
+ * @tfile: Pointer to ttm_object_file of the creator.
+ * NULL if the object was not created by a user request.
+ * (kernel object).
+ *
+ * @refcount: Number of references to this object, not
+ * including the hash entry. A reference to a base object can
+ * only be held by a ref object.
+ *
+ * @refcount_release: A function to be called when there are
+ * no more references to this object. This function should
+ * destroy the object (or make sure destruction eventually happens),
+ * and when it is called, the object has
+ * already been taken out of the per-device hash. The parameter
+ * "base" should be set to NULL by the function.
+ *
+ * @ref_obj_release: A function to be called when a reference object
+ * with another ttm_ref_type than TTM_REF_USAGE is deleted.
+ * this function may, for example, release a lock held by a user-space
+ * process.
+ *
+ * This struct is intended to be used as a base struct for objects that
+ * are visible to user-space. It provides a global name, race-safe
+ * access and refcounting, minimal access contol and hooks for unref actions.
+ */
+
+struct ttm_base_object {
+	struct drm_hash_item hash;
+	enum ttm_object_type object_type;
+	bool shareable;
+	struct ttm_object_file *tfile;
+	struct kref refcount;
+	void (*refcount_release) (struct ttm_base_object **base);
+	void (*ref_obj_release) (struct ttm_base_object *base,
+				 enum ttm_ref_type ref_type);
+};
+
+/**
+ * ttm_base_object_init
+ *
+ * @tfile: Pointer to a struct ttm_object_file.
+ * @base: The struct ttm_base_object to initialize.
+ * @shareable: This object is shareable with other applcations.
+ * (different @tfile pointers.)
+ * @type: The object type.
+ * @refcount_release: See the struct ttm_base_object description.
+ * @ref_obj_release: See the struct ttm_base_object description.
+ *
+ * Initializes a struct ttm_base_object.
+ */
+
+extern int ttm_base_object_init(struct ttm_object_file *tfile,
+				struct ttm_base_object *base,
+				bool shareable,
+				enum ttm_object_type type,
+				void (*refcount_release) (struct ttm_base_object
+							  **),
+				void (*ref_obj_release) (struct ttm_base_object
+							 *,
+							 enum ttm_ref_type
+							 ref_type));
+
+/**
+ * ttm_base_object_lookup
+ *
+ * @tfile: Pointer to a struct ttm_object_file.
+ * @key: Hash key
+ *
+ * Looks up a struct ttm_base_object with the key @key.
+ * Also verifies that the object is visible to the application, by
+ * comparing the @tfile argument and checking the object shareable flag.
+ */
+
+extern struct ttm_base_object *ttm_base_object_lookup(struct ttm_object_file
+						      *tfile, uint32_t key);
+
+/**
+ * ttm_base_object_unref
+ *
+ * @p_base: Pointer to a pointer referncing a struct ttm_base_object.
+ *
+ * Decrements the base object refcount and clears the pointer pointed to by
+ * p_base.
+ */
+
+extern void ttm_base_object_unref(struct ttm_base_object **p_base);
+
+/**
+ * ttm_ref_object_add.
+ *
+ * @tfile: A struct ttm_object_file representing the application owning the
+ * ref_object.
+ * @base: The base object to reference.
+ * @ref_type: The type of reference.
+ * @existed: Upon completion, indicates that an identical reference object
+ * already existed, and the refcount was upped on that object instead.
+ *
+ * Adding a ref object to a base object is basically like referencing the
+ * base object, but a user-space application holds the reference. When the
+ * file corresponding to @tfile is closed, all its reference objects are
+ * deleted. A reference object can have different types depending on what
+ * it's intended for. It can be refcounting to prevent object destruction,
+ * When user-space takes a lock, it can add a ref object to that lock to
+ * make sure the lock is released if the application dies. A ref object
+ * will hold a single reference on a base object.
+ */
+extern int ttm_ref_object_add(struct ttm_object_file *tfile,
+			      struct ttm_base_object *base,
+			      enum ttm_ref_type ref_type, bool *existed);
+/**
+ * ttm_ref_object_base_unref
+ *
+ * @key: Key representing the base object.
+ * @ref_type: Ref type of the ref object to be dereferenced.
+ *
+ * Unreference a ref object with type @ref_type
+ * on the base object identified by @key. If there are no duplicate
+ * references, the ref object will be destroyed and the base object
+ * will be unreferenced.
+ */
+extern int ttm_ref_object_base_unref(struct ttm_object_file *tfile,
+				     unsigned long key,
+				     enum ttm_ref_type ref_type);
+
+/**
+ * ttm_object_file_init - initialize a struct ttm_object file
+ *
+ * @tdev: A struct ttm_object device this file is initialized on.
+ * @hash_order: Order of the hash table used to hold the reference objects.
+ *
+ * This is typically called by the file_ops::open function.
+ */
+
+extern struct ttm_object_file *ttm_object_file_init(struct ttm_object_device
+						    *tdev,
+						    unsigned int hash_order);
+
+/**
+ * ttm_object_file_release - release data held by a ttm_object_file
+ *
+ * @p_tfile: Pointer to pointer to the ttm_object_file object to release.
+ * *p_tfile will be set to NULL by this function.
+ *
+ * Releases all data associated by a ttm_object_file.
+ * Typically called from file_ops::release. The caller must
+ * ensure that there are no concurrent users of tfile.
+ */
+
+extern void ttm_object_file_release(struct ttm_object_file **p_tfile);
+
+/**
+ * ttm_object device init - initialize a struct ttm_object_device
+ *
+ * @hash_order: Order of hash table used to hash the base objects.
+ *
+ * This function is typically called on device initialization to prepare
+ * data structures needed for ttm base and ref objects.
+ */
+
+extern struct ttm_object_device *ttm_object_device_init
+    (struct ttm_mem_global *mem_glob, unsigned int hash_order);
+
+/**
+ * ttm_object_device_release - release data held by a ttm_object_device
+ *
+ * @p_tdev: Pointer to pointer to the ttm_object_device object to release.
+ * *p_tdev will be set to NULL by this function.
+ *
+ * Releases all data associated by a ttm_object_device.
+ * Typically called from driver::unload before the destruction of the
+ * device private data structure.
+ */
+
+extern void ttm_object_device_release(struct ttm_object_device **p_tdev);
+
+#endif
-- 
1.5.3.2

