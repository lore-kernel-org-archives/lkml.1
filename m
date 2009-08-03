Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZHCBHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZHCBHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZHCBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:07:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:59734 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZHCBH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,310,1246863600"; 
   d="scan'208";a="713298355"
Subject: Re: [PATCH] thermal_sys: check get_temp return value
From: Zhang Rui <rui.zhang@intel.com>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090802140652.16effa08@mail.gmx.de>
References: <20090802140652.16effa08@mail.gmx.de>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 09:07:08 +0800
Message-Id: <1249261628.2670.184.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 20:06 +0800, Michael Brunner wrote:
> The return value of the get_temp function is not checked when doing a
> thermal zone update. This may lead to a critical shutdown if get_temp
> fails and the content of the temp variable is incorrectly set higher
> than the critical trip point.
> This has been observed on a system with incorrect ACPI implementation
> where the corresponding methods were not serialized and therefore
> sometimes triggered ACPI errors (AE_ALREADY_EXISTS). The following
> critical shutdowns indicated a temperature of 2097 C, which was
> obviously wrong.
> 
> The patch adds a return value check that jumps over all trip point
> evaluations printing a warning if get_temp fails. The trip points are
> evaluated again on the next polling interval with successful get_temp
> execution.
> 
> Signed-off-by: Michael Brunner <mibru@gmx.de>
> 
good catch, Michael. :)

Signed-off-by: Zhang Rui <rui.zhang@intel.com>

> ---
> 
>  drivers/thermal/thermal_sys.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 0a69672..4e83c29 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -953,7 +953,12 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>  
>  	mutex_lock(&tz->lock);
>  
> -	tz->ops->get_temp(tz, &temp);
> +	if (tz->ops->get_temp(tz, &temp)) {
> +		/* get_temp failed - retry it later */
> +		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
> +		       "%d\n", tz->id);
> +		goto leave;
> +	}
>  
>  	for (count = 0; count < tz->trips; count++) {
>  		tz->ops->get_trip_type(tz, count, &trip_type);
> @@ -1005,6 +1010,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>  					    THERMAL_TRIPS_NONE);
>  
>  	tz->last_temperature = temp;
> +
> +      leave:
>  	if (tz->passive)
>  		thermal_zone_device_set_polling(tz, tz->passive_delay);
>  	else if (tz->polling_delay)

