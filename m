Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688Ab0ARRR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0ARRR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193Ab0ARRRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:17 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0ARRRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=T25GuSg/7+GYCfOuTT/5RW7jJLPEFXnaR4V1YKISfOF7iNdVQ9ce/wyuOV6zvpCAJq
         TzeNQYclP+1jXWAlQ6l5fE+RxqNK18Ob331wKIUVuzjFdPTIF6gu0YkMGz5wHtFlpUe5
         Y8yrRU/gjJTLjt4tBma+wnmMLlFT246kt7ehQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:55 +0100
Message-Id: <20100118171555.14623.3131.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 15/64] pata_efar: always program master_data before slave_data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: always program master_data before slave_data

We may need to set SITRE before programming slave_data.

This makes pata_efar match the behavior of IDE slc90e66 host driver
and also libata ata_piix one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -72,8 +72,10 @@ static void efar_set_timings(struct ata_
 			     u8 pio, bool use_mwdma)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int is_slave	= (adev->devno != 0);
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
+	u8 slave_data;
 	int control = 0;
 
 	/*
@@ -104,14 +106,13 @@ static void efar_set_timings(struct ata_
 	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
-	if (adev->devno == 0) {
+	if (is_slave == 0) {
 		master_data &= 0xCCF0;
 		master_data |= control;
 		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		int shift = 4 * ap->port_no;
-		u8 slave_data;
 
 		master_data &= 0xFF0F;
 		master_data |= (control << 4);
@@ -120,11 +121,12 @@ static void efar_set_timings(struct ata_
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= ap->port_no ? 0x0F : 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
-		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
 	master_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, master_port, master_data);
+	if (is_slave)
+		pci_write_config_byte(dev, 0x44, slave_data);
 }
 
 /**
