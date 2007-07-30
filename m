Return-Path: <linux-kernel-owner+w=401wt.eu-S967706AbXG3SKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967706AbXG3SKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966949AbXG3SJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:09:40 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:37485 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966811AbXG3SJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:09:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
Date: Mon, 30 Jul 2007 12:09:33 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
References: <20070725040304.111550f4.akpm@linux-foundation.org> <23912.1185542889@turing-police.cc.vt.edu> <200707271643.14028.bjorn.helgaas@hp.com>
In-Reply-To: <200707271643.14028.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301209.33961.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 04:43:13 pm Bjorn Helgaas wrote:
> On Friday 27 July 2007 07:28:09 am Valdis.Kletnieks@vt.edu wrote:
> > Looks like the problematic code is in tpm_tis.c tpm_tis_init() near here:
> > 
> >                 for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {
> >                         iowrite8(i, chip->vendor.iobase +
> >                                     TPM_INT_VECTOR(chip->vendor.locality));
> >                         if (request_irq
> >                             (i, tis_int_probe, IRQF_SHARED,
> >                              chip->vendor.miscdev.name, chip) != 0) {
> >                                 dev_info(chip->dev,
> >                                          "Unable to request irq: %d for probe\n"
> > ,           
> >                                          i);
> >                                 continue;
> >                         }
> > 
> > This seems to be misbehaving differently for the two different DEBUG_SHIRQ
> > cases.
> > 
> > With DEBUG_SHIRQ=n, it starts at IRQ3, gets to at least 8 (where it complains
> > it can't request it for probing), and possibly all the way to 15, without ever
> > actually selecting and assigning an IRQ (to refresh memories, in that range
> > /proc/interrupts only lists:
> > 
> >   8:          0          0   IO-APIC-edge      rtc
> >   9:          3          0   IO-APIC-fasteoi   acpi
> >  12:         94          0   IO-APIC-edge      i8042
> >  14:     148166          0   IO-APIC-edge      libata
> >  15:         94          0   IO-APIC-edge      libata
> > 
> > So there's certainly IRQ's available.  No idea why it doesn't choose one. But
> > since it never chose one, it never gets into the "wait for the IRQ" protected
> > by 'if (chip->vendor.irq)' at the end of tpm_tis_send.
> > 
> > With DEBUG_SHIRQ=y, It starts at IRQ3, and assigns it (which seems a good thing).
> > Unfortunately, this then hits the timeouts in tpm_tis_send.
> > 
> > Anybody got an idea what *should* be happening here?
> 
> I don't know why tpm_tis_init() is messing around trying different
> IRQs between 3 and 16.  That looks suspiciously x86-dependent.
> 
> Maybe if you don't have PNP (though I doubt TPMs exist on any
> pre-PNPBIOS machines) the "check-IRQ" loop would be necessary.
> 
> But you're using the PNP probe, and PNP should just tell you what
> IRQ the device is configured for (and whether the IRQ can be
> shared -- see 8250_pnp.c for an example).

I think tpm_tis should do something like the patch below to discover
its interrupt.  If ACPI tells us the device's IRQ, we should just use
it rather than blindly trying a few possibilities.  So the patch below
might make it work, because it should skip the problematic code you
identified above.

But there could still be an issue with DEBUG_SHIRQ and the IRQ probe
loop.  Even if we used the attached patch, we'd probably still want
the IRQ probe to work when you specify tpm_tis.force=1.

Index: w/drivers/char/tpm/tpm_tis.c
===================================================================
--- w.orig/drivers/char/tpm/tpm_tis.c	2007-07-30 11:29:31.000000000 -0600
+++ w/drivers/char/tpm/tpm_tis.c	2007-07-30 11:35:20.000000000 -0600
@@ -433,17 +433,12 @@
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len)
+			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
 	struct tpm_chip *chip;
 
-	if (!start)
-		start = TIS_MEM_BASE;
-	if (!len)
-		len = TIS_MEM_LEN;
-
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
 
@@ -510,7 +505,9 @@
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts) {
+	if (interrupts)
+		chip->vendor.irq = irq;
+	if (interrupts && !chip->vendor.irq) {
 		chip->vendor.irq =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -595,10 +592,13 @@
 				      const struct pnp_device_id *pnp_id)
 {
 	resource_size_t start, len;
+	unsigned int irq;
+
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
+	irq = pnp_irq(pnp_dev, 0);
 
-	return tpm_tis_init(&pnp_dev->dev, start, len);
+	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
 static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
@@ -658,7 +658,7 @@
 			return rc;
 		if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
 			return PTR_ERR(pdev);
-		if((rc=tpm_tis_init(&pdev->dev, 0, 0)) != 0) {
+		if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
 			platform_device_unregister(pdev);
 			driver_unregister(&tis_drv);
 		}
