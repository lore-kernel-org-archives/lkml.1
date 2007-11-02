Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXKBCjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXKBCjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbXKBCim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:38:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24198 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbXKBCij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:38:39 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="55424474:sNHT29785385"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/4] Blackfin SPI driver: reconfigure speed_hz and bits_per_word in each spi transfer
Date: Fri,  2 Nov 2007 10:38:32 +0800
Message-Id: <1193971112-7744-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - reconfigure SPI baud from speed_hz of each spi transfer
 - according to spi_transfer.bits_per_word to reprogram register and setup
   correct SPI operation handlers

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   54 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f466fa0..3e5126e 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -234,10 +234,8 @@ static int restore_state(struct driver_data *drv_data)
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	write_BAUD(drv_data, chip->baud);
-	chip->ctl_reg &= (~BIT_CTL_TIMOD);
-	chip->ctl_reg |= (chip->width << 8);
 	write_CTRL(drv_data, chip->ctl_reg);
+	write_BAUD(drv_data, chip->baud);
 
 	bfin_spi_enable(drv_data);
 	cs_active(drv_data, chip);
@@ -679,6 +677,7 @@ static void pump_transfers(unsigned long data)
 	message = drv_data->cur_msg;
 	transfer = drv_data->cur_transfer;
 	chip = drv_data->cur_chip;
+
 	/*
 	 * if msg is error or done, report it back using complete() callback
 	 */
@@ -736,23 +735,62 @@ static void pump_transfers(unsigned long data)
 	drv_data->len_in_bytes = transfer->len;
 	drv_data->cs_change = transfer->cs_change;
 
-	width = chip->width;
+	/* Bits per word setup */
+	switch (transfer->bits_per_word) {
+	case 8:
+		drv_data->n_bytes = 1;
+		width = CFG_SPI_WORDSIZE8;
+		drv_data->read = chip->cs_change_per_word ?
+			u8_cs_chg_reader : u8_reader;
+		drv_data->write = chip->cs_change_per_word ?
+			u8_cs_chg_writer : u8_writer;
+		drv_data->duplex = chip->cs_change_per_word ?
+			u8_cs_chg_duplex : u8_duplex;
+		break;
+
+	case 16:
+		drv_data->n_bytes = 2;
+		width = CFG_SPI_WORDSIZE16;
+		drv_data->read = chip->cs_change_per_word ?
+			u16_cs_chg_reader : u16_reader;
+		drv_data->write = chip->cs_change_per_word ?
+			u16_cs_chg_writer : u16_writer;
+		drv_data->duplex = chip->cs_change_per_word ?
+			u16_cs_chg_duplex : u16_duplex;
+		break;
+
+	default:
+		/* No change, the same as default setting */
+		drv_data->n_bytes = chip->n_bytes;
+		width = chip->width;
+		drv_data->write = drv_data->tx ? chip->write : null_writer;
+		drv_data->read = drv_data->rx ? chip->read : null_reader;
+		drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
+		break;
+	}
+	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
+	cr |= (width << 8);
+	write_CTRL(drv_data, cr);
+
 	if (width == CFG_SPI_WORDSIZE16) {
 		drv_data->len = (transfer->len) >> 1;
 	} else {
 		drv_data->len = transfer->len;
 	}
-	drv_data->write = drv_data->tx ? chip->write : null_writer;
-	drv_data->read = drv_data->rx ? chip->read : null_reader;
-	drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
 	dev_dbg(&drv_data->pdev->dev,
 		"transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
-   		drv_data->write, chip->write, null_writer);
+		drv_data->write, chip->write, null_writer);
 
 	/* speed and width has been set on per message */
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
+	/* Speed setup (surely valid because already checked) */
+	if (transfer->speed_hz)
+		write_BAUD(drv_data, hz_to_spi_baud(transfer->speed_hz));
+	else
+		write_BAUD(drv_data, chip->baud);
+
 	write_STAT(drv_data, BIT_STAT_CLR);
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
 	cs_active(drv_data, chip);
-- 
1.5.3.4
