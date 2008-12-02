Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYLBDk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYLBDk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYLBDkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:40:18 -0500
Received: from web15702.mail.cnb.yahoo.com ([202.165.102.69]:27320 "HELO
	web15702.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751388AbYLBDkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:40:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=MYHBdryrLj13u3FB3lvlb+2eFpTHUiqiNx4T1eT++l63xSOkMgUF1RF8bZ7i0Wz/TFi67OZ5U95zYkGHPOciMVwDincJ29lhYWDFrs7jRH9f7oQ87hNQeQWE5/Fk1XcOjyxKKvE1ulRm3qne97xh8g2Mmx1OIu6kReZZFcumnII=;
X-YMail-OSG: 8i8x5AEVM1mSkB76IygzE5k6h6QzR0R7LEZA5rcrOZCcvtbijwQvIs2Q5X3Nc9ItnnF9ezEYPWLEivOcUPMyniiUCx4gC4zPDo3g2RXA0onWSDok3aH7z2zurIyBetgRGC9RlsqGWsBerESOgThtEqG2GfXLeYEucLP91YP.yHVY2nM-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 2 Dec 2008 11:40:14 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: Re: I want to know how to write a lcd driver with spi interface
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49346E8E.9050707@call-direct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <648837.22167.qm@web15702.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Iwo

Thank you very mach .
I'm a newbie on video driver .
Could you recommended the lcd driver that already use spi interface on Linux  to me ?
I want to emulate it .


Best Regards
Peter 


--- On Tue, 12/2/08, Iwo Mergler <iwo@call-direct.com.au> wrote:

> From: Iwo Mergler <iwo@call-direct.com.au>
> Subject: Re: I want to know how to write a lcd driver with spi interface
> To: mengsanshui@yahoo.com.cn
> Cc: linux-kernel@vger.kernel.org
> Date: Tuesday, December 2, 2008, 7:09 AM
> peter meng wrote:
> > 1. I want to know how to write a lcd driver with spi
> interface on
> >   linux(2.6.24) ? I'm using a
> tft-lcd(FT-G128160UTSW-123W-E  vendor --TRULY)
> >   with  s6d0151(IC) that connected to s3c2412 with spi
>    .
> >   interface : SDI --> GPG6  WR-->GPG7 CSB
> -->GPG3 RS-->GPB1 RESET -->GPB2 )
> > 
> > 2.How the framebuffer related with spi interface ? I
> mean how the
> >   framebuffer know it transfer the data with spi
> interfcae not the
> >   RGB/80-System interface.
> 
> The main difference is that a framebuffer is memory mapped,
> whereas an SPI
> connected display is more suitable for a function call
> abstraction. The two don't
> relate very well.
> 
> Your SPI display has an internal frame buffer, which you
> can access via SPI,
> but cannot memory map. A function call interface would
> easily map to the
> SPI transfer, but requires applications written for such an
> API.
> 
> If you absolutely have to use a framebuffer abstraction,
> you can create a fake
> framebuffer in RAM. Now, you have to solve the problem of
> keeping the display's
> framebuffer in sync with the RAM one.
> 
> The simplest approach is to have a kernel timer fire a few
> times per second
> and transfer the whole RAM fb via SPI every time. The
> faster you refresh, the
> better the synchronisation, but you'll hit CPU or SPI
> bus limits eventually. It
> also causes image artefacts with fast updating content,
> e.g. video.
> 
> If your CPU+RAM is much faster than SPI, it might be
> beneficial to detect
> which part of the display was changed and only update that
> stripe/rectangle.
> 
> In practice, it is best to use a combination of methods.
> Have a timer based
> update for most GUI-type applications and then modify the
> more demanding
> applications to control the refresh directly, for instance
> through a IOCTL.
> 
> If your applications use a graphics library on top of the
> framebuffer (e.g. QTE),
> you may be able to add synchronisation calls into that
> library, for better
> efficiency.
> 
> One more avenue to look at is to use the MMU for
> synchronisation. That is,
> you map the RAM fb as read only, such that if an
> application writes to it, it triggers
> an exception. In the exception handler you remap the memory
> as read/write,
> execute the write, update the display and remap r/o. This
> would be very inefficient,
> so you may want to leave the memory mapped r/w and start a
> timer to collect a
> number of changes before mapping r/o again.
> 
> The best method very much depends on your use case,
> applications, relative
> speeds of CPU and SPI, size of display, etc.
> 
> > 
> > 3. Where i can get the example driver on linux ?
> A well documented framebuffer skeleton: 
> drivers/video/skeletonfb.c
> A RAM-based framebuffer: drivers/video/vfb.c
> A simple SPI driver (EEPROM): drivers/spi/at25.c
> 
> Kind regards,
> 
> Iwo


      
