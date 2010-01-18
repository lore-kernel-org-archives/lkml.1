Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362Ab0ARRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0ARRVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229Ab0ARRVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:21:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:34657 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0ARRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YcoGwgizS8ClaEgw9l4r++gCajHm0LzZDSs5UKfZ11VG8CY9x9GGiE7NTEGYwfX7GH
         u35GG0wWVQV/w6uvR+RQ48phcHKI/2qw4KwamJuH/uCXOfcAj6xbfWsfrbm9xD6FT+S2
         x7x9IGr5bkrG8nN1u4kfiHXN5SQclzr4Vznwg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:21 +0100
Message-Id: <20100118172021.14623.2326.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 45/64] via82cxxx: fix UDMA settings programming
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: fix UDMA settings programming

* preserve 80-wire cable detection bit
* don't clear UDMA settings when programming PIO/MWDMA modes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -146,10 +146,25 @@ static void via_set_speed(ide_hwif_t *hw
 	case ATA_UDMA4: t = timing->udma ? (0xe8 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x0f; break;
 	case ATA_UDMA5: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
 	case ATA_UDMA6: t = timing->udma ? (0xe0 | (clamp_val(timing->udma, 2, 9) - 2)) : 0x07; break;
-	default: return;
 	}
 
-	pci_write_config_byte(dev, VIA_UDMA_TIMING + (3 - dn), t);
+	/* Set UDMA unless device is not UDMA capable */
+	if (vdev->via_config->udma_mask) {
+		u8 udma_etc;
+
+		pci_read_config_byte(dev, VIA_UDMA_TIMING + 3 - dn, &udma_etc);
+
+		/* clear transfer mode bit */
+		udma_etc &= ~0x20;
+
+		if (timing->udma) {
+			/* preserve 80-wire cable detection bit */
+			udma_etc &= 0x10;
+			udma_etc |= t;
+		}
+
+		pci_write_config_byte(dev, VIA_UDMA_TIMING + 3 - dn, udma_etc);
+	}
 }
 
 /**
