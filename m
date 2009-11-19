Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZKSSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZKSSTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZKSSTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:19:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752376AbZKSSTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:19:36 -0500
Date: Thu, 19 Nov 2009 18:21:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119182132.5155f819@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191852.23061.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911191838.11791.bzolnier@gmail.com>
	<20091119175051.6a91d160@lxorguk.ukuu.org.uk>
	<200911191852.23061.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fixed where?  I posted the patch as soon as I noticed the problem.

Its not posted because unlike you I don't post patches as soon as I
notice them. I test them first. Which is why for example I discovered the
bug in the drivers/ide one. Did you check the vendor driver and then
stick 40 and 80 wire cables on the system to check the bits on a 3x2N ?

No I didn't think so. You see if you had you'd have discovered something
else. You'd have discovered another bug in the old IDE one. The driver
code for these chips isn't reliable and doesn't work at all in some cases.

> Told me about it?  

Yes - or do you only write replies not read them ?

NAK - the patch is inadequate. The procedure in the vendor driver does
appear to work on the newer chips however. Probably worth double checking
the HPT37x and seeing if it needs the same debounce delays.

Give the patch below a test on your HPT3x2N series device. The PCI -> io
access change doesn't appear to matter but is used by the vendor driver.
I've switched to it because we've been burned before with only some of the
I/O space being visible both ways (eg on the 371N). The critical bit other
than get the bits the right way around appears to be the 10uS delay.

Alan
--

commit d27660f440b516f58385649f705b07f10b24da94
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu Nov 19 17:59:26 2009 +0000

    pata_hpt3x2n: Fix cable detection
    
    The version inherited from drivers/ide doesn't work on the newer chipsets
    at least not reliably. The vendors own driver uses a different process and
    that one appears to produce plausible numbers.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 3d59fe0..d92ad5b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -124,16 +124,15 @@ static u32 hpt3x2n_find_mode(struct ata_port *ap, int speed)
 static int hpt3x2n_cable_detect(struct ata_port *ap)
 {
 	u8 scr2, ata66;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	void __iomem *base = ap->ioaddr.bmdma_addr;
 
-	pci_read_config_byte(pdev, 0x5B, &scr2);
-	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
-	/* Cable register now active */
-	pci_read_config_byte(pdev, 0x5A, &ata66);
-	/* Restore state */
-	pci_write_config_byte(pdev, 0x5B, scr2);
+	scr2 = ioread8(base + 0x7B);
+	iowrite8(scr2 & ~0x01, base + 0x7B);
+	udelay(10);	/* Debounce */
+	ata66 = ioread8(base + 0x7A);
+	iowrite8(scr2, base + 0x7B);
 
-	if (ata66 & (1 << ap->port_no))
+	if (ata66 & (2 >> ap->port_no))
 		return ATA_CBL_PATA40;
 	else
 		return ATA_CBL_PATA80;
