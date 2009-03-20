Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZCTFwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZCTFwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZCTFwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:52:44 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:38140 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZCTFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:52:43 -0400
X-Greylist: delayed 1046 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 01:52:43 EDT
Date: Fri, 20 Mar 2009 06:52:39 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20090320055239.GA19800@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: [PATCH] input: elantech.c make sure touchpad is really in absolute
	mode
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan Opmeer <arjan@opmeer.net>

There exist laptops with Elantech touchpads where switching to absolute mode
does not happen, although writing the configuration register succeeds
without error. Reading back the register afterwards reveils that the
absolute mode bit is not set as if masked out by the touchpad firmware.

Always read back register 0x10, make sure that for hardware version 1 the
absolute mode bit is actually set and fail otherwise. This prevents the case
where the touchpad is claimed by the Elantech driver but is nonetheless not
working.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
---

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 6ab0eb1..1de6fd6 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -363,9 +363,14 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
 			rc = -1;
 			break;
 		}
+	}
+
+	if (rc == 0) {
 		/*
-		 * Read back reg 0x10. The touchpad is probably initalising
-		 * and not ready until we read back the value we just wrote.
+		 * Read back reg 0x10. For hardware version 1 we must make
+		 * sure the absolute mode bit is set. For hardware version 2
+		 * the touchpad is probably initalising and not ready until
+		 * we read back the value we just wrote.
 		 */
 		do {
 			rc = elantech_read_reg(psmouse, 0x10, &val);
@@ -376,9 +381,17 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
 				tries);
 			msleep(ETP_READ_BACK_DELAY);
 		} while (tries > 0);
-		if (rc)
+
+		if (rc) {
 			pr_err("elantech.c: failed to read back register 0x10.\n");
-		break;
+		} else {
+			if (etd->hw_version == 1 &&
+			    val & ETP_R10_ABSOLUTE_MODE == 0) {
+				pr_err("elantech.c: touchpad refuses "
+					"to have absolute mode bit set\n");
+				rc = -1;
+			}
+		}
 	}
 
 	if (rc)
