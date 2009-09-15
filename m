Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZIOVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZIOVto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZIOVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:49:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZIOVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:49:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 3/3] ACPI: Remove old GPE API and transition code entirely to new one
Date: Tue, 15 Sep 2009 23:50:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090902181014.GA10917@srcf.ucam.org> <1251915173-10144-2-git-send-email-mjg@redhat.com> <1251915173-10144-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1251915173-10144-3-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909152350.37948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009, Matthew Garrett wrote:
> Remove the old GPE type handling entirely, which gets rid of various
> quirks like the implicit disabling with GPE type setting and some entirely
> dead code that set flags that were never used by anything else in the
> kernel. Also fix up some comments that erroneously claimed that the code
> they were commenting was actually enabling GPEs.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/acpica/acevents.h |    6 +-
>  drivers/acpi/acpica/evgpe.c    |  150 ++++--------------------------------
>  drivers/acpi/acpica/evgpeblk.c |  164 +---------------------------------------
>  drivers/acpi/acpica/evxface.c  |   14 ----
>  drivers/acpi/acpica/evxfevnt.c |   48 +-----------
>  drivers/acpi/button.c          |    5 -
>  drivers/acpi/ec.c              |    2 -
>  drivers/acpi/wakeup.c          |   55 ++-----------
>  include/acpi/actypes.h         |   32 ++------
>  9 files changed, 41 insertions(+), 435 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
> index 0bba148..197aa4f 100644
> --- a/drivers/acpi/acpica/acevents.h
> +++ b/drivers/acpi/acpica/acevents.h
> @@ -76,8 +76,7 @@ acpi_ev_queue_notify_request(struct acpi_namespace_node *node,
>   * evgpe - GPE handling and dispatch
>   */
>  acpi_status
> -acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info,
> -				u8 type);
> +acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info);
>  
>  acpi_status
>  acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info,
> @@ -122,9 +121,6 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info,
>  u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list);
>  
>  acpi_status
> -acpi_ev_set_gpe_type(struct acpi_gpe_event_info *gpe_event_info, u8 type);
> -
> -acpi_status
>  acpi_ev_check_for_wake_only_gpe(struct acpi_gpe_event_info *gpe_event_info);
>  
>  acpi_status acpi_ev_gpe_initialize(void);
> diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
> index b9d8ee6..97c0e0f 100644
> --- a/drivers/acpi/acpica/evgpe.c
> +++ b/drivers/acpi/acpica/evgpe.c
> @@ -54,54 +54,9 @@ static void ACPI_SYSTEM_XFACE acpi_ev_asynch_execute_gpe_method(void *context);
>  
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ev_set_gpe_type
> - *
> - * PARAMETERS:  gpe_event_info          - GPE to set
> - *              Type                    - New type
> - *
> - * RETURN:      Status
> - *
> - * DESCRIPTION: Sets the new type for the GPE (wake, run, or wake/run)
> - *
> - ******************************************************************************/
> -
> -acpi_status
> -acpi_ev_set_gpe_type(struct acpi_gpe_event_info *gpe_event_info, u8 type)
> -{
> -	acpi_status status;
> -
> -	ACPI_FUNCTION_TRACE(ev_set_gpe_type);
> -
> -	/* Validate type and update register enable masks */
> -
> -	switch (type) {
> -	case ACPI_GPE_TYPE_WAKE:
> -	case ACPI_GPE_TYPE_RUNTIME:
> -	case ACPI_GPE_TYPE_WAKE_RUN:
> -		break;
> -
> -	default:
> -		return_ACPI_STATUS(AE_BAD_PARAMETER);
> -	}
> -
> -	/* Disable the GPE if currently enabled */
> -
> -	status = acpi_ev_disable_gpe(gpe_event_info);
> -
> -	/* Clear the type bits and insert the new Type */
> -
> -	gpe_event_info->flags &= ~ACPI_GPE_TYPE_MASK;
> -	gpe_event_info->flags |= type;
> -	return_ACPI_STATUS(status);
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_ev_update_gpe_enable_masks
>   *
>   * PARAMETERS:  gpe_event_info          - GPE to update
> - *              Type                    - What to do: ACPI_GPE_DISABLE or
> - *                                        ACPI_GPE_ENABLE
>   *
>   * RETURN:      Status
>   *
> @@ -110,8 +65,7 @@ acpi_ev_set_gpe_type(struct acpi_gpe_event_info *gpe_event_info, u8 type)
>   ******************************************************************************/
>  
>  acpi_status
> -acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info,
> -				u8 type)
> +acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info)
>  {
>  	struct acpi_gpe_register_info *gpe_register_info;
>  	u8 register_bit;
> @@ -127,37 +81,13 @@ acpi_ev_update_gpe_enable_masks(struct acpi_gpe_event_info *gpe_event_info,
>  	    (1 <<
>  	     (gpe_event_info->gpe_number - gpe_register_info->base_gpe_number));
>  
> -	/* 1) Disable case. Simply clear all enable bits */
> -
> -	if (type == ACPI_GPE_DISABLE) {
> -		ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake,
> -			       register_bit);
> -		ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
> -		return_ACPI_STATUS(AE_OK);
> -	}
> -
> -	/* 2) Enable case. Set/Clear the appropriate enable bits */
> -
> -	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
> -	case ACPI_GPE_TYPE_WAKE:
> -		ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
> -		ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
> -		break;
> -
> -	case ACPI_GPE_TYPE_RUNTIME:
> -		ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake,
> -			       register_bit);
> -		ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
> -		break;
> -
> -	case ACPI_GPE_TYPE_WAKE_RUN:
> -		ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
> -		ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
> -		break;
> +	ACPI_CLEAR_BIT(gpe_register_info->enable_for_wake, register_bit);
> +	ACPI_CLEAR_BIT(gpe_register_info->enable_for_run, register_bit);
>  
> -	default:
> -		return_ACPI_STATUS(AE_BAD_PARAMETER);
> -	}
> +	if (gpe_event_info->runtime_count)
> +                ACPI_SET_BIT(gpe_register_info->enable_for_run, register_bit);
> +	if (gpe_event_info->wakeup_count)
> +                ACPI_SET_BIT(gpe_register_info->enable_for_wake, register_bit);
>  
>  	return_ACPI_STATUS(AE_OK);
>  }
> @@ -186,47 +116,22 @@ acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info,
>  
>  	/* Make sure HW enable masks are updated */
>  
> -	status =
> -	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_ENABLE);
> +	status = acpi_ev_update_gpe_enable_masks(gpe_event_info);
>  	if (ACPI_FAILURE(status)) {
>  		return_ACPI_STATUS(status);
>  	}
>  
>  	/* Mark wake-enabled or HW enable, or both */
>  
> -	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
> -	case ACPI_GPE_TYPE_WAKE:
> -
> -		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
> -		break;
> -
> -	case ACPI_GPE_TYPE_WAKE_RUN:
> -
> -		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
> -
> -		/*lint -fallthrough */
> -
> -	case ACPI_GPE_TYPE_RUNTIME:
> -
> -		ACPI_SET_BIT(gpe_event_info->flags, ACPI_GPE_RUN_ENABLED);
> -
> -		if (write_to_hardware) {
> -
> -			/* Clear the GPE (of stale events), then enable it */
> -
> -			status = acpi_hw_clear_gpe(gpe_event_info);
> -			if (ACPI_FAILURE(status)) {
> -				return_ACPI_STATUS(status);
> -			}
> -
> -			/* Enable the requested runtime GPE */
> -
> -			status = acpi_hw_write_gpe_enable_reg(gpe_event_info);
> +	if (gpe_event_info->runtime_count && write_to_hardware) {
> +		/* Clear the GPE (of stale events), then enable it */
> +		status = acpi_hw_clear_gpe(gpe_event_info);
> +		if (ACPI_FAILURE(status)) {
> +			return_ACPI_STATUS(status);
>  		}
> -		break;
>  
> -	default:
> -		return_ACPI_STATUS(AE_BAD_PARAMETER);
> +		/* Enable the requested runtime GPE */
> +		status = acpi_hw_write_gpe_enable_reg(gpe_event_info);
>  	}
>  
>  	return_ACPI_STATUS(AE_OK);
> @@ -253,34 +158,11 @@ acpi_status acpi_ev_disable_gpe(struct acpi_gpe_event_info *gpe_event_info)
>  	/* Make sure HW enable masks are updated */
>  
>  	status =
> -	    acpi_ev_update_gpe_enable_masks(gpe_event_info, ACPI_GPE_DISABLE);
> +	    acpi_ev_update_gpe_enable_masks(gpe_event_info);
>  	if (ACPI_FAILURE(status)) {
>  		return_ACPI_STATUS(status);
>  	}
>  
> -	/* Clear the appropriate enabled flags for this GPE */
> -
> -	switch (gpe_event_info->flags & ACPI_GPE_TYPE_MASK) {
> -	case ACPI_GPE_TYPE_WAKE:
> -		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
> -		break;
> -
> -	case ACPI_GPE_TYPE_WAKE_RUN:
> -		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_WAKE_ENABLED);
> -
> -		/* fallthrough */
> -
> -	case ACPI_GPE_TYPE_RUNTIME:
> -
> -		/* Disable the requested runtime GPE */
> -
> -		ACPI_CLEAR_BIT(gpe_event_info->flags, ACPI_GPE_RUN_ENABLED);
> -		break;
> -
> -	default:
> -		break;
> -	}
> -
>  	/*
>  	 * Even if we don't know the GPE type, make sure that we always
>  	 * disable it. low_disable_gpe will just clear the enable bit for this
> diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
> index 7b34636..51cc875 100644
> --- a/drivers/acpi/acpica/evgpeblk.c
> +++ b/drivers/acpi/acpica/evgpeblk.c
> @@ -54,10 +54,6 @@ static acpi_status
>  acpi_ev_save_method_info(acpi_handle obj_handle,
>  			 u32 level, void *obj_desc, void **return_value);
>  
> -static acpi_status
> -acpi_ev_match_prw_and_gpe(acpi_handle obj_handle,
> -			  u32 level, void *info, void **return_value);
> -
>  static struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block(u32
>  							       interrupt_number);
>  
> @@ -325,14 +321,12 @@ acpi_ev_save_method_info(acpi_handle obj_handle,
>  
>  	/*
>  	 * Now we can add this information to the gpe_event_info block for use
> -	 * during dispatch of this GPE. Default type is RUNTIME, although this may
> -	 * change when the _PRW methods are executed later.
> +	 * during dispatch of this GPE.
>  	 */
>  	gpe_event_info =
>  	    &gpe_block->event_info[gpe_number - gpe_block->block_base_number];
>  
> -	gpe_event_info->flags = (u8)
> -	    (type | ACPI_GPE_DISPATCH_METHOD | ACPI_GPE_TYPE_RUNTIME);
> +	gpe_event_info->flags = (u8) (type | ACPI_GPE_DISPATCH_METHOD);
>  
>  	gpe_event_info->dispatch.method_node =
>  	    (struct acpi_namespace_node *)obj_handle;
> @@ -349,134 +343,6 @@ acpi_ev_save_method_info(acpi_handle obj_handle,
>  
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ev_match_prw_and_gpe
> - *
> - * PARAMETERS:  Callback from walk_namespace
> - *
> - * RETURN:      Status. NOTE: We ignore errors so that the _PRW walk is
> - *              not aborted on a single _PRW failure.
> - *
> - * DESCRIPTION: Called from acpi_walk_namespace. Expects each object to be a
> - *              Device. Run the _PRW method. If present, extract the GPE
> - *              number and mark the GPE as a WAKE GPE.
> - *
> - ******************************************************************************/
> -
> -static acpi_status
> -acpi_ev_match_prw_and_gpe(acpi_handle obj_handle,
> -			  u32 level, void *info, void **return_value)
> -{
> -	struct acpi_gpe_walk_info *gpe_info = (void *)info;
> -	struct acpi_namespace_node *gpe_device;
> -	struct acpi_gpe_block_info *gpe_block;
> -	struct acpi_namespace_node *target_gpe_device;
> -	struct acpi_gpe_event_info *gpe_event_info;
> -	union acpi_operand_object *pkg_desc;
> -	union acpi_operand_object *obj_desc;
> -	u32 gpe_number;
> -	acpi_status status;
> -
> -	ACPI_FUNCTION_TRACE(ev_match_prw_and_gpe);
> -
> -	/* Check for a _PRW method under this device */
> -
> -	status = acpi_ut_evaluate_object(obj_handle, METHOD_NAME__PRW,
> -					 ACPI_BTYPE_PACKAGE, &pkg_desc);
> -	if (ACPI_FAILURE(status)) {
> -
> -		/* Ignore all errors from _PRW, we don't want to abort the subsystem */
> -
> -		return_ACPI_STATUS(AE_OK);
> -	}
> -
> -	/* The returned _PRW package must have at least two elements */
> -
> -	if (pkg_desc->package.count < 2) {
> -		goto cleanup;
> -	}
> -
> -	/* Extract pointers from the input context */
> -
> -	gpe_device = gpe_info->gpe_device;
> -	gpe_block = gpe_info->gpe_block;
> -
> -	/*
> -	 * The _PRW object must return a package, we are only interested in the
> -	 * first element
> -	 */
> -	obj_desc = pkg_desc->package.elements[0];
> -
> -	if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> -
> -		/* Use FADT-defined GPE device (from definition of _PRW) */
> -
> -		target_gpe_device = acpi_gbl_fadt_gpe_device;
> -
> -		/* Integer is the GPE number in the FADT described GPE blocks */
> -
> -		gpe_number = (u32) obj_desc->integer.value;
> -	} else if (obj_desc->common.type == ACPI_TYPE_PACKAGE) {
> -
> -		/* Package contains a GPE reference and GPE number within a GPE block */
> -
> -		if ((obj_desc->package.count < 2) ||
> -		    ((obj_desc->package.elements[0])->common.type !=
> -		     ACPI_TYPE_LOCAL_REFERENCE) ||
> -		    ((obj_desc->package.elements[1])->common.type !=
> -		     ACPI_TYPE_INTEGER)) {
> -			goto cleanup;
> -		}
> -
> -		/* Get GPE block reference and decode */
> -
> -		target_gpe_device =
> -		    obj_desc->package.elements[0]->reference.node;
> -		gpe_number = (u32) obj_desc->package.elements[1]->integer.value;
> -	} else {
> -		/* Unknown type, just ignore it */
> -
> -		goto cleanup;
> -	}
> -
> -	/*
> -	 * Is this GPE within this block?
> -	 *
> -	 * TRUE if and only if these conditions are true:
> -	 *     1) The GPE devices match.
> -	 *     2) The GPE index(number) is within the range of the Gpe Block
> -	 *          associated with the GPE device.
> -	 */
> -	if ((gpe_device == target_gpe_device) &&
> -	    (gpe_number >= gpe_block->block_base_number) &&
> -	    (gpe_number < gpe_block->block_base_number +
> -	     (gpe_block->register_count * 8))) {
> -		gpe_event_info = &gpe_block->event_info[gpe_number -
> -							gpe_block->
> -							block_base_number];
> -
> -		/* Mark GPE for WAKE-ONLY but WAKE_DISABLED */
> -
> -		gpe_event_info->flags &=
> -		    ~(ACPI_GPE_WAKE_ENABLED | ACPI_GPE_RUN_ENABLED);
> -
> -		status =
> -		    acpi_ev_set_gpe_type(gpe_event_info, ACPI_GPE_TYPE_WAKE);
> -		if (ACPI_FAILURE(status)) {
> -			goto cleanup;
> -		}
> -
> -		status =
> -		    acpi_ev_update_gpe_enable_masks(gpe_event_info,
> -						    ACPI_GPE_DISABLE);
> -	}
> -
> -      cleanup:
> -	acpi_ut_remove_reference(pkg_desc);
> -	return_ACPI_STATUS(AE_OK);
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_ev_get_gpe_xrupt_block
>   *
>   * PARAMETERS:  interrupt_number     - Interrupt for a GPE block
> @@ -991,7 +857,6 @@ acpi_ev_initialize_gpe_block(struct acpi_namespace_node *gpe_device,
>  {
>  	acpi_status status;
>  	struct acpi_gpe_event_info *gpe_event_info;
> -	struct acpi_gpe_walk_info gpe_info;
>  	u32 wake_gpe_count;
>  	u32 gpe_enabled_count;
>  	u32 i;
> @@ -1006,27 +871,6 @@ acpi_ev_initialize_gpe_block(struct acpi_namespace_node *gpe_device,
>  	}
>  
>  	/*
> -	 * Runtime option: Should wake GPEs be enabled at runtime?  The default
> -	 * is no, they should only be enabled just as the machine goes to sleep.
> -	 */
> -	if (acpi_gbl_leave_wake_gpes_disabled) {
> -		/*
> -		 * Differentiate runtime vs wake GPEs, via the _PRW control methods.
> -		 * Each GPE that has one or more _PRWs that reference it is by
> -		 * definition a wake GPE and will not be enabled while the machine
> -		 * is running.
> -		 */
> -		gpe_info.gpe_block = gpe_block;
> -		gpe_info.gpe_device = gpe_device;
> -
> -		status =
> -		    acpi_ns_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -					   ACPI_UINT32_MAX, ACPI_NS_WALK_UNLOCK,
> -					   acpi_ev_match_prw_and_gpe, &gpe_info,
> -					   NULL);
> -	}
> -
> -	/*
>  	 * Enable all GPEs in this block that have these attributes:
>  	 * 1) are "runtime" or "run/wake" GPEs, and
>  	 * 2) have a corresponding _Lxx or _Exx method
> @@ -1048,11 +892,11 @@ acpi_ev_initialize_gpe_block(struct acpi_namespace_node *gpe_device,
>  
>  			if (((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) ==
>  			     ACPI_GPE_DISPATCH_METHOD) &&
> -			    (gpe_event_info->flags & ACPI_GPE_TYPE_RUNTIME)) {
> +			    gpe_event_info->runtime_count) {
>  				gpe_enabled_count++;
>  			}
>  
> -			if (gpe_event_info->flags & ACPI_GPE_TYPE_WAKE) {
> +			if (gpe_event_info->wakeup_count) {
>  				wake_gpe_count++;
>  			}
>  		}
> diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
> index 10b8543..90cdeae 100644
> --- a/drivers/acpi/acpica/evxface.c
> +++ b/drivers/acpi/acpica/evxface.c
> @@ -617,13 +617,6 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
>  	handler->context = context;
>  	handler->method_node = gpe_event_info->dispatch.method_node;
>  
> -	/* Disable the GPE before installing the handler */
> -
> -	status = acpi_ev_disable_gpe(gpe_event_info);
> -	if (ACPI_FAILURE(status)) {
> -		goto unlock_and_exit;
> -	}
> -
>  	/* Install the handler */
>  
>  	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
> @@ -707,13 +700,6 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
>  		goto unlock_and_exit;
>  	}
>  
> -	/* Disable the GPE before removing the handler */
> -
> -	status = acpi_ev_disable_gpe(gpe_event_info);
> -	if (ACPI_FAILURE(status)) {
> -		goto unlock_and_exit;
> -	}
> -
>  	/* Make sure all deferred tasks are completed */
>  
>  	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
> diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
> index 2a98818..4fb451d 100644
> --- a/drivers/acpi/acpica/evxfevnt.c
> +++ b/drivers/acpi/acpica/evxfevnt.c
> @@ -311,8 +311,7 @@ acpi_status acpi_get_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
>  	}
>  
>  	if (++gpe_event_info->wakeup_count == 1)
> -		acpi_ev_update_gpe_enable_masks(gpe_event_info,
> -						ACPI_GPE_ENABLE);
> +		acpi_ev_update_gpe_enable_masks(gpe_event_info);
>  
>  unlock_and_exit:
>  	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> @@ -351,8 +350,7 @@ acpi_status acpi_put_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
>  	}
>  
>  	if (--gpe_event_info->wakeup_count == 0)
> -		acpi_ev_update_gpe_enable_masks(gpe_event_info,
> -			ACPI_GPE_DISABLE);
> +		acpi_ev_update_gpe_enable_masks(gpe_event_info);
>  
>  unlock_and_exit:
>  	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> @@ -362,48 +360,6 @@ ACPI_EXPORT_SYMBOL(acpi_put_wakeup_gpe)
>  
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_set_gpe_type
> - *
> - * PARAMETERS:  gpe_device      - Parent GPE Device
> - *              gpe_number      - GPE level within the GPE block
> - *              Type            - New GPE type
> - *
> - * RETURN:      Status
> - *
> - * DESCRIPTION: Set the type of an individual GPE
> - *
> - ******************************************************************************/
> -acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type)
> -{
> -	acpi_status status = AE_OK;
> -	struct acpi_gpe_event_info *gpe_event_info;
> -
> -	ACPI_FUNCTION_TRACE(acpi_set_gpe_type);
> -
> -	/* Ensure that we have a valid GPE number */
> -
> -	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
> -	if (!gpe_event_info) {
> -		status = AE_BAD_PARAMETER;
> -		goto unlock_and_exit;
> -	}
> -
> -	if ((gpe_event_info->flags & ACPI_GPE_TYPE_MASK) == type) {
> -		return_ACPI_STATUS(AE_OK);
> -	}
> -
> -	/* Set the new type (will disable GPE if currently enabled) */
> -
> -	status = acpi_ev_set_gpe_type(gpe_event_info, type);
> -
> -      unlock_and_exit:
> -	return_ACPI_STATUS(status);
> -}
> -
> -ACPI_EXPORT_SYMBOL(acpi_set_gpe_type)
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_enable_gpe
>   *
>   * PARAMETERS:  gpe_device      - Parent GPE Device
> diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
> index 4dd67b1..1a50241 100644
> --- a/drivers/acpi/button.c
> +++ b/drivers/acpi/button.c
> @@ -372,11 +372,6 @@ static int acpi_button_add(struct acpi_device *device)
>  
>  	if (device->wakeup.flags.valid) {
>  		/* Button's GPE is run-wake GPE */
> -		acpi_set_gpe_type(device->wakeup.gpe_device,
> -				  device->wakeup.gpe_number,
> -				  ACPI_GPE_TYPE_WAKE_RUN);
> -		acpi_enable_gpe(device->wakeup.gpe_device,
> -				device->wakeup.gpe_number);
>  		acpi_get_wakeup_gpe(device->wakeup.gpe_device,
>  				    device->wakeup.gpe_number);
>  		device->wakeup.state.enabled = 1;
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index 56f6ba9..a28373d 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -899,8 +899,6 @@ static int ec_install_handlers(struct acpi_ec *ec)
>  				  &acpi_ec_gpe_handler, ec);
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
> -	acpi_set_gpe_type(NULL, ec->gpe, ACPI_GPE_TYPE_RUNTIME);
> -	acpi_enable_gpe(NULL, ec->gpe);
>  	acpi_get_runtime_gpe(NULL, ec->gpe);
>  	status = acpi_install_address_space_handler(ec->handle,
>  						    ACPI_ADR_SPACE_EC,
> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> index 98023ef..ebe7250 100644
> --- a/drivers/acpi/wakeup.c
> +++ b/drivers/acpi/wakeup.c
> @@ -62,25 +62,12 @@ void acpi_enable_wakeup_device(u8 sleep_state)
>  		struct acpi_device *dev =
>  			container_of(node, struct acpi_device, wakeup_list);
>  
> -		if (!dev->wakeup.flags.valid)
> +		if (!dev->wakeup.flags.valid ||
> +		    !dev->wakeup.flags.prepared ||
> +		    !dev->wakeup.state.enabled ||
> +		    (sleep_state > (u32) dev->wakeup.sleep_state))
>  			continue;

That'll need to be updated after the PCI wake-up rework.

> -		/* If users want to disable run-wake GPE,
> -		 * we only disable it for wake and leave it for runtime
> -		 */
> -		if ((!dev->wakeup.state.enabled && !dev->wakeup.flags.prepared)
> -		    || sleep_state > (u32) dev->wakeup.sleep_state) {
> -			if (dev->wakeup.flags.run_wake) {
> -				/* set_gpe_type will disable GPE, leave it like that */
> -				acpi_set_gpe_type(dev->wakeup.gpe_device,
> -						  dev->wakeup.gpe_number,
> -						  ACPI_GPE_TYPE_RUNTIME);
> -			}
> -			continue;
> -		}
> -		if (!dev->wakeup.flags.run_wake)
> -			acpi_enable_gpe(dev->wakeup.gpe_device,
> -					dev->wakeup.gpe_number);
>  		acpi_get_wakeup_gpe(dev->wakeup.gpe_device,
>  				    dev->wakeup.gpe_number);
>  	}
> @@ -99,32 +86,13 @@ void acpi_disable_wakeup_device(u8 sleep_state)
>  		struct acpi_device *dev =
>  			container_of(node, struct acpi_device, wakeup_list);
>  
> -		if (!dev->wakeup.flags.valid)
> -			continue;
> -
> -		if ((!dev->wakeup.state.enabled && !dev->wakeup.flags.prepared)
> -		    || sleep_state > (u32) dev->wakeup.sleep_state) {
> -			if (dev->wakeup.flags.run_wake) {
> -				acpi_set_gpe_type(dev->wakeup.gpe_device,
> -						  dev->wakeup.gpe_number,
> -						  ACPI_GPE_TYPE_WAKE_RUN);
> -				/* Re-enable it, since set_gpe_type will disable it */
> -				acpi_enable_gpe(dev->wakeup.gpe_device,
> -						dev->wakeup.gpe_number);
> -			}
> -			continue;
> -		}
> +		if (dev->wakeup.state.enabled &&
> +		    dev->wakeup.flags.prepared &&
> +		    sleep_state <= (u32) dev->wakeup.sleep_state)
> +			acpi_put_wakeup_gpe(dev->wakeup.gpe_device,
> +					    dev->wakeup.gpe_number);

Ditto.

>  		acpi_disable_wakeup_device_power(dev);
> -		/* Never disable run-wake GPE */
> -		if (!dev->wakeup.flags.run_wake) {
> -			acpi_disable_gpe(dev->wakeup.gpe_device,
> -					 dev->wakeup.gpe_number);
> -			acpi_clear_gpe(dev->wakeup.gpe_device,
> -				       dev->wakeup.gpe_number, ACPI_NOT_ISR);
> -		}
> -		acpi_put_wakeup_gpe(dev->wakeup.gpe_device,
> -				    dev->wakeup.gpe_number);
>  	}
>  }
>  
> @@ -140,11 +108,6 @@ int __init acpi_wakeup_device_init(void)
>  		/* In case user doesn't load button driver */
>  		if (!dev->wakeup.flags.run_wake || dev->wakeup.state.enabled)
>  			continue;
> -		acpi_set_gpe_type(dev->wakeup.gpe_device,
> -				  dev->wakeup.gpe_number,
> -				  ACPI_GPE_TYPE_WAKE_RUN);
> -		acpi_enable_gpe(dev->wakeup.gpe_device,
> -				dev->wakeup.gpe_number);
>  		acpi_get_wakeup_gpe(dev->wakeup.gpe_device,
>  				    dev->wakeup.gpe_number);
>  		dev->wakeup.state.enabled = 1;
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index 37ba576..0c6f8d8 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -668,41 +668,27 @@ typedef u32 acpi_event_status;
>  
>  /*
>   * GPE info flags - Per GPE
> - * +-+-+-+---+---+-+
> - * |7|6|5|4:3|2:1|0|
> - * +-+-+-+---+---+-+
> - *  | | |  |   |  |
> - *  | | |  |   |  +--- Interrupt type: Edge or Level Triggered
> - *  | | |  |   +--- Type: Wake-only, Runtime-only, or wake/runtime
> + * +-+-+-+---+-+-+-+
> + * |7|6|5|4:3|2|1|0|
> + * +-+-+-+---+-+-+-+
> + *  | | |  |  | | |
> + *  | | |  |  | | +--- Interrupt type: Edge or Level Triggered
> + *  | | |  |  | +--- Unused
> + *  | | |  |  +--- Unused
>   *  | | |  +--- Type of dispatch -- to method, handler, or none
> - *  | | +--- Enabled for runtime?
> - *  | +--- Enabled for wake?
> + *  | | +--- Unused
> + *  | +--- Unused
>   *  +--- Unused
>   */
>  #define ACPI_GPE_XRUPT_TYPE_MASK        (u8) 0x01
>  #define ACPI_GPE_LEVEL_TRIGGERED        (u8) 0x01
>  #define ACPI_GPE_EDGE_TRIGGERED         (u8) 0x00
>  
> -#define ACPI_GPE_TYPE_MASK              (u8) 0x06
> -#define ACPI_GPE_TYPE_WAKE_RUN          (u8) 0x06
> -#define ACPI_GPE_TYPE_WAKE              (u8) 0x02
> -#define ACPI_GPE_TYPE_RUNTIME           (u8) 0x04	/* Default */
> -
>  #define ACPI_GPE_DISPATCH_MASK          (u8) 0x18
>  #define ACPI_GPE_DISPATCH_HANDLER       (u8) 0x08
>  #define ACPI_GPE_DISPATCH_METHOD        (u8) 0x10
>  #define ACPI_GPE_DISPATCH_NOT_USED      (u8) 0x00	/* Default */
>  
> -#define ACPI_GPE_RUN_ENABLE_MASK        (u8) 0x20
> -#define ACPI_GPE_RUN_ENABLED            (u8) 0x20
> -#define ACPI_GPE_RUN_DISABLED           (u8) 0x00	/* Default */
> -
> -#define ACPI_GPE_WAKE_ENABLE_MASK       (u8) 0x40
> -#define ACPI_GPE_WAKE_ENABLED           (u8) 0x40
> -#define ACPI_GPE_WAKE_DISABLED          (u8) 0x00	/* Default */
> -
> -#define ACPI_GPE_ENABLE_MASK            (u8) 0x60	/* Both run/wake */
> -
>  /*
>   * Flags for GPE and Lock interfaces
>   */

Apart from the comments above, looks really good.

Thanks,
Rafael
