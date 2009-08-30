Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZH3TKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZH3TKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZH3TKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:10:19 -0400
Received: from ns.unixsol.org ([193.110.159.2]:54334 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZH3TKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:10:18 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 15:10:18 EDT
Message-ID: <4A9ACD69.5030501@unixsol.org>
Date: Sun, 30 Aug 2009 22:05:13 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@mail.ru>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] input: Add support for Rotronic silver/white handset in cm109
 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds support for yet another keymap in
cm109 driver. Rotronic silver/white is USB "Skype" handset
sold in Bulgaria and Serbia (according to Google). With this
cheap stuff a picture is the only way to identify what you've
got, so here is one:
   http://www.reset.bg/catalog/images/skyphoneusbbelihcek.jpg

Signed-off-by: Georgi Chorbadzhiyski <georgi@unixsol.org>

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 86457fe..161899e 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -13,6 +13,7 @@
  *	- Komunikate KIP1000
  *	- Genius G-talk
  *	- Allied-Telesis Corega USBPH01
+ *	- Rotronic Skype USB silver/white
  *	- ...
  *
  * This driver is based on the yealink.c driver
@@ -42,7 +43,7 @@

 static char *phone = "kip1000";
 module_param(phone, charp, S_IRUSR);
-MODULE_PARM_DESC(phone, "Phone name {kip1000, gtalk, usbph01, atcom}");
+MODULE_PARM_DESC(phone, "Phone name {kip1000, gtalk, usbph01, atcom, rotronic}");

 enum {
 	/* HID Registers */
@@ -289,6 +290,43 @@ static unsigned short keymap_atcom(int scancode)
 	}
 }

+/*
+ * Keymap for Rotronic Skype USB silver/white
+ * Contributed by Georgi Chorbadzhiyski <georgi@unixsol.org>
+ *
+ * Keypad looks like this:
+ *         Up
+ *  Green       Red
+ *        Down
+ *  Vol+  Mute  Vol-
+ *    1    2     3
+ *    4    5     6
+ *    7    8     9
+ *    *    0     #
+ */
+static unsigned short keymap_rotronic(int scancode)
+{
+	switch (scancode) {
+	case 0x48: return KEY_UP;
+	case 0x18: return KEY_ENTER;		/*   pickup     */
+	case 0x28: return KEY_ESC;		/*   hangup     */
+	case 0x88: return KEY_DOWN;
+	case 0x21: return KEY_NUMERIC_1;
+	case 0x41: return KEY_NUMERIC_2;
+	case 0x81: return KEY_NUMERIC_3;
+	case 0x12: return KEY_NUMERIC_4;
+	case 0x22: return KEY_NUMERIC_5;
+	case 0x42: return KEY_NUMERIC_6;
+	case 0x82: return KEY_NUMERIC_7;
+	case 0x14: return KEY_NUMERIC_8;
+	case 0x24: return KEY_NUMERIC_9;
+	case 0x84: return KEY_NUMERIC_STAR;
+	case 0x11: return KEY_NUMERIC_0;
+	case 0x44: return KEY_NUMERIC_POUND;
+	default:   return special_keymap(scancode);
+	}
+}
+
 static unsigned short (*keymap)(int) = keymap_kip1000;

 /*
@@ -875,6 +913,10 @@ static int __init cm109_select_keymap(void)
 		keymap = keymap_atcom;
 		printk(KERN_INFO KBUILD_MODNAME ": "
 			"Keymap for ATCom AU-100 phone loaded\n");
+	} else if (!strcasecmp(phone, "rotronic")) {
+		keymap = keymap_rotronic;
+		printk(KERN_INFO KBUILD_MODNAME ": "
+			"Keymap for Rotronic silver/white phone loaded\n");
 	} else {
 		printk(KERN_ERR KBUILD_MODNAME ": "
 			"Unsupported phone: %s\n", phone);

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

