Return-Path: <linux-kernel-owner+w=401wt.eu-S938226AbXFHIs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938226AbXFHIs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937049AbXFHIsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:48:20 -0400
Received: from mta-ps-be-03.sunrise.ch ([194.158.229.25]:38336 "EHLO
	mail-ps.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935571AbXFHIsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:48:19 -0400
From: Robin Farine <robin.farine@terminus.org>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] LEDS: generic driver
Date: Fri, 8 Jun 2007 10:48:04 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <ab8cd0edce36b4ea93429c7ab695f5a967b11365.1181149111.git.robin.farine@terminus.org> <200706061902.06738.robin.farine@terminus.org> <1181258872.30600.12.camel@localhost.localdomain>
In-Reply-To: <1181258872.30600.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081048.05001.robin.farine@terminus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 8 2007 01:27, Richard Purdie wrote:

> I'm not sure about this to be honest. I can see a case for
> perhaps having a couple of standard suspend/resume functions for
> platform device based LED drivers as those functions are often
> identical. I'm not sure whether there is going to be much need
> for more than that.

I am not persuaded either. To give a better idea of the context, my 
platform has to sets of LEDs, a first attached to a write-only 
register on the extension bus and the second on an optional 
daughter board and I2C controlled. The value of the register on the 
extension bus is shadowed and needs to be manipulated through an 
API that takes care of the locking.

Thus, instead of adding new board specific drivers to drivers/leds, 
my idea was that given a generic LED driver:

- the module that implements accesses to the write-only register 
defines one platform device for each LED attached to the register 
and implements the LED toggling internally;

- the I2C driver for the daughter board defines one platform device 
for each LED on the daughter board and implement the LED toggling 
internally as well.

> Having looked through a few of the LED drivers, even the
> suspend/resume functions are often different...

I looked at this too and it seemed to me that in all but one case 
the suspend function ends up by calling led_classdev_suspend for 
each LED the driver controls, and the resume function calls 
led_classdev_resume for each LED as well. In the generic LED 
driver, it is equivalent since there is a different platform device 
for each LED so only one call to led_classdev_xyz is needed.

> >From a style point of view, why not
> > s/pdev_to_led/platform_get_drvdata/?

Yes, of course :-).

> What are your thoughts on multiple LEDs on a single device?

Physically that is what I have on my platform, but the system sees 
each LED as a separate device. The platform device data and 
function for a set of LEDS attached to the same physical device 
take care of the multiplexing.

> Given the LED class is going to get a conversion to struct device
> soon, I'd prefer to put this on hold until after I've made that
> conversion at which point I'll reconsider this.

Yes, sure. I am well aware that it applies to very specific 
situations and that there may be a cleaner solution in which case I 
would be happy to drop this idea. I am not pushing for this to be 
included in mainline.

Thanks for looking into this and for the feed-back,

Robin
