Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYFFQNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYFFQNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbYFFQMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:23 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39478 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbYFFQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:19 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 6/8] avr32: atmel_nand platform code for AT32AP700x
Date: Fri,  6 Jun 2008 18:04:56 +0200
Message-Id: <1212768298-13614-7-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0498 (UTC) FILETIME=[FA4440A0:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function initializes and adds a platform_device for a NAND flash
interface on SMC chip select 3.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c   |   52 +++++++++++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/board.h |   13 ++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0f24b4f..b65d3e0 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1730,6 +1730,58 @@ fail:
 #endif
 
 /* --------------------------------------------------------------------
+ * NAND Flash / SmartMedia
+ * -------------------------------------------------------------------- */
+static struct resource smc_cs3_resource[] __initdata = {
+	{
+		.start	= 0x0c000000,
+		.end	= 0x0fffffff,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.start	= 0xfff03c00,
+		.end	= 0xfff03fff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device *__init
+at32_add_device_nand(unsigned int id, struct atmel_nand_data *data)
+{
+	struct platform_device *pdev;
+
+	if (id != 0 || !data)
+		return NULL;
+
+	pdev = platform_device_alloc("atmel_nand", id);
+	if (!pdev)
+		goto fail;
+
+	if (platform_device_add_resources(pdev, smc_cs3_resource,
+				ARRAY_SIZE(smc_cs3_resource)))
+		goto fail;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct atmel_nand_data)))
+		goto fail;
+
+	set_ebi_sfr_bits(HMATRIX_BIT(CS3A));
+	if (data->enable_pin)
+		at32_select_gpio(data->enable_pin,
+				AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
+	if (data->rdy_pin)
+		at32_select_gpio(data->rdy_pin, 0);
+	if (data->det_pin)
+		at32_select_gpio(data->det_pin, 0);
+
+	platform_device_add(pdev);
+	return pdev;
+
+fail:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
  * AC97C
  * -------------------------------------------------------------------- */
 static struct resource atmel_ac97c0_resource[] __initdata = {
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index a4e2d28..cc5906c 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -85,4 +85,17 @@ struct platform_device *
 at32_add_device_cf(unsigned int id, unsigned int extint,
 		struct cf_platform_data *data);
 
+/* NAND / SmartMedia */
+struct atmel_nand_data {
+	int	enable_pin;	/* chip enable */
+	int	det_pin;	/* card detect */
+	int	rdy_pin;	/* ready/busy */
+	u8	ale;		/* address line number connected to ALE */
+	u8	cle;		/* address line number connected to CLE */
+	u8	bus_width_16;	/* buswidth is 16 bit */
+	struct mtd_partition *(*partition_info)(int size, int *num_partitions);
+};
+struct platform_device *
+at32_add_device_nand(unsigned int id, struct atmel_nand_data *data);
+
 #endif /* __ASM_ARCH_BOARD_H */
-- 
1.5.5.1

