Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZCSEMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZCSEMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZCSEMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:12:38 -0400
Received: from kroah.org ([198.145.64.141]:34750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755523AbZCSELn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:11:43 -0400
Date: Wed, 18 Mar 2009 21:08:55 -0700
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [patch 2/5] drm: Add a tracker for global objects.
Message-ID: <20090319040855.GF29249@kroah.com>
References: <20090319035834.875839585@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-add-a-tracker-for-global-objects.patch"
In-Reply-To: <20090319040809.GA29249@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[coding style issues fixed by gregkh]

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/Makefile     |    3 -
 drivers/gpu/drm/drm_drv.c    |    3 +
 drivers/gpu/drm/drm_global.c |  105 +++++++++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h           |   20 ++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -386,6 +386,8 @@ static int __init drm_core_init(void)
 
 	DRM_INFO("Initialized %s %d.%d.%d %s\n",
 		 CORE_NAME, CORE_MAJOR, CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
+	drm_global_init();
+
 	return 0;
 err_p3:
 	drm_sysfs_destroy();
@@ -399,6 +401,7 @@ err_p1:
 
 static void __exit drm_core_exit(void)
 {
+	drm_global_release();
 	remove_proc_entry("dri", NULL);
 	drm_sysfs_destroy();
 
--- /dev/null
+++ b/drivers/gpu/drm/drm_global.c
@@ -0,0 +1,105 @@
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
+#include <drmP.h>
+struct drm_global_item {
+	struct mutex mutex;
+	void *object;
+	int refcount;
+};
+
+static struct drm_global_item glob[DRM_GLOBAL_NUM];
+
+void drm_global_init(void)
+{
+	int i;
+
+	for (i = 0; i < DRM_GLOBAL_NUM; ++i) {
+		struct drm_global_item *item = &glob[i];
+		mutex_init(&item->mutex);
+		item->object = NULL;
+		item->refcount = 0;
+	}
+}
+
+void drm_global_release(void)
+{
+	int i;
+	for (i = 0; i < DRM_GLOBAL_NUM; ++i) {
+		struct drm_global_item *item = &glob[i];
+		BUG_ON(item->object != NULL);
+		BUG_ON(item->refcount != 0);
+	}
+}
+
+int drm_global_item_ref(struct drm_global_reference *ref)
+{
+	int ret;
+	struct drm_global_item *item = &glob[ref->global_type];
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
+EXPORT_SYMBOL(drm_global_item_ref);
+
+void drm_global_item_unref(struct drm_global_reference *ref)
+{
+	struct drm_global_item *item = &glob[ref->global_type];
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
+EXPORT_SYMBOL(drm_global_item_unref);
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -10,7 +10,8 @@ drm-y       :=	drm_auth.o drm_bufs.o drm
 		drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
 		drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
 		drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o \
-		drm_crtc.o drm_crtc_helper.o drm_modes.o drm_edid.o
+		drm_crtc.o drm_crtc_helper.o drm_modes.o drm_edid.o \
+		drm_global.o
 
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1405,5 +1405,25 @@ extern void *drm_calloc(size_t nmemb, si
 
 /*@}*/
 
+enum drm_global_types {
+	DRM_GLOBAL_TTM_MEM = 0,
+	DRM_GLOBAL_TTM_BO,
+	DRM_GLOBAL_TTM_OBJECT,
+	DRM_GLOBAL_NUM
+};
+
+struct drm_global_reference {
+	enum drm_global_types global_type;
+	size_t size;
+	void *object;
+	int (*init) (struct drm_global_reference *);
+	void (*release) (struct drm_global_reference *);
+};
+
+extern void drm_global_init(void);
+extern void drm_global_release(void);
+extern int drm_global_item_ref(struct drm_global_reference *ref);
+extern void drm_global_item_unref(struct drm_global_reference *ref);
+
 #endif				/* __KERNEL__ */
 #endif

