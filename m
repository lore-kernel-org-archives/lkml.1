Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbZHSLkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbZHSLkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZHSLki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:40:38 -0400
Received: from india.einfochips.com ([203.88.139.151]:1656 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751386AbZHSLkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:40:37 -0400
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
To: nico@cam.org
Cc: linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk, dhaval.vasa@einfochips.com
Subject: [PATCH] [ARM] Kirkwood: Marvell OpenRD-Client board support added
Date: Wed, 19 Aug 2009 17:12:08 +0530
Message-Id: <1250682128-553-1-git-send-email-dhaval.vasa@einfochips.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reference:
http://open-rd.org
http://code.google.com/p/openrd

This patch is tested for:
1. Boot from DRAM/NAND flash
2. NAND read/write/erase
3. GbE0 & GbE1
4. USB read/write
5. SATA

FIXME:
1. SD/UART1 selection
2. MPP configuration (currently, default)
3. PEX
4. Audio
5. VGA

Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
---
 arch/arm/mach-kirkwood/Kconfig               |    6 ++
 arch/arm/mach-kirkwood/Makefile              |    1 +
 arch/arm/mach-kirkwood/openrd_client-setup.c |   92 ++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-kirkwood/openrd_client-setup.c

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index f2379b3..1c8c6af 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -43,6 +43,12 @@ config MACH_OPENRD_BASE
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell OpenRD Base Board.
+
+config MACH_OPENRD_CLIENT
+	bool "Marvell OpenRD Client Board"
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Marvell OpenRD Client Board.
 endmenu
 
 endif
diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
index 80ab0ec..26ba284 100644
--- a/arch/arm/mach-kirkwood/Makefile
+++ b/arch/arm/mach-kirkwood/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_MACH_MV88F6281GTW_GE)	+= mv88f6281gtw_ge-setup.o
 obj-$(CONFIG_MACH_SHEEVAPLUG)		+= sheevaplug-setup.o
 obj-$(CONFIG_MACH_TS219)		+= ts219-setup.o
 obj-$(CONFIG_MACH_OPENRD_BASE)		+= openrd_base-setup.o
+obj-$(CONFIG_MACH_OPENRD_CLIENT)	+= openrd_client-setup.o
 
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
diff --git a/arch/arm/mach-kirkwood/openrd_client-setup.c b/arch/arm/mach-kirkwood/openrd_client-setup.c
new file mode 100644
index 0000000..7b474fc
--- /dev/null
+++ b/arch/arm/mach-kirkwood/openrd_client-setup.c
@@ -0,0 +1,92 @@
+/*
+ * arch/arm/mach-kirkwood/openrd_client-setup.c
+ *
+ * Marvell OpenRD Base Client Setup
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/partitions.h>
+#include <linux/ata_platform.h>
+#include <linux/mv643xx_eth.h>
+#include <linux/gpio.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <mach/kirkwood.h>
+#include <plat/mvsdio.h>
+#include "common.h"
+#include "mpp.h"
+
+static struct mtd_partition openrd_client_nand_parts[] = {
+	{
+		.name = "u-boot",
+		.offset = 0,
+		.size = SZ_1M
+	}, {
+		.name = "uImage",
+		.offset = MTDPART_OFS_NXTBLK,
+		.size = SZ_4M
+	}, {
+		.name = "root",
+		.offset = MTDPART_OFS_NXTBLK,
+		.size = MTDPART_SIZ_FULL
+	},
+};
+
+static struct mv643xx_eth_platform_data openrd_client_ge00_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(8),
+};
+
+static struct mv643xx_eth_platform_data openrd_client_ge01_data = {
+	.phy_addr	= MV643XX_ETH_PHY_ADDR(18),
+};
+
+static struct mv_sata_platform_data openrd_client_sata_data = {
+	.n_ports	= 2,
+};
+
+static struct mvsdio_platform_data openrd_client_mvsdio_data = {
+	.gpio_card_detect = 29,	/* MPP29 used as SD card detect */
+};
+
+static unsigned int openrd_client_mpp_config[] __initdata = {
+	MPP29_GPIO,
+	0
+};
+
+static void __init openrd_client_init(void)
+{
+	/*
+	 * Basic setup. Needs to be called early.
+	 */
+	kirkwood_init();
+	kirkwood_mpp_conf(openrd_client_mpp_config);
+
+	kirkwood_uart0_init();
+	kirkwood_nand_init(ARRAY_AND_SIZE(openrd_client_nand_parts), 25);
+
+	kirkwood_ehci_init();
+
+	/* initialize gbe0 and gbe1 */
+	kirkwood_ge00_init(&openrd_client_ge00_data);
+	kirkwood_ge01_init(&openrd_client_ge01_data);
+
+	kirkwood_sata_init(&openrd_client_sata_data);
+	kirkwood_sdio_init(&openrd_client_mvsdio_data);
+}
+
+MACHINE_START(OPENRD_CLIENT, "Marvell OpenRD Client Board")
+	/* Maintainer: Dhaval Vasa <dhaval.vasa@einfochips.com> */
+	.phys_io	= KIRKWOOD_REGS_PHYS_BASE,
+	.io_pg_offst	= ((KIRKWOOD_REGS_VIRT_BASE) >> 18) & 0xfffc,
+	.boot_params	= 0x00000100,
+	.init_machine	= openrd_client_init,
+	.map_io		= kirkwood_map_io,
+	.init_irq	= kirkwood_init_irq,
+	.timer		= &kirkwood_timer,
+MACHINE_END
-- 
1.6.3.3

-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
