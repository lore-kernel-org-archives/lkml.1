Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbYFIWi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbYFIWi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761835AbYFIWeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:34:31 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761702AbYFIWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=DcyZ8Q7DkZwSDMP0uEzeOUbhL/cSh6BnLYQ/PjCkA+E0H2SfESxY3AzJSzoLSy9JYq
         861NH7uoaJP6t6ArlHfEckEHYfz8RFJ1rAWztnZr3+h7GmvdZoI3pQ2v53656Dn26Hn5
         I5nIqcCgleY3f3/J1bxNlgm11nWI3Vv49iVhY=
To: linux-kernel@vger.kernel.org
Subject: [patch 12/21] perfmon2 minimal:  sysfs interface
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:34:25 -0700 (PDT)
Message-ID: <484daff1.1358560a.0808.0267@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the sysfs interface to the perfmon2 subsystem. It is
used for configuration of the interface. It exposes the PMU register
mappings and various attributes of the subsystem.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/perfmon/perfmon_init.c
===================================================================
--- o.orig/perfmon/perfmon_init.c	2008-06-04 22:46:24.000000000 +0200
+++ o/perfmon/perfmon_init.c	2008-06-04 22:46:26.000000000 +0200
@@ -62,6 +62,9 @@
 	if (pfm_init_fs())
 		goto error_disable;
 
+	if (pfm_init_sysfs())
+		goto error_disable;
+
 	/* not critical, so no error checking */
 	pfm_init_debugfs();
 
Index: o/perfmon/perfmon_sysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/perfmon/perfmon_sysfs.c	2008-06-04 22:46:26.000000000 +0200
@@ -0,0 +1,422 @@
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
+	ssize_t (*show)(void *, char *);
+	ssize_t (*store)(void *, const char *, size_t);
+};
+#define to_attr(n) container_of(n, struct pfm_attribute, attr);
+
+#define PFM_RO_ATTR(_name) \
+struct pfm_attribute attr_##_name = __ATTR_RO(_name)
+
+#define PFM_RW_ATTR(_name, _mode, _show,_store) 			\
+struct pfm_attribute attr_##_name = __ATTR(_name, _mode, _show, _store);
+
+int pfm_sysfs_add_pmu(struct pfm_pmu_config *pmu);
+
+static struct kobject pfm_kernel_kobj;
+
+static ssize_t pfm_pmu_attr_show(struct kobject *kobj,
+		struct attribute *attr, char *buf)
+{
+	struct pfm_pmu_config *pmu = to_pmu(kobj);
+	struct pfm_attribute *attribute = to_attr(attr);
+	return attribute->show ? attribute->show(pmu, buf) : -EIO;
+}
+
+static ssize_t pfm_regs_attr_show(struct kobject *kobj,
+		struct attribute *attr, char *buf)
+{
+	struct pfm_regmap_desc *reg = to_reg(kobj);
+	struct pfm_attribute *attribute = to_attr(attr);
+	return attribute->show ? attribute->show(reg, buf) : -EIO;
+}
+
+static struct sysfs_ops pfm_pmu_sysfs_ops = {
+	.show = pfm_pmu_attr_show
+};
+
+static struct sysfs_ops pfm_regs_sysfs_ops = {
+	.show  = pfm_regs_attr_show
+};
+
+
+static struct kobj_type pfm_pmu_ktype = {
+	.sysfs_ops = &pfm_pmu_sysfs_ops,
+};
+
+static struct kobj_type pfm_regs_ktype = {
+	.sysfs_ops = &pfm_regs_sysfs_ops,
+};
+
+static ssize_t version_show(void *info, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u.%u\n",  PFM_VERSION_MAJ, PFM_VERSION_MIN);
+}
+
+static ssize_t task_sessions_count_show(void *info, char *buf)
+{
+	return pfm_sysfs_res_show(buf, PAGE_SIZE, 0);
+}
+
+
+static ssize_t debug_show(void *info, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", pfm_controls.debug);
+}
+
+static ssize_t debug_store(void *info, const char *buf, size_t sz)
+{
+	int d;
+
+	if (sscanf(buf, "%d", &d) != 1)
+		return -EINVAL;
+
+	pfm_controls.debug = d;
+	return sz;
+}
+
+static ssize_t task_group_show(void *info, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", pfm_controls.task_group);
+}
+
+static ssize_t task_group_store(void *info, const char *buf, size_t sz)
+{
+	int d;
+
+	if (sscanf(buf, "%d", &d) != 1)
+		return -EINVAL;
+
+	pfm_controls.task_group = d;
+
+	return strnlen(buf, PAGE_SIZE);
+}
+
+static ssize_t arg_size_show(void *info, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%zu\n", pfm_controls.arg_mem_max);
+}
+
+static ssize_t arg_size_store(void *info, const char *buf, size_t sz)
+{
+	size_t d;
+
+	if (sscanf(buf, "%zu", &d) != 1)
+		return -EINVAL;
+
+	/*
+	 * we impose a page as the minimum.
+	 *
+	 * This limit may be smaller than the stack buffer
+	 * available and that is fine.
+	 */
+	if (d < PAGE_SIZE)
+		return -EINVAL;
+
+	pfm_controls.arg_mem_max = d;
+
+	return strnlen(buf, PAGE_SIZE);
+}
+
+static int __init enable_debug(char *str)
+{
+	pfm_controls.debug = 1;
+	PFM_INFO("debug output enabled\n");
+	return 1;
+}
+__setup("perfmon_debug", enable_debug);
+
+/*
+ * /sys/kernel/perfmon attributes
+ */
+static PFM_RO_ATTR(version);
+static PFM_RO_ATTR(task_sessions_count);
+
+static PFM_RW_ATTR(debug, 0644, debug_show, debug_store);
+static PFM_RW_ATTR(task_group, 0644, task_group_show, task_group_store);
+static PFM_RW_ATTR(arg_mem_max, 0644, arg_size_show, arg_size_store);
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
+static ssize_t pfm_kernel_show(struct kobject *kobj,
+			       struct attribute *attr, char *buf)
+{
+	int ret;
+	struct pfm_attribute *fattr = to_attr(attr);
+
+	if (fattr->show)
+		ret = fattr->show(NULL, buf);
+	else
+		ret = -EIO;
+
+	return ret;
+}
+
+static ssize_t pfm_kernel_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf, size_t count)
+{
+	int ret;
+	struct pfm_attribute *fattr = to_attr(attr);
+
+	if (fattr->store)
+		ret = fattr->store(NULL, buf, count);
+	else
+		ret = -EIO;
+	return ret;
+}
+
+static struct sysfs_ops pfm_kernel_sysfs_ops = {
+	.show	= pfm_kernel_show,
+	.store	= pfm_kernel_store,
+};
+
+static struct kobj_type ktype_kernel = {
+	.sysfs_ops	= &pfm_kernel_sysfs_ops,
+	.default_attrs	= pfm_kernel_attrs,
+};
+
+int __init pfm_init_sysfs(void)
+{
+	int ret;
+
+	ret = kobject_init_and_add(&pfm_kernel_kobj, &ktype_kernel,
+				   kobject_get(kernel_kobj), "perfmon");
+	if (ret) {
+		PFM_ERR("cannot add kernel object: %d", ret);
+		return ret;
+	}
+
+	if (pfm_pmu_conf)
+		pfm_sysfs_add_pmu(pfm_pmu_conf);
+
+	return 0;
+}
+
+/*
+ * per-cpu perfmon stats attributes
+ */
+#define PFM_DECL_STATS_ATTR(name) \
+static ssize_t name##_show(void *info, char *buf) \
+{ \
+	struct pfm_stats *st = info;\
+	return snprintf(buf, PAGE_SIZE, "%llu\n", \
+			(unsigned long long)st->name); \
+} \
+static PFM_RO_ATTR(name)
+
+/*
+ * per-reg attributes
+ */
+static ssize_t name_show(void *info, char *buf)
+{
+	struct pfm_regmap_desc *reg = info;
+	return snprintf(buf, PAGE_SIZE, "%s\n", reg->desc);
+}
+static PFM_RO_ATTR(name);
+
+static ssize_t dfl_val_show(void *info, char *buf)
+{
+	struct pfm_regmap_desc *reg = info;
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)reg->dfl_val);
+}
+static PFM_RO_ATTR(dfl_val);
+
+static ssize_t rsvd_msk_show(void *info, char *buf)
+{
+	struct pfm_regmap_desc *reg = info;
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+			(unsigned long long)reg->rsvd_msk);
+}
+static PFM_RO_ATTR(rsvd_msk);
+
+static ssize_t width_show(void *info, char *buf)
+{
+	struct pfm_regmap_desc *reg = info;
+	int w;
+
+	w = (reg->type & PFM_REG_C64) ? pfm_pmu_conf->counter_width : 64;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", w);
+}
+static PFM_RO_ATTR(width);
+
+
+static ssize_t addr_show(void *info, char *buf)
+{
+	struct pfm_regmap_desc *reg = info;
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n", reg->hw_addr);
+}
+static PFM_RO_ATTR(addr);
+
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
+static ssize_t model_show(void *info, char *buf)
+{
+	struct pfm_pmu_config *p = info;
+	return snprintf(buf, PAGE_SIZE, "%s\n", p->pmu_name);
+}
+static PFM_RO_ATTR(model);
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
+		kobject_init(&reg->kobj, &pfm_regs_ktype);
+
+		ret = kobject_add(&reg->kobj, &pmu->kobj, "pmc%u", i);
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
+		kobject_init(&reg->kobj, &pfm_regs_ktype);
+
+		ret = kobject_add(&reg->kobj, &pmu->kobj, "pmd%u", i);
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
+	kobject_init(&pmu->kobj, &pfm_pmu_ktype);
+
+	ret = kobject_add(&pmu->kobj, &pfm_kernel_kobj, "%s", "pmu_desc");
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&pmu->kobj, &pfm_pmu_desc_attr_group);
+	if (ret)
+		kobject_del(&pmu->kobj);
+
+	ret = pfm_sysfs_add_pmu_regs(pmu);
+	if (ret) {
+		sysfs_remove_group(&pmu->kobj, &pfm_pmu_desc_attr_group);
+		kobject_del(&pmu->kobj);
+	}
+	return ret;
+}
Index: o/perfmon/perfmon_priv.h
===================================================================
--- o.orig/perfmon/perfmon_priv.h	2008-06-04 22:46:24.000000000 +0200
+++ o/perfmon/perfmon_priv.h	2008-06-04 22:46:26.000000000 +0200
@@ -52,6 +52,8 @@
 
 void pfm_free_context(struct pfm_context *ctx);
 
+ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
+
 int pfm_pmu_acquire(void);
 void pfm_pmu_release(void);
 
Index: o/perfmon/perfmon_res.c
===================================================================
--- o.orig/perfmon/perfmon_res.c	2008-06-04 22:46:24.000000000 +0200
+++ o/perfmon/perfmon_res.c	2008-06-04 22:46:26.000000000 +0200
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
Index: o/perfmon/Makefile
===================================================================
--- o.orig/perfmon/Makefile	2008-06-04 22:46:24.000000000 +0200
+++ o/perfmon/Makefile	2008-06-04 22:46:26.000000000 +0200
@@ -5,4 +5,5 @@
 obj-$(CONFIG_PERFMON) = perfmon_ctx.o perfmon_ctxsw.o		\
 			perfmon_file.o perfmon_attach.o 	\
 			perfmon_res.o perfmon_init.o		\
-			perfmon_intr.o perfmon_pmu.o
+			perfmon_intr.o perfmon_pmu.o		\
+			perfmon_sysfs.o
Index: o/perfmon/perfmon_pmu.c
===================================================================
--- o.orig/perfmon/perfmon_pmu.c	2008-06-04 22:46:24.000000000 +0200
+++ o/perfmon/perfmon_pmu.c	2008-06-04 22:46:26.000000000 +0200
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

