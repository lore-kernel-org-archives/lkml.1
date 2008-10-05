Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbYJEQHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbYJEQHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYJEQFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:05:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54846 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756077AbYJEQF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:05:29 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 07/76] Blackfin Serial Driver: Fix bug - should
	suspend/resume/remove all uart ports.
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:05:29 +0100
Message-ID: <20081005160527.1997.38422.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/bfin_5xx.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 4a023c6..04eeef0 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1100,20 +1100,26 @@ static struct uart_driver bfin_serial_reg = {
 
 static int bfin_serial_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(dev);
+	int i;
 
-	if (uart)
-		uart_suspend_port(&bfin_serial_reg, &uart->port);
+	for (i = 0; i < nr_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_suspend_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+	}
 
 	return 0;
 }
 
 static int bfin_serial_resume(struct platform_device *dev)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(dev);
+	int i;
 
-	if (uart)
-		uart_resume_port(&bfin_serial_reg, &uart->port);
+	for (i = 0; i < nr_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_resume_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+	}
 
 	return 0;
 }
@@ -1133,27 +1139,26 @@ static int bfin_serial_probe(struct platform_device *dev)
 				continue;
 			bfin_serial_ports[i].port.dev = &dev->dev;
 			uart_add_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
-			platform_set_drvdata(dev, &bfin_serial_ports[i]);
 		}
 	}
 
 	return 0;
 }
 
-static int bfin_serial_remove(struct platform_device *pdev)
+static int bfin_serial_remove(struct platform_device *dev)
 {
-	struct bfin_serial_port *uart = platform_get_drvdata(pdev);
-
+	int i;
 
+	for (i = 0; i < nr_ports; i++) {
+		if (bfin_serial_ports[i].port.dev != &dev->dev)
+			continue;
+		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
+		bfin_serial_ports[i].port.dev = NULL;
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	gpio_free(uart->cts_pin);
-	gpio_free(uart->rts_pin);
+		gpio_free(bfin_serial_ports[i].cts_pin);
+		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif
-
-	platform_set_drvdata(pdev, NULL);
-
-	if (uart)
-		uart_remove_one_port(&bfin_serial_reg, &uart->port);
+	}
 
 	return 0;
 }

