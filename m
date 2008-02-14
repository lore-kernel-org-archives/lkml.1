Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbYBNQoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbYBNQoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYBNQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:43:41 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:28673 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755586AbYBNQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:43:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4qoxGZdaUIS7daQ65fCt0ae15P3ORhj4nOKdtdBx9Z7nJuvIZpOD4mt+pLsoG2TfvPlCVswOEWNzbkcO1ptN5IjuZyq3o9A4cVdDOKMJoaY1k1G9jcPUo/iSBhjBztPrs98UUbpKcVoJgMRRDKYEdonGPVZHQiKWe9Hi1t22eJE=  ;
X-YMail-OSG: 74SyyysVM1nPUsNViRKFzagFUzQ5wzVSqvEHh2bgM4HwVqbmq4ls5GqvlQYI3mzl8Wu30KfGIEEzhyRprKH_U1nD2UznsuY5vAZ6telKwxuA_CAfu0A-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] call gpio_cansleep only after gpio_request succeeded
Date: Thu, 14 Feb 2008 08:43:24 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Raphael Assenat <raph@8d.com>,
       Richard Purdie <rpurdie@rpsys.net>
References: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
In-Reply-To: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802140843.25103.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Uwe Kleine-König wrote:
> If you have GPIO_LIB gpio_cansleep oopses on an invalid
> gpio.  So better gpio_request your pin first.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... my bad, sorry.  The "first do gpio_request(), THEN
you can test gpio_cansleep()" issue got resolved in that
direction a bit late; this is the only in-tree driver
that I know would be affected.  My test platforms haven't
yet been updated to 2.6.25-rc1 ... :(



> Cc: Raphael Assenat <raph@8d.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
> Hello,
> 
> I currently start using GPIO_LIB and don't have any chips yet.  The Oops will
> vanish after I will have registered the chips for my SoC's gpios, but still
> this way the code is more robust.
> 
> Best regards
> Uwe
> 
>  drivers/leds/leds-gpio.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 6c0a9c4..76ddcf3 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -79,6 +79,10 @@ static int gpio_led_probe(struct platform_device *pdev)
>  		cur_led = &pdata->leds[i];
>  		led_dat = &leds_data[i];
>  
> +		ret = gpio_request(led_dat->gpio, cur_led->name);
> +		if (ret < 0)
> +			goto err;
> +
>  		led_dat->cdev.name = cur_led->name;
>  		led_dat->cdev.default_trigger = cur_led->default_trigger;
>  		led_dat->gpio = cur_led->gpio;
> @@ -87,10 +91,6 @@ static int gpio_led_probe(struct platform_device *pdev)
>  		led_dat->cdev.brightness_set = gpio_led_set;
>  		led_dat->cdev.brightness = LED_OFF;
>  
> -		ret = gpio_request(led_dat->gpio, led_dat->cdev.name);
> -		if (ret < 0)
> -			goto err;
> -
>  		gpio_direction_output(led_dat->gpio, led_dat->active_low);
>  
>  		INIT_WORK(&led_dat->work, gpio_led_work);
> -- 
> 1.5.4.1
> 


