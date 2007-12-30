Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbXL3Lil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbXL3Lil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 06:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXL3Lic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 06:38:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXL3Lib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 06:38:31 -0500
Date: Sun, 30 Dec 2007 12:38:11 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH] Get NUMLOCK from PC BIOS
Message-ID: <alpine.LSU.0.999.0712301230270.3273@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19poVyuuxBwLoEvUFDzK1/lXBmWAg+UCnBaO3y
 VQyyULoUXkHZ1bglk+v7VSWlFqlS0QuhcfSN9rLQ8nIJAhtoVH
 T2oe4GXTZVR9rgVaYe5Pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables reading the default NUMLOCK status from the BIOS data
area as defined for IBM PCs (1981). Using this area has been a reliable way
to detect (or set) the NUMLOCK status for about 27 years, and it will
continue to work on any IBM-compatible system that might run DOS. 
Especially, the NUMLOCK status on Linus' famous laptop should be usable.

---

I'd like some information about how this patch works non non-IBM-compatible
x86 PCs. For now, I've documented the wordt possible outcome I can imagine.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

diff -pruN -X dontdiff linux-2.6.23.pure/drivers/char/keyboard.c linux-2.6.23.base/drivers/char/keyboard.c
--- linux-2.6.23.pure/drivers/char/keyboard.c	2007-10-11 14:15:18.000000000 +0200
+++ linux-2.6.23.base/drivers/char/keyboard.c	2007-12-30 12:12:11.000000000 +0100
@@ -24,6 +24,7 @@
  * 21-08-02: Converted to input API, major cleanup. (Vojtech Pavlik)
  */
 
+#include <asm/io.h>
 #include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -57,7 +58,10 @@ extern void ctrl_alt_del(void);
  * to be used for numbers.
  */
 
-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+/* KBD_DEFLEDS is a variable */
+#undef KBD_DEFLEDS
+#elif defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
 #define KBD_DEFLEDS (1 << VC_NUMLOCK)
 #else
 #define KBD_DEFLEDS 0
@@ -1358,8 +1362,17 @@ int __init kbd_init(void)
 {
 	int i;
 	int error;
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+	int KBD_DEFLEDS = 0;
+	/* address 0x40:0x17 */
+	char * bios_kbd_status=xlate_dev_mem_ptr(0x417);
+
+	/* Numlock status bit set? */
+	if (*bios_kbd_status & 0x20)
+		KBD_DEFLEDS = 1 << VC_NUMLOCK;
+#endif
 
-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
diff -pruN -X dontdiff linux-2.6.23.pure/drivers/input/keyboard/Kconfig linux-2.6.23.base/drivers/input/keyboard/Kconfig
--- linux-2.6.23.pure/drivers/input/keyboard/Kconfig	2007-10-11 14:14:41.000000000 +0200
+++ linux-2.6.23.base/drivers/input/keyboard/Kconfig	2007-12-30 12:11:45.000000000 +0100
@@ -12,6 +12,17 @@ menuconfig INPUT_KEYBOARD
 
 if INPUT_KEYBOARD
 
+config KBD_DEFLEDS_PCBIOS
+	bool "Enable Num-Lock based on BIOS settings"
+	depends on X86_PC && EXPERIMENTAL
+	help
+	  Turns on Numlock depending on the BIOS settings.
+	  This works by reading the BIOS data area as defined for IBM PCs (1981).
+
+	  If you have an alternative firmware like OpenFirmware or LinuxBios,
+	  this flag might not be set correctly, which results in a random state
+	  of the Numlock key.
+
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EMBEDDED || !X86_PC
 	default y

-- 
Top 100 things you don't want the sysadmin to say:
39. It is only a minor upgrade, the system should be back up in
    a few hours.  ( This is said on a monday afternoon.)
