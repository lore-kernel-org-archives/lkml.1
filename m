Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXGADcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXGADcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 23:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXGADb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 23:31:58 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:50448 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbXGADb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 23:31:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 30 Jun 2007 21:30:49 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706301847.33834.arvidjaar@mail.ru> <200707010113.25853.arvidjaar@mail.ru>
In-Reply-To: <200707010113.25853.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706302130.49440.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 03:13:24 pm Andrey Borzenkov wrote:
> After some digging, it works now :) So the story:
> 
> PCMCIA includes code for checking for free IO range(s)
> code is active only if CONFIG_ISA is defined
> CONFIG_ISA has this excellent help text:
>           Find out whether you have ISA slots on your motherboard. 
> and I was stupid enough to take this literally (having notebook I obviously do 
> not have any slots at all)

I'm sorry I don't have time at the moment to do digging of my own.
But I don't think you should have to define CONFIG_ISA.  I think
you hit the nail on the head in your last email -- PNP should be
reserving the resources of active devices.

The fact that PNP doesn't reserve them means PCMCIA is free to
claim them for itself.  So I think PNP is mostly at fault here.
(Of course, we'll still have to work around the Portege BIOS
issue as well.)

> So after recompiling with CONFIG_ISA defined I now get
> 
> [ 2254.136611] cs: IO port probe 0x100-0x3af: excluding 0x100-0x107 
> 0x2e8-0x2ef 0x378-0x37f
> [ 2254.166638] cs: IO port probe 0x3e0-0x4ff: excluding 0x3f8-0x3ff 
> 0x408-0x40f 0x480-0x48f 0x4d0-0x4d7
> [ 2254.194838] cs: IO port probe 0x820-0x8ff: clean.
> [ 2254.222401] cs: IO port probe 0xc00-0xcf7: clean.
> [ 2254.250056] cs: IO port probe 0xa00-0xaff: clean.

I suspect that things will mostly work if you load the drivers in
the (smsc-ircc2, wlags49_h1_cs) order.  Then smsc-ircc2 has a chance
to reserve the resources before yenta and wlags49 get involved.  But
of course, we can't rely on that workaround.

I think there's lots of work needed here -- make PNP reserve resources,
add smarter PNP quirk infrastructure so we can do things at _SRS-time,
add real Portege BIOS workaround, etc.  Way more than we can do for
2.6.22.

What do you think we need to get 2.6.22 out?  I was thinking of a
stop-gap patch like the one below.  I'm between trips and can't
really test it.  In my one quick boot, it did find the IR device,
but irdadump didn't seem to do anything.



[patch] smsc-ircc2: bypass PNP detection until we get the quirks worked out

Don't use PNP detection by default yet.  We have some PNP and BIOS issues
to work out first.

Sample problem on a Toshiba Portege 4000: the SMCf010 device is handed off
disabled.  We assign I/O ports originally assigned to the SMCf010 to a
PCMCIA device instead.  We enable the SMCf010, configuring it to use
disjoint ports, but _SRS doesn't work correctly, so the device doesn't
work.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/net/irda/smsc-ircc2.c
===================================================================
--- w.orig/drivers/net/irda/smsc-ircc2.c	2007-06-30 21:00:06.000000000 -0600
+++ w/drivers/net/irda/smsc-ircc2.c	2007-06-30 21:00:08.000000000 -0600
@@ -79,7 +79,7 @@
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
-static int smsc_nopnp;
+static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
 MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
 

