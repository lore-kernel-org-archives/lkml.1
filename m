Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZGKU71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZGKU71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZGKUyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:54:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbZGKUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:52 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move macsonic's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:48 +0200
Message-Id: <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de>
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
index acd143d..8f492c7 100644
--- a/drivers/net/macsonic.c
+++ b/drivers/net/macsonic.c
@@ -179,7 +179,7 @@ static const struct net_device_ops macsonic_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
-static int __init macsonic_init(struct net_device *dev)
+static int __devinit macsonic_init(struct net_device *dev)
 {
 	struct sonic_local* lp = netdev_priv(dev);
 
@@ -223,7 +223,7 @@ static int __init macsonic_init(struct net_device *dev)
 	return 0;
 }
 
-static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
+static int __devinit mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 {
 	struct sonic_local *lp = netdev_priv(dev);
 	const int prom_addr = ONBOARD_SONIC_PROM_BASE;
@@ -288,7 +288,7 @@ static int __init mac_onboard_sonic_ethernet_addr(struct net_device *dev)
 	} else return 0;
 }
 
-static int __init mac_onboard_sonic_probe(struct net_device *dev)
+static int __devinit mac_onboard_sonic_probe(struct net_device *dev)
 {
 	/* Bwahahaha */
 	static int once_is_more_than_enough;
@@ -409,7 +409,7 @@ static int __init mac_onboard_sonic_probe(struct net_device *dev)
 	return macsonic_init(dev);
 }
 
-static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
+static int __devinit mac_nubus_sonic_ethernet_addr(struct net_device *dev,
 						unsigned long prom_addr,
 						int id)
 {
@@ -424,7 +424,7 @@ static int __init mac_nubus_sonic_ethernet_addr(struct net_device *dev,
 	return 0;
 }
 
-static int __init macsonic_ident(struct nubus_dev *ndev)
+static int __devinit macsonic_ident(struct nubus_dev *ndev)
 {
 	if (ndev->dr_hw == NUBUS_DRHW_ASANTE_LC &&
 	    ndev->dr_sw == NUBUS_DRSW_SONIC_LC)
@@ -449,7 +449,7 @@ static int __init macsonic_ident(struct nubus_dev *ndev)
 	return -1;
 }
 
-static int __init mac_nubus_sonic_probe(struct net_device *dev)
+static int __devinit mac_nubus_sonic_probe(struct net_device *dev)
 {
 	static int slots;
 	struct nubus_dev* ndev = NULL;
@@ -562,7 +562,7 @@ static int __init mac_nubus_sonic_probe(struct net_device *dev)
 	return macsonic_init(dev);
 }
 
-static int __init mac_sonic_probe(struct platform_device *pdev)
+static int __devinit mac_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
1.6.3.1

