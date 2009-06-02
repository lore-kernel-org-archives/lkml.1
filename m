Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbZFBHOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbZFBHOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759838AbZFBHL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46644 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbZFBHLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 11/11] Blackfin Serial Driver: disable dma rx interrupt only rather than all irqs
Date: Tue,  2 Jun 2009 03:11:40 -0400
Message-Id: <1243926700-30485-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The UART RX handling code isn't exactly speeding, so don't go disabling
all interrupts when processing the buffer.  Just disable the relevant DMA
interrupt.  This greatly improves latency of the system when utilizing the
UART.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 64603f5..e2f6b1b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -479,9 +479,9 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
 	int x_pos, pos;
-	unsigned long flags;
 
-	spin_lock_irqsave(&uart->port.lock, flags);
+	dma_disable_irq(uart->rx_dma_channel);
+	spin_lock_bh(&uart->port.lock);
 
 	/* 2D DMA RX buffer ring is used. Because curr_y_count and
 	 * curr_x_count can't be read as an atomic operation,
@@ -512,7 +512,8 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
 	}
 
-	spin_unlock_irqrestore(&uart->port.lock, flags);
+	spin_unlock_bh(&uart->port.lock);
+	dma_enable_irq(uart->rx_dma_channel);
 
 	mod_timer(&(uart->rx_dma_timer), jiffies + DMA_RX_FLUSH_JIFFIES);
 }
-- 
1.6.3.1

