Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZIULCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZIULCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZIULCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:02:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32786 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZIULCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:02:07 -0400
X-IronPort-AV: E=Sophos;i="4.44,424,1249272000"; 
   d="scan'208";a="4697764"
Subject: [PATCH] [bfin-sport-uart] The waiting loop to stop SPORT TX from
	TX interrupt is too long
From: sonic zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 19:02:53 +0800
Message-ID: <1253530973.22138.16.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The waiting loop to stop SPORT TX from TX interrupt is
too long. This may block SPORT RX interrupts and cause
RX FIFO overflow. So, do stop sport TX only after the last
char in TX FIFO is moved into the shift register.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/serial/bfin_sport_uart.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index c108b1a..fb9f7cd 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -303,7 +303,13 @@ static void sport_uart_tx_chars(struct sport_uart_port *up)
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
-		sport_stop_tx(&up->port);
+		/* The waiting loop to stop SPORT TX from TX interrupt is
+		 * too long. This may block SPORT RX interrupts and cause
+		 * RX FIFO overflow. So, do stop sport TX only after the last
+		 * char in TX FIFO is moved into the shift register.
+		 */
+		if (SPORT_GET_STAT(up) & TXHRE)
+			sport_stop_tx(&up->port);
 		return;
 	}
 
-- 
1.6.0



