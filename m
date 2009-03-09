Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZCIBDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZCIBDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 21:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZCIBDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 21:03:30 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:11434 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZCIBD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 21:03:29 -0400
Message-ID: <49B46ADA.5060809@poczta.fm>
Date: Mon, 09 Mar 2009 02:03:22 +0100
From: Lukasz Stelmach <stlman@poczta.fm>
User-Agent: Thunderbird 2.0.0.19 (X11/20090124)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] use multitouch touchpad events as buttons mousedev
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: 41d8b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- --- drivers/input/mousedev.c~	2009-03-08 15:11:11.000000000 +0100
+++ drivers/input/mousedev.c	2009-03-09 00:27:34.000000000 +0100
@@ -316,7 +316,7 @@
 		wake_up_interruptible(&mousedev->wait);
 }

- -static void mousedev_touchpad_touch(struct mousedev *mousedev, int value)
+static void mousedev_touchpad_touch(struct mousedev *mousedev, unsigned int code, int value)
 {
 	if (!value) {
 		if (mousedev->touch &&
@@ -327,13 +327,23 @@
 			 * We rely on the fact that mousedev_mix always has 0
 			 * motion packet so we won't mess current position.
 			 */
- -			set_bit(0, &mousedev->packet.buttons);
- -			set_bit(0, &mousedev_mix->packet.buttons);
+			int index;
+
+			switch (code) {
+			case BTN_TOOL_DOUBLETAP: index = 1; break;
+
+			case BTN_TOOL_TRIPLETAP: index = 2; break;
+
+			default: index = 0;
+			}
+
+			set_bit(index, &mousedev->packet.buttons);
+			set_bit(index, &mousedev_mix->packet.buttons);
 			mousedev_notify_readers(mousedev, &mousedev_mix->packet);
 			mousedev_notify_readers(mousedev_mix,
 						&mousedev_mix->packet);
- -			clear_bit(0, &mousedev->packet.buttons);
- -			clear_bit(0, &mousedev_mix->packet.buttons);
+			clear_bit(index, &mousedev->packet.buttons);
+			clear_bit(index, &mousedev_mix->packet.buttons);
 		}
 		mousedev->touch = mousedev->pkt_count = 0;
 		mousedev->frac_dx = 0;
@@ -371,7 +381,7 @@
 		if (value != 2) {
 			if (code == BTN_TOUCH &&
 			    test_bit(BTN_TOOL_FINGER, handle->dev->keybit))
- -				mousedev_touchpad_touch(mousedev, value);
+				mousedev_touchpad_touch(mousedev, code, value);
 			else
 				mousedev_key_event(mousedev, code, value);
 		}

Some touchpads can recognize multi-finger taps. They can be used as
additional buttons (left and middle).

	Signed-off-by: Łukasz Stelmach <stlman@poczta.fm>


Please CC any comments.
- --
Było mi bardzo miło.               Czwarta pospolita klęska, [...]
>Łukasz<                 Już nie katolicka lecz złodziejska.  (c)PP
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkm0atoACgkQNdzY8sm9K9z8rQCfQkfJ4xHSEeao6yy9wzz/6zkT
t0kAni6046EHiTmVc7McixxEsrSfJZDS
=w8xZ
-----END PGP SIGNATURE-----


----------------------------------------------------------------------
Udar sloneczny prezesa Kaczynskiego... >>> http://link.interia.pl/f2083

