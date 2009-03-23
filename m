Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZCWPdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZCWPdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZCWPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:33:26 -0400
Received: from mx1.emlix.com ([193.175.82.87]:59646 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbZCWPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:33:24 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 4/6] xtensa: add m25p80 to s6105 platform
Date: Mon, 23 Mar 2009 16:34:20 +0100
Message-Id: <1237822462-32109-4-git-send-email-dg@emlix.com>
In-Reply-To: <1237822462-32109-1-git-send-email-dg@emlix.com>
References: <1237822462-32109-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi_board_info is enclosed in #ifdef CONFIG_MTD_M25P80 to not
interfere with the mmc_spi driver if not used. When mmc_spi is fixed
to work on a shared bus, this #ifdef can be removed.

The stage2 partition contains the kernels for all processors in the
device. In our case a Linux kernel for the SCP core and maybe a
non-Linux kernel for the AUX core. The size of the stage2 partition
is not hardcoded in the bootloader. It depends on the first few bytes
of that partition. Remaining space up to the boot config can be used
for other purposes (f.ex. a filesystem).

The boot configuration is expected at address 0xfff800. The flash chip
ignores the upper two address bits. Rounding down to sectors then
yields an offset of 0x3f0000 for that partition.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   47 ++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index 789448e..bc254ac 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -12,9 +12,12 @@
 #include <linux/irq.h>
 #include <linux/phy.h>
 #include <linux/mmc/host.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
+#include <linux/spi/flash.h>
 #include <linux/spi/mmc_spi.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_s6000.h>
@@ -211,6 +214,36 @@ static __devinitdata struct s6_spi_platform_data s6_spi_pdata = {
 #define S6_SPI_CS_EXPANSION	3
 #define S6_SPI_CS_MMC_SLOT	4
 
+static struct mtd_partition s6_spi_flash_partitions[] = {
+	{
+		.name = "bootloader",
+		.size = 0x10000,
+		.offset = 0,
+	},
+	{
+		.name = "stage2",
+		.size = 0x360000,
+		.offset = 0x10000,
+	},
+	{
+		.name = "filesystem",
+		.size = 0x90000,
+		.offset = 0x370000,
+	},
+	{ /* actually 0x800 bytes at 0xfff800 */
+		.name = "bootconfig",
+		.size = 0x10000,
+		.offset = 0x3f0000,
+	}
+};
+
+static struct flash_platform_data s6_spi_flash_pdata = {
+	.name = "m25p80",
+	.parts = s6_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(s6_spi_flash_partitions),
+	.type = "m25p32",
+};
+
 static int __devinit s6_init_mmc_host(struct device *spi,
 				      irqreturn_t (*handler)(int, void *),
 				      void *mmc)
@@ -258,6 +291,20 @@ static struct mmc_spi_platform_data s6_spi_mmc_pdata = {
 };
 
 static struct spi_board_info __initdata s6_spi_devices[] = {
+#ifdef CONFIG_MTD_M25P80
+	{
+		.modalias = "m25p80",
+		.platform_data = &s6_spi_flash_pdata,
+		.bus_num = S6_SPI_BUS_NUM,
+		.chip_select = S6_SPI_CS_BOOT_FLASH,
+#ifdef CONFIG_M25PXX_USE_FAST_READ
+		.max_speed_hz = 50000000,
+#else
+		.max_speed_hz = 33000000,
+#endif
+		.mode = SPI_MODE_3
+	},
+#endif
 	{
 		.modalias = "mmc_spi",
 		.platform_data = &s6_spi_mmc_pdata,
-- 
1.6.2.107.ge47ee

