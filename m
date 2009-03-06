Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZCFFdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZCFFdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZCFFdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:33:22 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:57243 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZCFFdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:33:21 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid/apple: add module parameter to swap the Command and Option keys
Date: Fri, 06 Mar 2009 18:33:18 +1300
Message-ID: <87zlfz8bc1.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple keyboards have the Command keys (a.k.a. the Apple or "waffle" key)
in the positions normally occupied on PC keyboards by the Alt/AltGr keys,
and the Option or Alt keys in the position occupied by the so-called
Windows keys.  Folks who have been using PC-type computers for too long
generally have insurmountable muscle memory in this regard.

This patch adds a module parameter, defaulting to off, that swaps these keys.

The same effect can also be achieved by changing the console and X
keymaps, but this approach does not scale.  For example, I don't want to
have to learn how to reconfigure Wayland's keymaps when the future
arrives and we all start using it, and there may be applications I don't
know about that also read keyboard events directly.

Signed-off-by: Paul Collins <paul@ondioline.org>
---
 drivers/hid/hid-apple.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 7ed94cf..63e9ee3 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -40,6 +40,11 @@ module_param(fnmode, uint, 0644);
 MODULE_PARM_DESC(fnmode, "Mode of fn key on Apple keyboards (0 = disabled, "
 		"[1] = fkeyslast, 2 = fkeysfirst)");
 
+static unsigned int swapmodifiers = 0;
+module_param(swapmodifiers, uint, 0644);
+MODULE_PARM_DESC(fnmode, "Modifiers match labels or positions "
+		 "([0] = labels, 1 = positions)");
+
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
@@ -123,6 +128,14 @@ static struct apple_key_translation apple_iso_keyboard[] = {
 	{ }
 };
 
+static struct apple_key_translation apple_swap_modifiers[] = {
+	{ KEY_LEFTALT,	KEY_LEFTMETA },
+	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
+	{ KEY_LEFTMETA,	KEY_LEFTALT },
+	{ KEY_RIGHTMETA, KEY_RIGHTALT },
+	{ }
+};
+
 static struct apple_key_translation *apple_find_translation(
 		struct apple_key_translation *table, u16 from)
 {
@@ -199,6 +212,14 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
+	if (swapmodifiers) {
+		trans = apple_find_translation(apple_swap_modifiers, usage->code);
+		if (trans) {
+			input_event(input, usage->type, trans->to, value);
+			return 1;
+		}
+	}
+
 	if (asc->quirks & APPLE_ISO_KEYBOARD) {
 		trans = apple_find_translation(apple_iso_keyboard, usage->code);
 		if (trans) {

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
