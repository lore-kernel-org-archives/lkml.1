Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZGUUgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZGUUgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZGUUgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:36:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43536 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbZGUUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:36:31 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Pihet <jpihet@mvista.com>, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus@drzeus.cx>, Andy Lowe <alowe@mvista.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] register mmci-omap-hs using platform_driver_probe
Date: Tue, 21 Jul 2009 22:36:13 +0200
Message-Id: <1248208573-15171-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <200907111529.21165.david-b@pacbell.net>
References: <200907111529.21165.david-b@pacbell.net>
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

omap_mmc_probe lives in .init.text, so using platform_driver_register
to register it is wrong because binding a device after the init memory
is discarded (e.g. via sysfs) results in an oops.

As requested by David Brownell platform_driver_probe is used instead of
moving the probe function to .devinit.text as proposed initially.
This saves some memory, but devices registered after the driver is
probed are not bound (probably there are none) and binding via sysfs
isn't possible.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Madhusudhan Chikkature<madhu.cr@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/omap_hsmmc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1cf9cfb..40d9830 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1307,7 +1307,6 @@ clk_en_err:
 #endif
 
 static struct platform_driver omap_mmc_driver = {
-	.probe		= omap_mmc_probe,
 	.remove		= omap_mmc_remove,
 	.suspend	= omap_mmc_suspend,
 	.resume		= omap_mmc_resume,
@@ -1320,7 +1319,7 @@ static struct platform_driver omap_mmc_driver = {
 static int __init omap_mmc_init(void)
 {
 	/* Register the MMC driver */
-	return platform_driver_register(&omap_mmc_driver);
+	return platform_driver_probe(&omap_mmc_driver, omap_mmc_probe);
 }
 
 static void __exit omap_mmc_cleanup(void)
-- 
tg: (4b0a840..) t/platsection/omap_mmc_driver (depends on: linus/master)
