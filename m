Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYFHJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYFHJWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYFHJWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:22:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:12303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbYFHJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:22:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QLNX+C3NFWFLVWXxD9UtsIeRW6DdUsvG/911feCF2KLPn6TaFOCVE8Hw8oLSSCw8ov
         rbCZN5wQR9KpioZcmwi0y9oLnLN5F5uipCH4VrYKVKhJO3UVTT59To05p09zkLZ9NFZj
         kj/p93TAE00W190iB24sYUVZTxeP8Zdt1ygA0=
Date: Sun, 8 Jun 2008 13:21:56 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC][PATCH 1/3] Clocklib: add generic framework for managing
	clocks.
Message-ID: <20080608092156.GA11474@doriath.ww600.siemens.net>
References: <20080608091954.GA11200@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608091954.GA11200@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a generic framework that platform may choose
to support clocks api. In particular this provides
platform-independant struct clk definition, a full
implementation of clocks api and a set of functions
for registering and unregistering clocks in a safe way.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 include/linux/clocklib.h |   91 +++++++++++++
 lib/Kconfig              |    3 +
 lib/Makefile             |    1 +
 lib/clocklib.c           |  318 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 413 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/clocklib.h
 create mode 100644 lib/clocklib.c

diff --git a/include/linux/clocklib.h b/include/linux/clocklib.h
new file mode 100644
index 0000000..c1da052
--- /dev/null
+++ b/include/linux/clocklib.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2008 Dmitry Baryshkov
+ *
+ * This file is released under the GPL v2.
+ */
+#ifndef CLOCKLIB_H
+#define CLOCKLIB_H
+
+struct device;
+/*
+ * @kobj: kobject representing a clock
+ * @state: represents the state of the clock. it's -1, when the clock is locked otherwise it shows the "enable" counter
+ * @ops: a reference to implementation of operations for clock
+ * @release: deallocate all resources after last reference to this clock was removed
+ */
+struct clk {
+	const char *name;
+	struct kobject kobj;
+
+	atomic_t state;
+
+	const struct clk_ops *ops;
+	void (*release)(struct clk *clk);
+};
+
+/**
+ * struct clk_ops - generic clock management operations
+ * @can_get: checks whether passed device can get this clock
+ * @set_parent: reconfigures the clock to use specified parent
+ * @enable: enable specified clock.
+ * @disable: disable specified clock.
+ * @get_rate: obtain the current rate of a specified clock in Hz
+ * @round_rate: adjust a rate to the exact value a clock can provide and possibly apply it
+ *
+ * This structure specifies clock operations that are used to configure
+ * specific clock. All functions are called with spin lock held,
+ * so you can't do fancy things. However you can use helpers for accessing
+ * parent clocks.
+ *
+ * The enable, disable, get_rate and round_rate fields are mandatory.
+ *
+ * can_get is optional. It checks whether this particular "struct clk" is
+ * suitable for passed device. E.g. for the uniformity of the driver the
+ * PXA names all clocks "UARTCLK" and binds each of them to the particular
+ * UART device in the system. Some other platforms would like to compare
+ * the id of the device on the platform_bus with the value stored in the
+ * clock. To make this check generic, I've provided the possibility for
+ * each particular clock to define it's own way to be bound to devices.
+ */
+struct clk_ops {
+	int (*can_get)(struct clk *clk, struct device *dev);
+	int (*set_parent)(struct clk *clk, struct clk *parent);
+	int (*enable)(struct clk *clk);
+	void (*disable)(struct clk *clk);
+	unsigned long (*get_rate)(struct clk *clk);
+	long (*round_rate)(struct clk *clk, unsigned long hz, bool apply);
+};
+
+
+/*
+ * Add a clock to system. As the the struct clk embedds a kobject,
+ * in most cases you should allocate it dynamically. Allocate it
+ * from static space only if you know what you are doing.
+ */
+int clk_add(struct clk *parent, struct clk *clk);
+
+/*
+ * This unregisters the clock. However some other drivers can still
+ * reference the clk, so you have to take measures not to cause a BUG.
+ */
+void clk_unregister(struct clk *clk);
+
+
+/*
+ * Some useful helpers
+ */
+
+/*
+ * A simple clk wrapper and operations for it. This clock will be bound
+ * to the provided device.
+ */
+struct clk_devck {
+	struct clk		clk;
+	const char		*parent;
+	struct device		*dev;
+};
+extern struct clk_ops clk_devck_ops;
+
+#endif
+
+
diff --git a/lib/Kconfig b/lib/Kconfig
index 8cc8e87..f50b04a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -13,6 +13,9 @@ config GENERIC_FIND_FIRST_BIT
 config GENERIC_FIND_NEXT_BIT
 	def_bool n
 
+config CLOCKLIB
+	tristate
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 74b0cfb..c5b4cc3 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
+lib-$(CONFIG_CLOCKLIB) += clocklib.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
diff --git a/lib/clocklib.c b/lib/clocklib.c
new file mode 100644
index 0000000..bb3859a
--- /dev/null
+++ b/lib/clocklib.c
@@ -0,0 +1,318 @@
+/*
+ * lib/clocklib.c
+ *
+ * Copyright (C) 2008 Dmitry Baryshkov
+ *
+ * Generic clocks API implementation
+ *
+ * This file is released under the GPL v2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clocklib.h>
+#include <linux/kobject.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+static void clk_release(struct kobject *kobj)
+{
+	struct clk *clk = container_of(kobj, struct clk, kobj);
+
+	BUG_ON(!clk->release);
+	clk->release(clk);
+}
+
+static ssize_t clk_state_show(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				char *buf)
+{
+	struct clk *clk = container_of(kobj, struct clk, kobj);
+	int val;
+
+	smp_mb();
+	val = atomic_read(&clk->state);
+
+	return snprintf(buf, PAGE_SIZE, "%d", val);
+}
+
+static struct kobj_attribute clk_state_attr =
+	__ATTR(state, 0444, clk_state_show, NULL);
+
+static ssize_t clk_rate_show(struct kobject *kobj,
+				struct kobj_attribute *attr,
+				char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lu",
+		clk_get_rate(container_of(kobj, struct clk, kobj)));
+}
+
+static struct kobj_attribute clk_rate_attr =
+	__ATTR(rate, 0444, clk_rate_show, NULL);
+
+
+static struct attribute *clk_attrs[] = {
+	&clk_state_attr.attr,
+	&clk_rate_attr.attr,
+	NULL,
+};
+
+static struct kobj_type clk_ktype = {
+	.release = clk_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_attrs = clk_attrs,
+};
+
+static struct kset *clks_kset;
+
+static int clk_sysfs_init(void)
+{
+	clks_kset = kset_create_and_add("clocks", NULL, kernel_kobj);
+
+	if (!clks_kset)
+		return -ENOMEM;
+
+	return 0;
+}
+core_initcall(clk_sysfs_init);
+
+int clk_add(struct clk *parent, struct clk *clk)
+{
+	BUG_ON(!clk->ops);
+	BUG_ON(!clk->release);
+	BUG_ON(!clk->name);
+
+	BUG_ON(!clk->ops->enable || !clk->ops->disable ||
+			!clk->ops->get_rate || !clk->ops->round_rate);
+
+	kobject_init(&clk->kobj, &clk_ktype);
+
+	clk->kobj.kset = clks_kset;
+
+	return kobject_add(&clk->kobj, parent? &parent->kobj : NULL,
+			"%s", clk->name);
+}
+
+void clk_unregister(struct clk *clk)
+{
+	kobject_del(&clk->kobj);
+	kobject_put(&clk->kobj);
+}
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+	struct clk *parent;
+
+	spin_lock(&clks_kset->list_lock);
+
+	parent = clk->kobj.parent == &clks_kset->kobj ?
+		NULL :
+		container_of(kobject_get(clk->kobj.parent), struct clk, kobj);
+
+	spin_unlock(&clks_kset->list_lock);
+
+	return parent;
+}
+
+struct clk *clk_get(struct device *dev, const char *name)
+{
+	struct clk *clk = NULL;
+	struct clk *p;
+	struct kobject *k;
+
+	spin_lock(&clks_kset->list_lock);
+
+	list_for_each_entry(k, &clks_kset->list, entry) {
+		if (kobject_name(k) && !strcmp(kobject_name(k), name)
+				) {
+			p = container_of(kobject_get(k), struct clk, kobj);
+			if (p->ops && p->ops->can_get &&
+					p->ops->can_get(p, dev)) {
+				clk = p;
+				break;
+			}
+			kobject_put(k);
+		}
+	}
+
+	list_for_each_entry(k, &clks_kset->list, entry) {
+		if (kobject_name(k) && !strcmp(kobject_name(k), name)
+				) {
+			p = container_of(kobject_get(k), struct clk, kobj);
+			if (!p->ops || !p->ops->can_get) {
+				clk = p;
+				break;
+			}
+			kobject_put(k);
+			break;
+		}
+	}
+
+	spin_unlock(&clks_kset->list_lock);
+
+	return clk;
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	kobject_put(&clk->kobj);
+}
+EXPORT_SYMBOL(clk_put);
+
+static DECLARE_WAIT_QUEUE_HEAD(clks_enable);
+
+static int __clk_get(struct clk *clk)
+{
+	int rc = 0;
+	int state;
+
+	/* FIXME: handle the case if we are in atomic context */
+	rc = wait_event_interruptible(clks_enable,
+			(state = atomic_xchg(&clk->state, -1)) >= 0);
+	if (rc < 0)
+		return rc;
+
+	return state;
+}
+
+static void __clk_put(struct clk *clk, int state)
+{
+	atomic_xchg(&clk->state, state);
+
+	wake_up(&clks_enable);
+}
+
+int clk_enable(struct clk *clk)
+{
+	int rc = 0;
+	int state = __clk_get(clk);
+
+	if (state < 0)
+		return state;
+	else if (state == 0)
+		rc = clk->ops->enable(clk);
+
+	__clk_put(clk, state + 1);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	int state = __clk_get(clk);
+
+	if (state < 0)
+		return;
+
+	if (state == 1)
+		clk->ops->disable(clk);
+
+	__clk_put(clk, state - 1);
+
+	return;
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	int state = __clk_get(clk);
+	unsigned long hz;
+
+	if (state < 0)
+		return 0;
+
+	hz = clk->ops->get_rate(clk);
+
+	__clk_put(clk, state);
+
+	return hz;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long hz)
+{
+	int rc;
+	int state = __clk_get(clk);
+
+	if (state < 0)
+		return state;
+
+	rc = clk->ops->round_rate(clk, hz, true);
+
+	__clk_put(clk, state);
+
+	return rc < 0 ? rc : 0;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long hz)
+{
+	long rc;
+	int state = __clk_get(clk);
+
+	if (state < 0)
+		return state;
+
+	rc = clk->ops->round_rate(clk, hz, false);
+
+	__clk_put(clk, state);
+
+	return rc;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+/*
+ * Some usefull helpers
+ */
+static inline int clk_enable_parent(struct clk *clk)
+{
+	struct clk *parent = clk_get_parent(clk);
+	int rc = clk_enable(parent);
+	clk_put(parent);
+	return rc;
+}
+
+static inline void clk_disable_parent(struct clk *clk)
+{
+	struct clk *parent = clk_get_parent(clk);
+	clk_disable(parent);
+	clk_put(parent);
+}
+
+static inline unsigned long clk_get_rate_parent(struct clk *clk)
+{
+	struct clk *parent = clk_get_parent(clk);
+	unsigned long rc = clk_get_rate(parent);
+	clk_put(parent);
+	return rc;
+}
+
+static inline long clk_round_rate_parent(struct clk *clk, unsigned long hz, bool apply)
+{
+	struct clk *parent = clk_get_parent(clk);
+	long rc = apply ? clk_set_rate(parent, hz) : clk_round_rate(parent, hz);
+	clk_put(parent);
+	return rc;
+}
+
+static inline int clk_devck_can_get(struct clk *clk, struct device *dev)
+{
+	struct clk_devck *dc = container_of(clk, struct clk_devck, clk);
+
+	return dc->dev == dev;
+}
+
+struct clk_ops clk_devck_ops = {
+	.can_get = clk_devck_can_get,
+	.enable = clk_enable_parent,
+	.disable = clk_disable_parent,
+	.get_rate = clk_get_rate_parent,
+	.round_rate = clk_round_rate_parent,
+};
+EXPORT_SYMBOL(clk_devck_ops);
+
-- 
1.5.5.1


-- 
With best wishes
Dmitry

