Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZC1T0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZC1T0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZC1T0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:26:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36639 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZC1T0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:26:03 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move jazzsonic's probe function to .devinit.text
Date: Sat, 28 Mar 2009 20:25:58 +0100
Message-Id: <1238268358-6068-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
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
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Hi Geert and Ralf,

thanks for your feed-back.

@Geert: Did you notice this, or your compiler?
@Ralf: I assume that I can still add your ack after this additional change?

Best regards
Uwe

 drivers/net/jazzsonic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/jazzsonic.c b/drivers/net/jazzsonic.c
index 14248cf..ca68383 100644
--- a/drivers/net/jazzsonic.c
+++ b/drivers/net/jazzsonic.c
@@ -96,7 +96,7 @@ static int jazzsonic_close(struct net_device* dev)
 	return err;
 }
 
-static int __init sonic_probe1(struct net_device *dev)
+static int __devinit sonic_probe1(struct net_device *dev)
 {
 	static unsigned version_printed;
 	unsigned int silicon_revision;
@@ -204,7 +204,7 @@ out:
  * Probe for a SONIC ethernet controller on a Mips Jazz board.
  * Actually probing is superfluous but we're paranoid.
  */
-static int __init jazz_sonic_probe(struct platform_device *pdev)
+static int __devinit jazz_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
tg: (be0ea69..) t/platsection/jazz_sonic_driver (depends on: linus/master)
