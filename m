Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZKKJJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZKKJJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZKKJJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:09:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZKKJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y0VqgMYl3+Qe3MtSElgqueoToN54Yxeiz4h5JMwsOci30S8rFHH7HARcqRxlTJnxtL
         yxV4mx+0BqJCPGUAM+qJmug5AJXNyxg1yfXgwlzIXo94vj/3cIJNwNhz96mkw0lC3nb7
         S3T7rUPHyM59lq+YD+lI3RaSz6XZL+KGsnCCw=
Subject: [PATCH v2] ALPS: Add support for 4 directions button on Acer
 Aspire 5720
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <20091110173047.GC15263@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop>
	 <1257846940.4921.11.camel@maxim-laptop>
	 <1257847427.4921.13.camel@maxim-laptop>
	 <20091110173047.GC15263@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 11:09:50 +0200
Message-ID: <1257930590.3601.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6b263982ffd62ae4621a5202f0084983af8dc093 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Wed, 11 Nov 2009 11:03:35 +0200
Subject: [PATCH] ALPS: Add support for 4 directions button on Acer Aspire 5720
 Implemented using DMI due to uncertainty about systems that have
 only the middle button

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/input/mouse/alps.c |   75 +++++++++++++++++++++++++++++++++++++-------
 drivers/input/mouse/alps.h |    2 +-
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index f361106..96fa093 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/dmi.h>
 
 #include "psmouse.h"
 #include "alps.h"
@@ -28,13 +29,16 @@
 #define dbg(format, arg...) do {} while (0)
 #endif
 
-#define ALPS_DUALPOINT	0x01
-#define ALPS_WHEEL	0x02
-#define ALPS_FW_BK_1	0x04
-#define ALPS_4BTN	0x08
-#define ALPS_OLDPROTO	0x10
-#define ALPS_PASS	0x20
-#define ALPS_FW_BK_2	0x40
+
+#define ALPS_OLDPROTO		0x01	/* old style input */
+#define ALPS_DUALPOINT		0x02	/* touchpad has trackstick */
+#define ALPS_PASS		0x04	/* select which device to address each time */
+
+#define ALPS_WHEEL		0x08	/* hardware wheel present */
+#define ALPS_FW_BK_1		0x10	/* front & back buttons present */
+#define ALPS_FW_BK_2		0x20	/* front & back buttons present */
+#define ALPS_FOUR_BUTTONS	0x40	/* 4 direction button present */
+
 
 static const struct alps_model_info alps_model_data[] = {
 	{ { 0x32, 0x02, 0x14 },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
@@ -117,7 +121,7 @@ static void alps_process_packet(struct psmouse *psmouse)
 		z = packet[5];
 	}
 
-	if (priv->i->flags & ALPS_FW_BK_1) {
+	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FOUR_BUTTONS)) {
 		back = packet[0] & 0x10;
 		forward = packet[2] & 4;
 	}
@@ -147,7 +151,9 @@ static void alps_process_packet(struct psmouse *psmouse)
 
 	input_report_key(dev, BTN_LEFT, left);
 	input_report_key(dev, BTN_RIGHT, right);
-	input_report_key(dev, BTN_MIDDLE, middle);
+
+	if (!(priv->i->flags & ALPS_FOUR_BUTTONS))
+		input_report_key(dev, BTN_MIDDLE, middle);
 
 	/* Convert hardware tap to a reasonable Z value */
 	if (ges && !fin) z = 40;
@@ -185,6 +191,13 @@ static void alps_process_packet(struct psmouse *psmouse)
 		input_report_key(dev, BTN_BACK, back);
 	}
 
+	if (priv->i->flags & ALPS_FOUR_BUTTONS) {
+		input_report_key(dev, BTN_0, forward);
+		input_report_key(dev, BTN_1, back);
+		input_report_key(dev, BTN_2, middle);
+		input_report_key(dev, BTN_3, packet[0] & 0x20);
+	}
+
 	input_sync(dev);
 }
 
@@ -216,7 +229,8 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
 	return PSMOUSE_GOOD_DATA;
 }
 
-static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int *version)
+static struct alps_model_info *alps_get_model(struct psmouse *psmouse,
+								int *version)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	static const unsigned char rates[] = { 0, 10, 20, 40, 60, 80, 100, 200 };
@@ -268,9 +282,15 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int
 
 	for (i = 0; i < ARRAY_SIZE(alps_model_data); i++)
 		if (!memcmp(param, alps_model_data[i].signature,
-			    sizeof(alps_model_data[i].signature)))
-			return alps_model_data + i;
+			    sizeof(alps_model_data[i].signature))) {
+
+			model_info = kmalloc(sizeof(struct alps_model_info),
+				GFP_KERNEL);
 
+			memcpy(model_info, alps_model_data + i,
+				sizeof(struct alps_model_info));
+			return model_info;
+		}
 	return NULL;
 }
 
@@ -393,6 +413,25 @@ static int alps_poll(struct psmouse *psmouse)
 	return 0;
 }
 
+static int alps_dmi_flags;
+static int alps_acer_5720_flags(const struct dmi_system_id *d)
+{
+	alps_dmi_flags = ALPS_FOUR_BUTTONS;
+	return 0;
+}
+
+static struct dmi_system_id alps_dmi_table[] = {
+	{
+	 .callback = alps_acer_5720_flags,
+	 .ident = "Acer Aspire 5720",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5720"),
+		},
+	},
+	{}
+};
+
 static int alps_hw_init(struct psmouse *psmouse, int *version)
 {
 	struct alps_data *priv = psmouse->private;
@@ -401,6 +440,10 @@ static int alps_hw_init(struct psmouse *psmouse, int *version)
 	if (!priv->i)
 		return -1;
 
+	dmi_check_system(alps_dmi_table);
+	if (alps_dmi_flags)
+		priv->i->flags = alps_dmi_flags;
+
 	if ((priv->i->flags & ALPS_PASS) &&
 	    alps_passthrough_mode(psmouse, true)) {
 		return -1;
@@ -446,6 +489,7 @@ static void alps_disconnect(struct psmouse *psmouse)
 
 	psmouse_reset(psmouse);
 	input_unregister_device(priv->dev2);
+	kfree(priv->i);
 	kfree(priv);
 }
 
@@ -487,6 +531,13 @@ int alps_init(struct psmouse *psmouse)
 		dev1->keybit[BIT_WORD(BTN_BACK)] |= BIT_MASK(BTN_BACK);
 	}
 
+	if (priv->i->flags & ALPS_FOUR_BUTTONS) {
+		dev1->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_0);
+		dev1->keybit[BIT_WORD(BTN_1)] |= BIT_MASK(BTN_1);
+		dev1->keybit[BIT_WORD(BTN_2)] |= BIT_MASK(BTN_2);
+		dev1->keybit[BIT_WORD(BTN_3)] |= BIT_MASK(BTN_3);
+	}
+
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
 	dev2->phys = priv->phys;
 	dev2->name = (priv->i->flags & ALPS_DUALPOINT) ? "DualPoint Stick" : "PS/2 Mouse";
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index bc87936..92505d5 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -21,7 +21,7 @@ struct alps_model_info {
 struct alps_data {
 	struct input_dev *dev2;		/* Relative device */
 	char phys[32];			/* Phys */
-	const struct alps_model_info *i;/* Info */
+	struct alps_model_info *i;	/* Info */
 	int prev_fin;			/* Finger bit from previous packet */
 };
 
-- 
1.6.3.3



