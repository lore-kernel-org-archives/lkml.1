Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYJPRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYJPRN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYJPRM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:12:59 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7133 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752954AbYJPRM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:12:58 -0400
Date: Thu, 16 Oct 2008 21:12:56 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 3/7] of: fill the archdata for I2C devices
Message-ID: <20081016171256.GC5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For I2C devices we just setting the the node pointer in the archdata.
This is needed so that the other code would know device's node.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/of_i2c.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
index 6a98dc8..f9e18ed 100644
--- a/drivers/of/of_i2c.c
+++ b/drivers/of/of_i2c.c
@@ -24,6 +24,7 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 
 	for_each_child_of_node(adap_node, node) {
 		struct i2c_board_info info = {};
+		struct dev_archdata dev_ad = {};
 		const u32 *addr;
 		int len;
 
@@ -41,6 +42,9 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 
 		info.addr = *addr;
 
+		dev_archdata_set_node(&dev_ad, node);
+		info.archdata = &dev_ad;
+
 		request_module(info.type);
 
 		result = i2c_new_device(adap, &info);
@@ -51,6 +55,13 @@ void of_register_i2c_devices(struct i2c_adapter *adap,
 			irq_dispose_mapping(info.irq);
 			continue;
 		}
+
+		/*
+		 * Get the node to not lose the dev_archdata->of_node.
+		 * Currently there is no way to put it back, as well as no
+		 * of_unregister_i2c_devices() call.
+		 */
+		of_node_get(node);
 	}
 }
 EXPORT_SYMBOL(of_register_i2c_devices);
-- 
1.5.6.3

