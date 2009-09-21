Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZIUELR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZIUELR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 00:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZIUELP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 00:11:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36451 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZIUELO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 00:11:14 -0400
X-IronPort-AV: E=Sophos;i="4.44,422,1249272000"; 
   d="scan'208";a="6608320"
Subject: [PATCH v2][bfin-sport-uart] Walk around RX underflow hardware
	issue in 32-bit SPORT RX reading
From: sonic zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 12:11:58 +0800
Message-ID: <1253506318.22138.13.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If another interrupt fires while doing a 32-bit read from RX FIFO,
a fake RX underflow error will be generated.  So disable interrupts
to prevent interruption while reading the FIFO.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/serial/bfin_sport_uart.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 671d41c..f4e5a83 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -43,7 +43,21 @@
 #define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
 #define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
 #define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
-#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+/*
+ * If another interrupt fires while doing a 32-bit read from RX FIFO,
+ * a fake RX underflow error will be generated.  So disable interrupts
+ * to prevent interruption while reading the FIFO.
+ * Once hardware design can root cause and officially log this, we can
+ * update the code to use a standard ANOMALY_XXX define.
+ */
+#define SPORT_GET_RX32(sport)  \
+({                             \
+	unsigned int __ret;             \
+	local_irq_disable();    \
+	__ret = bfin_read32(((sport)->port.membase + OFFSET_RX));       \
+	local_irq_enable();     \
+	__ret;                  \
+})
 #define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
 #define SPORT_GET_RCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR2))
 #define SPORT_GET_RCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_RCLKDIV))
-- 
1.6.0



