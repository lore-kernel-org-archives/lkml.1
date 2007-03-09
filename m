Return-Path: <linux-kernel-owner+w=401wt.eu-S1767537AbXCIVSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767537AbXCIVSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993145AbXCIVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:18:03 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:38694 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993144AbXCIVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:18:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j5DN2mEMb12tNx1fV37AnCjAvf1QZnO0nAs9eyBGNUuhh4Qot1aC7BUadhRSvyXQexUUd9dDHzLeihDSwWa5oO7Z/T5YFqgtdFgsdhZmAiZSHnw3xE28iNnUQU7Xuvtb57SomEIDQTbdis0T87jKRbPHa3OfN9dP9MlQLkgfYEo=  ;
X-YMail-OSG: klYyDZAVM1lecnHZzz7LSUY_0BT1FP0DlQTJiF4j4L.9Xfj1gaq..324g.2lSJaNxuA7paIGMwF89bolUpd8WGLe.IicXJ3kJ9g3sYKfq2p.pE1hNcru5UFPC2jMhI6K.nQniYPPBKVpzmw-
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
Date: Fri, 9 Mar 2007 13:17:56 -0800
User-Agent: KMail/1.7.1
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703090945.38880.david-b@pacbell.net> <200703091130.13547.david-b@pacbell.net> <20070309200850.GA8444@flint.arm.linux.org.uk>
In-Reply-To: <20070309200850.GA8444@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200703091317.58178.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 12:08 pm, Russell King wrote:
> On Fri, Mar 09, 2007 at 11:30:12AM -0800, David Brownell wrote:
> > On Friday 09 March 2007 10:48 am, Haavard Skinnemoen wrote:
> > > This is a very simple bitbanging i2c bus driver utilizing the new
> > > arch-neutral GPIO API. Useful for chips that don't have a built-in
> > > i2c controller, additional i2c busses, or testing purposes.
> > 
> > That's the right idea!  But remember that not all GPIOs support
> > reading back the actual value on SCL (it's an OUT pin, so lacking
> > multidrive capability the values "should" be what you wrote), so
> > getscl() support should depend on a flag in platform data.  In
> > the same vein, if SCL is an output-only pin, you won't be able
> > to change its direction ... but then, I'm not sure why you were
> > changing its direction in setscl() rather than just its value.
> 
> That's a more correct I2C implementation.  If you read the specs, the
> SDA and SCL signals are supposed to be driven by open-collector or
> open-drain drivers, such that devices only pull the bus low.  Pull-up
> resistors pull the signals high when undriven.

Exactly as I had mentioned:

> > I2C has another interesting special case.  at91_set_multi_drive()
> > would be appropriate (yes?) for ARCH_AT91 to use on SCL, to best
> > support both clock stretching and multi-master configurations.

Where "multi-drive" == open-drain.  You're saying it should also be
used on SDA too ... OK, I was focussing on clock stretching but it
applies there too.

 
> This avoids the possibility of damage caused when one device drives
> a signal low and another device tries to drive it high.
> 
> Therefore, the correct I2C GPIO implementation is one where you drive
> both SDA and SCL low by using a combination of the data direction
> register and the output level register, but avoid driving the output
> high.

I see your point -- it does answer my question -- but you seem to have
overlooked a highly relevant one of mine.  :)

Regardless, those nuances should be captured in comments in that
driver:  that for GPIOs that don't support open drain output (only
push/pull drivers), that it's faked by otherwise-unnecessary
tweaking of GPIO direction.

- Dave

