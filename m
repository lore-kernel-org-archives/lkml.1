Return-Path: <linux-kernel-owner+w=401wt.eu-S1759120AbZAGA6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120AbZAGA6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZAGA6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:58:20 -0500
Received: from solo.fdn.fr ([80.67.169.19]:38921 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769AbZAGA6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:58:19 -0500
Date: Wed, 7 Jan 2009 01:58:13 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
Subject: [PATCH] Let keyboard notifiers modify key codes
Message-ID: <20090107005813.GA4987@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make kbd_keycode() read param.value after calling the keyboard notification
chain, to let the callee change the translation on the fly. This for instance
permits to remap the physical positions of the keys independently of the
configured keymap, for e.g. single-handed people.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/char/keyboard.c.orig	2009-01-07 00:48:46.000000000 +0100
+++ linux/drivers/char/keyboard.c	2009-01-07 01:02:05.000000000 +0100
@@ -1248,6 +1248,7 @@ kbd_keycode
 		kbd->slockstate = 0;
 		return;
 	}
+	keycode = param.value;
 
 	if (keycode >= NR_KEYS)
 		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
@@ -1263,6 +1264,7 @@ kbd_keycode
 		param.value = keysym;
 		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
 			return;
+		keysym = param.value;
 		if (down && !raw_mode)
 			to_utf8(vc, keysym);
 		return;
@@ -1282,6 +1284,7 @@ kbd_keycode
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYSYM, &param) == NOTIFY_STOP)
 		return;
+	keysym = param.value;
 
 	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
 		return;
--- linux/Documentation/input/notifier.txt.orig	2008-04-17 12:14:30.000000000 +0200
+++ linux/Documentation/input/notifier.txt	2009-01-07 01:04:16.000000000 +0100
@@ -21,7 +21,8 @@
 
 For each kind of event but the last, the callback may return NOTIFY_STOP in
 order to "eat" the event: the notify loop is stopped and the keyboard event is
-dropped.
+dropped.  The callee can also modify param.value so as to change the key
+translation.
 
 In a rough C snippet, we have:
 
@@ -33,18 +34,26 @@
 		notifier_call_chain(KBD_UNBOUND_KEYCODE,&params);
 		return;
 	}
+	keycode = param.value;
+
+	...
 
 	if (unicode) {
 		param.value = unicode;
 		if (notifier_call_chain(KBD_UNICODE,&params) == NOTIFY_STOP)
 			return;
+		keysym = param.value;
 		emit unicode;
 		return;
 	}
 
+	...
+
 	params.value = keysym;
 	if (notifier_call_chain(KBD_KEYSYM,&params) == NOTIFY_STOP)
 		return;
+	keysym = params.value;
+
 	apply keysym;
 	notifier_call_chain(KBD_POST_KEYSYM,&params);
 }
