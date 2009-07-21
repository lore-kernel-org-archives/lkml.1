Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZGUUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZGUUL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZGUUL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:11:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54325 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZGUUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:11:56 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, netdev@vger.kernel.org,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] register at91_ether using platform_driver_probe
Date: Tue, 21 Jul 2009 22:11:39 +0200
Message-Id: <1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <200907111527.46441.david-b@pacbell.net>
References: <200907111527.46441.david-b@pacbell.net>
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

at91ether_probe lives in .init.text, so using platform_driver_register
to register it is wrong because binding a device after the init memory
is discarded (e.g. via sysfs) results in an oops.

As requested by David Brownell platform_driver_probe is used instead of
moving the probe function to .devinit.text as proposed initially.
This saves some memory, but devices registered after the driver is
probed are not bound (probably there are none) and binding via sysfs
isn't possible.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: netdev@vger.kernel.org
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/arm/at91_ether.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 2e7419a..5041d10 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -1228,7 +1228,6 @@ static int at91ether_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver at91ether_driver = {
-	.probe		= at91ether_probe,
 	.remove		= __devexit_p(at91ether_remove),
 	.suspend	= at91ether_suspend,
 	.resume		= at91ether_resume,
@@ -1240,7 +1239,7 @@ static struct platform_driver at91ether_driver = {
 
 static int __init at91ether_init(void)
 {
-	return platform_driver_register(&at91ether_driver);
+	return platform_driver_probe(&at91ether_driver, at91ether_probe);
 }
 
 static void __exit at91ether_exit(void)
-- 
tg: (4b0a840..) t/platsection/at91ether_driver (depends on: linus/master)
