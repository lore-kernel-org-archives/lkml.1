Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYLCT6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYLCT6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYLCTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:37 -0500
Received: from kroah.org ([198.145.64.141]:59625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754641AbYLCTu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:28 -0500
Date: Wed, 3 Dec 2008 11:49:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
       Adel Gadllah <adel.gadllah@gmail.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 020/104] Input: atkbd - add keymap quirk for Inventec
	Symphony systems
Message-ID: <20081203194904.GU8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-atkbd-add-keymap-quirk-for-inventec-symphony-systems.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Matthew Garrett <mjg@redhat.com>

commit a8215b81cc31cf267506bc6a4a4bfe93f4ca1652 upstream.

The Zepto 6615WD laptop (rebranded Inventec Symphony system) needs a
key release quirk for its volume keys to work. The attached patch adds
the quirk to the atkbd driver.

Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=460237

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/keyboard/atkbd.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -868,6 +868,22 @@ static void atkbd_hp_keymap_fixup(struct
 }
 
 /*
+ * Inventec system with broken key release on volume keys
+ */
+static void atkbd_inventec_keymap_fixup(struct atkbd *atkbd)
+{
+	const unsigned int forced_release_keys[] = {
+		0xae, 0xb0,
+	};
+	int i;
+
+	if (atkbd->set == 2)
+		for (i = 0; i < ARRAY_SIZE(forced_release_keys); i++)
+			__set_bit(forced_release_keys[i],
+				  atkbd->force_release_mask);
+}
+
+/*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
  * according to the selected scancode set
  */
@@ -1478,6 +1494,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_hp_keymap_fixup,
 	},
+	{
+		.ident = "Inventec Symphony",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "INVENTEC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SYMPHONY 6.0/7.0"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_inventec_keymap_fixup,
+	},
 	{ }
 };
 

