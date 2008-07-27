Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYG0GGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYG0GGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYG0GGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:06:38 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:23514 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYG0GGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=MXad0JR4KySc0V2kepF23APpek7rowpvMc1KVGOnGQH4fVhc1uYa/BZq2Ni5Dh9Qde
         6bsDBx3L54uIXUyepk9US3Il/f3xWr0F3k5rV1sGDlkqZEixRnlG4qUVS3SRDPCxafUD
         nOOlRdUz7MnOFCYaMfJSzXfETK6m6NgHiZPfE=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/8] Blackfin Serial Driver: Fix bug - Don't call tx_stop in tx_transfer.
Date: Sun, 27 Jul 2008 14:04:05 +0800
Message-Id: <1217138647-18227-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Disable irq and return immediately.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 31fc8e1..afeff9f 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -301,7 +301,11 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 	bfin_serial_mctrl_check(uart);
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
-		bfin_serial_stop_tx(&uart->port);
+#ifdef CONFIG_BF54x
+		/* Clear TFI bit */
+		UART_PUT_LSR(uart, TFI);
+#endif
+		UART_CLEAR_IER(uart, ETBEI);
 		return;
 	}
 
-- 
1.5.6

