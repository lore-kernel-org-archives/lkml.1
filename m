Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXDMGGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXDMGGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXDMGGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:06:49 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:45739 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751750AbXDMGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:06:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jLtkqwfydJhIixGaimI1DYoVvGzuDV+lMXjKpmCZSOz7NtfFXIaCOY+71gUHBtXJlhH7gY3cPJKdx1CWfdYE5coWWuocQpmMGmNM4dbfI383m9xCloFeARYm3MMMX0qZAK4wTQeBQ9ft2JIULUGHXE8G08EUpZXIhqAYiaZpP5Q=  ;
X-YMail-OSG: .4afU3sVM1liWgneTAGVk2Zumqykf26DhCP_mYEaa6dQk9CxhQPltKdV4zSRQ.TXU_ktUq2wcQ_TRNiLVDrZI8y8V.si1wVS7YDEMngjcNRLkGlg7HU-
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Date: Thu, 12 Apr 2007 23:06:46 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122306.46518.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This driver used to stop code/logic duplication through different
> machines we porting at handhelds.org. pda_power register machs' power
> supplies, and will take care about notifying batteries about power
> changes through external power interface.

It gets USB power management wrong though.  Have a look at two I2C drivers
in drivers/i2c/chips:  tps65010.c (which would talk to this API) and then
isp1301_omap.c (which would talk to the tps65010 driver).  The tps65010
chip accepts the same two power sources you're addressing here, as part
of its battery charging responsibilities. [1]

Key points:

 - The API needs to say *how much power* can be drawn.  Common values
   are 8 mA (OTG peripherals before configuration), 100 mA (non-OTG ones
   before configuration), 500 mA (high power configurations) ... but the
   exact value depends on what's listed in the configuration descriptor
   for the chosen configuration, any value 0..500 mA (increments of two)
   could be appropriate.

 - Sensing VBUS power is not the same thing as being allowed to consume
   it.  Again, USB OTG devices are different:  OTG hosts **SUPPLY** the
   current, so you really don't want to be telling the OTG transceiver to
   fire up its charge pump (say, 3.0V VBAT converted to 5V VBUS) while at
   the same time telling the battery manager to use that battery-derived
   VBUS current to recharge its battery!  Not only would that waste power,
   but it also deprives the peripheral of the power it needs to draw.

In general, no component other than the USB peripheral (or host) controller
driver has any business trying to control how VBUS power is used.  It's
likely to get it wrong ... as shown by this patch.  ;)

And that's exactly why the USB gadget API has had calls to manage the USB
power consumption since mid-2004.  And I wonder why H5000 code evidently
doesn't implement those calls.

- Dave

[1] You may find http://www.linux-usb.org/gadget/h2-otg.html useful too.
    It gives a high level map of the complicated OTG case, including
    those drivers, and points out how simpler peripheral-only systems
    could behave with the same drivers.  However it does turn out to
    be useful if USB peripheral drivers have a "transciever" notion
    that can receive "VBUS present" interrupts, letting the peripheral
    controller driver power down almost *everything* to save power,
    and that otg_transceiver interface does that job.
 
