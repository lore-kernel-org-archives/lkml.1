Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYBIBdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYBIBdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 20:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbYBIBdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 20:33:43 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:20592 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758339AbYBIBdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 20:33:41 -0500
X-Greylist: delayed 96676 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 20:33:27 EST
Date: Sat, 9 Feb 2008 01:33:22 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: torvalds@osdl.org, linux-input@vger.kernel.org, dtor@mail.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] keyboard notifier documentation
Message-ID: <20080209013322.GC4463@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	torvalds@osdl.org, linux-input@vger.kernel.org, dtor@mail.ru,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
X-Cloudmark-Analysis: v=1.0 c=1 a=vgUJB+MMWQXyFPPprAVJSw==:17 a=eOpj_Dqyrppc4suWQs4A:9 a=sZwwuO8ceSid-uJfSYKz5k4lMjQA:4 a=9B0AjoBSoiEA:10 a=3N6FRji80VMA:10 a=ziFrdkHw70AA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the keyboard notifier.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- /dev/null	2008-02-09 01:22:34.790011677 +0000
+++ linux/Documentation/input/notifier.txt	2008-02-09 01:28:12.000000000 +0000
@@ -0,0 +1,52 @@
+Keyboard notifier
+
+One can use register_keyboard_notifier to get called back on keyboard
+events (see kbd_keycode() function for details).  The passed structure is
+keyboard_notifier_param:
+
+- 'vc' always provide the VC for which the keyboard event applies ;
+- 'down' is 1 for a key press event, 0 for a key release ;
+- 'shift' is the current modifier state, mask bit indexes are KG_* ;
+- 'value' depends on the type of event.
+
+- KBD_KEYCODE events are always sent before other events, value is the keycode.
+- KBD_UNBOUND_KEYCODE events are sent if the keycode is not bound to a keysym.
+  value is the keycode.
+- KBD_UNICODE events are sent if the keycode -> keysym translation produced a
+  unicode character. value is the unicode value.
+- KBD_KEYSYM events are sent if the keycode -> keysym translation produced a
+  non-unicode character. value is the keysym.
+- KBD_POST_KEYSYM events are sent after the treatment of non-unicode keysyms.
+  That permits to inspect the resulting LEDs for instance.
+
+For each kind of event but the last, the callback may return NOTIFY_STOP in
+order to "eat" the event: the notify loop is stopped and the keyboard event is
+dropped.
+
+I a rough C snippet, we have:
+
+kbd_keycode(keycode) {
+	...
+	params.value = keycode;
+	if (notifier_call_chain(KBD_KEYCODE,&params) == NOTIFY_STOP)
+	    || !bound) {
+		notifier_call_chain(KBD_UNBOUND_KEYCODE,&params);
+		return;
+	}
+
+	if (unicode) {
+		param.value = unicode;
+		if (notifier_call_chain(KBD_UNICODE,&params) == NOTIFY_STOP)
+			return;
+		emit unicode;
+		return;
+	}
+
+	params.value = keysym;
+	if (notifier_call_chain(KBD_KEYSYM,&params) == NOTIFY_STOP)
+		return;
+	apply keysym;
+	notifier_call_chain(KBD_POST_KEYSYM,&params);
+}
+
+NOTE: This notifier is usually called from interrupt context.
