Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZGOPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZGOPh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZGOPh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:37:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbZGOPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:37:56 -0400
Date: Wed, 15 Jul 2009 02:37:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 8/8] i8042: support device async suspend & shutdown
Message-ID: <20090715003716.GE2360@ucw.cz>
References: <1247643522.26272.83.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247643522.26272.83.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-15 15:38:42, Zhang Rui wrote:
> 
> i8042 controller support device async actions.
> 
> If boot option "dev_async_action" is added,
> i8042 controller and its child devices can be
> suspended/resumed/shutdown asynchronously.
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
> @@ -1284,14 +1284,21 @@ static int __init i8042_init(void)
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
> @@ -1304,6 +1311,7 @@ static int __init i8042_init(void)
>  
>  static void __exit i8042_exit(void)
>  {
> +	dev_async_unregister(&i8042_platform_device->dev);
>  	platform_device_unregister(i8042_platform_device);
>  	platform_driver_unregister(&i8042_driver);
>  	i8042_platform_exit();

Could we get the core to do async_unregister during device_unregister?

Or maybe better, just add flags during device_add?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
