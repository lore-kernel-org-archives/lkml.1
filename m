Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYEWNJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYEWNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYEWNJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:09:23 -0400
Received: from gw.goop.org ([64.81.55.164]:33889 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbYEWNJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:09:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] xen pvfb: Pointer z-axis (mouse wheel) support
X-Mercurial-Node: 37b91e2977db6e5c6fc5b846fae078edce06d8c8
Message-Id: <37b91e2977db6e5c6fc5.1211547982@localhost>
In-Reply-To: <patchbomb.1211547980@localhost>
Date: Fri, 23 May 2008 14:06:22 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Armbruster <armbru@redhat.com>

Add z-axis motion to pointer events.  Backward compatible, because
there's space for the z-axis in union xenkbd_in_event, and old
backends zero it.

Derived from
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/57dfe0098000
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/1edfea26a2a9
http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/c3ff0b26f664

Signed-off-by: Pat Campbell <plc@novell.com>
Signed-off-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/input/xen-kbdfront.c     |    8 +++++++-
 include/xen/interface/io/kbdif.h |    3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -66,6 +66,9 @@
 		case XENKBD_TYPE_MOTION:
 			input_report_rel(dev, REL_X, event->motion.rel_x);
 			input_report_rel(dev, REL_Y, event->motion.rel_y);
+			if (event->motion.rel_z)
+				input_report_rel(dev, REL_WHEEL,
+						 -event->motion.rel_z);
 			break;
 		case XENKBD_TYPE_KEY:
 			dev = NULL;
@@ -84,6 +87,9 @@
 		case XENKBD_TYPE_POS:
 			input_report_abs(dev, ABS_X, event->pos.abs_x);
 			input_report_abs(dev, ABS_Y, event->pos.abs_y);
+			if (event->pos.rel_z)
+				input_report_rel(dev, REL_WHEEL,
+						 -event->pos.rel_z);
 			break;
 		}
 		if (dev)
@@ -152,7 +158,7 @@
 	ptr->evbit[0] = BIT(EV_KEY) | BIT(EV_REL) | BIT(EV_ABS);
 	for (i = BTN_LEFT; i <= BTN_TASK; i++)
 		set_bit(i, ptr->keybit);
-	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y);
+	ptr->relbit[0] = BIT(REL_X) | BIT(REL_Y) | BIT(REL_WHEEL);
 	input_set_abs_params(ptr, ABS_X, 0, XENFB_WIDTH, 0, 0);
 	input_set_abs_params(ptr, ABS_Y, 0, XENFB_HEIGHT, 0, 0);
 
diff --git a/include/xen/interface/io/kbdif.h b/include/xen/interface/io/kbdif.h
--- a/include/xen/interface/io/kbdif.h
+++ b/include/xen/interface/io/kbdif.h
@@ -49,6 +49,7 @@
 	uint8_t type;		/* XENKBD_TYPE_MOTION */
 	int32_t rel_x;		/* relative X motion */
 	int32_t rel_y;		/* relative Y motion */
+	int32_t rel_z;		/* relative Z motion (wheel) */
 };
 
 struct xenkbd_key {
@@ -61,6 +62,7 @@
 	uint8_t type;		/* XENKBD_TYPE_POS */
 	int32_t abs_x;		/* absolute X position (in FB pixels) */
 	int32_t abs_y;		/* absolute Y position (in FB pixels) */
+	int32_t rel_z;		/* relative Z motion (wheel) */
 };
 
 #define XENKBD_IN_EVENT_SIZE 40


