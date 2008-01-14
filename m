Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYANBDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYANBDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYANBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:03:37 -0500
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:34612 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYANBDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:03:36 -0500
Date: Mon, 14 Jan 2008 00:52:19 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Default keyboard LEDs
Message-ID: <20080114005219.GA4296@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In many cases, one prefers to have e.g. the NumLock on by default.  In
many cases, one doesn't want to have it by default, e.g. on laptops.

Distributions actually have a very hard time trying to set this
correctly after the kernel boot, and that doesn't work for new consoles
that are created via the openvt(1) command anyway. This hence adds a
keyboard.default_leds boot parameter that permits to configure the
default keyboard LEDs.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---

Actually, what would be perfect would be to use the configuration that
the BIOS sets at boot by default.  That is device-dependent, however.

--- linux/drivers/char/keyboard.c.orig	2008-01-14 00:26:12.000000000 +0000
+++ linux/drivers/char/keyboard.c	2008-01-14 00:33:03.000000000 +0000
@@ -67,6 +67,9 @@
 
 #define KBD_DEFLOCK 0
 
+unsigned char default_leds = KBD_DEFLEDS;
+module_param(default_leds, byte, S_IRUGO | S_IWUSR);
+
 void compute_shiftstate(void);
 
 /*
@@ -1405,8 +1408,8 @@
 	int error;
 
         for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		kbd_table[i].ledflagstate = KBD_DEFLEDS;
-		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
+		kbd_table[i].ledflagstate = default_leds;
+		kbd_table[i].default_ledflagstate = default_leds;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
 		kbd_table[i].lockstate = KBD_DEFLOCK;
 		kbd_table[i].slockstate = 0;
--- linux/include/linux/kbd_kern.h.orig	2008-01-14 00:32:36.000000000 +0000
+++ linux/include/linux/kbd_kern.h	2008-01-14 00:32:48.000000000 +0000
@@ -13,6 +13,7 @@
 extern char func_buf[];
 extern char *funcbufptr;
 extern int funcbufsize, funcbufleft;
+extern unsigned char default_leds;
 
 /*
  * kbd->xxx contains the VC-local things (flag settings etc..)
--- linux/Documentation/kernel-parameters.txt.orig	2008-01-14 00:38:40.000000000 +0000
+++ linux/Documentation/kernel-parameters.txt	2008-01-14 00:41:21.000000000 +0000
@@ -550,6 +550,15 @@
 			Set system-wide default UTF-8 mode for all tty's.
 			Default is 0 and by setting to 1, it enables UTF-8
 			mode for all newly opened or allocated terminals.
+	
+	keyboard.default_leds=
+			[KEYBOARD]
+			Format=<ledmask>
+			Mask of the leds to activate on consoles by default.
+			ScrollLock: 1
+			NumLock: 2
+			CapsLock: 4
+			KanaLock: 8
 
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
