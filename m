Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZGKVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZGKVDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbZGKUyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:54:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33069 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbZGKUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:54:07 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move jazzsonic's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:46 +0200
Message-Id: <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to jazz_sonic_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

As noticed by Geert Uytterhoeven sonic_probe1 is called by
jazz_sonic_probe, so the former has to move to .devinit.text, too.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/jazzsonic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/jazzsonic.c b/drivers/net/jazzsonic.c
index d12106b..8baf595 100644
--- a/drivers/net/jazzsonic.c
+++ b/drivers/net/jazzsonic.c
@@ -108,7 +108,7 @@ static const struct net_device_ops sonic_netdev_ops = {
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
-static int __init sonic_probe1(struct net_device *dev)
+static int __devinit sonic_probe1(struct net_device *dev)
 {
 	static unsigned version_printed;
 	unsigned int silicon_revision;
@@ -211,7 +211,7 @@ out:
  * Probe for a SONIC ethernet controller on a Mips Jazz board.
  * Actually probing is superfluous but we're paranoid.
  */
-static int __init jazz_sonic_probe(struct platform_device *pdev)
+static int __devinit jazz_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
1.6.3.1

