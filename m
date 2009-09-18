Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZIRJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZIRJEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZIRJEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:04:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:20309 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZIRJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:04:48 -0400
X-IronPort-AV: E=Sophos;i="4.44,408,1249272000"; 
   d="scan'208";a="4605749"
Subject: [PATCH][bfin-sport-uart] Walk around RX underflow hardware issue
	in 32-bit SPORT RX reading
From: sonic zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 17:05:47 +0800
Message-ID: <1253264747.22138.2.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable local interrupts in 32-bit reading from SPORT RX MMR to walk
around the RX underflow hardware issue when this reading is interrupted
by the other IRQ.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/serial/bfin_sport_uart.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 671d41c..46e793e 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -43,7 +43,20 @@
 #define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
 #define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
 #define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
-#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+/*
+ * Disable local interrupt to walk around the fake RX underflow error
+ * when do 32-bit reading from RX fifois interrupted by other interrupt.
+ * This is a possible hardware anomaly. After it is logged officially,
+ * the official anomaly id should be listed bellow.
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



