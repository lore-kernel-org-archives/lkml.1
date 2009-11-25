Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZKYREm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZKYREm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbZKYREk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:40 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbZKYREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jPwzBpUlDq6nuKhChG1UIdgI2VEKKvAAY0TRVgqvgoVD75J3KuAE8EO/nbvpnNtlOo
         oQJgcEEZx5wH74fmobWhP1PmlYps62NQhaxPCuJxBav1t+TryQtelMEdkhbpWyGfGLUS
         5ZUGjavpJtf/mWaLdec6zSPrrOWZiruNnieUo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:58 +0100
Message-Id: <20091125170358.5446.6976.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 14/86] pata_efar: fix wrong PIO timings being programmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: fix wrong PIO timings being programmed

* do not clear PIO timings for master when programming slave
* do not clear PIO timings for device on the other port when
  programming slave device

Both changes should be safe as this is how we have been doing
things in IDE slc90e66 host driver for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -2,6 +2,7 @@
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
  *	(C) 2005 Red Hat
+ *	(C) 2009 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -118,12 +119,12 @@ static void efar_set_piomode (struct ata
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= 0x0F << shift;
+		slave_data &= ap->port_no ? 0x0F : 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
