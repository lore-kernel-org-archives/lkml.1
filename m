Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0BKKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:24:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0BKKYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:24:53 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Darren Jenkins <darrenrjenkins@gmail.com>
Subject: Re: [PATCH] drivers/acpi/processor_thermal.c
Date: Thu, 11 Feb 2010 11:24:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1265882211.27789.1.camel@ICE-BOX>
In-Reply-To: <1265882211.27789.1.camel@ICE-BOX>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111124.51070.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eh, 

what is this for?:
static inline void *acpi_driver_data(struct acpi_device *d)
{
        return d->driver_data;
}

On Thursday 11 February 2010 10:56:51 Darren Jenkins wrote:
> There are a few places where a pointer is dereferenced with acpi_driver_data()
> before a NULL test. This re-orders the code to fix these issues.
> 
> Coverity CID: 2752 2751 2750
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> ---
>  drivers/acpi/processor_thermal.c |   28 ++++++++++++++++++++--------
>  1 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> index 6deafb4..ec33554 100644
> --- a/drivers/acpi/processor_thermal.c
> +++ b/drivers/acpi/processor_thermal.c
> @@ -379,9 +379,14 @@ processor_get_max_state(struct thermal_cooling_device *cdev,
>  			unsigned long *state)
>  {
>  	struct acpi_device *device = cdev->devdata;
> -	struct acpi_processor *pr = acpi_driver_data(device);
> +	struct acpi_processor *pr;
>  
> -	if (!device || !pr)
> +	if (!device)
> +		return -EINVAL;
> +
> +	pr = acpi_driver_data(device);
Better use (here and at other places):
device->driver_data
instead of
acpi_driver_data(device)

if you touch this anyway.
Then such bugs like the one you address here, don't happen
anymore in the future.
If you have some more time you might want to revert all the
other instances and revert the acpi_driver_data declaration
in include/acpi/acpi_bus.h

Thanks,

       Thomas
