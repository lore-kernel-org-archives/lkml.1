Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYCMWb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYCMWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbYCMW3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288AbYCMW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZD7AMa0EW/5AWRqu9YwOI7aJlEnK5FUvchHxmDEjaSjs26cnWkQs5Yw4+ckU8brrExqstI9/BMPPzVnqGQw/YLvOEy/IAZ+sVxI48yy8+/50pU0NR9LAkmxB38ZUfOD+nzJAvx3uFryDQx5FYRny936lxk+ptM0rIPwKsA22pBc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:32 +0100
Message-Id: <20080313224432.7051.74170.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/12] cmd64x: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd64x.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -57,6 +57,8 @@
 #define UDIDETCR1	0x7B
 #define DTPR1		0x7C
 
+static int pci_clock;
+
 static u8 quantize_timing(int timing, int quant)
 {
 	return (timing + quant - 1) / quant;
@@ -68,8 +70,8 @@ static u8 quantize_timing(int timing, in
  */
 static void program_cycle_times (ide_drive_t *drive, int cycle_time, int active_time)
 {
-	struct pci_dev *dev	= to_pci_dev(drive->hwif->dev);
-	int clock_time		= 1000 / system_bus_clock();
+	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
+	int clock_time = 1000 / (pci_clock ? pci_clock : system_bus_clock());
 	u8  cycle_count, active_count, recovery_count, drwtim;
 	static const u8 recovery_values[] =
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
@@ -128,7 +130,7 @@ static void cmd64x_tune_pio(ide_drive_t 
 			    ide_pio_timings[pio].active_time);
 
 	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
-				      1000 / system_bus_clock());
+			1000 / (pci_clock ? pci_clock : system_bus_clock()));
 
 	/*
 	 * The primary channel has individual address setup timing registers
@@ -532,6 +534,9 @@ static int __init cmd64x_ide_init(void)
 
 module_init(cmd64x_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for CMD64x IDE");
 MODULE_LICENSE("GPL");
