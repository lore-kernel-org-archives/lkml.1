Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbYJPRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbYJPRq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbYJPRpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:45:23 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:20082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbYJPRpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=Rn2BjQEaryY4RrJydgI9o0M3MnKiz9XIAKxf/3M5pCkFRwGt6AAPPY1ozPu5dMWgiw
         pZx9wkJlcRu+IbE5waE/WTJRQ3mNATHzVHNxf3bAJYayfQP2BcuBzQqi3wrPRSCiaJCe
         r6tACSDDivBxqsEfb92aNOBoyFntSNXoe1jXM=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 8/9] Blackfin Serial Driver: fix a in dma circle rx buffer handling
Date: Fri, 17 Oct 2008 01:44:06 +0800
Message-Id: <1224179047-13073-9-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

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
1.5.6

