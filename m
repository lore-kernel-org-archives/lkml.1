Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZIKVLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZIKVLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZIKVLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:11:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33679 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827AbZIKVLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:11:03 -0400
Message-ID: <4AAABCE3.5090702@austin.ibm.com>
Date: Fri, 11 Sep 2009 16:10:59 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dynamic logical partitioning infrastructure
References: <4AAABC55.4070207@austin.ibm.com>
In-Reply-To: <4AAABC55.4070207@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the kernel DLPAR infrastructure in a new filed named
dlpar.c.  The functionality provided is for acquiring and releasing a 
resource from firmware and the parsing of information returned from the
ibm,configure-connector rtas call.  Additionally this exports the 
pSeries reconfiguration notifier chain so that it can be invoked when
device tree updates are made.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-09-11 12:51:52.000000000 -0500
@@ -0,0 +1,416 @@
+/*
+ * dlpar.c - support for dynamic reconfiguration (including PCI
+ * Hotplug and Dynamic Logical Partitioning on RPA platforms).
+ *
+ * Copyright (C) 2009 Nathan Fontenot
+ * Copyright (C) 2009 IBM Corporation
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kref.h>
+#include <linux/notifier.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+
+#include <asm/prom.h>
+#include <asm/machdep.h>
+#include <asm/uaccess.h>
+#include <asm/rtas.h>
+#include <asm/pSeries_reconfig.h>
+
+#define CFG_CONN_WORK_SIZE	4096
+static char workarea[CFG_CONN_WORK_SIZE];
+spinlock_t workarea_lock;
+
+static struct property *parse_cc_property(char *workarea)
+{
+	struct property *prop;
+	u32 *work_ints;
+	char *name;
+	char *value;
+
+	prop = kzalloc(sizeof(*prop), GFP_KERNEL);
+	if (!prop)
+		return NULL;
+
+	work_ints = (u32 *)workarea;
+	name = workarea + work_ints[2];
+	prop->name = kzalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!prop->name) {
+		kfree(prop);
+		return NULL;
+	}
+
+	strcpy(prop->name, name);
+
+	prop->length = work_ints[3];
+	value = workarea + work_ints[4];
+	prop->value = kzalloc(prop->length, GFP_KERNEL);
+	if (!prop->value) {
+		kfree(prop->name);
+		kfree(prop);
+		return NULL;
+	}
+
+	memcpy(prop->value, value, prop->length);
+	return prop;
+}
+
+static void free_cc_property(struct property *prop)
+{
+	if (prop->name)
+		kfree(prop->name);
+	if (prop->value)
+		kfree(prop->value);
+
+	kfree(prop);
+}
+
+static struct device_node *parse_cc_node(char *work_area)
+{
+	struct device_node *dn;
+	u32 *work_ints;
+	char *name;
+
+	dn = kzalloc(sizeof(*dn), GFP_KERNEL);
+	if (!dn)
+		return NULL;
+
+	work_ints = (u32 *)work_area;
+	name = work_area + work_ints[2];
+	dn->full_name = kzalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!dn->full_name) {
+		kfree(dn);
+		return NULL;
+	}
+
+	strcpy(dn->full_name, name);
+	return dn;
+}
+
+static void free_one_cc_node(struct device_node *dn)
+{
+	struct property *prop;
+
+	while (dn->properties) {
+		prop = dn->properties;
+		dn->properties = prop->next;
+		free_cc_property(prop);
+	}
+
+	if (dn->full_name)
+		kfree(dn->full_name);
+
+	kfree(dn);
+}
+
+static void free_cc_nodes(struct device_node *dn)
+{
+	if (dn->child)
+		free_cc_nodes(dn->child);
+
+	if (dn->sibling)
+		free_cc_nodes(dn->sibling);
+
+	free_one_cc_node(dn);
+}
+
+#define NEXT_SIBLING    1
+#define NEXT_CHILD      2
+#define NEXT_PROPERTY   3
+#define PREV_PARENT     4
+#define MORE_MEMORY     5
+#define CALL_AGAIN	-2
+#define ERR_CFG_USE     -9003
+
+struct device_node *configure_connector(u32 drc_index)
+{
+	struct device_node *dn;
+	struct device_node *first_dn = NULL;
+	struct device_node *last_dn = NULL;
+	struct property *property;
+	struct property *last_property = NULL;
+	u32 *work_int;
+	int cc_token;
+	int rc;
+
+	cc_token = rtas_token("ibm,configure-connector");
+	if (cc_token == RTAS_UNKNOWN_SERVICE)
+		return NULL;
+
+	spin_lock(&workarea_lock);
+
+	work_int = (u32 *)&workarea[0];
+	work_int[0] = drc_index;
+	work_int[1] = 0;
+
+	rc = rtas_call(cc_token, 2, 1, NULL, workarea, NULL);
+	while (rc) {
+		switch (rc) {
+			case NEXT_SIBLING:
+				dn = parse_cc_node(workarea);
+				if (!dn)
+					goto cc_error;
+
+				dn->parent = last_dn->parent;
+				last_dn->sibling = dn;
+				last_dn = dn;
+				break;
+
+			case NEXT_CHILD:
+				dn = parse_cc_node(workarea);
+				if (!dn)
+					goto cc_error;
+
+				if (!first_dn)
+					first_dn = dn;
+				else {
+					dn->parent = last_dn;
+					if (last_dn)
+						last_dn->child = dn;
+				}
+
+				last_dn = dn;
+				break;
+
+			case NEXT_PROPERTY:
+				property = parse_cc_property(workarea);
+				if (!property)
+					goto cc_error;
+
+				if (!last_dn->properties)
+					last_dn->properties = property;
+				else
+					last_property->next = property;
+
+				last_property = property;
+				break;
+
+			case PREV_PARENT:
+				last_dn = last_dn->parent;
+				break;
+
+			case CALL_AGAIN:
+				break;
+
+			case MORE_MEMORY:
+			case ERR_CFG_USE:
+			default:
+				printk(KERN_ERR "Unexpected Error (%d) "
+				       "returned from configure-connector\n",
+				       rc);
+				goto cc_error;
+		}
+
+		rc = rtas_call(cc_token, 2, 1, NULL, workarea, NULL);
+	}
+
+	spin_unlock(&workarea_lock);
+	return first_dn;
+
+cc_error:
+	spin_unlock(&workarea_lock);
+
+	if (first_dn)
+		free_cc_nodes(first_dn);
+
+	return NULL;
+}
+
+static struct device_node *derive_parent(const char *path)
+{
+	struct device_node *parent;
+	char parent_path[128];
+	int parent_path_len;
+
+	parent_path_len = strrchr(path, '/') - path + 1;
+	strlcpy(parent_path, path, parent_path_len);
+
+	parent = of_find_node_by_path(parent_path);
+
+	return parent;
+}
+
+static int add_one_node(struct device_node *dn)
+{
+	struct proc_dir_entry *ent;
+	int rc;
+
+	of_node_set_flag(dn, OF_DYNAMIC);
+	kref_init(&dn->kref);
+	dn->parent = derive_parent(dn->full_name);
+
+	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
+					  PSERIES_RECONFIG_ADD, dn);
+	if (rc == NOTIFY_BAD) {
+		printk(KERN_ERR "Failed to add device node %s\n",
+		       dn->full_name);
+		return -ENOMEM; /* For now, safe to assume kmalloc failure */
+	}
+
+	of_attach_node(dn);
+
+#ifdef CONFIG_PROC_DEVICETREE
+	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
+	if (ent)
+		proc_device_tree_add_node(dn, ent);
+#endif
+
+	of_node_put(dn->parent);
+	return 0;
+}
+
+int add_device_tree_nodes(struct device_node *dn)
+{
+	struct device_node *child = dn->child;
+	struct device_node *sibling = dn->sibling;
+	int rc;
+
+	dn->child = NULL;
+	dn->sibling = NULL;
+	dn->parent = NULL;
+
+	rc = add_one_node(dn);
+	if (rc)
+		return rc;
+
+	if (child) {
+		rc = add_device_tree_nodes(child);
+		if (rc)
+			return rc;
+	}
+
+	if (sibling)
+		rc = add_device_tree_nodes(sibling);
+
+	return rc;
+}
+
+static int remove_one_node(struct device_node *dn)
+{
+	struct device_node *parent = dn->parent;
+	struct property *prop = dn->properties;
+
+#ifdef CONFIG_PROC_DEVICETREE
+	while (prop) {
+		remove_proc_entry(prop->name, dn->pde);
+		prop = prop->next;
+	}
+
+	if (dn->pde)
+		remove_proc_entry(dn->pde->name, parent->pde);
+#endif
+
+	blocking_notifier_call_chain(&pSeries_reconfig_chain,
+			    PSERIES_RECONFIG_REMOVE, dn);
+	of_detach_node(dn);
+
+	of_node_put(parent);
+	of_node_put(dn); /* Must decrement the refcount */
+
+	return 0;
+}
+
+static int _remove_device_tree_nodes(struct device_node *dn)
+{
+	int rc;
+
+	if (dn->child) {
+		rc = _remove_device_tree_nodes(dn->child);
+		if (rc)
+			return rc;
+	}
+
+	if (dn->sibling) {
+		rc = _remove_device_tree_nodes(dn->sibling);
+		if (rc)
+			return rc;
+	}
+
+	rc = remove_one_node(dn);
+	return rc;
+}
+
+int remove_device_tree_nodes(struct device_node *dn)
+{
+	int rc;
+
+	if (dn->child) {
+		rc = _remove_device_tree_nodes(dn->child);
+		if (rc)
+			return rc;
+	}
+
+	rc = remove_one_node(dn);
+	return rc;
+}
+
+#define DR_ENTITY_SENSE		9003
+#define DR_ENTITY_PRESENT	1
+#define DR_ENTITY_UNUSABLE	2
+#define ALLOCATION_STATE	9003
+#define ALLOC_UNUSABLE		0
+#define ALLOC_USABLE		1
+#define ISOLATION_STATE		9001
+#define ISOLATE			0
+#define UNISOLATE		1
+
+int acquire_drc(u32 drc_index)
+{
+	int dr_status, rc;
+
+	rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
+		       DR_ENTITY_SENSE, drc_index);
+	if (rc || dr_status != DR_ENTITY_UNUSABLE)
+		return -1;
+
+	rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_USABLE);
+	if (rc)
+		return -1;
+
+	rc = rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
+	if (rc) {
+		rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
+		return -1;
+	}
+
+	return 0;
+}
+
+int release_drc(u32 drc_index)
+{
+	int dr_status, rc;
+
+	rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
+		       DR_ENTITY_SENSE, drc_index);
+	if (rc || dr_status != DR_ENTITY_PRESENT)
+		return -1;
+
+	rc = rtas_set_indicator(ISOLATION_STATE, drc_index, ISOLATE);
+	if (rc)
+		return -1;
+
+	rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
+	if (rc) {
+		rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int pseries_dlpar_init(void)
+{
+	spin_lock_init(&workarea_lock);
+
+	if (!machine_is(pseries))
+		return 0;
+
+	return 0;
+}
+__initcall(pseries_dlpar_init);
Index: powerpc/arch/powerpc/platforms/pseries/Makefile
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/Makefile	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/Makefile	2009-09-11 12:51:52.000000000 -0500
@@ -8,7 +8,7 @@
 
 obj-y			:= lpar.o hvCall.o nvram.o reconfig.o \
 			   setup.o iommu.o ras.o rtasd.o \
-			   firmware.o power.o
+			   firmware.o power.o dlpar.o
 obj-$(CONFIG_SMP)	+= smp.o
 obj-$(CONFIG_XICS)	+= xics.o
 obj-$(CONFIG_SCANLOG)	+= scanlog.o
Index: powerpc/arch/powerpc/include/asm/pSeries_reconfig.h
===================================================================
--- powerpc.orig/arch/powerpc/include/asm/pSeries_reconfig.h	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/include/asm/pSeries_reconfig.h	2009-09-11 12:51:52.000000000 -0500
@@ -17,6 +17,7 @@
 #ifdef CONFIG_PPC_PSERIES
 extern int pSeries_reconfig_notifier_register(struct notifier_block *);
 extern void pSeries_reconfig_notifier_unregister(struct notifier_block *);
+extern struct blocking_notifier_head pSeries_reconfig_chain;
 #else /* !CONFIG_PPC_PSERIES */
 static inline int pSeries_reconfig_notifier_register(struct notifier_block *nb)
 {
Index: powerpc/arch/powerpc/platforms/pseries/reconfig.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/reconfig.c	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/reconfig.c	2009-09-11 12:51:52.000000000 -0500
@@ -95,7 +95,7 @@
 	return parent;
 }
 
-static BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
+struct blocking_notifier_head pSeries_reconfig_chain = BLOCKING_NOTIFIER_INIT(pSeries_reconfig_chain);
 
 int pSeries_reconfig_notifier_register(struct notifier_block *nb)
 {
