Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbZKXQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbZKXQxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbZKXQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:53:15 -0500
Received: from www.tglx.de ([62.245.132.106]:50999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbZKXQxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:53:15 -0500
To: s.hauer@pengutronix.de
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SPI/i.MX: fix broken error handling for gpio_request
From: John Ogness <john.ogness@linutronix.de>
Date: Tue, 24 Nov 2009 17:53:07 +0100
Message-ID: <807htfsw3w.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX35-provided chipselects are represented using negative numbers. If
gpio_request() fails and the previous chipselect was a negative number,
the while loop is endless (i is never decremented).

Also, the error loop would never call gpio_free on chipselect[0].

And finally, the error message was missing an endline.

This patch is against 2.6.32-rc8.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 spi_imx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -513,11 +513,12 @@ static int __init spi_imx_probe(struct p
 			continue;
 		ret = gpio_request(spi_imx->chipselect[i], DRIVER_NAME);
 		if (ret) {
-			i--;
-			while (i > 0)
+			while (i > 0) {
+				i--;
 				if (spi_imx->chipselect[i] >= 0)
-					gpio_free(spi_imx->chipselect[i--]);
-			dev_err(&pdev->dev, "can't get cs gpios");
+					gpio_free(spi_imx->chipselect[i]);
+			}
+			dev_err(&pdev->dev, "can't get cs gpios\n");
 			goto out_master_put;
 		}
 	}
