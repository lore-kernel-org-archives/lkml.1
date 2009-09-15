Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZIOV3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZIOV3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbZIOV3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:29:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692AbZIOV3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:29:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/3] ACPI: Add infrastructure for refcounting GPE consumers
Date: Tue, 15 Sep 2009 23:30:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090902181014.GA10917@srcf.ucam.org> <1251915173-10144-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1251915173-10144-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909152330.38874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009, Matthew Garrett wrote:
> ACPI GPEs may map to multiple devices. The current GPE interface only
> provides a mechanism for enabling and disabling GPEs, making it difficult
> to change the state of GPEs at runtime without extensive cooperation
> between devices. Add an API to allow devices to indicate whether or not
> they want their device's GPE to be enabled for both runtime and wakeup
> events.

Looks fine in general, but are we going to do anything about unbalanced
puts?

Rafael


> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/acpi/acpica/aclocal.h  |    2 +
>  drivers/acpi/acpica/evxfevnt.c |  161 ++++++++++++++++++++++++++++++++++++++++
>  include/acpi/acpixf.h          |    8 ++
>  3 files changed, 171 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
> index ee986ed..935e351 100644
> --- a/drivers/acpi/acpica/aclocal.h
> +++ b/drivers/acpi/acpica/aclocal.h
> @@ -413,6 +413,8 @@ struct acpi_gpe_event_info {
>  	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
>  	u8 flags;		/* Misc info about this GPE */
>  	u8 gpe_number;		/* This GPE */
> +	u8 runtime_count;
> +	u8 wakeup_count;
>  };
>  
>  /* Information about a GPE register pair, one per each status/enable pair in an array */
> diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
> index 4721f58..2a98818 100644
> --- a/drivers/acpi/acpica/evxfevnt.c
> +++ b/drivers/acpi/acpica/evxfevnt.c
> @@ -201,6 +201,167 @@ ACPI_EXPORT_SYMBOL(acpi_enable_event)
>  
>  /*******************************************************************************
>   *
> + * FUNCTION:    acpi_get_runtime_gpe
> + *
> + * PARAMETERS:  gpe_device      - Parent GPE Device
> + *              gpe_number      - GPE level within the GPE block
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Take a reference to a runtime GPE
> + *
> + ******************************************************************************/
> +acpi_status acpi_get_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_cpu_flags flags;
> +	struct acpi_gpe_event_info *gpe_event_info;
> +
> +	ACPI_FUNCTION_TRACE(acpi_get_runtime_gpe);
> +
> +	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
> +
> +	/* Ensure that we have a valid GPE number */
> +
> +	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
> +	if (!gpe_event_info) {
> +		status = AE_BAD_PARAMETER;
> +		goto unlock_and_exit;
> +	}
> +
> +	if (++gpe_event_info->runtime_count == 1)
> +		status = acpi_ev_enable_gpe(gpe_event_info, TRUE);
> +
> +	if (ACPI_FAILURE(status))
> +		gpe_event_info->runtime_count--;
> +
> +unlock_and_exit:
> +	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> +	return_ACPI_STATUS(status);
> +}
> +ACPI_EXPORT_SYMBOL(acpi_get_runtime_gpe)
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_put_runtime_gpe
> + *
> + * PARAMETERS:  gpe_device      - Parent GPE Device
> + *              gpe_number      - GPE level within the GPE block
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Release a reference to a runtime GPE
> + *
> + ******************************************************************************/
> +acpi_status acpi_put_runtime_gpe(acpi_handle gpe_device, u32 gpe_number)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_cpu_flags flags;
> +	struct acpi_gpe_event_info *gpe_event_info;
> +
> +	ACPI_FUNCTION_TRACE(acpi_put_runtime_gpe);
> +
> +	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
> +
> +	/* Ensure that we have a valid GPE number */
> +
> +	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
> +	if (!gpe_event_info) {
> +		status = AE_BAD_PARAMETER;
> +		goto unlock_and_exit;
> +	}
> +
> +	if (--gpe_event_info->runtime_count == 0)
> +		acpi_ev_disable_gpe(gpe_event_info);
> +
> +unlock_and_exit:
> +	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> +	return_ACPI_STATUS(status);
> +}
> +ACPI_EXPORT_SYMBOL(acpi_put_runtime_gpe)
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_get_wakeup_gpe
> + *
> + * PARAMETERS:  gpe_device      - Parent GPE Device
> + *              gpe_number      - GPE level within the GPE block
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Take a reference to a wakeup GPE
> + *
> + ******************************************************************************/
> +acpi_status acpi_get_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_cpu_flags flags;
> +	struct acpi_gpe_event_info *gpe_event_info;
> +
> +	ACPI_FUNCTION_TRACE(acpi_get_wakeup_gpe);
> +
> +	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
> +
> +	/* Ensure that we have a valid GPE number */
> +
> +	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
> +	if (!gpe_event_info) {
> +		status = AE_BAD_PARAMETER;
> +		goto unlock_and_exit;
> +	}
> +
> +	if (++gpe_event_info->wakeup_count == 1)
> +		acpi_ev_update_gpe_enable_masks(gpe_event_info,
> +						ACPI_GPE_ENABLE);
> +
> +unlock_and_exit:
> +	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> +	return_ACPI_STATUS(status);
> +}
> +ACPI_EXPORT_SYMBOL(acpi_get_wakeup_gpe)
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_put_wakeup_gpe
> + *
> + * PARAMETERS:  gpe_device      - Parent GPE Device
> + *              gpe_number      - GPE level within the GPE block
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Release a reference to a wakeup GPE
> + *
> + ******************************************************************************/
> +acpi_status acpi_put_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number)
> +{
> +	acpi_status status = AE_OK;
> +	acpi_cpu_flags flags;
> +	struct acpi_gpe_event_info *gpe_event_info;
> +
> +	ACPI_FUNCTION_TRACE(acpi_put_wakeup_gpe);
> +
> +	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
> +
> +	/* Ensure that we have a valid GPE number */
> +
> +	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
> +	if (!gpe_event_info) {
> +		status = AE_BAD_PARAMETER;
> +		goto unlock_and_exit;
> +	}
> +
> +	if (--gpe_event_info->wakeup_count == 0)
> +		acpi_ev_update_gpe_enable_masks(gpe_event_info,
> +			ACPI_GPE_DISABLE);
> +
> +unlock_and_exit:
> +	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
> +	return_ACPI_STATUS(status);
> +}
> +ACPI_EXPORT_SYMBOL(acpi_put_wakeup_gpe)
> +
> +/*******************************************************************************
> + *
>   * FUNCTION:    acpi_set_gpe_type
>   *
>   * PARAMETERS:  gpe_device      - Parent GPE Device
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index 82ec6a3..671e699 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -280,6 +280,14 @@ acpi_status acpi_get_event_status(u32 event, acpi_event_status * event_status);
>   */
>  acpi_status acpi_set_gpe_type(acpi_handle gpe_device, u32 gpe_number, u8 type);
>  
> +acpi_status acpi_get_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
> +
> +acpi_status acpi_put_runtime_gpe(acpi_handle gpe_device, u32 gpe_number);
> +
> +acpi_status acpi_get_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
> +
> +acpi_status acpi_put_wakeup_gpe(acpi_handle gpe_device, u32 gpe_number);
> +
>  acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
>  
>  acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number);
> 
