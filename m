Return-Path: <linux-kernel-owner+w=401wt.eu-S935056AbZLKXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056AbZLKXhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbZLKXgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:33 -0500
Received: from kroah.org ([198.145.64.141]:50461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934197AbZLKX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/58] sdio_uart: Fix oops caused by the previous changeset
Date: Fri, 11 Dec 2009 15:28:11 -0800
Message-Id: <1260574122-10676-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

Now... testing reveals that the very first patch "sdio_uart: use
tty_port" causes a segmentation fault in sdio_uart_open():

Unable to handle kernel NULL pointer dereference at virtual address 00000084
pgd = dfb44000 [00000084] *pgd=1fb99031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
last sysfs file:
/sys/devices/platform/mvsdio/mmc_host/mmc0/mmc0:f111/uevent
Modules linked in:
CPU: 0    Not tainted  (2.6.32-rc5-next-20091102-00001-gb36eae9 #10)
PC is at sdio_uart_open+0x204/0x2cc
[...]

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index c2759db..671fe5e 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -608,7 +608,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 		if (!(sdio_uart_get_mctrl(port) & TIOCM_CTS))
 			tty->hw_stopped = 1;
 
-	clear_bit(TTY_IO_ERROR, &port->tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 
 	/* Kick the IRQ handler once while we're still holding the host lock */
 	sdio_uart_irq(port->func);
-- 
1.6.5.5

