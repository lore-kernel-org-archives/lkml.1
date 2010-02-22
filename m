Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0BVTLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:52 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30903 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0BVTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:45 -0500
Subject: [PATCH v2 04/12] ACPI: processor: move acpi_get_cpuid into
	processor_core.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:11:24 -0700
Message-ID: <20100222191124.19752.25542.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enumerating processors (via MADT/_MAT) belongs in the processor core,
which is always built-in, rather than living in the processor driver
which may not be built.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c   |  160 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_driver.c |  159 ---------------------------------------
 2 files changed, 160 insertions(+), 159 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 6f376bf..9ae5cc2 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -42,6 +42,159 @@ static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 	{},
 };
 
+#ifdef CONFIG_SMP
+static struct acpi_table_madt *madt;
+
+static int map_lapic_id(struct acpi_subtable_header *entry,
+		 u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_apic *lapic =
+		(struct acpi_madt_local_apic *)entry;
+	if ((lapic->lapic_flags & ACPI_MADT_ENABLED) &&
+	    lapic->processor_id == acpi_id) {
+		*apic_id = lapic->id;
+		return 1;
+	}
+	return 0;
+}
+
+static int map_x2apic_id(struct acpi_subtable_header *entry,
+			 int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_x2apic *apic =
+		(struct acpi_madt_local_x2apic *)entry;
+	u32 tmp = apic->local_apic_id;
+
+	/* Only check enabled APICs*/
+	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	/* Device statement declaration type */
+	if (device_declaration) {
+		if (apic->uid == acpi_id)
+			goto found;
+	}
+
+	return 0;
+found:
+	*apic_id = tmp;
+	return 1;
+}
+
+static int map_lsapic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_sapic *lsapic =
+		(struct acpi_madt_local_sapic *)entry;
+	u32 tmp = (lsapic->id << 8) | lsapic->eid;
+
+	/* Only check enabled APICs*/
+	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	/* Device statement declaration type */
+	if (device_declaration) {
+		if (entry->length < 16)
+			printk(KERN_ERR PREFIX
+			    "Invalid LSAPIC with Device type processor (SAPIC ID %#x)\n",
+			    tmp);
+		else if (lsapic->uid == acpi_id)
+			goto found;
+	/* Processor statement declaration type */
+	} else if (lsapic->processor_id == acpi_id)
+		goto found;
+
+	return 0;
+found:
+	*apic_id = tmp;
+	return 1;
+}
+
+static int map_madt_entry(int type, u32 acpi_id)
+{
+	unsigned long madt_end, entry;
+	int apic_id = -1;
+
+	if (!madt)
+		return apic_id;
+
+	entry = (unsigned long)madt;
+	madt_end = entry + madt->header.length;
+
+	/* Parse all entries looking for a match. */
+
+	entry += sizeof(struct acpi_table_madt);
+	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
+		struct acpi_subtable_header *header =
+			(struct acpi_subtable_header *)entry;
+		if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+			if (map_lapic_id(header, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+			if (map_x2apic_id(header, type, acpi_id, &apic_id))
+				break;
+		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+			if (map_lsapic_id(header, type, acpi_id, &apic_id))
+				break;
+		}
+		entry += header->length;
+	}
+	return apic_id;
+}
+
+static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	struct acpi_subtable_header *header;
+	int apic_id = -1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
+		goto exit;
+
+	if (!buffer.length || !buffer.pointer)
+		goto exit;
+
+	obj = buffer.pointer;
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(struct acpi_subtable_header)) {
+		goto exit;
+	}
+
+	header = (struct acpi_subtable_header *)obj->buffer.pointer;
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+		map_lapic_id(header, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+		map_lsapic_id(header, type, acpi_id, &apic_id);
+	}
+
+exit:
+	if (buffer.pointer)
+		kfree(buffer.pointer);
+	return apic_id;
+}
+
+int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+{
+	int i;
+	int apic_id = -1;
+
+	apic_id = map_mat_entry(handle, type, acpi_id);
+	if (apic_id == -1)
+		apic_id = map_madt_entry(type, acpi_id);
+	if (apic_id == -1)
+		return apic_id;
+
+	for_each_possible_cpu(i) {
+		if (cpu_physical_id(i) == apic_id)
+			return i;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(acpi_get_cpuid);
+#endif
+
+
 static void acpi_set_pdc_bits(u32 *buf)
 {
 	buf[0] = ACPI_PDC_REVISION_ID;
@@ -188,6 +341,13 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 void __init acpi_early_processor_set_pdc(void)
 {
+
+#ifdef CONFIG_SMP
+	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
+				(struct acpi_table_header **)&madt)))
+		madt = NULL;
+#endif
+
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
 	 * should not use mwait for CPU-states.
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 404fab4..777d046 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -357,160 +357,6 @@ static inline int acpi_processor_remove_fs(struct acpi_device *device)
 }
 #endif
 
-/* Use the acpiid in MADT to map cpus in case of SMP */
-
-#ifdef CONFIG_SMP
-static struct acpi_table_madt *madt;
-
-static int map_lapic_id(struct acpi_subtable_header *entry,
-		 u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_apic *lapic =
-		(struct acpi_madt_local_apic *)entry;
-	if ((lapic->lapic_flags & ACPI_MADT_ENABLED) &&
-	    lapic->processor_id == acpi_id) {
-		*apic_id = lapic->id;
-		return 1;
-	}
-	return 0;
-}
-
-static int map_x2apic_id(struct acpi_subtable_header *entry,
-			 int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_x2apic *apic =
-		(struct acpi_madt_local_x2apic *)entry;
-	u32 tmp = apic->local_apic_id;
-
-	/* Only check enabled APICs*/
-	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
-		return 0;
-
-	/* Device statement declaration type */
-	if (device_declaration) {
-		if (apic->uid == acpi_id)
-			goto found;
-	}
-
-	return 0;
-found:
-	*apic_id = tmp;
-	return 1;
-}
-
-static int map_lsapic_id(struct acpi_subtable_header *entry,
-		int device_declaration, u32 acpi_id, int *apic_id)
-{
-	struct acpi_madt_local_sapic *lsapic =
-		(struct acpi_madt_local_sapic *)entry;
-	u32 tmp = (lsapic->id << 8) | lsapic->eid;
-
-	/* Only check enabled APICs*/
-	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
-		return 0;
-
-	/* Device statement declaration type */
-	if (device_declaration) {
-		if (entry->length < 16)
-			printk(KERN_ERR PREFIX
-			    "Invalid LSAPIC with Device type processor (SAPIC ID %#x)\n",
-			    tmp);
-		else if (lsapic->uid == acpi_id)
-			goto found;
-	/* Processor statement declaration type */
-	} else if (lsapic->processor_id == acpi_id)
-		goto found;
-
-	return 0;
-found:
-	*apic_id = tmp;
-	return 1;
-}
-
-static int map_madt_entry(int type, u32 acpi_id)
-{
-	unsigned long madt_end, entry;
-	int apic_id = -1;
-
-	if (!madt)
-		return apic_id;
-
-	entry = (unsigned long)madt;
-	madt_end = entry + madt->header.length;
-
-	/* Parse all entries looking for a match. */
-
-	entry += sizeof(struct acpi_table_madt);
-	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
-		struct acpi_subtable_header *header =
-			(struct acpi_subtable_header *)entry;
-		if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
-			if (map_lapic_id(header, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
-			if (map_x2apic_id(header, type, acpi_id, &apic_id))
-				break;
-		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-			if (map_lsapic_id(header, type, acpi_id, &apic_id))
-				break;
-		}
-		entry += header->length;
-	}
-	return apic_id;
-}
-
-static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
-{
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
-	struct acpi_subtable_header *header;
-	int apic_id = -1;
-
-	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
-		goto exit;
-
-	if (!buffer.length || !buffer.pointer)
-		goto exit;
-
-	obj = buffer.pointer;
-	if (obj->type != ACPI_TYPE_BUFFER ||
-	    obj->buffer.length < sizeof(struct acpi_subtable_header)) {
-		goto exit;
-	}
-
-	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
-		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-		map_lsapic_id(header, type, acpi_id, &apic_id);
-	}
-
-exit:
-	if (buffer.pointer)
-		kfree(buffer.pointer);
-	return apic_id;
-}
-
-int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
-{
-	int i;
-	int apic_id = -1;
-
-	apic_id = map_mat_entry(handle, type, acpi_id);
-	if (apic_id == -1)
-		apic_id = map_madt_entry(type, acpi_id);
-	if (apic_id == -1)
-		return apic_id;
-
-	for_each_possible_cpu(i) {
-		if (cpu_physical_id(i) == apic_id)
-			return i;
-	}
-	return -1;
-}
-EXPORT_SYMBOL_GPL(acpi_get_cpuid);
-#endif
-
 /* --------------------------------------------------------------------------
                                  Driver Interface
    -------------------------------------------------------------------------- */
@@ -1069,11 +915,6 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
-#ifdef CONFIG_SMP
-	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
-				(struct acpi_table_header **)&madt)))
-		madt = NULL;
-#endif
 #ifdef CONFIG_ACPI_PROCFS
 	acpi_processor_dir = proc_mkdir(ACPI_PROCESSOR_CLASS, acpi_root_dir);
 	if (!acpi_processor_dir)

