Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZKYBsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZKYBsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbZKYBsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:48:23 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53322 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148AbZKYBsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:48:22 -0500
Message-ID: <4B0C8CE3.4010207@austin.ibm.com>
Date: Tue, 24 Nov 2009 19:48:19 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/3] Kernel DLPAR infrastructure
References: <4B0C8B45.6080804@austin.ibm.com>
In-Reply-To: <4B0C8B45.6080804@austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the kernel DLPAR infrastructure in a new filed named
dlpar.c.  The functionality provided is for acquiring and releasing a resource
from firmware and the parsing of information returned from the
ibm,configure-connector rtas call.  Additionally this exports the pSeries
reconfiguration notifier chain so that it can be invoked when device tree 
updates are made.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com> 
---

---
 arch/powerpc/include/asm/pSeries_reconfig.h |    1 
 arch/powerpc/platforms/pseries/Makefile     |    2 
 arch/powerpc/platforms/pseries/dlpar.c      |  324 ++++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/reconfig.c   |    2 
 4 files changed, 327 insertions(+), 2 deletions(-)

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-11-24 23:31:28.000000000 -0600
@@ -0,0 +1,324 @@
+/*
+ * Support for dynamic reconfiguration for PCI, Memory, and CPU
+ * Hotplug and Dynamic Logical Partitioning on RPA platforms.
+ *
+ * Copyright (C) 2009 Nathan Fontenot
+ * Copyright (C) 2009 IBM Corporation
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
+#include <linux/cpu.h>
+
+#include <asm/prom.h>
+#include <asm/machdep.h>
+#include <asm/uaccess.h>
+#include <asm/rtas.h>
+#include <asm/pSeries_reconfig.h>
+
+struct cc_workarea {
+	u32	drc_index;
+	u32	zero;
+	u32	name_offset;
+	u32	prop_length;
+	u32	prop_offset;
+};
+
+static void dlpar_free_cc_property(struct property *prop)
+{
+	kfree(prop->name);
+	kfree(prop->value);
+	kfree(prop);
+}
+
+static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
+{
+	struct property *prop;
+	char *name;
+	char *value;
+
+	prop = kzalloc(sizeof(*prop), GFP_KERNEL);
+	if (!prop)
+		return NULL;
+
+	name = (char *)ccwa + ccwa->name_offset;
+	prop->name = kstrdup(name, GFP_KERNEL);
+
+	prop->length = ccwa->prop_length;
+	value = (char *)ccwa + ccwa->prop_offset;
+	prop->value = kzalloc(prop->length, GFP_KERNEL);
+	if (!prop->value) {
+		dlpar_free_cc_property(prop);
+		return NULL;
+	}
+
+	memcpy(prop->value, value, prop->length);
+	return prop;
+}
+
+static struct device_node *dlpar_parse_cc_node(struct cc_workarea *ccwa)
+{
+	struct device_node *dn;
+	char *name;
+
+	dn = kzalloc(sizeof(*dn), GFP_KERNEL);
+	if (!dn)
+		return NULL;
+
+	name = (char *)ccwa + ccwa->name_offset;
+	dn->full_name = kstrdup(name, GFP_KERNEL);
+
+	return dn;
+}
+
+static void dlpar_free_one_cc_node(struct device_node *dn)
+{
+	struct property *prop;
+
+	while (dn->properties) {
+		prop = dn->properties;
+		dn->properties = prop->next;
+		dlpar_free_cc_property(prop);
+	}
+
+	kfree(dn->full_name);
+	kfree(dn);
+}
+
+static void dlpar_free_cc_nodes(struct device_node *dn)
+{
+	if (dn->child)
+		dlpar_free_cc_nodes(dn->child);
+
+	if (dn->sibling)
+		dlpar_free_cc_nodes(dn->sibling);
+
+	dlpar_free_one_cc_node(dn);
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
+struct device_node *dlpar_configure_connector(u32 drc_index)
+{
+	struct device_node *dn;
+	struct device_node *first_dn = NULL;
+	struct device_node *last_dn = NULL;
+	struct property *property;
+	struct property *last_property = NULL;
+	struct cc_workarea *ccwa;
+	int cc_token;
+	int rc;
+
+	cc_token = rtas_token("ibm,configure-connector");
+	if (cc_token == RTAS_UNKNOWN_SERVICE)
+		return NULL;
+
+	spin_lock(&rtas_data_buf_lock);
+	ccwa = (struct cc_workarea *)&rtas_data_buf[0];
+	ccwa->drc_index = drc_index;
+	ccwa->zero = 0;
+
+	rc = rtas_call(cc_token, 2, 1, NULL, rtas_data_buf, NULL);
+	while (rc) {
+		switch (rc) {
+		case NEXT_SIBLING:
+			dn = dlpar_parse_cc_node(ccwa);
+			if (!dn)
+				goto cc_error;
+
+			dn->parent = last_dn->parent;
+			last_dn->sibling = dn;
+			last_dn = dn;
+			break;
+
+		case NEXT_CHILD:
+			dn = dlpar_parse_cc_node(ccwa);
+			if (!dn)
+				goto cc_error;
+
+			if (!first_dn)
+				first_dn = dn;
+			else {
+				dn->parent = last_dn;
+				if (last_dn)
+					last_dn->child = dn;
+			}
+
+			last_dn = dn;
+			break;
+
+		case NEXT_PROPERTY:
+			property = dlpar_parse_cc_property(ccwa);
+			if (!property)
+				goto cc_error;
+
+			if (!last_dn->properties)
+				last_dn->properties = property;
+			else
+				last_property->next = property;
+
+			last_property = property;
+			break;
+
+		case PREV_PARENT:
+			last_dn = last_dn->parent;
+			break;
+
+		case CALL_AGAIN:
+			break;
+
+		case MORE_MEMORY:
+		case ERR_CFG_USE:
+		default:
+			printk(KERN_ERR "Unexpected Error (%d) "
+			       "returned from configure-connector\n", rc);
+			goto cc_error;
+		}
+
+		rc = rtas_call(cc_token, 2, 1, NULL, rtas_data_buf, NULL);
+	}
+
+	spin_unlock(&rtas_data_buf_lock);
+	return first_dn;
+
+cc_error:
+	if (first_dn)
+		dlpar_free_cc_nodes(first_dn);
+	spin_unlock(&rtas_data_buf_lock);
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
+int dlpar_attach_node(struct device_node *dn)
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
+int dlpar_detach_node(struct device_node *dn)
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
+	of_node_put(dn); /* Must decrement the refcount */
+
+	return 0;
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
+int dlpar_acquire_drc(u32 drc_index)
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
+		return rc;
+
+	rc = rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
+	if (rc) {
+		rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
+		return rc;
+	}
+
+	return 0;
+}
+
+int dlpar_release_drc(u32 drc_index)
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
+		return rc;
+
+	rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
+	if (rc) {
+		rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
+		return rc;
+	}
+
+	return 0;
+}
+
+
Index: powerpc/arch/powerpc/platforms/pseries/Makefile
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/Makefile	2009-11-20 17:53:54.000000000 -0600
+++ powerpc/arch/powerpc/platforms/pseries/Makefile	2009-11-20 17:55:52.000000000 -0600
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
--- powerpc.orig/arch/powerpc/include/asm/pSeries_reconfig.h	2009-11-20 17:53:54.000000000 -0600
+++ powerpc/arch/powerpc/include/asm/pSeries_reconfig.h	2009-11-20 17:55:52.000000000 -0600
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
--- powerpc.orig/arch/powerpc/platforms/pseries/reconfig.c	2009-11-20 17:53:54.000000000 -0600
+++ powerpc/arch/powerpc/platforms/pseries/reconfig.c	2009-11-20 17:55:52.000000000 -0600
@@ -96,7 +96,7 @@
 	return parent;
 }
 
-static BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
+BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
 
 int pSeries_reconfig_notifier_register(struct notifier_block *nb)
 {
