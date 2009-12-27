Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZL0UMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZL0UMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZL0ULy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:11:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZL0ULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 7/12] ACPI: Remove old GPE API and transition code entirely to new one
Date: Sun, 27 Dec 2009 21:04:39 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl>
In-Reply-To: <200912272057.10443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272104.40186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Remove the old GPE type handling entirely, which gets rid of various quirks
like the implicit disabling with GPE type setting. This requires a small
amount of rework in order to ensure that non-wake GPEs are enabled by
default to preserve existing behaviour.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
drivers/acpi/acpica/acevents.h |    6 +--
 drivers/acpi/acpica/acevents.h |    6 -
 drivers/acpi/acpica/evgpe.c    |  147 +++--------------------------------------
 drivers/acpi/acpica/evgpeblk.c |   69 ++++++-------------
 drivers/acpi/acpica/evxface.c  |   14 ---
 drivers/acpi/acpica/evxfevnt.c |   48 -------------
 drivers/acpi/button.c          |    5 -
 drivers/acpi/ec.c              |    2 
 drivers/acpi/wakeup.c          |   55 ++-------------
 include/acpi/actypes.h         |   32 ++------
 9 files changed, 59 insertions(+), 319 deletions(-)

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
@@ -127,37 +81,13 @@ acpi_ev_update_gpe_enable_masks(struct a
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
-
-	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
-	case ACPI_GPE_TYPE_WAKE:
-		ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
-		break;
+	ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake, register_bit);
+	ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
 
-	case ACPI_GPE_TYPE_RUNTIME:
-		ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake,
-			       register_bit);
+	if (gpe_event_info->runtime_count)
 		ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
-		break;
-
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
@@ -186,47 +116,21 @@ acpi_ev_enable_gpe(struct acpi_gpe_event
 
 	/* Make sure HW enable masks are updated */
 
-	status =
-	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_ENABLE);
+	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
 
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
@@ -253,34 +157,11 @@ acpi_status acpi_ev_disable_gpe(struct a
 	/* Make sure HW enable masks are updated */
 
 	status =
-	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_DISABLE);
+	    acpi_ev_update_gpe_enable_masks(gpe_event_info);
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
 
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
-
 	/*
 	 * Even if we don't know the GPE type, make sure that we always
 	 * disable it. low_disable_gpe will just clear the enable bit for this
Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -325,22 +325,16 @@ acpi_ev_save_method_info(acpi_handle obj
 
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
@@ -454,20 +448,7 @@ acpi_ev_match_prw_and_gpe(acpi_handle ob
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
@@ -1027,33 +1008,35 @@ acpi_ev_initialize_gpe_block(struct acpi
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
+	 * must be enabled via the acpi_ref_runtime_gpe interface.
 	 */
 	wake_gpe_count = 0;
 	gpe_enabled_count = 0;
 
 	for (i = 0; i < gpe_block->register_count; i++) {
 		for (j = 0; j < 8; j++) {
+			int gpe_number = i * ACPI_GPE_REGISTER_WIDTH + j;
 
 			/* Get the info block for this particular GPE */
 
-			gpe_event_info = &gpe_block->event_info[((acpi_size) i *
-								 ACPI_GPE_REGISTER_WIDTH)
-								+ j];
-
-			if (((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
-			     ACPI_GPE_DISPATCH_METHOD) &&
-			    (gpe_event_info->flags & ACPI_GPE_TYPE_RUNTIME)) {
-				gpe_enabled_count++;
-			}
+			gpe_event_info = &gpe_block->event_info[(acpi_size)
+								gpe_number];
 
-			if (gpe_event_info->flags & ACPI_GPE_TYPE_WAKE) {
+			if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE) {
 				wake_gpe_count++;
+				continue;
+			}
+
+			if (gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD) {
+				gpe_enabled_count++;
+				if (gpe_device == acpi_gbl_fadt_gpe_device)
+					status = acpi_ref_runtime_gpe(NULL,
+								      gpe_number);
+				else
+					status = acpi_ref_runtime_gpe(gpe_device,
+								      gpe_number);
 			}
 		}
 	}
@@ -1062,15 +1045,7 @@ acpi_ev_initialize_gpe_block(struct acpi
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
Index: linux-2.6/drivers/acpi/acpica/evxfevnt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxfevnt.c
+++ linux-2.6/drivers/acpi/acpica/evxfevnt.c
@@ -311,8 +311,7 @@ acpi_status acpi_ref_wakeup_gpe(acpi_han
 	}
 
 	if (++gpe_event_info->wakeup_count == 1)
-		acpi_ev_update_gpe_enable_masks(gpe_event_info,
-						ACPI_GPE_ENABLE);
+		acpi_ev_update_gpe_enable_masks(gpe_event_info);
 
 unlock_and_exit:
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
@@ -351,8 +350,7 @@ acpi_status acpi_unref_wakeup_gpe(acpi_h
 	}
 
 	if (--gpe_event_info->wakeup_count == 0)
-		acpi_ev_update_gpe_enable_masks(gpe_event_info,
-			ACPI_GPE_DISABLE);
+		acpi_ev_update_gpe_enable_masks(gpe_event_info);
 
 unlock_and_exit:
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
@@ -362,48 +360,6 @@ ACPI_EXPORT_SYMBOL(acpi_unref_wakeup_gpe
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_set_gpe_type
- *
- * PARAMETERS:  gpe_device      - Parent GPE Device
- *              gpe_number      - GPE level within the GPE block
- *              Type            - New GPE type
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Set the type of an individual GPE
- *
- ******************************************************************************/
-acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type)
-{
-	acpi_status status = AE_OK;
-	struct acpi_gpe_event_info *gpe_event_info;
-
-	ACPI_FUNCTION_TRACE(acpi_set_gpe_type);
-
-	/* Ensure that we have a valid GPE number */
-
-	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
-	if (!gpe_event_info) {
-		status = AE_BAD_PARAMETER;
-		goto unlock_and_exit;
-	}
-
-	if ((gpe_event_info->flags & ACPI_GPE_TYPE_MASK) == type) {
-		return_ACPI_STATUS(AE_OK);
-	}
-
-	/* Set the new type (will disable GPE if currently enabled) */
-
-	status = acpi_ev_set_gpe_type(gpe_event_info, type);
-
-      unlock_and_exit:
-	return_ACPI_STATUS(status);
-}
-
-ACPI_EXPORT_SYMBOL(acpi_set_gpe_type)
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_enable_gpe
  *
  * PARAMETERS:  gpe_device      - Parent GPE Device
Index: linux-2.6/drivers/acpi/button.c
===================================================================
--- linux-2.6.orig/drivers/acpi/button.c
+++ linux-2.6/drivers/acpi/button.c
@@ -422,11 +422,6 @@ static int acpi_button_add(struct acpi_d
 
 	if (device->wakeup.flags.valid) {
 		/* Button's GPE is run-wake GPE */
-		acpi_set_gpe_type(device->wakeup.gpe_device,
-				  device->wakeup.gpe_number,
-				  ACPI_GPE_TYPE_WAKE_RUN);
-		acpi_enable_gpe(device->wakeup.gpe_device,
-				device->wakeup.gpe_number);
 		acpi_ref_runtime_gpe(device->wakeup.gpe_device,
 				     device->wakeup.gpe_number);
 		acpi_ref_wakeup_gpe(device->wakeup.gpe_device,
Index: linux-2.6/drivers/acpi/ec.c
===================================================================
--- linux-2.6.orig/drivers/acpi/ec.c
+++ linux-2.6/drivers/acpi/ec.c
@@ -754,7 +754,7 @@ static int ec_install_handlers(struct ac
 				  &acpi_ec_gpe_handler, ec);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
-	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
+
 	acpi_ref_runtime_gpe(NULL, ec->gpe);
 	status = acpi_install_address_space_handler(ec->handle,
 						    ACPI_ADR_SPACE_EC,
Index: linux-2.6/drivers/acpi/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/acpi/wakeup.c
+++ linux-2.6/drivers/acpi/wakeup.c
@@ -62,25 +62,12 @@ void acpi_enable_wakeup_device(u8 sleep_
 		struct acpi_device *dev =
 			container_of(node, struct acpi_device, wakeup_list);
 
-		if (!dev->wakeup.flags.valid)
+		if (!dev->wakeup.flags.valid ||
+		    !dev->wakeup.prepare_count ||
+		    !dev->wakeup.state.enabled ||
+		    (sleep_state > (u32) dev->wakeup.sleep_state))
 			continue;
 
-		/* If users want to disable run-wake GPE,
-		 * we only disable it for wake and leave it for runtime
-		 */
-		if ((!dev->wakeup.state.enabled && !dev->wakeup.prepare_count)
-		    || sleep_state > (u32) dev->wakeup.sleep_state) {
-			if (dev->wakeup.flags.run_wake) {
-				/* set_gpe_type will disable GPE, leave it like that */
-				acpi_set_gpe_type(dev->wakeup.gpe_device,
-						  dev->wakeup.gpe_number,
-						  ACPI_GPE_TYPE_RUNTIME);
-			}
-			continue;
-		}
-		if (!dev->wakeup.flags.run_wake)
-			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
 		acpi_ref_wakeup_gpe(dev->wakeup.gpe_device,
 				    dev->wakeup.gpe_number);
 	}
@@ -99,32 +86,13 @@ void acpi_disable_wakeup_device(u8 sleep
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
-			continue;
-		}
+		if (dev->wakeup.state.enabled &&
+		    dev->wakeup.prepare_count &&
+		    sleep_state <= (u32) dev->wakeup.sleep_state)
+			acpi_unref_wakeup_gpe(dev->wakeup.gpe_device,
+					    dev->wakeup.gpe_number);
 
 		acpi_disable_wakeup_device_power(dev);
-		/* Never disable run-wake GPE */
-		if (!dev->wakeup.flags.run_wake) {
-			acpi_disable_gpe(dev->wakeup.gpe_device,
-					 dev->wakeup.gpe_number);
-			acpi_clear_gpe(dev->wakeup.gpe_device,
-				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
-		}
-		acpi_unref_wakeup_gpe(dev->wakeup.gpe_device,
-				    dev->wakeup.gpe_number);
 	}
 }
 
@@ -140,11 +108,6 @@ int __init acpi_wakeup_device_init(void)
 		/* In case user doesn't load button driver */
 		if (!dev->wakeup.flags.run_wake || dev->wakeup.state.enabled)
 			continue;
-		acpi_set_gpe_type(dev->wakeup.gpe_device,
-				  dev->wakeup.gpe_number,
-				  ACPI_GPE_TYPE_WAKE_RUN);
-		acpi_enable_gpe(dev->wakeup.gpe_device,
-				dev->wakeup.gpe_number);
 		acpi_ref_wakeup_gpe(dev->wakeup.gpe_device,
 				    dev->wakeup.gpe_number);
 		dev->wakeup.state.enabled = 1;
Index: linux-2.6/include/acpi/actypes.h
===================================================================
--- linux-2.6.orig/include/acpi/actypes.h
+++ linux-2.6/include/acpi/actypes.h
@@ -668,41 +668,29 @@ typedef u32 acpi_event_status;
 
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
 #define ACPI_GPE_LEVEL_TRIGGERED        (u8) 0x01
 #define ACPI_GPE_EDGE_TRIGGERED         (u8) 0x00
 
-#define ACPI_GPE_TYPE_MASK              (u8) 0x06
-#define ACPI_GPE_TYPE_WAKE_RUN          (u8) 0x06
-#define ACPI_GPE_TYPE_WAKE              (u8) 0x02
-#define ACPI_GPE_TYPE_RUNTIME           (u8) 0x04	/* Default */
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

