Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZIBUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZIBUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZIBUh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:37:26 -0400
Received: from fifo99.com ([67.223.236.141]:57969 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZIBUh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:37:26 -0400
Subject: Re: [PATCH 3/3] ACPI: Remove old GPE API and transition code
 entirely to new one
From: Daniel Walker <dwalker@fifo99.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251915173-10144-3-git-send-email-mjg@redhat.com>
References: <20090902181014.GA10917@srcf.ucam.org>
	 <1251915173-10144-1-git-send-email-mjg@redhat.com>
	 <1251915173-10144-2-git-send-email-mjg@redhat.com>
	 <1251915173-10144-3-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 13:37:26 -0700
Message-Id: <1251923846.16819.4.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 14:12 -0400, Matthew Garrett wrote:
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

Could you run this through checkpatch.pl and fix any issues you find..
It looks like you have some copy&paste issues on the lines above.

Daniel

