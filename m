Return-Path: <linux-kernel-owner+w=401wt.eu-S2992960AbXDYTOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992960AbXDYTOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDYTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:14:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992960AbXDYTOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:14:06 -0400
Message-ID: <462FA849.7090901@redhat.com>
Date: Wed, 25 Apr 2007 15:13:13 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.4.35-pre4] fix 'pc_keyb: controller jammed (0xA7)' error
 on systems with KVM
Content-Type: multipart/mixed;
 boundary="------------090502050804030205080402"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090502050804030205080402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ive had a few requests for this patch, so Im posting it against 
linux-2.4.35-pre4 kernel.

Various hardware (IBM BladeCenter, Sun Fire servers, and many other 
bladeserver systems) 
have an integrated KVM or console switch.  The keyboard type on these 
systems is often USB,
and the hardware usually does not have a legacy PS/2 console keyboard. 
The 2.4 kernel always tries to
initialize the keyboard controller by default, and on systems without 
such a keyboard present
at boot you get the following errors spewed to the logs:

Jun  3 10:21:06 sbknpwaq3 kernel: pc_keyb: controller jammed (0xA7).
Jun  3 10:21:08 sbknpwaq3 last message repeated 249 times
Jun  3 10:21:08 sbknpwaq3 kernel: Keyboard timed out[1]
Jun  3 10:21:08 sbknpwaq3 kernel: pc_keyb: controller jammed (0xA7).
Jun  3 10:21:08 sbknpwaq3 last message repeated 249 times
Jun  3 10:21:08 sbknpwaq3 kernel: Keyboard timed out[1]


This patch allows the kernel to skip the keyboard controller init so the 
kernel does not try to initialize, fail
and spew errors when no keyboard is attached. This can also be used for 
various systems without a traditional
console keyboard present at boot (includes USB or IrDA keyboard too and 
systems connected to KVM's).
Ive provided the dmi_scan magic in this parch for the IBM BladeCenter, 
but on other hardware, use the "nokeyb"
kernel-param at boot to skip the initialization.

Tested on IBM BladeCenter, and Sun Fire.
 

Signed-off-by: Brian Maly <bmaly@redhat>

Regards, Brian



Documentation/kernel-parameters.txt |    4 ++++
 arch/i386/kernel/dmi_scan.c         |   24 ++++++++++++++++++++++++
 drivers/char/pc_keyb.c              |   15 +++++++++++----
 3 files changed, 39 insertions(+), 4 deletions(-)



--------------090502050804030205080402
Content-Type: text/x-patch;
 name="removable-keyboard-2.4.35-pre4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="removable-keyboard-2.4.35-pre4.patch"

--- a/drivers/char/pc_keyb.c	2007-04-24 15:47:49.000000000 -0400
+++ b/drivers/char/pc_keyb.c	2007-04-24 15:30:24.000000000 -0400
@@ -61,6 +61,14 @@ unsigned char pckbd_sysrq_xlate[128] =
 	"\r\000/";					/* 0x60 - 0x6f */
 #endif
 
+int keyboard_controller_present __initdata = 1;
+static int __init removable_keyb(char *str)
+{
+        keyboard_controller_present = 0;
+        return 0;
+}
+__setup("nokeyb", removable_keyb);
+
 static void kbd_write_command_w(int data);
 static void kbd_write_output_w(int data);
 #ifdef CONFIG_PSMOUSE
@@ -69,9 +77,8 @@ static void __aux_write_ack(int val);
 static int aux_reconnect = 0;
 #endif
 
-#ifndef kbd_controller_present
-#define kbd_controller_present()	1
-#endif
+#define kbd_controller_present() keyboard_controller_present
+
 static spinlock_t kbd_controller_lock = SPIN_LOCK_UNLOCKED;
 static unsigned char handle_kbd_event(void);
 
@@ -898,7 +905,7 @@ static char * __init initialize_kbd(void
 
 void __init pckbd_init_hw(void)
 {
-	if (!kbd_controller_present()) {
+	if (!keyboard_controller_present) {
 		kbd_exists = 0;
 		return;
 	}
--- a/arch/i386/kernel/dmi_scan.c	2007-04-24 15:47:04.000000000 -0400
+++ b/arch/i386/kernel/dmi_scan.c	2007-04-24 15:30:24.000000000 -0400
@@ -524,6 +524,21 @@ static __init int disable_acpi_pci(struc
  */
  
 
+/*      IBM bladeservers have a USB console switch. The keyboard type is USB
+ *      and the hardware does not have a console keyboard. We disable the
+ *      console keyboard so the kernel does not try to initialize one and
+ *      spew errors. This can be used for all systems without a console
+ *      keyboard like systems with just a USB or IrDA keyboard.
+ */
+static __init int disable_console_keyboard(struct dmi_blacklist *d)
+{
+        extern int keyboard_controller_present;
+        printk(KERN_INFO "*** Hardware has no console keyboard controller.\n");
+        printk(KERN_INFO "*** Disabling console keyboard.\n");
+        keyboard_controller_present = 0;
+        return 0;
+}
+
 /*
  *	This will be expanded over time to force things like the APM 
  *	interrupt mask settings according to the laptop
@@ -810,6 +825,15 @@ static __initdata struct dmi_blacklist d
 			MATCH(DMI_SYS_VENDOR, "IBM"),
 			NO_MATCH, NO_MATCH, NO_MATCH
 			} },
+ /*
+         *      IBM Bladeservers
+         */
+
+        { disable_console_keyboard, "IBM Server Blade", {
+                        MATCH(DMI_SYS_VENDOR,"IBM"),
+                        MATCH(DMI_BOARD_NAME, "Server Blade"),
+                        NO_MATCH, NO_MATCH
+                        } },
 
 #ifdef	CONFIG_ACPI_BOOT
 	/*
 
--- a/Documentation/kernel-parameters.txt	2007-04-25 12:49:22.000000000 -0400
+++ b/Documentation/kernel-parameters.txt	2007-04-25 13:02:53.000000000 -0400
@@ -430,6 +430,10 @@ running once the system is up.
 			initial RAM disk.
 
 	nointroute	[IA-64]
+
+	nokeyb		[HW] Skip console keyboard initialization for systems 
+			without a console keyboard, removable keyboard, or 
+			bladecenters with a USB console keyboard switch, etc.
  
 	nolapic		[IA-32,APIC] Do not enable or use the local APIC.
 

--------------090502050804030205080402--
