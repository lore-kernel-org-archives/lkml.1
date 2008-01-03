Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYACQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYACQ65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYACQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:58:37 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:52939 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYACQ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:58:35 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 1/2] I2C: ISP1301_OMAP: New-style i2c driver updates, part 1
Date: Thu,  3 Jan 2008 11:59:56 -0500
Message-Id: <1199379597-6273-2-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc1.21.g0e545-dirty
In-Reply-To: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
References: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on David Brownell's patch for tps65010, this patch
starts converting isp1301_omap.c to new-style i2c driver.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/i2c/chips/isp1301_omap.c |   60 +++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index b767603..37e1403 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -49,7 +49,8 @@ MODULE_LICENSE("GPL");
 
 struct isp1301 {
 	struct otg_transceiver	otg;
-	struct i2c_client	client;
+	struct i2c_client	*client;
+	struct i2c_client	c;
 	void			(*i2c_release)(struct device *dev);
 
 	int			irq;
@@ -153,25 +154,25 @@ static struct i2c_driver isp1301_driver;
 static inline u8
 isp1301_get_u8(struct isp1301 *isp, u8 reg)
 {
-	return i2c_smbus_read_byte_data(&isp->client, reg + 0);
+	return i2c_smbus_read_byte_data(isp->client, reg + 0);
 }
 
 static inline int
 isp1301_get_u16(struct isp1301 *isp, u8 reg)
 {
-	return i2c_smbus_read_word_data(&isp->client, reg);
+	return i2c_smbus_read_word_data(isp->client, reg);
 }
 
 static inline int
 isp1301_set_bits(struct isp1301 *isp, u8 reg, u8 bits)
 {
-	return i2c_smbus_write_byte_data(&isp->client, reg + 0, bits);
+	return i2c_smbus_write_byte_data(isp->client, reg + 0, bits);
 }
 
 static inline int
 isp1301_clear_bits(struct isp1301 *isp, u8 reg, u8 bits)
 {
-	return i2c_smbus_write_byte_data(&isp->client, reg + 1, bits);
+	return i2c_smbus_write_byte_data(isp->client, reg + 1, bits);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -355,10 +356,10 @@ isp1301_defer_work(struct isp1301 *isp, int work)
 	int status;
 
 	if (isp && !test_and_set_bit(work, &isp->todo)) {
-		(void) get_device(&isp->client.dev);
+		(void) get_device(&isp->client->dev);
 		status = schedule_work(&isp->work);
 		if (!status && !isp->working)
-			dev_vdbg(&isp->client.dev,
+			dev_vdbg(&isp->client->dev,
 				"work item %d may be lost\n", work);
 	}
 }
@@ -1113,7 +1114,7 @@ isp1301_work(struct work_struct *work)
 		/* transfer state from otg engine to isp1301 */
 		if (test_and_clear_bit(WORK_UPDATE_ISP, &isp->todo)) {
 			otg_update_isp(isp);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 #endif
 		/* transfer state from isp1301 to otg engine */
@@ -1121,7 +1122,7 @@ isp1301_work(struct work_struct *work)
 			u8		stat = isp1301_clear_latch(isp);
 
 			isp_update_otg(isp, stat);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (test_and_clear_bit(WORK_HOST_RESUME, &isp->todo)) {
@@ -1156,7 +1157,7 @@ isp1301_work(struct work_struct *work)
 			}
 			host_resume(isp);
 			// mdelay(10);
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (test_and_clear_bit(WORK_TIMER, &isp->todo)) {
@@ -1165,15 +1166,15 @@ isp1301_work(struct work_struct *work)
 			if (!stop)
 				mod_timer(&isp->timer, jiffies + TIMER_JIFFIES);
 #endif
-			put_device(&isp->client.dev);
+			put_device(&isp->client->dev);
 		}
 
 		if (isp->todo)
-			dev_vdbg(&isp->client.dev,
+			dev_vdbg(&isp->client->dev,
 				"work done, todo = 0x%lx\n",
 				isp->todo);
 		if (stop) {
-			dev_dbg(&isp->client.dev, "stop\n");
+			dev_dbg(&isp->client->dev, "stop\n");
 			break;
 		}
 	} while (isp->todo);
@@ -1197,7 +1198,7 @@ static void isp1301_release(struct device *dev)
 {
 	struct isp1301	*isp;
 
-	isp = container_of(dev, struct isp1301, client.dev);
+	isp = container_of(dev, struct isp1301, c.dev);
 
 	/* ugly -- i2c hijacks our memory hook to wait_for_completion() */
 	if (isp->i2c_release)
@@ -1211,7 +1212,7 @@ static int isp1301_detach_client(struct i2c_client *i2c)
 {
 	struct isp1301	*isp;
 
-	isp = container_of(i2c, struct isp1301, client);
+	isp = container_of(i2c, struct isp1301, c);
 
 	isp1301_clear_bits(isp, ISP1301_INTERRUPT_FALLING, ~0);
 	isp1301_clear_bits(isp, ISP1301_INTERRUPT_RISING, ~0);
@@ -1263,7 +1264,7 @@ static int isp1301_otg_enable(struct isp1301 *isp)
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
 		INTR_VBUS_VLD | INTR_SESS_VLD | INTR_ID_GND);
 
-	dev_info(&isp->client.dev, "ready for dual-role USB ...\n");
+	dev_info(&isp->client->dev, "ready for dual-role USB ...\n");
 
 	return 0;
 }
@@ -1288,7 +1289,7 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 
 #ifdef	CONFIG_USB_OTG
 	isp->otg.host = host;
-	dev_dbg(&isp->client.dev, "registered host\n");
+	dev_dbg(&isp->client->dev, "registered host\n");
 	host_suspend(isp);
 	if (isp->otg.gadget)
 		return isp1301_otg_enable(isp);
@@ -1303,7 +1304,7 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 	if (machine_is_omap_h2())
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
 
-	dev_info(&isp->client.dev, "A-Host sessions ok\n");
+	dev_info(&isp->client->dev, "A-Host sessions ok\n");
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_RISING,
 		INTR_ID_GND);
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
@@ -1321,7 +1322,7 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 	return 0;
 
 #else
-	dev_dbg(&isp->client.dev, "host sessions not allowed\n");
+	dev_dbg(&isp->client->dev, "host sessions not allowed\n");
 	return -EINVAL;
 #endif
 
@@ -1347,7 +1348,7 @@ isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
 
 #ifdef	CONFIG_USB_OTG
 	isp->otg.gadget = gadget;
-	dev_dbg(&isp->client.dev, "registered gadget\n");
+	dev_dbg(&isp->client->dev, "registered gadget\n");
 	/* gadget driver may be suspended until vbus_connect () */
 	if (isp->otg.host)
 		return isp1301_otg_enable(isp);
@@ -1370,7 +1371,7 @@ isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
 		INTR_SESS_VLD);
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
 		INTR_VBUS_VLD);
-	dev_info(&isp->client.dev, "B-Peripheral sessions ok\n");
+	dev_info(&isp->client->dev, "B-Peripheral sessions ok\n");
 	dump_regs(isp, __FUNCTION__);
 
 	/* If this has a Mini-AB connector, this mode is highly
@@ -1383,7 +1384,7 @@ isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
 	return 0;
 
 #else
-	dev_dbg(&isp->client.dev, "peripheral sessions not allowed\n");
+	dev_dbg(&isp->client->dev, "peripheral sessions not allowed\n");
 	return -EINVAL;
 #endif
 }
@@ -1499,12 +1500,13 @@ static int isp1301_probe(struct i2c_adapter *bus, int address, int kind)
 	isp->timer.data = (unsigned long) isp;
 
 	isp->irq = -1;
-	isp->client.addr = address;
-	i2c_set_clientdata(&isp->client, isp);
-	isp->client.adapter = bus;
-	isp->client.driver = &isp1301_driver;
-	strlcpy(isp->client.name, DRIVER_NAME, I2C_NAME_SIZE);
-	i2c = &isp->client;
+	isp->irq_type = 0;
+	isp->c.addr = address;
+	i2c_set_clientdata(&isp->c, isp);
+	isp->c.adapter = bus;
+	isp->c.driver = &isp1301_driver;
+	strlcpy(isp->c.name, DRIVER_NAME, I2C_NAME_SIZE);
+	isp->client = i2c = &isp->c;
 
 	/* if this is a true probe, verify the chip ... */
 	if (kind < 0) {
@@ -1589,7 +1591,7 @@ fail2:
 		goto fail1;
 	}
 
-	isp->otg.dev = &isp->client.dev;
+	isp->otg.dev = &isp->client->dev;
 	isp->otg.label = DRIVER_NAME;
 
 	isp->otg.set_host = isp1301_set_host,
-- 
1.5.4.rc1.21.g0e545-dirty

