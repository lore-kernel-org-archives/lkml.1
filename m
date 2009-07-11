Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZGKVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZGKVBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZGKUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:54:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32987 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbZGKUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:59 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move at91_ether's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:32 +0200
Message-Id: <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to at91ether_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/arm/at91_ether.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 2e7419a..0c8860e 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -1119,7 +1119,7 @@ static int __init at91ether_setup(unsigned long phy_type, unsigned short phy_add
 /*
  * Detect MAC and PHY and perform initialization
  */
-static int __init at91ether_probe(struct platform_device *pdev)
+static int __devinit at91ether_probe(struct platform_device *pdev)
 {
 	unsigned int phyid1, phyid2;
 	int detected = -1;
-- 
1.6.3.1

