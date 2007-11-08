Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXKHOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXKHOdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbXKHOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:33:05 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:56851 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXKHOdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:33:04 -0500
Date: Thu, 08 Nov 2007 23:35:05 +0900 (JST)
Message-Id: <20071108.233505.25913499.anemo@mba.ocn.ne.jp>
To: David Brownell <david-b@pacbell.net>, Tony Jones <tonyj@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] spi: Fix double-free on spi_unregister_master
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, device_for_each_child
iteration hits the master device itself.  Do not call
spi_unregister_device() for the master device.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/spi/spi.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 89769ce..b31f443 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -457,10 +457,11 @@ done:
 EXPORT_SYMBOL_GPL(spi_register_master);
 
 
-static int __unregister(struct device *dev, void *unused)
+static int __unregister(struct device *dev, void *master_dev)
 {
 	/* note: before about 2.6.14-rc1 this would corrupt memory: */
-	spi_unregister_device(to_spi_device(dev));
+	if (dev != master_dev)
+		spi_unregister_device(to_spi_device(dev));
 	return 0;
 }
 
@@ -478,7 +479,8 @@ void spi_unregister_master(struct spi_master *master)
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
+	dummy = device_for_each_child(master->dev.parent, &master->dev,
+					__unregister);
 	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
