Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXK3U7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXK3U7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXK3U71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:59:27 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:28365 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752338AbXK3U70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:59:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BSTwO8bSqvCGMJXfPnndC256nSNG4t+RFvhzp4TEmZryO442oO4POM+5E2ab3H0qRjYFYK/eRm61MoD6rJS1IJFgx+v2nBqKS/b8qrILKMGn+/k9prmfVtlxYKxK5/68cnvpc85RYC6dgtnj3wolvNThIR6AHrDpAJwhTtlzgiY=  ;
X-YMail-OSG: gUpjXIMVM1mzY7y16JufclBRWUiJov83WaPQzVK3MGhCt8O.FeAHApiy0HNGxoODsPojzS.L6w--
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
Date: Fri, 30 Nov 2007 12:59:21 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       "eric miao" <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711301040.54777.david-b@pacbell.net> <20071130211332.49a21a6b@hyperion.delvare>
In-Reply-To: <20071130211332.49a21a6b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301259.22666.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007, Jean Delvare wrote:
>
> So the user-space interface would be part of the generic GPIO
> infrastructure? I like the idea.

I thought that would make sense too! :)  Someone would need to
write the code though.  Having such a mechanism would provide
another "carrot" to migrate folk towards the gpiolib core.

I think adding a gpiochip primitive to mark a (potential) GPIO
as invalid would support the converse of /sys/kernel/debug/gpio.
Invalid GPIOs include pins set up for non-GPIO usage (like being
used for MMC or MII), or not wired up on a given board.  Pins
that were valid as GPIOs and not requested by a kernel driver
might reasonably be managed by userspace code.


> > > > +#include <linux/pcf857x.h>
> > > 
> > > I suspect that there will be many more such header files in the future.
> > > Would it make sense to move them to include/linux/gpio?
> > 
> > I was thinking more like <linux/i2c/...> myself.  There are many more
> > I2C chips than GPIO expanders.
> 
> But most i2c chip drivers don't need a header file. Or is this going to
> change with the new-style i2c drivers?

I expect it will become a lot more common.  Remember that legacy
I2C drivers *couldn't* get any board-specific config data; that's
been problematic, since it meant the drivers themselves ended up
with lots of board-specific cruft.   That prevented many drivers
from going upstream at all.  (As I mentioned about pcf8574 code,
although in that case the problem was worsened by lack of any
reusable kernel interface for such GPIO signals.)


> Along the same line, I am wondering if it would make sense to put the
> various GPIO drivers in drivers/gpio.

Could be.  Right now we have three "GPIO expander" drivers using
the new "gpiolib" framework:  pcf875x and pca9539 for I2C, and
mcp23s08 for SPI.  There are many more that *could* be used with
Linux boxes.  And there are other drivers/XYZ directories that
are (currently) that small.  Maybe gpiolib should go upstream
like that, and lib/gpiolib should be in drivers/gpio too...

However, keep in mind that lots of chips export a few GPIOs but
don't have that as their core functionality ... one example is
the drivers/i2c/chips/tps65010 driver.  So it'd never be the
case that GPIO drivers only live in that directory.

- Dave
