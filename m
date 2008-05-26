Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYEZRXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYEZRXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYEZRXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:23:42 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12692 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753916AbYEZRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:23:41 -0400
Date: Mon, 26 May 2008 21:23:40 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Timur Tabi <timur@freescale.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SERIAL] fix driver_name conflicts
Message-ID: <20080526172340.GA17703@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers are using too generic "serial" name for driver_name, this
might cause issues, like this:

Freescale QUICC Engine UART device driver
proc_dir_entry 'serial' already registered
Call Trace:
[cf82de50] [c0007f7c] show_stack+0x4c/0x1ac (unreliable)
[cf82de90] [c00b03fc] proc_register+0xfc/0x1ac
[cf82dec0] [c00b05c8] create_proc_entry+0x60/0xac
[cf82dee0] [c00b23dc] proc_tty_register_driver+0x60/0x98
[cf82def0] [c016dbd8] tty_register_driver+0x1b4/0x228
[cf82df20] [c0184d70] uart_register_driver+0x144/0x194
[cf82df40] [c030a378] ucc_uart_init+0x2c/0x94
[cf82df50] [c02f21a0] kernel_init+0x98/0x27c
[cf82dff0] [c000fa74] kernel_thread+0x44/0x60

^^ The board is using ucc_uart.c and 8250.c, both registered as
   "serial".

This patch fixes two drivers that are using "serial" for driver_name and
not "ttyS" for dev_name. Drivers that are using "ttyS" for dev_name, will
conflict anyway, so we don't bother with these.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/serial/sb1250-duart.c |    2 +-
 drivers/serial/ucc_uart.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/sb1250-duart.c b/drivers/serial/sb1250-duart.c
index 2d6c08b..f8e1447 100644
--- a/drivers/serial/sb1250-duart.c
+++ b/drivers/serial/sb1250-duart.c
@@ -924,7 +924,7 @@ console_initcall(sbd_serial_console_init);
 
 static struct uart_driver sbd_reg = {
 	.owner		= THIS_MODULE,
-	.driver_name	= "serial",
+	.driver_name	= "sb1250_duart",
 	.dev_name	= "duart",
 	.major		= TTY_MAJOR,
 	.minor		= SB1250_DUART_MINOR_BASE,
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 01917c4..566a8b4 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -195,7 +195,7 @@ struct uart_qe_port {
 
 static struct uart_driver ucc_uart_driver = {
 	.owner  	= THIS_MODULE,
-	.driver_name    = "serial",
+	.driver_name    = "ucc_uart",
 	.dev_name       = "ttyQE",
 	.major  	= SERIAL_QE_MAJOR,
 	.minor  	= SERIAL_QE_MINOR,
-- 
1.5.5.1
