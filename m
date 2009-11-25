Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbZKYRHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbZKYRHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZKYRH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:27 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42882 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZKYRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JMhtvfiobqj+UuGfYccs1YViZAaDwBntuDFZRx/Mz2byXUjb1RD5yQgbfR78Wtnf9P
         tmJaQ17GLFT41eT1OFCxPLJr/jM6P7BVcu6rfQh/HlzueK2LrfYkelN9iakOO+hGm7pB
         5L5t9ih3shjHSkcN/Ke/NCIbcn4CsYC2nPEZY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:44 +0100
Message-Id: <20091125170644.5446.73492.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 37/86] pata_it8213: fix wrong PIO timings being programmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: fix wrong PIO timings being programmed

* do not clear PIO timings for master when programming slave
* program new PIO timings in the correct register nibble

Both changes should be safe as this is how we have been doing
things in IDE it8213 host driver for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -112,13 +112,13 @@ static void it8213_set_piomode (struct a
 	} else {
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= 0xF0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << 4;
+		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
