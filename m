Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYL3AnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYL3AnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYL3AnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:43:09 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:29720 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751709AbYL3AnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:43:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=C9uvOolYd+b/j/vW+FbLE4vGksHFarHKViiQ3M+Vi1vMxk2Z5u11i8ngqZM2He08cP5thquFAryykYFhiUqFvbGABfVbgH/5RppQTGVGf+7vxmIAerGNOPV7GWxBOJyXvFwT/2y1qSU2g5A203brCJn5KS92TKLFxueVHkTARLw=  ;
X-YMail-OSG: 5A2peL0VM1kldMaGiYrv562RUqTIY.2LEoBbq9M90iMyC5jXmgljlr2yCZ1sruIO2Iy6b7xeKicnOq79JG9fUofPexF9Aw3V95xMB97EMSqvNYk4iZReiClu.XVBfbRIkVamukwOiT5_fx6UegmK5e8kHwadkDIDYAyuPMWP.YgJ6ULFzMaM3f9IWRPX
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 16:43:03 -0800
User-Agent: KMail/1.9.10
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200812291156.12230.david-b@pacbell.net> <20081230002023.GA5309@shareable.org>
In-Reply-To: <20081230002023.GA5309@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291643.03798.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, Jamie Lokier wrote:
> David Brownell wrote:
> > The reason single-bit operations don't provide error paths is twofold.
> > First, they started as wrappers for can't-fail register accessors.
> > Second, it's extremely unrealisitic to expect much code to handle any
> > kind of faults in the middle of bitbanging loops ... or even just in
> > classic "set this bit and continue" configuration code.
> 
> That's interesting.  I'm not sure it's a good idea not to return an
> error code.  The caller can just ignore it if they don't care, and
> it's extremely cheap to "return 0" in GPIO drivers which can't error.

I'm not sure either; at this point I *might* consider doing
it differently -- but primarily for the case of external GPIO
chips, e.g. over I2C or SPI -- where errors are realistic.  But
it's been this way for a few years now, and changing stuff
that hasn't been observed to be a problem isn't on my list.

But as I noted:  patches for $SUBJECT don't seem to have any
reason not to report whatever faults they encounter.

Also worth remembering:  when reading a GPIO value, it's not
so easy to "ignore" a tristate (0, 1, error) return value.

 
> If I were bit-banging on GPIOs reached via some peripheral chip (such
> a GPIO-fanout chip over I2C/SPI, where that chip is itself feeding a
> secondary I2C or similar bit-banging bus), I probably would like to
> check for errors and take emergency action if the peripheral chip
> isn't responding, or just report to userspace.

If I had to do that, I'd *certainly* want to bang the hardware
designer over the head with some sort of cluebat or cluebrick.  :(


> This has actually happened on a board I worked with, where the primary
> I2C failed due to a plugged in peripheral loading it too much, and a
> secondary bit-banging bus was not then reachable.

It should now be realistic for I2C device drivers to have
fault recovery logic...

But for a long time, I2c only returned -EPERM so it was
completely hopeless trying to figure out how to "handle"
any problem beyond logging the problem and hoping someone
is watching syslog output.  That's a big part of why most
current I2C drivers have such unfriendly fault handling.

- Dave



> 
> -- Jamie
> 
> 


