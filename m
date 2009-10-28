Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZJ1U5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZJ1U5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZJ1U5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:57:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60089 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZJ1U5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:57:19 -0400
Message-ID: <4AE8B02C.3060706@austin.ibm.com>
Date: Wed, 28 Oct 2009 15:57:16 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6 v5] Memory DLPAR Handling
References: <4AE8ADCF.6090104@austin.ibm.com>
In-Reply-To: <4AE8ADCF.6090104@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the capability to DLPAR add and remove memory from the kernel.  The
patch registers handlers for the arch-specific probe and release memory 
callouts to handle addition/removal of memory to the system and the associated
device tree updates. 

Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com> 
---

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-28 15:21:38.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-28 15:21:49.000000000 -0500
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
@@ -404,11 +408,189 @@
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+static struct property *clone_property(struct property *old_prop)
+{
+	struct property *new_prop;
+
+	new_prop = kzalloc((sizeof *new_prop), GFP_KERNEL);
+	if (!new_prop)
+		return NULL;
+
+	new_prop->name = kstrdup(old_prop->name, GFP_KERNEL);
+	new_prop->value = kzalloc(old_prop->length + 1, GFP_KERNEL);
+	if (!new_prop->name || !new_prop->value) {
+		free_property(new_prop);
+		return NULL;
+	}
+
+	memcpy(new_prop->value, old_prop->value, old_prop->length);
+	new_prop->length = old_prop->length;
+
+	return new_prop;
+}
+
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+
+int memory_probe(u64 phys_addr)
+{
+	struct device_node *dn = NULL;
+	struct property *new_prop;
+	struct property *old_prop;
+	struct of_drconf_cell *drmem;
+	const u64 *lmb_size;
+	int num_entries, i;
+	int rc = -EINVAL;
+
+	if (!phys_addr)
+		goto memory_probe_exit;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		goto memory_probe_exit;
+
+	lmb_size = of_get_property(dn, "ibm,lmb-size", NULL);
+	if (!lmb_size)
+		goto memory_probe_exit;
+
+	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
+	if (!old_prop)
+		goto memory_probe_exit;
+
+	num_entries = *(u32 *)old_prop->value;
+	drmem = (struct of_drconf_cell *)
+				((char *)old_prop->value + sizeof(u32));
+
+	for (i = 0; i < num_entries; i++) {
+		u64 lmb_end_addr = drmem[i].base_addr + *lmb_size;
+		if (phys_addr >= drmem[i].base_addr
+		    && phys_addr < lmb_end_addr)
+			break;
+	}
+
+	if (i >= num_entries)
+		goto memory_probe_exit;
+
+	if (drmem[i].flags & DRCONF_MEM_ASSIGNED) {
+		/* This lmb is already adssigned to the system, nothing to do */
+		rc = 0;
+		goto memory_probe_exit;
+	}
+
+	rc = acquire_drc(drmem[i].drc_index);
+	if (rc) {
+		rc = -EINVAL;
+		goto memory_probe_exit;
+	}
+
+	new_prop = clone_property(old_prop);
+	drmem = (struct of_drconf_cell *)
+				((char *)new_prop->value + sizeof(u32));
+
+	drmem[i].flags |= DRCONF_MEM_ASSIGNED;
+	rc = prom_update_property(dn, new_prop, old_prop);
+	if (rc) {
+		free_property(new_prop);
+		rc = -EINVAL;
+		goto memory_probe_exit;
+	}
+
+	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
+					  PSERIES_DRCONF_MEM_ADD,
+					  &drmem[i].base_addr);
+	if (rc == NOTIFY_BAD) {
+		prom_update_property(dn, old_prop, new_prop);
+		release_drc(drmem[i].drc_index);
+		rc = -EINVAL;
+	} else
+		rc = 0;
+
+memory_probe_exit:
+	of_node_put(dn);
+	return rc;
+}
+
+#endif /* CONFIG_ARCH_MEMORY_PROBE */
+
+#ifdef CONFIG_ARCH_MEMORY_RELEASE
+
+static int memory_release(const char *buf, size_t count)
+{
+	unsigned long drc_index;
+	struct device_node *dn;
+	struct property *new_prop, *old_prop;
+	struct of_drconf_cell *drmem;
+	int num_entries;
+	int i;
+	int rc = -EINVAL;
+
+	rc = strict_strtoul(buf, 0, &drc_index);
+	if (rc)
+		return rc;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		return rc;
+
+	old_prop = of_find_property(dn, "ibm,dynamic-memory", NULL);
+	if (!old_prop)
+		goto memory_release_exit;
+
+	num_entries = *(u32 *)old_prop->value;
+	drmem = (struct of_drconf_cell *)
+				((char *)old_prop->value + sizeof(u32));
+
+	for (i = 0; i < num_entries; i++) {
+		if (drmem[i].drc_index == drc_index)
+			break;
+	}
+
+	if (i >= num_entries)
+		goto memory_release_exit;
+
+	new_prop = clone_property(old_prop);
+	drmem = (struct of_drconf_cell *)
+				((char *)new_prop->value + sizeof(u32));
+
+	drmem[i].flags &= ~DRCONF_MEM_ASSIGNED;
+	rc = prom_update_property(dn, new_prop, old_prop);
+	if (rc) {
+		free_property(new_prop);
+		rc = -EINVAL;
+		goto memory_release_exit;
+	}
+
+	rc = blocking_notifier_call_chain(&pSeries_reconfig_chain,
+					  PSERIES_DRCONF_MEM_REMOVE,
+					  &drmem[i].base_addr);
+	if (rc != NOTIFY_BAD)
+		rc = release_drc(drc_index);
+
+	if (rc) {
+		prom_update_property(dn, old_prop, new_prop);
+		rc = -EINVAL;
+	}
+
+memory_release_exit:
+	of_node_put(dn);
+	return rc ? rc : count;
+}
+#endif /* CONFIG_ARCH_MEMORY_RELEASE */
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 static int pseries_dlpar_init(void)
 {
 	if (!machine_is(pseries))
 		return 0;
 
+#ifdef CONFIG_ARCH_MEMORY_RELEASE
+	ppc_md.memory_release = memory_release;
+#endif
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+	ppc_md.memory_probe = memory_probe;
+#endif
+
 	return 0;
 }
 device_initcall(pseries_dlpar_init);
