Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbYBWVWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbYBWVWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYBWVWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:22:13 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49258 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYBWVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:22:11 -0500
Date: Sat, 23 Feb 2008 22:22:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: [Fixed PATCH] hpt366: fix section mismatch warnings
Message-ID: <20080223212222.GA16568@uranus.ravnborg.org>
References: <20080222194651.GA7154@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222194651.GA7154@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpt366: fix section mismatch warnings

Fix following warnings:
WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n

Replace a static array with a small switch resulting in
more readable code.
Mark the pci table __devinitconst.

A lot of variables are const but annotated __devinitdata.
Annotating them __devinitconst would cause a section type
conflict error when build for 64 bit powerpc.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---

The first patch I posted caused a section type conflict when
build for 64 bit powerpc. The actual cause of this is know and unavoidable
when we start to declare variables const.
The patch attached is much simpler as the transition from __devinitdata
to __devinitconst turned out to be bogus.

I also took the opportunity to simplify the switch as suggested by
Sergei.

	Sam

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index d0f7bb8..a5eeb6b 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1570,11 +1570,13 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		if (rev < 3)
 			info = &hpt36x;
 		else {
-			static const struct hpt_info *hpt37x_info[] =
-				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
-
-			info = hpt37x_info[min_t(u8, rev, 6) - 3];
-			idx++;
+			switch (min_t(u8, rev, 6)) {
+			case 3: info = &hpt370;  break;
+			case 4: info = &hpt370a; break;
+			case 5: info = &hpt372;  break;
+			case 6: info = &hpt372n; break;
+			}
+		idx++;
 		}
 		break;
 	case 1:
@@ -1626,7 +1628,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &d);
 }
 
-static const struct pci_device_id hpt366_pci_tbl[] = {
+static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366),  0 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372),  1 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT302),  2 },
