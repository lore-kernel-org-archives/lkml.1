Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZBIFxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZBIFxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZBIFxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:53:33 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:24933 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751141AbZBIFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:53:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pzD6efopJtXuKpbl1k4bwT8Dazkcku/TtKFh9R7FIfvwXUlChM1tRoZ31Hfnpuo3OcYDch7Jxoi7GyahxovMU8LGwdsweo0sdb50wJz539VUW5P3cf03SMxRgTpqBzn438rqrp0HkymQS2mZwGQooyHL/LjtjE4i655X2xVySGk=  ;
X-YMail-OSG: NGbx9eAVM1lXgTnRWTjUY5.ItOi2fK8UnPqogdPyezkM5V5eox27lvLocrc8XpZ74r48lnJPBfBqj0ryhRU8Sj.BtQZTYS17AG5mUME79sUPF_6PQDZkmjXgYCe6rA0DlZI2dUDmeiC6LqqXhOaLSVWa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Joonyoung Shim <dofmind@gmail.com>
Subject: Re: [PATCH] OMAP3 GPIO: Fix getting the value of the GPIO output pin
Date: Sun, 8 Feb 2009 21:53:30 -0800
User-Agent: KMail/1.9.10
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       kyungmin.park@samsung.com
References: <4e1455be0902062015i1ff94b28p93588e61b7860618@mail.gmail.com> <200902082011.36500.david-b@pacbell.net> <4e1455be0902082129i2c038477g886c8de03d3073dd@mail.gmail.com>
In-Reply-To: <4e1455be0902082129i2c038477g886c8de03d3073dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902082153.30479.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Joonyoung Shim wrote:
> > Which should clearly be AE6_34XX_GPIO141_OUT since it does
> > not enable the input driver.  Try making that ...PIN_OUTPUT
> > read ...PIN_INPUT and see if things behave.
> 
> Of course, it will be better if the name is clear as AE6_34XX_GPIO141_OUT.
> but, the core of this problem is not it, the chip->get() called in
> gpiolib_dbg_show()
> of drivers/gpio/gpiolib.c or dbg_gpio_show() of arch/arm/plat-omap/gpio.c
> can return the wrong value when gpio pin is configured as an output.

No, the core of the problem is that you're using a GPIO
which is explicitly configured as output-only ... but are
treating it as if it were a normal bi-directional GPIO.

It's acting *exactly* right for an output-only GPIO.  But
that's not the behavior you expect, or want.

If you weren't disabling the input driver, then when you
ask for the input value it would work as you expect.  Which
is why I suggested you change how that ball is configured.
(That's actually a bugfix to those muxing tables ...)

- Dave

p.s. This specific confusion is new on OMAP3; previous
     OMAPs didn't have the extra byte of options to
     configure.  The PIN_INPUT flag was, on previous
     chips, effectively hard-wired on for GPIOs.
