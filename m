Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYD2Esi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYD2Esi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYD2Es2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:48:28 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:63695 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYD2Es1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:48:27 -0400
Message-ID: <4816A888.9000802@aknet.ru>
Date: Tue, 29 Apr 2008 08:48:08 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: tiwai@suse.de
CC: gregkh@suse.de, Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
 added to gregkh-2.6 tree
References: <12094266793898@kroah.org>
In-Reply-To: <12094266793898@kroah.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

gregkh@suse.de wrote:
> This is a note to let you know that I've just added the patch titled
>      Subject: driver core: warn about duplicate driver names on the same bus
> to my gregkh-2.6 tree.  Its filename is
Thanks.

Takashi, do you think this fixes the
pcspkr/snd-pcsp conflict sufficienly
well? I think the Kconfig protection
is no longer needed. For the better
convinience the modprobe rule can be
created that will remove one driver
before inserting another. But this is
optional.
What do you think? Can we now remove
the Kconfig protection?


>      driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
> 
> This tree can be found at 
>     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> 
> 
>>From stsp@aknet.ru Sat Apr 26 08:52:51 2008
> From: Stas Sergeev <stsp@aknet.ru>
> Date: Sat, 26 Apr 2008 19:52:35 +0400
> Subject: driver core: warn about duplicate driver names on the same bus
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg KH <greg@kroah.com>, Takashi Iwai <tiwai@suse.de>
> Message-ID: <48134FC3.6040002@aknet.ru>
> 
> 
> Currently an attempt to register multiple
> drivers with the same name causes the
> stack trace with some cryptic error message.
> The attached patch adds the necessary check
> and the clear error message.
> 
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/base/driver.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -217,12 +217,22 @@ static void driver_remove_groups(struct 
>  int driver_register(struct device_driver *drv)
>  {
>  	int ret;
> +	struct device_driver *other;
>  
>  	if ((drv->bus->probe && drv->probe) ||
>  	    (drv->bus->remove && drv->remove) ||
>  	    (drv->bus->shutdown && drv->shutdown))
>  		printk(KERN_WARNING "Driver '%s' needs updating - please use "
>  			"bus_type methods\n", drv->name);
> +
> +	other = driver_find(drv->name, drv->bus);
> +	if (other) {
> +		put_driver(other);
> +		printk(KERN_ERR "Error: Driver '%s' is already registered, "
> +			"aborting...\n", drv->name);
> +		return -EEXIST;
> +	}
> +
>  	ret = bus_add_driver(drv);
>  	if (ret)
>  		return ret;
> 
> 
> Patches currently in gregkh-2.6 which might be from stsp@aknet.ru are
> 
> driver-core/driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
> 

