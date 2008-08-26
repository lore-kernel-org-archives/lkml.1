Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYHZTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYHZTBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbYHZTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:00:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50635 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758619AbYHZS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:59:52 -0400
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 3/4] acpi: add lockdep magic
Date: Tue, 26 Aug 2008 11:59:48 -0700
Message-Id: <1219777186-4787-3-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.32.gba7d2
In-Reply-To: <1219777186-4787-2-git-send-email-dwalker@mvista.com>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
 <1219777186-4787-2-git-send-email-dwalker@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep integration for the ACPI mutex usage.

Cc: linux-acpi@vger.kernel.org
Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/acpi/dispatcher/dsmethod.c |    4 ++++
 drivers/acpi/executer/excreate.c   |    4 ++++
 drivers/acpi/namespace/nsaccess.c  |    5 +++++
 drivers/acpi/utilities/utmutex.c   |    6 ++++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/dispatcher/dsmethod.c b/drivers/acpi/dispatcher/dsmethod.c
index 4613b9c..a3cf3d4 100644
--- a/drivers/acpi/dispatcher/dsmethod.c
+++ b/drivers/acpi/dispatcher/dsmethod.c
@@ -130,6 +130,7 @@ acpi_ds_method_error(acpi_status status, struct acpi_walk_state *walk_state)
 static acpi_status
 acpi_ds_create_method_mutex(union acpi_operand_object *method_desc)
 {
+	static struct lock_class_key method_mutex;
 	union acpi_operand_object *mutex_desc;
 	acpi_status status;
 
@@ -149,6 +150,9 @@ acpi_ds_create_method_mutex(union acpi_operand_object *method_desc)
 		return_ACPI_STATUS(status);
 	}
 
+	lockdep_set_class((struct mutex *)&mutex_desc->mutex.os_mutex,
+			  &method_mutex);
+
 	mutex_desc->mutex.sync_level = method_desc->method.sync_level;
 	method_desc->method.mutex = mutex_desc;
 	return_ACPI_STATUS(AE_OK);
diff --git a/drivers/acpi/executer/excreate.c b/drivers/acpi/executer/excreate.c
index ad09696..044a780 100644
--- a/drivers/acpi/executer/excreate.c
+++ b/drivers/acpi/executer/excreate.c
@@ -222,6 +222,7 @@ acpi_status acpi_ex_create_mutex(struct acpi_walk_state *walk_state)
 {
 	acpi_status status = AE_OK;
 	union acpi_operand_object *obj_desc;
+	static struct lock_class_key interpreter_class;
 
 	ACPI_FUNCTION_TRACE_PTR(ex_create_mutex, ACPI_WALK_OPERANDS);
 
@@ -240,6 +241,9 @@ acpi_status acpi_ex_create_mutex(struct acpi_walk_state *walk_state)
 		goto cleanup;
 	}
 
+	lockdep_set_class((struct mutex *)obj_desc->mutex.os_mutex,
+			  &interpreter_class);
+
 	/* Init object and attach to NS node */
 
 	obj_desc->mutex.sync_level =
diff --git a/drivers/acpi/namespace/nsaccess.c b/drivers/acpi/namespace/nsaccess.c
index c39a7f6..293c0ba 100644
--- a/drivers/acpi/namespace/nsaccess.c
+++ b/drivers/acpi/namespace/nsaccess.c
@@ -64,6 +64,7 @@ ACPI_MODULE_NAME("nsaccess")
  ******************************************************************************/
 acpi_status acpi_ns_root_initialize(void)
 {
+	static struct lock_class_key ns_root_mutex;
 	acpi_status status;
 	const struct acpi_predefined_names *init_val = NULL;
 	struct acpi_namespace_node *new_node;
@@ -205,6 +206,10 @@ acpi_status acpi_ns_root_initialize(void)
 					goto unlock_and_exit;
 				}
 
+				lockdep_set_class((struct mutex *)
+					obj_desc->mutex.os_mutex,
+					&ns_root_mutex);
+
 				/* Special case for ACPI Global Lock */
 
 				if (ACPI_STRCMP(init_val->name, "_GL_") == 0) {
diff --git a/drivers/acpi/utilities/utmutex.c b/drivers/acpi/utilities/utmutex.c
index 7331dde..3f7f16c 100644
--- a/drivers/acpi/utilities/utmutex.c
+++ b/drivers/acpi/utilities/utmutex.c
@@ -134,6 +134,7 @@ void acpi_ut_mutex_terminate(void)
 
 static acpi_status acpi_ut_create_mutex(acpi_mutex_handle mutex_id)
 {
+	static struct lock_class_key utility_class_keys[ACPI_MAX_MUTEX];
 	acpi_status status = AE_OK;
 
 	ACPI_FUNCTION_TRACE_U32(ut_create_mutex, mutex_id);
@@ -145,6 +146,11 @@ static acpi_status acpi_ut_create_mutex(acpi_mutex_handle mutex_id)
 	if (!acpi_gbl_mutex_info[mutex_id].mutex) {
 		status =
 		    acpi_os_create_mutex(&acpi_gbl_mutex_info[mutex_id].mutex);
+
+		lockdep_set_class(
+			(struct mutex *)acpi_gbl_mutex_info[mutex_id].mutex,
+			&utility_class_keys[mutex_id]);
+
 		acpi_gbl_mutex_info[mutex_id].thread_id =
 		    ACPI_MUTEX_NOT_ACQUIRED;
 		acpi_gbl_mutex_info[mutex_id].use_count = 0;
-- 
1.5.5.1.32.gba7d2


