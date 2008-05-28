Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYE1Vro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYE1Vro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYE1VpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:45:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:51223 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbYE1VpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l7FJVOKRSs5+42f6LwGCHMxRWqPGPdbmi8OUjkW5LfYKV4IuPU7Z8TkhVN9d3p5TTYiD+sEMRgbiGgKpu52Z5Ow/46Qq0kiECAfkX7sFCjMBr+Mksr2d70RTD0Pm14ROWJmtWJDJdfKgvuRlHtoz3wlBS+bUnx/1I0ND3LxQXYs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:44 +0200
Message-Id: <20080528214244.16327.27961.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/21] cy82c693: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig        |    1 +
 drivers/ide/pci/cy82c693.c |    9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -510,6 +510,7 @@ config BLK_DEV_TRIFLEX
 
 config BLK_DEV_CY82C693
 	tristate "CY82C693 chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds detection and support for the CY82C693 chipset
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -133,6 +133,7 @@ static int calc_clk(int time, int bus_sp
  */
 static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 	int clk1, clk2;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 
@@ -141,15 +142,13 @@ static void compute_clocks(u8 pio, pio_c
 	 */
 
 	/* let's calc the address setup time clocks */
-	p_pclk->address_time = (u8)calc_clk(ide_pio_timings[pio].setup_time, bus_speed);
+	p_pclk->address_time = (u8)calc_clk(t->setup, bus_speed);
 
 	/* let's calc the active and recovery time clocks */
-	clk1 = calc_clk(ide_pio_timings[pio].active_time, bus_speed);
+	clk1 = calc_clk(t->active, bus_speed);
 
 	/* calc recovery timing */
-	clk2 =	ide_pio_timings[pio].cycle_time -
-		ide_pio_timings[pio].active_time -
-		ide_pio_timings[pio].setup_time;
+	clk2 = t->cycle - t->active - t->setup;
 
 	clk2 = calc_clk(clk2, bus_speed);
 
