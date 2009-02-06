Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZBFAQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZBFAQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZBFAQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:16:05 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48924 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757253AbZBFAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:16:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H3e2B+FuoBV16MQBOfuNYLOy5KX0ZSCalsgeEoLcOQRvDt8z/jcbMsa89adZf/qNklGWJVFSWf8DgXLfJFWVO3J2TOgBccVVfnqofL9A+wE3UQ+uhjTyF6k9URS8uM1HIJ+8vCyKqgQqcjmr//SNTlikWiIqmPrwjT/WaD3R5qY=  ;
X-YMail-OSG: nCegNFUVM1mVKZYtBHpgYsv.zU9aZcGUMJlExjANzbDL.e5W8ScoTtOdZpPJGRZE2JTL_vlrGiZW7mQ_DnQGgESreE_XKgYJSD7A1h9LpFnF3L_GP_NKPjjCwIeLvkBJBAK061x0SSTCFNKaY760M9oEe5xzYIbGhtEuuM2iWNNrxGQ3O_e5ndIfSpF8
X-Yahoo-Newman-Property: ymail-5
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <azummo-lists@towertech.it>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Date: Thu, 5 Feb 2009 16:12:20 -0800
User-Agent: KMail/1.9.10
Cc: jordan@cosmicpenguin.net, linux-geode@lists.infradead.org,
       dilinger@queued.net, dsaxena@laptop.org,
       "=?iso-8859-1?q?Martin-=C9ric?= Racine" <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
In-Reply-To: <20090205161007.4d121cbf@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051612.20475.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Alessandro Zummo wrote:
> --- linux-2.6.28.orig/arch/x86/Kconfig	2009-02-03 19:38:43.000000000 +0100
> +++ linux-2.6.28/arch/x86/Kconfig	2009-02-03 20:15:25.000000000 +0100
> @@ -1911,6 +1911,16 @@ config GEODE_MFGPT_TIMER
>  	  MFGPTs have a better resolution and max interval than the
>  	  generic PIT, and are suitable for use as high-res timers.
>  
> +config GEODE_GPIO
> +	bool "Geode GPIO support"
> +	depends on MGEODE_LX && !CS5535_GPIO

and also GPIOLIB ... maybe can you just "select GPIOLIB".


> +	default n
> +	help


> +static int cs5535_direction_output(struct gpio_chip *chip, unsigned offset,
> +					int value)
> +{
> +	cs5535_gpio_set(chip, offset, value);
> +
> +	geode_gpio_set(geode_gpio(offset), GPIO_OUTPUT_ENABLE);
> +	geode_gpio_clear(geode_gpio(offset), GPIO_INPUT_ENABLE);

Unless this hardware misbehaves when both output and input
modes are enabled (e.g. in the window between those two calls),
I'd suggest just not clearing INPUT_ENABLE.  It's legit to
ask for the *actual* value of an output line, e.g. for when
it uses open drain mode.  (And didn't this hardware have an
option for open drain GPIO signaling?)


Otherwise this has about the right shape for platform GPIOs.

- Dave
