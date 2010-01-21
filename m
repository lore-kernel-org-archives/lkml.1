Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AUEX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AUEX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221Ab0AUEXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:23:06 -0500
Received: from kroah.org ([198.145.64.141]:60163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0AUEXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.206048238@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tai-hwa Liang <avatar@sentelic.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [21/30] Input: pmouse - move Sentelic probe down the list
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tai-hwa Liang <avatar@sentelic.com>

commit 4a18b3ab6ed537b055e3fcfca64ab870b4f9acf0 upstream.

Sentelic probes confuse IBM trackpoints so they stop responding to
TP_READ_ID command. See:

	http://bugzilla.kernel.org/show_bug.cgi?id=14970

Let's move FSP detection lower so it is probed after trackpoint and
others, just before we strat probing for Intellimouse Explorer.

Signed-off-by: Tai-hwa Liang <avatar@sentelic.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/psmouse-base.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -667,19 +667,6 @@ static int psmouse_extensions(struct psm
 		max_proto = PSMOUSE_IMEX;
 	}
 
-/*
- * Try Finger Sensing Pad
- */
-	if (max_proto > PSMOUSE_IMEX) {
-		if (fsp_detect(psmouse, set_properties) == 0) {
-			if (!set_properties || fsp_init(psmouse) == 0)
-				return PSMOUSE_FSP;
-/*
- * Init failed, try basic relative protocols
- */
-			max_proto = PSMOUSE_IMEX;
-		}
-	}
 
 	if (max_proto > PSMOUSE_IMEX) {
 		if (genius_detect(psmouse, set_properties) == 0)
@@ -696,6 +683,21 @@ static int psmouse_extensions(struct psm
 	}
 
 /*
+ * Try Finger Sensing Pad. We do it here because its probe upsets
+ * Trackpoint devices (causing TP_READ_ID command to time out).
+ */
+	if (max_proto > PSMOUSE_IMEX) {
+		if (fsp_detect(psmouse, set_properties) == 0) {
+			if (!set_properties || fsp_init(psmouse) == 0)
+				return PSMOUSE_FSP;
+/*
+ * Init failed, try basic relative protocols
+ */
+			max_proto = PSMOUSE_IMEX;
+		}
+	}
+
+/*
  * Reset to defaults in case the device got confused by extended
  * protocol probes. Note that we follow up with full reset because
  * some mice put themselves to sleep when they see PSMOUSE_RESET_DIS.


