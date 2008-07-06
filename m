Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbYGFTz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbYGFTz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 15:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYGFTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 15:55:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49800 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753633AbYGFTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 15:55:10 -0400
Date: Sun, 6 Jul 2008 20:37:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080706203716.2c5bdcc5@lxorguk.ukuu.org.uk>
In-Reply-To: <200807051242.00545.linux@rainbow-software.org>
References: <200807042153.56644.linux@rainbow-software.org>
	<200807042339.02444.linux@rainbow-software.org>
	<20080704224636.352e4a7b@lxorguk.ukuu.org.uk>
	<200807051242.00545.linux@rainbow-software.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I force the pass-through mode, it oopses (haven't captured it yet as it's 
> too long). Forcing pass-through mode works fine with UDMA-capable drives:

Couldn't reproduce that yet but the HPA case should be fixed by the
following patch:

pata_it821x: With newer firmware we see HPA flags

From: Alan Cox <alan@redhat.com>

We don't want HPA flags set at this point as we don't allow the issuing of
HPA operations via the 'smart' firmware interface. It could be 1.7 firmware
supports this but for the moment the blunt hammer is appealing (one reason
being right now we don't actually know how to peek at the firmware rev!)
---

 drivers/ata/pata_it821x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index e108169..977e5f8 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -80,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.8"
+#define DRV_VERSION "0.3.9"
 
 struct it821x_dev
 {
@@ -519,6 +519,8 @@ static void it821x_dev_config(struct ata_device *adev)
 	/* This is a controller firmware triggered funny, don't
 	   report the drive faulty! */
 	adev->horkage &= ~ATA_HORKAGE_DIAGNOSTIC;
+	/* No HPA in 'smart' mode */
+	adev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 }
 
 /**
@@ -546,7 +548,9 @@ static int it821x_ident_hack(struct ata_port *ap)
 			adev->id[76] = 0;		/* No NCQ/AN etc */
 		}
 	}
-	return ata_cable_unknown(ap);
+	/* This is actually meaningless, but reporting 80 wire avoids
+	   warnings about cable types */
+	return ata_cable_80wire(ap);
 }
 
 
