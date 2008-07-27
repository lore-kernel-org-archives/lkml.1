Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYG0GFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYG0GFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYG0GFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:05:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:32725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYG0GFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=TWNm5z8ne6aSzzWErolnKmrW5HhhrzJ+9yPp4B+7ZGKfK/OFVGUj7c+tdTQj3FXnAz
         Gyr0IWDa/dcyl9IwxEv46fulvl+vp2/vNcdhp2uMVHLHKtYkfV9tc2BnZCMs075UI9SO
         pFIHvmkG7XDng18/Y80ioMPvRM5FpK/ykWnu0=
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/8] Blackfin Serial Driver: Fix bug - should suspend/resume/remove all uart ports.
Date: Sun, 27 Jul 2008 14:04:01 +0800
Message-Id: <1217138647-18227-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
References: <1217138647-18227-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 052ce73..5e43530 100644
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
-- 
1.5.6

