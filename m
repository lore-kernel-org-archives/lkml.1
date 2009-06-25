Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZFYQKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZFYQKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZFYQKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:10:40 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:46123 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZFYQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hNre9RAvQK+8GIXh2IDVRbtYWjcZzrthbKiDFUx6EwYZzJr1raai+hnv5tLLiIr/Nd
         UHDewZc4olJAsIAQQGOkYMZO7d58sWsd0usTBA4weAgxSHL7Wcc9f6RKhiPH8qJNrzmh
         93FA322vCgatqMaBnRAYxt7HVl7hgHi4ou2Gk=
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 18:10:41 +0200
Message-ID: <6b1460640906250910x5ba98ce2wa990946486edfc0d@mail.gmail.com>
Subject: [PATCH] trackpoint: enable selection of press-to-select button
From: Tom Weissmann <tom.weissmann@gmail.com>
To: rubini@vision.unipv.it
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the trackpoint driver supports press-to-select but only left
button clicks can be generated, although the trackpoint itself can
generate 3 different button clicks when pressed: left, middle, or
right.

With this patch the trackpoint sysfs variable press-to-select can be
set not only to 0 (off), 1 (left button), but also to 2 (middle
button) and 3 (right button). This makes the feature more useful for
left-handed users with no visible changes to the right-handed default
behaviour.

Signed-off by: Tom Weissmann <tom.weissmann@gmail.com>
---

--- linux-2.6.30/drivers/input/mouse/trackpoint.h.orig	2009-06-19
12:16:54.814029216 +0200
+++ linux-2.6.30/drivers/input/mouse/trackpoint.h	2009-06-19
12:38:31.151280333 +0200
@@ -102,6 +102,13 @@
 #define TP_MASK_EXT_TAG			0x04


+/* Press-to-select button maps */
+
+#define TP_BUTTON1_MAP          0x41
+#define TP_BUTTON2_MAP          0x43
+#define TP_BUTTON3_MAP          0x42
+
+
 /* Power on Self Test Results */
 #define TP_POR_SUCCESS		0x3B

@@ -121,6 +128,8 @@
 #define TP_DEF_Z_TIME		0x26
 #define TP_DEF_JENKS_CURV	0x87

+#define TP_DEF_PTS		0x00
+
 /* Toggles */
 #define TP_DEF_MB		0x00
 #define TP_DEF_PTSON		0x00
--- linux-2.6.30/drivers/input/mouse/trackpoint.c.orig	2009-06-19
12:18:57.430029371 +0200
+++ linux-2.6.30/drivers/input/mouse/trackpoint.c	2009-06-20
00:13:54.299571377 +0200
@@ -131,17 +131,69 @@ static ssize_t trackpoint_set_bit_attr(s
 }


-#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv)				\
-	static struct trackpoint_attr_data trackpoint_attr_##_name = {		\
-		.field_offset	= offsetof(struct trackpoint_data, _name),	\
-		.command	= _command,					\
-		.mask		= _mask,					\
-		.inverted	= _inv,						\
-	};									\
-	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,				\
-			    &trackpoint_attr_##_name,				\
+#define TRACKPOINT_BIT_ATTR(_name, _command, _mask, _inv)		      \
+	static struct trackpoint_attr_data trackpoint_attr_##_name = {	      \
+		.field_offset	= offsetof(struct trackpoint_data, _name),    \
+		.command	= _command,				      \
+		.mask		= _mask,				      \
+		.inverted	= _inv,					      \
+	};								      \
+	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,			      \
+			    &trackpoint_attr_##_name,			      \
 			    trackpoint_show_int_attr, trackpoint_set_bit_attr)

+
+#define TRACKPOINT_CUSTOM_WRITE_ATTR(_name, _command, _mask, _inv, _writefn)  \
+	static struct trackpoint_attr_data trackpoint_attr_##_name = {	      \
+		.field_offset	= offsetof(struct trackpoint_data, _name),    \
+		.command	= _command,				      \
+		.mask		= _mask,				      \
+		.inverted	= _inv,					      \
+	};								      \
+	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,			      \
+			    &trackpoint_attr_##_name,			      \
+			    trackpoint_show_int_attr, _writefn)
+
+
+#define TRACKPOINT_SET_PTS_BUTTON(_ps2dev, _value)			      \
+ do {									      \
+	trackpoint_write(_ps2dev, TP_BUTTON1_MAP, ((1 == _value) ? 255 : 0)); \
+	trackpoint_write(_ps2dev, TP_BUTTON2_MAP, ((2 == _value) ? 255 : 0)); \
+	trackpoint_write(_ps2dev, TP_BUTTON3_MAP, ((3 == _value) ? 255 : 0)); \
+  } while (0)								      \
+
+static ssize_t trackpoint_set_press_to_select(struct psmouse *psmouse,
+					      void *data,
+					      const char *buf,
+					      size_t count)
+{
+	struct trackpoint_data *tp = psmouse->private;
+	struct trackpoint_attr_data *attr = data;
+	unsigned char *field = (unsigned char *) ((char *)tp +
+						  attr->field_offset);
+	unsigned long value;
+	char *rest;
+
+	value = strict_strtoul(buf, &rest, 10);
+	if (*rest || value > 3)
+		return -EINVAL;
+
+	if (*field != value) {
+
+		if (*field == 0 || value == 0)
+			trackpoint_toggle_bit(&psmouse->ps2dev, attr->command,
+					      attr->mask);
+
+		if (0 < value)
+			TRACKPOINT_SET_PTS_BUTTON(&psmouse->ps2dev, value);
+
+	  *field = value;
+	}
+
+	return count;
+}
+
+
 TRACKPOINT_INT_ATTR(sensitivity, TP_SENS);
 TRACKPOINT_INT_ATTR(speed, TP_SPEED);
 TRACKPOINT_INT_ATTR(inertia, TP_INERTIA);
@@ -153,10 +205,12 @@ TRACKPOINT_INT_ATTR(upthresh, TP_UP_THRE
 TRACKPOINT_INT_ATTR(ztime, TP_Z_TIME);
 TRACKPOINT_INT_ATTR(jenks, TP_JENKS_CURV);

-TRACKPOINT_BIT_ATTR(press_to_select, TP_TOGGLE_PTSON, TP_MASK_PTSON, 0);
 TRACKPOINT_BIT_ATTR(skipback, TP_TOGGLE_SKIPBACK, TP_MASK_SKIPBACK, 0);
 TRACKPOINT_BIT_ATTR(ext_dev, TP_TOGGLE_EXT_DEV, TP_MASK_EXT_DEV, 1);

+TRACKPOINT_CUSTOM_WRITE_ATTR(press_to_select, TP_TOGGLE_PTSON,
TP_MASK_PTSON, 0,
+				   trackpoint_set_press_to_select);
+
 static struct attribute *trackpoint_attrs[] = {
 	&psmouse_attr_sensitivity.dattr.attr,
 	&psmouse_attr_speed.dattr.attr,
@@ -228,8 +282,16 @@ static int trackpoint_sync(struct psmous
 	trackpoint_write(&psmouse->ps2dev, TP_JENKS_CURV, tp->jenks);

 	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_PTSON, &toggle);
-	if (((toggle & TP_MASK_PTSON) == TP_MASK_PTSON) != tp->press_to_select)
-		 trackpoint_toggle_bit(&psmouse->ps2dev, TP_TOGGLE_PTSON, TP_MASK_PTSON);
+
+	if (((toggle & TP_MASK_PTSON) == TP_MASK_PTSON) !=
+	    (0 < tp->press_to_select))
+		trackpoint_toggle_bit(&psmouse->ps2dev,
+				      TP_TOGGLE_PTSON,
+				      TP_MASK_PTSON);
+	}
+	if (0 < tp->press_to_select)
+		TRACKPOINT_SET_PTS_BUTTON(&psmouse->ps2dev, tp->press_to_select)
+

 	trackpoint_read(&psmouse->ps2dev, TP_TOGGLE_SKIPBACK, &toggle);
 	if (((toggle & TP_MASK_SKIPBACK) == TP_MASK_SKIPBACK) != tp->skipback)
@@ -244,7 +306,8 @@ static int trackpoint_sync(struct psmous

 static void trackpoint_defaults(struct trackpoint_data *tp)
 {
-	tp->press_to_select = TP_DEF_PTSON;
+	tp->press_to_select = TP_DEF_PTS;
+
 	tp->sensitivity = TP_DEF_SENS;
 	tp->speed = TP_DEF_SPEED;
 	tp->reach = TP_DEF_REACH;
