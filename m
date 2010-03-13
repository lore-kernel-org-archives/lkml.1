Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936435Ab0CMBYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:24:49 -0500
Received: from kroah.org ([198.145.64.141]:60852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934864Ab0CMAUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.065998205@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Baruch Siach <baruch@tkos.co.il>, Alan Cox <alan@linux.intel.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 056/123] serial: imx: fix NULL dereference Oops when pdata == NULL
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Baruch Siach <baruch@tkos.co.il>

commit bbcd18d1b37413d25eaf4580682b1b8e4a09ff5e upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/imx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1279,7 +1279,7 @@ static int serial_imx_probe(struct platf
 		sport->use_irda = 1;
 #endif
 
-	if (pdata->init) {
+	if (pdata && pdata->init) {
 		ret = pdata->init(pdev);
 		if (ret)
 			goto clkput;
@@ -1292,7 +1292,7 @@ static int serial_imx_probe(struct platf
 
 	return 0;
 deinit:
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 clkput:
 	clk_put(sport->clk);
@@ -1321,7 +1321,7 @@ static int serial_imx_remove(struct plat
 
 	clk_disable(sport->clk);
 
-	if (pdata->exit)
+	if (pdata && pdata->exit)
 		pdata->exit(pdev);
 
 	iounmap(sport->port.membase);


