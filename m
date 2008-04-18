Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbYDRVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbYDRVPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbYDRUyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:54:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:63327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761739AbYDRUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:54:31 -0400
Subject: Re: [RFC PATCH try2] sysfs: add /sys/dev/{char,block} to lookup
	sysfs path by major:minor
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Mark Lord <lkml@rtr.ca>,
       NeilBrown <neilb@suse.de>, SL Baur <steve@xemacs.org>,
       Tejun Heo <htejun@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1208547223.5083.17.camel@dwillia2-linux.ch.intel.com>
References: <1208547223.5083.17.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 22:53:54 +0200
Message-Id: <1208552034.8589.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX198hK05Bu7c0v9xXQQPsnqsXtyx6KXqK5V1kHb
 xeKmjmPP2J9fYCcrP03jSdsBcr9OxJ1YxuwsZLm+L7vVI6dCHe
 ZovccFsAfby5wFsnK9Ai4CBdWfeE+10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 12:33 -0700, Dan Williams wrote:
> --- a/Documentation/filesystems/sysfs.txt
> +++ b/Documentation/filesystems/sysfs.txt
> @@ -248,6 +248,7 @@ The top level sysfs directory looks like:
>  block/
>  bus/
>  class/
> +dev/
>  devices/

Lots of stuff in that file is pretty damn wrong, and at it should
probably just be deleted. Care to put this new documentation into:
  Documentation/ABI/

> --- a/drivers/base/class.c
> +++ b/drivers/base/class.c
> @@ -134,6 +134,18 @@ static void remove_class_attrs(struct class *cls)
>  	}
>  }
>  
> +static void class_set_dev_kobj(struct class *class)
> +{
> +#ifdef CONFIG_BLOCK
> +	if (class == &block_class) {
> +		class->dev_kobj = block_kobj;
> +		return;
> +	}
> +#endif
> +
> +	class->dev_kobj = char_kobj;
> +}
> +

If you do:
  struct class block_class = {
    .name = "block",
    .dev_kobj = block_kobj,
  }

in:
  block/genhd.c
and put:
  if (!class->dev_kobj)
          class->dev_kobj = char_kobj;
in:
  class_register()
we can get rid of all this logic and the BLOCK #ifdef, right?

Also:
  class_create(THIS_MODULE, "usb_device");
in:
  drivers/usb/core/devio.c
should probably clear the dev_kobj after registration, and we can get
rid of the "parent has the same dev_t" logic?

> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -192,6 +192,7 @@ struct class {
>  	struct class_attribute		*class_attrs;
>  	struct class_device_attribute	*class_dev_attrs;
>  	struct device_attribute		*dev_attrs;
> +	struct kobject			*dev_kobj;
>  
>  	int (*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
>  	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
> @@ -204,6 +205,8 @@ struct class {
>  	int (*resume)(struct device *dev);
>  };
>  
> +extern struct kobject *block_kobj;
> +extern struct kobject *char_kobj;

These global symbols should get better names, to make it obvious that
it's "only" the /sys/dev/ stuff.


Thanks,
Kay

