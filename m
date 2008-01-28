Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYA1JaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYA1JaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYA1J37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:29:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYA1J36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:29:58 -0500
Date: Mon, 28 Jan 2008 01:29:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH -mm 2/2] PWM LED driver
Message-Id: <20080128012932.bfbbd97d.akpm@linux-foundation.org>
In-Reply-To: <20080128101551.7cbc7af5@dhcp-252-066.norway.atmel.com>
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-3-git-send-email-hskinnemoen@atmel.com>
	<20080127213232.ade044d5.akpm@linux-foundation.org>
	<20080128101551.7cbc7af5@dhcp-252-066.norway.atmel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 10:15:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Sun, 27 Jan 2008 21:32:32 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 24 Jan 2008 15:33:45 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > 
> > > +	if (i > 0) {
> > > +		for (i = i - 1; i >= 0; i--) {
> > > +			led_classdev_unregister(&leds[i].cdev);
> > > +			pwm_channel_free(&leds[i].pwmc);
> > > +		}
> > > +	}
> > 
> > Could be:
> > 
> > 	while (--i > 0) {
> > 		led_classdev_unregister(&leds[i].cdev);
> > 		pwm_channel_free(&leds[i].pwmc);
> > 	}
> > 
> > or thereabouts.
> 
> Almost...we need to clean up for leds[0] too. Using a postfix decrement
> should take care of that. How about the patch below?
> 
> Haavard
> 
> >From de5002ad71a1000f81817410f02a7d9fbd5d4ecd Mon Sep 17 00:00:00 2001
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Date: Mon, 28 Jan 2008 10:14:14 +0100
> Subject: [PATCH] PWM led driver: Simplify cleanup loop
> 
> Why use a for loop inside an if() when we can get away with a simple
> while() loop?
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/leds/leds-atmel-pwm.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
> index af61f55..187031c 100644
> --- a/drivers/leds/leds-atmel-pwm.c
> +++ b/drivers/leds/leds-atmel-pwm.c
> @@ -100,11 +100,9 @@ static int __init pwmled_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err:
> -	if (i > 0) {
> -		for (i = i - 1; i >= 0; i--) {
> -			led_classdev_unregister(&leds[i].cdev);
> -			pwm_channel_free(&leds[i].pwmc);
> -		}
> +	while (i-- > 0) {
> +		led_classdev_unregister(&leds[i].cdev);
> +		pwm_channel_free(&leds[i].pwmc);
>  	}

Looks OK, although I'd say that `while (--i >= 0)' is more idiomatic -
predecrement, postincrement and all that?

