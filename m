Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYE1Vr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYE1Vr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYE1VpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:45:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:51381 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbYE1VpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cNQ99UPoavyaXr3QGrzrat9OgnPQSG6yhjiMp598GaPIB3ZSuaQQWbt0c5U24isFH1QtS3R42RM2GgVW3IvdV7FRB5EkUj/3eMV5VyiAtOmrZCgHRB0m0VS9WAvLctGcN4iOQh17fmgaID9NlXsRAFQ2emFr1yjh4UKuImAlbUI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:51 +0200
Message-Id: <20080528214251.16327.69202.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/21] opti621: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig       |    1 +
 drivers/ide/pci/opti621.c |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -426,6 +426,7 @@ config BLK_DEV_GENERIC
 config BLK_DEV_OPTI621
 	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select IDE_TIMINGS
 	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -208,15 +208,15 @@ typedef struct pio_clocks_s {
 static void compute_clocks(int pio, pio_clocks_t *clks)
 {
 	if (pio != PIO_NOT_EXIST) {
-		int adr_setup, data_pls;
+		struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
+		int adr_setup = t->setup, data_pls = t->active;
 		int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
-		adr_setup = ide_pio_timings[pio].setup_time;
-		data_pls = ide_pio_timings[pio].active_time;
 		clks->address_time = cmpt_clk(adr_setup, bus_speed);
 		clks->data_time = cmpt_clk(data_pls, bus_speed);
-		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
-			- adr_setup-data_pls, bus_speed);
+		clks->recovery_time = cmpt_clk(t->cycle	- adr_setup - data_pls,
+					       bus_speed);
+
 		if (clks->address_time < 1)
 			clks->address_time = 1;
 		if (clks->address_time > 4)
