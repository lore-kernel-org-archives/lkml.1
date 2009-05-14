Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbZENBRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbZENBRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZENBQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:16:59 -0400
Received: from plexity.net ([206.123.115.38]:40855 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZENBQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:16:58 -0400
Date: Thu, 14 May 2009 01:16:03 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Alessandro Rubini <rubini@vision.unipv.it>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] psmouse:  ESD workaround fix for OLPC XO touchpad
Message-ID: <20090514011603.GA12494@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears that when the XO touchpad unit resets from ESD, it sends AA 
AA instead of AA 00, the psmouse-base code handles the case of AA 00 by
triggering a serio reconnect for the port, causing a full reprobe of
the device.
    
Testing with OFW shows that this is likely to solve the problem, so
the attached patch simply expands the existing test to also catch AA AA.
    
Author: Zephaniah E. Hull <warp@aehallh.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

---
This issue was found during testing back in 2007, before I
was involved, and the fix has been carried in the OLPC tree 
since then. Not sure how this would affect other systems so 
wondering if we should wrap this specific check around 
'#ifdef OLPC'?

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index f8f86de..cf0f4fc 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -327,7 +327,7 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 			goto out;
 		}
 
-		if (psmouse->packet[1] == PSMOUSE_RET_ID) {
+		if (psmouse->packet[1] == PSMOUSE_RET_ID || psmouse->packet[1] == PSMOUSE_RET_BAT) {
 			__psmouse_set_state(psmouse, PSMOUSE_IGNORE);
 			serio_reconnect(serio);
 			goto out;
