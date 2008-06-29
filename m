Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYF2Qy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYF2Qy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYF2Qyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:54:51 -0400
Received: from [88.205.141.71] ([88.205.141.71]:21153 "EHLO mail.ward.six"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753677AbYF2Qyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:54:50 -0400
Date: Sun, 29 Jun 2008 22:54:23 +0600
From: Denis Zaitceff <zaitceff@gmail.com>
To: vojtech@suse.cz, dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] atkbd.c: make the unknown key warnings controllable thru a config option
Message-ID: <20080629225423.A23524@ward.six>
Mail-Followup-To: vojtech@suse.cz, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch allows to configure off the logging of ATKBD_KEY_UNKNOWN
events.  This logging can be healthy, but usually it just pollutes the
kernel log.  And this logging may be _very_ massive.

Very probably that other (than atkbd) keyboard drivers may win from
the similar patches.

Please apply this patch.


--- drivers/input/keyboard/Kconfig
+++ drivers/input/keyboard/Kconfig
@@ -12,6 +12,15 @@ menuconfig INPUT_KEYBOARD
 
 if INPUT_KEYBOARD
 
+config KEYBOARD_VERBOSE_KEY_UNKNOWN
+	bool "Report unknown keys"
+	default n
+	help
+	  If Y, each press and release of any key unknown to the keyboard driver
+	  will be logged at the KERN_WARNING level.  This is really good if you
+	  want to study your keyboard, but may really flood your logs.
+	  Be warned!
+
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EMBEDDED || !X86_PC
 	default y
--- drivers/input/keyboard/atkbd.c
+++ drivers/input/keyboard/atkbd.c
@@ -442,6 +442,7 @@ static irqreturn_t atkbd_interrupt(struc
 		case ATKBD_KEY_NULL:
 			break;
 		case ATKBD_KEY_UNKNOWN:
+#ifdef KEYBOARD_VERBOSE_KEY_UNKNOWN
 			printk(KERN_WARNING
 			       "atkbd.c: Unknown key %s (%s set %d, code %#x on %s).\n",
 			       atkbd->release ? "released" : "pressed",
@@ -450,6 +451,7 @@ static irqreturn_t atkbd_interrupt(struc
 			printk(KERN_WARNING
 			       "atkbd.c: Use 'setkeycodes %s%02x <keycode>' to make it known.\n",
 			       code & 0x80 ? "e0" : "", code & 0x7f);
+#endif
 			input_sync(dev);
 			break;
 		case ATKBD_SCR_1:
