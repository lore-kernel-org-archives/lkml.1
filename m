Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422Ab0AMKZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0AMKZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370Ab0AMKZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:25:28 -0500
Received: from poutre.nerim.net ([62.4.16.124]:53060 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0AMKZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:25:17 -0500
Date: Wed, 13 Jan 2010 11:25:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-i2c@vger.kernel.org,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: do not use device name after device_unregister
Message-ID: <20100113112515.3c73ceee@hyperion.delvare>
In-Reply-To: <1263332203-5542-1-git-send-email-cascardo@holoscopio.com>
References: <1263332203-5542-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thadeu,

On Tue, 12 Jan 2010 19:36:43 -0200, Thadeu Lima de Souza Cascardo wrote:
> dev_dbg outputs dev_name, which is released with device_unregister. This bug
> resulted in output like this:
> 
> [ 7860.470713] i2c Xy2�0: adapter [SMBus I801 adapter at 1880] unregistered
> 
> The right output would be:
> [   60.639233] i2c i2c-0: adapter [SMBus I801 adapter at 1880] unregistered

I can't reproduce this bug. Do you have a specific memory poisoning
option enabled by any chance? And which kernel version are you running
exactly?

> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/i2c/i2c-core.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 0ac2f90..d5db0f4 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -843,6 +843,9 @@ int i2c_del_adapter(struct i2c_adapter *adap)
>  				 adap->dev.parent);
>  #endif
>  
> +	/* device name is gone after device_unregister */
> +	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
> +
>  	/* clean up the sysfs representation */
>  	init_completion(&adap->dev_released);
>  	device_unregister(&adap->dev);
> @@ -855,8 +858,6 @@ int i2c_del_adapter(struct i2c_adapter *adap)
>  	idr_remove(&i2c_adapter_idr, adap->nr);
>  	mutex_unlock(&core_lock);
>  
> -	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
> -
>  	/* Clear the device structure in case this adapter is ever going to be
>  	   added again */
>  	memset(&adap->dev, 0, sizeof(adap->dev));

The device structure is embedded in struct i2c_adapter, so its memory
can't be reused before the i2c_adapter itself is freed, which can't
happen before the end of function i2c_del_adapter(). Until recently,
the device name was embedded in the device structure so the code above
was fine. But apparently this changed some 9 months ago...

-- 
Jean Delvare
