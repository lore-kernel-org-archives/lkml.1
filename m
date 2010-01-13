Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692Ab0AMLGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0AMLGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610Ab0AMLGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:06:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58075 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0AMLGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:06:01 -0500
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
Subject: [RESEND PATCH 5/5] spi/mpc8xxx: don't check platform_get_irq's return value against zero
Date: Wed, 13 Jan 2010 12:05:46 +0100
Message-Id: <1263380746-27803-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
1.6.6

