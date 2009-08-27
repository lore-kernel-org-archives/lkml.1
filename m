Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZH0V7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZH0V7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZH0V7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:59:16 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:27891 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753152AbZH0V7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:59:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 17:59:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LIpcF/7mvdEwl9acNOSCT5lz6OCvvmOVG0pDMSZcOIqxZPwbxnzg+v0F2P88h/9XbX1/FHuQBD5D8X/Pwsd4Vf3kEfCUDkF9CMSPfgZg9abnfPMRR2zvLK2ChijOrSsCEuMF2BTx+VNWfYc8NySTO+5RGCcg/meLGa7ptC6670Y=  ;
X-YMail-OSG: jHRg3b8VM1nWfTxVOAg5UgO6UocSLq7Ht4wiIRfCtHPY0Yb_Qqgcz.aNmKemVht7.xFlpf.mAAMI6187lIE6xy4MG95E_0wHsCc6jMtI7dCxUTS_gQHhYTVL1P4_0mt7EB6QMZBZUH0TvWYID_o17DUWKeqqEC5hzoTP9h4xhhU.18R2RttBEwibp_jR_2LHcAr6Ksi26quX_Sw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] rtc: Set wakeup capability for I2C and SPI RTC drivers
Date: Thu, 27 Aug 2009 14:52:36 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>,
       Jean Delvare <khali@linux-fr.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20090827182207.GA7358@oksana.dev.rtsoft.ru>
In-Reply-To: <20090827182207.GA7358@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908271452.37358.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK; see details below

On Thursday 27 August 2009, Anton Vorontsov wrote:
> RTC core won't allow wakeup alarms to be set if RTC devices' parent
> (i.e. i2c_client or spi_device) isn't wakeup capable.

Quite rightly so ... being wakeup-capable is config-specific.


> For I2C devices there is I2C_CLIENT_WAKE flag exists that we can pass
> via board info, and if set, I2C core will initialize wakeup capability.
> For SPI devices there is no such flag at all.

So why not add it for SPI?  If it's an issue, it's not
unique to RTC devices.

 
> I believe that it's not platform code responsibility to allow or
> disallow wakeups, instead, drivers themselves should set the capability
> if a device can trigger wakeups.

Drivers can't generally know if that's possible though.
They need to be told that it is, by platform code.

Most devices can't issue wakeup events.

 
> That's what drivers/base/power/sysfs.c says:
> 
>  * It is the responsibility of device drivers to enable (or disable)
>  * wakeup signaling as part of changing device power states, respecting
>  * the policy choices provided through the driver model.
> 
> I2C and SPI RTC devices send wakeup events via interrupt lines, so we
> should set the wakeup capability if IRQ is routed.

Re-read the quoted sentence.  You're saying that policy
choices should be hard-wired into the driver; contrary
to that quote.  (In this case the choice is one that
platform code must report, and which the hardware
designer made:  if the device can issue wakeup events.)  


> Ideally we should also check irq for wakeup capability before setting
> device's capability, i.e.
> 
> 	if (can_irq_wake(irq))
> 		device_set_wakeup_capable(&client->dev, 1);
> 
> But there is no can_irq_wake() call exist, and it is not that trivial
> to implement it for all interrupts controllers and complex/cascaded
> setups.

That is why platform code should device_init_wakeup() and
drivers should check device_can_wakeup(dev) ...


> drivers/base/power/sysfs.c also covers these cases:
> 
>  * Devices may not be able to generate wakeup events from all power
>  * states.  Also, the events may be ignored in some configurations;
>  * for example, they might need help from other devices that aren't
>  * active
> 
> So there is no guarantee that wakeup will actually work, 

Yes there is ... it's only **exceptional** cases where it can't
work.  Your patch would make it routine that those flags be
unreliable; pretty nasty.

