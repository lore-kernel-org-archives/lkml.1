Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbZBKAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbZBKAok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZBKA2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:51 -0500
Received: from kroah.org ([198.145.64.141]:51573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757857AbZBKA2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:48 -0500
Date: Tue, 10 Feb 2009 16:25:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dennis Noordsij <dennis.noordsij@helsinki.fi>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>
Subject: [patch 46/56] ACPICA: Copy dynamically loaded tables to local
	buffer
Message-ID: <20090211002550.GU14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-copy-dynamically-loaded-tables-to-local-buffer.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Dennis Noordsij <dennis.noordsij@helsinki.fi>

commit f0e0da8a6cca44396c7a711e308d58084e881617 upstream.

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
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/executer/exconfig.c |  113 ++++++++++++++++++++++++++++-----------
 1 file changed, 82 insertions(+), 31 deletions(-)

--- a/drivers/acpi/executer/exconfig.c
+++ b/drivers/acpi/executer/exconfig.c
@@ -280,6 +280,7 @@ acpi_ex_load_op(union acpi_operand_objec
 		struct acpi_walk_state *walk_state)
 {
 	union acpi_operand_object *ddb_handle;
+	struct acpi_table_header *table;
 	struct acpi_table_desc table_desc;
 	u32 table_index;
 	acpi_status status;
@@ -294,9 +295,8 @@ acpi_ex_load_op(union acpi_operand_objec
 	switch (ACPI_GET_OBJECT_TYPE(obj_desc)) {
 	case ACPI_TYPE_REGION:
 
-		ACPI_DEBUG_PRINT((ACPI_DB_EXEC, "Load from Region %p %s\n",
-				  obj_desc,
-				  acpi_ut_get_object_type_name(obj_desc)));
+		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
+				  "Load table from Region %p\n", obj_desc));
 
 		/* Region must be system_memory (from ACPI spec) */
 
@@ -316,61 +316,112 @@ acpi_ex_load_op(union acpi_operand_objec
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
@@ -379,7 +430,7 @@ acpi_ex_load_op(union acpi_operand_objec
 	/*
 	 * Add the table to the namespace.
 	 *
-	 * Note: We load the table objects relative to the root of the namespace.
+	 * Note: Load the table objects relative to the root of the namespace.
 	 * This appears to go against the ACPI specification, but we do it for
 	 * compatibility with other ACPI implementations.
 	 */
@@ -415,7 +466,7 @@ acpi_ex_load_op(union acpi_operand_objec
       cleanup:
 	if (ACPI_FAILURE(status)) {
 
-		/* Delete allocated buffer or mapping */
+		/* Delete allocated table buffer */
 
 		acpi_tb_delete_table(&table_desc);
 	}

