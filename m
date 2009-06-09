Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZFINr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZFINr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFINq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:56 -0400
Received: from mx1.emlix.com ([193.175.82.87]:37564 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [PATCH 5/8] imx: serial: handle initialisation failure correctly
Date: Tue,  9 Jun 2009 15:46:48 +0200
Message-Id: <1244555211-15618-6-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-5-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
 <1244555211-15618-2-git-send-email-os@emlix.com>
 <1244555211-15618-3-git-send-email-os@emlix.com>
 <1244555211-15618-4-git-send-email-os@emlix.com>
 <1244555211-15618-5-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>

correctly de-initialise device when setting up failed,
call to pdata->exit() was missing.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 3fa07a9..60892a2 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1155,10 +1155,15 @@ static int serial_imx_probe(struct platform_device *pdev)
 			goto clkput;
 	}
 
-	uart_add_one_port(&imx_reg, &sport->port);
+	ret = uart_add_one_port(&imx_reg, &sport->port);
+	if (ret)
+		goto deinit;
 	platform_set_drvdata(pdev, &sport->port);
 
 	return 0;
+deinit:
+	if (pdata->exit)
+		pdata->exit(pdev);
 clkput:
 	clk_put(sport->clk);
 	clk_disable(sport->clk);
-- 
1.5.3.7

