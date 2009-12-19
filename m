Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZLSPN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZLSPN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 10:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZLSPN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 10:13:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZLSPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 10:13:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] spi/mpc8xxx: don't check platform_get_irq's return value against zero
Date: Sat, 19 Dec 2009 16:13:41 +0100
Message-Id: <1261235621-19116-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091217163944.GA6453@oksana.dev.rtsoft.ru>
References: <20091217163944.GA6453@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_get_irq returns -ENXIO on failure, so !irq was probably
always true.  Make irq a signed variable and compare irq <= 0.  Note
that a return value of zero is still handled as error even though this
could mean irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
changed the return value of platform_get_irq from 0 to -ENXIO on error.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Vrabel <dvrabel@arcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: spi-devel-general@lists.sourceforge.net
---
Hello,

as requested by Anton Vorontsov I made irq signed instead of casting to
int when comparing to zero.

Best regards
Uwe

 drivers/spi/spi_mpc8xxx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 1fb2a6e..08065fb 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -1328,7 +1328,7 @@ static struct of_platform_driver of_mpc8xxx_spi_driver = {
 static int __devinit plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
-	unsigned int irq;
+	int irq;
 	struct spi_master *master;
 
 	if (!pdev->dev.platform_data)
@@ -1339,7 +1339,7 @@ static int __devinit plat_mpc8xxx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq)
+	if (irq <= 0)
 		return -EINVAL;
 
 	master = mpc8xxx_spi_probe(&pdev->dev, mem, irq);
-- 
1.6.5.2

