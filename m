Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbZE0SGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbZE0SGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZE0SGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:06:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44603 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761061AbZE0SGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:06:21 -0400
Date: Wed, 27 May 2009 18:56:09 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Scott Wood <scottwood@freescale.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527175609.GB31861@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D6901.2090508@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 11:23:29AM -0500, Scott Wood wrote:
> That removes the ability to use the device tree to pass information from  
> the bootloader, such as MAC addresses and clock frequencies.  On the  
> u-boot list, you'll find people trying such hacks (which were rightly  
> NACKed) as passing the information in the device's volatile registers  
> (which the Linux driver must then not reset) to deal with ARM Linux's  
> lack of this ability.

No one has brought that up on the ARM mailing lists - so does this issue
really exist?  All of the stuff I see on the ARM lists seems to be well
behaved and following our existing model - even vendor stuff (supplied
to me under NDA) seems to generally get this kind of stuff right.

Basically, what I'm saying is that I have seen no evidence to support
the argument you're making, but I'm not saying you're wrong or that it
doesn't happen.

>>  Robert> - The oftree layering is fundamentally broken. We already
>>  Robert> have a sane abstraction for arbitrary hardware in the kernel:
>>  Robert> platform devices.  Why not instanciate platform devices from
>>  Robert> a generic oftree core?
>
> You can, if you want.  But you'll need extra glue code that understands  
> the individual bindings.  IMHO that logic is usually better off in the  
> driver itself, but if you really need platform code to involve itself in  
> some way (such as providing callbacks), then exceptions can be made.

No it is not.  Device drivers are best written to support devices, and
the platform specific code should not be anywhere near them.  Platform
specific code to handle oddities of platforms should be totally separate
from the device driver itself.

For example, see the mess that is cs89x0, which isn't a platform driver
(or any kind of driver model driver).  It's full of individual platform
specific hacks to make it work on platforms X, Y and Z.  The same was
true of the smc91x driver (which is a platform driver but wasn't done
in a generic way.)  smc91x was very quickly becoming a big problem to
maintain and use because of all the platform specific junk being shoe-
horned into the driver.  smc91x eventually got fixed.  cs89x0 hasn't.

smc91x is a prime example of the kind of information drivers need - base
address and irq are very much insufficient to describe how this device is
connected.  There's much more information required to specify this device
fully, and throwing it into the driver doesn't work.  We've been there
and proven that point.

So, repeat this mantra: device drivers should contain no platform specifics.
Platform specifics should be separated from the driver and implemented by
platform support code.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
