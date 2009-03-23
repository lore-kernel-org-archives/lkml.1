Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZCWPed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZCWPed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZCWPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:27 -0400
Received: from mx1.emlix.com ([193.175.82.87]:60028 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZCWPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:24 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 3/6] xtensa: add spi mmc host to s6105 platform
Date: Mon, 23 Mar 2009 16:34:19 +0100
Message-Id: <1237822462-32109-3-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-1-git-send-email-dg@emlix.com>
References: <1237822462-32109-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   55 ++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index a7ea916..789448e 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -11,9 +11,11 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/phy.h>
+#include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
+#include <linux/spi/mmc_spi.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_s6000.h>
 
@@ -209,7 +211,60 @@ static __devinitdata struct s6_spi_platform_data s6_spi_pdata = {
 #define S6_SPI_CS_EXPANSION	3
 #define S6_SPI_CS_MMC_SLOT	4
 
+static int __devinit s6_init_mmc_host(struct device *spi,
+				      irqreturn_t (*handler)(int, void *),
+				      void *mmc)
+{
+	int ret;
+	ret = gpio_request(GPIO_SD_WP, "mmc_wp");
+	if (ret < 0)
+		return ret;
+	ret = gpio_request(GPIO_SD_IRQ, "mmc_irq");
+	if (ret < 0)
+		return ret;
+	ret = gpio_direction_input(GPIO_SD_WP);
+	if (ret < 0)
+		return ret;
+	ret = gpio_direction_input(GPIO_SD_IRQ);
+	if (ret < 0)
+		return ret;
+	ret = gpio_to_irq(GPIO_SD_IRQ);
+	if (ret < 0)
+		return ret;
+	ret = request_irq(ret, handler,
+			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			  "mmc_slot", mmc);
+	return ret;
+}
+
+static void __devexit s6_exit_mmc_host(struct device *spi, void *mmc)
+{
+	free_irq(gpio_to_irq(GPIO_SD_IRQ), mmc);
+	gpio_free(GPIO_SD_IRQ);
+	gpio_free(GPIO_SD_WP);
+}
+
+static int s6_mmc_get_ro(struct device *spi)
+{
+	return gpio_get_value(GPIO_SD_WP);
+}
+
+static struct mmc_spi_platform_data s6_spi_mmc_pdata = {
+	.caps = 0,
+	.ocr_mask = MMC_VDD_32_33,
+	.init = s6_init_mmc_host,
+	.exit = __devexit_p(s6_exit_mmc_host),
+	.get_ro = s6_mmc_get_ro,
+};
+
 static struct spi_board_info __initdata s6_spi_devices[] = {
+	{
+		.modalias = "mmc_spi",
+		.platform_data = &s6_spi_mmc_pdata,
+		.bus_num = S6_SPI_BUS_NUM,
+		.chip_select = S6_SPI_CS_MMC_SLOT,
+		.max_speed_hz = 50000000,
+	},
 };
 
 static struct platform_device platform_devices[] = {
-- 
1.6.2.107.ge47ee

