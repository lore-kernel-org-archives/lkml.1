Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380Ab0ASLNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0ASLNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394Ab0ASLNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:13:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40538 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab0ASLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:13:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Graf Yang <graf.yang@analog.com>
Subject: [PATCH 2/4] serial: bfin_5xx: need to disable DMA TX interrupt too
Date: Tue, 19 Jan 2010 06:13:11 -0500
Message-Id: <1263899593-12178-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
References: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

If we don't disable the DMA TX channel, an inopportune timeout will
trigger the interrupt handler and may cause a dead lock with the spin_lock.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 15843cc..b5a9b37 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -488,6 +488,7 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
 	int x_pos, pos;
 
+	dma_disable_irq(uart->tx_dma_channel);
 	dma_disable_irq(uart->rx_dma_channel);
 	spin_lock_bh(&uart->port.lock);
 
@@ -521,6 +522,7 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 	}
 
 	spin_unlock_bh(&uart->port.lock);
+	dma_enable_irq(uart->tx_dma_channel);
 	dma_enable_irq(uart->rx_dma_channel);
 
 	mod_timer(&(uart->rx_dma_timer), jiffies + DMA_RX_FLUSH_JIFFIES);
-- 
1.6.6

