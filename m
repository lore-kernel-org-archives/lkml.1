Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZHCVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZHCVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHCVZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:25:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZHCVZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:25:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH V2 2/4] introduce the device async action mechanism
Date: Mon, 3 Aug 2009 23:26:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru
References: <1248404524.2670.110.camel@rzhang-dt>
In-Reply-To: <1248404524.2670.110.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032326.03731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Zhang Rui wrote:
> Introduce Device Async Action Mechanism
> 
> In order to speed up Linux suspend/resume/shutdown process,
> we introduce the device async action mechanism that allow devices
> to suspend/resume/shutdown asynchronously.
> 
> The basic idea is that,
> if the suspend/resume/shutdown process of a device group,
> including a root device and its child devices, are independent of
> other devices, we create an async domain for this device group,
> and make them suspend/resume/shutdown asynchronously.    
> 
> Note that DEV_ASYNC_RESUME is different from DEV_ASYNC_SUSPEND and
> DEV_ASYNC_SHUTDOWN.
> In resume case, all the parents are resumed first.
> deferred resuming of the child devices won't break anything.
> So it's easy to find out a device group that supports DEV_ASYNC_RESUME.
> 
> In suspend/shutdown case, child devices should be suspended/shutdown
> before the parents. But deferred suspend/shutdown may break this rule.
> so for a device groups that supports DEV_ASYNC_SUSPEND&DEV_ASYNC_SHUTDOWN,
> the root device of this device async group must NOT depend on its parents.
> i.e. it's fully functional without its parents.
> e.g. I create a device async group for i8042 controller in patch 4,
> and the parent of i8042 controller device is the "platform" device under
> sysfs root device.

For general comments, please refer to my reply to the [0/4] message.  Some
coding-related remarks are below.

> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/base/Makefile     |    3 
>  drivers/base/async_dev.c  |  199 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/base/core.c       |   35 ++++++--
>  drivers/base/power/main.c |   24 +++++
>  include/linux/async_dev.h |   47 ++++++++++
>  include/linux/device.h    |    2 
>  6 files changed, 298 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/drivers/base/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/base/Makefile
> +++ linux-2.6/drivers/base/Makefile
> @@ -3,7 +3,8 @@
>  obj-y			:= core.o sys.o bus.o dd.o \
>  			   driver.o class.o platform.o \
>  			   cpu.o firmware.o init.o map.o devres.o \
> -			   attribute_container.o transport_class.o
> +			   attribute_container.o transport_class.o \
> +			   async_dev.o
>  obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
>  obj-$(CONFIG_ISA)	+= isa.o
> Index: linux-2.6/drivers/base/async_dev.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/async_dev.c
> @@ -0,0 +1,199 @@
> +/*
> + * async_dev.c: Device asynchronous functions
> + *
> + * (C) Copyright 2009 Intel Corporation
> + * Author: Zhang Rui <rui.zhang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/async.h>
> +#include <linux/async_dev.h>
> +
> +static LIST_HEAD(dev_async_list);
> +static int dev_async_enabled;
> +
> +struct dev_async_context {
> +	struct device *dev;
> +	void *data;
> +	void *func;
> +};

Please, _please_ don't use (void * ) for passing function pointers.  IMO doing
that is fundamentally wrong.

> +static int dev_action(struct device *dev, dev_async_func func,
> +			void *data)
> +{
> +	int error = 0;
> +
> +	if (!func || !dev)
> +		return -EINVAL;
> +
> +	error = func(dev, data);
> +
> +	return error;
> +}

Hmm, what about:

+		return func && dev ? func(dev, data) : -EINVAL;

That gives you a one-liner, doesn't it?

> +static void dev_async_action(void *data, async_cookie_t cookie)
> +{
> +	int error;
> +	struct dev_async_context *context = data;
> +
> +	context->dev->dev_async->cookie = cookie;
> +	async_synchronize_cookie_domain(cookie,
> +					 &context->dev->dev_async->domain);
> +
> +	error =	dev_action(context->dev, context->func, context->data);
> +	if (error)
> +		printk(KERN_ERR "PM: Device %s async action failed: error %d\n",
> +			dev_name(context->dev), error);
> +
> +	kfree(context);
> +}
> +
> +/**
> + * dev_async_schedule - async execution of device actions.
> + * @dev: Device.
> + * @func: device callback function.
> + * @data: data.
> + * @type: the type of device async actions.
> + */
> +int dev_async_schedule(struct device *dev, dev_async_func func,
> +			void *data, int type)
> +{
> +	struct dev_async_context *context;
> +
> +	if (!func || !dev)
> +		return -EINVAL;
> +
> +	if (!(type & DEV_ASYNC_ACTIONS_ALL))
> +		return -EINVAL;
> +
> +	if (!dev_async_enabled || !dev->dev_async)
> +		return dev_action(dev, func, data);
> +
> +	/* device doesn't support the current async action */
> +	if (!(dev->dev_async->type & type))
> +		return dev_action(dev, func, data);
> +
> +	context = kzalloc(sizeof(struct dev_async_context), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	context->dev = dev;
> +	context->data = data;
> +	context->func = func;
> +	async_schedule_domain(dev_async_action, context,
> +			       &dev->dev_async->domain);
> +	return 0;
> +}
> +
> +/**
> + * device_async_synchronization - sync point for all the async actions
> + * @dev: Device.
> + *
> + * wait until all the async actions are done.
> + */
> +void dev_async_synchronization(void)
> +{
> +	struct dev_async_struct *pos;
> +
> +	list_for_each_entry(pos, &dev_async_list, node)
> +	    async_synchronize_full_domain(&pos->domain);
> +
> +	return;

What the return statement is for?

> +}
> +
> +static int dev_match(struct device *dev, void *data)
> +{
> +	dev_err(dev->parent, "Child device %s is registered before "
> +		"dev->dev_async being initialized", dev_name(dev));
> +	return 1;
> +}
> +
> +/**
> + * device_async_register - register a device that supports async actions
> + * @dev: Device.
> + * @type: the kind of dev async actions that supported
> + *
> + * Register a device that supports a certain kind of dev async actions.
> + * Create a synchrolization Domain for this device and share with all its
> + * child devices.
> + */
> +int dev_async_register(struct device *dev, int type)
> +{
> +	if (!dev_async_enabled)
> +		return 0;
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	if (dev->dev_async) {
> +		/* multiple async domains for a single device not supported */
> +		dev_err(dev, "async domain already registered\n");
> +		return -EEXIST;
> +	}
> +
> +	/*
> +	 * dev_async_register must be called before any of its child devices
> +	 * being registered to the driver model.
> +	 */
> +	if (dev->p)
> +		if (device_find_child(dev, NULL, dev_match)) {
> +			dev_err(dev, "Can not register device async domain\n");
> +			return -EINVAL;
> +		}
> +
> +	/* check for unsupported async actions */
> +	if (!(type & DEV_ASYNC_ACTIONS_ALL)) {
> +		dev_err(dev, "unsupported async action %x registered\n", type);
> +		return -EINVAL;
> +	}
> +
> +	dev->dev_async = kzalloc(sizeof(struct dev_async_struct), GFP_KERNEL);
> +	if (!dev->dev_async)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&dev->dev_async->domain);
> +	dev->dev_async->dev = dev;
> +	dev->dev_async->type = type;
> +	list_add_tail(&dev->dev_async->node, &dev_async_list);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dev_async_register);
> +
> +/**
> + * device_async_unregister - unregister a device that supports async actions
> + * @dev: Device.
> + *
> + * Unregister a device that supports async actions.
> + * And delete async action Domain at the same time.
> + */
> +void dev_async_unregister(struct device *dev)
> +{
> +	if (!dev_async_enabled)
> +		return;
> +
> +	if (!dev->dev_async)
> +		return;
> +
> +	if (dev->dev_async->dev != dev)
> +		return;
> +
> +	list_del(&dev->dev_async->node);
> +	kfree(dev->dev_async);
> +	dev->dev_async = NULL;
> +	return;

And here?

Well, it looks like my comments to the previous version of the patch were
silently ignored. :-(

Best,
Rafael
