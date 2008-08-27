Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYH0VP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYH0VP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYH0VPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:15:17 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:44167 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYH0VPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:15:16 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] acpi-wmi: Enable event methods when registering notifiers
Date: Wed, 27 Aug 2008 22:15:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
References: <20080827150401.GA8966@srcf.ucam.org>
In-Reply-To: <20080827150401.GA8966@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272215.10199.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Wed, 27 Aug 2008 21:15:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 16:04:01 Matthew Garrett wrote:
> According to the ACPI-WMI spec, event blocks may provide a function call
> for enabling/disabling them. This patch adds support for making these
> calls when registering or removing notifications. Without this, my Dell
> firmware provides no data in the event notification.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

Andi, can you take this into the ACPI tree?

>
> ---
>
> diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
> index c33b1c6..c7f735f 100644
> --- a/drivers/acpi/wmi.c
> +++ b/drivers/acpi/wmi.c
> @@ -217,6 +217,35 @@ static bool find_guid(const char *guid_string, struct
> wmi_block **out) return 0;
>  }
>
> +static acpi_status wmi_method_enable(struct wmi_block *wblock, int enable)
> +{
> +	struct guid_block *block = NULL;
> +	char method[5];
> +	struct acpi_object_list input;
> +	union acpi_object params[1];
> +	acpi_status status;
> +	acpi_handle handle;
> +
> +	block = &wblock->gblock;
> +	handle = wblock->handle;
> +
> +	if (!block)
> +		return AE_NOT_EXIST;
> +
> +	input.count = 1;
> +	input.pointer = params;
> +	params[0].type = ACPI_TYPE_INTEGER;
> +	params[0].integer.value = enable;
> +
> +	snprintf(method, 5, "WE%02X", block->notify_id);
> +	status = acpi_evaluate_object(handle, method, &input, NULL);
> +
> +	if (status != AE_OK && status != AE_NOT_FOUND)
> +		return status;
> +	else
> +		return AE_OK;
> +}
> +
>  /*
>   * Exported WMI functions
>   */
> @@ -427,6 +456,7 @@ acpi_status wmi_install_notify_handler(const char
> *guid, wmi_notify_handler handler, void *data)
>  {
>  	struct wmi_block *block;
> +	acpi_status status;
>
>  	if (!guid || !handler)
>  		return AE_BAD_PARAMETER;
> @@ -441,7 +471,9 @@ wmi_notify_handler handler, void *data)
>  	block->handler = handler;
>  	block->handler_data = data;
>
> -	return AE_OK;
> +	status = wmi_method_enable(block, 1);
> +
> +	return status;
>  }
>  EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
>
> @@ -453,6 +485,7 @@ EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
>  acpi_status wmi_remove_notify_handler(const char *guid)
>  {
>  	struct wmi_block *block;
> +	acpi_status status;
>
>  	if (!guid)
>  		return AE_BAD_PARAMETER;
> @@ -464,10 +497,12 @@ acpi_status wmi_remove_notify_handler(const char
> *guid) if (!block->handler)
>  		return AE_NULL_ENTRY;
>
> +	status = wmi_method_enable(block, 0);
> +
>  	block->handler = NULL;
>  	block->handler_data = NULL;
>
> -	return AE_OK;
> +	return status;
>  }
>  EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);



-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
