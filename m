Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXFGPxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXFGPxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbXFGPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:52:49 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:39630 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765571AbXFGPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:52:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 7 Jun 2007 09:52:36 -0600
User-Agent: KMail/1.9.6
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706061309.28633.bjorn.helgaas@hp.com> <200706070045.14040.arvidjaar@mail.ru>
In-Reply-To: <200706070045.14040.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706070952.36823.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 02:45:01 pm Andrey Borzenkov wrote:
> On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> > On Tuesday 05 June 2007 09:29:11 pm Andrey Borzenkov wrote:
> > > On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> > > > Something's wrong with this strategy.  The BIOS is telling us that an
> > > > SMCf010 device is present, active, and responds at io ports 0x100-0x107
> > > > and 0x2e8-0x2ef.  The fact that it happens to be on the other side of
> > > > an ISA or LPC bridge should be immaterial to the OS driver.
> > >
> > > I thought this as well.
> >
> > If this is really true, it also means we shouldn't twiddle with the
> > bridge.  If the BIOS left us a working setup, the preconfiguration
> > is certainly going to change it to something incompatible with the
> > PNP info.
> >
> > What if we try the following patch, which keeps the FIR/SIR swap and
> > just removes the preconfiguration?
> 
> I already tried different patch but with similar effect (switch off 
> preconfiguration) - it does not work. I am beginning to doubt whether drier 
> works on my system at all (i.e. before PnP change); have to find time to 
> test.

OK.  My patch wasn't the right approach anyway.  Attached is what I
think we should do instead -- do the preconfig if we're not using PNP.

I need to figure out how to test this though.  The current smsc-ircc2
works on my HP nw8240, but I don't have any indication that it works
on laptops that require preconfiguration.



[patch] smsc-ircc2: skip preconfiguration for PNP devices

If we rely on the device resources from PNPBIOS, we also have to rely on
the BIOS to configure any bridges on the way to the device.

Using the PNPBIOS resources but twiddling the configuration of a
bridge behind the back of the firmware is likely to make things
inconsistent.

With "smsc-ircc2.nopnp", we do the legacy device probe, including
manual bridge preconfiguration, as before.

Index: w/drivers/net/irda/smsc-ircc2.c
===================================================================
--- w.orig/drivers/net/irda/smsc-ircc2.c	2007-06-06 15:45:14.000000000 -0600
+++ w/drivers/net/irda/smsc-ircc2.c	2007-06-06 15:50:40.000000000 -0600
@@ -416,6 +416,13 @@
 {
 	int ret = 0;
 
+#ifdef CONFIG_PCI
+	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
+		/* Ignore errors from preconfiguration */
+		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
+	}
+#endif
+
 	if (ircc_fir > 0 && ircc_sir > 0) {
 		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
 		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
@@ -459,13 +466,6 @@
 		return ret;
 	}
 
-#ifdef CONFIG_PCI
-	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
-		/* Ignore errors from preconfiguration */
-		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
-	}
-#endif
-
 	dev_count = 0;
 
 	if (smsc_nopnp || !pnp_platform_devices ||
