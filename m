Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbYETRbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbYETRbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYETRb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:31:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42719 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYETRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:31:23 -0400
Date: Tue, 20 May 2008 19:31:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c : use class_for_each_device
Message-ID: <20080520193113.19ef0dc5@hyperion.delvare>
In-Reply-To: <20080509072029.GA2740@darkstar.te-china.tietoenator.com>
References: <20080509072029.GA2740@darkstar.te-china.tietoenator.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Fri, 9 May 2008 15:20:29 +0800, Dave Young wrote:
> Use class_for_each_device for iteration.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
>  drivers/i2c/i2c-core.c |   96 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 52 insertions(+), 44 deletions(-)
> 
> diff -upr a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> --- a/drivers/i2c/i2c-core.c	2008-05-09 13:55:41.000000000 +0800
> +++ b/drivers/i2c/i2c-core.c	2008-05-09 14:24:07.000000000 +0800
> @@ -35,7 +35,6 @@
>  #include <linux/completion.h>
>  #include <linux/hardirq.h>
>  #include <linux/irqflags.h>
> -#include <linux/semaphore.h>
>  #include <asm/uaccess.h>
>  
>  #include "i2c-core.h"
> @@ -655,6 +654,16 @@ EXPORT_SYMBOL(i2c_del_adapter);
>  
>  
>  /* ------------------------------------------------------------------------- */
> +static int __attach_adapter(struct device *dev, void *data)
> +{
> +	struct i2c_adapter *adapter;
> +	struct i2c_driver *driver = data;
> +
> +	adapter = container_of(dev, struct i2c_adapter, dev);

You could use to_i2c_adapter(dev).

> +	driver->attach_adapter(adapter);
> +
> +	return 0;
> +}
>  
>  /*
>   * An i2c_driver is used with one or more i2c_client (device) nodes to access
> @@ -696,21 +705,52 @@ int i2c_register_driver(struct module *o
>  	pr_debug("i2c-core: driver [%s] registered\n", driver->driver.name);
>  
>  	/* legacy drivers scan i2c busses directly */
> -	if (driver->attach_adapter) {
> -		struct i2c_adapter *adapter;
> +	if (driver->attach_adapter)
> +		class_for_each_device(&i2c_adapter_class, driver,
> +					__attach_adapter);
> +
> +	mutex_unlock(&core_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(i2c_register_driver);
> +
> +static int __detach_adapter(struct device *dev, void *data)
> +{
> +	struct list_head   *item2, *_n;
> +	struct i2c_client  *client;
> +	struct i2c_adapter *adap;
> +	struct i2c_driver *driver = data;
>  
> -		down(&i2c_adapter_class.sem);
> -		list_for_each_entry(adapter, &i2c_adapter_class.devices,
> -				    dev.node) {
> -			driver->attach_adapter(adapter);
> +	/* Have a look at each adapter, if clients of this driver
> +	 * are still attached. If so, detach them to be able to
> +	 * kill the driver afterwards.
> +	 */
> +	adap = container_of(dev, struct i2c_adapter, dev);

You could use to_i2c_adapter(dev).

> +	if (driver->detach_adapter) {

Testing for a method...

> +		if (driver->attach_adapter(adap))

... but calling another one? Can't be correct. Which raises a question:
you didn't test your patch, did you? I'm also surprised how you managed
to mess this up, given that all you had to do was to move already
existing code around.

> +			dev_err(&adap->dev, "detach_adapter failed "
> +					"for driver [%s]\n",
> +					driver->driver.name);
> +	} else {
> +		list_for_each_safe(item2, _n, &adap->clients) {
> +			client = list_entry(item2, struct i2c_client,
> +					list);
> +			if (client->driver != driver)
> +				continue;
> +			dev_dbg(&adap->dev, "detaching client [%s] "
> +				"at 0x%02x\n", client->name,
> +				client->addr);
> +			if (driver->detach_client(client)) {
> +				dev_err(&adap->dev, "detach_client "
> +					"failed for client [%s] at "
> +					"0x%02x\n", client->name,
> +					client->addr);
> +			}
>  		}
> -		up(&i2c_adapter_class.sem);
>  	}
>  
> -	mutex_unlock(&core_lock);
>  	return 0;
>  }
> -EXPORT_SYMBOL(i2c_register_driver);
>  
>  /**
>   * i2c_del_driver - unregister I2C driver
> @@ -719,46 +759,14 @@ EXPORT_SYMBOL(i2c_register_driver);
>   */
>  void i2c_del_driver(struct i2c_driver *driver)
>  {
> -	struct list_head   *item2, *_n;
> -	struct i2c_client  *client;
> -	struct i2c_adapter *adap;
> -
>  	mutex_lock(&core_lock);
>  
>  	/* new-style driver? */
>  	if (is_newstyle_driver(driver))
>  		goto unregister;
>  
> -	/* Have a look at each adapter, if clients of this driver are still
> -	 * attached. If so, detach them to be able to kill the driver
> -	 * afterwards.
> -	 */
> -	down(&i2c_adapter_class.sem);
> -	list_for_each_entry(adap, &i2c_adapter_class.devices, dev.node) {
> -		if (driver->detach_adapter) {
> -			if (driver->detach_adapter(adap)) {
> -				dev_err(&adap->dev, "detach_adapter failed "
> -					"for driver [%s]\n",
> -					driver->driver.name);
> -			}
> -		} else {
> -			list_for_each_safe(item2, _n, &adap->clients) {
> -				client = list_entry(item2, struct i2c_client, list);
> -				if (client->driver != driver)
> -					continue;
> -				dev_dbg(&adap->dev, "detaching client [%s] "
> -					"at 0x%02x\n", client->name,
> -					client->addr);
> -				if (driver->detach_client(client)) {
> -					dev_err(&adap->dev, "detach_client "
> -						"failed for client [%s] at "
> -						"0x%02x\n", client->name,
> -						client->addr);
> -				}
> -			}
> -		}
> -	}
> -	up(&i2c_adapter_class.sem);
> +	class_for_each_device(&i2c_adapter_class, driver,
> +				__detach_adapter);
>  
>   unregister:
>  	driver_unregister(&driver->driver);

The rest looks OK. I'll fix the patch myself and add it to my i2c tree
now.

-- 
Jean Delvare
