Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYFLG20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYFLG20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYFLG2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:28:17 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22645 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752476AbYFLG2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:28:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EJAONvM2lmVBijZn5bV+1BSCoZS0H4KwFvzb2r90/riesBE0i+K1onAVRhbmkgndniUykzvvm66Qc5JdenuFO1TGtm9JtThm8h9zKTo5rryL9s/02EH7INikAOZntAsSpwVthlq2j7+1seFFyT7WQmEX/dXziAI6KKVjMxiIIvw=  ;
X-YMail-OSG: n4JGkNwVM1mvf5p3hsQYGG8pEGC_X0ghN_3DHZXBQ1qHDJklwVDZjLLHHbKFXKh_tCqFcvLyDM7LXrowudItQxuXsZQkKy1Au.Z13gqGJivC40B3pQUFVnm3AOJgEiSHOvgr945Rrks5RKBZ_tA1CnmN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [WARNING] local_bh_enable with irqs disabled:
Date: Wed, 11 Jun 2008 23:28:14 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806031529520.21106@axis700.grange> <Pine.LNX.4.64.0806060751240.14536@axis700.grange> <200806101715.52830.david-b@pacbell.net>
In-Reply-To: <200806101715.52830.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112328.14814.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008, David Brownell wrote:
> On Thursday 05 June 2008, Guennadi Liakhovetski wrote:
> > Sorry, this was a 2.6.26-rc3 based kernel with the gpio-sysfs patch from 
> > David, e.g., http://marc.info/?l=linux-kernel&m=121107105300923&w=2,
> > which introduces a call to device_unregister via gpiochip_unexport(chip); 
> > in gpiochip_remove. 
> 
> Right.  Obviously that wasn't tested with "rmmod" of a modular
> GPIO expander ... I only have one board which supports such an
> expander right now, and it's not been in use recently.
> 
> A fix is obvious; any problems with what's below?

I verified it works for me on that one board ... after I removed
the board hooks that actually *use* those GPIOs (which prevent an
rmmod) and just use it from sysfs.  The missing test case has now
been covered.

I'll send an updated patch.

- Dave


> 
> - Dave
> 
> 
> --- g26.orig/drivers/gpio/gpiolib.c	2008-06-10 16:56:01.000000000 -0700
> +++ g26/drivers/gpio/gpiolib.c	2008-06-10 16:55:39.000000000 -0700
> @@ -726,12 +726,15 @@ int gpiochip_remove(struct gpio_chip *ch
>  		}
>  	}
>  	if (status == 0) {
> -		gpiochip_unexport(chip);
>  		for (id = chip->base; id < chip->base + chip->ngpio; id++)
>  			gpio_desc[id].chip = NULL;
>  	}
>  
>  	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	if (status == 0)
> +		gpiochip_unexport(chip);
> +
>  	return status;
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_remove);
> 
> 


