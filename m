Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbXKKWQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbXKKWQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXKKWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:16:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:6394 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbXKKWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=SlWEsio0hcTB2e66orWUvHWRb+6SjbTSkeezG+W/rl2ebvb1PWAIa5aTFLprPMJFzKvn/ioT3Hp+Jmbshf3BMO94dXrj1i52FvbPAJAqj81DjgFVplO3HrH+UQNJf6Mr4ihgQILLDxhEmi5e3v7dXRozzjE2OOuv7DWehf4PIP8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Date: Sun, 11 Nov 2007 23:22:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Thomas Lindroth" <thomas.lindroth@gmail.com>
References: <200711112058.28043.rjw@sisk.pl> <20071111200935.1384c24d@the-village.bc.nu>
In-Reply-To: <20071111200935.1384c24d@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711112322.15537.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 November 2007, Alan Cox wrote:

> > Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
> > Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
> > References	: http://lkml.org/lkml/2007/11/7/152
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9322

http://lkml.org/lkml/2007/10/12/537

The regression itself has been foreseen a month ago and it is quite
sad that it is still not fixed...

> Tejun is looking into this - its not trivial so may be 2.6.25 material.
> Similar reports for some other controllers (notably VIA).

We may fix the regression in a bit different way for now and give Tejun
some more time for the complete rework of the cable detection code.

[PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings

* Don't program UDMA timings when programming PIO or MWDMA modes.

  This has also a nice side-effect of fixing regression added by commit
  681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
  SRST reset sequences") (->set_piomode method for PIO0 is called before
  ->cable_detect method which checks UDMA timings to get the cable type).

* Bump driver version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Untested, please don't merge until it is confirmed to fix the problem.

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
