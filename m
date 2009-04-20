Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZDTU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZDTU2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZDTU2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:28:14 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:62980 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZDTU2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Nlb2aBOLO7cTaDeNuNiThuMaFy4h5WWvKLdr4GLuDXQEGYFeCOLYUm0e289vWI86UL
         nFr3peP0NUdvYtDaTYy2YMFWYswLaDFDjQKazmqrHSNXWdttDmGmpMaRSmTiqiUn936y
         BgXVoWYOya0AluYQUv/pt/Sk4Lc0bOv7maZLU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: =?iso-8859-15?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: Quick question about libata and hdparm
Date: Mon, 20 Apr 2009 22:31:25 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB9758.3020506@garzik.org> <20090420173526.GA7935@ime.usp.br>
In-Reply-To: <20090420173526.GA7935@ime.usp.br>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904202231.25670.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009 19:35:27 Rogério Brito wrote:
> Hi, Jeff.
> 
> On Apr 19 2009, Jeff Garzik wrote:
> > Well, it's supposed to reduce speed in several circumstances... just
> > not Michael's.  :)
> 
> Well, I'll take that as a yes. :-)
> 
> Can you comment on the dmesg log attached? I'd like to, at least,
> understand what is happening, since I'm starting to consider using
> libata with all my computers.
> 
> This computer, in particular, uses an IDE drive with a 40 ribbon cable
> (and, thus, no UDMA/66). The cable is well put (checked two times
> already) and I believe that everything is OK with this cable, since I
> substituted it was already substituting one that gave me the same
> results.

DISCLAIMER: I'm not handling this bugreport, this is best
done by pata_pdc202xx_old Maintainer or libata Maintainer.

Rogério, if the issue is reproducible you can give this patch a try...

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: fix UDMA33 handling

The original driver doesn't use 66 MHz clock for UDMA33.

[ The alternative solution would be to adjust UDMA33 timings
  for 66 MHz clock but I think that it is safer to stick with
  old & tested behavior for now. ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,7 +2,7 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2007 Bartlomiej Zolnierkiewicz
+ *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
@@ -158,7 +158,7 @@ static void pdc2026x_bmdma_start(struct 
 	u32 len;
 
 	/* Check we keep host level locking here */
-	if (adev->dma_mode >= XFER_UDMA_2)
+	if (adev->dma_mode > XFER_UDMA_2)
 		iowrite8(ioread8(clock) | sel66, clock);
 	else
 		iowrite8(ioread8(clock) & ~sel66, clock);
@@ -212,7 +212,7 @@ static void pdc2026x_bmdma_stop(struct a
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	}
 	/* Flip back to 33Mhz for PIO */
-	if (adev->dma_mode >= XFER_UDMA_2)
+	if (adev->dma_mode > XFER_UDMA_2)
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	ata_bmdma_stop(qc);
 	pdc202xx_set_piomode(ap, adev);
