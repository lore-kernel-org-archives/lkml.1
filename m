Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYJ0Vjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYJ0Vjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYJ0ViM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:12 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42623 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751474AbYJ0ViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GencX6OYtm1MFUoVRTkxfC5CaPs1QNycqp2TP23y3nJZkPQgMs/VpjA5buB77xK+gKqm69l/94bi0ogId16Z4j0gmTspe+auf7k35iQyg8gB9iDujcl4/E/+pY+ARsPzxjdaCQQm2sRLAcUbTqw6vVQsa/yAsD056IrDsjZipfM=  ;
X-YMail-OSG: J3JLbWEVM1le2tAUfWDFiFFcZmFSzZ5QuiyUEm0_ddh0xI.plIHQRo1xfJtHQ0iKdWaTgSBPA83LYX4KUiQYkvBAz55Tegl0mL_KLQacKO.uZnK0R8XSs8UrHK8B9YtlCTxN4oPVe8wqpHFsjcjHqLNhGSBOLQg7VSSU594CI5DHmPpoYqutRn9rUMVp
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Date: Mon, 27 Oct 2008 14:06:23 -0700
User-Agent: KMail/1.9.10
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271406.24110.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The atmel_serial driver is mismanaging its clock by leaving it on
at all times ... the whole point of clock management is to leave
it off unless it's actively needed, which conserves power!!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/serial/atmel_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1258,6 +1258,8 @@ static void __devinit atmel_init_port(st
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
+		clk_disable(atmel_port->clk);
+		/* only enable clock when USART is in use */
 	}
 
 	atmel_port->use_dma_rx = data->use_dma_rx;
@@ -1544,7 +1546,6 @@ err_add_port:
 	port->rx_ring.buf = NULL;
 err_alloc_ring:
 	if (!atmel_is_console_port(&port->uart)) {
-		clk_disable(port->clk);
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
@@ -1568,7 +1569,6 @@ static int __devexit atmel_serial_remove
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clk_disable(atmel_port->clk);
 	clk_put(atmel_port->clk);
 
 	return ret;
