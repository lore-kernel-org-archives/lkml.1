Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZGXHOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZGXHOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 03:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZGXHOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 03:14:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZGXHOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 03:14:19 -0400
Date: Fri, 24 Jul 2009 09:14:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, dtor@mail.ru
Subject: Re: [PATCH V2 4/4] i8042: support async suspend and shutdown
Message-ID: <20090724071411.GB10760@elf.ucw.cz>
References: <1248404532.2670.112.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248404532.2670.112.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-24 11:02:12, Zhang Rui wrote:
> 
> i8042 controller support device async actions.
> 
> If boot option "dev_async_action" is added,
> i8042 controller and its child devices can be
> suspended/shutdown asynchronously.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/input/serio/i8042.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/input/serio/i8042.c
> ===================================================================
> --- linux-2.6.orig/drivers/input/serio/i8042.c
> +++ linux-2.6/drivers/input/serio/i8042.c
> @@ -1285,14 +1285,21 @@ static int __init i8042_init(void)
>  		goto err_unregister_driver;
>  	}
>  
> -	err = platform_device_add(i8042_platform_device);
> +	err = dev_async_register(&i8042_platform_device->dev,
> +			DEV_ASYNC_SUSPEND | DEV_ASYNC_SHUTDOWN);
>  	if (err)
>  		goto err_free_device;
>  
> +	err = platform_device_add(i8042_platform_device);
> +	if (err)
> +		goto err_dev_async_unregister;
> +
>  	panic_blink = i8042_panic_blink;
>  
>  	return 0;
>  
> + err_dev_async_unregister:
> +	dev_async_unregister(&i8042_platform_device->dev);
>   err_free_device:
>  	platform_device_put(i8042_platform_device);
>   err_unregister_driver:

I still do not like the interface: manually unregistering seems to be
ugly & error prone.

> @@ -1305,6 +1312,7 @@ static int __init i8042_init(void)
>  
>  static void __exit i8042_exit(void)
>  {
> +	dev_async_unregister(&i8042_platform_device->dev);
>  	platform_device_unregister(i8042_platform_device);
>  	platform_driver_unregister(&i8042_driver);
>  	i8042_platform_exit();
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
