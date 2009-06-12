Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbZFLRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbZFLRe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763289AbZFLReq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:34:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59190 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763074AbZFLRem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:34:42 -0400
From: Vikram Pandita <vikram.pandita@ti.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Vikram Pandita <vikram.pandita@ti.com>
Subject: [PATCH] serial: 8250: add IRQ trigger support
Date: Fri, 12 Jun 2009 12:32:51 -0500
Message-Id: <1244827971-14981-1-git-send-email-vikram.pandita@ti.com>
X-Mailer: git-send-email 1.6.0.3.613.g9f8f13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no provision for passing IRQ trigger flags for
serial IRQs with triggering requirements (such as GPIO IRQs.)

This patch adds UPF_IRQ_TRIG_* flags which map on to IRQF_TRIGGER_*
flags.

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/serial/8250.c       |   10 ++++++++++
 include/linux/serial_core.h |    4 ++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index bab115e..8235ef5 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1641,6 +1641,16 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 	struct irq_info *i;
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	/* Get IRQ Trigger Flag */
+	if (up->port.flags & UPF_IRQ_TRIG_RISING)
+		irq_flags |= IRQF_TRIGGER_RISING;
+	else if (up->port.flags & UPF_IRQ_TRIG_FALLING)
+		irq_flags |= IRQF_TRIGGER_FALLING;
+	else if (up->port.flags & UPF_IRQ_TRIG_HIGH)
+		irq_flags |= IRQF_TRIGGER_HIGH;
+	else if (up->port.flags & UPF_IRQ_TRIG_LOW)
+		irq_flags |= IRQF_TRIGGER_LOW;
+
 	mutex_lock(&hash_mutex);
 
 	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 57a97e5..07591d5 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -296,7 +296,11 @@ struct uart_port {
 #define UPF_SPD_WARP		((__force upf_t) (0x1010))
 #define UPF_SKIP_TEST		((__force upf_t) (1 << 6))
 #define UPF_AUTO_IRQ		((__force upf_t) (1 << 7))
+#define UPF_IRQ_TRIG_RISING	((__force upf_t) (1 << 8))
+#define UPF_IRQ_TRIG_FALLING	((__force upf_t) (1 << 9))
+#define UPF_IRQ_TRIG_HIGH	((__force upf_t) (1 << 10))
 #define UPF_HARDPPS_CD		((__force upf_t) (1 << 11))
+#define UPF_IRQ_TRIG_LOW	((__force upf_t) (1 << 12))
 #define UPF_LOW_LATENCY		((__force upf_t) (1 << 13))
 #define UPF_BUGGY_UART		((__force upf_t) (1 << 14))
 #define UPF_NO_TXEN_TEST	((__force upf_t) (1 << 15))
-- 
1.6.0.3.613.g9f8f13

