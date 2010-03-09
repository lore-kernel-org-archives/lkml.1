Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0CIRWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54666 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0CIRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 02/13] serial: bfin_sport_uart: shorten the SPORT TX waiting loop
Date: Tue,  9 Mar 2010 12:25:29 -0500
Message-Id: <1268155540-8241-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The waiting loop to stop SPORT TX from TX interrupt is too long.  This may
block the SPORT RX interrupts and cause the RX FIFO to overflow. So, do
stop sport TX only after the last char in TX FIFO is moved into the shift
register.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 7c72888..c34f02c 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -270,7 +270,13 @@ static void sport_uart_tx_chars(struct sport_uart_port *up)
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
1.7.0.2

