Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYFKU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYFKU0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYFKUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:25:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60994 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbYFKUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Cuey0rQZArp8flS3gGz3PMeVeY6zFGWJmJVJGjKxflzNQgnTdKga3WwNV9lzuHU7t2
         vJp7NExsCG02rhQK3sVM4W/hW57upyuSAqnmSjHJ34+hHtDXDUHm2fOjUq34NYNN7aU9
         es/PT5Y5lWlTHTaxxiNzmbdOoJtB6mqOiV6PI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] rapide: fix rapide_probe() return value
Date: Wed, 11 Jun 2008 21:19:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112119.46243.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOENT on ide_find_port() failure.

While at it:

- Cleanup rapide_probe() a bit.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -48,24 +48,26 @@ rapide_probe(struct expansion_card *ec, 
 		goto release;
 	}
 
-	hwif = ide_find_port();
-	if (hwif) {
-		memset(&hw, 0, sizeof(hw));
-		rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
-		hw.chipset = ide_generic;
-		hw.dev = &ec->dev;
+	memset(&hw, 0, sizeof(hw));
+	rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
+	hw.chipset = ide_generic;
+	hw.dev = &ec->dev;
 
-		ide_init_port_hw(hwif, &hw);
+	hwif = ide_find_port();
+	if (hwif == NULL) {
+		ret = -ENOENT;
+		goto release;
+	}
 
-		default_hwif_mmiops(hwif);
+	ide_init_port_hw(hwif, &hw);
+	default_hwif_mmiops(hwif);
 
-		idx[0] = hwif->index;
+	idx[0] = hwif->index;
 
-		ide_device_add(idx, &rapide_port_info);
+	ide_device_add(idx, &rapide_port_info);
 
-		ecard_set_drvdata(ec, hwif);
-		goto out;
-	}
+	ecard_set_drvdata(ec, hwif);
+	goto out;
 
  release:
 	ecard_release_resources(ec);
