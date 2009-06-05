Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZFEQbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZFEQbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZFEQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:30:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:59431 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZFEQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TA5iPVyrmBRcjep2us5ub+SqhEQz/7dU0dQxK8v21ZSZGf2qvdk9LdKTIS9Ae/GJsi
         s9EvEj6nnijHLUpTUC8jkXtMvTbj2zzSfOT+PQSsO0aoiBTV02m+qlaljWoP1x3p/Y3n
         SRDFboawYmfPWEBre1OXFwW0ESlRrYNMFsErg=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/7] MFD: ASIC3: add asic3_set_register common operation
Date: Fri,  5 Jun 2009 18:31:01 +0200
Message-Id: <1244219467-32136-2-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
References: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used to configure single bits of the SDHWCTRL_SDCONF and EXTCF_RESET/SELECT
registers needed for DS1WM, MMC/SDIO and PCMCIA functionality.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c       |   15 +++++++++++++++
 include/linux/mfd/asic3.h |   10 +++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 9e48545..ad3c591 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -52,6 +52,21 @@ static inline u32 asic3_read_register(struct asic3 *asic,
 			(reg >> asic->bus_shift));
 }
 
+void asic3_set_register(struct asic3 *asic, u32 reg, u32 bits, bool set)
+{
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	val = asic3_read_register(asic, reg);
+	if (set)
+		val |= bits;
+	else
+		val &= ~bits;
+	asic3_write_register(asic, reg, val);
+	spin_unlock_irqrestore(&asic->lock, flags);
+}
+
 /* IRQs */
 #define MAX_ASIC_ISR_LOOPS    20
 #define ASIC3_GPIO_BASE_INCR \
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 322cd6d..6b427ec 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -227,8 +227,8 @@ struct asic3_platform_data {
 
 
 /* Basic control of the SD ASIC */
-#define ASIC3_SDHWCTRL_Base	0x0E00
-#define ASIC3_SDHWCTRL_SDConf    0x00
+#define ASIC3_SDHWCTRL_BASE     0x0E00
+#define ASIC3_SDHWCTRL_SDCONF     0x00
 
 #define ASIC3_SDHWCTRL_SUSPEND    (1 << 0)  /* 1=suspend all SD operations */
 #define ASIC3_SDHWCTRL_CLKSEL     (1 << 1)  /* 1=SDICK, 0=HCLK */
@@ -242,10 +242,10 @@ struct asic3_platform_data {
 /* SD card power supply ctrl 1=enable */
 #define ASIC3_SDHWCTRL_SDPWR      (1 << 6)
 
-#define ASIC3_EXTCF_Base		0x1100
+#define ASIC3_EXTCF_BASE        0x1100
 
-#define ASIC3_EXTCF_Select         0x00
-#define ASIC3_EXTCF_Reset          0x04
+#define ASIC3_EXTCF_SELECT        0x00
+#define ASIC3_EXTCF_RESET         0x04
 
 #define ASIC3_EXTCF_SMOD0	         (1 << 0)  /* slot number of mode 0 */
 #define ASIC3_EXTCF_SMOD1	         (1 << 1)  /* slot number of mode 1 */
-- 
1.6.3.1

