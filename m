Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0BQWpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:45:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab0BQWpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:45:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH 6/8] ACPI / ACPICA: Multiple system notify handlers per device
Date: Wed, 17 Feb 2010 23:42:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
References: <201002172335.47703.rjw@sisk.pl>
In-Reply-To: <201002172335.47703.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201002172342.59544.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently it only is possible to install one system notify handler
per namespace node, but this is not enough for PCI run-time power
management, because we need to install power management notifiers for
devices that already have hotplug notifiers installed.  While in
principle this could be handled at the PCI level, that would be
suboptimal due to the way in which the ACPI-based PCI hotplug code is
designed.

For this reason, modify ACPICA so that it is possible to install more
than one system notify handler per namespace node.  Namely, make
acpi_install_notify_handler(), acpi_remove_notify_handler() and
acpi_ev_notify_dispatch() use a list of system notify handler objects
associated with a namespace node.

Make acpi_remove_notify_handler() call acpi_os_wait_events_complete()
upfront to avoid a situation in which concurrent instance of
acpi_remove_notify_handler() removes the handler from under us while
we're waiting for the event queues to flush.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/acobject.h |    2 
 drivers/acpi/acpica/evmisc.c   |   12 ++
 drivers/acpi/acpica/evxface.c  |  175 ++++++++++++++++++++++++++++++++---------
 3 files changed, 150 insertions(+), 39 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/acobject.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/acobject.h
+++ linux-2.6/drivers/acpi/acpica/acobject.h
@@ -287,8 +287,10 @@ struct acpi_object_buffer_field {
 
 struct acpi_object_notify_handler {
 	ACPI_OBJECT_COMMON_HEADER struct acpi_namespace_node *node;	/* Parent device */
+	u32 handler_type;
 	acpi_notify_handler handler;
 	void *context;
+	struct acpi_object_notify_handler *next;
 };
 
 struct acpi_object_addr_handler {
Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -218,6 +218,72 @@ ACPI_EXPORT_SYMBOL(acpi_remove_fixed_eve
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_populate_handler_object
+ *
+ * PARAMETERS:  handler_obj        - Handler object to populate
+ *              handler_type       - The type of handler:
+ *                                  ACPI_SYSTEM_NOTIFY: system_handler (00-7f)
+ *                                  ACPI_DEVICE_NOTIFY: driver_handler (80-ff)
+ *                                  ACPI_ALL_NOTIFY:  both system and device
+ *              handler            - Address of the handler
+ *              context            - Value passed to the handler on each GPE
+ *              next               - Address of a handler object to link to
+ *
+ * RETURN:      None
+ *
+ * DESCRIPTION: Populate a handler object.
+ *
+ ******************************************************************************/
+static void
+acpi_populate_handler_object(struct acpi_object_notify_handler *handler_obj,
+			     u32 handler_type,
+			     acpi_notify_handler handler, void *context,
+			     struct acpi_object_notify_handler *next)
+{
+	handler_obj->handler_type = handler_type;
+	handler_obj->handler = handler;
+	handler_obj->context = context;
+	handler_obj->next = next;
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_add_handler_object
+ *
+ * PARAMETERS:  parent_obj         - Parent of the new object
+ *              handler            - Address of the handler
+ *              context            - Value passed to the handler on each GPE
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Create a new handler object and populate it.
+ *
+ ******************************************************************************/
+static acpi_status
+acpi_add_handler_object(struct acpi_object_notify_handler *parent_obj,
+			acpi_notify_handler handler, void *context)
+{
+	struct acpi_object_notify_handler *handler_obj;
+
+	/* The parent must not be a defice notify handler object. */
+	if (parent_obj->handler_type & ACPI_DEVICE_NOTIFY)
+		return AE_BAD_PARAMETER;
+
+	handler_obj = ACPI_ALLOCATE_ZEROED(sizeof(*handler_obj));
+	if (!handler_obj)
+		return AE_NO_MEMORY;
+
+	acpi_populate_handler_object(handler_obj,
+					ACPI_SYSTEM_NOTIFY,
+					handler, context,
+					parent_obj->next);
+	parent_obj->next = handler_obj;
+
+	return AE_OK;
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_install_notify_handler
  *
  * PARAMETERS:  Device          - The device for which notifies will be handled
@@ -316,15 +382,32 @@ acpi_install_notify_handler(acpi_handle 
 		obj_desc = acpi_ns_get_attached_object(node);
 		if (obj_desc) {
 
-			/* Object exists - make sure there's no handler */
+			/* Object exists. */
 
-			if (((handler_type & ACPI_SYSTEM_NOTIFY) &&
-			     obj_desc->common_notify.system_notify) ||
-			    ((handler_type & ACPI_DEVICE_NOTIFY) &&
-			     obj_desc->common_notify.device_notify)) {
+			/* For a device notify, make sure there's no handler. */
+			if ((handler_type & ACPI_DEVICE_NOTIFY) &&
+			     obj_desc->common_notify.device_notify) {
 				status = AE_ALREADY_EXISTS;
 				goto unlock_and_exit;
 			}
+
+			/* System notifies may have more handlers installed. */
+			notify_obj = obj_desc->common_notify.system_notify;
+
+			if ((handler_type & ACPI_SYSTEM_NOTIFY) && notify_obj) {
+				struct acpi_object_notify_handler *parent_obj;
+
+				if (handler_type & ACPI_DEVICE_NOTIFY) {
+					status = AE_ALREADY_EXISTS;
+					goto unlock_and_exit;
+				}
+
+				parent_obj = &notify_obj->notify;
+				status = acpi_add_handler_object(parent_obj,
+								 handler,
+								 context);
+				goto unlock_and_exit;
+			}
 		} else {
 			/* Create a new object */
 
@@ -356,9 +439,10 @@ acpi_install_notify_handler(acpi_handle 
 			goto unlock_and_exit;
 		}
 
-		notify_obj->notify.node = node;
-		notify_obj->notify.handler = handler;
-		notify_obj->notify.context = context;
+		acpi_populate_handler_object(&notify_obj->notify,
+						handler_type,
+						handler, context,
+						NULL);
 
 		if (handler_type & ACPI_SYSTEM_NOTIFY) {
 			obj_desc->common_notify.system_notify = notify_obj;
@@ -418,6 +502,10 @@ acpi_remove_notify_handler(acpi_handle d
 		goto exit;
 	}
 
+
+	/* Make sure all deferred tasks are completed */
+	acpi_os_wait_events_complete(NULL);
+
 	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
 	if (ACPI_FAILURE(status)) {
 		goto exit;
@@ -445,15 +533,6 @@ acpi_remove_notify_handler(acpi_handle d
 			goto unlock_and_exit;
 		}
 
-		/* Make sure all deferred tasks are completed */
-
-		(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
-		acpi_os_wait_events_complete(NULL);
-		status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
-		if (ACPI_FAILURE(status)) {
-			goto exit;
-		}
-
 		if (handler_type & ACPI_SYSTEM_NOTIFY) {
 			acpi_gbl_system_notify.node = NULL;
 			acpi_gbl_system_notify.handler = NULL;
@@ -488,28 +567,60 @@ acpi_remove_notify_handler(acpi_handle d
 		/* Object exists - make sure there's an existing handler */
 
 		if (handler_type & ACPI_SYSTEM_NOTIFY) {
+			struct acpi_object_notify_handler *handler_obj;
+			struct acpi_object_notify_handler *parent_obj;
+
 			notify_obj = obj_desc->common_notify.system_notify;
 			if (!notify_obj) {
 				status = AE_NOT_EXIST;
 				goto unlock_and_exit;
 			}
 
-			if (notify_obj->notify.handler != handler) {
+			handler_obj = &notify_obj->notify;
+			parent_obj = NULL;
+			while (handler_obj->handler != handler) {
+				if (handler_obj->next) {
+					parent_obj = handler_obj;
+					handler_obj = handler_obj->next;
+				} else {
+					break;
+				}
+			}
+
+			if (handler_obj->handler != handler) {
 				status = AE_BAD_PARAMETER;
 				goto unlock_and_exit;
 			}
-			/* Make sure all deferred tasks are completed */
 
-			(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
-			acpi_os_wait_events_complete(NULL);
-			status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
-			if (ACPI_FAILURE(status)) {
-				goto exit;
+			/*
+			 * Remove the handler.  There are three possible cases.
+			 * First, we may need to remove a non-embedded object.
+			 * Second, we may need to remove the embedded object's
+			 * handler data, while non-embedded objects exist.
+			 * Finally, we may need to remove the embedded object
+			 * entirely along with its container.
+			 */
+			if (parent_obj) {
+				/* Non-embedded object is being removed. */
+				parent_obj->next = handler_obj->next;
+				ACPI_FREE(handler_obj);
+			} else if (notify_obj->notify.next) {
+				/*
+				 * The handler matches the embedded object, but
+				 * there are more handler objects in the list.
+				 * Replace the embedded object's data with the
+				 * first next object's data and remove that
+				 * object.
+				 */
+				parent_obj = &notify_obj->notify;
+				handler_obj = notify_obj->notify.next;
+				*parent_obj = *handler_obj;
+				ACPI_FREE(handler_obj);
+			} else {
+				/* No more handler objects in the list. */
+				obj_desc->common_notify.system_notify = NULL;
+				acpi_ut_remove_reference(notify_obj);
 			}
-
-			/* Remove the handler */
-			obj_desc->common_notify.system_notify = NULL;
-			acpi_ut_remove_reference(notify_obj);
 		}
 
 		if (handler_type & ACPI_DEVICE_NOTIFY) {
@@ -523,14 +634,6 @@ acpi_remove_notify_handler(acpi_handle d
 				status = AE_BAD_PARAMETER;
 				goto unlock_and_exit;
 			}
-			/* Make sure all deferred tasks are completed */
-
-			(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
-			acpi_os_wait_events_complete(NULL);
-			status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
-			if (ACPI_FAILURE(status)) {
-				goto exit;
-			}
 
 			/* Remove the handler */
 			obj_desc->common_notify.device_notify = NULL;
Index: linux-2.6/drivers/acpi/acpica/evmisc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evmisc.c
+++ linux-2.6/drivers/acpi/acpica/evmisc.c
@@ -259,9 +259,15 @@ static void ACPI_SYSTEM_XFACE acpi_ev_no
 
 	handler_obj = notify_info->notify.handler_obj;
 	if (handler_obj) {
-		handler_obj->notify.handler(notify_info->notify.node,
-					    notify_info->notify.value,
-					    handler_obj->notify.context);
+		struct acpi_object_notify_handler *notifier;
+
+		notifier = &handler_obj->notify;
+		while (notifier) {
+			notifier->handler(notify_info->notify.node,
+					  notify_info->notify.value,
+					  notifier->context);
+			notifier = notifier->next;
+		}
 	}
 
 	/* All done with the info object */

