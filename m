Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZGNA6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZGNA6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZGNA6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:58:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:7379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZGNA6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:58:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,393,1243839600"; 
   d="scan'208";a="707507613"
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
From: ykzhao <yakui.zhao@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       "lenb@kernel.org" <lenb@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
In-Reply-To: <1247517685-7719-1-git-send-email-mjg@redhat.com>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 14 Jul 2009 08:58:48 +0800
Message-Id: <1247533128.3704.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 04:41 +0800, Matthew Garrett wrote:
> Certain hardware will send us events when the backlight brightness
> changes. Add a function to update the value in the core, and
> additionally send a uevent so that userspace can pop up appropriate
> UI. The uevents are flagged depending on whether the update originated
> in the kernel or from userspace, making it easier to only display UI
> at the appropriate time.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/video/backlight/backlight.c |   23 +++++++++++++++++++++++
>  include/linux/backlight.h           |    1 +
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index 157057c..98ab76c 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -120,6 +120,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
>  {
>  	int rc;
>  	struct backlight_device *bd = to_backlight_device(dev);
> +	char *envp[] = { "SOURCE=userspace", NULL };
>  	unsigned long brightness;
>  
>  	rc = strict_strtoul(buf, 0, &brightness);
> @@ -142,6 +143,8 @@ static ssize_t backlight_store_brightness(struct device *dev,
>  	}
>  	mutex_unlock(&bd->ops_lock);
>  
> +	kobject_uevent_env(&bd->dev.kobj, KOBJ_CHANGE, envp);
> +
It will be better to send the event to user space only when the
brightness is updated successfully.
>  	return rc;
>  }
>  
> @@ -214,6 +217,26 @@ static struct device_attribute bl_device_attributes[] = {
>  };
>  
>  /**
> + * backlight_force_update - tell the backlight subsystem that hardware state
> + *   has changed
> + * @bd: the backlight device to update
> + *
> + * Updates the internal state of the backlight in response to a hardware event,
> + * and generate a uevent to notify userspace
> + */
> +void backlight_force_update(struct backlight_device *bd)
> +{
> +	char *envp[] = { "SOURCE=kernel", NULL };
> +
> +	mutex_lock(&bd->ops_lock);
> +	if (bd->ops && bd->ops->get_brightness)
> +		bd->props.brightness = bd->ops->get_brightness(bd);
> +	mutex_unlock(&bd->ops_lock);
> +	kobject_uevent_env(&bd->dev.kobj, KOBJ_CHANGE, envp);
> +}
> +EXPORT_SYMBOL(backlight_force_update);
It seems that the acpi video driver will send the ACPI event to user
space when updating the brightness. 
Is it necessary to send the udev-event again?
Thanks.
> +
> +/**
>   * backlight_device_register - create and register a new object of
>   *   backlight_device class.
>   * @name: the name of the new object(must be the same as the name of the
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index 79ca2da..8298c43 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -100,6 +100,7 @@ static inline void backlight_update_status(struct backlight_device *bd)
>  extern struct backlight_device *backlight_device_register(const char *name,
>  	struct device *dev, void *devdata, struct backlight_ops *ops);
>  extern void backlight_device_unregister(struct backlight_device *bd);
> +extern void backlight_force_update(struct backlight_device *bd);
>  
>  #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
>  

