Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0CBXsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:36 -0500
Received: from kroah.org ([198.145.64.141]:51619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab0CBXhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Graf Yang <graf.yang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/36] serial: bfin_5xx: need to disable DMA TX interrupt too
Date: Tue,  2 Mar 2010 15:36:28 -0800
Message-Id: <1267573003-782-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

If we don't disable the DMA TX channel, an inopportune timeout will
trigger the interrupt handler and may cause a dead lock with the spin_lock.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

