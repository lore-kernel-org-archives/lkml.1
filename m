Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYHZVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYHZVhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHZVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:37:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYHZVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:37:45 -0400
Date: Tue, 26 Aug 2008 14:36:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: vegard.nossum@gmail.com, zdenek.kabelac@gmail.com, hmh@hmh.eng.br,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC][PATCH] leds: fix oops race in led trigger
 registration
Message-Id: <20080826143657.7192afdf.akpm@linux-foundation.org>
In-Reply-To: <1219306014.5385.9.camel@dax.rpnet.com>
References: <20080821071750.GA8046@localhost.localdomain>
	<1219306014.5385.9.camel@dax.rpnet.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 09:06:54 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> Hi,
> 
> On Thu, 2008-08-21 at 09:17 +0200, Vegard Nossum wrote:
> > I resubmit this, which was posted a month ago, with no responses from
> > the maintainer (and no recent fixes in this area either). I have not
> > tested it myself, but I am reasonably confident that this is an
> > obviously correct fix. I guess it would not hurt to exercise it as well.
> > 
> > Zdenek: Have recent kernels also been showing this behaviour? Did the
> > patch fix the problem for you? You said something about a new issue
> > showing up, do you think that was related to this patch?
> > 
> > Also, just one question (since I'm newbie at this): Is it dangerous to
> > register the &dev_attr_trigger device file before we put the device on
> > the list or initialize it completely? If so, the initialization should
> > probably be moved all to the top before the file is made public.
> 
> This patch isn't quite right since whilst it fixes one race, it opens up
> a number of other potential problems. We definitely should have the led
> listed in leds_list before calling the various functions and the
> existing init order is correct in that sense.
> 
> I suspect your problem is caused by something calling a trigger
> registration between the point its added to the list and the
> init_rwsem(). The best solution is to move the init_rwsem() to earlier
> in the function. Yes, that means some ifdef ugliness but so be it. Could
> you see whether you still see the problem with the patch below?
> 
> Cheers,
> 
> Richard
> 
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 559a408..c9d8219 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -113,6 +113,9 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>  	if (rc)
>  		goto err_out;
>  
> +#ifdef CONFIG_LEDS_TRIGGERS
> +	init_rwsem(&led_cdev->trigger_lock);
> +#endif
>  	/* add to the list of leds */
>  	down_write(&leds_list_lock);
>  	list_add_tail(&led_cdev->node, &leds_list);
> @@ -121,8 +124,6 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>  	led_update_brightness(led_cdev);
>  
>  #ifdef CONFIG_LEDS_TRIGGERS
> -	init_rwsem(&led_cdev->trigger_lock);
> -
>  	rc = device_create_file(led_cdev->dev, &dev_attr_trigger);
>  	if (rc)
>  		goto err_out_led_list;
> 

??

