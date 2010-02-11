Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0BKWUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:20:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab0BKWUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:20:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Thu, 11 Feb 2010 23:21:13 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <201002112132.02255.rjw@sisk.pl> <20100211215604.GA10298@us.ibm.com>
In-Reply-To: <20100211215604.GA10298@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002112321.13922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Gary Hade wrote:
> On Thu, Feb 11, 2010 at 09:32:02PM +0100, Rafael J. Wysocki wrote:
> > On Thursday 11 February 2010, Gary Hade wrote:
> > > On Thu, Feb 11, 2010 at 02:27:17PM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > > > > > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > > > > ...
> > > > > > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > > > > > I was already doing what you asked except in the opposite order.
> > > > > > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > > > > > 
> > > > > > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > > > > > 
> > > > > > > > Thanks!
> > > > > > > > 
> > > > > > > > > 
> > > > > > > > > What's your kernel command line, BTW?
> > > > > > > > 
> > > > > > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > > > > > 
> > > > > > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > > > > > specific command line switch to trigger, which you don't use.
> > > > > > > 
> > > > > > > I'll let you know if I have anything to test.
> > > > > > 
> > > > > > OK, please try the patch below on top of [1-6/9].
> > > > > 
> > > > > Sorry, it didn't help.  The hot-add and hot-remove behaviors
> > > > > still look the same.
> > > > 
> > > > Thanks for testing.
> > > > 
> > > > Well, this time I found another real bug, which is that we should add
> > > > gpe_block->block_base_number to the GPE index within the block in order to
> > > > compute the GPE number.  If there are GPE devices other than the FADT ones in
> > > > your system, that may explain the symptoms.
> > > > 
> > > > Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
> > > > look for "Failed to ebable GPE" messages in dmesg and let me know if there are
> > > > any.
> > > 
> > > That one worked!  It corrected both the blinking amber LED
> > > after hot-remove and acpiphp's failure to see the hot-add event.
> > 
> > Great!
> > 
> > > Now when you have patch(es) ready for Jesse's linux-next branch
> > 
> > Well, not quite.  I had to rework them in the meantime. ;-)
> > 
> > > I can get back to my original mission of checking out Bjorn's
> > > _CRS enablement changes.
> > 
> > May I still ask you to test something?
> 
> Oh, I guess so. :)
> 
> > 
> > In case I can, please try the appended patch on top of [1-3/6].  It is a
> > replacement for [4-6/9] with the last fix included.
> 
> I just tried it and it seemed to work fine.

Great, thanks!

I have one more testing request if you don't mind, but I'd like to make sure
the PCI runtime PM patches won't break the PCI hotplug again.

Please apply [7/9] (ACPI / PM: Add more run-time wake-up field) on top of the
just tested patch and apply the appended patch on top of that.  Then, please
check if the PCI hotplug still works.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 8)

Although the majority of PCI devices can generate PMEs that in
principle may be used to wake up devices suspended at run time,
platform support is generally necessary to convert PMEs into wake-up
events that can be delivered to the kernel.  If ACPI is used for this
purpose, a PME generated by a PCI device will trigger the ACPI GPE
associated with the device to generate an ACPI wake-up event that we
can set up a handler for, provided that everything is configured
correctly.

Unfortunately, the subset of PCI devices that have GPEs associated
with them is quite limited and the other devices have to rely on
the GPEs associated with their upstream bridges and, possibly, the
root bridge to generate ACPI wake-up events in response to PMEs from
them.  Moreover, ACPI-based PCI hotplug also uses ACPI notify
handlers that in general may conflict with the PM notify handlers,
unless this issue is specifically taken care of.

Add ACPI platform support for PCI PME wake-up:
o Add a framework making is possible to use ACPI system notify
  handlers for both PM and hotplug at the same time and to take the
  wake-up GPE sharing into account.
o Add new PCI platform callback ->run_wake() to struct
  pci_platform_pm_ops allowing us to enable/disable the platform to
  generate wake-up events for given device.  Implemet this callback
  for the ACPI platform.
o Define ACPI wake-up handlers for PCI devices and PCI buses and make
  the PCI-ACPI binding code register wake-up notifiers for devices
  associated with wake-up GPEs.
o Add function pci_dev_run_wake() which can be used by PCI drivers to
  check if given device is capable of generating wake-up events at
  run time.

Developed in cooperation with Matthew Garrett <mjg@redhat.com>.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/internal.h            |    2 
 drivers/acpi/pci_bind.c            |   14 +
 drivers/acpi/pci_root.c            |    8 
 drivers/pci/hotplug/acpiphp_glue.c |   23 --
 drivers/pci/pci-acpi.c             |  351 +++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c                  |   67 +++++++
 drivers/pci/pci.h                  |    7 
 include/acpi/acpi_bus.h            |    3 
 include/linux/pci-acpi.h           |   10 +
 include/linux/pci.h                |    1 
 10 files changed, 469 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -35,6 +35,10 @@ int pci_probe_reset_function(struct pci_
  *
  * @sleep_wake: enables/disables the system wake up capability of given device
  *
+ * @run_wake: enables/disables the platform to generate run-time wake-up events
+ *		for given device (the device's wake-up capability has to be
+ *		enabled by @sleep_wake for this feature to work)
+ *
  * If given platform is generally capable of power managing PCI devices, all of
  * these callbacks are mandatory.
  */
@@ -44,12 +48,15 @@ struct pci_platform_pm_ops {
 	pci_power_t (*choose_state)(struct pci_dev *dev);
 	bool (*can_wakeup)(struct pci_dev *dev);
 	int (*sleep_wake)(struct pci_dev *dev, bool enable);
+	int (*run_wake)(struct pci_dev *dev, bool enable);
 };
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
 extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
 extern bool pci_check_pme_status(struct pci_dev *dev);
+extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
+extern void pci_pme_wakeup_bus(struct pci_bus *bus);
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -16,8 +16,284 @@
 #include <acpi/acpi_bus.h>
 
 #include <linux/pci-acpi.h>
+#include <linux/pm_runtime.h>
 #include "pci.h"
 
+static DEFINE_MUTEX(pci_acpi_notify_mtx);
+static LIST_HEAD(pci_acpi_notify_list);
+
+struct pci_acpi_notify_object
+{
+	struct list_head entry;
+	acpi_handle handle;
+	acpi_notify_handler hp_cb;
+	void *hp_data;
+	struct pci_bus *pci_bus;
+	struct pci_dev *pci_dev;
+};
+
+/**
+ * pci_acpi_event_fn - Universal system notification handler.
+ * @handle: ACPI handle of a device the notification is for.
+ * @event: Type of the signaled event.
+ * @context: Pointer to the notify object associated with the handle.
+ *
+ * Use @handle to obtain the address of the ACPI device object the event is
+ * signaled for.  If this is a wake-up event, execute the appropriate PME
+ * handler for the bus or device represented by it (or both, if @dev is a
+ * bridge).  If this is not a wake-up event, execute the hotplug notify handler
+ * for @handle.
+ */
+static void pci_acpi_event_fn(acpi_handle handle, u32 event, void *context)
+{
+	struct pci_acpi_notify_object *notify_obj = context;
+
+	if (!notify_obj)
+		return;
+
+	mutex_lock(&pci_acpi_notify_mtx);
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE) {
+		if (notify_obj->pci_bus) {
+			pci_pme_wakeup_bus(notify_obj->pci_bus);
+		}
+		if (notify_obj->pci_dev) {
+			pci_check_pme_status(notify_obj->pci_dev);
+			pm_request_resume(&notify_obj->pci_dev->dev);
+		}
+	} else if (notify_obj->hp_cb) {
+		notify_obj->hp_cb(handle, event, notify_obj->hp_data);
+	}
+
+	mutex_unlock(&pci_acpi_notify_mtx);
+}
+
+/**
+ * add_notify_obj - Create a new notify object for given ACPI handle.
+ * @handle: ACPI handle to create the notify object for.
+ */
+static struct pci_acpi_notify_object *add_notify_obj(acpi_handle handle)
+{
+	struct pci_acpi_notify_object *notify_obj;
+
+	notify_obj = kzalloc(sizeof(*notify_obj), GFP_KERNEL);
+	if (!notify_obj)
+		return NULL;
+
+	notify_obj->handle = handle;
+	return notify_obj;
+}
+
+/**
+ * pci_acpi_add_hp_notifier - Register a hotplug notifier for given device.
+ * @handle: ACPI handle to register the notifier for.
+ * @handler: Callback to execute for hotplug events related to @handle.
+ * @context: Pointer to the context data to pass to @handler.
+ *
+ * Find the notify object associated with @handle or create one if not found.
+ * Return error code if the notify object already contains a valid pointer to
+ * a hotplug handler or add @handler and @context to the notify object.
+ */
+acpi_status pci_acpi_add_hp_notifier(acpi_handle handle,
+				     acpi_notify_handler handler, void *context)
+{
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_status status = AE_OK;
+
+	if (!handle)
+		return AE_BAD_PARAMETER;
+
+	mutex_lock(&pci_acpi_notify_mtx);
+
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle) {
+			if (notify_obj->hp_cb) {
+				status = AE_ALREADY_EXISTS;
+				goto out;
+			} else {
+				goto add;
+			}
+		}
+
+	notify_obj = add_notify_obj(handle);
+	if (!notify_obj) {
+		status = AE_NO_MEMORY;
+		goto out;
+	}
+
+	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						pci_acpi_event_fn, notify_obj);
+	if (ACPI_FAILURE(status)) {
+		kfree(notify_obj);
+		goto out;
+	}
+
+	list_add_tail(&notify_obj->entry, &pci_acpi_notify_list);
+
+ add:
+	notify_obj->hp_cb = handler;
+	notify_obj->hp_data = context;
+
+ out:
+	mutex_unlock(&pci_acpi_notify_mtx);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(pci_acpi_add_hp_notifier);
+
+/**
+ * pci_acpi_remove_hp_notifier - Unregister a hotplug notifier for given device.
+ * @handle: ACPI handle of the device to unregister the notifier for.
+ * @handler: Callback executed for hotplug events related to @handle.
+ *
+ * Find the notify object corresponding to @handle and remove the pointers to
+ * the hotplug handler and data from it.  Return error code if the notify object
+ * is not found.
+ */
+acpi_status pci_acpi_remove_hp_notifier(acpi_handle handle,
+					acpi_notify_handler handler)
+{
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_status status = AE_NOT_FOUND;
+
+	if (!handle)
+		return AE_BAD_PARAMETER;
+
+	mutex_lock(&pci_acpi_notify_mtx);
+
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle)
+			goto remove;
+
+	goto out;
+
+ remove:
+	notify_obj->hp_data = NULL;
+	notify_obj->hp_cb = NULL;
+
+	if (notify_obj->pci_bus || notify_obj->pci_dev) {
+		status = AE_OK;
+		goto out;
+	}
+
+	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						pci_acpi_event_fn);
+	list_del(&notify_obj->entry);
+	kfree(notify_obj);
+
+ out:
+	mutex_unlock(&pci_acpi_notify_mtx);
+	return status;
+}
+EXPORT_SYMBOL_GPL(pci_acpi_remove_hp_notifier);
+
+/**
+ * pci_acpi_add_pm_notifier - Register PM notifier for given device.
+ * @dev: ACPI device to add the notifier for.
+ * @pci_dev: PCI device to check for the PME status if an event is signaled.
+ * @pci_bus: PCI bus to walk (checking PME status) if an event is signaled.
+ *
+ * Use @dev to find the notify object corresponding to its handle or create a
+ * new one if not found.  Return error code if the notify object already
+ * contains a valid pointer to a PCI device or bus object.  Otherwise, add
+ * @pci_dev and @pci_bus to the notify object, as the device whose PME status
+ * should be checked whenever a PM event is signaled for @dev and the bus to
+ * walk checking the PME status of all devices on it whenever a PM event is
+ * signaled for @dev, respectively.
+ *
+ * NOTE: @dev need not be a run-wake or wake-up device to be a valid source of
+ * PM wake-up events.  For example, wake-up events may be generated for bridges
+ * if one of the devices below the bridge is signaling PME, even if the bridge
+ * itself doesn't have a wake-up GPE associated with it.
+ */
+acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
+				     struct pci_dev *pci_dev,
+				     struct pci_bus *pci_bus)
+{
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_handle handle = dev->handle;
+	acpi_status status = AE_OK;
+
+	if (!handle)
+		return AE_BAD_PARAMETER;
+
+	mutex_lock(&pci_acpi_notify_mtx);
+
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
+		status = AE_NO_MEMORY;
+		goto out;
+	}
+
+	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+						pci_acpi_event_fn, notify_obj);
+	if (ACPI_FAILURE(status)) {
+		kfree(notify_obj);
+		goto out;
+	}
+
+	list_add_tail(&notify_obj->entry, &pci_acpi_notify_list);
+
+ add:
+	notify_obj->pci_dev = pci_dev;
+	notify_obj->pci_bus = pci_bus;
+
+ out:
+	mutex_unlock(&pci_acpi_notify_mtx);
+	return status;
+}
+
+/**
+ * pci_acpi_remove_pm_notifier - Unregister PM notifier for given device.
+ * @dev: ACPI device to remove the notifier from.
+ *
+ * Find the notify object for @dev and clear its @pci_dev and @pci_bus
+ * fields.  If the notify data object is not necessary any more after that,
+ * remove it altogether.
+ */
+acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
+{
+	struct pci_acpi_notify_object *notify_obj;
+	acpi_handle handle = dev->handle;
+	acpi_status status = AE_NOT_FOUND;
+
+	mutex_lock(&pci_acpi_notify_mtx);
+
+	list_for_each_entry(notify_obj, &pci_acpi_notify_list, entry)
+		if (notify_obj->handle == handle)
+			goto remove;
+
+	goto out;
+
+ remove:
+	notify_obj->pci_dev = NULL;
+	notify_obj->pci_bus = NULL;
+
+	if (notify_obj->hp_cb) {
+		status = AE_OK;
+		goto out;
+	}
+
+	status = acpi_remove_notify_handler(dev->handle, ACPI_SYSTEM_NOTIFY,
+						pci_acpi_event_fn);
+	list_del(&notify_obj->entry);
+	kfree(notify_obj);
+
+ out:
+	mutex_unlock(&pci_acpi_notify_mtx);
+	return status;
+}
+
 /*
  * _SxD returns the D-state with the highest power
  * (lowest D-state number) supported in the S-state "x".
@@ -131,12 +407,87 @@ static int acpi_pci_sleep_wake(struct pc
 	return 0;
 }
 
+/**
+ * acpi_dev_run_wake - Enable/disable wake-up for given device.
+ * @phys_dev: Device to enable/disable the platform to wake-up the system for.
+ * @enable: Whether enable or disable the wake-up functionality.
+ *
+ * Find the ACPI device object corresponding to @pci_dev and try to
+ * enable/disable the GPE associated with it.
+ */
+static int acpi_dev_run_wake(struct device *phys_dev, bool enable)
+{
+	struct acpi_device *dev;
+	acpi_handle handle;
+	int error = -ENODEV;
+
+	if (!device_run_wake(phys_dev))
+		return -EINVAL;
+
+	handle = DEVICE_ACPI_HANDLE(phys_dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
+		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (enable) {
+		if (!dev->wakeup.run_wake_count++) {
+			acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
+			acpi_enable_gpe(dev->wakeup.gpe_device,
+					dev->wakeup.gpe_number,
+					ACPI_GPE_TYPE_RUNTIME);
+		}
+	} else if (dev->wakeup.run_wake_count > 0) {
+		if (!--dev->wakeup.run_wake_count) {
+			acpi_disable_gpe(dev->wakeup.gpe_device,
+					dev->wakeup.gpe_number,
+					ACPI_GPE_TYPE_RUNTIME);
+			acpi_disable_wakeup_device_power(dev);
+		}
+	} else {
+		error = -EALREADY;
+	}
+
+	return error;
+}
+
+static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
+{
+	while (bus->parent) {
+		struct pci_dev *bridge = bus->self;
+
+		if (bridge->pme_interrupt)
+			return;
+		if (!acpi_dev_run_wake(&bridge->dev, enable))
+			return;
+		bus = bus->parent;
+	}
+
+	/* We have reached the root bus. */
+	if (bus->bridge)
+		acpi_dev_run_wake(bus->bridge, enable);
+}
+
+static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
+{
+	if (dev->pme_interrupt)
+		return 0;
+
+	if (!acpi_dev_run_wake(&dev->dev, enable))
+		return 0;
+
+	acpi_pci_propagate_run_wake(dev->bus, enable);
+	return 0;
+}
+
 static struct pci_platform_pm_ops acpi_pci_platform_pm = {
 	.is_manageable = acpi_pci_power_manageable,
 	.set_state = acpi_pci_set_power_state,
 	.choose_state = acpi_pci_choose_state,
 	.can_wakeup = acpi_pci_can_wakeup,
 	.sleep_wake = acpi_pci_sleep_wake,
+	.run_wake = acpi_pci_run_wake,
 };
 
 /* ACPI bus type */
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -20,6 +20,7 @@
 #include <linux/pm_wakeup.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 #include <asm/setup.h>
 #include "pci.h"
 
@@ -462,6 +463,12 @@ static inline int platform_pci_sleep_wak
 			pci_platform_pm->sleep_wake(dev, enable) : -ENODEV;
 }
 
+static inline int platform_pci_run_wake(struct pci_dev *dev, bool enable)
+{
+	return pci_platform_pm ?
+			pci_platform_pm->run_wake(dev, enable) : -ENODEV;
+}
+
 /**
  * pci_raw_set_power_state - Use PCI PM registers to set the power state of
  *                           given PCI device
@@ -1230,6 +1237,31 @@ bool pci_check_pme_status(struct pci_dev
 }
 
 /**
+ * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
+ * @dev: Device to handle.
+ * @ign: Ignored.
+ *
+ * Check if @dev has generated PME and queue a resume request for it in that
+ * case.
+ */
+static int pci_pme_wakeup(struct pci_dev *dev, void *ign)
+{
+	if (pci_check_pme_status(dev))
+		pm_request_resume(&dev->dev);
+	return 0;
+}
+
+/**
+ * pci_pme_wakeup_bus - Walk given bus and wake up devices on it, if necessary.
+ * @bus: Top bus of the subtree to walk.
+ */
+void pci_pme_wakeup_bus(struct pci_bus *bus)
+{
+	if (bus)
+		pci_walk_bus(bus, pci_pme_wakeup, NULL);
+}
+
+/**
  * pci_pme_capable - check the capability of PCI device to generate PME#
  * @dev: PCI device to handle.
  * @state: PCI state from which device will issue PME#.
@@ -1434,6 +1466,41 @@ int pci_back_from_sleep(struct pci_dev *
 }
 
 /**
+ * pci_dev_run_wake - Check if device can generate run-time wake-up events.
+ * @dev: Device to check.
+ *
+ * Return true if the device itself is cabable of generating wake-up events
+ * (through the platform or using the native PCIe PME) or if the device supports
+ * PME and one of its upstream bridges can generate wake-up events.
+ */
+bool pci_dev_run_wake(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+
+	if (device_run_wake(&dev->dev))
+		return true;
+
+	if (!dev->pme_support)
+		return false;
+
+	while (bus->parent) {
+		struct pci_dev *bridge = bus->self;
+
+		if (device_run_wake(&bridge->dev))
+			return true;
+
+		bus = bus->parent;
+	}
+
+	/* We have reached the root bus. */
+	if (bus->bridge)
+		return device_run_wake(bus->bridge);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(pci_dev_run_wake);
+
+/**
  * pci_pm_init - Initialize PM functions of given PCI device
  * @dev: PCI device to handle.
  */
Index: linux-2.6/include/linux/pci-acpi.h
===================================================================
--- linux-2.6.orig/include/linux/pci-acpi.h
+++ linux-2.6/include/linux/pci-acpi.h
@@ -11,6 +11,16 @@
 #include <linux/acpi.h>
 
 #ifdef CONFIG_ACPI
+extern acpi_status pci_acpi_add_hp_notifier(acpi_handle handle,
+					     acpi_notify_handler handler,
+					     void *context);
+extern acpi_status pci_acpi_remove_hp_notifier(acpi_handle handle,
+					       acpi_notify_handler handler);
+extern acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
+					     struct pci_dev *pci_dev,
+					     struct pci_bus *pci_bus);
+extern acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev);
+
 static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
 {
 	struct pci_bus *pbus = pdev->bus;
Index: linux-2.6/drivers/acpi/pci_bind.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_bind.c
+++ linux-2.6/drivers/acpi/pci_bind.c
@@ -26,7 +26,9 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-acpi.h>
 #include <linux/acpi.h>
+#include <linux/pm_runtime.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -38,7 +40,13 @@ static int acpi_pci_unbind(struct acpi_d
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
-	if (!dev || !dev->subordinate)
+	if (!dev)
+		goto out;
+
+	device_set_run_wake(&dev->dev, false);
+	pci_acpi_remove_pm_notifier(device);
+
+	if (!dev->subordinate)
 		goto out;
 
 	acpi_pci_irq_del_prt(dev->subordinate);
@@ -62,6 +70,10 @@ static int acpi_pci_bind(struct acpi_dev
 	if (!dev)
 		return 0;
 
+	pci_acpi_add_pm_notifier(device, dev, dev->subordinate);
+	if (device->wakeup.flags.run_wake)
+		device_set_run_wake(&dev->dev, true);
+
 	/*
 	 * Install the 'bind' function to facilitate callbacks for
 	 * children of the P2P bridge.
Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
@@ -236,8 +236,7 @@ register_slot(acpi_handle handle, u32 lv
 
 	/* install notify handler */
 	if (!(newfunc->flags & FUNC_HAS_DCK)) {
-		status = acpi_install_notify_handler(handle,
-					     ACPI_SYSTEM_NOTIFY,
+		status = pci_acpi_add_hp_notifier(handle,
 					     handle_hotplug_event_func,
 					     newfunc);
 
@@ -288,14 +287,12 @@ static void init_bridge_misc(struct acpi
 	/* install notify handler */
 	if (bridge->type != BRIDGE_TYPE_HOST) {
 		if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
-			status = acpi_remove_notify_handler(bridge->func->handle,
-						ACPI_SYSTEM_NOTIFY,
+			status = pci_acpi_remove_hp_notifier(bridge->func->handle,
 						handle_hotplug_event_func);
 			if (ACPI_FAILURE(status))
 				err("failed to remove notify handler\n");
 		}
-		status = acpi_install_notify_handler(bridge->handle,
-					     ACPI_SYSTEM_NOTIFY,
+		status = pci_acpi_add_hp_notifier(bridge->handle,
 					     handle_hotplug_event_bridge,
 					     bridge);
 
@@ -505,15 +502,14 @@ static void cleanup_bridge(struct acpiph
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
-	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+	status = pci_acpi_remove_hp_notifier(handle,
 					    handle_hotplug_event_bridge);
 	if (ACPI_FAILURE(status))
 		err("failed to remove notify handler\n");
 
 	if ((bridge->type != BRIDGE_TYPE_HOST) &&
 	    ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
-		status = acpi_install_notify_handler(bridge->func->handle,
-						ACPI_SYSTEM_NOTIFY,
+		status = pci_acpi_add_hp_notifier(bridge->func->handle,
 						handle_hotplug_event_func,
 						bridge->func);
 		if (ACPI_FAILURE(status))
@@ -529,8 +525,7 @@ static void cleanup_bridge(struct acpiph
 				unregister_dock_notifier(&func->nb);
 			}
 			if (!(func->flags & FUNC_HAS_DCK)) {
-				status = acpi_remove_notify_handler(func->handle,
-						ACPI_SYSTEM_NOTIFY,
+				status = pci_acpi_remove_hp_notifier(func->handle,
 						handle_hotplug_event_func);
 				if (ACPI_FAILURE(status))
 					err("failed to remove notify handler\n");
@@ -592,7 +587,7 @@ static void remove_bridge(acpi_handle ha
 	if (bridge)
 		cleanup_bridge(bridge);
 	else
-		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+		pci_acpi_remove_hp_notifier(handle,
 					   handle_hotplug_event_bridge);
 }
 
@@ -1278,8 +1273,8 @@ find_root_bridges(acpi_handle handle, u3
 	int *count = (int *)context;
 
 	if (acpi_is_root_bridge(handle)) {
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				handle_hotplug_event_bridge, NULL);
+		pci_acpi_add_hp_notifier(handle,
+					handle_hotplug_event_bridge, NULL);
 			(*count)++;
 	}
 	return AE_OK ;
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -756,6 +756,7 @@ int pci_wake_from_d3(struct pci_dev *dev
 pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
+bool pci_dev_run_wake(struct pci_dev *dev);
 
 /* For use by arch with custom probe code */
 void set_pcie_port_type(struct pci_dev *pdev);
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -388,6 +388,9 @@ acpi_handle acpi_get_pci_rootbridge_hand
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
+int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
+int acpi_disable_wakeup_device_power(struct acpi_device *dev);
+
 #ifdef CONFIG_PM_SLEEP
 int acpi_pm_device_sleep_state(struct device *, int *);
 int acpi_pm_device_sleep_wake(struct device *, bool);
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -30,6 +30,7 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/pm.h>
+#include <linux/pm_runtime.h>
 #include <linux/pci.h>
 #include <linux/pci-acpi.h>
 #include <linux/acpi.h>
@@ -528,6 +529,10 @@ static int __devinit acpi_pci_root_add(s
 	if (flags != base_flags)
 		acpi_pci_osc_support(root, flags);
 
+	pci_acpi_add_pm_notifier(device, NULL, root->bus);
+	if (device->wakeup.flags.run_wake)
+		device_set_run_wake(root->bus->bridge, true);
+
 	return 0;
 
 end:
@@ -549,6 +554,9 @@ static int acpi_pci_root_remove(struct a
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
+	device_set_run_wake(root->bus->bridge, false);
+	pci_acpi_remove_pm_notifier(device);
+
 	kfree(root);
 	return 0;
 }
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -36,8 +36,6 @@ static inline int acpi_debug_init(void) 
 int acpi_power_init(void);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
-int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state);
-int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 int acpi_power_get_inferred_state(struct acpi_device *device);
 int acpi_power_transition(struct acpi_device *device, int state);
 extern int acpi_power_nocheck;
