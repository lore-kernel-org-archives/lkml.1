Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZHPOv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZHPOv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHPOv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:51:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:38813 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZHPOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=StMBrMo1AQGyAS60IJteCjy6cu6K3lR5OWZG3TFg/DzNaRf9zC4sh+sVjubOvn4pqZ
         Tpabpbat6FJfdry5rdfpe2D6nW00dNSTF+f57LV7jAaOuuOhU83ltap6tSlQDayUXIze
         8utVRXYsduJySPMuW7UbVVXdM99w9iUfP03yg=
Message-ID: <4A881D08.4020202@gmail.com>
Date: Sun, 16 Aug 2009 22:51:52 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: modify mfp-w90p910.c and add mfp.h to w90x900 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

To rename, modify mfp-w90p910.c and add mfp.h for
'extern', duo to some drivers need the functions of
mfp.c frequently, so it is better that inlcuding
this header file in driver c file directly rather
than for the 'extern' to have to create specific
driver header file.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/Makefile                 |    4 +-
 arch/arm/mach-w90x900/include/mach/mfp.h       |   19 ++++++++++++
 arch/arm/mach-w90x900/{mfp-w90p910.c => mfp.c} |   38 ++++++++++++------------
 3 files changed, 40 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/include/mach/mfp.h
 rename arch/arm/mach-w90x900/{mfp-w90p910.c => mfp.c} (77%)

diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index 093c5da..4591bb4 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -5,10 +5,10 @@
 # Object file lists.
 
 obj-y				:= irq.o time.o gpio.o clock.o cpu.o dev.o
-obj-y				+= clksel.o
+obj-y				+= clksel.o mfp.o
 # W90X900 CPU support files
 
-obj-$(CONFIG_CPU_W90P910)	+= w90p910.o mfp-w90p910.o
+obj-$(CONFIG_CPU_W90P910)	+= w90p910.o
 obj-$(CONFIG_CPU_NUC950)	+= nuc950.o
 obj-$(CONFIG_CPU_NUC960)	+= nuc960.o
 
diff --git a/arch/arm/mach-w90x900/include/mach/mfp.h b/arch/arm/mach-w90x900/include/mach/mfp.h
new file mode 100644
index 0000000..6d47d53
--- /dev/null
+++ b/arch/arm/mach-w90x900/include/mach/mfp.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/mfp.h
+ *
+ * Copyright (c) 2009 Nuvoton corporation
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+/* extern function from mfp.c */
+
+extern void mfp_set_groupf(struct device *dev);
+extern void mfp_set_groupc(struct device *dev);
+extern void mfp_set_groupi(struct device *dev);
+extern void mfp_set_groupg(struct device *dev);
diff --git a/arch/arm/mach-w90x900/mfp-w90p910.c b/arch/arm/mach-w90x900/mfp.c
similarity index 77%
rename from arch/arm/mach-w90x900/mfp-w90p910.c
rename to arch/arm/mach-w90x900/mfp.c
index 4533098..a47dc9a 100644
--- a/arch/arm/mach-w90x900/mfp-w90p910.c
+++ b/arch/arm/mach-w90x900/mfp.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-w90x900/mfp-w90p910.c
+ * linux/arch/arm/mach-w90x900/mfp.c
  *
  * Copyright (c) 2008 Nuvoton technology corporation
  *
@@ -55,7 +55,7 @@ void mfp_set_groupf(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-emc") == 0)
+	if (strcmp(dev_id, "nuc900-emc") == 0)
 		mfpen |= GPSELF;/*enable mac*/
 	else
 		mfpen &= ~GPSELF;/*GPIOF[9:0]*/
@@ -79,16 +79,16 @@ void mfp_set_groupc(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-lcd") == 0)
+	if (strcmp(dev_id, "nuc900-lcd") == 0)
 		mfpen |= GPSELC;/*enable lcd*/
-	else if (strcmp(dev_id, "w90p910-kpi") == 0) {
-			mfpen &= (~GPSELC);/*enable kpi*/
-			mfpen |= ENKPI;
-		} else if (strcmp(dev_id, "w90p910-nand") == 0) {
-				mfpen &= (~GPSELC);/*enable nand*/
-				mfpen |= ENNAND;
-			} else
-				mfpen &= (~GPSELC);/*GPIOC[14:0]*/
+	else if (strcmp(dev_id, "nuc900-kpi") == 0) {
+		mfpen &= (~GPSELC);/*enable kpi*/
+		mfpen |= ENKPI;
+	} else if (strcmp(dev_id, "nuc900-nand") == 0) {
+		mfpen &= (~GPSELC);/*enable nand*/
+		mfpen |= ENNAND;
+	} else
+		mfpen &= (~GPSELC);/*GPIOC[14:0]*/
 
 	__raw_writel(mfpen, REG_MFSEL);
 
@@ -111,12 +111,12 @@ void mfp_set_groupi(struct device *dev)
 
 	mfpen &= ~GPSELEI1;/*default gpio16*/
 
-	if (strcmp(dev_id, "w90p910-wdog") == 0)
+	if (strcmp(dev_id, "nuc900-wdog") == 0)
 		mfpen |= GPSELEI1;/*enable wdog*/
-		else if (strcmp(dev_id, "w90p910-atapi") == 0)
-			mfpen |= GPSELEI0;/*enable atapi*/
-			else if (strcmp(dev_id, "w90p910-keypad") == 0)
-				mfpen &= ~GPSELEI0;/*enable keypad*/
+	else if (strcmp(dev_id, "nuc900-atapi") == 0)
+		mfpen |= GPSELEI0;/*enable atapi*/
+	else if (strcmp(dev_id, "nuc900-keypad") == 0)
+		mfpen &= ~GPSELEI0;/*enable keypad*/
 
 	__raw_writel(mfpen, REG_MFSEL);
 
@@ -137,13 +137,13 @@ void mfp_set_groupg(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-spi") == 0) {
+	if (strcmp(dev_id, "nuc900-spi") == 0) {
 		mfpen &= ~(GPIOG0TO1 | GPIOG2TO3);
 		mfpen |= ENSPI;/*enable spi*/
-	} else if (strcmp(dev_id, "w90p910-i2c0") == 0) {
+	} else if (strcmp(dev_id, "nuc900-i2c0") == 0) {
 		mfpen &= ~(GPIOG0TO1);
 		mfpen |= ENI2C0;/*enable i2c0*/
-	} else if (strcmp(dev_id, "w90p910-i2c1") == 0) {
+	} else if (strcmp(dev_id, "nuc900-i2c1") == 0) {
 		mfpen &= ~(GPIOG2TO3);
 		mfpen |= ENI2C1;/*enable i2c1*/
 	} else {
-- 
1.5.6.3
