Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0BUAud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 19:50:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab0BUAua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 19:50:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH] ACPI: Eliminate race conditions related to removing event handlers
Date: Sun, 21 Feb 2010 01:51:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002210151.01159.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current ACPI events handling code has two design issues that
need fixing.  First, there is a race condition between the event
queues and the removal of GPE handlers and notify handlers that may
cause a handler to be removed while it's being executed, which in
turn may lead to udefined behavior.  Second, the GPE handler removal
routine, acpi_remove_gpe_handler(), releases ACPI_MTX_EVENTS in the
middle of the operation, which effectively renders the locking
useless.  It turns out that the both of them can be fixed at the same
time.

To fix the first issue use the observation that all of the ACPI
workqueues are singlethread, so it is possible to flush the
execution of queued work by inserting a cleverly crafted work item
into the appropriate workqueue.  For this purpose use a barrier work
structure containing two completion objects, 'run' and 'exit', and a
pair of interface functions, acpi_os_add_events_barrier() and
acpi_os_remove_events_barrier(), the first of which puts a barrier
work into the workqueue indicated by its argument and waits for the
'run' completion to be completed, and the second of which completes
the 'exit' completion (the first one returns a pointer to the barrier
work object to be passed as an argument to the second one).  The work
function inserted into the workqueue by acpi_os_add_events_barrier()
completes the 'run' completion and waits for the 'exit' completion.
Thus, by executing acpi_os_add_events_barrier() with an appropriate
type argument the caller ensures that all events of this type queued
up earlier will be handled before it is allowed to continue running
and all events of this type queued up later will be handled until
acpi_os_remove_events_barrier() is called.

Modify acpi_remove_notify_handler() and acpi_remove_gpe_handler() to
use this interface, which also fixes the second issue, because the
new interface replaces acpi_os_wait_events_complete() that was the
reason for the releasing of ACPI_MTX_EVENTS in the middle of the
operation by acpi_remove_gpe_handler().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/evxface.c |   33 +++++++-----
 drivers/acpi/osl.c            |  113 ++++++++++++++++++++++++++++++++++--------
 include/acpi/acpiosxf.h       |    3 -
 3 files changed, 115 insertions(+), 34 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -61,6 +61,12 @@ struct acpi_os_dpc {
 	int wait;
 };
 
+struct acpi_os_barrier_work {
+	struct completion run;
+	struct completion exit;
+	struct work_struct work;
+};
+
 #ifdef CONFIG_ACPI_CUSTOM_DSDT
 #include CONFIG_ACPI_CUSTOM_DSDT_FILE
 #endif
@@ -700,28 +706,15 @@ static void acpi_os_execute_deferred(str
 {
 	struct acpi_os_dpc *dpc = container_of(work, struct acpi_os_dpc, work);
 
-	if (dpc->wait)
-		acpi_os_wait_events_complete(NULL);
+	if (dpc->wait) {
+		flush_workqueue(kacpid_wq);
+		flush_workqueue(kacpi_notify_wq);
+	}
 
 	dpc->function(dpc->context);
 	kfree(dpc);
 }
 
-/*******************************************************************************
- *
- * FUNCTION:    acpi_os_execute
- *
- * PARAMETERS:  Type               - Type of the callback
- *              Function           - Function to be executed
- *              Context            - Function parameters
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Depending on type, either queues function for deferred execution or
- *              immediately executes function on a separate thread.
- *
- ******************************************************************************/
-
 static acpi_status __acpi_os_execute(acpi_execute_type type,
 	acpi_osd_exec_callback function, void *context, int hp)
 {
@@ -770,6 +763,20 @@ static acpi_status __acpi_os_execute(acp
 	return status;
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_os_execute
+ *
+ * PARAMETERS:  Type               - Type of the callback
+ *              Function           - Function to be executed
+ *              Context            - Function parameters
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Depending on type, either queues function for deferred execution or
+ *              immediately executes function on a separate thread.
+ *
+ ******************************************************************************/
 acpi_status acpi_os_execute(acpi_execute_type type,
 			    acpi_osd_exec_callback function, void *context)
 {
@@ -783,13 +790,77 @@ acpi_status acpi_os_hotplug_execute(acpi
 	return __acpi_os_execute(0, function, context, 1);
 }
 
-void acpi_os_wait_events_complete(void *context)
+static void acpi_os_barrier_fn(struct work_struct *work)
 {
-	flush_workqueue(kacpid_wq);
-	flush_workqueue(kacpi_notify_wq);
+	struct acpi_os_barrier_work *barrier;
+
+	barrier = container_of(work, struct acpi_os_barrier_work, work);
+	complete(&barrier->run);
+	wait_for_completion(&barrier->exit);
+	kfree(barrier);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_os_add_events_barrier
+ *
+ * PARAMETERS:  type               - Type of events to add the barrier for
+ *
+ * RETURN:      Context to be passed to acpi_os_remove_events_barrier() or NULL
+ *              on failure.
+ *
+ * DESCRIPTION: Ensure that all of the events of given type either have been
+ *              handled before we continue running or will not be handled until
+ *              acpi_os_remove_events_barrier() is run.
+ *
+ ******************************************************************************/
+void *acpi_os_add_events_barrier(acpi_execute_type type)
+{
+	struct acpi_os_barrier_work *barrier;
+	struct workqueue_struct *queue;
+	int ret;
+
+	barrier = kmalloc(sizeof(*barrier), GFP_KERNEL);
+	if (!barrier)
+		return NULL;
+
+	init_completion(&barrier->run);
+	init_completion(&barrier->exit);
+	INIT_WORK(&barrier->work, acpi_os_barrier_fn);
+	queue = (type == OSL_NOTIFY_HANDLER) ? kacpi_notify_wq : kacpid_wq;
+	ret = queue_work(queue, &barrier->work);
+	if (!ret) {
+		printk(KERN_ERR PREFIX "queue_work() failed!\n");
+		kfree(barrier);
+		return NULL;
+	}
+
+	wait_for_completion(&barrier->run);
+
+	return barrier;
 }
+EXPORT_SYMBOL(acpi_os_add_events_barrier);
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_os_remove_events_barrier
+ *
+ * PARAMETERS:  context               - Information needed to remove the barrier
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Using the context information remove an events barrier added by
+ *              acpi_os_add_events_barrier().
+ *
+ ******************************************************************************/
+void acpi_os_remove_events_barrier(void *context)
+{
+	struct acpi_os_barrier_work *barrier = context;
 
-EXPORT_SYMBOL(acpi_os_wait_events_complete);
+	if (barrier)
+		complete(&barrier->exit);
+}
+EXPORT_SYMBOL(acpi_os_remove_events_barrier);
 
 /*
  * Allocate the memory for a spinlock and initialize it.
Index: linux-2.6/include/acpi/acpiosxf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpiosxf.h
+++ linux-2.6/include/acpi/acpiosxf.h
@@ -194,7 +194,8 @@ acpi_os_execute(acpi_execute_type type,
 acpi_status
 acpi_os_hotplug_execute(acpi_osd_exec_callback function, void *context);
 
-void acpi_os_wait_events_complete(void *context);
+void *acpi_os_add_events_barrier(acpi_execute_type type);
+void acpi_os_remove_events_barrier(void *context);
 
 void acpi_os_sleep(acpi_integer milliseconds);
 
Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -497,6 +497,7 @@ acpi_remove_notify_handler(acpi_handle d
 	union acpi_operand_object *notify_obj;
 	union acpi_operand_object *obj_desc;
 	struct acpi_namespace_node *node;
+	void *events_barrier;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_remove_notify_handler);
@@ -511,11 +512,16 @@ acpi_remove_notify_handler(acpi_handle d
 
 
 	/* Make sure all deferred tasks are completed */
-	acpi_os_wait_events_complete(NULL);
+
+	events_barrier = acpi_os_add_events_barrier(OSL_NOTIFY_HANDLER);
+	if (!events_barrier) {
+		status = AE_ERROR;
+		goto exit;
+	}
 
 	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
 	if (ACPI_FAILURE(status)) {
-		goto exit;
+		goto release_events;
 	}
 
 	/* Convert and validate the device handle */
@@ -653,6 +659,8 @@ acpi_remove_notify_handler(acpi_handle d
 
       unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+      release_events:
+        acpi_os_remove_events_barrier(events_barrier);
       exit:
 	if (ACPI_FAILURE(status))
 		ACPI_EXCEPTION((AE_INFO, status, "Removing notify handler"));
@@ -774,6 +782,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 {
 	struct acpi_gpe_event_info *gpe_event_info;
 	struct acpi_handler_info *handler;
+	void *events_barrier;
 	acpi_status status;
 	acpi_cpu_flags flags;
 
@@ -785,9 +794,16 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
+	/* Make sure all deferred tasks are completed */
+
+	events_barrier = acpi_os_add_events_barrier(OSL_GPE_HANDLER);
+	if (!events_barrier) {
+		return_ACPI_STATUS(AE_ERROR);
+	}
+
 	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
 	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
+		goto release_events;
 	}
 
 	/* Ensure that we have a valid GPE number */
@@ -813,15 +829,6 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		goto unlock_and_exit;
 	}
 
-	/* Make sure all deferred tasks are completed */
-
-	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
-	acpi_os_wait_events_complete(NULL);
-	status = acpi_ut_acquire_mutex(ACPI_MTX_EVENTS);
-	if (ACPI_FAILURE(status)) {
-		return_ACPI_STATUS(status);
-	}
-
 	/* Remove the handler */
 
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
@@ -842,6 +849,8 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 
       unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
+      release_events:
+	acpi_os_remove_events_barrier(events_barrier);
 	return_ACPI_STATUS(status);
 }
 
