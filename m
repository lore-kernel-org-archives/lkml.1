Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXFXVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXFXVp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFXVpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:45:23 -0400
Received: from imf23aec.mail.bellsouth.net ([205.152.59.71]:50439 "EHLO
	imf23aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbXFXVpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:45:22 -0400
Date: Sun, 24 Jun 2007 16:45:19 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: "Jay L. T. Cornwall" <jay@esuna.co.uk>
Cc: linux-kernel@vger.kernel.org, kronos.it@gmail.com,
       Chris Snook <csnook@redhat.com>
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
Message-ID: <20070624164519.04f215b8@osprey.hogchain.net>
In-Reply-To: <467ED4A8.4080500@esuna.co.uk>
References: <467B12CA.5060405@esuna.co.uk>
	<467BE118.4090308@redhat.com>
	<467BE4F1.7040308@esuna.co.uk>
	<467D0EB0.9030100@esuna.co.uk>
	<20070624125957.2e27820c@osprey.hogchain.net>
	<467ED4A8.4080500@esuna.co.uk>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 21:31:36 +0100
"Jay L. T. Cornwall" <jay@esuna.co.uk> wrote:

> Jay Cliburn wrote:
> 
> >> The common factor here seems to be the buffer_head circular list
> >> leading to invalid pointers in bh->b_this_page.
> >>
> >> I'm beginning to suspect the Attansic L1 Gigabit Etherner driver
> >> (marked as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these
> >> panics on disk-to-disk copies or SCP across the localhost
> >> interface. However, SCP from a server onto either of two different
> >> HDDs hits these oopses fairly quickly.
> 
> > How much RAM is installed in your machine?  If it's 4GB or more,
> > does your problem go away if you boot with mem=3000M?
> 
> Intriguing. Yes, this machine has 4GB of RAM. If I boot with mem=3000M
> the problem does indeed go away - I can't induce an oops even after
> transferring tens of GB across the interface.
> 
> I'm not sure I follow why that would be the case, except that it
> relates to pci_map_page behaviour. But I guess you have an inkling?
> 

For reasons not yet clear to me, it appears the L1 driver has a bug or
the device itself has trouble with DMA in high memory.  This patch,
drafted by Luca Tettamanti, is being explored as a workaround.  I'd be
interested to know if it fixes your problem.

[Aside: For future reference, atl1-devel@lists.sourceforge.net is a
mailing list devoted to L1 driver development.]

Jay



diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 6862c11..a600601 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -2104,15 +2104,12 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_dma;
-		}
-		pci_using_64 = false;
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_dma;
 	}
+	pci_using_64 = false;
 	/* Mark all PCI regions associated with PCI device
 	 * pdev as being reserved by owner atl1_driver_name
 	 */

