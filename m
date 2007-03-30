Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbXC3DHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbXC3DHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXC3DHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:07:51 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:47478 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbXC3DHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:07:50 -0400
X-IronPort-AV: i="4.14,350,1170651600"; 
   d="scan'208"; a="25878600:sNHT27629112"
Subject: [PATCH] blackfin arch fix bug interrupt setup problem request_irq:
	set_gpio_dir called before gpio_request
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 30 Mar 2007 11:08:46 +0800
Message-Id: <1175224126.15391.50.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/ints-priority-dc.c |   36 +++++++++++++++++++-----
 arch/blackfin/mach-common/ints-priority-sc.c |   38 +++++++++++++++++++++-----
 include/asm-blackfin/gpio.h                  |    6 ++--
 3 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority-dc.c b/arch/blackfin/mach-common/ints-priority-dc.c
index 01fd688..039191c 100644
--- a/arch/blackfin/mach-common/ints-priority-dc.c
+++ b/arch/blackfin/mach-common/ints-priority-dc.c
@@ -217,11 +217,18 @@ static void bf561_gpio_unmask_irq(unsigned int irq)
 static unsigned int bf561_gpio_irq_startup(unsigned int irq)
 {
 	unsigned int ret;
+	u16 gpionr = irq - IRQ_PF0;
+
+	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+			
+		ret = gpio_request(gpionr, NULL);
+		if(ret)
+			return ret;
 
-	ret = gpio_request(irq - IRQ_PF0, NULL);
+	}		
 
-	if (!ret)
-	  bf561_gpio_unmask_irq(irq);
+	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	bf561_gpio_unmask_irq(irq);
 
   return ret;
 
@@ -231,15 +238,15 @@ static void bf561_gpio_irq_shutdown(unsigned int irq)
 {
 	bf561_gpio_mask_irq(irq);
 	gpio_free(irq - IRQ_PF0);
+	gpio_enabled[gpio_bank(irq - IRQ_PF0)] &= ~gpio_bit(irq - IRQ_PF0);
 }
 
 static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 {
 
+	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
 
 		if (type == IRQ_TYPE_PROBE) {
 			/* only probe unenabled GPIO interrupt lines */
@@ -250,11 +257,26 @@ static int bf561_gpio_irq_type(unsigned int irq, unsigned int type)
 		}
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+
+		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+			
+			ret = gpio_request(gpionr, NULL);
+			if(ret)
+				return ret;
+
+		}
 
 			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		else
+		} else {
 			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+			return 0;		
+		}
+
+
+		set_gpio_dir(gpionr, 0);
+		set_gpio_inen(gpionr, 1);
+
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index 8b9e68b..8197a32 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -326,11 +326,18 @@ static void bfin_gpio_unmask_irq(unsigned int irq)
 static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 {
 	unsigned int ret;
+	u16 gpionr = irq - IRQ_PF0;
+
+	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+			
+		ret = gpio_request(gpionr, NULL);
+		if(ret)
+			return ret;
 
-	ret = gpio_request(irq - IRQ_PF0, NULL);
+	}		
 
-	if (!ret)
-		bfin_gpio_unmask_irq(irq);
+	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	bfin_gpio_unmask_irq(irq);
 
 	return ret;
 }
@@ -339,14 +346,15 @@ static void bfin_gpio_irq_shutdown(unsigned int irq)
 {
 	bfin_gpio_mask_irq(irq);
 	gpio_free(irq - IRQ_PF0);
+	gpio_enabled[gpio_bank(irq - IRQ_PF0)] &= ~gpio_bit(irq - IRQ_PF0);
 }
 
 static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 {
+
+	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
 
 		if (type == IRQ_TYPE_PROBE) {
 			/* only probe unenabled GPIO interrupt lines */
@@ -357,10 +365,26 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 		}
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+
+		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
+			
+			ret = gpio_request(gpionr, NULL);
+			if(ret)
+				return ret;
+
+		}
+
 			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		else
+		} else {
 			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+			return 0;		
+		}
+
+
+		set_gpio_dir(gpionr, 0);
+		set_gpio_inen(gpionr, 1);
+
 
 		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 06dd9cd..14db45f 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -85,9 +85,9 @@
 #ifndef __ARCH_BLACKFIN_GPIO_H__
 #define __ARCH_BLACKFIN_GPIO_H__
 
-#define gpio_bank(x) (x >> 4)
-#define gpio_bit(x)  (1<<(x & 0xF))
-#define gpio_sub_n(x) (x & 0xF)
+#define gpio_bank(x) ((x) >> 4)
+#define gpio_bit(x)  (1<<((x) & 0xF))
+#define gpio_sub_n(x) ((x) & 0xF)
 
 #define GPIO_BANKSIZE 16
 
-- 
1.5.0.5

