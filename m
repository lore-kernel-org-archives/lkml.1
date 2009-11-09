Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZKIWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZKIWmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZKIWmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:42:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49326 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZKIWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:42:37 -0500
From: Matthew Garrett <mjg@redhat.com>
To: rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, shaohua.li@intel.com, bjorn.helgaas@hp.com,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] pci: Updates to Rafael's runtime PCI PM patch set
Date: Mon,  9 Nov 2009 17:42:09 -0500
Message-Id: <1257806529-6535-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <200910090051.50932.rjw@sisk.pl>
References: <200910090051.50932.rjw@sisk.pl>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a few quirks with Rafael's PCI runtime PM code - this modifies
them a little. The body of it is just porting it to my GPE rewrite, but
it also moves the PCI binding earlier (otherwise acpi_pci_bind bails, since
it's primarily intended for bridges), and also ensures that the pme bit
gets set properly on hardware that requires it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/pci_bind.c  |   12 ++++++------
 drivers/acpi/wakeup.c    |   36 ------------------------------------
 drivers/pci/pci-acpi.c   |   43 ++++++++++++++++---------------------------
 drivers/pci/pci-driver.c |    6 ++++++
 include/acpi/acpi_bus.h  |    6 ------
 5 files changed, 28 insertions(+), 75 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index d7baeca..d0086aa 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -73,6 +73,12 @@ static int acpi_pci_bind(struct acpi_device *device)
 	if (!dev)
 		return 0;
 
+	if (device->wakeup.flags.valid) {
+		pci_acpi_add_device_pm_notifier(device, dev);
+		if (dev->subordinate)
+			pci_acpi_add_bus_pm_notifier(device, dev->subordinate);
+	}
+
 	/*
 	 * Install the 'bind' function to facilitate callbacks for
 	 * children of the P2P bridge.
@@ -105,12 +111,6 @@ static int acpi_pci_bind(struct acpi_device *device)
 
 	acpi_pci_irq_add_prt(device->handle, bus);
 
-	if (device->wakeup.flags.valid) {
-		pci_acpi_add_device_pm_notifier(device, dev);
-		if (dev->subordinate)
-			pci_acpi_add_bus_pm_notifier(device, dev->subordinate);
-	}
-
 out:
 	pci_dev_put(dev);
 	return 0;
diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index abdf349..be373cc 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -98,42 +98,6 @@ void acpi_disable_wakeup_device(u8 sleep_state)
 
 #ifdef CONFIG_PM_WAKEUP
 /**
- * acpi_device_run_wake - Enable/disable ACPI BIOS to generate wake-up events.
- * @dev: Device to generate the wake-up events for.
- * @enable: Desired action.
- *
- * If @enable is set, set up the GPE associated with @phys_dev to generate
- * wake-up events at run time.  If @enable is unset, disable the GPE associated
- * with @phys_dev (unless it is marked as a run-wake device).
- */
-int acpi_device_run_wake(struct acpi_device *dev, bool enable)
-{
-	if (!dev || !dev->wakeup.flags.valid)
-		return -EINVAL;
-
-	if (enable) {
-		if (!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
-			return -EINVAL;
-
-		acpi_set_gpe_type(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number,
-					ACPI_GPE_TYPE_WAKE_RUN);
-		acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
-	} else if (!dev->wakeup.flags.run_wake) {
-		acpi_set_gpe_type(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number,
-					ACPI_GPE_TYPE_WAKE);
-		acpi_disable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
-		acpi_clear_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number, ACPI_NOT_ISR);
-	}
-
-	return 0;
-}
-
-/**
  * acpi_wakeup_gpes_shared - Check if given ACPI devices share a wake-up GPE.
  * @deva: First ACPI device to check.
  * @devb: Second ACPI device to check.
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 51605c1..dae90cc 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -35,12 +35,6 @@
  * notify handler for the root bridge, because the other devices will be checked
  * in the process of handling the root bridge wake-up.
  *
- * Furthermore, if many devices share one wake-up GPE, we only need to install
- * a notify handler for one of them as long as we know which devices to check
- * in the process of handling the notification.  The purpose of the data
- * structures and helper functions below is to arrange things in accordance with
- * these observations.
- *
  * pci_acpi_runtime_notifiers is a list of struct pci_acpi_notifier_block
  * objects that each represent ACPI devices that have ACPI system notify
  * handlers installed.  For each of them, there is a ACPI-based hotplug notifier
@@ -63,7 +57,6 @@ struct pci_acpi_notifier_block
 	void *hp_data;
 	struct list_head pm_buses;
 	struct list_head pm_devices;
-	int pm_enable_count;
 };
 
 struct pci_bus_notifier_entry
@@ -102,7 +95,7 @@ static void pci_acpi_event_fn(acpi_handle handle, u32 event, void *data)
 
 	mutex_lock(&pci_acpi_notifier_mtx);
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && nb->pm_enable_count) {
+	if (event == ACPI_NOTIFY_DEVICE_WAKE) {
 		if (!list_empty(&nb->pm_buses)) {
 			struct pci_bus_notifier_entry *bne;
 
@@ -316,10 +309,6 @@ acpi_status pci_acpi_add_device_pm_notifier(struct acpi_device *dev,
 			if (bus_match(bne->bus, bus))
 				goto out;
 
-		list_for_each_entry(dne, &nb->pm_devices, entry)
-			if (dne->dev == pci_dev)
-				goto out;
-
 		if (!new_dev_entry(pci_dev, &nb->pm_devices))
 			status = AE_NO_MEMORY;
 		goto out;
@@ -385,10 +374,9 @@ acpi_status pci_acpi_remove_device_pm_notifier(struct acpi_device *dev,
 	return AE_NOT_FOUND;
 
  found:
-	if (dne->enabled) {
-		if (!--nb->pm_enable_count)
-			acpi_device_run_wake(nb->dev, false);
-	}
+	if (dne->enabled)
+		acpi_unref_runtime_gpe(nb->dev->wakeup.gpe_device,
+				       nb->dev->wakeup.gpe_number);
 	list_del(&dne->entry);
 	kfree(dne);
 
@@ -523,9 +511,10 @@ acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev,
 
  found:
 	if (bne->enable_count) {
-		nb->pm_enable_count -= bne->enable_count;
-		if (!nb->pm_enable_count)
-			acpi_device_run_wake(nb->dev, false);
+		int i;
+		for (i=bne->enable_count; i; i--)
+			acpi_unref_runtime_gpe(nb->dev->wakeup.gpe_device,
+					       nb->dev->wakeup.gpe_number);
 	}
 	list_del(&bne->entry);
 	kfree(bne);
@@ -556,12 +545,12 @@ static int dev_run_wake(struct pci_acpi_notifier_block *nb,
 
 	if (enable) {
 		dne->enabled = true;
-		if (!nb->pm_enable_count++)
-			acpi_device_run_wake(nb->dev, true);
+		acpi_ref_runtime_gpe(nb->dev->wakeup.gpe_device,
+				     nb->dev->wakeup.gpe_number);
 	} else if (dne->enabled) {
 		dne->enabled = false;
-		if (!--nb->pm_enable_count)
-			acpi_device_run_wake(nb->dev, false);
+		acpi_unref_runtime_gpe(nb->dev->wakeup.gpe_device,
+				       nb->dev->wakeup.gpe_number);
 	} else {
 		error = -EALREADY;
 	}
@@ -582,12 +571,12 @@ static int bus_run_wake(struct pci_acpi_notifier_block *nb,
 
 	if (enable) {
 		bne->enable_count++;
-		if (!nb->pm_enable_count++)
-			acpi_device_run_wake(nb->dev, true);
+		acpi_ref_runtime_gpe(nb->dev->wakeup.gpe_device,
+				     nb->dev->wakeup.gpe_number);
 	} else if (bne->enable_count) {
 		bne->enable_count--;
-		if (!--nb->pm_enable_count)
-			acpi_device_run_wake(nb->dev, false);
+		acpi_unref_runtime_gpe(nb->dev->wakeup.gpe_device,
+				       nb->dev->wakeup.gpe_number);
 	} else {
 		error = -EALREADY;
 	}
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index eb4f26a..d644db6 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -967,6 +967,9 @@ static int pci_pm_runtime_suspend(struct device *dev)
 			pci_prepare_to_sleep(pci_dev);
 	}
 
+	if (pci_pme_capable(pci_dev, pci_target_state(pci_dev)))
+		pci_pme_active(pci_dev, true);
+
 	pci_platform_run_wake(pci_dev, true);
 
 	return 0;
@@ -980,6 +983,9 @@ static int pci_pm_runtime_resume(struct device *dev)
 	if (!pm || !pm->runtime_resume)
 		return -ENOSYS;
 
+	if (pci_pme_capable(pci_dev, pci_target_state(pci_dev)))
+		pci_pme_active(pci_dev, false);
+
 	pci_platform_run_wake(pci_dev, false);
 	pci_pm_default_resume_early(pci_dev);
 	pci_pm_default_resume(pci_dev);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 935036e..9541588 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -389,7 +389,6 @@ struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #ifdef CONFIG_PM_WAKEUP
 int acpi_pm_device_sleep_state(struct device *, int *);
 int acpi_pm_device_sleep_wake(struct device *, bool);
-int acpi_device_run_wake(struct acpi_device *, bool);
 bool acpi_wakeup_gpe_shared(struct acpi_device *, struct acpi_device *);
 #else /* !CONFIG_PM_WAKEUP */
 static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
@@ -404,11 +403,6 @@ static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 	return -ENODEV;
 }
 
-static inline int acpi_device_run_wake(struct device *dev, bool enable)
-{
-	return -ENODEV;
-}
-
 static inline bool acpi_wakeup_gpe_shared(struct acpi_device *a,
 					   struct acpi_device *b)
 {
-- 
1.6.5.2

