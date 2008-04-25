Return-Path: <linux-kernel-owner+w=401wt.eu-S933973AbYDYTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbYDYTMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933709AbYDYTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:06:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43738 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbYDYTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:06:56 -0400
Date: Fri, 25 Apr 2008 22:06:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Toth <stoth@hauppauge.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] media/video/au0828/ cleanups and fixes
Message-ID: <20080425190603.GA20630@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups and fixes:
- "debug" is definitely not a good name for a global variable,
  renamed it to "au0828_debug"
  this fixes a compile error with some kernel configurations
- since the module parameter is int the variable shouldn't be unsigned
- remove the {usb,bridge,i2c}_debug module parameters since they are
  already covered by the "debug" module parameter
- remove the unused au0828_bcount
- make the needlessly global i2c_scan static
- make the needlessly global dvb_register() static

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/au0828/au0828-cards.c |    1 
 drivers/media/video/au0828/au0828-core.c  |   26 +++++-----------------
 drivers/media/video/au0828/au0828-dvb.c   |    2 -
 drivers/media/video/au0828/au0828-i2c.c   |    6 -----
 drivers/media/video/au0828/au0828.h       |    8 +-----
 5 files changed, 10 insertions(+), 33 deletions(-)

a07a41dedfa970826694e795d63007ad209cc7c9 diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 8ca91f8..a2a6983 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -36,7 +36,6 @@ struct au0828_board au0828_boards[] = {
 		.name	= "DViCO FusionHDTV USB",
 	},
 };
-const unsigned int au0828_bcount = ARRAY_SIZE(au0828_boards);
 
 /* Tuner callback function for au0828 boards. Currently only needed
  * for HVR1500Q, which has an xc5000 tuner.
diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index e65d564..54bfc0f 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -32,18 +32,10 @@
  * 4 = I2C related
  * 8 = Bridge related
  */
-unsigned int debug;
-module_param(debug, int, 0644);
+int au0828_debug;
+module_param_named(debug, au0828_debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
 
-unsigned int usb_debug;
-module_param(usb_debug, int, 0644);
-MODULE_PARM_DESC(usb_debug, "enable usb debug messages");
-
-unsigned int bridge_debug;
-module_param(bridge_debug, int, 0644);
-MODULE_PARM_DESC(bridge_debug, "enable bridge debug messages");
-
 #define _AU0828_BULKPIPE 0x03
 #define _BULKPIPESIZE 0xffff
 
@@ -229,24 +221,18 @@ static int __init au0828_init(void)
 {
 	int ret;
 
-	if (debug)
+	if (au0828_debug & 1)
 		printk(KERN_INFO "%s() Debugging is enabled\n", __func__);
 
-	if (usb_debug) {
+	if (au0828_debug & 2)
 		printk(KERN_INFO "%s() USB Debugging is enabled\n", __func__);
-		debug |= 2;
-	}
 
-	if (i2c_debug) {
+	if (au0828_debug & 4)
 		printk(KERN_INFO "%s() I2C Debugging is enabled\n", __func__);
-		debug |= 4;
-	}
 
-	if (bridge_debug) {
+	if (au0828_debug & 8)
 		printk(KERN_INFO "%s() Bridge Debugging is enabled\n",
 		       __func__);
-		debug |= 8;
-	}
 
 	printk(KERN_INFO "au0828 driver loaded\n");
 
diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/video/au0828/au0828-dvb.c
index 85d0ae9..5040d7f 100644
--- a/drivers/media/video/au0828/au0828-dvb.c
+++ b/drivers/media/video/au0828/au0828-dvb.c
@@ -204,7 +204,7 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 	return ret;
 }
 
-int dvb_register(struct au0828_dev *dev)
+static int dvb_register(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
 	int result;
diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/video/au0828/au0828-i2c.c
index 94c8b74..741a493 100644
--- a/drivers/media/video/au0828/au0828-i2c.c
+++ b/drivers/media/video/au0828/au0828-i2c.c
@@ -29,11 +29,7 @@
 
 #include <media/v4l2-common.h>
 
-unsigned int i2c_debug;
-module_param(i2c_debug, int, 0444);
-MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
-
-unsigned int i2c_scan;
+static int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 0200b9f..7beb571 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -96,15 +96,12 @@ struct au0828_buff {
 /* au0828-core.c */
 extern u32 au0828_read(struct au0828_dev *dev, u16 reg);
 extern u32 au0828_write(struct au0828_dev *dev, u16 reg, u32 val);
-extern unsigned int debug;
-extern unsigned int usb_debug;
-extern unsigned int bridge_debug;
+extern int au0828_debug;
 
 /* ----------------------------------------------------------- */
 /* au0828-cards.c */
 extern struct au0828_board au0828_boards[];
 extern struct usb_device_id au0828_usb_id_table[];
-extern const unsigned int au0828_bcount;
 extern void au0828_gpio_setup(struct au0828_dev *dev);
 extern int au0828_tuner_callback(void *priv, int command, int arg);
 extern void au0828_card_setup(struct au0828_dev *dev);
@@ -115,7 +112,6 @@ extern int au0828_i2c_register(struct au0828_dev *dev);
 extern int au0828_i2c_unregister(struct au0828_dev *dev);
 extern void au0828_call_i2c_clients(struct au0828_dev *dev,
 	unsigned int cmd, void *arg);
-extern unsigned int i2c_debug;
 
 /* ----------------------------------------------------------- */
 /* au0828-dvb.c */
@@ -123,6 +119,6 @@ extern int au0828_dvb_register(struct au0828_dev *dev);
 extern void au0828_dvb_unregister(struct au0828_dev *dev);
 
 #define dprintk(level, fmt, arg...)\
-	do { if (debug & level)\
+	do { if (au0828_debug & level)\
 		printk(KERN_DEBUG DRIVER_NAME "/0: " fmt, ## arg);\
 	} while (0)

