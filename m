Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYD0M31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYD0M31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYD0M3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:29:19 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:52565 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbYD0M3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:29:18 -0400
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 08:29:18 EDT
Message-ID: <4814612F.5030606@bakke.com>
Date: Sun, 27 Apr 2008 13:19:11 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080229)
MIME-Version: 1.0
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix apple alu keyboard with numpad
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nice apple alu keyboards with numpads are pretty much unusable in
vanilla 2.6.25.
(http://images.apple.com/keyboard/images/gallery/wired_1_20070813.jpg)
Hitting the 'clear' key (=numlock) disables the numpad, and maps multiple
alphanumeric keys to numpad symbols in typical laptopkeyboard fashion.

Furthermore, some of the F-keys do double duty as multimedia keys. The
vanilla kernel defaults to multimedia keys, requiring the user to hit
the 'fn' key to get F-key events. I use F-keys more often than multimedia
keys, so I included the patch to change the default to be F-keys.

The following patch is taken from:
https://bugs.launchpad.net/mactel-support/+bug/201887
and appears to have been written by Eric Johney. I have merely lifted
the two patches from the webpage above and submitted it, as I couldn't
see it upstream after a brief search.


Tested-by: dag@bakke.com

--- linux-2.6.25-gentoo/drivers/hid/hid-input.c 2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-gentoo-r1-apple/drivers/hid/hid-input.c        2008-04-25 23:07:52.925613698 +0200
@@ -34,7 +34,7 @@
  #include <linux/hid.h>
  #include <linux/hid-debug.h>

-static int hid_apple_fnmode = 1;
+static int hid_apple_fnmode = 2;
  module_param_named(pb_fnmode, hid_apple_fnmode, int, 0644);
  MODULE_PARM_DESC(pb_fnmode,
                 "Mode of fn key on Apple keyboards (0 = disabled, 1 = fkeyslast, 2 = fkeysfirst)");
@@ -218,8 +218,9 @@
                         }
                 }

-               if (test_bit(usage->code, hid->pb_pressed_numlock) ||
-                               test_bit(LED_NUML, input->led)) {
+               if ((test_bit(usage->code, hid->pb_pressed_numlock) ||
+                               test_bit(LED_NUML, input->led)) &&
+                               (hid->product < 0x220 ||hid->product >= 0x300)) {
                         trans = find_translation(powerbook_numlock_keys, usage->code);

                         if (trans) {



For "completeness" and the benfit of someone finding this in an archive
later, the following 4 commands provides correct keys for
the multimediakeys in X:

setxkbmap -model macintosh
xmodmap -e "keycode 162 = XF86AudioPlay"
xmodmap -e "keycode 153 = XF86AudioNext"
xmodmap -e "keycode 144 = XF86AudioPrev"

Works with a US layout keyboard, anyway.


Regards,

Dag B.
