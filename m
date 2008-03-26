Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbYCZUQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbYCZUQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759056AbYCZUMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:55 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46757 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbYCZUMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:53 -0400
Message-ID: <47EAAD72.2020902@indt.org.br>
Date: Wed, 26 Mar 2008 16:09:22 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] MMC: OMAP: Power functions modified to MMC multislot
 support
References: <47DAD39C.90405@indt.org.br> <20080324132631.1e0d2125@mjolnir.drzeus.cx>
In-Reply-To: <20080324132631.1e0d2125@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 20:12:05.0218 (UTC) FILETIME=[A92F1C20:01C88F7D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Modifications at power functions to MMC multislot support. This patch
also move board-specific code out of MMC OMAP driver.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   88 ++++++++++++++++++++---------------------------
 1 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index e4e7537..dbf831f 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -983,52 +983,27 @@ static void mmc_omap_request(struct mmc_host *mmc, struct mmc_request *req)
 	mmc_omap_start_request(host, req);
 }
 
-static void innovator_fpga_socket_power(int on)
+static void mmc_omap_set_power(struct mmc_omap_slot *slot, int power_on,
+				int vdd)
 {
-#if defined(CONFIG_MACH_OMAP_INNOVATOR) && defined(CONFIG_ARCH_OMAP15XX)
-	if (on) {
-		fpga_write(fpga_read(OMAP1510_FPGA_POWER) | (1 << 3),
-		     OMAP1510_FPGA_POWER);
-	} else {
-		fpga_write(fpga_read(OMAP1510_FPGA_POWER) & ~(1 << 3),
-		     OMAP1510_FPGA_POWER);
-	}
-#endif
-}
+	struct mmc_omap_host *host;
 
-/*
- * Turn the socket power on/off. Innovator uses FPGA, most boards
- * probably use GPIO.
- */
-static void mmc_omap_power(struct mmc_omap_host *host, int on)
-{
-	if (on) {
-		if (machine_is_omap_innovator())
-			innovator_fpga_socket_power(1);
-		else if (machine_is_omap_h2())
-			tps65010_set_gpio_out_value(GPIO3, HIGH);
-		else if (machine_is_omap_h3())
-			/* GPIO 4 of TPS65010 sends SD_EN signal */
-			tps65010_set_gpio_out_value(GPIO4, HIGH);
-		else if (cpu_is_omap24xx()) {
-			u16 reg = OMAP_MMC_READ(host, CON);
-			OMAP_MMC_WRITE(host, CON, reg | (1 << 11));
-		} else
-			if (host->power_pin >= 0)
-				omap_set_gpio_dataout(host->power_pin, 1);
-	} else {
-		if (machine_is_omap_innovator())
-			innovator_fpga_socket_power(0);
-		else if (machine_is_omap_h2())
-			tps65010_set_gpio_out_value(GPIO3, LOW);
-		else if (machine_is_omap_h3())
-			tps65010_set_gpio_out_value(GPIO4, LOW);
-		else if (cpu_is_omap24xx()) {
-			u16 reg = OMAP_MMC_READ(host, CON);
-			OMAP_MMC_WRITE(host, CON, reg & ~(1 << 11));
-		} else
-			if (host->power_pin >= 0)
-				omap_set_gpio_dataout(host->power_pin, 0);
+	host = slot->host;
+
+	if (slot->pdata->set_power != NULL)
+		slot->pdata->set_power(mmc_dev(slot->mmc), slot->id, power_on,
+					vdd);
+
+	if (cpu_is_omap24xx()) {
+		u16 w;
+
+		if (power_on) {
+			w = OMAP_MMC_READ(host, CON);
+			OMAP_MMC_WRITE(host, CON, w | (1 << 11));
+		} else {
+			w = OMAP_MMC_READ(host, CON);
+			OMAP_MMC_WRITE(host, CON, w & ~(1 << 11));
+		}
 	}
 }
 
@@ -1067,23 +1042,31 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	int i, dsor;
 
 	dsor = mmc_omap_calc_divisor(mmc, ios);
-	host->bus_mode = ios->bus_mode;
-	host->hw_bus_mode = host->bus_mode;
+
+	mmc_omap_select_slot(slot, 0);
+
+	if (ios->vdd != slot->vdd)
+		slot->vdd = ios->vdd;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		mmc_omap_power(host, 0);
+		mmc_omap_set_power(slot, 0, ios->vdd);
 		break;
 	case MMC_POWER_UP:
 		/* Cannot touch dsor yet, just power up MMC */
-		mmc_omap_power(host, 1);
-		return;
+		mmc_omap_set_power(slot, 1, ios->vdd);
+		goto exit;
 	case MMC_POWER_ON:
 		dsor |= 1 << 11;
 		break;
 	}
 
-	clk_enable(host->fclk);
+	if (slot->bus_mode != ios->bus_mode) {
+		if (slot->pdata->set_bus_mode != NULL)
+			slot->pdata->set_bus_mode(mmc_dev(mmc), slot->id,
+						  ios->bus_mode);
+		slot->bus_mode = ios->bus_mode;
+	}
 
 	/* On insanely high arm_per frequencies something sometimes
 	 * goes somehow out of sync, and the POW bit is not being set,
@@ -1091,6 +1074,7 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	 * Writing to the CON register twice seems to do the trick. */
 	for (i = 0; i < 2; i++)
 		OMAP_MMC_WRITE(host, CON, dsor);
+	slot->saved_con = dsor;
 	if (ios->power_mode == MMC_POWER_ON) {
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
@@ -1099,7 +1083,9 @@ static void mmc_omap_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		while ((OMAP_MMC_READ(host, STAT) & 1) == 0);
 		OMAP_MMC_WRITE(host, STAT, 1);
 	}
-	clk_disable(host->fclk);
+
+exit:
+	mmc_omap_release_slot(slot);
 }
 
 static const struct mmc_host_ops mmc_omap_ops = {
-- 1.5.3.GIT

