Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXGAN6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXGAN6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 09:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXGAN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 09:58:05 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:55089 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbXGAN6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 09:58:04 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 1 Jul 2007 07:57:36 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706302130.49440.bjorn.helgaas@hp.com> <20070701070816.BB294782035@smtp04.mtu.ru>
In-Reply-To: <20070701070816.BB294782035@smtp04.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010757.36825.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you apply the patch below for 2.6.22?  It reverts
smsc-ircc2 to the old blind probing behavior.  There's a lot of
infrastructure work I need to do before the PNP probe will be
reliable.

Thanks,
  Bjorn

On Sunday 01 July 2007 01:08:16 am Andrey Borzenkov wrote:
> Bjorn Helgaas wrote:
> > I suspect that things will mostly work if you load the drivers in
> > the (smsc-ircc2, wlags49_h1_cs) order.
> 
> yes
> 
> > Then smsc-ircc2 has a chance 
> > to reserve the resources before yenta and wlags49 get involved.  But
> > of course, we can't rely on that workaround.
> 
> yes :)
> 
> > I think there's lots of work needed here -- make PNP reserve resources,
> > add smarter PNP quirk infrastructure so we can do things at _SRS-time,
> > add real Portege BIOS workaround, etc.  Way more than we can do for
> > 2.6.22.
> 
> yes :)
> 
> > What do you think we need to get 2.6.22 out?  I was thinking of a
> > stop-gap patch like the one below. 
> 
> I agree. I was about to suggest the same the very first time I have seen
> this issue.
> 
> > I'm between trips and can't 
> > really test it.  In my one quick boot, it did find the IR device,
> > but irdadump didn't seem to do anything.
> 
> I confirm that loading smsc-icc2 with nopnp (with your other two patches
> applied) works, finds SIR/FIR and irdadump shows data flowing. 


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
 
