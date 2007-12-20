Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXLTWCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXLTWCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762452AbXLTWCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:02:38 -0500
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:54077 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbXLTWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:02:37 -0500
Subject: [PATCH RFC] Input: tell mousedev to handle remote console virtual
	mice using absolute coordinates
From: Micah Parrish <micah.parrish@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, "Chiang, Alexander" <achiang@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 15:02:44 -0700
Message-Id: <1198188164.7371.40.camel@strongbad>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices like the HP Integrated Remote Console Virtual Mouse, which are
standard equipment on all Proliant and Integrity servers, produce
absolute coordinates instead of relative coordinates.  This is done to
synchronize the position of the mouse cursor on the client desktop
with the mouse cursor position on the server.  Mousedev is not
designed to pass those absolute events directly to X, but it can
translate them into relative movements.  It currently does this for
tablet like devices and touchpads.  This patch merely tells it to also
include a device with ABS_X, ABS_Y, and mouse buttons in its list of
devices to process input for.

This patch enables the mouse pointer to move when using the remote
console.  Without this patch, the cursor will not move.

Signed-off-by: Micah Parrish <micah.parrish@hp.com>

---
I understand that Dell DRAC and Sun Andromeda are or contain a similar
device, one which produces absolute X,Y coordinates and ordinary mouse
clicks.  This patch may also enable these but I have no access to
these systems.

 mousedev.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index e1c1da0..2dc1b12 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -1028,7 +1028,12 @@ static const struct input_device_id mousedev_ids[] = {
                                BIT_MASK(ABS_PRESSURE) |
                                BIT_MASK(ABS_TOOL_WIDTH) },
        },      /* A touchpad */
-
+       {
+               .flags = INPUT_DEVICE_ID_MATCH_EVBIT |
+                        INPUT_DEVICE_ID_MATCH_KEYBIT |
+                        INPUT_DEVICE_ID_MATCH_ABSBIT,
+               .evbit = { BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_SYN) },
+               .keybit = { [LONG(BTN_LEFT)] = BIT(BTN_LEFT) },
+               .absbit = { BIT(ABS_X) | BIT(ABS_Y) },
+       },      /* Mouselike device with absolute X and Y but ordinary clicks */
        { },    /* Terminating entry */
 };


