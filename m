Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbZAMXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbZAMXl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZAMXk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:40:27 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:26100 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760451AbZAMXkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:40:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=dEVn4lXfLCOL7wTT/gLc/2yiLIqa+tX42acVx+opjUjuZabjoX7zUQPHRJJeFhDBsk
         TVZASsFaSZjYMTcGjMy6oaci2ar0/eRsgKmt9so2NV9pyapTgPbevufui7MMt5nsUx1j
         euM75IYaHXL0CBbj30yBVGe7sN4Uq8s51nICE=
From: Nelson <arhuaco@freaks-unidos.net>
Subject: [PATCH 5/5] Add linear filter
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, andy@openmoko.com
Date: Tue, 13 Jan 2009 18:40:12 -0500
Message-ID: <20090113234012.26361.46152.stgit@fugue.noexisteestedominiotanlargo.biz>
In-Reply-To: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Castillo <arhuaco@freaks-unidos.net>

* Linearly scale touchscreen values.
* Expose the constants for the linear transformation using sysfs.

This patch allow programs to gather data directly from
/dev/input/eventX. This is optional, you can use TSLIB
to do the linear transformation if you prefer.

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
---

 drivers/input/touchscreen/Kconfig            |    8 +
 drivers/input/touchscreen/Makefile           |    1 
 drivers/input/touchscreen/ts_filter_linear.c |  178 ++++++++++++++++++++++++++
 include/linux/ts_filter_linear.h             |   64 +++++++++
 4 files changed, 251 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/ts_filter_linear.c
 create mode 100644 include/linux/ts_filter_linear.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3f725d4..a3ed1dc 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -45,6 +45,14 @@ config TOUCHSCREEN_FILTER_MEAN
 	  Say Y here if you want to use the Mean touchscreen filter, it
 	  can further improve decent quality data by removing jitter
 
+config TOUCHSCREEN_FILTER_LINEAR
+	bool "Linear Touchscreen Filter"
+	depends on INPUT_TOUCHSCREEN && TOUCHSCREEN_FILTER
+	default Y
+	help
+	  Say Y here if you want to use the Linear touchscreen filter, it
+	  enables the use of calibration data for the touchscreen.
+
 endif
 
 config TOUCHSCREEN_ADS7846
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 84651c2..180b557 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_GROUP)	+= ts_filter_group.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_MEDIAN)	+= ts_filter_median.o
 obj-$(CONFIG_TOUCHSCREEN_FILTER_MEAN)	+= ts_filter_mean.o
+obj-$(CONFIG_TOUCHSCREEN_FILTER_LINEAR)	+= ts_filter_linear.o
diff --git a/drivers/input/touchscreen/ts_filter_linear.c b/drivers/input/touchscreen/ts_filter_linear.c
new file mode 100644
index 0000000..4803e17
--- /dev/null
+++ b/drivers/input/touchscreen/ts_filter_linear.c
@@ -0,0 +1,178 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Copyright (C) 2008 by Openmoko, Inc.
+ * Author: Nelson Castillo <arhuaco@freaks-unidos.net>
+ * All rights reserved.
+ *
+ * Linearly scale touchscreen values.
+ *
+ * Expose the TS_FILTER_LINEAR_NCONSTANTS for the linear transformation
+ * using sysfs.
+ *
+ */
+
+#include <linux/ts_filter_linear.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+
+/*
+ * sysfs functions
+ */
+
+
+static ssize_t const_attr_show(struct kobject *kobj,
+			       struct attribute *attr,
+			       char *buf)
+{
+	struct const_attribute *a = to_const_attr(attr);
+
+	return a->show(to_const_obj(kobj), a, buf);
+}
+
+static ssize_t const_attr_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf, size_t len)
+{
+	struct const_attribute *a = to_const_attr(attr);
+
+	return a->store(to_const_obj(kobj), a, buf, len);
+}
+
+static struct sysfs_ops const_sysfs_ops = {
+	.show =		const_attr_show,
+	.store =	const_attr_store,
+};
+
+static void const_release(struct kobject *kobj)
+{
+	kfree(to_const_obj(kobj)->tsfl);
+}
+
+static ssize_t const_show(struct const_obj *obj, struct const_attribute *attr,
+			  char *buf)
+{
+	int who;
+
+	sscanf(attr->attr.name, "%d", &who);
+	return sprintf(buf, "%d\n", obj->tsfl->constants[who]);
+}
+
+static ssize_t const_store(struct const_obj *obj, struct const_attribute *attr,
+			   const char *buf, size_t count)
+{
+	int who;
+
+	sscanf(attr->attr.name, "%d", &who);
+	sscanf(buf, "%d", &obj->tsfl->constants[who]);
+	return count;
+}
+
+/*
+ * filter functions
+ */
+
+static struct ts_filter *ts_filter_linear_create(struct platform_device *pdev,
+						 void *conf, int count_coords)
+{
+	struct ts_filter_linear *tsfl;
+	int i;
+	int ret;
+
+	tsfl = kzalloc(sizeof(struct ts_filter_linear), GFP_KERNEL);
+	if (!tsfl)
+		return NULL;
+
+	tsfl->config = (struct ts_filter_linear_configuration *)conf;
+	tsfl->tsf.count_coords = count_coords;
+
+	for (i = 0; i < TS_FILTER_LINEAR_NCONSTANTS; ++i) {
+		tsfl->constants[i] = tsfl->config->constants[i];
+
+		/* sysfs */
+		sprintf(tsfl->attr_names[i], "%d", i);
+		tsfl->kattrs[i].attr.name = tsfl->attr_names[i];
+		tsfl->kattrs[i].attr.mode = 0666;
+		tsfl->kattrs[i].show = const_show;
+		tsfl->kattrs[i].store = const_store;
+		tsfl->attrs[i] = &tsfl->kattrs[i].attr;
+	}
+	tsfl->attrs[i] = NULL;
+
+	tsfl->const_ktype.sysfs_ops = &const_sysfs_ops;
+	tsfl->const_ktype.release = const_release;
+	tsfl->const_ktype.default_attrs = tsfl->attrs;
+	tsfl->c_obj.tsfl = tsfl; /* kernel frees tsfl in const_release */
+
+	/* TODO: /sys/ts-calibration is not OK */
+	ret = kobject_init_and_add(&tsfl->c_obj.kobj, &tsfl->const_ktype,
+				   &pdev->dev.kobj, "calibration");
+	if (ret) {
+		kobject_put(&tsfl->c_obj.kobj);
+		return NULL;
+	}
+
+	printk(KERN_INFO"  Created Linear ts filter depth %d\n", count_coords);
+
+	return &tsfl->tsf;
+}
+
+static void ts_filter_linear_destroy(struct platform_device *pdev,
+				     struct ts_filter *tsf)
+{
+	struct ts_filter_linear *tsfl = (struct ts_filter_linear *)tsf;
+
+	/* kernel frees tsfl in const_release */
+	kobject_put(&tsfl->c_obj.kobj);
+}
+
+static void ts_filter_linear_clear(struct ts_filter *tsf)
+{
+	if (tsf->next) /* chain */
+		(tsf->next->api->clear)(tsf->next);
+}
+
+
+static void ts_filter_linear_scale(struct ts_filter *tsf, int *coords)
+{
+	struct ts_filter_linear *tsfl = (struct ts_filter_linear *)tsf;
+	int *k = tsfl->constants;
+	int c0 = coords[tsfl->config->coord0];
+	int c1 = coords[tsfl->config->coord1];
+
+	coords[tsfl->config->coord0] = (k[2] + k[0] * c0 + k[1] * c1) / k[6];
+	coords[tsfl->config->coord1] = (k[5] + k[3] * c0 + k[4] * c1) / k[6];
+
+	if (tsf->next)
+		(tsf->next->api->scale)(tsf->next, coords);
+}
+
+static int ts_filter_linear_process(struct ts_filter *tsf, int *coords)
+{
+	if (tsf->next)
+		return (tsf->next->api->process)(tsf->next, coords);
+
+	return 1;
+}
+
+struct ts_filter_api ts_filter_linear_api = {
+	.create = ts_filter_linear_create,
+	.destroy = ts_filter_linear_destroy,
+	.clear = ts_filter_linear_clear,
+	.process = ts_filter_linear_process,
+	.scale = ts_filter_linear_scale,
+};
diff --git a/include/linux/ts_filter_linear.h b/include/linux/ts_filter_linear.h
new file mode 100644
index 0000000..dab5390
--- /dev/null
+++ b/include/linux/ts_filter_linear.h
@@ -0,0 +1,64 @@
+#ifndef __TS_FILTER_LINEAR_H__
+#define __TS_FILTER_LINEAR_H__
+
+#include <linux/ts_filter.h>
+#include <linux/kobject.h>
+
+/*
+ * touchscreen linear filter.
+ *
+ * Copyright (C) 2008 by Openmoko, Inc.
+ * Author: Nelson Castillo <arhuaco@freaks-unidos.net>
+ *
+ */
+
+#define TS_FILTER_LINEAR_NCONSTANTS 7
+
+/* sysfs */
+
+struct ts_filter_linear;
+
+struct const_obj {
+	struct ts_filter_linear *tsfl;
+	struct kobject kobj;
+};
+
+#define to_const_obj(x) container_of(x, struct const_obj, kobj)
+
+struct const_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct const_obj *const, struct const_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct const_obj *const, struct const_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+#define to_const_attr(x) container_of(x, struct const_attribute, attr)
+
+/* filter configuration */
+
+struct ts_filter_linear_configuration {
+	int constants[TS_FILTER_LINEAR_NCONSTANTS];
+	int coord0;
+	int coord1;
+};
+
+/* the filter */
+
+struct ts_filter_linear {
+	struct ts_filter tsf;
+	struct ts_filter_linear_configuration *config;
+
+	int constants[TS_FILTER_LINEAR_NCONSTANTS];
+
+	/* sysfs */
+	struct const_obj c_obj;
+	struct kobj_type const_ktype;
+	struct const_attribute kattrs[TS_FILTER_LINEAR_NCONSTANTS];
+	struct attribute *attrs[TS_FILTER_LINEAR_NCONSTANTS + 1];
+	char attr_names[TS_FILTER_LINEAR_NCONSTANTS][2];
+};
+
+extern struct ts_filter_api ts_filter_linear_api;
+
+#endif

