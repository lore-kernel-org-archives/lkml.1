Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYJKGiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYJKGiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYJKGgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:36:55 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52440 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYJKGgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:53 -0400
Date: Sat, 11 Oct 2008 02:35:34 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 14/85] ACPICA: Add function to dereference returned reference
 objects
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <30c49107813a0e2fab185c7a28d7e829fc4841e8.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Examines the return object from a call to acpi_evaluate_object.
Any Index or RefOf references are automatically dereferenced in
an attempt to return something useful (these reference types
cannot be converted into an external ACPI_OBJECT.)
Lin Ming, Bob Moore.

http://bugzilla.kernel.org/show_bug.cgi?id=11105

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/namespace/nsxfeval.c |   79 +++++++++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
index 38be586..f3cc376 100644
--- a/drivers/acpi/namespace/nsxfeval.c
+++ b/drivers/acpi/namespace/nsxfeval.c
@@ -45,9 +45,14 @@
 #include <acpi/acpi.h>
 #include <acpi/acnamesp.h>
 #include <acpi/acinterp.h>
+#include <acpi/amlcode.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsxfeval")
+
+/* Local prototypes */
+static void acpi_ns_resolve_references(struct acpi_evaluate_info *info);
+
 #ifdef ACPI_FUTURE_USAGE
 /*******************************************************************************
  *
@@ -69,6 +74,7 @@ ACPI_MODULE_NAME("nsxfeval")
  *              be valid (non-null)
  *
  ******************************************************************************/
+
 acpi_status
 acpi_evaluate_object_typed(acpi_handle handle,
 			   acpi_string pathname,
@@ -283,6 +289,10 @@ acpi_evaluate_object(acpi_handle handle,
 
 			if (ACPI_SUCCESS(status)) {
 
+				/* Dereference Index and ref_of references */
+
+				acpi_ns_resolve_references(info);
+
 				/* Get the size of the returned object */
 
 				status =
@@ -352,6 +362,74 @@ ACPI_EXPORT_SYMBOL(acpi_evaluate_object)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_ns_resolve_references
+ *
+ * PARAMETERS:  Info                    - Evaluation info block
+ *
+ * RETURN:      Info->return_object is replaced with the dereferenced object
+ *
+ * DESCRIPTION: Dereference certain reference objects. Called before an
+ *              internal return object is converted to an external union acpi_object.
+ *
+ * Performs an automatic dereference of Index and ref_of reference objects.
+ * These reference objects are not supported by the union acpi_object, so this is a
+ * last resort effort to return something useful. Also, provides compatibility
+ * with other ACPI implementations.
+ *
+ * NOTE: does not handle references within returned package objects or nested
+ * references, but this support could be added later if found to be necessary.
+ *
+ ******************************************************************************/
+static void acpi_ns_resolve_references(struct acpi_evaluate_info *info)
+{
+	union acpi_operand_object *obj_desc = NULL;
+	struct acpi_namespace_node *node;
+
+	/* We are interested in reference objects only */
+
+	if (ACPI_GET_OBJECT_TYPE(info->return_object) !=
+	    ACPI_TYPE_LOCAL_REFERENCE) {
+		return;
+	}
+
+	/*
+	 * Two types of references are supported - those created by Index and
+	 * ref_of operators. A name reference (AML_NAMEPATH_OP) can be converted
+	 * to an union acpi_object, so it is not dereferenced here. A ddb_handle
+	 * (AML_LOAD_OP) cannot be dereferenced, nor can it be converted to
+	 * an union acpi_object.
+	 */
+	switch (info->return_object->reference.opcode) {
+	case AML_INDEX_OP:
+
+		obj_desc = *(info->return_object->reference.where);
+		break;
+
+	case AML_REF_OF_OP:
+
+		node = info->return_object->reference.object;
+		if (node) {
+			obj_desc = node->object;
+		}
+		break;
+
+	default:
+		return;
+	}
+
+	/* Replace the existing reference object */
+
+	if (obj_desc) {
+		acpi_ut_add_reference(obj_desc);
+		acpi_ut_remove_reference(info->return_object);
+		info->return_object = obj_desc;
+	}
+
+	return;
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_walk_namespace
  *
  * PARAMETERS:  Type                - acpi_object_type to search for
@@ -379,6 +457,7 @@ ACPI_EXPORT_SYMBOL(acpi_evaluate_object)
  *              function, etc.
  *
  ******************************************************************************/
+
 acpi_status
 acpi_walk_namespace(acpi_object_type type,
 		    acpi_handle start_object,
-- 
1.5.5.1

