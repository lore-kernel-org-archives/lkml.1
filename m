Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbYA3Jf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbYA3Jf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbYA3Jao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:44 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:63088 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbYA3JaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:24 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624093"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 12/12] [Blackfin] serial driver: Fix bug Poll RTS/CTS status in DMA mode as well
Date: Wed, 30 Jan 2008 17:30:12 +0800
Message-Id: <1201685412-29095-13-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3858

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c                         |   16 +++++-----------
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |    3 +--
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |    2 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |    3 +--
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |    3 +--
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |    2 +-
 6 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a07df53..af866ab 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -53,7 +53,6 @@
 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
 #else
-static void bfin_serial_do_work(struct work_struct *work);
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 #endif
 
@@ -372,8 +371,9 @@ static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 
 	return IRQ_HANDLED;
 }
+#endif
 
-
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 static void bfin_serial_do_work(struct work_struct *work)
 {
 	struct bfin_serial_port *uart = container_of(work, struct bfin_serial_port, cts_workqueue);
@@ -607,22 +607,17 @@ static void bfin_serial_mctrl_check(struct bfin_serial_port *uart)
 {
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	unsigned int status;
-# ifdef CONFIG_SERIAL_BFIN_DMA
 	struct uart_info *info = uart->port.info;
 	struct tty_struct *tty = info->tty;
 
 	status = bfin_serial_get_mctrl(&uart->port);
+	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
 	if (!(status & TIOCM_CTS)) {
 		tty->hw_stopped = 1;
+		schedule_work(&uart->cts_workqueue);
 	} else {
 		tty->hw_stopped = 0;
 	}
-# else
-	status = bfin_serial_get_mctrl(&uart->port);
-	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-	if (!(status & TIOCM_CTS))
-		schedule_work(&uart->cts_workqueue);
-# endif
 #endif
 }
 
@@ -939,10 +934,9 @@ static void __init bfin_serial_init_ports(void)
 		bfin_serial_ports[i].rx_dma_channel =
 			bfin_serial_resource[i].uart_rx_dma_channel;
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
-#else
-		INIT_WORK(&bfin_serial_ports[i].cts_workqueue, bfin_serial_do_work);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+		INIT_WORK(&bfin_serial_ports[i].cts_workqueue, bfin_serial_do_work);
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index 233c585..c0694ec 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -67,10 +67,9 @@ struct bfin_serial_port {
 	unsigned int tx_dma_channel;
 	unsigned int rx_dma_channel;
 	struct work_struct tx_dma_workqueue;
-#else
-	struct work_struct cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct cts_workqueue;
 	int cts_pin;
 	int rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index a1b4f4e..b6f513b 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -56,12 +56,12 @@ struct bfin_serial_port {
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
 #else
-	struct work_struct 	cts_workqueue;
 # if ANOMALY_05000230
 	unsigned int anomaly_threshold;
 # endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int			cts_pin;
 	int			rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index f18c517..8fc672d 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -67,10 +67,9 @@ struct bfin_serial_port {
 	unsigned int		tx_dma_channel;
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
-#else
-	struct work_struct 	cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 8733d47..c459c48 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -69,10 +69,9 @@ struct bfin_serial_port {
 	unsigned int		tx_dma_channel;
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
-#else
-	struct work_struct 	cts_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index a1b4f4e..b6f513b 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -56,12 +56,12 @@ struct bfin_serial_port {
 	unsigned int		rx_dma_channel;
 	struct work_struct	tx_dma_workqueue;
 #else
-	struct work_struct 	cts_workqueue;
 # if ANOMALY_05000230
 	unsigned int anomaly_threshold;
 # endif
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct work_struct 	cts_workqueue;
 	int			cts_pin;
 	int			rts_pin;
 #endif
-- 
1.5.3.4
