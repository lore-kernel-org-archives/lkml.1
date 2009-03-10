Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCJJoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCJJoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZCJJoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:44:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9786 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZCJJoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:44:14 -0400
X-IronPort-AV: E=Sophos;i="4.38,335,1233550800"; 
   d="scan'208";a="67624046"
Subject: [PATCH 03/18] Blackfin Serial Driver: fix a bug in dma circle rx
	buffer handling - v2
From: sonic zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 17:49:29 +0800
Message-Id: <1236678569.28294.3.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rx buffer tail index may increase to UART_XMIT_SIZE, which is not a valid
index, at the beginning of the Loop. The exit check should happen after this
index is adjusted properly.

Reported-by: Qian Zhang <zhangq@sansitech.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 350bfc4..1e027e3 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -402,9 +402,11 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 	else
 		flg = TTY_NORMAL;
 
-	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
+	for (i = uart->rx_dma_buf.tail; ; i++) {
 		if (i >= UART_XMIT_SIZE)
 			i = 0;
+		if (i == uart->rx_dma_buf.head)
+			break;
 		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
 			uart_insert_char(&uart->port, status, OE,
 				uart->rx_dma_buf.buf[i], flg);
-- 
1.6.0


