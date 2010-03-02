Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0CBXwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:52:18 -0500
Received: from kroah.org ([198.145.64.141]:51560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0CBXgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>, Alan Cox <alan@linux.intel.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       stable <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/36] serial: imx: fix NULL dereference Oops when pdata == NULL
Date: Tue,  2 Mar 2010 15:36:14 -0800
Message-Id: <1267573003-782-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

The platform code doesn't have to provide platform data to get sensible
default behaviour from the imx serial driver.

This patch does not handle NULL dereference in the IrDA case, which still
requires a valid platform data pointer (in imx_startup()/imx_shutdown()),
since I don't know whether there is a sensible default behaviour, or
should the operation just fail cleanly.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Fabian Godehardt <fg@emlix.com>
Cc: Daniel Glöckner <dg@emlix.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/imx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 60d665a..d00fcf8 100644
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
1.7.0.1

