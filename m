Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYJOHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYJOHa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYJOHaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:30:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34604 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbYJOHaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:30:13 -0400
Date: Wed, 15 Oct 2008 10:30:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [2.6 patch] HID: fix default building of all quirky devices
Message-ID: <20081015073011.GE20183@cs181140183.pp.htv.fi>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081015050557.GB20183@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9be7bbd54df3c9c393ccd19acc49f90c517d1291
(HID: build drivers for all quirky devices by default)
was wrong in that it select'ed the drivers, causing
build errors like the following with CONFIG_USB_HID=n:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `bright_probe':
drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
drivers/built-in.o: In function `dell_probe':
drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
drivers/built-in.o: In function `lg_probe':
drivers/hid/hid-lg.c:252: undefined reference to `usbhid_set_leds'
drivers/hid/hid-lg.c:252: more undefined references to `usbhid_set_leds' follow
drivers/built-in.o: In function `sony_set_operational':
drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->


Implement it in a better way.


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/hid/Kconfig |   91 +++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 55 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index da64108..eec9b73 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -17,25 +17,6 @@ config HID
 	tristate "Generic HID support"
 	depends on INPUT
 	default y
-        select HID_A4TECH if !EMBEDDED
-        select HID_APPLE if !EMBEDDED
-        select HID_BELKIN if !EMBEDDED
-        select HID_BRIGHT if !EMBEDDED
-        select HID_CHERRY if !EMBEDDED
-        select HID_CHICONY if !EMBEDDED
-        select HID_CYPRESS if !EMBEDDED
-        select HID_DELL if !EMBEDDED
-        select HID_EZKEY if !EMBEDDED
-        select HID_GYRATION if !EMBEDDED
-        select HID_LOGITECH if !EMBEDDED
-        select HID_MICROSOFT if !EMBEDDED
-        select HID_MONTEREY if !EMBEDDED
-        select HID_PANTHERLORD if !EMBEDDED
-        select HID_PETALYNX if !EMBEDDED
-        select HID_SAMSUNG if !EMBEDDED
-        select HID_SONY if !EMBEDDED
-        select HID_SUNPLUS if !EMBEDDED
-
 	---help---
 	  A human interface device (HID) is a type of computer device that
 	  interacts directly with and takes input from humans. The term "HID"
@@ -102,15 +83,15 @@ config HID_COMPAT
 	If unsure, say Y.
 
 config HID_A4TECH
-	tristate "A4 tech"
-	default m
+	tristate "A4 tech" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
 config HID_APPLE
-	tristate "Apple"
-	default m
+	tristate "Apple" if EMBEDDED
+	default (USB_HID || BT_HIDP)
 	depends on (USB_HID || BT_HIDP)
 	---help---
 	Support for some Apple devices which less or more break
@@ -123,64 +104,64 @@ config HID_APPLE
 	If unsure, say M.
 
 config HID_BELKIN
-	tristate "Belkin"
-	default m
+	tristate "Belkin" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
 config HID_BRIGHT
-	tristate "Bright"
-	default m
+	tristate "Bright" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Bright ABNT-2 keyboard.
 
 config HID_CHERRY
-	tristate "Cherry"
-	default m
+	tristate "Cherry" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Cherry Cymotion.
 
 config HID_CHICONY
-	tristate "Chicony"
-	default m
+	tristate "Chicony" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Chicony Tactical pad.
 
 config HID_CYPRESS
-	tristate "Cypress"
-	default m
+	tristate "Cypress" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Cypress mouse and barcodes.
 
 config HID_DELL
-	tristate "Dell"
-	default m
+	tristate "Dell" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Dell W7658.
 
 config HID_EZKEY
-	tristate "Ezkey"
-	default m
+	tristate "Ezkey" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Ezkey mouse and barcodes.
 
 config HID_GYRATION
-	tristate "Gyration"
-	default m
+	tristate "Gyration" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Gyration remote.
 
 config HID_LOGITECH
-	tristate "Logitech"
-	default m
+	tristate "Logitech" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for some Logitech devices which breaks less or more
@@ -211,23 +192,23 @@ config LOGIRUMBLEPAD2_FF
 	  Rumblepad 2 devices.
 
 config HID_MICROSOFT
-	tristate "Microsoft"
-	default m
+	tristate "Microsoft" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for some Microsoft devices which breaks less or more
 	HID specification.
 
 config HID_MONTEREY
-	tristate "Monterey"
-	default m
+	tristate "Monterey" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Monterey Genius KB29E.
 
 config HID_PANTHERLORD
-	tristate "Pantherlord devices support"
-	default m
+	tristate "Pantherlord devices support" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for PantherLord/GreenAsia based device support.
@@ -242,29 +223,29 @@ config PANTHERLORD_FF
 	  or adapter and want to enable force feedback support for it.
 
 config HID_PETALYNX
-	tristate "Petalynx"
-	default m
+	tristate "Petalynx" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Petalynx Maxter remote.
 
 config HID_SAMSUNG
-	tristate "Samsung"
-	default m
+	tristate "Samsung" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Samsung IR remote.
 
 config HID_SONY
-	tristate "Sony"
-	default m
+	tristate "Sony" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Sony PS3 controller.
 
 config HID_SUNPLUS
-	tristate "Sunplus"
-	default m
+	tristate "Sunplus" if EMBEDDED
+	default USB_HID
 	depends on USB_HID
 	---help---
 	Support for Sunplus WDesktop input device.

