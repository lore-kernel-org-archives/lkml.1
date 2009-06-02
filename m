Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbZFBHNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbZFBHNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbZFBHLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46633 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZFBHLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 08/11] Blackfin Serial Driver: handle irregular DMA register status in auto start mode
Date: Tue,  2 Jun 2009 03:11:37 -0400
Message-Id: <1243926700-30485-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

This bug is caused by irregular behavior of DMA register CURR_X_COUNT
and CURR_Y_COUNT when an auto restart uart rx DMA run to last byte in
DMA buffer, trigger the interrupt and stay at this possiton. The status
of current x and y is 0:7 instead of 512:8 or 0:8. The driver doesn't
take care of this case when calculating the position.

URL: http://blackfin.uclinux.org/gf/tracker/5063
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Reported-by: Tomasz Motylewski <t.motylewski@bfad.de>
---
 drivers/serial/bfin_5xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 676efda..854e96d 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -490,7 +490,7 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
 	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
 	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
-	if (uart->rx_dma_nrows == DMA_RX_YCOUNT)
+	if (uart->rx_dma_nrows == DMA_RX_YCOUNT || x_pos == 0)
 		uart->rx_dma_nrows = 0;
 	x_pos = DMA_RX_XCOUNT - x_pos;
 	if (x_pos == DMA_RX_XCOUNT)
@@ -546,15 +546,16 @@ static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 	unsigned short irqstat;
-	int pos;
+	int x_pos, pos;
 
 	spin_lock(&uart->port.lock);
 	irqstat = get_dma_curr_irqstat(uart->rx_dma_channel);
 	clear_dma_irqstat(uart->rx_dma_channel);
 
 	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
+	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
 	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
-	if (uart->rx_dma_nrows == DMA_RX_YCOUNT)
+	if (uart->rx_dma_nrows == DMA_RX_YCOUNT || x_pos == 0)
 		uart->rx_dma_nrows = 0;
 
 	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT;
-- 
1.6.3.1

