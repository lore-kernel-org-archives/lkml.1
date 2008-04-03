Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbYDUN2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbYDUN2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbYDUNT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760173AbYDUNTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=dsqkQoqUPCTh4nBFrq3m93p0i9i4QPQZcgNecuBYgMY3J4rfOD6/dNFylb+UO1aP5C6+eK7CuvfRAY57vjVxBWC3+3hsRMx5wuBLMlw8JFp8mPW+p+L/sSg+hpMD7IoFwebi8pqnMFjPO/+q5LrP4UJfE9+HN8OhaBdaGa5y/rw=
Message-Id: <a0979923d7c34c9c60d0ee8a533f9502dcfbd42b.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:18:10 -0400
Subject: [PATCH 12/37] Input: xpad - fix dpad handling of unknown devices
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For devices not specifically listed in xpad.c, xpad->dpad_mapping
is initially set to MAP_DPAD_UNKNOWN. In xpad_probe() it gets changed
to either MAP_DPAD_TO_BUTTONS or MAP_DPAD_TO_AXES, depending on the
module parameter dpad_to_buttons.

However, MAP_DPAD_UNKNOWN is defined as -1, while the field is u8.
This results in actual value of 255, causing the MAP_DPAD_UNKNOWN
check in xpad_probe() to fail.
Fix that by defining MAP_DPAD_UNKNOWN as 2 instead.

Also, setting module parameter dpad_to_buttons to 1 should obviously
map dpad to buttons, while the default behaviour (0) should be to map
dpad to axes. However, dpad_to_buttons is directly assigned to
xpad->dpad_mapping, and as MAP_DPAD_TO_BUTTONS is 0, the actual
behaviour is reversed.
Fix that by negating dpad_to_buttons in assignment.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 8804ad3..6288c4f 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -87,7 +87,7 @@
    but we map them to axes when possible to simplify things */
 #define MAP_DPAD_TO_BUTTONS    0
 #define MAP_DPAD_TO_AXES       1
-#define MAP_DPAD_UNKNOWN       -1
+#define MAP_DPAD_UNKNOWN       2
 
 #define XTYPE_XBOX        0
 #define XTYPE_XBOX360     1
@@ -653,7 +653,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	xpad->dpad_mapping = xpad_device[i].dpad_mapping;
 	xpad->xtype = xpad_device[i].xtype;
 	if (xpad->dpad_mapping == MAP_DPAD_UNKNOWN)
-		xpad->dpad_mapping = dpad_to_buttons;
+		xpad->dpad_mapping = !dpad_to_buttons;
 	if (xpad->xtype == XTYPE_UNKNOWN)
 		xpad->xtype = (intf->cur_altsetting->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC);
 	xpad->dev = input_dev;
-- 
1.5.5.rc2.6.gf58d


