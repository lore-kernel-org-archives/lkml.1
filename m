Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbZBDSyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbZBDSyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbZBDStQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:16 -0500
Received: from kroah.org ([198.145.64.141]:34367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761357AbZBDStJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:09 -0500
Date: Wed, 4 Feb 2009 10:46:08 -0800
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
       alan@lxorguk.ukuu.org.uk, Stuart Hopkins <stuart@dodgy-geeza.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 10/41] Input: atkbd - Samsung NC10 key repeat fix
Message-ID: <20090204184608.GK25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-atkbd-samsung-nc10-key-repeat-fix.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stuart Hopkins <stuart@dodgy-geeza.com>

commit 4200844bd9dc511088258437d564a187f0ffc94e upstream.

This patch fixes the key repeat issue with the Fn+F? keys on the new
Samsung NC10 Netbook, so that the keys can be defined and used within
ACPID correctly, otherwise the keys repeat indefinately.

This solves part of http://bugzilla.kernel.org/show_bug.cgi?id=12021

Signed-off-by: Stuart Hopkins <stuart@dodgy-geeza.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/keyboard/atkbd.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -884,6 +884,22 @@ static void atkbd_inventec_keymap_fixup(
 }
 
 /*
+ * Samsung NC10 with Fn+F? key release not working
+ */
+static void atkbd_samsung_keymap_fixup(struct atkbd *atkbd)
+{
+	const unsigned int forced_release_keys[] = {
+		0x82, 0x83, 0x84, 0x86, 0x88, 0x89, 0xb3, 0xf7, 0xf9,
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
@@ -1512,6 +1528,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.callback = atkbd_setup_fixup,
 		.driver_data = atkbd_inventec_keymap_fixup,
 	},
+	{
+		.ident = "Samsung NC10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_samsung_keymap_fixup,
+	},
 	{ }
 };
 

