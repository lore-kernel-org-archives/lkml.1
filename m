Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbXLBCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbXLBCli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 21:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXLBCla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 21:41:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:31889 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXLBCl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 21:41:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=quwDt8008mJcjeTltLgd1yehocR4GVdcnVV6zq0NNFFiDUbxTDJwfRLAPTW+eRHZd0OHbW/X48RI6UrH9pDwNq06FDJl2rurOWypwlGxEG3NZxq8kVCOFuH6y69F1leZ3uR2DLaqAeucGbXXEKOx1+NcTwXt+iGqGiJ+d9a/AJ4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc3-git6: Reported regressions from 2.6.23
Date: Sun, 2 Dec 2007 03:47:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Thomas Lindroth" <thomas.lindroth@gmail.com>
References: <200712012312.42136.rjw@sisk.pl>
In-Reply-To: <200712012312.42136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712020347.01769.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Rafael J. Wysocki wrote:

> Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
> Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
> References	: http://lkml.org/lkml/2007/11/7/152
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9322
> Handled-By	: Tejun Heo <htejun@gmail.com>
> 		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch		: http://lkml.org/lkml/2007/11/11/115

Tejun's rework of cable detection code which fixes the problem has
been just applied into "upstream" (not "upstream-fixes") so it is
destined for 2.6.25 (I wasn't on cc: BTW) and since I got no feedback
on my patch (below) which also happens to fix the regression, was
acked by Alan, tested by Thomas and has been in -mm for 3 weeks now
I assume that everybody is happy with it (Jeff/Tejun: you were also
on cc: when the patch was merged into -mm)...

Linus, please apply.

[PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings

* Don't program UDMA timings when programming PIO or MWDMA modes.

  This has also a nice side-effect of fixing regression added by commit
  681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
  SRST reset sequences") (->set_piomode method for PIO0 is called before
  ->cable_detect method which checks UDMA timings to get the cable type).

* Bump driver version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Tested-by: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_amd.c |    5 +++--
 drivers/ata/pata_via.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.9"
+#define DRV_VERSION "0.3.10"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -115,7 +115,8 @@ static void timing_setup(struct ata_port
 	}
 
 	/* UDMA timing */
-	pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
+	if (at.udma)
+		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
 }
 
 /**
Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -63,7 +63,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -296,7 +296,7 @@ static void via_do_set_mode(struct ata_p
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type) {
+	if (udma_type && t.udma) {
 		u8 cable80_status;
 
 		/* Get 80-wire cable detection bit */
