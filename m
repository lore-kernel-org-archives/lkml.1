Return-Path: <linux-kernel-owner+w=401wt.eu-S1765791AbZDBRsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765791AbZDBRsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZDBRrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:47:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZDBRru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:47:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Grazvydas Ignotas <notasas@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] make mmci-omap using platform_driver_probe
Date: Thu,  2 Apr 2009 19:47:41 +0200
Message-Id: <1238694461-29501-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <200903280927.32786.david-b@pacbell.net>
References: <200903280927.32786.david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to mmc_omap_probe which lives in .init.text is passed to the
core via platform_driver_register and so the kernel might oops if probe
is called after the init code is discarded.

As requested by David Brownell platform_driver_probe is used instead of
moving the probe function to .devinit.text.  This saves some memory, but
might have the downside that a device being registered after the call to
mmc_omap_init but before the init sections are discarded will not be
bound anymore to the driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/mmc/host/omap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 67d7b7f..004080e 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1601,7 +1601,6 @@ static int mmc_omap_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver mmc_omap_driver = {
-	.probe		= mmc_omap_probe,
 	.remove		= mmc_omap_remove,
 	.suspend	= mmc_omap_suspend,
 	.resume		= mmc_omap_resume,
@@ -1613,7 +1612,7 @@ static struct platform_driver mmc_omap_driver = {
 
 static int __init mmc_omap_init(void)
 {
-	return platform_driver_register(&mmc_omap_driver);
+	return platform_driver_probe(&mmc_omap_driver, mmc_omap_probe);
 }
 
 static void __exit mmc_omap_exit(void)
-- 
tg: (5d80f8e..) t/platsection/mmc_omap_driver (depends on: linus/master)
