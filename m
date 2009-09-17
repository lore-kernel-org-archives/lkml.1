Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZIQVxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZIQVxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIQVw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:52:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49471 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZIQVw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:52:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graf Yang <graf.yang@analog.com>
Subject: [PATCH 2/4] serial: bfin_5xx: need to disable DMA TX interrupt too
Date: Thu, 17 Sep 2009 17:52:26 -0400
Message-Id: <1253224348-6996-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253224348-6996-1-git-send-email-vapier@gentoo.org>
References: <1253224348-6996-1-git-send-email-vapier@gentoo.org>
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
index 1b7fd62..663fec1 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -484,6 +484,7 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
 	int x_pos, pos;
 
+	dma_disable_irq(uart->tx_dma_channel);
 	dma_disable_irq(uart->rx_dma_channel);
 	spin_lock_bh(&uart->port.lock);
 
@@ -517,6 +518,7 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 	}
 
 	spin_unlock_bh(&uart->port.lock);
+	dma_enable_irq(uart->tx_dma_channel);
 	dma_enable_irq(uart->rx_dma_channel);
 
 	mod_timer(&(uart->rx_dma_timer), jiffies + DMA_RX_FLUSH_JIFFIES);
-- 
1.6.5.rc1

