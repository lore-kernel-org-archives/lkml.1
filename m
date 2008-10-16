Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYJPLtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYJPLtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbYJPLs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:48:56 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:56424 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbYJPLsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:48:55 -0400
Date: Thu, 16 Oct 2008 13:59:49 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Use PC-BIOS NUMLOCK flag
Message-ID: <alpine.LSU.0.999.0810161358540.5404@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PC BIOS does provide a NUMLOCK flag containing the desired state of this
LED. Use it.

Signed-off-by: Bodo Eggert <7eggert@gmx.de>

---
 char/keyboard.c        |   17 +++++++++++++++--
 input/keyboard/Kconfig |   11 +++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)
   

diff -pruNXdontdiff linux-2.6.27.softpanic/drivers/char/keyboard.c linux-2.6.27.2-numlock/drivers/char/keyboard.c
--- linux-2.6.27.softpanic/drivers/char/keyboard.c	2008-10-10 13:18:18.000000000 +0200
+++ linux-2.6.27.2-numlock/drivers/char/keyboard.c	2008-10-10 20:34:44.000000000 +0200
@@ -24,6 +24,7 @@
  * 21-08-02: Converted to input API, major cleanup. (Vojtech Pavlik)
  */
 
+#include <asm/io.h>
 #include <linux/consolemap.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -61,7 +62,10 @@ extern void ctrl_alt_del(void);
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
@@ -1406,8 +1410,17 @@ int __init kbd_init(void)
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
diff -pruNXdontdiff linux-2.6.27.softpanic/drivers/input/keyboard/Kconfig linux-2.6.27.2-numlock/drivers/input/keyboard/Kconfig
--- linux-2.6.27.softpanic/drivers/input/keyboard/Kconfig	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.27.2-numlock/drivers/input/keyboard/Kconfig	2008-10-10 20:33:52.000000000 +0200
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
"Oh Guru, what is the secret of Life?"
"Enjoy the journey, because the destination sucks."
	-- Gandalf Parker
