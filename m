Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYJ1Rqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYJ1Rqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYJ1RqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:46:17 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57674 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753237AbYJ1RqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:46:16 -0400
Date: Tue, 28 Oct 2008 20:46:15 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: [PATCH 3/6] of/of_i2c: add support for dedicated OF I2C devices
Message-ID: <20081028174615.GC25349@oksana.dev.rtsoft.ru>
References: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081028174532.GA23834@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_i2c will create the OF platform device if it knows that the
device won't work without platform data. The OF platform driver
will fill the platform data and will register real I2C device.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/of_i2c.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 57de7c5..02aa1d6 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -13,6 +13,7 @@
 
 #include <linux/i2c.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/of_i2c.h>
 #include <linux/module.h>
 
@@ -67,6 +68,17 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 	for_each_child_of_node(adap_node, node) {
 		struct i2c_board_info info = {};
 
+#ifdef CONFIG_PPC
+		/* TODO: of_platform_device_create() for SPARC. */
+		if (of_should_create_pdev(node)) {
+			struct of_device *of_pdev;
+
+			of_pdev = of_platform_device_create(node, NULL,
+							    &adap->dev);
+			WARN_ON(!of_pdev);
+			continue;
+		}
+#endif
 		of_register_i2c_device(adap, &info, node);
 	}
 }
-- 
1.5.6.3

