Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbYDVW0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbYDVW0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbYDVW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:26:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933370AbYDVW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:26:20 -0400
Date: Tue, 22 Apr 2008 15:25:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <20080422221733.GA16260@havoc.gtf.org>
Message-ID: <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jeff Garzik wrote:
>
> diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
> index 5235f64..28726ee 100644
> --- a/arch/arm/mach-integrator/time.c
> +++ b/arch/arm/mach-integrator/time.c
> @@ -137,7 +137,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
>  	return 0;
>  
>   irq_out:
> -	free_irq(dev->irq[0], dev);
> +	free_irq(dev->irq[0], NULL);
>   map_out:
>  	iounmap(rtc_base);
>  	rtc_base = NULL;
> @@ -153,7 +153,7 @@ static int rtc_remove(struct amba_device *dev)
>  
>  	writel(0, rtc_base + RTC_CR);
>  
> -	free_irq(dev->irq[0], dev);
> +	free_irq(dev->irq[0], NULL);
>  	unregister_rtc(&rtc_ops);
>  
>  	iounmap(rtc_base);

Quite frankly, I'd actually prefer to just reinstate "dev" to the irq 
registration instead.

Why? Because that field is how we are able to track multiple interrupt 
registrations that share an IRQ. Now, the "request_irq()" logic has a 
special rule that actually tests that NULL is a valid cookie if the 
IRQF_SHARED bit isn't set, but isn't it a nice thing to double-check 
regardless?



> index 37fe80d..5681c01 100644
> --- a/drivers/char/mwave/tp3780i.c
> +++ b/drivers/char/mwave/tp3780i.c
> @@ -274,7 +274,8 @@ int tp3780I_ReleaseResources(THINKPAD_BD_DATA * pBDData)
>  	release_region(pSettings->usDspBaseIO & (~3), 16);
>  
>  	if (pSettings->bInterruptClaimed) {
> -		free_irq(pSettings->usDspIrq, NULL);
> +		free_irq(pSettings->usDspIrq,
> +			 (void *)(unsigned long) pSettings->usDspIrq);

This, in contrast, *really* sucks as a cookie. In fact, it's useless. If 
there are multiple tp3780i instances on the same irq, they will always 
have the same cookie.

That's why we pass in a "device" pointer or similar - exactly to make sure 
that the cookie is unique for that irq resource!

So it would be much nicer to fix the cookie to be a real device pointer 
(why not "pSettings" itself?) that is stable across the whole series of 
request_irq/free_irq. And that also would tend to get rid of the 
butt-ugly casts.

Willing to fix those up?

		Linus
