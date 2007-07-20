Return-Path: <linux-kernel-owner+w=401wt.eu-S938567AbXGTAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938567AbXGTAsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934171AbXGTApq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:45:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:12938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761143AbXGTApo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:45:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,559,1175497200"; 
   d="scan'208";a="252605968"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH 6/7] DCA: Add Direct Cache Access driver
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, jeff@garzik.org, dan.j.williams@intel.com,
       christopher.leech@intel.com, peter.p.waskiewicz.jr@intel.com
Date: Thu, 19 Jul 2007 17:45:17 -0700
Message-ID: <20070720004517.13564.19649.stgit@localhost.localdomain>
In-Reply-To: <20070720004403.13564.14294.stgit@localhost.localdomain>
References: <20070720004403.13564.14294.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Direct Cache Access (DCA) is a method for warming the CPU cache before data
is used, with the intent of lessening the impact of cache misses.  This
patch adds a manager and interface for matching up client requests for DCA
services with devices that offer DCA services.

In order to use DCA, a module must do bus writes with the appropriate tag
bits set to trigger a cache read for a specific CPU.  However, different
CPUs and chipsets can require different sets of tag bits, and the methods
for determining the correct bits may be simple hardcoding or may be a
hardware specific magic incantation.  This interface is a way for DCA
clients to find the correct tag bits for the targeted CPU without needing
to know the specifics.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/Kconfig         |    2 +
 drivers/Makefile        |    1 
 drivers/dca/Kconfig     |   11 +++
 drivers/dca/Makefile    |    2 +
 drivers/dca/dca-core.c  |  170 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/dca/dca-sysfs.c |   88 ++++++++++++++++++++++++
 include/linux/dca.h     |   47 +++++++++++++
 7 files changed, 321 insertions(+), 0 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 7916f4b..98b7e10 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -80,6 +80,8 @@ source "drivers/rtc/Kconfig"
 
 source "drivers/dma/Kconfig"
 
+source "drivers/dca/Kconfig"
+
 source "drivers/auxdisplay/Kconfig"
 
 source "drivers/kvm/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 6d9d7fa..4e03de6 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -82,5 +82,6 @@ obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
+obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
diff --git a/drivers/dca/Kconfig b/drivers/dca/Kconfig
new file mode 100644
index 0000000..d901615
--- /dev/null
+++ b/drivers/dca/Kconfig
@@ -0,0 +1,11 @@
+#
+# DCA server configuration
+#
+
+config DCA
+	tristate "DCA support for clients and providers"
+	---help---
+          This is a server to help modules that want to use Direct Cache
+	  Access to find DCA providers that will supply correct CPU tags.
+	default m
+
diff --git a/drivers/dca/Makefile b/drivers/dca/Makefile
new file mode 100644
index 0000000..b2db56b
--- /dev/null
+++ b/drivers/dca/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_DCA) += dca.o
+dca-objs := dca-core.o dca-sysfs.o
diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
new file mode 100644
index 0000000..864f469
--- /dev/null
+++ b/drivers/dca/dca-core.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
+ */
+
+/*
+ * This driver supports an interface for DCA clients and providers to meet.
+ */
+
+#include <linux/kernel.h>
+#include <linux/notifier.h>
+#include <linux/device.h>
+#include <linux/dca.h>
+
+MODULE_LICENSE("GPL");
+
+/* For now we're assuming a single, global, DCA provider for the system. */
+
+static spinlock_t dca_lock;
+
+struct dca_provider *global_dca = NULL;
+
+int dca_add_requester(struct device *dev)
+{
+	int err, slot;
+
+	if (!global_dca)
+		return -ENODEV;
+
+	spin_lock(&dca_lock);
+	slot = global_dca->ops->add_requester(global_dca, dev);
+	spin_unlock(&dca_lock);
+	if (slot < 0)
+		return slot;
+
+	err = dca_sysfs_add_req(global_dca, dev, slot);
+	if (err) {
+		spin_lock(&dca_lock);
+		global_dca->ops->remove_requester(global_dca, dev);
+		spin_unlock(&dca_lock);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dca_add_requester);
+
+int dca_remove_requester(struct device *dev)
+{
+	int slot;
+	if (!global_dca)
+		return -ENODEV;
+
+	spin_lock(&dca_lock);
+	slot = global_dca->ops->remove_requester(global_dca, dev);
+	spin_unlock(&dca_lock);
+	if (slot < 0)
+		return slot;
+
+	dca_sysfs_remove_req(global_dca, slot);
+	return 0;
+}
+EXPORT_SYMBOL(dca_remove_requester);
+
+u8 dca_get_tag(int cpu)
+{
+	if (!global_dca)
+		return -ENODEV;
+	return global_dca->ops->get_tag(global_dca, cpu);
+}
+EXPORT_SYMBOL(dca_get_tag);
+
+struct dca_provider *alloc_dca_provider(struct dca_ops *ops, int priv_size)
+{
+	struct dca_provider *dca;
+	int alloc_size;
+
+	alloc_size = (sizeof(*dca) + priv_size);
+	dca = kzalloc(alloc_size, GFP_KERNEL);
+	if (!dca)
+		return NULL;
+	dca->ops = ops;
+
+	return dca;
+}
+EXPORT_SYMBOL(alloc_dca_provider);
+
+void free_dca_provider(struct dca_provider *dca)
+{
+	kfree(dca);
+}
+EXPORT_SYMBOL(free_dca_provider);
+
+static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
+
+int register_dca_provider(struct dca_provider *dca, struct device *dev)
+{
+	int err;
+
+	if (global_dca)
+		return -EEXIST;
+	err = dca_sysfs_add_provider(dca, dev);
+	if (err)
+		return err;
+	global_dca = dca;
+	blocking_notifier_call_chain(&dca_provider_chain,
+				     DCA_PROVIDER_ADD, NULL);
+	return 0;
+}
+EXPORT_SYMBOL(register_dca_provider);
+
+void unregister_dca_provider(struct dca_provider *dca)
+{
+	if (!global_dca)
+		return;
+	blocking_notifier_call_chain(&dca_provider_chain,
+				     DCA_PROVIDER_REMOVE, NULL);
+	global_dca = NULL;
+	dca_sysfs_remove_provider(dca);
+}
+EXPORT_SYMBOL(unregister_dca_provider);
+
+void dca_register_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&dca_provider_chain, nb);
+}
+EXPORT_SYMBOL(dca_register_notify);
+
+void dca_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&dca_provider_chain, nb);
+}
+EXPORT_SYMBOL(dca_unregister_notify);
+
+static int __init dca_init(void)
+{
+	int err;
+
+	spin_lock_init(&dca_lock);
+
+	err = dca_sysfs_init();
+	if (err)
+		return err;
+	return 0;
+}
+
+static void __exit dca_exit(void)
+{
+	dca_sysfs_exit();
+}
+
+module_init(dca_init);
+module_exit(dca_exit);
+
diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
new file mode 100644
index 0000000..24a263b
--- /dev/null
+++ b/drivers/dca/dca-sysfs.c
@@ -0,0 +1,88 @@
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/kdev_t.h>
+#include <linux/err.h>
+#include <linux/dca.h>
+
+static struct class *dca_class;
+static struct idr dca_idr;
+static spinlock_t dca_idr_lock;
+
+int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
+{
+	struct class_device *cd;
+
+	cd = class_device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
+				 dev, "requester%d", slot);
+	if (IS_ERR(cd))
+		return PTR_ERR(cd);
+	return 0;
+}
+
+void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
+{
+	class_device_destroy(dca_class, MKDEV(0, slot + 1));
+}
+
+int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
+{
+	struct class_device *cd;
+	int err = 0;
+
+idr_try_again:
+	if (!idr_pre_get(&dca_idr, GFP_KERNEL))
+		return -ENOMEM;
+	spin_lock(&dca_idr_lock);
+	err = idr_get_new(&dca_idr, dca, &dca->id);
+	spin_unlock(&dca_idr_lock);
+	switch (err) {
+	case 0:
+		break;
+	case -EAGAIN:
+		goto idr_try_again;
+	default:
+		return err;
+	}
+
+	cd = class_device_create(dca_class, NULL, MKDEV(0, 0),
+				 dev, "dca%d", dca->id);
+	if (IS_ERR(cd)) {
+		spin_lock(&dca_idr_lock);
+		idr_remove(&dca_idr, dca->id);
+		spin_unlock(&dca_idr_lock);
+		return PTR_ERR(cd);
+	}
+	dca->cd = cd;
+	return 0;
+}
+
+void dca_sysfs_remove_provider(struct dca_provider *dca)
+{
+	class_device_unregister(dca->cd);
+	dca->cd = NULL;
+	spin_lock(&dca_idr_lock);
+	idr_remove(&dca_idr, dca->id);
+	spin_unlock(&dca_idr_lock);
+}
+
+int __init dca_sysfs_init(void)
+{
+	idr_init(&dca_idr);
+	spin_lock_init(&dca_idr_lock);
+
+	dca_class = class_create(THIS_MODULE, "dca");
+	if (IS_ERR(dca_class)) {
+		idr_destroy(&dca_idr);
+		return PTR_ERR(dca_class);
+	}
+	return 0;
+}
+
+void __exit dca_sysfs_exit(void)
+{
+	class_destroy(dca_class);
+	idr_destroy(&dca_idr);
+}
+
diff --git a/include/linux/dca.h b/include/linux/dca.h
new file mode 100644
index 0000000..83eaecc
--- /dev/null
+++ b/include/linux/dca.h
@@ -0,0 +1,47 @@
+#ifndef DCA_H
+#define DCA_H
+/* DCA Provider API */
+
+/* DCA Notifier Interface */
+void dca_register_notify(struct notifier_block *nb);
+void dca_unregister_notify(struct notifier_block *nb);
+
+#define DCA_PROVIDER_ADD     0x0001
+#define DCA_PROVIDER_REMOVE  0x0002
+
+struct dca_provider {
+	struct dca_ops		*ops;
+	struct class_device 	*cd;
+	int			 id;
+};
+
+struct dca_ops {
+	int	(*add_requester)    (struct dca_provider *, struct device *);
+	int	(*remove_requester) (struct dca_provider *, struct device *);
+	u8	(*get_tag)	    (struct dca_provider *, int cpu);
+};
+
+struct dca_provider *alloc_dca_provider(struct dca_ops *ops, int priv_size);
+void free_dca_provider(struct dca_provider *dca);
+int register_dca_provider(struct dca_provider *dca, struct device *dev);
+void unregister_dca_provider(struct dca_provider *dca);
+
+static inline void *dca_priv(struct dca_provider *dca)
+{
+	return (void *)dca + sizeof(struct dca_provider);
+}
+
+/* Requester API */
+int dca_add_requester(struct device *dev);
+int dca_remove_requester(struct device *dev);
+u8 dca_get_tag(int cpu);
+
+/* internal stuff */
+int __init dca_sysfs_init(void);
+void __exit dca_sysfs_exit(void);
+int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev);
+void dca_sysfs_remove_provider(struct dca_provider *dca);
+int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot);
+void dca_sysfs_remove_req(struct dca_provider *dca, int slot);
+
+#endif /* DCA_H */
