Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0BVTLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:25 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6621 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0BVTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:15 -0500
Subject: [PATCH v2 02/12] ACPI: processor: mv processor_pdc.c processor_core.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:11:14 -0700
Message-ID: <20100222191113.19752.1315.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've renamed the old processor_core.c to processor_driver.c, to
convey the idea that it can be built modular and has driver-like
bits.

Now let's re-create a processor_core.c for the bits needed
statically by the rest of the kernel. The contents of processor_pdc.c
are a good starting spot, so let's just rename that file and
complete our three card monte.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/Makefile         |    2 
 drivers/acpi/processor_core.c |  209 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_pdc.c  |  209 -----------------------------------------
 include/acpi/processor.h      |    2 
 4 files changed, 211 insertions(+), 211 deletions(-)
 create mode 100644 drivers/acpi/processor_core.c
 delete mode 100644 drivers/acpi/processor_pdc.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index c8fcda4..d90af7f 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -33,7 +33,7 @@ acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 #
 acpi-y				+= bus.o glue.o
 acpi-y				+= scan.o
-acpi-y				+= processor_pdc.o
+acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
new file mode 100644
index 0000000..6f376bf
--- /dev/null
+++ b/drivers/acpi/processor_core.c
@@ -0,0 +1,209 @@
+/*
+ * Copyright (C) 2005 Intel Corporation
+ * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
+ *
+ *	Alex Chiang <achiang@hp.com>
+ *	- Unified x86/ia64 implementations
+ *	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *	- Added _PDC for platforms with Intel CPUs
+ */
+#include <linux/dmi.h>
+
+#include <acpi/acpi_drivers.h>
+#include <acpi/processor.h>
+
+#include "internal.h"
+
+#define PREFIX			"ACPI: "
+#define _COMPONENT		ACPI_PROCESSOR_COMPONENT
+ACPI_MODULE_NAME("processor_core");
+
+static int set_no_mwait(const struct dmi_system_id *id)
+{
+	printk(KERN_NOTICE PREFIX "%s detected - "
+		"disabling mwait for CPU C-states\n", id->ident);
+	idle_nomwait = 1;
+	return 0;
+}
+
+static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
+	{
+	set_no_mwait, "IFL91 board", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
+	DMI_MATCH(DMI_SYS_VENDOR, "ZEPTO"),
+	DMI_MATCH(DMI_PRODUCT_VERSION, "3215W"),
+	DMI_MATCH(DMI_BOARD_NAME, "IFL91") }, NULL},
+	{
+	set_no_mwait, "Extensa 5220", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
+	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
+	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
+	{},
+};
+
+static void acpi_set_pdc_bits(u32 *buf)
+{
+	buf[0] = ACPI_PDC_REVISION_ID;
+	buf[1] = 1;
+
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
+
+	/* Twiddle arch-specific bits needed for _PDC */
+	arch_acpi_set_pdc_bits(buf);
+}
+
+static struct acpi_object_list *acpi_processor_alloc_pdc(void)
+{
+	struct acpi_object_list *obj_list;
+	union acpi_object *obj;
+	u32 *buf;
+
+	/* allocate and initialize pdc. It will be used later. */
+	obj_list = kmalloc(sizeof(struct acpi_object_list), GFP_KERNEL);
+	if (!obj_list) {
+		printk(KERN_ERR "Memory allocation error\n");
+		return NULL;
+	}
+
+	obj = kmalloc(sizeof(union acpi_object), GFP_KERNEL);
+	if (!obj) {
+		printk(KERN_ERR "Memory allocation error\n");
+		kfree(obj_list);
+		return NULL;
+	}
+
+	buf = kmalloc(12, GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_ERR "Memory allocation error\n");
+		kfree(obj);
+		kfree(obj_list);
+		return NULL;
+	}
+
+	acpi_set_pdc_bits(buf);
+
+	obj->type = ACPI_TYPE_BUFFER;
+	obj->buffer.length = 12;
+	obj->buffer.pointer = (u8 *) buf;
+	obj_list->count = 1;
+	obj_list->pointer = obj;
+
+	return obj_list;
+}
+
+/*
+ * _PDC is required for a BIOS-OS handshake for most of the newer
+ * ACPI processor features.
+ */
+static int
+acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
+{
+	acpi_status status = AE_OK;
+
+	if (idle_nomwait) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		union acpi_object *obj;
+		u32 *buffer = NULL;
+
+		obj = pdc_in->pointer;
+		buffer = (u32 *)(obj->buffer.pointer);
+		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+
+	}
+	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
+
+	if (ACPI_FAILURE(status))
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+		    "Could not evaluate _PDC, using legacy perf. control.\n"));
+
+	return status;
+}
+
+static int early_pdc_done;
+
+void acpi_processor_set_pdc(acpi_handle handle)
+{
+	struct acpi_object_list *obj_list;
+
+	if (arch_has_acpi_pdc() == false)
+		return;
+
+	if (early_pdc_done)
+		return;
+
+	obj_list = acpi_processor_alloc_pdc();
+	if (!obj_list)
+		return;
+
+	acpi_processor_eval_pdc(handle, obj_list);
+
+	kfree(obj_list->pointer->buffer.pointer);
+	kfree(obj_list->pointer);
+	kfree(obj_list);
+}
+EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
+
+static int early_pdc_optin;
+static int set_early_pdc_optin(const struct dmi_system_id *id)
+{
+	early_pdc_optin = 1;
+	return 0;
+}
+
+static int param_early_pdc_optin(char *s)
+{
+	early_pdc_optin = 1;
+	return 1;
+}
+__setup("acpi_early_pdc_eval", param_early_pdc_optin);
+
+static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
+	{
+	set_early_pdc_optin, "HP Envy", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Envy") }, NULL},
+	{
+	set_early_pdc_optin, "HP Pavilion dv6", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv6") }, NULL},
+	{
+	set_early_pdc_optin, "HP Pavilion dv7", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv7") }, NULL},
+	{},
+};
+
+static acpi_status
+early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	acpi_processor_set_pdc(handle);
+	return AE_OK;
+}
+
+void __init acpi_early_processor_set_pdc(void)
+{
+	/*
+	 * Check whether the system is DMI table. If yes, OSPM
+	 * should not use mwait for CPU-states.
+	 */
+	dmi_check_system(processor_idle_dmi_table);
+
+	/*
+	 * Allow systems to opt-in to early _PDC evaluation.
+	 */
+	dmi_check_system(early_pdc_optin_table);
+	if (!early_pdc_optin)
+		return;
+
+	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX,
+			    early_init_pdc, NULL, NULL, NULL);
+
+	early_pdc_done = 1;
+}
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
deleted file mode 100644
index e306ba9..0000000
--- a/drivers/acpi/processor_pdc.c
+++ /dev/null
@@ -1,209 +0,0 @@
-/*
- * Copyright (C) 2005 Intel Corporation
- * Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
- *
- *	Alex Chiang <achiang@hp.com>
- *	- Unified x86/ia64 implementations
- *	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
- *	- Added _PDC for platforms with Intel CPUs
- */
-#include <linux/dmi.h>
-
-#include <acpi/acpi_drivers.h>
-#include <acpi/processor.h>
-
-#include "internal.h"
-
-#define PREFIX			"ACPI: "
-#define _COMPONENT		ACPI_PROCESSOR_COMPONENT
-ACPI_MODULE_NAME("processor_pdc");
-
-static int set_no_mwait(const struct dmi_system_id *id)
-{
-	printk(KERN_NOTICE PREFIX "%s detected - "
-		"disabling mwait for CPU C-states\n", id->ident);
-	idle_nomwait = 1;
-	return 0;
-}
-
-static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
-	{
-	set_no_mwait, "IFL91 board", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
-	DMI_MATCH(DMI_SYS_VENDOR, "ZEPTO"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "3215W"),
-	DMI_MATCH(DMI_BOARD_NAME, "IFL91") }, NULL},
-	{
-	set_no_mwait, "Extensa 5220", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
-	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
-	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
-	{},
-};
-
-static void acpi_set_pdc_bits(u32 *buf)
-{
-	buf[0] = ACPI_PDC_REVISION_ID;
-	buf[1] = 1;
-
-	/* Enable coordination with firmware's _TSD info */
-	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
-
-	/* Twiddle arch-specific bits needed for _PDC */
-	arch_acpi_set_pdc_bits(buf);
-}
-
-static struct acpi_object_list *acpi_processor_alloc_pdc(void)
-{
-	struct acpi_object_list *obj_list;
-	union acpi_object *obj;
-	u32 *buf;
-
-	/* allocate and initialize pdc. It will be used later. */
-	obj_list = kmalloc(sizeof(struct acpi_object_list), GFP_KERNEL);
-	if (!obj_list) {
-		printk(KERN_ERR "Memory allocation error\n");
-		return NULL;
-	}
-
-	obj = kmalloc(sizeof(union acpi_object), GFP_KERNEL);
-	if (!obj) {
-		printk(KERN_ERR "Memory allocation error\n");
-		kfree(obj_list);
-		return NULL;
-	}
-
-	buf = kmalloc(12, GFP_KERNEL);
-	if (!buf) {
-		printk(KERN_ERR "Memory allocation error\n");
-		kfree(obj);
-		kfree(obj_list);
-		return NULL;
-	}
-
-	acpi_set_pdc_bits(buf);
-
-	obj->type = ACPI_TYPE_BUFFER;
-	obj->buffer.length = 12;
-	obj->buffer.pointer = (u8 *) buf;
-	obj_list->count = 1;
-	obj_list->pointer = obj;
-
-	return obj_list;
-}
-
-/*
- * _PDC is required for a BIOS-OS handshake for most of the newer
- * ACPI processor features.
- */
-static int
-acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
-{
-	acpi_status status = AE_OK;
-
-	if (idle_nomwait) {
-		/*
-		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
-		 * mode will be disabled in the parameter of _PDC object.
-		 * Of course C1_FFH access mode will also be disabled.
-		 */
-		union acpi_object *obj;
-		u32 *buffer = NULL;
-
-		obj = pdc_in->pointer;
-		buffer = (u32 *)(obj->buffer.pointer);
-		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
-
-	}
-	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
-
-	if (ACPI_FAILURE(status))
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-		    "Could not evaluate _PDC, using legacy perf. control.\n"));
-
-	return status;
-}
-
-static int early_pdc_done;
-
-void acpi_processor_set_pdc(acpi_handle handle)
-{
-	struct acpi_object_list *obj_list;
-
-	if (arch_has_acpi_pdc() == false)
-		return;
-
-	if (early_pdc_done)
-		return;
-
-	obj_list = acpi_processor_alloc_pdc();
-	if (!obj_list)
-		return;
-
-	acpi_processor_eval_pdc(handle, obj_list);
-
-	kfree(obj_list->pointer->buffer.pointer);
-	kfree(obj_list->pointer);
-	kfree(obj_list);
-}
-EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
-
-static int early_pdc_optin;
-static int set_early_pdc_optin(const struct dmi_system_id *id)
-{
-	early_pdc_optin = 1;
-	return 0;
-}
-
-static int param_early_pdc_optin(char *s)
-{
-	early_pdc_optin = 1;
-	return 1;
-}
-__setup("acpi_early_pdc_eval", param_early_pdc_optin);
-
-static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
-	{
-	set_early_pdc_optin, "HP Envy", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Envy") }, NULL},
-	{
-	set_early_pdc_optin, "HP Pavilion dv6", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv6") }, NULL},
-	{
-	set_early_pdc_optin, "HP Pavilion dv7", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv7") }, NULL},
-	{},
-};
-
-static acpi_status
-early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	acpi_processor_set_pdc(handle);
-	return AE_OK;
-}
-
-void __init acpi_early_processor_set_pdc(void)
-{
-	/*
-	 * Check whether the system is DMI table. If yes, OSPM
-	 * should not use mwait for CPU-states.
-	 */
-	dmi_check_system(processor_idle_dmi_table);
-
-	/*
-	 * Allow systems to opt-in to early _PDC evaluation.
-	 */
-	dmi_check_system(early_pdc_optin_table);
-	if (!early_pdc_optin)
-		return;
-
-	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX,
-			    early_init_pdc, NULL, NULL, NULL);
-
-	early_pdc_done = 1;
-}
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 2983176..c642f55 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -320,7 +320,7 @@ static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 
 #endif				/* CONFIG_CPU_FREQ */
 
-/* in processor_pdc.c */
+/* in processor_core.c */
 void acpi_processor_set_pdc(acpi_handle handle);
 
 /* in processor_throttling.c */

