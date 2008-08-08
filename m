Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbYHHVGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbYHHVGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYHHVG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:06:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:40380 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753934AbYHHVG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:06:26 -0400
X-Authenticated: #3093567
X-Provags-ID: V01U2FsdGVkX18HU3ddbxkHm+xydevuHyVr3weDaTb5pGaHYdiMiU
	QgG27Pvz5WCdyz
Subject: [PATCH] Make atkbd.c use unsigned short instead of unsigned int
From: Thomas Ilnseher <illth@gmx.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-HP2bMxw2VgcqLCzbzfK9"
Date: Fri, 08 Aug 2008 23:06:23 +0200
Message-Id: <1218229583.6152.14.camel@note.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HP2bMxw2VgcqLCzbzfK9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi list,

I've got an Acer Extensa 5220 with some extra "Euro" and "Dollar" keys.
I wanted to make these keys known to the kernel, so I wrote an .fdi file
for hal. 

Unfortunately the configuration of the "Euro" and "Dollar" (and some
other key) failed, because:
a) the atkbd driver uses unsigned char to store the keymap
b) the KEY_DOLLAR is 0x1b2 (which doesn't fit in 8 bits).

I created a small patch which changes the keymap to use 
unsigned short.

PS: I'm not subscribed to the LKML, please email me directly.




-- 
Thomas Ilnseher <illth@gmx.de>

--=-HP2bMxw2VgcqLCzbzfK9
Content-Disposition: attachment; filename=atkbd_short.path
Content-Type: text/x-patch; name=atkbd_short.path; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux/drivers/input/keyboard/atkbd.c	2008-07-13 23:51:29.000000000 +0200
+++ linux/drivers/input/keyboard/atkbd.c.new	2008-08-08 22:22:15.483300222 +0200
@@ -64,10 +64,21 @@
 MODULE_PARM_DESC(extra, "Enable extra LEDs and keys on IBM RapidAcces, EzKey and similar keyboards");
 
 /*
+ * Keycode table type. This used to be unsigned char (= 8bit).
+ * Too small for dollar / euro (found on acer atkbd)
+ */
+typedef unsigned short keycode_table_t;
+
+/*
  * Scancode to keycode tables. These are just the default setting, and
  * are loadable via an userland utility.
  */
 
+/*
+ * This is left unsigned char to conserve some memory.
+ * the memcopy is replaces by a loop.
+ */
+
 static unsigned char atkbd_set2_keycode[512] = {
 
 #ifdef CONFIG_KEYBOARD_ATKBD_HP_KEYCODES
@@ -200,7 +211,7 @@
 	char phys[32];
 
 	unsigned short id;
-	unsigned char keycode[512];
+	keycode_table_t keycode[512];
 	DECLARE_BITMAP(force_release_mask, 512);
 	unsigned char set;
 	unsigned char translated;
@@ -357,7 +368,7 @@
 	unsigned int code = data;
 	int scroll = 0, hscroll = 0, click = -1;
 	int value;
-	unsigned char keycode;
+	keycode_table_t keycode;
 
 #ifdef ATKBD_DEBUG
 	printk(KERN_DEBUG "atkbd.c: Received %02x flags %02x\n", data, flags);
@@ -807,8 +818,6 @@
 static void atkbd_cleanup(struct serio *serio)
 {
 	struct atkbd *atkbd = serio_get_drvdata(serio);
-
-	atkbd_disable(atkbd);
 	ps2_command(&atkbd->ps2dev, NULL, ATKBD_CMD_RESET_BAT);
 }
 
@@ -874,14 +883,20 @@
 						atkbd->keycode[i | 0x80] = atkbd_scroll_keys[j].keycode;
 		}
 	} else if (atkbd->set == 3) {
-		memcpy(atkbd->keycode, atkbd_set3_keycode, sizeof(atkbd->keycode));
-	} else {
-		memcpy(atkbd->keycode, atkbd_set2_keycode, sizeof(atkbd->keycode));
+		/* at_kbd->keycode is keycode_table_t, but atkbd_set* is unsigned char.
+		 * therefore we can't use memcpy
+		memcpy(atkbd->keycode, atkbd_set3_keycode, sizeof(atkbd->keycode)); */
+		for (i = 0; i < (sizeof(atkbd->keycode) / sizeof(keycode_table_t)); i++)
+			atkbd->keycode[i] = (keycode_table_t) atkbd_set3_keycode[i];
+	} else { /* see above 
+		memcpy(atkbd->keycode, atkbd_set2_keycode, sizeof(atkbd->keycode)); */
+		for (i = 0; i < (sizeof(atkbd->keycode) / sizeof(keycode_table_t)); i++)
+			atkbd->keycode[i] = (keycode_table_t) atkbd_set2_keycode[i];
 
 		if (atkbd->scroll)
 			for (i = 0; i < ARRAY_SIZE(atkbd_scroll_keys); i++) {
 				scancode = atkbd_scroll_keys[i].set2;
-				atkbd->keycode[scancode] = atkbd_scroll_keys[i].keycode;
+				atkbd->keycode[scancode] = (keycode_table_t)(atkbd_scroll_keys[i].keycode);
 		}
 	}
 
@@ -965,7 +980,7 @@
 	}
 
 	input_dev->keycode = atkbd->keycode;
-	input_dev->keycodesize = sizeof(unsigned char);
+	input_dev->keycodesize = sizeof(keycode_table_t);
 	input_dev->keycodemax = ARRAY_SIZE(atkbd_set2_keycode);
 
 	for (i = 0; i < 512; i++)

--=-HP2bMxw2VgcqLCzbzfK9--

