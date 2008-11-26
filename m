Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKZIqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKZIqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYKZIma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYKZIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=RpmoVRDC5FTtxevIFd2tORcpKmE7qHIlrKS3jI6aJIPso11BC1sX+iQ9OL1x4CweSk
         cJMRGvJmQI7wLf5yKPA8QlHpjUU1F+lDTdD6eCXYQOvuJFJTcp1m25cU8zj22P376OAB
         9MsZ83Rl19qeKyw8jB7oRJs/ZcSAOQJns2eXQ=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 11/24] perfmon: sysfs interface
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:26 -0800 (PST)
Message-ID: <492d0bf2.0aec660a.5c95.ffffa917@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the sysfs interface to the perfmon subsystem. It is
used for configuration of the interface. It exposes the PMU register
mappings and various attributes of the subsystem.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_init.c
===================================================================
--- o3.orig/perfmon/perfmon_init.c	2008-10-15 15:53:09.000000000 +0200
+++ o3/perfmon/perfmon_init.c	2008-10-15 15:53:35.000000000 +0200
@@ -62,6 +62,9 @@
 	if (pfm_init_fs())
 		goto error_disable;
 
+ 	if (pfm_init_sysfs())
+ 		goto error_disable;
+
 	/*
 	 * one time, arch-specific global initialization
 	 */
Index: o3/perfmon/perfmon_sysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/perfmon/perfmon_sysfs.c	2008-10-15 15:53:35.000000000 +0200
@@ -0,0 +1,344 @@
+/*
+ * perfmon_sysfs.c: perfmon2 sysfs interface
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/kernel.h>
+#include <linux/module.h> /* for EXPORT_SYMBOL */
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+struct pfm_attribute {
+	struct attribute attr;
+	ssize_t (*show)(void *, struct pfm_attribute *attr, char *);
+	ssize_t (*store)(void *, const char *, size_t);
+};
+#define to_attr(n) container_of(n, struct pfm_attribute, attr);
+
+
+#define PFM_RO_ATTR(_name, _show) \
+	struct kobj_attribute attr_##_name = __ATTR(_name, 0444, _show, NULL)
+
+#define PFM_RW_ATTR(_name, _show, _store) 			\
+	struct kobj_attribute attr_##_name = __ATTR(_name, 0644, _show, _store)
+
+#define PFM_ROS_ATTR(_name, _show) \
+	struct pfm_attribute attr_##_name = __ATTR(_name, 0444, _show, NULL)
+
+#define is_attr_name(a, n) (!strcmp((a)->attr.name, n))
+int pfm_sysfs_add_pmu(struct pfm_pmu_config *pmu);
+
+static struct kobject *pfm_kernel_kobj;
+static struct kobject *pfm_pmu_kobj;
+
+
+static ssize_t pfm_regs_attr_show(struct kobject *kobj,
+		struct attribute *attr, char *buf)
+{
+#define to_reg(n) container_of(n, struct pfm_regmap_desc, kobj)
+	struct pfm_regmap_desc *reg = to_reg(kobj);
+	struct pfm_attribute *attribute = to_attr(attr);
+	return attribute->show ? attribute->show(reg, attribute, buf) : -EIO;
+}
+
+static struct sysfs_ops pfm_regs_sysfs_ops = {
+	.show  = pfm_regs_attr_show
+};
+
+static struct kobj_type pfm_regs_ktype = {
+	.sysfs_ops = &pfm_regs_sysfs_ops,
+};
+
+static ssize_t pfm_controls_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+
+	if (is_attr_name(attr, "version"))
+		return snprintf(buf, PAGE_SIZE, "%u.%u\n",  PFM_VERSION_MAJ, PFM_VERSION_MIN);
+
+	if (is_attr_name(attr, "task_sessions_count"))
+		return pfm_sysfs_res_show(buf, PAGE_SIZE, 0);
+
+	if (is_attr_name(attr, "debug"))
+		return snprintf(buf, PAGE_SIZE, "%d\n", pfm_controls.debug);
+
+	if (is_attr_name(attr, "task_group"))
+		return snprintf(buf, PAGE_SIZE, "%d\n", pfm_controls.task_group);
+
+	if (is_attr_name(attr, "arg_mem_max"))
+		return snprintf(buf, PAGE_SIZE, "%zu\n", pfm_controls.arg_mem_max);
+
+	return 0;
+}
+
+static ssize_t pfm_controls_store(struct kobject *kobj, struct kobj_attribute *attr,
+			 	  const char *buf, size_t count)
+{
+	size_t d;
+
+	if (sscanf(buf, "%zu", &d) != 1)
+		goto skip;
+
+	if (is_attr_name(attr, "debug"))
+		pfm_controls.debug = d;
+
+	if (is_attr_name(attr, "task_group"))
+		pfm_controls.task_group = d;
+
+	if (is_attr_name(attr, "arg_mem_max")) {
+		/*
+		 * we impose a page as the minimum.
+		 *
+		 * This limit may be smaller than the stack buffer
+		 * available and that is fine.
+		 */
+		if (d >= PAGE_SIZE)
+			pfm_controls.arg_mem_max = d;
+	}
+
+skip:
+	return count;
+}
+
+/*
+ * /sys/kernel/perfmon attributes
+ */
+static PFM_RO_ATTR(version, pfm_controls_show);
+static PFM_RO_ATTR(task_sessions_count, pfm_controls_show);
+static PFM_RW_ATTR(debug, pfm_controls_show, pfm_controls_store);
+static PFM_RW_ATTR(task_group, pfm_controls_show, pfm_controls_store);
+static PFM_RW_ATTR(arg_mem_max, pfm_controls_show, pfm_controls_store);
+
+static struct attribute *pfm_kernel_attrs[] = {
+	&attr_version.attr,
+	&attr_task_sessions_count.attr,
+	&attr_debug.attr,
+	&attr_task_group.attr,
+	&attr_arg_mem_max.attr,
+	NULL
+};
+
+static struct attribute_group pfm_kernel_attr_group = {
+	.attrs = pfm_kernel_attrs,
+};
+
+/*
+ * per-reg attributes
+ */
+static ssize_t pfm_reg_show(void *data, struct pfm_attribute *attr, char *buf)
+{
+	struct pfm_regmap_desc *reg = data;
+	int w;
+
+	reg = data;
+
+	if (is_attr_name(attr, "name"))
+		return snprintf(buf, PAGE_SIZE, "%s\n", reg->desc);
+
+	if (is_attr_name(attr, "dfl_val"))
+		return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+				(unsigned long long)reg->dfl_val);
+
+	if (is_attr_name(attr, "width")) {
+		w = (reg->type & PFM_REG_C64) ?
+		    pfm_pmu_conf->counter_width : 64;
+		return snprintf(buf, PAGE_SIZE, "%d\n", w);
+	}
+
+	if (is_attr_name(attr, "rsvd_msk"))
+		return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+				(unsigned long long)reg->rsvd_msk);
+
+	if (is_attr_name(attr, "addr"))
+		return snprintf(buf, PAGE_SIZE, "0x%lx\n", reg->hw_addr);
+
+	return 0;
+}
+
+static PFM_ROS_ATTR(name, pfm_reg_show);
+static PFM_ROS_ATTR(dfl_val, pfm_reg_show);
+static PFM_ROS_ATTR(rsvd_msk, pfm_reg_show);
+static PFM_ROS_ATTR(width, pfm_reg_show);
+static PFM_ROS_ATTR(addr, pfm_reg_show);
+
+static struct attribute *pfm_reg_attrs[] = {
+	&attr_name.attr,
+	&attr_dfl_val.attr,
+	&attr_rsvd_msk.attr,
+	&attr_width.attr,
+	&attr_addr.attr,
+	NULL
+};
+
+static struct attribute_group pfm_reg_attr_group = {
+	.attrs = pfm_reg_attrs,
+};
+
+static ssize_t pfm_pmu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	if (is_attr_name(attr, "model"))
+		return snprintf(buf, PAGE_SIZE, "%s\n", pfm_pmu_conf->pmu_name);
+	return 0;
+}
+
+static PFM_RO_ATTR(model, pfm_pmu_show);
+
+static struct attribute *pfm_pmu_desc_attrs[] = {
+	&attr_model.attr,
+	NULL
+};
+
+static struct attribute_group pfm_pmu_desc_attr_group = {
+	.attrs = pfm_pmu_desc_attrs,
+};
+
+static int pfm_sysfs_add_pmu_regs(struct pfm_pmu_config *pmu)
+{
+	struct pfm_regmap_desc *reg;
+	unsigned int i, k;
+	int ret;
+
+	reg = pmu->pmc_desc;
+	for (i = 0; i < pmu->num_pmc_entries; i++, reg++) {
+
+		if (!(reg->type & PFM_REG_I))
+			continue;
+
+		ret = kobject_init_and_add(&reg->kobj, &pfm_regs_ktype,
+					   pfm_pmu_kobj, "pmc%u", i);
+		if (ret)
+			goto undo_pmcs;
+
+		ret = sysfs_create_group(&reg->kobj, &pfm_reg_attr_group);
+		if (ret) {
+			kobject_del(&reg->kobj);
+			goto undo_pmcs;
+		}
+	}
+
+	reg = pmu->pmd_desc;
+	for (i = 0; i < pmu->num_pmd_entries; i++, reg++) {
+
+		if (!(reg->type & PFM_REG_I))
+			continue;
+
+		ret = kobject_init_and_add(&reg->kobj, &pfm_regs_ktype,
+					   pfm_pmu_kobj, "pmd%u", i);
+		if (ret)
+			goto undo_pmds;
+
+		ret = sysfs_create_group(&reg->kobj, &pfm_reg_attr_group);
+		if (ret) {
+			kobject_del(&reg->kobj);
+			goto undo_pmds;
+		}
+	}
+	return 0;
+undo_pmds:
+	reg = pmu->pmd_desc;
+	for (k = 0; k < i; k++, reg++) {
+		if (!(reg->type & PFM_REG_I))
+			continue;
+		sysfs_remove_group(&reg->kobj, &pfm_reg_attr_group);
+		kobject_del(&reg->kobj);
+	}
+	i = pmu->num_pmc_entries;
+	/* fall through */
+undo_pmcs:
+	reg = pmu->pmc_desc;
+	for (k = 0; k < i; k++, reg++) {
+		if (!(reg->type & PFM_REG_I))
+			continue;
+		sysfs_remove_group(&reg->kobj, &pfm_reg_attr_group);
+		kobject_del(&reg->kobj);
+	}
+	return ret;
+}
+
+/*
+ * when a PMU description module is inserted, we create
+ * a pmu_desc subdir in sysfs and we populate it with
+ * PMU specific information, such as register mappings
+ */
+int pfm_sysfs_add_pmu(struct pfm_pmu_config *pmu)
+{
+	int ret;
+
+	pfm_pmu_kobj = kobject_create_and_add("pmu_desc", pfm_kernel_kobj);
+	if (!pfm_pmu_kobj)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(pfm_pmu_kobj, &pfm_pmu_desc_attr_group);
+	if (ret) {
+		/* will release pfm_pmu_kobj */
+		kobject_put(pfm_pmu_kobj);
+		return ret;
+	}
+
+	ret = pfm_sysfs_add_pmu_regs(pmu);
+	if (ret) {
+		sysfs_remove_group(pfm_pmu_kobj, &pfm_pmu_desc_attr_group);
+		/* will release pfm_pmu_kobj */
+		kobject_put(pfm_pmu_kobj);
+	} else
+		kobject_uevent(pfm_pmu_kobj, KOBJ_ADD);
+
+	return ret;
+}
+
+int __init pfm_init_sysfs(void)
+{
+	int ret;
+
+	/*
+ 	 * dynamic allocation happens on pfm_kernel_kobj,
+ 	 * but a release callback is attached
+ 	 */
+	pfm_kernel_kobj = kobject_create_and_add("perfmon", kernel_kobj);
+	if (!pfm_kernel_kobj) {
+		PFM_ERR("cannot add kernel object");
+		return -ENOMEM;
+	}
+
+	ret = sysfs_create_group(pfm_kernel_kobj, &pfm_kernel_attr_group);
+	if (ret) {
+		kobject_put(pfm_kernel_kobj);
+		return ret;
+	}
+
+	if (pfm_pmu_conf)
+		pfm_sysfs_add_pmu(pfm_pmu_conf);
+
+	return 0;
+}
Index: o3/perfmon/perfmon_priv.h
===================================================================
--- o3.orig/perfmon/perfmon_priv.h	2008-10-15 15:53:34.000000000 +0200
+++ o3/perfmon/perfmon_priv.h	2008-10-16 12:15:55.000000000 +0200
@@ -52,6 +52,8 @@
 
 void pfm_free_context(struct pfm_context *ctx);
 
+ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
+
 int pfm_pmu_acquire(struct pfm_context *ctx);
 void pfm_pmu_release(void);
 
Index: o3/perfmon/perfmon_res.c
===================================================================
--- o3.orig/perfmon/perfmon_res.c	2008-10-15 15:53:27.000000000 +0200
+++ o3/perfmon/perfmon_res.c	2008-10-15 15:53:35.000000000 +0200
@@ -188,3 +188,36 @@
 	spin_unlock_irqrestore(&pfm_res_lock, flags);
 }
 EXPORT_SYMBOL(pfm_session_allcpus_release);
+
+/**
+ * pfm_sysfs_res_show - return currnt resourcde usage for sysfs
+ * @buf: buffer to hold string in return
+ * @sz: size of buf
+ * @what: what to produce
+ *        what=0 : thread_sessions
+ *        what=1 : cpus_weight(sys_cpumask)
+ *        what=2 : smpl_buf_mem_cur
+ *        what=3 : pmu model name
+ *
+ * called from perfmon_sysfs.c
+ * return number of bytes written into buf (up to sz)
+ */
+ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pfm_res_lock, flags);
+
+	switch (what) {
+	case 0: snprintf(buf, sz, "%u\n", pfm_res.thread_sessions);
+		break;
+	case 1: snprintf(buf, sz, "%d\n", cpus_weight(pfm_res.sys_cpumask));
+		break;
+	case 3:
+		snprintf(buf, sz, "%s\n",
+			pfm_pmu_conf ?	pfm_pmu_conf->pmu_name
+				     :	"unknown\n");
+	}
+	spin_unlock_irqrestore(&pfm_res_lock, flags);
+	return strlen(buf);
+}
Index: o3/perfmon/perfmon_pmu.c
===================================================================
--- o3.orig/perfmon/perfmon_pmu.c	2008-10-15 15:53:34.000000000 +0200
+++ o3/perfmon/perfmon_pmu.c	2008-10-15 15:53:35.000000000 +0200
@@ -164,6 +164,10 @@
 	pfm_pmu_conf = cfg;
 	pfm_pmu_conf->ovfl_mask = (1ULL << cfg->counter_width) - 1;
 
+	ret = pfm_sysfs_add_pmu(pfm_pmu_conf);
+	if (ret)
+		pfm_pmu_conf = NULL;
+
 unlock:
 	spin_unlock(&pfm_pmu_conf_lock);
 

-- 

