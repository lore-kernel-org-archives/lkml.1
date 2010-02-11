Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0BKUbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:31:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab0BKUbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:31:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Thu, 11 Feb 2010 21:32:02 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <201002111427.17275.rjw@sisk.pl> <20100211182910.GA9766@us.ibm.com>
In-Reply-To: <20100211182910.GA9766@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002112132.02255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Gary Hade wrote:
> On Thu, Feb 11, 2010 at 02:27:17PM +0100, Rafael J. Wysocki wrote:
> > On Thursday 11 February 2010, Gary Hade wrote:
> > > On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > > ...
> > > > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > > > I was already doing what you asked except in the opposite order.
> > > > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > > > 
> > > > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > > > 
> > > > > > Thanks!
> > > > > > 
> > > > > > > 
> > > > > > > What's your kernel command line, BTW?
> > > > > > 
> > > > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > > > 
> > > > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > > > specific command line switch to trigger, which you don't use.
> > > > > 
> > > > > I'll let you know if I have anything to test.
> > > > 
> > > > OK, please try the patch below on top of [1-6/9].
> > > 
> > > Sorry, it didn't help.  The hot-add and hot-remove behaviors
> > > still look the same.
> > 
> > Thanks for testing.
> > 
> > Well, this time I found another real bug, which is that we should add
> > gpe_block->block_base_number to the GPE index within the block in order to
> > compute the GPE number.  If there are GPE devices other than the FADT ones in
> > your system, that may explain the symptoms.
> > 
> > Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
> > look for "Failed to ebable GPE" messages in dmesg and let me know if there are
> > any.
> 
> That one worked!  It corrected both the blinking amber LED
> after hot-remove and acpiphp's failure to see the hot-add event.

Great!

> Now when you have patch(es) ready for Jesse's linux-next branch

Well, not quite.  I had to rework them in the meantime. ;-)

> I can get back to my original mission of checking out Bjorn's
> _CRS enablement changes.

May I still ask you to test something?

In case I can, please try the appended patch on top of [1-3/6].  It is a
replacement for [4-6/9] with the last fix included.

Rafael

---
Subject: ACPI: Use GPE reference counting to support shared GPEs
From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI GPEs may map to multiple devices.  The current GPE interface
only provides a mechanism for enabling and disabling GPEs, making
it difficult to change the state of GPEs at runtime without extensive
cooperation between devices.

Add an API to allow devices to indicate whether or not they want
their device's GPE to be enabled for both runtime and wakeup events.

Remove the old GPE type handling entirely, which gets rid of various
quirks, like the implicit disabling with GPE type setting. This
requires a small amount of rework in order to ensure that non-wake
GPEs are enabled by default to preserve existing behaviour.

Based on patches from Matthew Garrett <mjg@redhat.com>.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/acevents.h |    6 -
 drivers/acpi/acpica/aclocal.h  |    2 
 drivers/acpi/acpica/evgpe.c    |  153 ++++-------------------------------------
 drivers/acpi/acpica/evgpeblk.c |   87 ++++++++---------------
 drivers/acpi/acpica/evxface.c  |   14 ---
 drivers/acpi/acpica/evxfevnt.c |   90 +++++++++++++++++-------
 drivers/acpi/button.c          |   13 ++-
 drivers/acpi/ec.c              |   14 ++-
 drivers/acpi/sleep.c           |   15 +++-
 drivers/acpi/system.c          |    4 -
 drivers/acpi/wakeup.c          |   81 +++++++--------------
 include/acpi/acpixf.h          |    6 -
 include/acpi/actypes.h         |   28 ++-----
 13 files changed, 188 insertions(+), 325 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/aclocal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/aclocal.h
+++ linux-2.6/drivers/acpi/acpica/aclocal.h
@@ -426,6 +426,8 @@ struct acpi_gpe_event_info {
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
+	u8 runtime_count;
+	u8 wakeup_count;
 };
 
 /* Information about a GPE register pair, one per each status/enable pair in an array */
Index: linux-2.6/drivers/acpi/acpica/evxfevnt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxfevnt.c
+++ linux-2.6/drivers/acpi/acpica/evxfevnt.c
@@ -201,23 +201,27 @@ ACPI_EXPORT_SYMBOL(acpi_enable_event)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_set_gpe_type
+ * FUNCTION:    acpi_set_gpe
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
  *              gpe_number      - GPE level within the GPE block
- *              Type            - New GPE type
+ *              action          - Enable or disable
+ *                                Called from ISR or not
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Set the type of an individual GPE
+ * DESCRIPTION: Enable or disable an ACPI event (general purpose)
  *
  ******************************************************************************/
-acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type)
+acpi_status acpi_set_gpe(acpi_handle gpe_device, u32 gpe_number, u8 action)
 {
 	acpi_status status = AE_OK;
+	acpi_cpu_flags flags;
 	struct acpi_gpe_event_info *gpe_event_info;
 
-	ACPI_FUNCTION_TRACE(acpi_set_gpe_type);
+	ACPI_FUNCTION_TRACE(acpi_set_gpe);
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -227,19 +231,29 @@ acpi_status acpi_set_gpe_type(acpi_handl
 		goto unlock_and_exit;
 	}
 
-	if ((gpe_event_info->flags & ACPI_GPE_TYPE_MASK) == type) {
-		return_ACPI_STATUS(AE_OK);
-	}
+	/* Perform the action */
 
-	/* Set the new type (will disable GPE if currently enabled) */
+	switch (action) {
+	case ACPI_GPE_ENABLE:
+		status = acpi_ev_enable_gpe(gpe_event_info, TRUE);
+		break;
+
+	case ACPI_GPE_DISABLE:
+		status = acpi_ev_disable_gpe(gpe_event_info);
+		break;
 
-	status = acpi_ev_set_gpe_type(gpe_event_info, type);
+	default:
+		ACPI_ERROR((AE_INFO, "Invalid action\n"));
+		status = AE_BAD_PARAMETER;
+		break;
+	}
 
       unlock_and_exit:
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_set_gpe_type)
+ACPI_EXPORT_SYMBOL(acpi_set_gpe)
 
 /*******************************************************************************
  *
@@ -247,15 +261,14 @@ ACPI_EXPORT_SYMBOL(acpi_set_gpe_type)
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
  *              gpe_number      - GPE level within the GPE block
- *              Flags           - Just enable, or also wake enable?
- *                                Called from ISR or not
+ *              type            - Purpose the GPE will be used for
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Enable an ACPI event (general purpose)
+ * DESCRIPTION: Take a reference to a GPE and enable it if necessary
  *
  ******************************************************************************/
-acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
+acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number, u8 type)
 {
 	acpi_status status = AE_OK;
 	acpi_cpu_flags flags;
@@ -273,15 +286,32 @@ acpi_status acpi_enable_gpe(acpi_handle 
 		goto unlock_and_exit;
 	}
 
-	/* Perform the enable */
+	if (type & ACPI_GPE_TYPE_RUNTIME) {
+		if (++gpe_event_info->runtime_count == 1)
+			status = acpi_ev_enable_gpe(gpe_event_info, TRUE);
 
-	status = acpi_ev_enable_gpe(gpe_event_info, TRUE);
+		if (ACPI_FAILURE(status))
+			gpe_event_info->runtime_count--;
+	}
 
-      unlock_and_exit:
+	if (type & ACPI_GPE_TYPE_WAKE) {
+		if (!(gpe_event_info->flags & ACPI_GPE_CAN_WAKE)) {
+			status = AE_BAD_PARAMETER;
+			goto unlock_and_exit;
+		}
+
+		/*
+		 * Wake-up GPEs are only enabled right prior to putting the
+		 * system into a sleep state.
+		 */
+		if (++gpe_event_info->wakeup_count == 1)
+			acpi_ev_update_gpe_enable_masks(gpe_event_info);
+	}
+
+unlock_and_exit:
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
-
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
 
 /*******************************************************************************
@@ -290,15 +320,14 @@ ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
  *              gpe_number      - GPE level within the GPE block
- *              Flags           - Just disable, or also wake disable?
- *                                Called from ISR or not
+ *              type            - Purpose the GPE won't be used for any more
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Disable an ACPI event (general purpose)
+ * DESCRIPTION: Release a reference to a GPE and disable it if necessary
  *
  ******************************************************************************/
-acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number)
+acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number, u8 type)
 {
 	acpi_status status = AE_OK;
 	acpi_cpu_flags flags;
@@ -315,13 +344,24 @@ acpi_status acpi_disable_gpe(acpi_handle
 		goto unlock_and_exit;
 	}
 
-	status = acpi_ev_disable_gpe(gpe_event_info);
+	if ((type & ACPI_GPE_TYPE_WAKE) && gpe_event_info->runtime_count) {
+		if (--gpe_event_info->runtime_count == 0)
+			acpi_ev_disable_gpe(gpe_event_info);
+	}
+
+	if ((type & ACPI_GPE_TYPE_RUNTIME) && gpe_event_info->wakeup_count) {
+		/*
+		 * Wake-up GPEs are not enabled after leaving system sleep
+		 * states, so we don't need to disable them here.
+		 */
+		if (--gpe_event_info->wakeup_count == 0)
+			acpi_ev_update_gpe_enable_masks(gpe_event_info);
+	}
 
 unlock_and_exit:
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
-
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
 
 /*******************************************************************************
Index: linux-2.6/include/acpi/acpixf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpixf.h
+++ linux-2.6/include/acpi/acpixf.h
@@ -281,11 +281,11 @@ acpi_status acpi_get_event_status(u32 ev
 /*
  * GPE Interfaces
  */
-acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type);
+acpi_status acpi_set_gpe(acpi_handle gpe_device, u32 gpe_number, u8 action);
 
-acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
+acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number, u8 type);
 
-acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number);
+acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number, u8 type);
 
 acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 gpe_number, u32 flags);
 
Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -422,11 +422,9 @@ static int acpi_button_add(struct acpi_d
 
 	if (device->wakeup.flags.valid) {
 		/* Button's GPE is run-wake GPE */
-		acpi_set_gpe_type(device->wakeup.gpe_device,
-				  device->wakeup.gpe_number,
-				  ACPI_GPE_TYPE_WAKE_RUN);
 		acpi_enable_gpe(device->wakeup.gpe_device,
-				device->wakeup.gpe_number);
+				device->wakeup.gpe_number,
+				ACPI_GPE_TYPE_WAKE_RUN);
 		device->wakeup.state.enabled = 1;
 	}
 
@@ -446,6 +444,13 @@ static int acpi_button_remove(struct acp
 {
 	struct acpi_button *button = acpi_driver_data(device);
 
+	if (device->wakeup.flags.valid) {
+		acpi_disable_gpe(device->wakeup.gpe_device,
+				device->wakeup.gpe_number,
+				ACPI_GPE_TYPE_WAKE_RUN);
+		device->wakeup.state.enabled = 0;
+	}
+
 	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -307,7 +307,7 @@ static int acpi_ec_transaction(struct ac
 	pr_debug(PREFIX "transaction start\n");
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		acpi_disable_gpe(NULL, ec->gpe);
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
 	}
 
 	status = acpi_ec_transaction_unlocked(ec, t);
@@ -317,7 +317,7 @@ static int acpi_ec_transaction(struct ac
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		msleep(1);
 		/* it is safe to enable GPE outside of transaction */
-		acpi_enable_gpe(NULL, ec->gpe);
+		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
 	} else if (t->irq_count > ACPI_EC_STORM_THRESHOLD) {
 		pr_info(PREFIX "GPE storm detected, "
 			"transactions will use polling mode\n");
@@ -788,8 +788,8 @@ static int ec_install_handlers(struct ac
 				  &acpi_ec_gpe_handler, ec);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
-	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
-	acpi_enable_gpe(NULL, ec->gpe);
+
+	acpi_enable_gpe(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
 						    &acpi_ec_space_handler,
@@ -806,6 +806,7 @@ static int ec_install_handlers(struct ac
 		} else {
 			acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler);
+			acpi_disable_gpe(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
 			return -ENODEV;
 		}
 	}
@@ -816,6 +817,7 @@ static int ec_install_handlers(struct ac
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
+	acpi_disable_gpe(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
 		pr_err(PREFIX "failed to remove space handler\n");
@@ -1058,7 +1060,7 @@ static int acpi_ec_suspend(struct acpi_d
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
 	/* Stop using GPE */
-	acpi_disable_gpe(NULL, ec->gpe);
+	acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
 	return 0;
 }
 
@@ -1066,7 +1068,7 @@ static int acpi_ec_resume(struct acpi_de
 {
 	struct acpi_ec *ec = acpi_driver_data(device);
 	/* Enable use of GPE back */
-	acpi_enable_gpe(NULL, ec->gpe);
+	acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
 	return 0;
 }
 
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -745,9 +745,18 @@ int acpi_pm_device_sleep_wake(struct dev
 		return -ENODEV;
 	}
 
-	error = enable ?
-		acpi_enable_wakeup_device_power(adev, acpi_target_sleep_state) :
-		acpi_disable_wakeup_device_power(adev);
+	if (enable) {
+		error = acpi_enable_wakeup_device_power(adev,
+						acpi_target_sleep_state);
+		if (!error)
+			acpi_enable_gpe(adev->wakeup.gpe_device,
+					adev->wakeup.gpe_number,
+					ACPI_GPE_TYPE_WAKE);
+	} else {
+		acpi_disable_gpe(adev->wakeup.gpe_device, adev->wakeup.gpe_number,
+				ACPI_GPE_TYPE_WAKE);
+		error = acpi_disable_wakeup_device_power(adev);
+	}
 	if (!error)
 		dev_info(dev, "wake-up capability %s by ACPI\n",
 				enable ? "enabled" : "disabled");
Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -21,12 +21,12 @@
 ACPI_MODULE_NAME("wakeup_devices")
 
 /**
- * acpi_enable_wakeup_device_prep - prepare wakeup devices
- *	@sleep_state:	ACPI state
- * Enable all wakup devices power if the devices' wakeup level
- * is higher than requested sleep level
+ * acpi_enable_wakeup_device_prep - Prepare wake-up devices.
+ * @sleep_state: ACPI system sleep state.
+ *
+ * Enable all wake-up devices' power, unless the requested system sleep state is
+ * too deep.
  */
-
 void acpi_enable_wakeup_device_prep(u8 sleep_state)
 {
 	struct list_head *node, *next;
@@ -36,9 +36,8 @@ void acpi_enable_wakeup_device_prep(u8 s
 						       struct acpi_device,
 						       wakeup_list);
 
-		if (!dev->wakeup.flags.valid ||
-		    !dev->wakeup.state.enabled ||
-		    (sleep_state > (u32) dev->wakeup.sleep_state))
+		if (!dev->wakeup.flags.valid || !dev->wakeup.state.enabled
+		    || (sleep_state > (u32) dev->wakeup.sleep_state))
 			continue;
 
 		acpi_enable_wakeup_device_power(dev, sleep_state);
@@ -46,9 +45,12 @@ void acpi_enable_wakeup_device_prep(u8 s
 }
 
 /**
- * acpi_enable_wakeup_device - enable wakeup devices
- *	@sleep_state:	ACPI state
- * Enable all wakup devices's GPE
+ * acpi_enable_wakeup_device - Enable wake-up device GPEs.
+ * @sleep_state: ACPI system sleep state.
+ *
+ * Enable all wake-up devices' GPEs, with the assumption that
+ * acpi_disable_all_gpes() was executed before, so we don't need to disable any
+ * GPEs here.
  */
 void acpi_enable_wakeup_device(u8 sleep_state)
 {
@@ -65,29 +67,22 @@ void acpi_enable_wakeup_device(u8 sleep_
 		if (!dev->wakeup.flags.valid)
 			continue;
 
-		/* If users want to disable run-wake GPE,
-		 * we only disable it for wake and leave it for runtime
-		 */
 		if ((!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
-		    || sleep_state > (u32) dev->wakeup.sleep_state) {
-			if (dev->wakeup.flags.run_wake) {
-				/* set_gpe_type will disable GPE, leave it like that */
-				acpi_set_gpe_type(dev->wakeup.gpe_device,
-						  dev->wakeup.gpe_number,
-						  ACPI_GPE_TYPE_RUNTIME);
-			}
+		    || sleep_state > (u32) dev->wakeup.sleep_state)
 			continue;
-		}
-		if (!dev->wakeup.flags.run_wake)
-			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
+
+		/* The wake-up power should have been enabled already. */
+		acpi_set_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
+				ACPI_GPE_ENABLE);
 	}
 }
 
 /**
- * acpi_disable_wakeup_device - disable devices' wakeup capability
- *	@sleep_state:	ACPI state
- * Disable all wakup devices's GPE and wakeup capability
+ * acpi_disable_wakeup_device - Disable devices' wakeup capability.
+ * @sleep_state: ACPI system sleep state.
+ *
+ * This function only affects devices with wakeup.state.enabled set, which means
+ * that it reverses the changes made by acpi_enable_wakeup_device_prep().
  */
 void acpi_disable_wakeup_device(u8 sleep_state)
 {
@@ -97,30 +92,11 @@ void acpi_disable_wakeup_device(u8 sleep
 		struct acpi_device *dev =
 			container_of(node, struct acpi_device, wakeup_list);
 
-		if (!dev->wakeup.flags.valid)
-			continue;
-
-		if ((!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
-		    || sleep_state > (u32) dev->wakeup.sleep_state) {
-			if (dev->wakeup.flags.run_wake) {
-				acpi_set_gpe_type(dev->wakeup.gpe_device,
-						  dev->wakeup.gpe_number,
-						  ACPI_GPE_TYPE_WAKE_RUN);
-				/* Re-enable it, since set_gpe_type will disable it */
-				acpi_enable_gpe(dev->wakeup.gpe_device,
-						dev->wakeup.gpe_number);
-			}
+		if (!dev->wakeup.flags.valid || !dev->wakeup.state.enabled
+		    || (sleep_state > (u32) dev->wakeup.sleep_state))
 			continue;
-		}
 
 		acpi_disable_wakeup_device_power(dev);
-		/* Never disable run-wake GPE */
-		if (!dev->wakeup.flags.run_wake) {
-			acpi_disable_gpe(dev->wakeup.gpe_device,
-					 dev->wakeup.gpe_number);
-			acpi_clear_gpe(dev->wakeup.gpe_device,
-				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
-		}
 	}
 }
 
@@ -136,11 +112,8 @@ int __init acpi_wakeup_device_init(void)
 		/* In case user doesn't load button driver */
 		if (!dev->wakeup.flags.run_wake || dev->wakeup.state.enabled)
 			continue;
-		acpi_set_gpe_type(dev->wakeup.gpe_device,
-				  dev->wakeup.gpe_number,
-				  ACPI_GPE_TYPE_WAKE_RUN);
-		acpi_enable_gpe(dev->wakeup.gpe_device,
-				dev->wakeup.gpe_number);
+ 		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
+ 				ACPI_GPE_TYPE_WAKE);
 		dev->wakeup.state.enabled = 1;
 	}
 	mutex_unlock(&acpi_device_lock);
Index: linux-2.6/drivers/acpi/acpica/acevents.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/acevents.h
+++ linux-2.6/drivers/acpi/acpica/acevents.h
@@ -76,8 +76,7 @@ acpi_ev_queue_notify_request(struct acpi
  * evgpe - GPE handling and dispatch
  */
 acpi_status
-acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info,
-				u8 type);
+acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status
 acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info,
@@ -122,9 +121,6 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_eve
 u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list);
 
 acpi_status
-acpi_ev_set_gpe_type(struct acpi_gpe_event_info *gpe_event_info, u8 type);
-
-acpi_status
 acpi_ev_check_for_wake_only_gpe(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status acpi_ev_gpe_initialize(void);
Index: linux-2.6/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpe.c
+++ linux-2.6/drivers/acpi/acpica/evgpe.c
@@ -54,54 +54,9 @@ static void ACPI_SYSTEM_XFACE acpi_ev_as
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ev_set_gpe_type
- *
- * PARAMETERS:  gpe_event_info          - GPE to set
- *              Type                    - New type
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Sets the new type for the GPE (wake, run, or wake/run)
- *
- ******************************************************************************/
-
-acpi_status
-acpi_ev_set_gpe_type(struct acpi_gpe_event_info *gpe_event_info, u8 type)
-{
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(ev_set_gpe_type);
-
-	/* Validate type and update register enable masks */
-
-	switch (type) {
-	case ACPI_GPE_TYPE_WAKE:
-	case ACPI_GPE_TYPE_RUNTIME:
-	case ACPI_GPE_TYPE_WAKE_RUN:
-		break;
-
-	default:
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
-
-	/* Disable the GPE if currently enabled */
-
-	status = acpi_ev_disable_gpe(gpe_event_info);
-
-	/* Clear the type bits and insert the new Type */
-
-	gpe_event_info->flags &= ~ACPI_GPE_TYPE_MASK;
-	gpe_event_info->flags |= type;
-	return_ACPI_STATUS(status);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ev_update_gpe_enable_masks
  *
  * PARAMETERS:  gpe_event_info          - GPE to update
- *              Type                    - What to do: ACPI_GPE_DISABLE or
- *                                        ACPI_GPE_ENABLE
  *
  * RETURN:      Status
  *
@@ -110,8 +65,7 @@ acpi_ev_set_gpe_type(struct acpi_gpe_eve
  ******************************************************************************/
 
 acpi_status
-acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info,
-				u8 type)
+acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info)
 {
 	struct acpi_gpe_register_info *gpe_register_info;
 	u8 register_bit;
@@ -127,37 +81,14 @@ acpi_ev_update_gpe_enable_masks(struct a
 	    (1 <<
 	     (gpe_event_info->gpe_number - gpe_register_info->base_gpe_number));
 
-	/* 1) Disable case. Simply clear all enable bits */
-
-	if (type == ACPI_GPE_DISABLE) {
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake,
-			       register_bit);
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
-		return_ACPI_STATUS(AE_OK);
-	}
-
-	/* 2) Enable case. Set/Clear the appropriate enable bits */
+	ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake, register_bit);
+	ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
 
-	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
-	case ACPI_GPE_TYPE_WAKE:
-		ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
-		break;
-
-	case ACPI_GPE_TYPE_RUNTIME:
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake,
-			       register_bit);
+	if (gpe_event_info->runtime_count)
 		ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
-		break;
 
-	case ACPI_GPE_TYPE_WAKE_RUN:
+	if (gpe_event_info->wakeup_count)
 		ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
-		ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
-		break;
-
-	default:
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
-	}
 
 	return_ACPI_STATUS(AE_OK);
 }
@@ -186,47 +117,20 @@ acpi_ev_enable_gpe(struct acpi_gpe_event
 
 	/* Make sure HW enable masks are updated */
 
-	status =
-	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_ENABLE);
-	if (ACPI_FAILURE(status)) {
+	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
+	if (ACPI_FAILURE(status))
 		return_ACPI_STATUS(status);
-	}
 
 	/* Mark wake-enabled or HW enable, or both */
 
-	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
-	case ACPI_GPE_TYPE_WAKE:
-
-		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
-		break;
-
-	case ACPI_GPE_TYPE_WAKE_RUN:
-
-		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
-
-		/*lint -fallthrough */
-
-	case ACPI_GPE_TYPE_RUNTIME:
-
-		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_RUN_ENABLED);
-
-		if (write_to_hardware) {
-
-			/* Clear the GPE (of stale events), then enable it */
-
-			status = acpi_hw_clear_gpe(gpe_event_info);
-			if (ACPI_FAILURE(status)) {
-				return_ACPI_STATUS(status);
-			}
-
-			/* Enable the requested runtime GPE */
-
-			status = acpi_hw_write_gpe_enable_reg(gpe_event_info);
-		}
-		break;
+	if (gpe_event_info->runtime_count && write_to_hardware) {
+		/* Clear the GPE (of stale events), then enable it */
+		status = acpi_hw_clear_gpe(gpe_event_info);
+		if (ACPI_FAILURE(status))
+			return_ACPI_STATUS(status);
 
-	default:
-		return_ACPI_STATUS(AE_BAD_PARAMETER);
+		/* Enable the requested runtime GPE */
+		status = acpi_hw_write_gpe_enable_reg(gpe_event_info);
 	}
 
 	return_ACPI_STATUS(AE_OK);
@@ -252,34 +156,9 @@ acpi_status acpi_ev_disable_gpe(struct a
 
 	/* Make sure HW enable masks are updated */
 
-	status =
-	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_DISABLE);
-	if (ACPI_FAILURE(status)) {
+	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
+	if (ACPI_FAILURE(status))
 		return_ACPI_STATUS(status);
-	}
-
-	/* Clear the appropriate enabled flags for this GPE */
-
-	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
-	case ACPI_GPE_TYPE_WAKE:
-		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
-		break;
-
-	case ACPI_GPE_TYPE_WAKE_RUN:
-		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
-
-		/* fallthrough */
-
-	case ACPI_GPE_TYPE_RUNTIME:
-
-		/* Disable the requested runtime GPE */
-
-		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_RUN_ENABLED);
-		break;
-
-	default:
-		break;
-	}
 
 	/*
 	 * Even if we don't know the GPE type, make sure that we always
Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -258,7 +258,6 @@ acpi_ev_save_method_info(acpi_handle obj
 	u32 gpe_number;
 	char name[ACPI_NAME_SIZE + 1];
 	u8 type;
-	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(ev_save_method_info);
 
@@ -325,26 +324,20 @@ acpi_ev_save_method_info(acpi_handle obj
 
 	/*
 	 * Now we can add this information to the gpe_event_info block for use
-	 * during dispatch of this GPE. Default type is RUNTIME, although this may
-	 * change when the _PRW methods are executed later.
+	 * during dispatch of this GPE.
 	 */
 	gpe_event_info =
 	    &gpe_block->event_info[gpe_number - gpe_block->block_base_number];
 
-	gpe_event_info->flags = (u8)
-	    (type | ACPI_GPE_DISPATCH_METHOD | ACPI_GPE_TYPE_RUNTIME);
+	gpe_event_info->flags = (u8) (type | ACPI_GPE_DISPATCH_METHOD);
 
 	gpe_event_info->dispatch.method_node =
 	    (struct acpi_namespace_node *)obj_handle;
 
-	/* Update enable mask, but don't enable the HW GPE as of yet */
-
-	status = acpi_ev_enable_gpe(gpe_event_info, FALSE);
-
 	ACPI_DEBUG_PRINT((ACPI_DB_LOAD,
 			  "Registered GPE method %s as GPE number 0x%.2X\n",
 			  name, gpe_number));
-	return_ACPI_STATUS(status);
+	return_ACPI_STATUS(AE_OK);
 }
 
 /*******************************************************************************
@@ -454,20 +447,7 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
 							gpe_block->
 							block_base_number];
 
-		/* Mark GPE for WAKE-ONLY but WAKE_DISABLED */
-
-		gpe_event_info->flags &=
-		    ~(ACPI_GPE_WAKE_ENABLED | ACPI_GPE_RUN_ENABLED);
-
-		status =
-		    acpi_ev_set_gpe_type(gpe_event_info, ACPI_GPE_TYPE_WAKE);
-		if (ACPI_FAILURE(status)) {
-			goto cleanup;
-		}
-
-		status =
-		    acpi_ev_update_gpe_enable_masks(gpe_event_info,
-						    ACPI_GPE_DISABLE);
+		gpe_event_info->flags |= ACPI_GPE_CAN_WAKE;
 	}
 
       cleanup:
@@ -989,7 +969,6 @@ acpi_status
 acpi_ev_initialize_gpe_block(struct acpi_namespace_node *gpe_device,
 			     struct acpi_gpe_block_info *gpe_block)
 {
-	acpi_status status;
 	struct acpi_gpe_event_info *gpe_event_info;
 	struct acpi_gpe_walk_info gpe_info;
 	u32 wake_gpe_count;
@@ -1019,42 +998,50 @@ acpi_ev_initialize_gpe_block(struct acpi
 		gpe_info.gpe_block = gpe_block;
 		gpe_info.gpe_device = gpe_device;
 
-		status =
-		    acpi_ns_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+		acpi_ns_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 					   ACPI_UINT32_MAX, ACPI_NS_WALK_UNLOCK,
 					   acpi_ev_match_prw_and_gpe, NULL,
 					   &gpe_info, NULL);
 	}
 
 	/*
-	 * Enable all GPEs in this block that have these attributes:
-	 * 1) are "runtime" or "run/wake" GPEs, and
-	 * 2) have a corresponding _Lxx or _Exx method
-	 *
-	 * Any other GPEs within this block must be enabled via the
-	 * acpi_enable_gpe() external interface.
+	 * Enable all GPEs that have a corresponding method and aren't
+	 * capable of generating wakeups. Any other GPEs within this block
+	 * must be enabled via the acpi_enable_gpe() interface.
 	 */
 	wake_gpe_count = 0;
 	gpe_enabled_count = 0;
+	if (gpe_device == acpi_gbl_fadt_gpe_device)
+		gpe_device = NULL;
 
 	for (i = 0; i < gpe_block->register_count; i++) {
-		for (j = 0; j < 8; j++) {
+		for (j = 0; j < ACPI_GPE_REGISTER_WIDTH; j++) {
+			acpi_status status;
+			acpi_size gpe_index;
+			int gpe_number;
 
 			/* Get the info block for this particular GPE */
+			gpe_index = (acpi_size)i * ACPI_GPE_REGISTER_WIDTH + j;
+			gpe_event_info = &gpe_block->event_info[gpe_index];
 
-			gpe_event_info = &gpe_block->event_info[((acpi_size) i *
-								 ACPI_GPE_REGISTER_WIDTH)
-								+ j];
-
-			if (((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-			     ACPI_GPE_DISPATCH_METHOD) &&
-			    (gpe_event_info->flags & ACPI_GPE_TYPE_RUNTIME)) {
-				gpe_enabled_count++;
-			}
-
-			if (gpe_event_info->flags & ACPI_GPE_TYPE_WAKE) {
+			if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE) {
 				wake_gpe_count++;
+				if (acpi_gbl_leave_wake_gpes_disabled)
+					continue;
 			}
+
+			if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD))
+				continue;
+
+			gpe_number = gpe_index + gpe_block->block_base_number;
+			status = acpi_enable_gpe(gpe_device, gpe_number,
+						ACPI_GPE_TYPE_RUNTIME);
+			if (ACPI_FAILURE(status))
+				ACPI_ERROR((AE_INFO,
+						"Failed to enable GPE %02X\n",
+						gpe_number));
+			else
+				gpe_enabled_count++;
 		}
 	}
 
@@ -1062,15 +1049,7 @@ acpi_ev_initialize_gpe_block(struct acpi
 			  "Found %u Wake, Enabled %u Runtime GPEs in this block\n",
 			  wake_gpe_count, gpe_enabled_count));
 
-	/* Enable all valid runtime GPEs found above */
-
-	status = acpi_hw_enable_runtime_gpe_block(NULL, gpe_block, NULL);
-	if (ACPI_FAILURE(status)) {
-		ACPI_ERROR((AE_INFO, "Could not enable GPEs in GpeBlock %p",
-			    gpe_block));
-	}
-
-	return_ACPI_STATUS(status);
+	return_ACPI_STATUS(AE_OK);
 }
 
 /*******************************************************************************
Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -617,13 +617,6 @@ acpi_install_gpe_handler(acpi_handle gpe
 	handler->context = context;
 	handler->method_node = gpe_event_info->dispatch.method_node;
 
-	/* Disable the GPE before installing the handler */
-
-	status = acpi_ev_disable_gpe(gpe_event_info);
-	if (ACPI_FAILURE(status)) {
-		goto unlock_and_exit;
-	}
-
 	/* Install the handler */
 
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
@@ -707,13 +700,6 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		goto unlock_and_exit;
 	}
 
-	/* Disable the GPE before removing the handler */
-
-	status = acpi_ev_disable_gpe(gpe_event_info);
-	if (ACPI_FAILURE(status)) {
-		goto unlock_and_exit;
-	}
-
 	/* Make sure all deferred tasks are completed */
 
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -668,15 +668,16 @@ typedef u32 acpi_event_status;
 
 /*
  * GPE info flags - Per GPE
- * +-+-+-+---+---+-+
- * |7|6|5|4:3|2:1|0|
- * +-+-+-+---+---+-+
- *  | | |  |   |  |
- *  | | |  |   |  +--- Interrupt type: Edge or Level Triggered
- *  | | |  |   +--- Type: Wake-only, Runtime-only, or wake/runtime
+ * +-+-+-+---+-+-+-+
+ * |7|6|5|4:3|2|1|0|
+ * +-+-+-+---+-+-+-+
+ *  | | |  |  | | |
+ *  | | |  |  | | +--- Interrupt type: Edge or Level Triggered
+ *  | | |  |  | +--- GPE can wake the system
+ *  | | |  |  +--- Unused
  *  | | |  +--- Type of dispatch -- to method, handler, or none
- *  | | +--- Enabled for runtime?
- *  | +--- Enabled for wake?
+ *  | | +--- Unused
+ *  | +--- Unused
  *  +--- Unused
  */
 #define ACPI_GPE_XRUPT_TYPE_MASK        (u8) 0x01
@@ -687,22 +688,13 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_TYPE_WAKE_RUN          (u8) 0x06
 #define ACPI_GPE_TYPE_WAKE              (u8) 0x02
 #define ACPI_GPE_TYPE_RUNTIME           (u8) 0x04	/* Default */
+#define ACPI_GPE_CAN_WAKE		(u8) 0x02
 
 #define ACPI_GPE_DISPATCH_MASK          (u8) 0x18
 #define ACPI_GPE_DISPATCH_HANDLER       (u8) 0x08
 #define ACPI_GPE_DISPATCH_METHOD        (u8) 0x10
 #define ACPI_GPE_DISPATCH_NOT_USED      (u8) 0x00	/* Default */
 
-#define ACPI_GPE_RUN_ENABLE_MASK        (u8) 0x20
-#define ACPI_GPE_RUN_ENABLED            (u8) 0x20
-#define ACPI_GPE_RUN_DISABLED           (u8) 0x00	/* Default */
-
-#define ACPI_GPE_WAKE_ENABLE_MASK       (u8) 0x40
-#define ACPI_GPE_WAKE_ENABLED           (u8) 0x40
-#define ACPI_GPE_WAKE_DISABLED          (u8) 0x00	/* Default */
-
-#define ACPI_GPE_ENABLE_MASK            (u8) 0x60	/* Both run/wake */
-
 /*
  * Flags for GPE and Lock interfaces
  */
Index: linux-2.6/drivers/acpi/system.c
===================================================================
--- linux-2.6.orig/drivers/acpi/system.c
+++ linux-2.6/drivers/acpi/system.c
@@ -387,10 +387,10 @@ static ssize_t counter_set(struct kobjec
 	if (index < num_gpes) {
 		if (!strcmp(buf, "disable\n") &&
 				(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_disable_gpe(handle, index);
+			result = acpi_set_gpe(handle, index, ACPI_GPE_DISABLE);
 		else if (!strcmp(buf, "enable\n") &&
 				!(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_enable_gpe(handle, index);
+			result = acpi_set_gpe(handle, index, ACPI_GPE_ENABLE);
 		else if (!strcmp(buf, "clear\n") &&
 				(status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index, ACPI_NOT_ISR);
