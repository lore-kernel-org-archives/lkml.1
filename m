Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0BJBLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:11:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38516 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0BJBLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:11:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Wed, 10 Feb 2010 02:12:29 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <20100209233154.GC12564@us.ibm.com> <201002100207.51180.rjw@sisk.pl>
In-Reply-To: <201002100207.51180.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100212.29904.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, Rafael J. Wysocki wrote:
> On Wednesday 10 February 2010, Gary Hade wrote:
> > On Tue, Feb 09, 2010 at 12:58:39PM -0800, Gary Hade wrote:
> ...
> > > OK.  I already confirmed that the problem reproduces with your
> > > patches applied.  I am now in the process of trying vanilla
> > > 2.6.33-rc7.  If hot-add works with 2.6.33-rc7 I will give
> > > your patch a try.
> > 
> > The hot-add worked fine with an unpatched 2.6.33-rc7.
> 
> Good.
> 
> > The new patch when added to the 2.6.33-rc7 tree that
> > included the original patchset unfortunately did not
> > correct the problem.
> 
> Bad.
> 
> Well, fortunately I have another one, but I haven't tested it myself yet except
> for checking that it builds.  Hopefully it won't break things more.
> 
> The patch below applies on top of 2.6.33-rc7 with my PCI runtime PM patchset
> applied.  Please test it and let me know the results.

Sorry, I sent a wrong version of the patch by mistake, it doesn't even build.
The correct one is appended.

Rafael

---
 drivers/pci/pci-acpi.c  |  240 ++++++++++++++++++++++++------------------------
 include/acpi/acpi_bus.h |    1 
 2 files changed, 124 insertions(+), 117 deletions(-)

Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -19,10 +19,13 @@
 #include <linux/pm_runtime.h>
 #include "pci.h"
 
-static DEFINE_MUTEX(pci_acpi_notifier_mtx);
+static DEFINE_MUTEX(pci_acpi_notify_mtx);
+static LIST_HEAD(pci_acpi_notify_list);
 
-struct pci_acpi_notify_data
+struct pci_acpi_notify_object
 {
+	struct list_head entry;
+	acpi_handle handle;
 	acpi_notify_handler hp_cb;
 	void *hp_data;
 	struct pci_bus *pci_bus;
@@ -33,7 +36,7 @@ struct pci_acpi_notify_data
  * pci_acpi_event_fn - Universal system notification handler.
  * @handle: ACPI handle of a device the notification is for.
  * @event: Type of the signaled event.
- * @ign: The value of this argument is ignored.
+ * @context: Pointer to the notify object associated with the handle.
  *
  * Use @handle to obtain the address of the ACPI device object the event is
  * signaled for.  If this is a wake-up event, execute the appropriate PME
@@ -41,116 +44,98 @@ struct pci_acpi_notify_data
  * bridge).  If this is not a wake-up event, execute the hotplug notify handler
  * for @handle.
  */
-static void pci_acpi_event_fn(acpi_handle handle, u32 event, void *ign)
+static void pci_acpi_event_fn(acpi_handle handle, u32 event, void *context)
 {
-	struct acpi_device *dev;
-	struct pci_acpi_notify_data *nd;
+	struct pci_acpi_notify_object *notify_obj = context;
 
-	if (ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
-		pr_warning("ACPI handle has no context in %s!\n", __func__);
+	if (!notify_obj)
 		return;
-	}
-
-	mutex_lock(&pci_acpi_notifier_mtx);
 
-	nd = dev->bus_data;
-	if (!nd)
-		goto out;
+	mutex_lock(&pci_acpi_notify_mtx);
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE) {
-		if (nd->pci_bus) {
-			pci_pme_wakeup_bus(nd->pci_bus);
+		if (notify_obj->pci_bus) {
+			pci_pme_wakeup_bus(notify_obj->pci_bus);
 		}
-		if (nd->pci_dev) {
-			pci_check_pme_status(nd->pci_dev);
-			pm_request_resume(&nd->pci_dev->dev);
+		if (notify_obj->pci_dev) {
+			pci_check_pme_status(notify_obj->pci_dev);
+			pm_request_resume(&notify_obj->pci_dev->dev);
 		}
-	} else if (nd->hp_cb) {
-		nd->hp_cb(handle, event, nd->hp_data);
+	} else if (notify_obj->hp_cb) {
+		notify_obj->hp_cb(handle, event, notify_obj->hp_data);
 	}
 
- out:
-	mutex_unlock(&pci_acpi_notifier_mtx);
+	mutex_unlock(&pci_acpi_notify_mtx);
 }
 
 /**
- * add_notify_data - Create a new notify data object for given ACPI device.
- * @dev: Device to create the notify data object for.
+ * add_notify_obj - Create a new notify object for given ACPI handle.
+ * @handle: ACPI handle to create the notify object for.
  */
-static struct pci_acpi_notify_data *add_notify_data(struct acpi_device *dev)
+static struct pci_acpi_notify_object *add_notify_obj(acpi_handle handle)
 {
-	struct pci_acpi_notify_data *nd;
+	struct pci_acpi_notify_object *notify_obj;
 
-	nd = kzalloc(sizeof(*nd), GFP_KERNEL);
-	if (!nd)
+	notify_obj = kzalloc(sizeof(*notify_obj), GFP_KERNEL);
+	if (!notify_obj)
 		return NULL;
 
-	dev->bus_data = nd;
-	return nd;
-}
-
-/**
- * remove_notify_data - Remove the notify data object from given ACPI device.
- * @dev: Device to remove the notify data object from.
- */
-static void remove_notify_data(struct acpi_device *dev)
-{
-	kfree(dev->bus_data);
-	dev->bus_data = NULL;
+	notify_obj->handle = handle;
+	return notify_obj;
 }
 
 /**
  * pci_acpi_add_hp_notifier - Register a hotplug notifier for given device.
- * @handle: ACPI handle of the device to register the notifier for.
+ * @handle: ACPI handle to register the notifier for.
  * @handler: Callback to execute for hotplug events related to @handle.
  * @context: Pointer to the context data to pass to @handler.
  *
- * Use @handle to get an ACPI device object and check if there is a notify data
- * object for it.  If this is the case, add @handler and @context to the
- * existing notify data object, unless there already is a hotplug handler in
- * there.  Otherwise, create a new notify data object for the ACPI device
- * associated with @handle and add @handler and @context to it.
+ * Find the notify object associated with @handle or create one if not found.
+ * Return error code if the notify object already contains a valid pointer to
+ * a hotplug handler or add @handler and @context to the notify object.
  */
 acpi_status pci_acpi_add_hp_notifier(acpi_handle handle,
 				     acpi_notify_handler handler, void *context)
 {
-	struct pci_acpi_notify_data *nd;
-	struct acpi_device *dev;
+	struct pci_acpi_notify_object *notify_obj;
 	acpi_status status = AE_OK;
 
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev)))
-		return AE_NOT_FOUND;
+	if (!handle)
+		return AE_BAD_PARAMETER;
 
-	mutex_lock(&pci_acpi_notifier_mtx);
+	mutex_lock(&pci_acpi_notify_mtx);
 
-	nd = dev->bus_data;
-	if (nd) {
-		if (!nd->hp_cb)
-			goto add;
-
-		status = AE_ALREADY_EXISTS;
-		goto out;
-	}
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle) {
+			if (notify_obj->hp_cb) {
+				status = AE_ALREADY_EXISTS;
+				goto out;
+			} else {
+				goto add;
+			}
+		}
 
-	nd = add_notify_data(dev);
-	if (!nd) {
+	notify_obj = add_notify_obj(handle);
+	if (!notify_obj) {
 		status = AE_NO_MEMORY;
 		goto out;
 	}
 
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						pci_acpi_event_fn, NULL);
+						pci_acpi_event_fn, notify_obj);
 	if (ACPI_FAILURE(status)) {
-		remove_notify_data(dev);
+		kfree(notify_obj);
 		goto out;
 	}
 
+	list_add_tail(&notify_obj->entry, &pci_acpi_notify_list);
+
  add:
-	nd->hp_cb = handler;
-	nd->hp_data = context;
+	notify_obj->hp_cb = handler;
+	notify_obj->hp_data = context;
 
  out:
-	mutex_unlock(&pci_acpi_notifier_mtx);
+	mutex_unlock(&pci_acpi_notify_mtx);
 
 	return status;
 }
@@ -161,38 +146,43 @@ EXPORT_SYMBOL_GPL(pci_acpi_add_hp_notifi
  * @handle: ACPI handle of the device to unregister the notifier for.
  * @handler: Callback executed for hotplug events related to @handle.
  *
- * Remove the hotplug callback and the pointer to the hotplug context data from
- * the notify data object belonging to the device represented by @handle.  If
- * the notify data object is not necessary any more, remove it altogether.
+ * Find the notify object corresponding to @handle and remove the pointers to
+ * the hotplug handler and data from it.  Return error code if the notify object
+ * is not found.
  */
 acpi_status pci_acpi_remove_hp_notifier(acpi_handle handle,
 					acpi_notify_handler handler)
 {
-	struct pci_acpi_notify_data *nd;
-	struct acpi_device *dev;
+	struct pci_acpi_notify_object *notify_obj;
 	acpi_status status = AE_NOT_FOUND;
 
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev)))
-		return AE_NOT_FOUND;
+	if (!handle)
+		return AE_BAD_PARAMETER;
 
-	mutex_lock(&pci_acpi_notifier_mtx);
+	mutex_lock(&pci_acpi_notify_mtx);
 
-	nd = dev->bus_data;
-	if (!nd)
-		goto out;
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle)
+			goto remove;
 
-	nd->hp_data = NULL;
-	nd->hp_cb = NULL;
+	goto out;
 
-	if (nd->pci_bus || nd->pci_dev)
+ remove:
+	notify_obj->hp_data = NULL;
+	notify_obj->hp_cb = NULL;
+
+	if (notify_obj->pci_bus || notify_obj->pci_dev) {
+		status = AE_OK;
 		goto out;
+	}
 
 	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 						pci_acpi_event_fn);
-	remove_notify_data(dev);
+	list_del(&notify_obj->entry);
+	kfree(notify_obj);
 
  out:
-	mutex_unlock(&pci_acpi_notifier_mtx);
+	mutex_unlock(&pci_acpi_notify_mtx);
 	return status;
 }
 EXPORT_SYMBOL_GPL(pci_acpi_remove_hp_notifier);
@@ -203,14 +193,13 @@ EXPORT_SYMBOL_GPL(pci_acpi_remove_hp_not
  * @pci_dev: PCI device to check for the PME status if an event is signaled.
  * @pci_bus: PCI bus to walk (checking PME status) if an event is signaled.
  *
- * Check if there is a notify data object for @dev and if that is the case, add
- * @pci_dev to it as the device whose PME status should be checked whenever a PM
- * event is signaled for @dev.  Also, add @pci_bus to it as the bus to walk
- * checking the PME status of all devices on it whenever a PM event is signaled
- * for @dev.
- *
- * Otherwise, create a new notify data object for @dev and add both @pci_dev and
- * @pci_bus to it.
+ * Use @dev to find the notify object corresponding to its handle or create a
+ * new one if not found.  Return error code if the notify object already
+ * contains a valid pointer to a PCI device or bus object.  Otherwise, add
+ * @pci_dev and @pci_bus to the notify object, as the device whose PME status
+ * should be checked whenever a PM event is signaled for @dev and the bus to
+ * walk checking the PME status of all devices on it whenever a PM event is
+ * signaled for @dev, respectively.
  *
  * NOTE: @dev need not be a run-wake or wake-up device to be a valid source of
  * PM wake-up events.  For example, wake-up events may be generated for bridges
@@ -221,34 +210,46 @@ acpi_status pci_acpi_add_pm_notifier(str
 				     struct pci_dev *pci_dev,
 				     struct pci_bus *pci_bus)
 {
-	struct pci_acpi_notify_data *nd;
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_handle handle = dev->handle;
 	acpi_status status = AE_OK;
 
-	mutex_lock(&pci_acpi_notifier_mtx);
+	if (!handle)
+		return AE_BAD_PARAMETER;
 
-	nd = dev->bus_data;
-	if (nd)
-		goto add;
+	mutex_lock(&pci_acpi_notify_mtx);
 
-	nd = add_notify_data(dev);
-	if (!nd) {
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle) {
+			if (notify_obj->pci_dev || notify_obj->pci_bus) {
+				status = AE_ALREADY_EXISTS;
+				goto out;
+			} else {
+				goto add;
+			}
+		}
+
+	notify_obj = add_notify_obj(handle);
+	if (!notify_obj) {
 		status = AE_NO_MEMORY;
 		goto out;
 	}
 
-	status = acpi_install_notify_handler(dev->handle, ACPI_SYSTEM_NOTIFY,
-						pci_acpi_event_fn, NULL);
+	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						pci_acpi_event_fn, notify_obj);
 	if (ACPI_FAILURE(status)) {
-		remove_notify_data(dev);
+		kfree(notify_obj);
 		goto out;
 	}
 
+	list_add_tail(&notify_obj->entry, &pci_acpi_notify_list);
+
  add:
-	nd->pci_dev = pci_dev;
-	nd->pci_bus = pci_bus;
+	notify_obj->pci_dev = pci_dev;
+	notify_obj->pci_bus = pci_bus;
 
  out:
-	mutex_unlock(&pci_acpi_notifier_mtx);
+	mutex_unlock(&pci_acpi_notify_mtx);
 	return status;
 }
 
@@ -256,33 +257,40 @@ acpi_status pci_acpi_add_pm_notifier(str
  * pci_acpi_remove_pm_notifier - Unregister PM notifier for given device.
  * @dev: ACPI device to remove the notifier from.
  *
- * Find the notify data object for @dev and clear its @pci_dev and @pci_bus
+ * Find the notify object for @dev and clear its @pci_dev and @pci_bus
  * fields.  If the notify data object is not necessary any more after that,
- * remove it too.
+ * remove it altogether.
  */
 acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
 {
-	struct pci_acpi_notify_data *nd;
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_handle handle = dev->handle;
 	acpi_status status = AE_NOT_FOUND;
 
-	mutex_lock(&pci_acpi_notifier_mtx);
+	mutex_lock(&pci_acpi_notify_mtx);
 
-	nd = dev->bus_data;
-	if (!nd)
-		goto out;
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle)
+			goto remove;
+
+	goto out;
 
-	nd->pci_dev = NULL;
-	nd->pci_bus = NULL;
+ remove:
+	notify_obj->pci_dev = NULL;
+	notify_obj->pci_bus = NULL;
 
-	if (nd->hp_cb)
+	if (notify_obj->hp_cb) {
+		status = AE_OK;
 		goto out;
+	}
 
 	status = acpi_remove_notify_handler(dev->handle, ACPI_SYSTEM_NOTIFY,
 						pci_acpi_event_fn);
-	remove_notify_data(dev);
+	list_del(&notify_obj->entry);
+	kfree(notify_obj);
 
  out:
-	mutex_unlock(&pci_acpi_notifier_mtx);
+	mutex_unlock(&pci_acpi_notify_mtx);
 	return status;
 }
 
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -282,7 +282,6 @@ struct acpi_device {
 	struct device dev;
 	struct acpi_bus_ops bus_ops;	/* workaround for different code path for hotplug */
 	enum acpi_bus_removal_type removal_type;	/* indicate for different removal type */
-	void *bus_data;
 };
 
 static inline void *acpi_driver_data(struct acpi_device *d)
