Return-Path: <linux-kernel-owner+w=401wt.eu-S932337Ab0ANUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0ANUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573Ab0ANUMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:12:18 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:5455 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab0ANUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:12:17 -0500
Date: Thu, 14 Jan 2010 13:12:14 -0700
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org
Cc: shemminger@linux-foundation.org, ming.m.lin@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: processor: only call _PDC on physically present
	processors
Message-ID: <20100114201214.GH4545@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 78f1699 (ACPI: processor: call _PDC early) blindly walks
the namespace and calls _PDC on every processor object it finds.

Unfortunately, we've discovered at least one BIOS that declares
bogus SSDTs on processors declared in the namespace but not
physically present.

The bogus SSDTs have both an invalid address and invalid length,
both set to something huge (0x80000000).

When the ACPI interpreter executes the Load() op on the bogus
SSDT, we attempt to allocate memory to copy the table; the amount
we try to allocate is determined by the length.

Of course, passing a huge number to the allocator results in
fail, and we get a warning.

The fix is to ensure each processor is physically present before
attempting to call its _PDC method.

Fixes:
	http://bugzilla.kernel.org/show_bug.cgi?id=14954

Reported-and-tested-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ling Min <ming.m.lin@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/acpi/processor_core.c |  163 -------------------------------------
 drivers/acpi/processor_pdc.c  |  183 ++++++++++++++++++++++++++++++++++++++++++
 include/acpi/processor.h      |    8 +
 3 files changed, 192 insertions(+), 162 deletions(-)
---
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 9863c98..11a51cc 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -357,162 +357,6 @@ static inline int acpi_processor_remove_fs(struct acpi_device *device)
 }
 #endif
 
-/* Use the acpiid in MADT to map cpus in case of SMP */
-
-#ifndef CONFIG_SMP
-static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id) { return -1; }
-#else
-
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
-static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id)
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
-#endif
-
 /* --------------------------------------------------------------------------
                                  Driver Interface
    -------------------------------------------------------------------------- */
@@ -577,7 +421,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		device_declaration = 1;
 		pr->acpi_id = value;
 	}
-	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);
+	cpu_index = acpi_get_cpuid(pr->handle, device_declaration, pr->acpi_id);
 
 	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 	if (!cpu0_initialized && (cpu_index == -1) &&
@@ -1071,11 +915,6 @@ static int __init acpi_processor_init(void)
 
 	memset(&errata, 0, sizeof(errata));
 
-#ifdef CONFIG_SMP
-	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
-				(struct acpi_table_header **)&madt)))
-		madt = NULL;
-#endif
 #ifdef CONFIG_ACPI_PROCFS
 	acpi_processor_dir = proc_mkdir(ACPI_PROCESSOR_CLASS, acpi_root_dir);
 	if (!acpi_processor_dir)
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 30e4dc0..9da0635 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -42,6 +42,186 @@ static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 	{},
 };
 
+#ifdef CONFIG_SMP
+static int map_lapic_id(struct acpi_subtable_header *entry,
+		 u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_apic *lapic;
+
+	lapic = (struct acpi_madt_local_apic *)entry;
+	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (lapic->processor_id != acpi_id)
+		return 0;
+
+	*apic_id = lapic->id;
+	return 1;
+}
+
+static int map_x2apic_id(struct acpi_subtable_header *entry,
+			 int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_x2apic *lx2apic;
+
+	lx2apic = (struct acpi_madt_local_x2apic *)entry;
+	if (!(lx2apic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (!device_declaration || (lx2apic->uid != acpi_id))
+		return 0;
+
+	*apic_id = lx2apic->local_apic_id;
+	return 1;
+}
+
+static int map_lsapic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_local_sapic *lsapic;
+
+	lsapic = (struct acpi_madt_local_sapic *)entry;
+	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	if (device_declaration) {
+		if ((entry->length < 16) || (lsapic->uid != acpi_id))
+			return 0;
+	} else if (lsapic->processor_id != acpi_id)
+			return 0;
+
+	*apic_id = (lsapic->id << 8) | lsapic->eid;
+	return 1;
+}
+
+static int map_madt_entry(int type, u32 acpi_id)
+{
+	unsigned long madt_end, entry;
+	struct acpi_subtable_header *header;
+	static struct acpi_table_madt *madt;
+	static int read_madt;
+	int apic_id = -1;
+
+	if (!read_madt) {
+		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_MADT, 0,
+					(struct acpi_table_header **)&madt)))
+			madt = NULL;
+		read_madt++;
+	}
+
+	if (!madt)
+		return apic_id;
+
+	entry = (unsigned long)madt;
+	madt_end = entry + madt->header.length;
+
+	entry += sizeof(struct acpi_table_madt);
+	while (entry + sizeof(struct acpi_subtable_header) < madt_end) {
+		header = (struct acpi_subtable_header *)entry;
+
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
+	    obj->buffer.length < sizeof(struct acpi_subtable_header))
+		goto exit;
+
+	header = (struct acpi_subtable_header *)obj->buffer.pointer;
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
+		map_lapic_id(header, acpi_id, &apic_id);
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
+		map_lsapic_id(header, type, acpi_id, &apic_id);
+
+exit:
+	kfree(buffer.pointer);
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
+	for_each_possible_cpu(i)
+		if (cpu_physical_id(i) == apic_id)
+			return i;
+	return -1;
+}
+EXPORT_SYMBOL_GPL(acpi_get_cpuid);
+#endif
+
+static bool processor_physically_present(acpi_handle handle)
+{
+	int cpuid, type;
+	u32 acpi_id;
+	acpi_status status;
+	acpi_object_type acpi_type;
+	unsigned long long tmp;
+	union acpi_object object = { 0 };
+	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
+
+	status = acpi_get_type(handle, &acpi_type);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	switch (acpi_type) {
+	case ACPI_TYPE_PROCESSOR:
+		status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = object.processor.proc_id;
+		break;
+	case ACPI_TYPE_DEVICE:
+		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = tmp;
+		break;
+	default:
+		return false;
+	}
+
+	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
+	cpuid = acpi_get_cpuid(handle, type, acpi_id);
+
+	if (cpuid == -1)
+		return false;
+
+	return true;
+}
+
 static void acpi_set_pdc_bits(u32 *buf)
 {
 	buf[0] = ACPI_PDC_REVISION_ID;
@@ -147,6 +327,9 @@ EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
 static acpi_status
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
+	if (processor_physically_present(handle) == false)
+		return AE_OK;
+
 	acpi_processor_set_pdc(handle);
 	return AE_OK;
 }
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 0ea5ef4..71901a5 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -322,6 +322,14 @@ static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 
 /* in processor_pdc.c */
 void acpi_processor_set_pdc(acpi_handle handle);
+#ifdef CONFIG_SMP
+int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
+#else
+static inline int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id)
+{
+	return -1;
+}
+#endif
 
 /* in processor_throttling.c */
 int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
