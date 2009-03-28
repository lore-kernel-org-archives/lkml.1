Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZC1Td7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZC1Td7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZC1Tdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:33:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZC1Tdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:33:49 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move macsonic's probe function to .devinit.text
Date: Sat, 28 Mar 2009 20:33:47 +0100
Message-Id: <1238268827-6316-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238196439-16535-25-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1238196439-16535-25-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to mac_sonic_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

Various other functions that are called by mac_sonic_probe need to move
to .devinit.text, too.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/net/macsonic.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macsonic.c b/drivers/net/macsonic.c
index 527166e..e4f177e 100644
--- a/drivers/net/macsonic.c
+++ b/drivers/net/macsonic.c
@@ -167,7 +167,7 @@ static int macsonic_close(struct net_device* dev)
 	return err;
 }
 
-static int __init macsonic_init(struct net_device *dev)
+static int __devinit macsonic_init(struct net_device *dev)
 {
 	struct sonic_local* lp = netdev_priv(dev);
 
@@ -216,7 +216,7 @@ static int __init macsonic_init(struct net_device *dev)
 	return 0;
 }
 
-static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
+static int __devinit mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 {
 	struct sonic_local *lp = netdev_priv(dev);
 	const int prom_addr = ONBOARD_SONIC_PROM_BASE;
@@ -281,7 +281,7 @@ static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 	} else return 0;
 }
 
-static int __init mac_onboard_sonic_probe(struct net_device *dev)
+static int __devinit mac_onboard_sonic_probe(struct net_device *dev)
 {
 	/* Bwahahaha */
 	static int once_is_more_than_enough;
@@ -402,7 +402,7 @@ static int __init mac_onboard_sonic_probe(struct net_device *dev)
 	return macsonic_init(dev);
 }
 
-static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
+static int __devinit mac_nubus_sonic_ethernet_addr(struct net_device *dev,
 						unsigned long prom_addr,
 						int id)
 {
@@ -417,7 +417,7 @@ static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
 	return 0;
 }
 
-static int __init macsonic_ident(struct nubus_dev *ndev)
+static int __devinit macsonic_ident(struct nubus_dev *ndev)
 {
 	if (ndev->dr_hw == NUBUS_DRHW_ASANTE_LC &&
 	    ndev->dr_sw == NUBUS_DRSW_SONIC_LC)
@@ -442,7 +442,7 @@ static int __init macsonic_ident(struct nubus_dev *ndev)
 	return -1;
 }
 
-static int __init mac_nubus_sonic_probe(struct net_device *dev)
+static int __devinit mac_nubus_sonic_probe(struct net_device *dev)
 {
 	static int slots;
 	struct nubus_dev* ndev = NULL;
@@ -555,7 +555,7 @@ static int __init mac_nubus_sonic_probe(struct net_device *dev)
 	return macsonic_init(dev);
 }
 
-static int __init mac_sonic_probe(struct platform_device *pdev)
+static int __devinit mac_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
tg: (be0ea69..) t/platsection/mac_sonic_driver (depends on: linus/master)
