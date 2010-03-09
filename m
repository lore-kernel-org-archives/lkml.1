Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0CIRWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:41 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54698 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0CIRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:31 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 07/13] serial: bfin_sport_uart: protect changes to uart_port
Date: Tue,  9 Mar 2010 12:25:34 -0500
Message-Id: <1268155540-8241-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Common serial API says we need to grab the port lock before modifying
the port state to prevent inconsistent state between threads.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_sport_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index a720e63..ba5a8b7 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -497,6 +497,8 @@ static void sport_set_termios(struct uart_port *port,
 		/* up->parib = 1; */
 	}
 
+	spin_lock_irqsave(&up->port.lock, flags);
+
 	port->read_status_mask = OE;
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= (FE | PE);
@@ -537,8 +539,6 @@ static void sport_set_termios(struct uart_port *port,
 	/* uart baud rate */
 	port->uartclk = uart_get_baud_rate(port, termios, old, 0, get_sclk()/16);
 
-	spin_lock_irqsave(&up->port.lock, flags);
-
 	/* Disable UART */
 	SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
 	SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) & ~RSPEN);
-- 
1.7.0.2

