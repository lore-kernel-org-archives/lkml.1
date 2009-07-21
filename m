Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZGUUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZGUUqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZGUUqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:46:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54619 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbZGUUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:46:43 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@marvell.com>, Saeed Bishara <saeed@marvell.com>,
       =?utf-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>,
       Nicolas Pitre <nico@marvell.com>,
       Tzachi Perelstein <tzachi@marvell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] register orion_nand using platform_driver_probe
Date: Tue, 21 Jul 2009 22:46:36 +0200
Message-Id: <1248209196-15705-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.0907141211260.3138@xanadu.home>
References: <alpine.LFD.2.00.0907141211260.3138@xanadu.home>
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

orion_nand_probe lives in .init.text, so using platform_driver_register
to register it is wrong because binding a device after the init memory
is discarded (e.g. via sysfs) results in an oops.

As requested by Nicolas Pitre platform_driver_probe is used instead of
moving the probe function to .devinit.text as proposed initially.
This saves some memory, but devices registered after the driver is
probed are not bound (probably there are none) and binding via sysfs
isn't possible.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Cc: Saeed Bishara <saeed@marvell.com>
Cc: Jörn Engel <joern@logfs.org>
Cc: Nicolas Pitre <nico@marvell.com>
Cc: Tzachi Perelstein <tzachi@marvell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org

---
 drivers/mtd/nand/orion_nand.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 7ad9722..cb9d13b 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -171,7 +171,6 @@ static int __devexit orion_nand_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver orion_nand_driver = {
-	.probe		= orion_nand_probe,
 	.remove		= __devexit_p(orion_nand_remove),
 	.driver		= {
 		.name	= "orion_nand",
@@ -181,7 +180,7 @@ static struct platform_driver orion_nand_driver = {
 
 static int __init orion_nand_init(void)
 {
-	return platform_driver_register(&orion_nand_driver);
+	return platform_driver_probe(&orion_nand_driver, orion_nand_probe);
 }
 
 static void __exit orion_nand_exit(void)
-- 
tg: (4b0a840..) t/platsection/orion_nand_driver (depends on: linus/master)
