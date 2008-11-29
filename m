Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYK2WIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYK2WIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYK2WIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:08:41 -0500
Received: from eta-ori.net ([91.121.142.51]:53152 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYK2WIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:08:40 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2008 17:08:40 EST
Message-ID: <4931BB48.9010706@impulze.org>
Date: Sat, 29 Nov 2008 22:59:36 +0100
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081026)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fujitsu Amilo PA 1510 key-release events quirk
Content-Type: multipart/mixed;
 boundary="------------020403020501020108060500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020403020501020108060500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

heya,
the fujitsu amilo pa 1510 laptop needs a little lovin' regarding the 
release event of the volume up and down keys. I attached a format-patch 
(against torvalds/linux-2.6.git ed313489badef16d7) which separates the 
generation of release events for certain scancodes into a macro since 3 
dmi matches are already using it and generation of the missing release 
events for that particular laptop. Please post back with any advice and 
thoughts for that patch.

Thanks in advance.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22


--------------020403020501020108060500
Content-Type: text/plain;
 name="fujitsu-siemens-amilopa1510-quirks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fujitsu-siemens-amilopa1510-quirks.patch"

>From a197dfb0eed23b87418c0a7fe6a562910046576e Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Sat, 29 Nov 2008 22:39:34 +0100
Subject: [PATCH] Separate macro for generation of keyrelease events

---
 drivers/input/keyboard/atkbd.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 22016ca..99ef522 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -834,6 +834,17 @@ static void atkbd_disconnect(struct serio *serio)
 }
 
 /*
+ * generate release events for the keycodes given in forced_release_keys[]
+ */
+#define GEN_RELEASE_EVENT \
+	int i; \
+\
+	if (atkbd->set == 2) \
+		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++) \
+			__set_bit(forced_release_keys[i], \
+				atkbd->force_release_mask);
+
+/*
  * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
@@ -842,12 +853,8 @@ static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 	const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-				  atkbd->force_release_mask);
+	GEN_RELEASE_EVENT
 }
 
 /*
@@ -859,12 +866,8 @@ static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
 	const unsigned int forced_release_keys[] = {
 		0x94,
 	};
-	int i;
 
-	if (atkbd->set == 2)
-		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
-			__set_bit(forced_release_keys[i],
-					atkbd->force_release_mask);
+	GEN_RELEASE_EVENT
 }
 
 /*
-- 
1.6.0.4


>From add1de59a8337442154fb3d7427ae8fd500de47a Mon Sep 17 00:00:00 2001
From: Daniel Mierswa <impulze@impulze.org>
Date: Sat, 29 Nov 2008 22:40:20 +0100
Subject: [PATCH] Fujitsu Siemens Amilo PA 1510 quirks

The volume up and down keys on the Fujitsu Siemens Amilo PA 1510 laptop
won't generate release events, so we have to do that. Use the same
way that is already used with other models.
---
 drivers/input/keyboard/atkbd.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 99ef522..1250242 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -845,6 +845,19 @@ static void atkbd_disconnect(struct serio *serio)
 				atkbd->force_release_mask);
 
 /*
+ * The volume up and volume down special keys on a Fujitsu Amilo PA 1510 laptop
+ * do not generate release events so we have to do it ourselves.
+ */
+static void atkbd_amilopa1510_keymap_fixup(struct atkbd *atkbd)
+{
+	const unsigned int forced_release_keys[] = {
+		0xb0, 0xae,
+	};
+
+	GEN_RELEASE_EVENT
+}
+
+/*
  * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
@@ -1463,6 +1476,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.driver_data = atkbd_dell_laptop_keymap_fixup,
 	},
 	{
+		.ident = "Fujitsu Amilo PA 1510",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"), 
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pa 1510"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_amilopa1510_keymap_fixup,
+	},
+	{
 		.ident = "HP 2133",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
1.6.0.4


--------------020403020501020108060500--
