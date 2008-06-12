Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYFLNLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYFLNLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYFLNK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:10:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:60646 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759026AbYFLNKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:10:55 -0400
Date: Thu, 12 Jun 2008 15:10:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: fix HP 2133 not sending release event for video switch
Message-ID: <Pine.LNX.4.64.0806121509350.10085@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video switch key on HP 2133 doesn't send release event, so we
have to create workaround similar to what we do for Dell Latitude,
i.e. perform DMI match for the system and generate 'false' release
event ourselves, so that userspace doesn't think that the key is
stuck forever.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/input/keyboard/atkbd.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index af58a6f..005173a 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -851,6 +851,23 @@ static void atkbd_latitude_keymap_fixup(struct atkbd *atkbd)
 }
 
 /*
+ * Perform fixup for HP system that doesn't generate release
+ * for its video switch
+ */
+static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
+{
+	const unsigned int forced_release_keys[] = {
+		0x94,
+	};
+	int i;
+
+	if (atkbd->set == 2)
+		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
+			__set_bit(forced_release_keys[i],
+					atkbd->force_release_mask);
+}
+
+/*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
  * according to the selected scancode set
  */
@@ -1452,6 +1469,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_latitude_keymap_fixup,
 	},
+	{
+		.ident = "HP 2133",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP 2133"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_hp_keymap_fixup,
+	},
 	{ }
 };
 
-- 
1.5.2.4

