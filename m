Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYEPJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYEPJwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYEPJwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:52:08 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49853 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752595AbYEPJwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:52:06 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 05/10] HID: move usage input mapping to hid.h
Date: Fri, 16 May 2008 11:49:18 +0200
Message-Id: <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mapping are currently used on 2 placces and will be needed by more
quirk drivers, so move them to hid.h to allow them to use it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-input-quirks.c |   71 ++++++++++++++++++++-------------------
 drivers/hid/hid-input.c        |   16 +++++----
 include/linux/hid.h            |   56 +++++++++++++++++++++++++++++++-
 3 files changed, 100 insertions(+), 43 deletions(-)

diff --git a/drivers/hid/hid-input-quirks.c b/drivers/hid/hid-input-quirks.c
index 4c2052c..51ae184 100644
--- a/drivers/hid/hid-input-quirks.c
+++ b/drivers/hid/hid-input-quirks.c
@@ -16,16 +16,14 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 
-#define map_abs(c)      do { usage->code = c; usage->type = EV_ABS; *bit = input->absbit; *max = ABS_MAX; } while (0)
-#define map_rel(c)      do { usage->code = c; usage->type = EV_REL; *bit = input->relbit; *max = REL_MAX; } while (0)
-#define map_key(c)      do { usage->code = c; usage->type = EV_KEY; *bit = input->keybit; *max = KEY_MAX; } while (0)
-#define map_led(c)      do { usage->code = c; usage->type = EV_LED; *bit = input->ledbit; *max = LED_MAX; } while (0)
+#define map_rel(c)	hid_map_usage(hidinput, usage, bit, max, EV_REL, (c))
+#define map_key(c)	hid_map_usage(hidinput, usage, bit, max, EV_KEY, (c))
 
-#define map_abs_clear(c)        do { map_abs(c); clear_bit(c, *bit); } while (0)
-#define map_key_clear(c)        do { map_key(c); clear_bit(c, *bit); } while (0)
+#define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, bit, \
+		max, EV_KEY, (c))
 
-static int quirk_belkin_wkbd(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_belkin_wkbd(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -40,8 +38,8 @@ static int quirk_belkin_wkbd(struct hid_usage *usage, struct input_dev *input,
 	return 1;
 }
 
-static int quirk_cherry_cymotion(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_cherry_cymotion(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -56,13 +54,13 @@ static int quirk_cherry_cymotion(struct hid_usage *usage, struct input_dev *inpu
 	return 1;
 }
 
-static int quirk_logitech_ultrax_remote(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_logitech_ultrax_remote(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;
 
-	set_bit(EV_REP, input->evbit);
+	set_bit(EV_REP, hidinput->input->evbit);
 	switch(usage->hid & HID_USAGE) {
 		/* Reported on Logitech Ultra X Media Remote */
 		case 0x004: map_key_clear(KEY_AGAIN);		break;
@@ -89,13 +87,13 @@ static int quirk_logitech_ultrax_remote(struct hid_usage *usage, struct input_de
 	return 1;
 }
 
-static int quirk_chicony_tactical_pad(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_chicony_tactical_pad(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
 
-	set_bit(EV_REP, input->evbit);
+	set_bit(EV_REP, hidinput->input->evbit);
 	switch (usage->hid & HID_USAGE) {
 		case 0xff01: map_key_clear(BTN_1);		break;
 		case 0xff02: map_key_clear(BTN_2);		break;
@@ -114,9 +112,11 @@ static int quirk_chicony_tactical_pad(struct hid_usage *usage, struct input_dev
 	return 1;
 }
 
-static int quirk_microsoft_ergonomy_kb(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_microsoft_ergonomy_kb(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
+	struct input_dev *input = hidinput->input;
+
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
 
@@ -137,13 +137,13 @@ static int quirk_microsoft_ergonomy_kb(struct hid_usage *usage, struct input_dev
 	return 1;
 }
 
-static int quirk_microsoft_presenter_8k(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_microsoft_presenter_8k(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
 
-	set_bit(EV_REP, input->evbit);
+	set_bit(EV_REP, hidinput->input->evbit);
 	switch(usage->hid & HID_USAGE) {
 		case 0xfd08: map_key_clear(KEY_FORWARD);	break;
 		case 0xfd09: map_key_clear(KEY_BACK);		break;
@@ -156,8 +156,8 @@ static int quirk_microsoft_presenter_8k(struct hid_usage *usage, struct input_de
 	return 1;
 }
 
-static int quirk_petalynx_remote(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_petalynx_remote(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if (((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR) &&
 			((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER))
@@ -184,8 +184,8 @@ static int quirk_petalynx_remote(struct hid_usage *usage, struct input_dev *inpu
 	return 1;
 }
 
-static int quirk_logitech_wireless(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_logitech_wireless(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -236,8 +236,8 @@ static int quirk_logitech_wireless(struct hid_usage *usage, struct input_dev *in
 	return 1;
 }
 
-static int quirk_cherry_genius_29e(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_cherry_genius_29e(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -254,7 +254,7 @@ static int quirk_cherry_genius_29e(struct hid_usage *usage, struct input_dev *in
 	return 1;
 }
 
-static int quirk_btc_8193(struct hid_usage *usage, struct input_dev *input,
+static int quirk_btc_8193(struct hid_usage *usage, struct hid_input *hidinput,
 			      unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
@@ -276,8 +276,8 @@ static int quirk_btc_8193(struct hid_usage *usage, struct input_dev *input,
 	return 1;
 }
 
-static int quirk_sunplus_wdesktop(struct hid_usage *usage, struct input_dev *input,
-			      unsigned long **bit, int *max)
+static int quirk_sunplus_wdesktop(struct hid_usage *usage,
+		struct hid_input *hidinput, unsigned long **bit, int *max)
 {
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_CONSUMER)
 		return 0;
@@ -327,7 +327,8 @@ static int quirk_sunplus_wdesktop(struct hid_usage *usage, struct input_dev *inp
 static const struct hid_input_blacklist {
 	__u16 idVendor;
 	__u16 idProduct;
-	int (*quirk)(struct hid_usage *, struct input_dev *, unsigned long **, int *);
+	int (*quirk)(struct hid_usage *, struct hid_input *, unsigned long **,
+			int *);
 } hid_input_blacklist[] = {
 	{ VENDOR_ID_BELKIN, DEVICE_ID_BELKIN_WIRELESS_KEYBOARD, quirk_belkin_wkbd },
 
@@ -357,16 +358,16 @@ static const struct hid_input_blacklist {
 };
 
 int hidinput_mapping_quirks(struct hid_usage *usage, 
-				   struct input_dev *input, 
-				   unsigned long **bit, int *max)
+		struct hid_input *hi, unsigned long **bit, int *max)
 {
-	struct hid_device *device = input_get_drvdata(input);
+	struct hid_device *device = input_get_drvdata(hi->input);
 	int i = 0;
 	
 	while (hid_input_blacklist[i].quirk) {
 		if (hid_input_blacklist[i].idVendor == device->vendor &&
 				hid_input_blacklist[i].idProduct == device->product)
-			return hid_input_blacklist[i].quirk(usage, input, bit, max);
+			return hid_input_blacklist[i].quirk(usage, hi, bit,
+					max);
 		i++;
 	}
 	return 0;
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 6521ece..5dc017e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -78,13 +78,15 @@ static const struct {
 	__s32 y;
 }  hid_hat_to_axis[] = {{ 0, 0}, { 0,-1}, { 1,-1}, { 1, 0}, { 1, 1}, { 0, 1}, {-1, 1}, {-1, 0}, {-1,-1}};
 
-#define map_abs(c)	do { usage->code = c; usage->type = EV_ABS; bit = input->absbit; max = ABS_MAX; } while (0)
-#define map_rel(c)	do { usage->code = c; usage->type = EV_REL; bit = input->relbit; max = REL_MAX; } while (0)
-#define map_key(c)	do { usage->code = c; usage->type = EV_KEY; bit = input->keybit; max = KEY_MAX; } while (0)
-#define map_led(c)	do { usage->code = c; usage->type = EV_LED; bit = input->ledbit; max = LED_MAX; } while (0)
+#define map_abs(c)	hid_map_usage(hidinput, usage, &bit, &max, EV_ABS, (c))
+#define map_rel(c)	hid_map_usage(hidinput, usage, &bit, &max, EV_REL, (c))
+#define map_key(c)	hid_map_usage(hidinput, usage, &bit, &max, EV_KEY, (c))
+#define map_led(c)	hid_map_usage(hidinput, usage, &bit, &max, EV_LED, (c))
 
-#define map_abs_clear(c)	do { map_abs(c); clear_bit(c, bit); } while (0)
-#define map_key_clear(c)	do { map_key(c); clear_bit(c, bit); } while (0)
+#define map_abs_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
+		&max, EV_ABS, (c))
+#define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
+		&max, EV_KEY, (c))
 
 #ifdef CONFIG_USB_HIDINPUT_POWERBOOK
 
@@ -386,7 +388,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	}
 
 	/* handle input mappings for quirky devices */
-	ret = hidinput_mapping_quirks(usage, input, &bit, &max);
+	ret = hidinput_mapping_quirks(usage, hidinput, &bit, &max);
 	if (ret)
 		goto mapped;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index bda2368..e4d718f 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -643,7 +643,8 @@ extern void hidinput_disconnect(struct hid_device *);
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
-int hidinput_mapping_quirks(struct hid_usage *, struct input_dev *, unsigned long **, int *);
+int hidinput_mapping_quirks(struct hid_usage *, struct hid_input *,
+		unsigned long **, int *);
 int hidinput_event_quirks(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
 int hidinput_apple_event(struct hid_device *, struct input_dev *, struct hid_usage *, __s32);
 void hid_output_report(struct hid_report *report, __u8 *data);
@@ -651,6 +652,59 @@ struct hid_device *hid_allocate_device(void);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
 
 /**
+ * hid_map_usage - map usage input bits
+ *
+ * @hidinput: hidinput which we are interested in
+ * @usage: usage to fill in
+ * @bit: pointer to input->{}bit (out parameter)
+ * @max: maximal valid usage->code to consider later (out parameter)
+ * @type: input event type (EV_KEY, EV_REL, ...)
+ * @c: code which corresponds to this usage and type
+ */
+static inline void hid_map_usage(struct hid_input *hidinput,
+		struct hid_usage *usage, unsigned long **bit, int *max,
+		__u8 type, __u16 c)
+{
+	struct input_dev *input = hidinput->input;
+
+	usage->type = type;
+	usage->code = c;
+
+	switch (type) {
+	case EV_ABS:
+		*bit = input->absbit;
+		*max = ABS_MAX;
+		break;
+	case EV_REL:
+		*bit = input->relbit;
+		*max = REL_MAX;
+		break;
+	case EV_KEY:
+		*bit = input->keybit;
+		*max = KEY_MAX;
+		break;
+	case EV_LED:
+		*bit = input->ledbit;
+		*max = LED_MAX;
+		break;
+	}
+}
+
+/**
+ * hid_map_usage_clear - map usage input bits and clear the input bit
+ *
+ * The same as hid_map_usage, except the @c bit is also cleared in supported
+ * bits (@bit).
+ */
+static inline void hid_map_usage_clear(struct hid_input *hidinput,
+		struct hid_usage *usage, unsigned long **bit, int *max,
+		__u8 type, __u16 c)
+{
+	hid_map_usage(hidinput, usage, bit, max, type, c);
+	clear_bit(c, *bit);
+}
+
+/**
  * hid_parse - parse HW reports
  *
  * @hdev: hid device
-- 
1.5.4.5

