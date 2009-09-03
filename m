Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZICPO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZICPO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZICPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:14:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59392 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZICPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:14:27 -0400
Message-ID: <55730.192.168.10.89.1251990860.squirrel@dbdmail.itg.ti.com>
Date: Thu, 3 Sep 2009 20:44:20 +0530 (IST)
Subject: [PATCH 2/2]: twl4030: initialize pm_power_off in twl4030-core.c
From: "vimal singh" <vimalsingh@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: felipe.balbi@nokia.com
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'twl4030-poweroff' module was removed sometime back. This patch adds back
this capability.
We don't really need a whole new driver just for initializing one pointer.
Initialize pm_power_off in twl4030-core.c

Signed-off-by: Vimal Singh <vimalsingh@ti.com>
CC: Felipe Balbi <felipe.balbi@nokia.com>
---
This patch is compile tested only.
This patch is based on Felipe Balbi's patch posted earlier:
http://markmail.org/message/ts4if3553qnauket

 drivers/mfd/twl4030-core.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+)

Index: linux-omap-2.6/drivers/mfd/twl4030-core.c
===================================================================
--- linux-omap-2.6.orig/drivers/mfd/twl4030-core.c
+++ linux-omap-2.6/drivers/mfd/twl4030-core.c
@@ -178,6 +178,10 @@
 #define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
 #define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */

+/* for pm_power_off */
+#define PWR_P1_SW_EVENTS	0x10
+#define PWR_DEVOFF		(1 << 0)
+
 /*----------------------------------------------------------------------*/

 /* is driver active, bound to a chip? */
@@ -754,6 +758,30 @@ static int twl4030_remove(struct i2c_cli
 	return 0;
 }

+static void twl4030_poweroff(void)
+{
+	int err;
+	u8 val;
+
+	err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &val,
+				  PWR_P1_SW_EVENTS);
+	if (err) {
+		pr_err("%s: i2c error %d while reading TWL4030"
+			"PM_MASTER P1_SW_EVENTS\n",
+			DRIVER_NAME, err);
+		return;
+	}
+
+	val |= PWR_DEVOFF;
+
+	err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, val,
+				   PWR_P1_SW_EVENTS);
+	if (err)
+		pr_err("%s: i2c error %d while writing TWL4030"
+			"PM_MASTER P1_SW_EVENTS\n",
+			DRIVER_NAME, err);
+}
+
 /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
 static int
 twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -811,6 +839,9 @@ twl4030_probe(struct i2c_client *client,
 			goto fail;
 	}

+	/* initialize pm_power_off routine */
+	pm_power_off = twl4030_poweroff;
+
 	status = add_children(pdata, id->driver_data);
 fail:
 	if (status < 0)


