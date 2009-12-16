Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbZLPHim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbZLPHim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZLPHim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:38:42 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:57477 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZLPHil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:38:41 -0500
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 02:38:41 EST
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Baruch Siach <baruch@tkos.co.il>, Alan Cox <alan@linux.intel.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] serial: imx: fix NULL dereference Oops when pdata == NULL
Date: Wed, 16 Dec 2009 09:02:25 +0200
Message-Id: <d1d806ef1d3cd9ff34edc5b09778ac42f11b32fd.1260946439.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform code doesn't have to provide platform data to get sensible default
behaviour from the imx serial driver.

This patch does not handle NULL dereference in the IrDA case, which still
requires a valid platform data pointer (in imx_startup()/imx_shutdown()), since
I don't know whether there is a sensible default behaviour, or should the
operation just fail cleanly.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/serial/imx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 18130f1..8c0dd13 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1279,7 +1279,7 @@ static int serial_imx_probe(struct platform_device *pdev)
 		sport->use_irda = 1;
 #endif
 
-	if (pdata->init) {
+	if (pdata && pdata->init) {
 		ret = pdata->init(pdev);
 		if (ret)
 			goto clkput;
@@ -1292,7 +1292,7 @@ static int serial_imx_probe(struct platform_device *pdev)
 
 	return 0;
 deinit:
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 clkput:
 	clk_put(sport->clk);
@@ -1321,7 +1321,7 @@ static int serial_imx_remove(struct platform_device *pdev)
 
 	clk_disable(sport->clk);
 
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
 	iounmap(sport->port.membase);
-- 
1.6.5

