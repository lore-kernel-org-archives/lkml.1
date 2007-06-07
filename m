Return-Path: <linux-kernel-owner+w=401wt.eu-S936398AbXFGUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936398AbXFGUz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXFGUzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:55:17 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:47788 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755118AbXFGUzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:55:14 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 16:55:14 EDT
Date: Thu, 7 Jun 2007 23:47:59 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
       "Linus Walleij \(LD/EAB\)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Message-ID: <20070607204759.GA6809@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706061309.28633.bjorn.helgaas@hp.com> <200706070045.14040.arvidjaar@mail.ru> <200706070952.36823.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706070952.36823.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Ovh-Remote: 90.28.102.240 (aannecy-257-1-23-240.w90-28.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 6/7/2007, "Bjorn Helgaas" <bjorn.helgaas@hp.com> wrote:

>On Wednesday 06 June 2007 02:45:01 pm Andrey Borzenkov wrote:
>> On Wednesday 06 June 2007, Bjorn Helgaas wrote:
>> > On Tuesday 05 June 2007 09:29:11 pm Andrey Borzenkov wrote:
>> > > On Wednesday 06 June 2007, Bjorn Helgaas wrote:
>> > > > Something's wrong with this strategy.  The BIOS is telling us that an
>> > > > SMCf010 device is present, active, and responds at io ports 0x100-0x107
>> > > > and 0x2e8-0x2ef.  The fact that it happens to be on the other side of
>> > > > an ISA or LPC bridge should be immaterial to the OS driver.
>> > >
>> > > I thought this as well.
>> >
>> > If this is really true, it also means we shouldn't twiddle with the
>> > bridge.  If the BIOS left us a working setup, the preconfiguration
>> > is certainly going to change it to something incompatible with the
>> > PNP info.
>> >
>> > What if we try the following patch, which keeps the FIR/SIR swap and
>> > just removes the preconfiguration?
>>
>> I already tried different patch but with similar effect (switch off
>> preconfiguration) - it does not work. I am beginning to doubt whether drier
>> works on my system at all (i.e. before PnP change); have to find time to
>> test.
>
>OK.  My patch wasn't the right approach anyway.  Attached is what I
>think we should do instead -- do the preconfig if we're not using PNP.
Thats sounds good, yes.
Maybe we should also run the legacy probe when the PnP one fails. I
don't know how the preconfiguration stuff will behave with the device
being PnP enabled, but with your patch Andrey will still need to
modprobe smsc-ircc with smsc_nopnp.

So, here is the patch I propose (I had to move smsc_ircc_legacy_probe()
a bit earlier in the code to avoid forward declaration, but it's
basically your patch plus a call to smsc_ircc_legacy_probe() from the
pnp_probe() routine):


diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 9043bf4..1d7ab3f 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -366,6 +366,44 @@ static inline void register_bank(int iobase, int bank)
                iobase + IRCC_MASTER);
 }
 
+
+static int __init smsc_ircc_legacy_probe(void)
+{
+	int ret = 0;
+
+#ifdef CONFIG_PCI
+	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir,
+					      ircc_dma, ircc_irq) < 0) {
+		/* Ignore errors from preconfiguration */
+		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
+	}
+#endif
+
+	if (ircc_fir > 0 && ircc_sir > 0) {
+		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
+		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
+
+		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
+			ret = -ENODEV;
+	} else {
+		ret = -ENODEV;
+
+		/* try user provided configuration register base address */
+		if (ircc_cfg > 0) {
+			IRDA_MESSAGE(" Overriding configuration address "
+				     "0x%04x\n", ircc_cfg);
+			if (!smsc_superio_fdc(ircc_cfg))
+				ret = 0;
+			if (!smsc_superio_lpc(ircc_cfg))
+				ret = 0;
+		}
+
+		if (smsc_ircc_look_for_chips() > 0)
+			ret = 0;
+	}
+	return ret;
+}
+
 /* PNP hotplug support */
 static const struct pnp_device_id smsc_ircc_pnp_table[] = {
 	{ .id = "SMCf010", .driver_data = 0 },
@@ -391,9 +429,14 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 	dma = pnp_dma(dev, 0);
 	irq = pnp_irq(dev, 0);
 
-	if (smsc_ircc_open(firbase, sirbase, dma, irq))
-		return -ENODEV;
-
+	if (smsc_ircc_open(firbase, sirbase, dma, irq)) {
+		IRDA_ERROR("PnP probe failed\n");
+		if (smsc_ircc_legacy_probe()) {
+			IRDA_ERROR("Legacy probe failed\n");
+			return -ENODEV;
+		}
+	}
+	
 	return 0;
 }
 
@@ -412,35 +455,6 @@ static struct pnp_driver smsc_ircc_pnp_driver = {
  *
  *******************************************************************************/
 
-static int __init smsc_ircc_legacy_probe(void)
-{
-	int ret = 0;
-
-	if (ircc_fir > 0 && ircc_sir > 0) {
-		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
-		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
-
-		if (smsc_ircc_open(ircc_fir, ircc_sir, ircc_dma, ircc_irq))
-			ret = -ENODEV;
-	} else {
-		ret = -ENODEV;
-
-		/* try user provided configuration register base address */
-		if (ircc_cfg > 0) {
-			IRDA_MESSAGE(" Overriding configuration address "
-				     "0x%04x\n", ircc_cfg);
-			if (!smsc_superio_fdc(ircc_cfg))
-				ret = 0;
-			if (!smsc_superio_lpc(ircc_cfg))
-				ret = 0;
-		}
-
-		if (smsc_ircc_look_for_chips() > 0)
-			ret = 0;
-	}
-	return ret;
-}
-
 /*
  * Function smsc_ircc_init ()
  *
@@ -459,13 +473,6 @@ static int __init smsc_ircc_init(void)
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

