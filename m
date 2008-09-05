Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYIEAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYIEAVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYIEAVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:21:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbYIEAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:21:05 -0400
Date: Thu, 4 Sep 2008 17:20:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, dbaryshkov@gmail.com
Subject: Re: [PATCH] platform: add new device registration helper
Message-Id: <20080904172050.cbde3013.akpm@linux-foundation.org>
In-Reply-To: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
References: <1220563816-8106-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Sep 2008 01:30:16 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Add a helper that registers simple platform_device
> w/o resources but with parent and device data.
> 
> This is usefull to cleanup platform code from code that
> registers such simple devices as leds-gpio, generic-bl,
> etc.
> 

nits:

>  include/linux/platform_device.h |    2 +
>  2 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3f94039..fcd9f97 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -391,6 +391,53 @@ error:
>  }
>  EXPORT_SYMBOL_GPL(platform_device_register_simple);
>  
> +/**
> + * platform_device_register_data
> + * @parent: parent device for the device we're adding
> + * @name: base name of the device we're adding
> + * @id: instance id
> + * @data: platform specific data for this platform device
> + * @size: size of platform specific data
> + *
> + * This function creates a simple platform device that requires minimal
> + * resource and memory management. Canned release function freeing memory
> + * allocated for the device allows drivers using such devices to be
> + * unloaded without waiting for the last reference to the device to be
> + * dropped.

Should document the return value (tested with IS_ERR)

> + */
> +struct platform_device *platform_device_register_data(
> +		struct device *parent,
> +		const char *name, int id,
> +		const void *data, size_t size)

Something like

struct platform_device *platform_device_register_data(struct device *parent,
			const char *name, int id, const void *data, size_t size)

would be more typical.  

> +{
> +	struct platform_device *pdev;
> +	int retval;
> +
> +	pdev = platform_device_alloc(name, id);
> +	if (!pdev) {
> +		retval = -ENOMEM;
> +		goto error;
> +	}
> +
> +	pdev->dev.parent = parent;
> +
> +	if (size) {
> +		retval = platform_device_add_data(pdev, data, size);
> +		if (retval)
> +			goto error;
> +	}
> +
> +	retval = platform_device_add(pdev);
> +	if (retval)
> +		goto error;
> +
> +	return pdev;
> +
> +error:
> +	platform_device_put(pdev);

Are you sure this can't trigger a !kobj->state_initialized warning in
kobject_put()?

> +	return ERR_PTR(retval);
> +}
> +
>
> ...
>
> +extern struct platform_device *platform_device_register_data(struct device *,
> +		const char *, int, const void *, size_t);

It's nice (IMO) to include the names of the args, for documentation
purposes.  Obviously the surrounding code didn't agree.

