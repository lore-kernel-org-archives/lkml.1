Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbZLKXgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbZLKXgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbZLKXgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:09 -0500
Received: from kroah.org ([198.145.64.141]:50441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934338AbZLKX3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/58] tty: sdio_uart: Fix the locking on "func" for new code
Date: Fri, 11 Dec 2009 15:28:18 -0800
Message-Id: <1260574122-10676-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The new dtr_rts function didn't take the port->func lock as it should
so add use of the lock there.


Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 2a13db5..f537555 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -603,10 +603,14 @@ static void uart_dtr_rts(struct tty_port *tport, int onoff)
 {
 	struct sdio_uart_port *port =
 			container_of(tport, struct sdio_uart_port, port);
+	int ret = sdio_uart_claim_func(port);
+	if (ret)
+		return;
 	if (onoff == 0)
 		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	else
 		sdio_uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+	sdio_uart_release_func(port);
 }
 
 /**
-- 
1.6.5.5

