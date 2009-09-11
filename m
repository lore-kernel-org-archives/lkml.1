Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZIKVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZIKVOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZIKVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:14:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53136 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZIKVOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:14:39 -0400
Message-ID: <4AAABDBB.7010400@austin.ibm.com>
Date: Fri, 11 Sep 2009 16:14:35 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] kernel handling of memory DLPAR
References: <4AAABC55.4070207@austin.ibm.com>
In-Reply-To: <4AAABC55.4070207@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the capability to DLPAR add and remove memory from the kernel.  The
patch extends the powerpc handling of memory_add_physaddr_to_nid(), which is
called from the sysfs memory 'probe' file to first ensure that the memory
has been added to the system.  This is done by creating a platform specific
callout from the routine.  The pseries implementation of this handles the
DLPAR work to add the memory to the system and update the device tree.

The patch also creates a pseries only 'release' sys file, 
/sys/devices/system/memory/release.  This file handles the DLPAR release of
memory back to firmware and updating of the device-tree.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-09-11 12:51:52.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-09-11 13:05:23.000000000 -0500
@@ -16,6 +16,10 @@
 #include <linux/notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
+#include <linux/memory_hotplug.h>
+#include <linux/sysdev.h>
+#include <linux/sysfs.h>
+
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -404,13 +408,174 @@
 	return 0;
 }
 
+static void free_property(struct property *prop)
+{
+	if (prop->name)
+		kfree(prop->name);
+	if (prop->value)
+		kfree(prop->value);
+	kfree(prop);
+}
+
+static struct property *clone_property(struct property *old_prop)
+{
+	struct property *new_prop;
+
+	new_prop = kzalloc((sizeof *new_prop), GFP_KERNEL);
+	if (!new_prop)
+		return NULL;
+
+	new_prop->name = kzalloc(strlen(old_prop->name) + 1, GFP_KERNEL);
+	new_prop->value = kzalloc(old_prop->length + 1, GFP_KERNEL);
+	if (!new_prop->name || !new_prop->value) {
+		free_property(new_prop);
+		return NULL;
+	}
+
+	strcpy(new_prop->name, old_prop->name);
+	memcpy(new_prop->value, old_prop->value, old_prop->length);
+	new_prop->length = old_prop->length;
+
+	return new_prop;
+}
+
+int platform_probe_memory(u64 phys_addr)
+{
+	struct device_node *dn;
+	struct property *new_prop, *old_prop;
+	struct property *lmb_sz_prop;
+	struct of_drconf_cell *drmem;
+	u64 lmb_size;
+	int num_entries, i, rc;
+
+	if (!phys_addr)
+		return -EINVAL;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		return -EINVAL;
+
+	lmb_sz_prop = of_find_property(dn, "ibm,lmb-size", NULL);
+	lmb_size = *(u64 *)lmb_sz_prop->value;
+
+	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
+
+	num_entries = *(u32 *)old_prop->value;
+	drmem = (struct of_drconf_cell *)
+				((char *)old_prop->value + sizeof(u32));
+
+	for (i = 0; i < num_entries; i++) {
+		u64 lmb_end_addr = drmem[i].base_addr + lmb_size;
+		if (phys_addr >= drmem[i].base_addr
+		    && phys_addr < lmb_end_addr)
+			break;
+	}
+
+	if (i >= num_entries) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	if (drmem[i].flags & DRCONF_MEM_ASSIGNED) {
+		of_node_put(dn);
+		return 0;
+	}
+
+	rc = acquire_drc(drmem[i].drc_index);
+	if (rc) {
+		of_node_put(dn);
+		return -1;
+	}
+
+	new_prop = clone_property(old_prop);
+	drmem = (struct of_drconf_cell *)
+				((char *)new_prop->value + sizeof(u32));
+
+	drmem[i].flags |= DRCONF_MEM_ASSIGNED;
+	prom_update_property(dn, new_prop, old_prop);
+
+	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
+					  PSERIES_DRCONF_MEM_ADD,
+					  &drmem[i].base_addr);
+	if (rc == NOTIFY_BAD) {
+		prom_update_property(dn, old_prop, new_prop);
+		release_drc(drmem[i].drc_index);
+	}
+
+	of_node_put(dn);
+	return rc == NOTIFY_BAD ? -1 : 0;
+}
+
+static ssize_t memory_release_store(struct class *class, const char *buf,
+				    size_t count)
+{
+	u32 drc_index;
+	struct device_node *dn;
+	struct property *new_prop, *old_prop;
+	struct of_drconf_cell *drmem;
+	int num_entries;
+	int i, rc;
+
+	drc_index = simple_strtoull(buf, NULL, 0);
+	if (!drc_index)
+		return -EINVAL;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		return 0;
+
+	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
+	new_prop = clone_property(old_prop);
+
+	num_entries = *(u32 *)new_prop->value;
+	drmem = (struct of_drconf_cell *)
+				((char *)new_prop->value + sizeof(u32));
+
+	for (i = 0; i < num_entries; i++) {
+		if (drmem[i].drc_index == drc_index)
+			break;
+	}
+
+	if (i >= num_entries) {
+		free_property(new_prop);
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	drmem[i].flags &= ~DRCONF_MEM_ASSIGNED;
+	prom_update_property(dn, new_prop, old_prop);
+
+	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
+					  PSERIES_DRCONF_MEM_REMOVE,
+					  &drmem[i].base_addr);
+	if (rc != NOTIFY_BAD)
+		rc = release_drc(drc_index);
+
+	if (rc)
+		prom_update_property(dn, old_prop, new_prop);
+
+	of_node_put(dn);
+	return rc ? -1 : count;
+}
+
+static struct class_attribute class_attr_mem_release =
+			__ATTR(release, S_IWUSR, NULL, memory_release_store);
+
 static int pseries_dlpar_init(void)
 {
+	int rc;
+
 	spin_lock_init(&workarea_lock);
 
 	if (!machine_is(pseries))
 		return 0;
 
+	rc = sysfs_create_file(&memory_sysdev_class.kset.kobj,
+			       &class_attr_mem_release.attr);
+	if (rc)
+		printk(KERN_INFO "DLPAR: Could not create sysfs memory "
+		       "release file\n");
+
 	return 0;
 }
 __initcall(pseries_dlpar_init);
Index: powerpc/arch/powerpc/mm/mem.c
===================================================================
--- powerpc.orig/arch/powerpc/mm/mem.c	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/mm/mem.c	2009-09-11 12:52:42.000000000 -0500
@@ -111,8 +111,19 @@
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 #ifdef CONFIG_NUMA
+int __attribute ((weak)) platform_probe_memory(u64 start)
+{
+	return 0;
+}
+
 int memory_add_physaddr_to_nid(u64 start)
 {
+	int rc;
+
+	rc = platform_probe_memory(start);
+	if (rc)
+		return rc;
+
 	return hot_add_scn_to_nid(start);
 }
 #endif
