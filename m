Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYJ3WOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYJ3WOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYJ3WNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:13:22 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:5480 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbYJ3WNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:13:20 -0400
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH v2 2/3] ACPI: Behave uniquely based on processor declaration
	definition type
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Myron Stowe <myron.stowe@hp.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>
Date: Thu, 30 Oct 2008 16:13:19 -0600
Message-ID: <20081030221319.30683.23234.stgit@bob.kio>
In-Reply-To: <20081030215410.30683.95368.stgit@bob.kio>
References: <20081030215410.30683.95368.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Associating a Local SAPIC with a processor object is dependent upon the
processor object's definition type.  CPUs declared as "Processor" should
use the Local SAPIC's 'processor_id', and CPUs declared as "Device"
should use the 'uid'.  Note that for "Processor" declarations, even if a
'_UID' child object exists, it has no bearing with respect to mapping
Local SAPICs (see section 5.2.11.13 - Local SAPIC Structure; "Advanced
Configuration and Power Interface Specification", Revision 3.0b).

This patch changes the lsapic mapping logic to rely on the distinction of
how the processor object was declared - the mapping can't just try both
types of matches irregardless of declaration type and rely on one failing
as is currently being done.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
---

 drivers/acpi/processor_core.c |   75 +++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 0c670dd..35d33e8 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -410,7 +410,7 @@ static int acpi_processor_remove_fs(struct acpi_device *device)
 /* Use the acpiid in MADT to map cpus in case of SMP */
 
 #ifndef CONFIG_SMP
-static int get_cpu_id(acpi_handle handle, u32 acpi_id) {return -1;}
+static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id) { return -1; }
 #else
 
 static struct acpi_table_madt *madt;
@@ -429,27 +429,35 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
 }
 
 static int map_lsapic_id(struct acpi_subtable_header *entry,
-		  u32 acpi_id, int *apic_id)
+		int device_declaration, u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_sapic *lsapic =
 		(struct acpi_madt_local_sapic *)entry;
+	u32 tmp = (lsapic->id << 8) | lsapic->eid;
+
 	/* Only check enabled APICs*/
-	if (lsapic->lapic_flags & ACPI_MADT_ENABLED) {
-		/* First check against id */
-		if (lsapic->processor_id == acpi_id) {
-			*apic_id = (lsapic->id << 8) | lsapic->eid;
-			return 1;
-		/* Check against optional uid */
-		} else if (entry->length >= 16 &&
-			lsapic->uid == acpi_id) {
-			*apic_id = lsapic->uid;
-			return 1;
-		}
-	}
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
 	return 0;
+found:
+	*apic_id = tmp;
+	return 1;
 }
 
-static int map_madt_entry(u32 acpi_id)
+static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
 	int apic_id = -1;
@@ -470,7 +478,7 @@ static int map_madt_entry(u32 acpi_id)
 			if (map_lapic_id(header, acpi_id, &apic_id))
 				break;
 		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-			if (map_lsapic_id(header, acpi_id, &apic_id))
+			if (map_lsapic_id(header, type, acpi_id, &apic_id))
 				break;
 		}
 		entry += header->length;
@@ -478,7 +486,7 @@ static int map_madt_entry(u32 acpi_id)
 	return apic_id;
 }
 
-static int map_mat_entry(acpi_handle handle, u32 acpi_id)
+static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
@@ -501,7 +509,7 @@ static int map_mat_entry(acpi_handle handle, u32 acpi_id)
 	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
 		map_lapic_id(header, acpi_id, &apic_id);
 	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
-		map_lsapic_id(header, acpi_id, &apic_id);
+		map_lsapic_id(header, type, acpi_id, &apic_id);
 	}
 
 exit:
@@ -510,14 +518,14 @@ exit:
 	return apic_id;
 }
 
-static int get_cpu_id(acpi_handle handle, u32 acpi_id)
+static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id)
 {
 	int i;
 	int apic_id = -1;
 
-	apic_id = map_mat_entry(handle, acpi_id);
+	apic_id = map_mat_entry(handle, type, acpi_id);
 	if (apic_id == -1)
-		apic_id = map_madt_entry(acpi_id);
+		apic_id = map_madt_entry(type, acpi_id);
 	if (apic_id == -1)
 		return apic_id;
 
@@ -533,15 +541,16 @@ static int get_cpu_id(acpi_handle handle, u32 acpi_id)
                                  Driver Interface
    -------------------------------------------------------------------------- */
 
-static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
+static int acpi_processor_get_info(struct acpi_device *device)
 {
 	acpi_status status = 0;
 	union acpi_object object = { 0 };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
-	int cpu_index;
+	struct acpi_processor *pr;
+	int cpu_index, device_declaration = 0;
 	static int cpu0_initialized;
 
-
+	pr = acpi_driver_data(device);
 	if (!pr)
 		return -EINVAL;
 
@@ -562,8 +571,11 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "No bus mastering arbitration control\n"));
 
-	/* Check if it is a Device with HID and UID */
-	if (has_uid) {
+	if (!strcmp(acpi_device_hid(device), ACPI_PROCESSOR_HID)) {
+		/*
+		 * Declared with "Device" statement; match _UID.
+		 * Note that we don't handle string _UIDs yet.
+		 */
 		unsigned long long value;
 		status = acpi_evaluate_integer(pr->handle, METHOD_NAME__UID,
 						NULL, &value);
@@ -571,13 +583,10 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
 			printk(KERN_ERR PREFIX "Evaluating processor _UID\n");
 			return -ENODEV;
 		}
+		device_declaration = 1;
 		pr->acpi_id = value;
 	} else {
-		/*
-		* Evalute the processor object.  Note that it is common on SMP to
-		* have the first (boot) processor with a valid PBLK address while
-		* all others have a NULL address.
-		*/
+		/* Declared with "Processor" statement; match ProcessorID */
 		status = acpi_evaluate_object(pr->handle, NULL, NULL, &buffer);
 		if (ACPI_FAILURE(status)) {
 			printk(KERN_ERR PREFIX "Evaluating processor object\n");
@@ -590,7 +599,7 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
 		*/
 		pr->acpi_id = object.processor.proc_id;
 	}
-	cpu_index = get_cpu_id(pr->handle, pr->acpi_id);
+	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);
 
 	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 	if (!cpu0_initialized && (cpu_index == -1) &&
@@ -662,7 +671,7 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
 
 	pr = acpi_driver_data(device);
 
-	result = acpi_processor_get_info(pr, device->flags.unique_id);
+	result = acpi_processor_get_info(device);
 	if (result) {
 		/* Processor is physically not present */
 		return 0;

