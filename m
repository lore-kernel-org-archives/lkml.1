Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbYJJKuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbYJJKuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYJJKtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:49:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47557 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756205AbYJJKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:49:09 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 10/27] Blackfin Serial Driver: Fix bug - Don't call tx_stop in
	tx_transfer.
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:49:06 +0100
Message-ID: <20081010104903.31597.94354.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Disable irq and return immediately.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 8d2d757..5e20f50 100644
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
 

