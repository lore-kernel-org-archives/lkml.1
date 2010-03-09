Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0CIRYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:24:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54657 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab0CIRWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:25 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 01/13] serial: bfin_sport_uart: work around anomaly 05000473 (make 32bit fifo read atomic)
Date: Tue,  9 Mar 2010 12:25:28 -0500
Message-Id: <1268155540-8241-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

We cannot let a 32-bit RX FIFO read be interrupted otherwise a fake RX
underflow error might be generated.

URL: http://blackfin.uclinux.org/gf/tracker/5145
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index abe0361..9791fcc 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -37,7 +37,21 @@
 #define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
 #define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
 #define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
-#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+/*
+ * If another interrupt fires while doing a 32-bit read from RX FIFO,
+ * a fake RX underflow error will be generated.  So disable interrupts
+ * to prevent interruption while reading the FIFO.
+ */
+#define SPORT_GET_RX32(sport) \
+({ \
+	unsigned int __ret; \
+	if (ANOMALY_05000473) \
+		local_irq_disable(); \
+	__ret = bfin_read32((sport)->port.membase + OFFSET_RX); \
+	if (ANOMALY_05000473) \
+		local_irq_enable(); \
+	__ret; \
+})
 #define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
 #define SPORT_GET_RCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR2))
 #define SPORT_GET_RCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_RCLKDIV))
-- 
1.7.0.2

