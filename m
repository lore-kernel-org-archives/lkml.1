Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbXGaUDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbXGaUDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXGaUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:03:20 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:34742 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXGaUDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:03:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
Date: Tue, 31 Jul 2007 14:01:21 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
References: <20070725040304.111550f4.akpm@linux-foundation.org> <5287.1185839599@turing-police.cc.vt.edu> <17955.1185907709@turing-police.cc.vt.edu>
In-Reply-To: <17955.1185907709@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311401.22158.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2007 12:48:29 pm Valdis.Kletnieks@vt.edu wrote:
> Scratch that.  When I wrote the first note, I was at home, and the TPM chip
> did its PNP thing and became 00:0e.  I failed to notice that in my reply,
> I was at work, and the printer port on the docking station became 00:0e and
> the TPM became 00:0f.
> 
> % cat /sys/devices/pnp0/00:0f/id
> BCM0102
> PNP0c31
> % cat /sys/devices/pnp0/00:0f/resources 
> state = active
> io 0xcb0-0xcbb
> mem 0xfed40000-0xfed44fff
> 
> So there *isn't* an IRQ assigned.

Interesting.  I should have noticed that the first resources looked like
a parallel port.  I've been looking at those recently because they're
also broken :-)

So, the BIOS is telling us that at least as currently configured, the
TPM can't use interrupts.  /sys/devices/pnp0/00:0f/options should have
all the *possible* TPM configurations.  I would guess that none of them
shows an IRQ either.

In general, if the BIOS says there's no interrupt, we should not poke
around looking for one unless we think there's a BIOS defect.  I think
you said that under 2.6.22-rc6-mm1, the TPM didn't find a working
interrupt either.

> Or am I wrong in thinking chip->vendor.irq == -1 means "Pick me an IRQ",
> but instead means "I don't do that IRQ thing"? If so, maybe what we need
> to be doing is something like:
> 
> 	if (chip->vendor.irq == -1)
> 		interrupts = 0;
> 
> and force the use of interrupts off and do polling only?

Yup, I hadn't considered the case of BIOS not telling us an interrupt
for the device.  In that case, I think we should force interrupts off
as you suggest.  Here's the patch I would propose:

Index: w/drivers/char/tpm/tpm_tis.c
===================================================================
--- w.orig/drivers/char/tpm/tpm_tis.c	2007-07-31 09:15:43.000000000 -0600
+++ w/drivers/char/tpm/tpm_tis.c	2007-07-31 13:58:55.000000000 -0600
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
@@ -595,10 +592,17 @@
 				      const struct pnp_device_id *pnp_id)
 {
 	resource_size_t start, len;
+	unsigned int irq = 0;
+
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
 
-	return tpm_tis_init(&pnp_dev->dev, start, len);
+	if (pnp_irq_valid(pnp_dev, 0))
+		irq = pnp_irq(pnp_dev, 0);
+	else
+		interrupts = 0;
+
+	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
 static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
@@ -658,7 +662,7 @@
 			return rc;
 		if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
 			return PTR_ERR(pdev);
-		if((rc=tpm_tis_init(&pdev->dev, 0, 0)) != 0) {
+		if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
 			platform_device_unregister(pdev);
 			driver_unregister(&tis_drv);
 		}

