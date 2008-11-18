Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYKRH47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYKRH47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYKRHvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:51:33 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:43724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYKRHv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:51:27 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690405"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 15/16] Blackfin SPI Driver: fix bug - spi controller driver does not assert/deassert CS correctly
Date: Tue, 18 Nov 2008 15:52:39 +0800
Message-Id: <1226994760-4301-16-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

This bug can be observed when two SPI devices are sharing the spi bus:
One device is set as SPI CS 7, another one is using SPI CS 4.

In spi_bfin5xx.c: cs_active(), cs_deactive() are used to control SPI_FLG
register. From the debug bellow:

cs_active: flag: 0x7f91, chip->flag: 0x7f80, cs: 7
cs_active: flag: 0xef91, chip->flag: 0xef10, cs: 4

When device A (cs_7) activate CS 7, SPI_FLG is set as 0x7f91 (however,
SPI_FLG should be set as 0x7f80, or 0x6f91 if in broadcast mode).

Due to some HW bug (very possibly), if SPI_FLG is set as 0x7f91,
SPISSEL7 is asserted, however SPISSEL4 will be asserted too (I can see
this using the scope). This is unreasonable according to HRM.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 9c602ad..8cf5d6e 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -189,6 +189,7 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 {
 	u16 flag = read_FLAG(drv_data);
 
+	flag &= ~chip->flag;
 	flag |= (chip->flag << 8);
 
 	write_FLAG(drv_data, flag);
@@ -1032,7 +1033,6 @@ static int setup(struct spi_device *spi)
 	struct bfin5xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
-	u8 spi_flg;
 
 	/* Abort device setup if requested features are not supported */
 	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
@@ -1115,8 +1115,7 @@ static int setup(struct spi_device *spi)
 	 * SPI_BAUD, not the real baudrate
 	 */
 	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
-	spi_flg = ~(1 << (spi->chip_select));
-	chip->flag = ((u16) spi_flg << 8) | (1 << (spi->chip_select));
+	chip->flag = 1 << (spi->chip_select);
 	chip->chip_select_num = spi->chip_select;
 
 	switch (chip->bits_per_word) {
-- 
1.5.6.3
