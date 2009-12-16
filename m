Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbZLPBNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbZLPBNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934390AbZLPBNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:13:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:9537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934343AbZLPBNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,402,1257148800"; 
   d="scan'208,223";a="476486056"
Subject: Re: [REGRESSION] 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7 causes
 boot hang
From: Lin Ming <ming.m.lin@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091215181538.GA28707@srcf.ucam.org>
References: <20091215181538.GA28707@srcf.ucam.org>
Content-Type: multipart/mixed; boundary="=-q3IHO5iSQolxuIANUMA5"
Date: Wed, 16 Dec 2009 08:57:20 +0800
Message-Id: <1260925040.3834.69.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q3IHO5iSQolxuIANUMA5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2009-12-16 at 02:15 +0800, Matthew Garrett wrote:
> Commit 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7 (ACPICA: Add additional 
> module-level code support) results in one of my test machines hanging at 
> boot. The last line output is:
> 
> bio: create slab <bio-0> at 0
> 
> which would normally be followed by
> 
> ACPI: EC: Look up EC in DSDT
> 
> but instead the machine hangs without printing this line. Reverting the 
> commit results in the machine booting. acpidump output attached.
> 

Hi, Matthew

Could you try the attached ACPICA latest release (20091214) patch
series? There are module level code and _REG method fixes included in
it.

Checkout Linus' tree.
git am acpica-v20091214.patch

Thanks,
Lin Ming


--=-q3IHO5iSQolxuIANUMA5
Content-Disposition: attachment; filename="acpica-v20091214.patch"
Content-Type: text/x-patch; name="acpica-v20091214.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 31f202a1b06e817c08e45d9f2313ca6713ee22a8 Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Fri, 11 Dec 2009 14:36:47 +0800
Subject: [PATCH 01/16] ACPICA: Fix possible memory leak for module-level code execution

An object can be leaked for each block of executed module-level
code if the interpreter slack mode is enabled. The change deletes
any implicitly returned object in this case.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/nseval.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpica/nseval.c b/drivers/acpi/acpica/nseval.c
index f771e97..65e0d1a 100644
--- a/drivers/acpi/acpica/nseval.c
+++ b/drivers/acpi/acpica/nseval.c
@@ -415,6 +415,12 @@ acpi_ns_exec_module_code(union acpi_operand_object *method_obj,
 	ACPI_DEBUG_PRINT((ACPI_DB_INIT, "Executed module-level code at %p\n",
 			  method_obj->method.aml_start));
 
+	/* Delete a possible implicit return value (in slack mode) */
+
+	if (info->return_object) {
+		acpi_ut_remove_reference(info->return_object);
+	}
+
 	/* Detach the temporary method object */
 
 	acpi_ns_detach_object(parent_node);

>From f145ca7c01ff3839e95afbe00c2f6eca007b0a2f Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 14:38:08 +0800
Subject: [PATCH 02/16] ACPICA: Fix two Scope type error messages

Both messages incorrectly used the internal Path string instead
of the node name.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/dswload.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 10fc785..1bab934 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -212,18 +212,19 @@ acpi_ds_load1_begin_op(struct acpi_walk_state * walk_state,
 		case ACPI_TYPE_BUFFER:
 
 			/*
-			 * These types we will allow, but we will change the type. This
-			 * enables some existing code of the form:
+			 * These types we will allow, but we will change the type.
+			 * This enables some existing code of the form:
 			 *
 			 *  Name (DEB, 0)
 			 *  Scope (DEB) { ... }
 			 *
-			 * Note: silently change the type here. On the second pass, we will report
-			 * a warning
+			 * Note: silently change the type here. On the second pass,
+			 * we will report a warning
 			 */
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "Type override - [%4.4s] had invalid type (%s) for Scope operator, changed to (Scope)\n",
-					  path,
+					  "Type override - [%4.4s] had invalid type (%s) "
+					  "for Scope operator, changed to type ANY\n",
+					  acpi_ut_get_node_name(node),
 					  acpi_ut_get_type_name(node->type)));
 
 			node->type = ACPI_TYPE_ANY;
@@ -235,8 +236,10 @@ acpi_ds_load1_begin_op(struct acpi_walk_state * walk_state,
 			/* All other types are an error */
 
 			ACPI_ERROR((AE_INFO,
-				    "Invalid type (%s) for target of Scope operator [%4.4s] (Cannot override)",
-				    acpi_ut_get_type_name(node->type), path));
+				    "Invalid type (%s) for target of "
+				    "Scope operator [%4.4s] (Cannot override)",
+				    acpi_ut_get_type_name(node->type),
+				    acpi_ut_get_node_name(node)));
 
 			return_ACPI_STATUS(AE_AML_OPERAND_TYPE);
 		}

>From 3634ce47ec96ff8f454ebe31a4e77e1251eb9d05 Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 14:40:17 +0800
Subject: [PATCH 03/16] ACPICA: Fix two additional Scope override error messages

These messages were using the internal path for the message
instead of using the node name.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/dswload.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 1bab934..9cc2289 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -700,15 +700,16 @@ acpi_ds_load2_begin_op(struct acpi_walk_state *walk_state,
 		case ACPI_TYPE_BUFFER:
 
 			/*
-			 * These types we will allow, but we will change the type. This
-			 * enables some existing code of the form:
+			 * These types we will allow, but we will change the type.
+			 * This enables some existing code of the form:
 			 *
 			 *  Name (DEB, 0)
 			 *  Scope (DEB) { ... }
 			 */
 			ACPI_WARNING((AE_INFO,
-				      "Type override - [%4.4s] had invalid type (%s) for Scope operator, changed to (Scope)",
-				      buffer_ptr,
+				      "Type override - [%4.4s] had invalid type (%s) "
+				      "for Scope operator, changed to type ANY\n",
+				      acpi_ut_get_node_name(node),
 				      acpi_ut_get_type_name(node->type)));
 
 			node->type = ACPI_TYPE_ANY;
@@ -720,9 +721,10 @@ acpi_ds_load2_begin_op(struct acpi_walk_state *walk_state,
 			/* All other types are an error */
 
 			ACPI_ERROR((AE_INFO,
-				    "Invalid type (%s) for target of Scope operator [%4.4s]",
+				    "Invalid type (%s) for target of "
+				    "Scope operator [%4.4s] (Cannot override)",
 				    acpi_ut_get_type_name(node->type),
-				    buffer_ptr));
+				    acpi_ut_get_node_name(node)));
 
 			return (AE_AML_OPERAND_TYPE);
 		}

>From ae4beff87110c192d5490b49c7d9eb08af350164 Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 14:53:11 +0800
Subject: [PATCH 04/16] ACPICA: Add repair for bad _FDE/_GTM buffers

The expected return value for both names is a Buffer of 5 DWORDS.
This repair fixes two possible problems (both seen in the field):
A package of integers is returned, or a buffer of BYTEs is returned.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nspredef.c  |   14 ++--
 drivers/acpi/acpica/nsrepair2.c |  149 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 152 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index b05f429..1782c3d 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -222,23 +222,21 @@ acpi_ns_check_predefined_names(struct acpi_namespace_node *node,
 	status = acpi_ns_check_object_type(data, return_object_ptr,
 					   predefined->info.expected_btypes,
 					   ACPI_NOT_PACKAGE_ELEMENT);
-	if (ACPI_FAILURE(status)) {
-		goto check_validation_status;
-	}
+	if (ACPI_SUCCESS(status)) {
 
-	/* For returned Package objects, check the type of all sub-objects */
+		/* For returned Package objects, check the type of all sub-objects */
 
-	if (return_object->common.type == ACPI_TYPE_PACKAGE) {
-		status = acpi_ns_check_package(data, return_object_ptr);
+		if (return_object->common.type == ACPI_TYPE_PACKAGE) {
+			status = acpi_ns_check_package(data, return_object_ptr);
+		}
 	}
 
 	/*
 	 * Perform additional, more complicated repairs on a per-name
-	 * basis.
+	 * basis. Do this regardless of the status from above.
 	 */
 	status = acpi_ns_complex_repairs(data, node, status, return_object_ptr);
 
-check_validation_status:
 	/*
 	 * If the object validation failed or if we successfully repaired one
 	 * or more objects, mark the parent node to suppress further warning
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index d07b686..6c35b57 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -74,6 +74,10 @@ acpi_ns_repair_ALR(struct acpi_predefined_data *data,
 		   union acpi_operand_object **return_object_ptr);
 
 static acpi_status
+acpi_ns_repair_FDE(struct acpi_predefined_data *data,
+		   union acpi_operand_object **return_object_ptr);
+
+static acpi_status
 acpi_ns_repair_PSS(struct acpi_predefined_data *data,
 		   union acpi_operand_object **return_object_ptr);
 
@@ -104,17 +108,27 @@ acpi_ns_sort_list(union acpi_operand_object **elements,
  * This table contains the names of the predefined methods for which we can
  * perform more complex repairs.
  *
- * _ALR: Sort the list ascending by ambient_illuminance if necessary
- * _PSS: Sort the list descending by Power if necessary
- * _TSS: Sort the list descending by Power if necessary
+ * As necessary:
+ *
+ * _ALR: Sort the list ascending by ambient_illuminance
+ * _FDE: Convert a Package or Buffer of BYTEs to a Buffer of DWORDs
+ * _GTM: Convert a Package or Buffer of BYTEs to a Buffer of DWORDs
+ * _PSS: Sort the list descending by Power
+ * _TSS: Sort the list descending by Power
  */
 static const struct acpi_repair_info acpi_ns_repairable_names[] = {
 	{"_ALR", acpi_ns_repair_ALR},
+	{"_FDE", acpi_ns_repair_FDE},
+	{"_GTM", acpi_ns_repair_FDE},	/* _GTM has same repair as _FDE */
 	{"_PSS", acpi_ns_repair_PSS},
 	{"_TSS", acpi_ns_repair_TSS},
 	{{0, 0, 0, 0}, NULL}	/* Table terminator */
 };
 
+#define ACPI_FDE_FIELD_COUNT        5
+#define ACPI_FDE_BYTE_BUFFER_SIZE   5
+#define ACPI_FDE_DWORD_BUFFER_SIZE  (ACPI_FDE_FIELD_COUNT * sizeof (u32))
+
 /******************************************************************************
  *
  * FUNCTION:    acpi_ns_complex_repairs
@@ -215,6 +229,135 @@ acpi_ns_repair_ALR(struct acpi_predefined_data *data,
 
 /******************************************************************************
  *
+ * FUNCTION:    acpi_ns_repair_FDE
+ *
+ * PARAMETERS:  Data                - Pointer to validation data structure
+ *              return_object_ptr   - Pointer to the object returned from the
+ *                                    evaluation of a method or object
+ *
+ * RETURN:      Status. AE_OK if object is OK or was repaired successfully
+ *
+ * DESCRIPTION: Repair for the _FDE and _GTM objects. The expected return
+ *              value is a Buffer of 5 DWORDs. This function repairs two
+ *              possible problems:
+ *              1) The return value is a Buffer of BYTEs, not DWORDs
+ *              2) The return value is a Package of Integer objects
+ *
+ *****************************************************************************/
+
+static acpi_status
+acpi_ns_repair_FDE(struct acpi_predefined_data *data,
+		   union acpi_operand_object **return_object_ptr)
+{
+	union acpi_operand_object *return_object = *return_object_ptr;
+	union acpi_operand_object **elements;
+	union acpi_operand_object *buffer_object;
+	u8 *byte_buffer;
+	u32 *dword_buffer;
+	u32 count;
+	u32 i;
+
+	switch (return_object->common.type) {
+	case ACPI_TYPE_BUFFER:
+
+		/* This is the expected type. Length should be (at least) 5 DWORDs */
+
+		if (return_object->buffer.length >= ACPI_FDE_DWORD_BUFFER_SIZE) {
+			return (AE_OK);
+		}
+
+		/* We can only repair if we have exactly 5 BYTEs */
+
+		if (return_object->buffer.length != ACPI_FDE_BYTE_BUFFER_SIZE) {
+			ACPI_WARN_PREDEFINED((AE_INFO, data->pathname,
+					      data->node_flags,
+					      "Incorrect return buffer length %u, expected %u",
+					      return_object->buffer.length,
+					      ACPI_FDE_DWORD_BUFFER_SIZE));
+
+			return (AE_AML_OPERAND_TYPE);
+		}
+
+		/* Create the new (larger) buffer object */
+
+		buffer_object =
+		    acpi_ut_create_buffer_object(ACPI_FDE_DWORD_BUFFER_SIZE);
+		if (!buffer_object) {
+			return (AE_NO_MEMORY);
+		}
+
+		/* Expand each byte to a DWORD */
+
+		byte_buffer = return_object->buffer.pointer;
+		dword_buffer =
+		    ACPI_CAST_PTR(u32, buffer_object->buffer.pointer);
+
+		for (i = 0; i < ACPI_FDE_FIELD_COUNT; i++) {
+			*dword_buffer = (u32) *byte_buffer;
+			dword_buffer++;
+			byte_buffer++;
+		}
+
+		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
+				      "Expanded Byte Buffer to expected DWord Buffer"));
+		break;
+
+	case ACPI_TYPE_PACKAGE:
+
+		/* All elements of the Package must be integers */
+
+		elements = return_object->package.elements;
+		count =
+		    ACPI_MIN(ACPI_FDE_FIELD_COUNT,
+			     return_object->package.count);
+
+		for (i = 0; i < count; i++) {
+			if ((!*elements) ||
+			    ((*elements)->common.type != ACPI_TYPE_INTEGER)) {
+				return (AE_AML_OPERAND_TYPE);
+			}
+			elements++;
+		}
+
+		/* Create the new buffer object to replace the Package */
+
+		buffer_object =
+		    acpi_ut_create_buffer_object(ACPI_FDE_DWORD_BUFFER_SIZE);
+		if (!buffer_object) {
+			return (AE_NO_MEMORY);
+		}
+
+		/* Copy the package elements (integers) to the buffer */
+
+		elements = return_object->package.elements;
+		dword_buffer =
+		    ACPI_CAST_PTR(u32, buffer_object->buffer.pointer);
+
+		for (i = 0; i < count; i++) {
+			*dword_buffer = (u32) (*elements)->integer.value;
+			dword_buffer++;
+			elements++;
+		}
+
+		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
+				      "Converted Package to expected Buffer"));
+		break;
+
+	default:
+		return (AE_AML_OPERAND_TYPE);
+	}
+
+	/* Delete the original return object, return the new buffer object */
+
+	acpi_ut_remove_reference(return_object);
+	*return_object_ptr = buffer_object;
+
+	data->flags |= ACPI_OBJECT_REPAIRED;
+	return (AE_OK);
+}
+
+/******************************************************************************
+ *
  * FUNCTION:    acpi_ns_repair_TSS
  *
  * PARAMETERS:  Data                - Pointer to validation data structure

>From a70077c65a8a587c34e69d620ef6af05a23615e7 Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 14:57:00 +0800
Subject: [PATCH 05/16] ACPICA: Update internal namespace node/handle interfaces

This change deletes the unnecessary acpi_ns_convert_entry_to_handle
interface and renames the acpi_ns_map_handle_to_node interface to
acpi_ns_validate_handle.  ACPICA BZ 798.

http://www.acpica.org/bugzilla/show_bug.cgi?id=798

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/acnamesp.h |    4 +--
 drivers/acpi/acpica/evregion.c |    4 +-
 drivers/acpi/acpica/evxface.c  |    4 +-
 drivers/acpi/acpica/evxfevnt.c |    4 +-
 drivers/acpi/acpica/evxfregn.c |    4 +-
 drivers/acpi/acpica/nsdump.c   |    2 +-
 drivers/acpi/acpica/nsnames.c  |    2 +-
 drivers/acpi/acpica/nsutils.c  |   57 +++++++--------------------------------
 drivers/acpi/acpica/nsxfeval.c |   10 +++---
 drivers/acpi/acpica/nsxfname.c |   10 +++---
 drivers/acpi/acpica/nsxfobj.c  |   14 +++++-----
 drivers/acpi/acpica/rsxface.c  |    2 +-
 12 files changed, 40 insertions(+), 77 deletions(-)

diff --git a/drivers/acpi/acpica/acnamesp.h b/drivers/acpi/acpica/acnamesp.h
index ab83919..14cef45 100644
--- a/drivers/acpi/acpica/acnamesp.h
+++ b/drivers/acpi/acpica/acnamesp.h
@@ -354,9 +354,7 @@ acpi_ns_externalize_name(u32 internal_name_length,
 			 const char *internal_name,
 			 u32 * converted_name_length, char **converted_name);
 
-struct acpi_namespace_node *acpi_ns_map_handle_to_node(acpi_handle handle);
-
-acpi_handle acpi_ns_convert_entry_to_handle(struct acpi_namespace_node *node);
+struct acpi_namespace_node *acpi_ns_validate_handle(acpi_handle handle);
 
 void acpi_ns_terminate(void);
 
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 0bc807c..5336d91 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -718,7 +718,7 @@ acpi_ev_install_handler(acpi_handle obj_handle,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	if (!node) {
 		return (AE_BAD_PARAMETER);
 	}
@@ -1087,7 +1087,7 @@ acpi_ev_reg_run(acpi_handle obj_handle,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	if (!node) {
 		return (AE_BAD_PARAMETER);
 	}
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 10b8543..2fe0809 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -259,7 +259,7 @@ acpi_install_notify_handler(acpi_handle device,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(device);
+	node = acpi_ns_validate_handle(device);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -425,7 +425,7 @@ acpi_remove_notify_handler(acpi_handle device,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(device);
+	node = acpi_ns_validate_handle(device);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
index 4721f58..eed7a38 100644
--- a/drivers/acpi/acpica/evxfevnt.c
+++ b/drivers/acpi/acpica/evxfevnt.c
@@ -610,7 +610,7 @@ acpi_install_gpe_block(acpi_handle gpe_device,
 		return (status);
 	}
 
-	node = acpi_ns_map_handle_to_node(gpe_device);
+	node = acpi_ns_validate_handle(gpe_device);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -698,7 +698,7 @@ acpi_status acpi_remove_gpe_block(acpi_handle gpe_device)
 		return (status);
 	}
 
-	node = acpi_ns_map_handle_to_node(gpe_device);
+	node = acpi_ns_validate_handle(gpe_device);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index 7c3d2d3..c98aa7c 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -89,7 +89,7 @@ acpi_install_address_space_handler(acpi_handle device,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(device);
+	node = acpi_ns_validate_handle(device);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -155,7 +155,7 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 	/* Convert and validate the device handle */
 
-	node = acpi_ns_map_handle_to_node(device);
+	node = acpi_ns_validate_handle(device);
 	if (!node ||
 	    ((node->type != ACPI_TYPE_DEVICE) &&
 	     (node->type != ACPI_TYPE_PROCESSOR) &&
diff --git a/drivers/acpi/acpica/nsdump.c b/drivers/acpi/acpica/nsdump.c
index 2deb986..e37836e 100644
--- a/drivers/acpi/acpica/nsdump.c
+++ b/drivers/acpi/acpica/nsdump.c
@@ -180,7 +180,7 @@ acpi_ns_dump_one_object(acpi_handle obj_handle,
 		return (AE_OK);
 	}
 
-	this_node = acpi_ns_map_handle_to_node(obj_handle);
+	this_node = acpi_ns_validate_handle(obj_handle);
 	if (!this_node) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Invalid object handle %p\n",
 				  obj_handle));
diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index af8e6bc..8f9a487 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -232,7 +232,7 @@ acpi_ns_handle_to_pathname(acpi_handle target_handle,
 
 	ACPI_FUNCTION_TRACE_PTR(ns_handle_to_pathname, target_handle);
 
-	node = acpi_ns_map_handle_to_node(target_handle);
+	node = acpi_ns_validate_handle(target_handle);
 	if (!node) {
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
diff --git a/drivers/acpi/acpica/nsutils.c b/drivers/acpi/acpica/nsutils.c
index ea55ab4..47d91e6 100644
--- a/drivers/acpi/acpica/nsutils.c
+++ b/drivers/acpi/acpica/nsutils.c
@@ -671,24 +671,25 @@ acpi_ns_externalize_name(u32 internal_name_length,
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ns_map_handle_to_node
+ * FUNCTION:    acpi_ns_validate_handle
  *
- * PARAMETERS:  Handle          - Handle to be converted to an Node
+ * PARAMETERS:  Handle          - Handle to be validated and typecast to a
+ *                                namespace node.
  *
- * RETURN:      A Name table entry pointer
+ * RETURN:      A pointer to a namespace node
  *
- * DESCRIPTION: Convert a namespace handle to a real Node
+ * DESCRIPTION: Convert a namespace handle to a namespace node. Handles special
+ *              cases for the root node.
  *
- * Note: Real integer handles would allow for more verification
+ * NOTE: Real integer handles would allow for more verification
  *       and keep all pointers within this subsystem - however this introduces
- *       more (and perhaps unnecessary) overhead.
- *
- * The current implemenation is basically a placeholder until such time comes
- * that it is needed.
+ *       more overhead and has not been necessary to this point. Drivers
+ *       holding handles are typically notified before a node becomes invalid
+ *       due to a table unload.
  *
  ******************************************************************************/
 
-struct acpi_namespace_node *acpi_ns_map_handle_to_node(acpi_handle handle)
+struct acpi_namespace_node *acpi_ns_validate_handle(acpi_handle handle)
 {
 
 	ACPI_FUNCTION_ENTRY();
@@ -710,42 +711,6 @@ struct acpi_namespace_node *acpi_ns_map_handle_to_node(acpi_handle handle)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ns_convert_entry_to_handle
- *
- * PARAMETERS:  Node          - Node to be converted to a Handle
- *
- * RETURN:      A user handle
- *
- * DESCRIPTION: Convert a real Node to a namespace handle
- *
- ******************************************************************************/
-
-acpi_handle acpi_ns_convert_entry_to_handle(struct acpi_namespace_node *node)
-{
-
-	/*
-	 * Simple implementation for now;
-	 */
-	return ((acpi_handle) node);
-
-/* Example future implementation ---------------------
-
-	if (!Node)
-	{
-		return (NULL);
-	}
-
-	if (Node == acpi_gbl_root_node)
-	{
-		return (ACPI_ROOT_OBJECT);
-	}
-
-	return ((acpi_handle) Node);
-------------------------------------------------------*/
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ns_terminate
  *
  * PARAMETERS:  none
diff --git a/drivers/acpi/acpica/nsxfeval.c b/drivers/acpi/acpica/nsxfeval.c
index f2bd1da..f0c0892 100644
--- a/drivers/acpi/acpica/nsxfeval.c
+++ b/drivers/acpi/acpica/nsxfeval.c
@@ -190,7 +190,7 @@ acpi_evaluate_object(acpi_handle handle,
 
 	/* Convert and validate the device handle */
 
-	info->prefix_node = acpi_ns_map_handle_to_node(handle);
+	info->prefix_node = acpi_ns_validate_handle(handle);
 	if (!info->prefix_node) {
 		status = AE_BAD_PARAMETER;
 		goto cleanup;
@@ -552,7 +552,7 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
 		return (status);
 	}
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 	if (ACPI_FAILURE(status)) {
 		return (status);
@@ -729,7 +729,7 @@ acpi_attach_data(acpi_handle obj_handle,
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -775,7 +775,7 @@ acpi_detach_data(acpi_handle obj_handle, acpi_object_handler handler)
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -822,7 +822,7 @@ acpi_get_data(acpi_handle obj_handle, acpi_object_handler handler, void **data)
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(obj_handle);
+	node = acpi_ns_validate_handle(obj_handle);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
index ddc84af..e611dd9 100644
--- a/drivers/acpi/acpica/nsxfname.c
+++ b/drivers/acpi/acpica/nsxfname.c
@@ -93,7 +93,7 @@ acpi_get_handle(acpi_handle parent,
 	/* Convert a parent handle to a prefix node */
 
 	if (parent) {
-		prefix_node = acpi_ns_map_handle_to_node(parent);
+		prefix_node = acpi_ns_validate_handle(parent);
 		if (!prefix_node) {
 			return (AE_BAD_PARAMETER);
 		}
@@ -114,7 +114,7 @@ acpi_get_handle(acpi_handle parent,
 
 		if (!ACPI_STRCMP(pathname, ACPI_NS_ROOT_PATH)) {
 			*ret_handle =
-			    acpi_ns_convert_entry_to_handle(acpi_gbl_root_node);
+			    ACPI_CAST_PTR(acpi_handle, acpi_gbl_root_node);
 			return (AE_OK);
 		}
 	} else if (!prefix_node) {
@@ -129,7 +129,7 @@ acpi_get_handle(acpi_handle parent,
 	status =
 	    acpi_ns_get_node(prefix_node, pathname, ACPI_NS_NO_UPSEARCH, &node);
 	if (ACPI_SUCCESS(status)) {
-		*ret_handle = acpi_ns_convert_entry_to_handle(node);
+		*ret_handle = ACPI_CAST_PTR(acpi_handle, node);
 	}
 
 	return (status);
@@ -186,7 +186,7 @@ acpi_get_name(acpi_handle handle, u32 name_type, struct acpi_buffer * buffer)
 		return (status);
 	}
 
-	node = acpi_ns_map_handle_to_node(handle);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -291,7 +291,7 @@ acpi_get_object_info(acpi_handle handle,
 		goto cleanup;
 	}
 
-	node = acpi_ns_map_handle_to_node(handle);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 		return (AE_BAD_PARAMETER);
diff --git a/drivers/acpi/acpica/nsxfobj.c b/drivers/acpi/acpica/nsxfobj.c
index 4071bad..0cc6ba0 100644
--- a/drivers/acpi/acpica/nsxfobj.c
+++ b/drivers/acpi/acpica/nsxfobj.c
@@ -79,7 +79,7 @@ acpi_status acpi_get_id(acpi_handle handle, acpi_owner_id * ret_id)
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(handle);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 		return (AE_BAD_PARAMETER);
@@ -132,7 +132,7 @@ acpi_status acpi_get_type(acpi_handle handle, acpi_object_type * ret_type)
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(handle);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 		return (AE_BAD_PARAMETER);
@@ -182,7 +182,7 @@ acpi_status acpi_get_parent(acpi_handle handle, acpi_handle * ret_handle)
 
 	/* Convert and validate the handle */
 
-	node = acpi_ns_map_handle_to_node(handle);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		status = AE_BAD_PARAMETER;
 		goto unlock_and_exit;
@@ -191,7 +191,7 @@ acpi_status acpi_get_parent(acpi_handle handle, acpi_handle * ret_handle)
 	/* Get the parent entry */
 
 	parent_node = acpi_ns_get_parent_node(node);
-	*ret_handle = acpi_ns_convert_entry_to_handle(parent_node);
+	*ret_handle = ACPI_CAST_PTR(acpi_handle, parent_node);
 
 	/* Return exception if parent is null */
 
@@ -251,7 +251,7 @@ acpi_get_next_object(acpi_object_type type,
 
 		/* Start search at the beginning of the specified scope */
 
-		parent_node = acpi_ns_map_handle_to_node(parent);
+		parent_node = acpi_ns_validate_handle(parent);
 		if (!parent_node) {
 			status = AE_BAD_PARAMETER;
 			goto unlock_and_exit;
@@ -260,7 +260,7 @@ acpi_get_next_object(acpi_object_type type,
 		/* Non-null handle, ignore the parent */
 		/* Convert and validate the handle */
 
-		child_node = acpi_ns_map_handle_to_node(child);
+		child_node = acpi_ns_validate_handle(child);
 		if (!child_node) {
 			status = AE_BAD_PARAMETER;
 			goto unlock_and_exit;
@@ -276,7 +276,7 @@ acpi_get_next_object(acpi_object_type type,
 	}
 
 	if (ret_handle) {
-		*ret_handle = acpi_ns_convert_entry_to_handle(node);
+		*ret_handle = ACPI_CAST_PTR(acpi_handle, node);
 	}
 
       unlock_and_exit:
diff --git a/drivers/acpi/acpica/rsxface.c b/drivers/acpi/acpica/rsxface.c
index 395212b..f27feb4 100644
--- a/drivers/acpi/acpica/rsxface.c
+++ b/drivers/acpi/acpica/rsxface.c
@@ -104,7 +104,7 @@ acpi_rs_validate_parameters(acpi_handle device_handle,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	node = acpi_ns_map_handle_to_node(device_handle);
+	node = acpi_ns_validate_handle(device_handle);
 	if (!node) {
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}

>From 03cdc8466299f16fb98b9a82affe58dec5b8cac9 Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:01:12 +0800
Subject: [PATCH 06/16] ACPICA: Add more conversions to predefined name repair module

This change enhances the automatic repairs/conversions for
predefined name return values to make Integers, Strings, and
Buffers fully interchangeable. Also, a Buffer can be converted
to a Package of Integers if necessary. The nsrepair.c module was
completely restructured.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nsrepair.c |  403 ++++++++++++++++++++++++++++++++--------
 1 files changed, 327 insertions(+), 76 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index d563f1a..10629fa 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -45,13 +45,52 @@
 #include "accommon.h"
 #include "acnamesp.h"
 #include "acinterp.h"
-#include "acpredef.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsrepair")
 
 /*******************************************************************************
  *
+ * This module attempts to repair or convert objects returned by the
+ * predefined methods to an object type that is expected, as per the ACPI
+ * specification. The need for this code is dictated by the many machines that
+ * return incorrect types for the standard predefined methods. Performing these
+ * conversions here, in one place, eliminates the need for individual ACPI
+ * device drivers to do the same. Note: Most of these conversions are different
+ * than the internal object conversion routines used for implicit object
+ * conversion.
+ *
+ * The following conversions can be performed as necessary:
+ *
+ * Integer -> String
+ * Integer -> Buffer
+ * String  -> Integer
+ * String  -> Buffer
+ * Buffer  -> Integer
+ * Buffer  -> String
+ * Buffer  -> Package of Integers
+ * Package -> Package of one Package
+ *
+ ******************************************************************************/
+/* Local prototypes */
+static acpi_status
+acpi_ns_convert_to_integer(union acpi_operand_object *original_object,
+			   union acpi_operand_object **return_object);
+
+static acpi_status
+acpi_ns_convert_to_string(union acpi_operand_object *original_object,
+			  union acpi_operand_object **return_object);
+
+static acpi_status
+acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
+			  union acpi_operand_object **return_object);
+
+static acpi_status
+acpi_ns_convert_to_package(union acpi_operand_object *original_object,
+			   union acpi_operand_object **return_object);
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_ns_repair_object
  *
  * PARAMETERS:  Data                - Pointer to validation data structure
@@ -68,6 +107,7 @@ ACPI_MODULE_NAME("nsrepair")
  *              not expected.
  *
  ******************************************************************************/
+
 acpi_status
 acpi_ns_repair_object(struct acpi_predefined_data *data,
 		      u32 expected_btypes,
@@ -76,32 +116,205 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 {
 	union acpi_operand_object *return_object = *return_object_ptr;
 	union acpi_operand_object *new_object;
-	acpi_size length;
 	acpi_status status;
 
 	/*
 	 * At this point, we know that the type of the returned object was not
 	 * one of the expected types for this predefined name. Attempt to
-	 * repair the object. Only a limited number of repairs are possible.
+	 * repair the object by converting it to one of the expected object
+	 * types for this predefined name.
+	 */
+	if (expected_btypes & ACPI_RTYPE_INTEGER) {
+		status = acpi_ns_convert_to_integer(return_object, &new_object);
+		if (ACPI_SUCCESS(status)) {
+			goto object_repaired;
+		}
+	}
+	if (expected_btypes & ACPI_RTYPE_STRING) {
+		status = acpi_ns_convert_to_string(return_object, &new_object);
+		if (ACPI_SUCCESS(status)) {
+			goto object_repaired;
+		}
+	}
+	if (expected_btypes & ACPI_RTYPE_BUFFER) {
+		status = acpi_ns_convert_to_buffer(return_object, &new_object);
+		if (ACPI_SUCCESS(status)) {
+			goto object_repaired;
+		}
+	}
+	if (expected_btypes & ACPI_RTYPE_PACKAGE) {
+		status = acpi_ns_convert_to_package(return_object, &new_object);
+		if (ACPI_SUCCESS(status)) {
+			goto object_repaired;
+		}
+	}
+
+	/* We cannot repair this object */
+
+	return (AE_AML_OPERAND_TYPE);
+
+      object_repaired:
+
+	/* Object was successfully repaired */
+
+	/*
+	 * If the original object is a package element, we need to:
+	 * 1. Set the reference count of the new object to match the
+	 *    reference count of the old object.
+	 * 2. Decrement the reference count of the original object.
 	 */
-	switch (return_object->common.type) {
+	if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
+		new_object->common.reference_count =
+		    return_object->common.reference_count;
+
+		if (return_object->common.reference_count > 1) {
+			return_object->common.reference_count--;
+		}
+
+		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
+				      "Converted %s to expected %s at index %u",
+				      acpi_ut_get_object_type_name
+				      (return_object),
+				      acpi_ut_get_object_type_name(new_object),
+				      package_index));
+	} else {
+		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
+				      "Converted %s to expected %s",
+				      acpi_ut_get_object_type_name
+				      (return_object),
+				      acpi_ut_get_object_type_name
+				      (new_object)));
+	}
+
+	/* Delete old object, install the new return object */
+
+	acpi_ut_remove_reference(return_object);
+	*return_object_ptr = new_object;
+	data->flags |= ACPI_OBJECT_REPAIRED;
+	return (AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ns_convert_to_integer
+ *
+ * PARAMETERS:  original_object     - Object to be converted
+ *              return_object       - Where the new converted object is returned
+ *
+ * RETURN:      Status. AE_OK if conversion was successful.
+ *
+ * DESCRIPTION: Attempt to convert a String/Buffer object to an Integer.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_ns_convert_to_integer(union acpi_operand_object *original_object,
+			   union acpi_operand_object **return_object)
+{
+	union acpi_operand_object *new_object;
+	acpi_status status;
+	u64 value = 0;
+	u32 i;
+
+	switch (original_object->common.type) {
+	case ACPI_TYPE_STRING:
+
+		/* String-to-Integer conversion */
+
+		status = acpi_ut_strtoul64(original_object->string.pointer,
+					   ACPI_ANY_BASE, &value);
+		if (ACPI_FAILURE(status)) {
+			return (status);
+		}
+		break;
+
 	case ACPI_TYPE_BUFFER:
 
-		/* Does the method/object legally return a string? */
+		/* Buffer-to-Integer conversion. Max buffer size is 64 bits. */
 
-		if (!(expected_btypes & ACPI_RTYPE_STRING)) {
+		if (original_object->buffer.length > 8) {
 			return (AE_AML_OPERAND_TYPE);
 		}
 
+		/* Extract each buffer byte to create the integer */
+
+		for (i = 0; i < original_object->buffer.length; i++) {
+			value |=
+			    ((u64) original_object->buffer.
+			     pointer[i] << (i * 8));
+		}
+		break;
+
+	default:
+		return (AE_AML_OPERAND_TYPE);
+	}
+
+	new_object = acpi_ut_create_integer_object(value);
+	if (!new_object) {
+		return (AE_NO_MEMORY);
+	}
+
+	*return_object = new_object;
+	return (AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ns_convert_to_string
+ *
+ * PARAMETERS:  original_object     - Object to be converted
+ *              return_object       - Where the new converted object is returned
+ *
+ * RETURN:      Status. AE_OK if conversion was successful.
+ *
+ * DESCRIPTION: Attempt to convert a Integer/Buffer object to a String.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_ns_convert_to_string(union acpi_operand_object *original_object,
+			  union acpi_operand_object **return_object)
+{
+	union acpi_operand_object *new_object;
+	acpi_size length;
+	acpi_status status;
+
+	switch (original_object->common.type) {
+	case ACPI_TYPE_INTEGER:
+		/*
+		 * Integer-to-String conversion. Commonly, convert
+		 * an integer of value 0 to a NULL string. The last element of
+		 * _BIF and _BIX packages occasionally need this fix.
+		 */
+		if (original_object->integer.value == 0) {
+
+			/* Allocate a new NULL string object */
+
+			new_object = acpi_ut_create_string_object(0);
+			if (!new_object) {
+				return (AE_NO_MEMORY);
+			}
+		} else {
+			status =
+			    acpi_ex_convert_to_string(original_object,
+						      &new_object,
+						      ACPI_IMPLICIT_CONVERT_HEX);
+			if (ACPI_FAILURE(status)) {
+				return (status);
+			}
+		}
+		break;
+
+	case ACPI_TYPE_BUFFER:
 		/*
-		 * Have a Buffer, expected a String, convert. Use a to_string
+		 * Buffer-to-String conversion. Use a to_string
 		 * conversion, no transform performed on the buffer data. The best
 		 * example of this is the _BIF method, where the string data from
 		 * the battery is often (incorrectly) returned as buffer object(s).
 		 */
 		length = 0;
-		while ((length < return_object->buffer.length) &&
-		       (return_object->buffer.pointer[length])) {
+		while ((length < original_object->buffer.length) &&
+		       (original_object->buffer.pointer[length])) {
 			length++;
 		}
 
@@ -117,94 +330,132 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 		 * terminated at Length+1.
 		 */
 		ACPI_MEMCPY(new_object->string.pointer,
-			    return_object->buffer.pointer, length);
+			    original_object->buffer.pointer, length);
 		break;
 
-	case ACPI_TYPE_INTEGER:
+	default:
+		return (AE_AML_OPERAND_TYPE);
+	}
 
-		/* 1) Does the method/object legally return a buffer? */
+	*return_object = new_object;
+	return (AE_OK);
+}
 
-		if (expected_btypes & ACPI_RTYPE_BUFFER) {
-			/*
-			 * Convert the Integer to a packed-byte buffer. _MAT needs
-			 * this sometimes, if a read has been performed on a Field
-			 * object that is less than or equal to the global integer
-			 * size (32 or 64 bits).
-			 */
-			status =
-			    acpi_ex_convert_to_buffer(return_object,
-						      &new_object);
-			if (ACPI_FAILURE(status)) {
-				return (status);
-			}
-		}
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ns_convert_to_buffer
+ *
+ * PARAMETERS:  original_object     - Object to be converted
+ *              return_object       - Where the new converted object is returned
+ *
+ * RETURN:      Status. AE_OK if conversion was successful.
+ *
+ * DESCRIPTION: Attempt to convert a Integer/String object to a Buffer.
+ *
+ ******************************************************************************/
 
-		/* 2) Does the method/object legally return a string? */
+static acpi_status
+acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
+			  union acpi_operand_object **return_object)
+{
+	union acpi_operand_object *new_object;
+	acpi_status status;
 
-		else if (expected_btypes & ACPI_RTYPE_STRING) {
-			/*
-			 * The only supported Integer-to-String conversion is to convert
-			 * an integer of value 0 to a NULL string. The last element of
-			 * _BIF and _BIX packages occasionally need this fix.
-			 */
-			if (return_object->integer.value != 0) {
-				return (AE_AML_OPERAND_TYPE);
-			}
+	switch (original_object->common.type) {
+	case ACPI_TYPE_INTEGER:
+		/*
+		 * Integer-to-Buffer conversion.
+		 * Convert the Integer to a packed-byte buffer. _MAT and other
+		 * objects need this sometimes, if a read has been performed on a
+		 * Field object that is less than or equal to the global integer
+		 * size (32 or 64 bits).
+		 */
+		status =
+		    acpi_ex_convert_to_buffer(original_object, &new_object);
+		if (ACPI_FAILURE(status)) {
+			return (status);
+		}
+		break;
 
-			/* Allocate a new NULL string object */
+	case ACPI_TYPE_STRING:
 
-			new_object = acpi_ut_create_string_object(0);
-			if (!new_object) {
-				return (AE_NO_MEMORY);
-			}
-		} else {
-			return (AE_AML_OPERAND_TYPE);
+		/* String-to-Buffer conversion. Simple data copy */
+
+		new_object =
+		    acpi_ut_create_buffer_object(original_object->string.
+						 length);
+		if (!new_object) {
+			return (AE_NO_MEMORY);
 		}
+
+		ACPI_MEMCPY(new_object->buffer.pointer,
+			    original_object->string.pointer,
+			    original_object->string.length);
 		break;
 
 	default:
-
-		/* We cannot repair this object */
-
 		return (AE_AML_OPERAND_TYPE);
 	}
 
-	/* Object was successfully repaired */
+	*return_object = new_object;
+	return (AE_OK);
+}
 
-	/*
-	 * If the original object is a package element, we need to:
-	 * 1. Set the reference count of the new object to match the
-	 *    reference count of the old object.
-	 * 2. Decrement the reference count of the original object.
-	 */
-	if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
-		new_object->common.reference_count =
-		    return_object->common.reference_count;
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ns_convert_to_package
+ *
+ * PARAMETERS:  original_object     - Object to be converted
+ *              return_object       - Where the new converted object is returned
+ *
+ * RETURN:      Status. AE_OK if conversion was successful.
+ *
+ * DESCRIPTION: Attempt to convert a Buffer object to a Package. Each byte of
+ *              the buffer is converted to a single integer package element.
+ *
+ ******************************************************************************/
 
-		if (return_object->common.reference_count > 1) {
-			return_object->common.reference_count--;
+static acpi_status
+acpi_ns_convert_to_package(union acpi_operand_object *original_object,
+			   union acpi_operand_object **return_object)
+{
+	union acpi_operand_object *new_object;
+	union acpi_operand_object **elements;
+	u32 length;
+	u8 *buffer;
+
+	switch (original_object->common.type) {
+	case ACPI_TYPE_BUFFER:
+
+		/* Buffer-to-Package conversion */
+
+		length = original_object->buffer.length;
+		new_object = acpi_ut_create_package_object(length);
+		if (!new_object) {
+			return (AE_NO_MEMORY);
 		}
 
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Converted %s to expected %s at index %u",
-				      acpi_ut_get_object_type_name
-				      (return_object),
-				      acpi_ut_get_object_type_name(new_object),
-				      package_index));
-	} else {
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Converted %s to expected %s",
-				      acpi_ut_get_object_type_name
-				      (return_object),
-				      acpi_ut_get_object_type_name
-				      (new_object)));
-	}
+		/* Convert each buffer byte to an integer package element */
 
-	/* Delete old object, install the new return object */
+		elements = new_object->package.elements;
+		buffer = original_object->buffer.pointer;
 
-	acpi_ut_remove_reference(return_object);
-	*return_object_ptr = new_object;
-	data->flags |= ACPI_OBJECT_REPAIRED;
+		while (length--) {
+			*elements = acpi_ut_create_integer_object(*buffer);
+			if (!*elements) {
+				acpi_ut_remove_reference(new_object);
+				return (AE_NO_MEMORY);
+			}
+			elements++;
+			buffer++;
+		}
+		break;
+
+	default:
+		return (AE_AML_OPERAND_TYPE);
+	}
+
+	*return_object = new_object;
 	return (AE_OK);
 }
 

>From 140335ddcd5e6e9209ef1c81653a58cf7755584c Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:02:15 +0800
Subject: [PATCH 07/16] ACPICA: Update function headers, no functional change

Fixed a few errors with the headers in utcopy.c

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/utcopy.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index 0f0c64b..f857c5e 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -323,11 +323,11 @@ acpi_ut_copy_ielement_to_eelement(u8 object_type,
  * RETURN:      Status
  *
  * DESCRIPTION: This function is called to place a package object in a user
- *              buffer.  A package object by definition contains other objects.
+ *              buffer. A package object by definition contains other objects.
  *
  *              The buffer is assumed to have sufficient space for the object.
- *              The caller must have verified the buffer length needed using the
- *              acpi_ut_get_object_size function before calling this function.
+ *              The caller must have verified the buffer length needed using
+ *              the acpi_ut_get_object_size function before calling this function.
  *
  ******************************************************************************/
 
@@ -382,12 +382,12 @@ acpi_ut_copy_ipackage_to_epackage(union acpi_operand_object *internal_object,
  * FUNCTION:    acpi_ut_copy_iobject_to_eobject
  *
  * PARAMETERS:  internal_object     - The internal object to be converted
- *              buffer_ptr          - Where the object is returned
+ *              ret_buffer          - Where the object is returned
  *
  * RETURN:      Status
  *
- * DESCRIPTION: This function is called to build an API object to be returned to
- *              the caller.
+ * DESCRIPTION: This function is called to build an API object to be returned
+ *              to the caller.
  *
  ******************************************************************************/
 
@@ -626,7 +626,7 @@ acpi_ut_copy_epackage_to_ipackage(union acpi_object *external_object,
  * PARAMETERS:  external_object     - The external object to be converted
  *              internal_object     - Where the internal object is returned
  *
- * RETURN:      Status              - the status of the call
+ * RETURN:      Status
  *
  * DESCRIPTION: Converts an external object to an internal object.
  *
@@ -665,7 +665,7 @@ acpi_ut_copy_eobject_to_iobject(union acpi_object *external_object,
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Simple copy of one internal object to another.  Reference count
+ * DESCRIPTION: Simple copy of one internal object to another. Reference count
  *              of the destination object is preserved.
  *
  ******************************************************************************/
@@ -897,10 +897,11 @@ acpi_ut_copy_ielement_to_ielement(u8 object_type,
  *
  * FUNCTION:    acpi_ut_copy_ipackage_to_ipackage
  *
- * PARAMETERS:  *source_obj     - Pointer to the source package object
- *              *dest_obj       - Where the internal object is returned
+ * PARAMETERS:  source_obj      - Pointer to the source package object
+ *              dest_obj        - Where the internal object is returned
+ *              walk_state      - Current Walk state descriptor
  *
- * RETURN:      Status          - the status of the call
+ * RETURN:      Status
  *
  * DESCRIPTION: This function is called to copy an internal package object
  *              into another internal package object.
@@ -953,9 +954,9 @@ acpi_ut_copy_ipackage_to_ipackage(union acpi_operand_object *source_obj,
  *
  * FUNCTION:    acpi_ut_copy_iobject_to_iobject
  *
- * PARAMETERS:  walk_state          - Current walk state
- *              source_desc         - The internal object to be copied
+ * PARAMETERS:  source_desc         - The internal object to be copied
  *              dest_desc           - Where the copied object is returned
+ *              walk_state          - Current walk state
  *
  * RETURN:      Status
  *

>From bd778e7a4a35cb6715345533cbd0c1a2449c9b1d Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:16:38 +0800
Subject: [PATCH 08/16] ACPICA: Fix mutex errors when running _REG methods

Fixes a problem where mutex errors can occur when running a _REG
method that is in the same scope as a method-defined operation
region or an operation region under a module-level IF block.
This is rare, so the problem has not been seen before.
ACPICA BZ 826.

http://www.acpica.org/bugzilla/show_bug.cgi?id=826

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/dswload.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 9cc2289..b40513d 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -1052,9 +1052,22 @@ acpi_status acpi_ds_load2_end_op(struct acpi_walk_state *walk_state)
 			}
 
 			/*
-			 * If we are executing a method, initialize the region
+			 * The op_region is not fully parsed at this time. The only valid
+			 * argument is the space_id. (We must save the address of the
+			 * AML of the address and length operands)
+			 *
+			 * If we have a valid region, initialize it. The namespace is
+			 * unlocked at this point.
+			 *
+			 * Need to unlock interpreter if it is locked (if we are running
+			 * a control method), in order to allow _REG methods to be run
+			 * during acpi_ev_initialize_region.
 			 */
 			if (walk_state->method_node) {
+				/*
+				 * Executing a method: initialize the region and unlock
+				 * the interpreter
+				 */
 				status =
 				    acpi_ex_create_region(op->named.data,
 							  op->named.length,
@@ -1063,21 +1076,17 @@ acpi_status acpi_ds_load2_end_op(struct acpi_walk_state *walk_state)
 				if (ACPI_FAILURE(status)) {
 					return (status);
 				}
-			}
 
-			/*
-			 * The op_region is not fully parsed at this time. Only valid
-			 * argument is the space_id. (We must save the address of the
-			 * AML of the address and length operands)
-			 */
+				acpi_ex_exit_interpreter();
+			}
 
-			/*
-			 * If we have a valid region, initialize it
-			 * Namespace is NOT locked at this point.
-			 */
 			status =
 			    acpi_ev_initialize_region
 			    (acpi_ns_get_attached_object(node), FALSE);
+			if (walk_state->method_node) {
+				acpi_ex_enter_interpreter();
+			}
+
 			if (ACPI_FAILURE(status)) {
 				/*
 				 *  If AE_NOT_EXIST is returned, it is not fatal

>From f3a581ea1d632f132f7222b34c40ea6f1be43c8f Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:18:52 +0800
Subject: [PATCH 09/16] ACPICA: Move Package-to-Buffer repair code into common ToBuffer function

Move code specific to _FDE and _GTM into the generic repair code.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nspredef.c  |   11 ++++++---
 drivers/acpi/acpica/nsrepair.c  |   43 +++++++++++++++++++++++++++++++++++++-
 drivers/acpi/acpica/nsrepair2.c |   43 ---------------------------------------
 3 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index 1782c3d..c6297f5 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -215,6 +215,8 @@ acpi_ns_check_predefined_names(struct acpi_namespace_node *node,
 	data->node_flags = node->flags;
 	data->pathname = pathname;
 
+	/* TBD: For variable-length Packages, remove NULL elements here */
+
 	/*
 	 * Check that the type of the return object is what is expected for
 	 * this predefined name
@@ -223,10 +225,11 @@ acpi_ns_check_predefined_names(struct acpi_namespace_node *node,
 					   predefined->info.expected_btypes,
 					   ACPI_NOT_PACKAGE_ELEMENT);
 	if (ACPI_SUCCESS(status)) {
-
-		/* For returned Package objects, check the type of all sub-objects */
-
-		if (return_object->common.type == ACPI_TYPE_PACKAGE) {
+		/*
+		 * For returned Package objects, check the type of all sub-objects.
+		 * Note: Package may have been created by call above.
+		 */
+		if ((*return_object_ptr)->common.type == ACPI_TYPE_PACKAGE) {
 			status = acpi_ns_check_package(data, return_object_ptr);
 		}
 	}
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 10629fa..062a016 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -350,7 +350,7 @@ acpi_ns_convert_to_string(union acpi_operand_object *original_object,
  *
  * RETURN:      Status. AE_OK if conversion was successful.
  *
- * DESCRIPTION: Attempt to convert a Integer/String object to a Buffer.
+ * DESCRIPTION: Attempt to convert a Integer/String/Package object to a Buffer.
  *
  ******************************************************************************/
 
@@ -360,6 +360,10 @@ acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
 {
 	union acpi_operand_object *new_object;
 	acpi_status status;
+	union acpi_operand_object **elements;
+	u32 *dword_buffer;
+	u32 count;
+	u32 i;
 
 	switch (original_object->common.type) {
 	case ACPI_TYPE_INTEGER:
@@ -393,6 +397,40 @@ acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
 			    original_object->string.length);
 		break;
 
+	case ACPI_TYPE_PACKAGE:
+
+		/* All elements of the Package must be integers */
+
+		elements = original_object->package.elements;
+		count = original_object->package.count;
+
+		for (i = 0; i < count; i++) {
+			if ((!*elements) ||
+			    ((*elements)->common.type != ACPI_TYPE_INTEGER)) {
+				return (AE_AML_OPERAND_TYPE);
+			}
+			elements++;
+		}
+
+		/* Create the new buffer object to replace the Package */
+
+		new_object = acpi_ut_create_buffer_object(ACPI_MUL_4(count));
+		if (!new_object) {
+			return (AE_NO_MEMORY);
+		}
+
+		/* Copy the package elements (integers) to the buffer as DWORDs */
+
+		elements = original_object->package.elements;
+		dword_buffer = ACPI_CAST_PTR(u32, new_object->buffer.pointer);
+
+		for (i = 0; i < count; i++) {
+			*dword_buffer = (u32) (*elements)->integer.value;
+			dword_buffer++;
+			elements++;
+		}
+		break;
+
 	default:
 		return (AE_AML_OPERAND_TYPE);
 	}
@@ -441,7 +479,8 @@ acpi_ns_convert_to_package(union acpi_operand_object *original_object,
 		buffer = original_object->buffer.pointer;
 
 		while (length--) {
-			*elements = acpi_ut_create_integer_object(*buffer);
+			*elements =
+			    acpi_ut_create_integer_object((u64) *buffer);
 			if (!*elements) {
 				acpi_ut_remove_reference(new_object);
 				return (AE_NO_MEMORY);
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 6c35b57..846df70 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -250,11 +250,9 @@ acpi_ns_repair_FDE(struct acpi_predefined_data *data,
 		   union acpi_operand_object **return_object_ptr)
 {
 	union acpi_operand_object *return_object = *return_object_ptr;
-	union acpi_operand_object **elements;
 	union acpi_operand_object *buffer_object;
 	u8 *byte_buffer;
 	u32 *dword_buffer;
-	u32 count;
 	u32 i;
 
 	switch (return_object->common.type) {
@@ -302,47 +300,6 @@ acpi_ns_repair_FDE(struct acpi_predefined_data *data,
 				      "Expanded Byte Buffer to expected DWord Buffer"));
 		break;
 
-	case ACPI_TYPE_PACKAGE:
-
-		/* All elements of the Package must be integers */
-
-		elements = return_object->package.elements;
-		count =
-		    ACPI_MIN(ACPI_FDE_FIELD_COUNT,
-			     return_object->package.count);
-
-		for (i = 0; i < count; i++) {
-			if ((!*elements) ||
-			    ((*elements)->common.type != ACPI_TYPE_INTEGER)) {
-				return (AE_AML_OPERAND_TYPE);
-			}
-			elements++;
-		}
-
-		/* Create the new buffer object to replace the Package */
-
-		buffer_object =
-		    acpi_ut_create_buffer_object(ACPI_FDE_DWORD_BUFFER_SIZE);
-		if (!buffer_object) {
-			return (AE_NO_MEMORY);
-		}
-
-		/* Copy the package elements (integers) to the buffer */
-
-		elements = return_object->package.elements;
-		dword_buffer =
-		    ACPI_CAST_PTR(u32, buffer_object->buffer.pointer);
-
-		for (i = 0; i < count; i++) {
-			*dword_buffer = (u32) (*elements)->integer.value;
-			dword_buffer++;
-			elements++;
-		}
-
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Converted Package to expected Buffer"));
-		break;
-
 	default:
 		return (AE_AML_OPERAND_TYPE);
 	}

>From e138573797bc53acf151df11198f9c3f4c9e6b46 Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:23:22 +0800
Subject: [PATCH 10/16] ACPICA: Remove messages if predefined repair(s) are successful

Repair mechanism was considered too wordy. Now, messages are only
unconditionally emitted if the return object cannot be repaired.
Existing messages for successful repairs were converted to
ACPI_DEBUG_PRINT messages for now. ACPICA BZ 827.

http://www.acpica.org/bugzilla/show_bug.cgi?id=827

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nspredef.c  |   10 +++++-----
 drivers/acpi/acpica/nsrepair.c  |   32 ++++++++++++++++++--------------
 drivers/acpi/acpica/nsrepair2.c |   21 +++++++++++++--------
 include/acpi/acoutput.h         |    8 +++++---
 4 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index c6297f5..e352467 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -462,11 +462,11 @@ acpi_ns_check_package(struct acpi_predefined_data *data,
 		if (count < expected_count) {
 			goto package_too_small;
 		} else if (count > expected_count) {
-			ACPI_WARN_PREDEFINED((AE_INFO, data->pathname,
-					      data->node_flags,
-					      "Return Package is larger than needed - "
-					      "found %u, expected %u", count,
-					      expected_count));
+			ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+					  "%s: Return Package is larger than needed - "
+					  "found %u, expected %u\n",
+					  data->pathname, count,
+					  expected_count));
 		}
 
 		/* Validate all elements of the returned package */
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 062a016..907f60c 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -118,6 +118,8 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 	union acpi_operand_object *new_object;
 	acpi_status status;
 
+	ACPI_FUNCTION_NAME(ns_repair_object);
+
 	/*
 	 * At this point, we know that the type of the returned object was not
 	 * one of the expected types for this predefined name. Attempt to
@@ -171,19 +173,18 @@ acpi_ns_repair_object(struct acpi_predefined_data *data,
 			return_object->common.reference_count--;
 		}
 
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Converted %s to expected %s at index %u",
-				      acpi_ut_get_object_type_name
-				      (return_object),
-				      acpi_ut_get_object_type_name(new_object),
-				      package_index));
+		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+				  "%s: Converted %s to expected %s at index %u\n",
+				  data->pathname,
+				  acpi_ut_get_object_type_name(return_object),
+				  acpi_ut_get_object_type_name(new_object),
+				  package_index));
 	} else {
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Converted %s to expected %s",
-				      acpi_ut_get_object_type_name
-				      (return_object),
-				      acpi_ut_get_object_type_name
-				      (new_object)));
+		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+				  "%s: Converted %s to expected %s\n",
+				  data->pathname,
+				  acpi_ut_get_object_type_name(return_object),
+				  acpi_ut_get_object_type_name(new_object)));
 	}
 
 	/* Delete old object, install the new return object */
@@ -528,6 +529,8 @@ acpi_ns_repair_package_list(struct acpi_predefined_data *data,
 {
 	union acpi_operand_object *pkg_obj_desc;
 
+	ACPI_FUNCTION_NAME(ns_repair_package_list);
+
 	/*
 	 * Create the new outer package and populate it. The new package will
 	 * have a single element, the lone subpackage.
@@ -544,8 +547,9 @@ acpi_ns_repair_package_list(struct acpi_predefined_data *data,
 	*obj_desc_ptr = pkg_obj_desc;
 	data->flags |= ACPI_OBJECT_REPAIRED;
 
-	ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-			      "Repaired Incorrectly formed Package"));
+	ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+			  "%s: Repaired incorrectly formed Package\n",
+			  data->pathname));
 
 	return (AE_OK);
 }
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 846df70..1993338 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -255,6 +255,8 @@ acpi_ns_repair_FDE(struct acpi_predefined_data *data,
 	u32 *dword_buffer;
 	u32 i;
 
+	ACPI_FUNCTION_NAME(ns_repair_FDE);
+
 	switch (return_object->common.type) {
 	case ACPI_TYPE_BUFFER:
 
@@ -296,8 +298,9 @@ acpi_ns_repair_FDE(struct acpi_predefined_data *data,
 			byte_buffer++;
 		}
 
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "Expanded Byte Buffer to expected DWord Buffer"));
+		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+				  "%s Expanded Byte Buffer to expected DWord Buffer\n",
+				  data->pathname));
 		break;
 
 	default:
@@ -445,6 +448,8 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
 	u32 previous_value;
 	acpi_status status;
 
+	ACPI_FUNCTION_NAME(ns_check_sorted_list);
+
 	/* The top-level object must be a package */
 
 	if (return_object->common.type != ACPI_TYPE_PACKAGE) {
@@ -460,8 +465,9 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
 	 */
 	status = acpi_ns_remove_null_elements(return_object);
 	if (status == AE_NULL_ENTRY) {
-		ACPI_INFO_PREDEFINED((AE_INFO, data->pathname, data->node_flags,
-				      "NULL elements removed from package"));
+		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+				  "%s: NULL elements removed from package\n",
+				  data->pathname));
 
 		/* Exit if package is now zero length */
 
@@ -522,10 +528,9 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
 
 			data->flags |= ACPI_OBJECT_REPAIRED;
 
-			ACPI_INFO_PREDEFINED((AE_INFO, data->pathname,
-					      data->node_flags,
-					      "Repaired unsorted list - now sorted by %s",
-					      sort_key_name));
+			ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+					  "%s: Repaired unsorted list - now sorted by %s\n",
+					  data->pathname, sort_key_name));
 			return (AE_OK);
 		}
 
diff --git a/include/acpi/acoutput.h b/include/acpi/acoutput.h
index 5c823d5..d814da4 100644
--- a/include/acpi/acoutput.h
+++ b/include/acpi/acoutput.h
@@ -85,7 +85,8 @@
 #define ACPI_LV_INIT                0x00000001
 #define ACPI_LV_DEBUG_OBJECT        0x00000002
 #define ACPI_LV_INFO                0x00000004
-#define ACPI_LV_ALL_EXCEPTIONS      0x00000007
+#define ACPI_LV_REPAIR              0x00000008
+#define ACPI_LV_ALL_EXCEPTIONS      0x0000000F
 
 /* Trace verbosity level 1 [Standard Trace Level] */
 
@@ -143,6 +144,7 @@
 #define ACPI_DB_INIT                ACPI_DEBUG_LEVEL (ACPI_LV_INIT)
 #define ACPI_DB_DEBUG_OBJECT        ACPI_DEBUG_LEVEL (ACPI_LV_DEBUG_OBJECT)
 #define ACPI_DB_INFO                ACPI_DEBUG_LEVEL (ACPI_LV_INFO)
+#define ACPI_DB_REPAIR              ACPI_DEBUG_LEVEL (ACPI_LV_REPAIR)
 #define ACPI_DB_ALL_EXCEPTIONS      ACPI_DEBUG_LEVEL (ACPI_LV_ALL_EXCEPTIONS)
 
 /* Trace level -- also used in the global "DebugLevel" */
@@ -174,8 +176,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INFO)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INFO | ACPI_LV_REPAIR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_DEBUG_OBJECT | ACPI_LV_REPAIR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #if defined (ACPI_DEBUG_OUTPUT) || !defined (ACPI_NO_ERROR_MESSAGES)

>From ee82be5bef89157c43e54b6039074446dc30b55a Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:24:27 +0800
Subject: [PATCH 11/16] ACPICA: Update function headers and comments, no functional change

Update comments for repair of _FDE and _GTM methods.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nsrepair.c  |    5 +++++
 drivers/acpi/acpica/nsrepair2.c |   11 +++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 907f60c..4fd1bdb 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -399,6 +399,11 @@ acpi_ns_convert_to_buffer(union acpi_operand_object *original_object,
 		break;
 
 	case ACPI_TYPE_PACKAGE:
+		/*
+		 * This case is often seen for predefined names that must return a
+		 * Buffer object with multiple DWORD integers within. For example,
+		 * _FDE and _GTM. The Package can be converted to a Buffer.
+		 */
 
 		/* All elements of the Package must be integers */
 
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 1993338..e7373eb 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -111,8 +111,8 @@ acpi_ns_sort_list(union acpi_operand_object **elements,
  * As necessary:
  *
  * _ALR: Sort the list ascending by ambient_illuminance
- * _FDE: Convert a Package or Buffer of BYTEs to a Buffer of DWORDs
- * _GTM: Convert a Package or Buffer of BYTEs to a Buffer of DWORDs
+ * _FDE: Convert Buffer of BYTEs to a Buffer of DWORDs
+ * _GTM: Convert Buffer of BYTEs to a Buffer of DWORDs
  * _PSS: Sort the list descending by Power
  * _TSS: Sort the list descending by Power
  */
@@ -238,10 +238,9 @@ acpi_ns_repair_ALR(struct acpi_predefined_data *data,
  * RETURN:      Status. AE_OK if object is OK or was repaired successfully
  *
  * DESCRIPTION: Repair for the _FDE and _GTM objects. The expected return
- *              value is a Buffer of 5 DWORDs. This function repairs two
- *              possible problems:
- *              1) The return value is a Buffer of BYTEs, not DWORDs
- *              2) The return value is a Package of Integer objects
+ *              value is a Buffer of 5 DWORDs. This function repairs a common
+ *              problem where the return value is a Buffer of BYTEs, not
+ *              DWORDs.
  *
  *****************************************************************************/
 

>From 8010cdbd5ae27ea2e5288e42f1e91b62236dff2e Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:26:13 +0800
Subject: [PATCH 12/16] ACPICA: Conditionally perform complex per-predefined-name repairs

Only attempt the "complex" repairs (package sorting, buffer
expansion) if the previous "generic" validation and repair was
successful.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/nspredef.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index e352467..239fa2f 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -215,31 +215,42 @@ acpi_ns_check_predefined_names(struct acpi_namespace_node *node,
 	data->node_flags = node->flags;
 	data->pathname = pathname;
 
-	/* TBD: For variable-length Packages, remove NULL elements here */
-
 	/*
-	 * Check that the type of the return object is what is expected for
-	 * this predefined name
+	 * Check that the type of the main return object is what is expected
+	 * for this predefined name
 	 */
 	status = acpi_ns_check_object_type(data, return_object_ptr,
 					   predefined->info.expected_btypes,
 					   ACPI_NOT_PACKAGE_ELEMENT);
-	if (ACPI_SUCCESS(status)) {
-		/*
-		 * For returned Package objects, check the type of all sub-objects.
-		 * Note: Package may have been created by call above.
-		 */
-		if ((*return_object_ptr)->common.type == ACPI_TYPE_PACKAGE) {
-			status = acpi_ns_check_package(data, return_object_ptr);
+	if (ACPI_FAILURE(status)) {
+		goto exit;
+	}
+
+	/*
+	 * For returned Package objects, check the type of all sub-objects.
+	 * Note: Package may have been newly created by call above.
+	 */
+	if ((*return_object_ptr)->common.type == ACPI_TYPE_PACKAGE) {
+
+		/* TBD: For variable-length Packages, remove NULL elements here */
+
+		status = acpi_ns_check_package(data, return_object_ptr);
+		if (ACPI_FAILURE(status)) {
+			goto exit;
 		}
 	}
 
 	/*
-	 * Perform additional, more complicated repairs on a per-name
-	 * basis. Do this regardless of the status from above.
+	 * The return object was OK, or it was successfully repaired above.
+	 * Now make some additional checks such as verifying that package
+	 * objects are sorted correctly (if required) or buffer objects have
+	 * the correct data width (bytes vs. dwords). These repairs are
+	 * performed on a per-name basis, i.e., the code is specific to
+	 * particular predefined names.
 	 */
 	status = acpi_ns_complex_repairs(data, node, status, return_object_ptr);
 
+exit:
 	/*
 	 * If the object validation failed or if we successfully repaired one
 	 * or more objects, mark the parent node to suppress further warning

>From 5e34a8b41b210a8fa611bb9d7314ca7133f31e6e Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Fri, 11 Dec 2009 15:28:27 +0800
Subject: [PATCH 13/16] ACPICA: Module-level code: enable _REG execution in same scope

This change enables the execution of _REG methods that appear
in the same scope as the module-level code, in resonse to an
operation region declaration within the module-level code.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/acobject.h |    6 +++++-
 drivers/acpi/acpica/dsmethod.c |    2 +-
 drivers/acpi/acpica/evrgnini.c |   15 +++++++++++++++
 drivers/acpi/acpica/nsaccess.c |    2 +-
 drivers/acpi/acpica/nseval.c   |   12 ++++++++++++
 drivers/acpi/acpica/psxface.c  |    3 ++-
 6 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index b39d682..64062b1 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -180,7 +180,11 @@ struct acpi_object_method {
 	u8 sync_level;
 	union acpi_operand_object *mutex;
 	u8 *aml_start;
-	ACPI_INTERNAL_METHOD implementation;
+	union {
+		ACPI_INTERNAL_METHOD implementation;
+		union acpi_operand_object *handler;
+	} extra;
+
 	u32 aml_length;
 	u8 thread_count;
 	acpi_owner_id owner_id;
diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 567a489..e786f9f 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -414,7 +414,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	/* Invoke an internal method if necessary */
 
 	if (obj_desc->method.method_flags & AML_METHOD_INTERNAL_ONLY) {
-		status = obj_desc->method.implementation(next_walk_state);
+		status = obj_desc->method.extra.implementation(next_walk_state);
 		if (status == AE_OK) {
 			status = AE_CTRL_TERMINATE;
 		}
diff --git a/drivers/acpi/acpica/evrgnini.c b/drivers/acpi/acpica/evrgnini.c
index cf29c49..ff16805 100644
--- a/drivers/acpi/acpica/evrgnini.c
+++ b/drivers/acpi/acpica/evrgnini.c
@@ -575,6 +575,21 @@ acpi_ev_initialize_region(union acpi_operand_object *region_obj,
 				handler_obj = obj_desc->thermal_zone.handler;
 				break;
 
+			case ACPI_TYPE_METHOD:
+				/*
+				 * If we are executing module level code, the original
+				 * Node's object was replaced by this Method object and we
+				 * saved the handler in the method object.
+				 *
+				 * See acpi_ns_exec_module_code
+				 */
+				if (obj_desc->method.
+				    flags & AOPOBJ_MODULE_LEVEL) {
+					handler_obj =
+					    obj_desc->method.extra.handler;
+				}
+				break;
+
 			default:
 				/* Ignore other objects */
 				break;
diff --git a/drivers/acpi/acpica/nsaccess.c b/drivers/acpi/acpica/nsaccess.c
index 9c3cdbe..d622ba7 100644
--- a/drivers/acpi/acpica/nsaccess.c
+++ b/drivers/acpi/acpica/nsaccess.c
@@ -165,7 +165,7 @@ acpi_status acpi_ns_root_initialize(void)
 
 				obj_desc->method.method_flags =
 				    AML_METHOD_INTERNAL_ONLY;
-				obj_desc->method.implementation =
+				obj_desc->method.extra.implementation =
 				    acpi_ut_osi_implementation;
 #endif
 				break;
diff --git a/drivers/acpi/acpica/nseval.c b/drivers/acpi/acpica/nseval.c
index 65e0d1a..af9fe91 100644
--- a/drivers/acpi/acpica/nseval.c
+++ b/drivers/acpi/acpica/nseval.c
@@ -381,6 +381,18 @@ acpi_ns_exec_module_code(union acpi_operand_object *method_obj,
 				    method_obj->method.next_object);
 	type = acpi_ns_get_type(parent_node);
 
+	/*
+	 * Get the region handler and save it in the method object. We may need
+	 * this if an operation region declaration causes a _REG method to be run.
+	 *
+	 * We can't do this in acpi_ps_link_module_code because
+	 * acpi_gbl_root_node->Object is NULL at PASS1.
+	 */
+	if ((type == ACPI_TYPE_DEVICE) && parent_node->object) {
+		method_obj->method.extra.handler =
+		    parent_node->object->device.handler;
+	}
+
 	/* Must clear next_object (acpi_ns_attach_object needs the field) */
 
 	method_obj->method.next_object = NULL;
diff --git a/drivers/acpi/acpica/psxface.c b/drivers/acpi/acpica/psxface.c
index 12934ad..d0c1b91 100644
--- a/drivers/acpi/acpica/psxface.c
+++ b/drivers/acpi/acpica/psxface.c
@@ -287,7 +287,8 @@ acpi_status acpi_ps_execute_method(struct acpi_evaluate_info *info)
 	/* Invoke an internal method if necessary */
 
 	if (info->obj_desc->method.method_flags & AML_METHOD_INTERNAL_ONLY) {
-		status = info->obj_desc->method.implementation(walk_state);
+		status =
+		    info->obj_desc->method.extra.implementation(walk_state);
 		info->return_object = walk_state->return_desc;
 
 		/* Cleanup states */

>From 8a78790b4e6e107f2c4c3c87cb77d78e202f2a8a Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Fri, 11 Dec 2009 15:29:44 +0800
Subject: [PATCH 14/16] ACPICA: Predefined name repair: automatically remove null package elements

This change will automatically remove embedded and trailing NULL
package elements from returned package objects that are defined
to containe a variable number of sub-packages. The driver is then
presented with a package with no null elements to deal with.
ACPICA BZ 819.

http://www.acpica.org/bugzilla/show_bug.cgi?id=819

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/acnamesp.h  |    5 ++
 drivers/acpi/acpica/nspredef.c  |   59 +++++++----------------------
 drivers/acpi/acpica/nsrepair2.c |   79 ++++++++++++++++++++++----------------
 3 files changed, 65 insertions(+), 78 deletions(-)

diff --git a/drivers/acpi/acpica/acnamesp.h b/drivers/acpi/acpica/acnamesp.h
index 14cef45..61edb15 100644
--- a/drivers/acpi/acpica/acnamesp.h
+++ b/drivers/acpi/acpica/acnamesp.h
@@ -296,6 +296,11 @@ acpi_ns_complex_repairs(struct acpi_predefined_data *data,
 			acpi_status validate_status,
 			union acpi_operand_object **return_object_ptr);
 
+void
+acpi_ns_remove_null_elements(struct acpi_predefined_data *data,
+			     u8 package_type,
+			     union acpi_operand_object *obj_desc);
+
 /*
  * nssearch - Namespace searching and entry
  */
diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index 239fa2f..d34fa59 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -231,9 +231,6 @@ acpi_ns_check_predefined_names(struct acpi_namespace_node *node,
 	 * Note: Package may have been newly created by call above.
 	 */
 	if ((*return_object_ptr)->common.type == ACPI_TYPE_PACKAGE) {
-
-		/* TBD: For variable-length Packages, remove NULL elements here */
-
 		status = acpi_ns_check_package(data, return_object_ptr);
 		if (ACPI_FAILURE(status)) {
 			goto exit;
@@ -439,6 +436,13 @@ acpi_ns_check_package(struct acpi_predefined_data *data,
 			  data->pathname, package->ret_info.type,
 			  return_object->package.count));
 
+	/*
+	 * For variable-length Packages, we can safely remove all embedded
+	 * and trailing NULL package elements
+	 */
+	acpi_ns_remove_null_elements(data, package->ret_info.type,
+				     return_object);
+
 	/* Extract package count and elements array */
 
 	elements = return_object->package.elements;
@@ -692,53 +696,18 @@ acpi_ns_check_package_list(struct acpi_predefined_data *data,
 	union acpi_operand_object *sub_package;
 	union acpi_operand_object **sub_elements;
 	acpi_status status;
-	u8 non_trailing_null = FALSE;
 	u32 expected_count;
 	u32 i;
 	u32 j;
 
-	/* Validate each sub-Package in the parent Package */
-
+	/*
+	 * Validate each sub-Package in the parent Package
+	 *
+	 * NOTE: assumes list of sub-packages contains no NULL elements.
+	 * Any NULL elements should have been removed by earlier call
+	 * to acpi_ns_remove_null_elements.
+	 */
 	for (i = 0; i < count; i++) {
-		/*
-		 * Handling for NULL package elements. For now, we will simply allow
-		 * a parent package with trailing NULL elements. This can happen if
-		 * the package was defined to be longer than the initializer list.
-		 * This is legal as per the ACPI specification. It is often used
-		 * to allow for dynamic initialization of a Package.
-		 *
-		 * A future enhancement may be to simply truncate the package to
-		 * remove the trailing NULL elements.
-		 */
-		if (!(*elements)) {
-			if (!non_trailing_null) {
-
-				/* Ensure the remaining elements are all NULL */
-
-				for (j = 1; j < (count - i + 1); j++) {
-					if (elements[j]) {
-						non_trailing_null = TRUE;
-					}
-				}
-
-				if (!non_trailing_null) {
-
-					/* Ignore the trailing NULL elements */
-
-					return (AE_OK);
-				}
-			}
-
-			/* There are trailing non-null elements, issue warning */
-
-			ACPI_WARN_PREDEFINED((AE_INFO, data->pathname,
-					      data->node_flags,
-					      "Found NULL element at package index %u",
-					      i));
-			elements++;
-			continue;
-		}
-
 		sub_package = *elements;
 		sub_elements = sub_package->package.elements;
 
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index e7373eb..f13691c 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -45,6 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "acnamesp.h"
+#include "acpredef.h"
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsrepair2")
@@ -93,9 +94,6 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
 			  u8 sort_direction, char *sort_key_name);
 
 static acpi_status
-acpi_ns_remove_null_elements(union acpi_operand_object *package);
-
-static acpi_status
 acpi_ns_sort_list(union acpi_operand_object **elements,
 		  u32 count, u32 index, u8 sort_direction);
 
@@ -456,25 +454,10 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
 	}
 
 	/*
-	 * Detect any NULL package elements and remove them from the
-	 * package.
-	 *
-	 * TBD: We may want to do this for all predefined names that
-	 * return a variable-length package of packages.
+	 * NOTE: assumes list of sub-packages contains no NULL elements.
+	 * Any NULL elements should have been removed by earlier call
+	 * to acpi_ns_remove_null_elements.
 	 */
-	status = acpi_ns_remove_null_elements(return_object);
-	if (status == AE_NULL_ENTRY) {
-		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
-				  "%s: NULL elements removed from package\n",
-				  data->pathname));
-
-		/* Exit if package is now zero length */
-
-		if (!return_object->package.count) {
-			return (AE_NULL_ENTRY);
-		}
-	}
-
 	outer_elements = return_object->package.elements;
 	outer_element_count = return_object->package.count;
 	if (!outer_element_count) {
@@ -544,36 +527,63 @@ acpi_ns_check_sorted_list(struct acpi_predefined_data *data,
  *
  * FUNCTION:    acpi_ns_remove_null_elements
  *
- * PARAMETERS:  obj_desc            - A Package object
+ * PARAMETERS:  Data                - Pointer to validation data structure
+ *              package_type        - An acpi_return_package_types value
+ *              obj_desc            - A Package object
  *
- * RETURN:      Status. AE_NULL_ENTRY means that one or more elements were
- *              removed.
+ * RETURN:      None.
  *
- * DESCRIPTION: Remove all NULL package elements and update the package count.
+ * DESCRIPTION: Remove all NULL package elements from packages that contain
+ *              a variable number of sub-packages.
  *
  *****************************************************************************/
 
-static acpi_status
-acpi_ns_remove_null_elements(union acpi_operand_object *obj_desc)
+void
+acpi_ns_remove_null_elements(struct acpi_predefined_data *data,
+			     u8 package_type,
+			     union acpi_operand_object *obj_desc)
 {
 	union acpi_operand_object **source;
 	union acpi_operand_object **dest;
-	acpi_status status = AE_OK;
 	u32 count;
 	u32 new_count;
 	u32 i;
 
+	ACPI_FUNCTION_NAME(ns_remove_null_elements);
+
+	/*
+	 * PTYPE1 packages contain no subpackages.
+	 * PTYPE2 packages contain a variable number of sub-packages. We can
+	 * safely remove all NULL elements from the PTYPE2 packages.
+	 */
+	switch (package_type) {
+	case ACPI_PTYPE1_FIXED:
+	case ACPI_PTYPE1_VAR:
+	case ACPI_PTYPE1_OPTION:
+		return;
+
+	case ACPI_PTYPE2:
+	case ACPI_PTYPE2_COUNT:
+	case ACPI_PTYPE2_PKG_COUNT:
+	case ACPI_PTYPE2_FIXED:
+	case ACPI_PTYPE2_MIN:
+	case ACPI_PTYPE2_REV_FIXED:
+		break;
+
+	default:
+		return;
+	}
+
 	count = obj_desc->package.count;
 	new_count = count;
 
 	source = obj_desc->package.elements;
 	dest = source;
 
-	/* Examine all elements of the package object */
+	/* Examine all elements of the package object, remove nulls */
 
 	for (i = 0; i < count; i++) {
 		if (!*source) {
-			status = AE_NULL_ENTRY;
 			new_count--;
 		} else {
 			*dest = *source;
@@ -582,15 +592,18 @@ acpi_ns_remove_null_elements(union acpi_operand_object *obj_desc)
 		source++;
 	}
 
-	if (status == AE_NULL_ENTRY) {
+	/* Update parent package if any null elements were removed */
+
+	if (new_count < count) {
+		ACPI_DEBUG_PRINT((ACPI_DB_REPAIR,
+				  "%s: Found and removed %u NULL elements\n",
+				  data->pathname, (count - new_count)));
 
 		/* NULL terminate list and update the package count */
 
 		*dest = NULL;
 		obj_desc->package.count = new_count;
 	}
-
-	return (status);
 }
 
 /******************************************************************************

>From dc1fd0b1133d84ef81bde570c00eeabee0996c5f Mon Sep 17 00:00:00 2001
From: Dan Carpenter <error27@gmail.com>
Date: Fri, 11 Dec 2009 15:31:40 +0800
Subject: [PATCH 15/16] ACPICA: Move check for valid Thread ID structure

This change moves the check for a valid Thread ID structure up a
few lines to insure that the check is made before the structure
is actually used.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/acpica/exmutex.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/exmutex.c b/drivers/acpi/acpica/exmutex.c
index 2f01142..3c456bd 100644
--- a/drivers/acpi/acpica/exmutex.c
+++ b/drivers/acpi/acpica/exmutex.c
@@ -375,6 +375,15 @@ acpi_ex_release_mutex(union acpi_operand_object *obj_desc,
 		return_ACPI_STATUS(AE_AML_MUTEX_NOT_ACQUIRED);
 	}
 
+	/* Must have a valid thread ID */
+
+	if (!walk_state->thread) {
+		ACPI_ERROR((AE_INFO,
+			    "Cannot release Mutex [%4.4s], null thread info",
+			    acpi_ut_get_node_name(obj_desc->mutex.node)));
+		return_ACPI_STATUS(AE_AML_INTERNAL);
+	}
+
 	/*
 	 * The Mutex is owned, but this thread must be the owner.
 	 * Special case for Global Lock, any thread can release
@@ -392,15 +401,6 @@ acpi_ex_release_mutex(union acpi_operand_object *obj_desc,
 		return_ACPI_STATUS(AE_AML_NOT_OWNER);
 	}
 
-	/* Must have a valid thread ID */
-
-	if (!walk_state->thread) {
-		ACPI_ERROR((AE_INFO,
-			    "Cannot release Mutex [%4.4s], null thread info",
-			    acpi_ut_get_node_name(obj_desc->mutex.node)));
-		return_ACPI_STATUS(AE_AML_INTERNAL);
-	}
-
 	/*
 	 * The sync level of the mutex must be equal to the current sync level. In
 	 * other words, the current level means that at least one mutex at that

>From 92053da7b273cfad6d60ded357cf76a74668a57d Mon Sep 17 00:00:00 2001
From: Bob Moore <robert.moore@intel.com>
Date: Tue, 15 Dec 2009 12:45:15 +0800
Subject: [PATCH 16/16] ACPICA: Update version to 20091214

Version 20091214.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/acpi/acpixf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 5e1ad3c..86e9735 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -47,7 +47,7 @@
 
 /* Current ACPICA subsystem version in YYYYMMDD format */
 
-#define ACPI_CA_VERSION                 0x20091112
+#define ACPI_CA_VERSION                 0x20091214
 
 #include "actypes.h"
 #include "actbl.h"


--=-q3IHO5iSQolxuIANUMA5--

