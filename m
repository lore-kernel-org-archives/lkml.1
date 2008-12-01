Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYLAXJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYLAXJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 18:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYLAXJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 18:09:44 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:29003 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbYLAXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 18:09:43 -0500
Message-ID: <49346E8E.9050707@call-direct.com.au>
Date: Tue, 02 Dec 2008 10:09:02 +1100
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: mengsanshui@yahoo.com.cn
CC: linux-kernel@vger.kernel.org
Subject: Re: I want to know how to write a lcd driver with spi interface
References: <173589.37422.qm@web15703.mail.cnb.yahoo.com>
In-Reply-To: <173589.37422.qm@web15703.mail.cnb.yahoo.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peter meng wrote:
> 1. I want to know how to write a lcd driver with spi interface on
>   linux(2.6.24) ? I'm using a tft-lcd(FT-G128160UTSW-123W-E  vendor --TRULY)
>   with  s6d0151(IC) that connected to s3c2412 with spi    .
>   interface : SDI --> GPG6  WR-->GPG7 CSB -->GPG3 RS-->GPB1 RESET -->GPB2 )
> 
> 2.How the framebuffer related with spi interface ? I mean how the
>   framebuffer know it transfer the data with spi interfcae not the
>   RGB/80-System interface.

The main difference is that a framebuffer is memory mapped, whereas an SPI
connected display is more suitable for a function call abstraction. The two don't
relate very well.

Your SPI display has an internal frame buffer, which you can access via SPI,
but cannot memory map. A function call interface would easily map to the
SPI transfer, but requires applications written for such an API.

If you absolutely have to use a framebuffer abstraction, you can create a fake
framebuffer in RAM. Now, you have to solve the problem of keeping the display's
framebuffer in sync with the RAM one.

The simplest approach is to have a kernel timer fire a few times per second
and transfer the whole RAM fb via SPI every time. The faster you refresh, the
better the synchronisation, but you'll hit CPU or SPI bus limits eventually. It
also causes image artefacts with fast updating content, e.g. video.

If your CPU+RAM is much faster than SPI, it might be beneficial to detect
which part of the display was changed and only update that stripe/rectangle.

In practice, it is best to use a combination of methods. Have a timer based
update for most GUI-type applications and then modify the more demanding
applications to control the refresh directly, for instance through a IOCTL.

If your applications use a graphics library on top of the framebuffer (e.g. QTE),
you may be able to add synchronisation calls into that library, for better
efficiency.

One more avenue to look at is to use the MMU for synchronisation. That is,
you map the RAM fb as read only, such that if an application writes to it, it triggers
an exception. In the exception handler you remap the memory as read/write,
execute the write, update the display and remap r/o. This would be very inefficient,
so you may want to leave the memory mapped r/w and start a timer to collect a
number of changes before mapping r/o again.

The best method very much depends on your use case, applications, relative
speeds of CPU and SPI, size of display, etc.

> 
> 3. Where i can get the example driver on linux ?
A well documented framebuffer skeleton:  drivers/video/skeletonfb.c
A RAM-based framebuffer: drivers/video/vfb.c
A simple SPI driver (EEPROM): drivers/spi/at25.c

Kind regards,

Iwo


