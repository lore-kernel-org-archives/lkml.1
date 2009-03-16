Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZCPLF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZCPLF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZCPLFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:05:50 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49022 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbZCPLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:05:50 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: mxser, remove tty_port_tty_get from mxser_check_modem_status
Date: Mon, 16 Mar 2009 12:04:57 +0100
Message-Id: <1237201497-12577-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_check_modem_status is called with tty parameter, so the
reference should be increased by callers already -- for ioctl
syscall it is held whole time gap since open to close, for
interrupt, the reference count is increased in the irq handler.

There is no tty_kref_put in that function, so this also fixes
a refcounting bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/mxser.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 402c9f2..a420e8d 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -820,7 +820,6 @@ static void mxser_check_modem_status(struct tty_struct *tty,
 			wake_up_interruptible(&port->port.open_wait);
 	}
 
-	tty = tty_port_tty_get(&port->port);
 	if (port->port.flags & ASYNC_CTS_FLOW) {
 		if (tty->hw_stopped) {
 			if (status & UART_MSR_CTS) {
-- 
1.6.2

