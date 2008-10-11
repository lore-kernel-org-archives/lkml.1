Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYJKGz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYJKGz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYJKGjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:47 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYJKGhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:06 -0400
Date: Sat, 11 Oct 2008 02:35:28 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 08/85] ACPICA: Copy dynamically loaded tables to local buffer
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dennis Noordsij <dennis.noordsij@helsinki.fi>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <a4377db47f9b0586f32ed7beddb53c86d5ef422d.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dennis Noordsij <dennis.noordsij@helsinki.fi>

Previously, dynamically loaded tables were simply mapped, but on some machines
this memory is corrupted after suspend. Now copy the table to a local buffer.
For OpRegion case, added checksum verify. Use the table length from the table header,
not the region length. For Buffer case, use the table length also.

http://bugzilla.kernel.org/show_bug.cgi?id=10734

Signed-off-by: Dennis Noordsij <dennis.noordsij@helsinki.fi>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/executer/exconfig.c |  113 +++++++++++++++++++++++++++----------
 1 files changed, 82 insertions(+), 31 deletions(-)

diff --git a/drivers/acpi/executer/exconfig.c b/drivers/acpi/executer/exconfig.c
index 8892b98..331a114 100644
--- a/drivers/acpi/executer/exconfig.c
+++ b/drivers/acpi/executer/exconfig.c
@@ -280,6 +280,7 @@ acpi_ex_load_op(union acpi_operand_object *obj_desc,
 		struct acpi_walk_state *walk_state)
 {
 	union acpi_operand_object *ddb_handle;
+	struct acpi_table_header *table;
 	struct acpi_table_desc table_desc;
 	u32 table_index;
 	acpi_status status;
@@ -294,9 +295,8 @@ acpi_ex_load_op(union acpi_operand_object *obj_desc,
 	switch (ACPI_GET_OBJECT_TYPE(obj_desc)) {
 	case ACPI_TYPE_REGION:
 
-		ACPI_DEBUG_PRINT((ACPI_DB_EXEC, "Load from Region %p %s\n",
-				  obj_desc,
-				  acpi_ut_get_object_type_name(obj_desc)));
+		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
+				  "Load table from Region %p\n", obj_desc));
 
 		/* Region must be system_memory (from ACPI spec) */
 
@@ -316,61 +316,112 @@ acpi_ex_load_op(union acpi_operand_object *obj_desc,
 		}
 
 		/*
-		 * We will simply map the memory region for the table. However, the
-		 * memory region is technically not guaranteed to remain stable and
-		 * we may eventually have to copy the table to a local buffer.
+		 * Map the table header and get the actual table length. The region
+		 * length is not guaranteed to be the same as the table length.
+		 */
+		table = acpi_os_map_memory(obj_desc->region.address,
+					   sizeof(struct acpi_table_header));
+		if (!table) {
+			return_ACPI_STATUS(AE_NO_MEMORY);
+		}
+
+		length = table->length;
+		acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+
+		/* Must have at least an ACPI table header */
+
+		if (length < sizeof(struct acpi_table_header)) {
+			return_ACPI_STATUS(AE_INVALID_TABLE_LENGTH);
+		}
+
+		/*
+		 * The memory region is not guaranteed to remain stable and we must
+		 * copy the table to a local buffer. For example, the memory region
+		 * is corrupted after suspend on some machines. Dynamically loaded
+		 * tables are usually small, so this overhead is minimal.
 		 */
+
+		/* Allocate a buffer for the table */
+
+		table_desc.pointer = ACPI_ALLOCATE(length);
+		if (!table_desc.pointer) {
+			return_ACPI_STATUS(AE_NO_MEMORY);
+		}
+
+		/* Map the entire table and copy it */
+
+		table = acpi_os_map_memory(obj_desc->region.address, length);
+		if (!table) {
+			ACPI_FREE(table_desc.pointer);
+			return_ACPI_STATUS(AE_NO_MEMORY);
+		}
+
+		ACPI_MEMCPY(table_desc.pointer, table, length);
+		acpi_os_unmap_memory(table, length);
+
 		table_desc.address = obj_desc->region.address;
-		table_desc.length = obj_desc->region.length;
-		table_desc.flags = ACPI_TABLE_ORIGIN_MAPPED;
 		break;
 
 	case ACPI_TYPE_BUFFER:	/* Buffer or resolved region_field */
 
 		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-				  "Load from Buffer or Field %p %s\n", obj_desc,
-				  acpi_ut_get_object_type_name(obj_desc)));
-
-		length = obj_desc->buffer.length;
+				  "Load table from Buffer or Field %p\n",
+				  obj_desc));
 
 		/* Must have at least an ACPI table header */
 
-		if (length < sizeof(struct acpi_table_header)) {
+		if (obj_desc->buffer.length < sizeof(struct acpi_table_header)) {
 			return_ACPI_STATUS(AE_INVALID_TABLE_LENGTH);
 		}
 
-		/* Validate checksum here. It won't get validated in tb_add_table */
+		/* Get the actual table length from the table header */
 
-		status =
-		    acpi_tb_verify_checksum(ACPI_CAST_PTR
-					    (struct acpi_table_header,
-					     obj_desc->buffer.pointer), length);
-		if (ACPI_FAILURE(status)) {
-			return_ACPI_STATUS(status);
+		table =
+		    ACPI_CAST_PTR(struct acpi_table_header,
+				  obj_desc->buffer.pointer);
+		length = table->length;
+
+		/* Table cannot extend beyond the buffer */
+
+		if (length > obj_desc->buffer.length) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LIMIT);
+		}
+		if (length < sizeof(struct acpi_table_header)) {
+			return_ACPI_STATUS(AE_INVALID_TABLE_LENGTH);
 		}
 
 		/*
-		 * We need to copy the buffer since the original buffer could be
-		 * changed or deleted in the future
+		 * Copy the table from the buffer because the buffer could be modified
+		 * or even deleted in the future
 		 */
 		table_desc.pointer = ACPI_ALLOCATE(length);
 		if (!table_desc.pointer) {
 			return_ACPI_STATUS(AE_NO_MEMORY);
 		}
 
-		ACPI_MEMCPY(table_desc.pointer, obj_desc->buffer.pointer,
-			    length);
-		table_desc.length = length;
-		table_desc.flags = ACPI_TABLE_ORIGIN_ALLOCATED;
+		ACPI_MEMCPY(table_desc.pointer, table, length);
+		table_desc.address = ACPI_TO_INTEGER(table_desc.pointer);
 		break;
 
 	default:
 		return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
 	}
 
-	/*
-	 * Install the new table into the local data structures
-	 */
+	/* Validate table checksum (will not get validated in tb_add_table) */
+
+	status = acpi_tb_verify_checksum(table_desc.pointer, length);
+	if (ACPI_FAILURE(status)) {
+		ACPI_FREE(table_desc.pointer);
+		return_ACPI_STATUS(status);
+	}
+
+	/* Complete the table descriptor */
+
+	table_desc.length = length;
+	table_desc.flags = ACPI_TABLE_ORIGIN_ALLOCATED;
+
+	/* Install the new table into the local data structures */
+
 	status = acpi_tb_add_table(&table_desc, &table_index);
 	if (ACPI_FAILURE(status)) {
 		goto cleanup;
@@ -379,7 +430,7 @@ acpi_ex_load_op(union acpi_operand_object *obj_desc,
 	/*
 	 * Add the table to the namespace.
 	 *
-	 * Note: We load the table objects relative to the root of the namespace.
+	 * Note: Load the table objects relative to the root of the namespace.
 	 * This appears to go against the ACPI specification, but we do it for
 	 * compatibility with other ACPI implementations.
 	 */
@@ -415,7 +466,7 @@ acpi_ex_load_op(union acpi_operand_object *obj_desc,
       cleanup:
 	if (ACPI_FAILURE(status)) {
 
-		/* Delete allocated buffer or mapping */
+		/* Delete allocated table buffer */
 
 		acpi_tb_delete_table(&table_desc);
 	}
-- 
1.5.5.1

