Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZKSTiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZKSTiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKSTiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:38:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:59850 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZKSTiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:38:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=AeIZIUIJAJF3DcIixmRljsFDCTTIxKMROO41UoaLsSYVkZ3uEDeODjiShLN2t1CGQI
         i0OuTkd5BnmGorS1pNYcvhu0wjtwjwyx9SBbtDZ9C+GPOxMzFVKopQTsdkfrl3/s8dEO
         nNTNOmitueAxan4LjssDJyjacdotTPRzxC5g4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 20:31:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <4B0590A2.9050306@ru.mvista.com> <200911192003.09675.bzolnier@gmail.com>
In-Reply-To: <200911192003.09675.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911192031.31613.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 20:03:09 Bartlomiej Zolnierkiewicz wrote:
> On Thursday 19 November 2009 19:38:26 Sergei Shtylyov wrote:
> > Alan Cox wrote:
> > 
> > >>Fixed where?  I posted the patch as soon as I noticed the problem.
> > 
> > > Its not posted because unlike you I don't post patches as soon as I
> > > notice them. I test them first. Which is why for example I discovered the
> > > bug in the drivers/ide one. Did you check the vendor driver and then
> > > stick 40 and 80 wire cables on the system to check the bits on a 3x2N ?
> > 
> > > No I didn't think so. You see if you had you'd have discovered something
> > > else. You'd have discovered another bug in the old IDE one. The driver
> > > code for these chips isn't reliable and doesn't work at all in some cases.
> > 
> > >>Told me about it?  
> > 
> > > Yes - or do you only write replies not read them ?
> > 
> > > NAK - the patch is inadequate.
> > 
> >     No, it was. And yours isn't quite.
> > 
> > > The procedure in the vendor driver does
> > > appear to work on the newer chips however.
> > 
> > > Probably worth double checking
> > > the HPT37x and seeing if it needs the same debounce delays.
> > 
> >     All vendor drivers I have do call StallExec(10) when detecting cable 
> > type, so need to add the delay to pata_hpt37x too.
> 
> Given this I take back my ACK to Alan's patch.
> 
> >     I'd suggest to address the delay by another, separate patch to both 
> > pata_hpt37x and pata_hpt3x2n drivers, and accept Bart's original patch for 
> > bit reversing...
> 
> Yes.

Jeff, this is incremental to my previous fix.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_hpt{37x,3x2n}: add debounce delay to cable detection methods

Alan Cox reported that cable detection sometimes works unreliably
for HPT3xxN and that the issue is fixed by adding debounce delay
as used by the vendor driver. 

Sergei Shtylyov also noticed that debounce delay is needed for all
HPT37x and HPT3xxN chipsets according to vendor drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
In comparison to original patch the conversion from PCI access to
io has been dropped as it is not required for the bugfix and makes
patch easier for back-porting into -stable kernels.

 drivers/ata/pata_hpt37x.c  |    3 +++
 drivers/ata/pata_hpt3x2n.c |    3 +++
 2 files changed, 6 insertions(+)

Index: b/drivers/ata/pata_hpt37x.c
===================================================================
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -324,6 +324,9 @@ static int hpt37x_pre_reset(struct ata_l
 
 	pci_read_config_byte(pdev, 0x5B, &scr2);
 	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
+
+	udelay(10); /* debounce */
+
 	/* Cable register now active */
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Restore state */
Index: b/drivers/ata/pata_hpt3x2n.c
===================================================================
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -128,6 +128,9 @@ static int hpt3x2n_cable_detect(struct a
 
 	pci_read_config_byte(pdev, 0x5B, &scr2);
 	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
+
+	udelay(10); /* debounce */
+
 	/* Cable register now active */
 	pci_read_config_byte(pdev, 0x5A, &ata66);
 	/* Restore state */

