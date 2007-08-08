Return-Path: <linux-kernel-owner+w=401wt.eu-S935501AbXHHDf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935501AbXHHDf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932625AbXHHDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:35:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18048 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623AbXHHDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:47 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="47739374:sNHT27380556"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 03/12] Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
Date: Wed,  8 Aug 2007 11:35:28 +0800
Message-Id: <11865441393158-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_gpio.c          |   19 +++++++++------
 include/asm-blackfin/mach-bf537/portmux.h |   35 ++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 9f30948..5d488ef 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -180,11 +180,13 @@ static int cmp_label(unsigned short ident, const char *label)
 #ifdef BF537_FAMILY
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
-	if (usage == GPIO_USAGE) {
-		*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
-	} else
-		*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
-	SSYNC();
+	if (!check_gpio(gpio)) {
+		if (usage == GPIO_USAGE) {
+			*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+		} else
+			*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
+		SSYNC();
+	}
 }
 #else
 # define port_setup(...)  do { } while (0)
@@ -644,11 +646,10 @@ int peripheral_request(unsigned short per, const char *label)
 	if (!(per & P_DEFINED))
 		return -ENODEV;
 
-	if (check_gpio(ident) < 0)
-		return -EINVAL;
-
 	local_irq_save(flags);
 
+	if (!check_gpio(ident)) {
+
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
 		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
@@ -658,6 +659,8 @@ int peripheral_request(unsigned short per, const char *label)
 		return -EBUSY;
 	}
 
+	}
+
 	if (unlikely(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident))) {
 
 	/*
diff --git a/include/asm-blackfin/mach-bf537/portmux.h b/include/asm-blackfin/mach-bf537/portmux.h
index 7daa247..ae6c53b 100644
--- a/include/asm-blackfin/mach-bf537/portmux.h
+++ b/include/asm-blackfin/mach-bf537/portmux.h
@@ -106,4 +106,37 @@
 #define P_SPI0_SSEL2	(P_DEFINED | P_IDENT(PORT_PJ11) | P_FUNCT(1))
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(PORT_PJ5) | P_FUNCT(2))
 
-#endif				/* _MACH_PORTMUX_H_ */
+#define P_MII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxD2, \
+	P_MII0_ETxD3, \
+	P_MII0_ETxEN, \
+	P_MII0_TxCLK, \
+	P_MII0_PHYINT, \
+	P_MII0_COL, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxD2, \
+	P_MII0_ERxD3, \
+	P_MII0_ERxDV, \
+	P_MII0_ERxCLK, \
+	P_MII0_ERxER, \
+	P_MII0_CRS, \
+	P_MDC, \
+	P_MDIO, 0}
+
+
+#define P_RMII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxEN, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxER, \
+	P_RMII0_REF_CLK, \
+	P_RMII0_MDINT, \
+	P_RMII0_CRS_DV, \
+	P_MDC, \
+	P_MDIO, 0}
+#endif			        	/* _MACH_PORTMUX_H_ */
-- 
1.5.2
