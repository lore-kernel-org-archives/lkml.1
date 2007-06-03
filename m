Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXFCXSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXFCXSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXFCXR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:17:56 -0400
Received: from 27.mail-out.ovh.net ([213.186.38.137]:35822 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751333AbXFCXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:17:55 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 19:17:55 EDT
Date: Mon, 4 Jun 2007 02:10:51 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       bjorn.helgaas@hp.com
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Message-ID: <20070603231050.GA3829@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <200706031200.07514.arvidjaar@mail.ru> <200706031216.06172.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706031216.06172.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Ovh-Remote: 90.28.104.183 (aannecy-257-1-25-183.w90-28.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Sun, Jun 03, 2007 at 12:16:05PM +0400, Andrey Borzenkov wrote:
> 
> Adding "nopnp" parameters finds device just fine so it is apparently result of 
> this commit:
> 
> commit d0d4f69bb65a8c1c1430c577a583632709b874c6
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue May 8 00:36:05 2007 -0700
> 
>     smsc-ircc2: add PNP support
> 
> What information is needed to debug it further?
It seems that PnP tells us that the FIR port is at 0x2e8 while we're
expecting it at 0x2f8.
Could you apply this patch and then send me a dmesg dump of the
smsc-ircc initialisation ?

Cheers,
Samuel.


diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 9043bf4..d1d46a6 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -391,6 +391,9 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 	dma = pnp_dma(dev, 0);
 	irq = pnp_irq(dev, 0);
 
+	printk("%s(): fir 0x%x sir 0x%x dma %d irq %d\n",
+	       __FUNCTION__, firbase, sirbase, dma, irq);
+
 	if (smsc_ircc_open(firbase, sirbase, dma, irq))
 		return -ENODEV;
 
@@ -655,6 +658,7 @@ static int smsc_ircc_present(unsigned int fir_base, unsigned int sir_base)
 	irq     = (config & IRCC_INTERFACE_IRQ_MASK) >> 4;
 
 	if (high != 0x10 || low != 0xb8 || (chip != 0xf1 && chip != 0xf2)) {
+		printk("High: 0x%x, Chip 0x%x\n", high, chip);
 		IRDA_WARNING("%s(), addr 0x%04x - no device found!\n",
 			     __FUNCTION__, fir_base);
 		goto out3;



