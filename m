Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZBEFFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZBEFFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZBEFFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:05:31 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:40345 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZBEFFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:05:30 -0500
Date: Thu, 5 Feb 2009 06:05:24 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, patrakov@gmail.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Message-ID: <20090205050524.GA31737@adopmeer.homeip.net>
References: <20090126150821.GC31179@shadowen.org> <20090126162303.GA11618@adopmeer.homeip.net> <20090130152330.4ff2cbb2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130152330.4ff2cbb2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: elantech touchpad driver miss-recognising logitech mice
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 03:23:30PM -0800, Andrew Morton wrote:
> 
> blah. 

Very eloquent and very motivational...

> Please propose a final patch for me to stash away, lest the issue get
> forgotten about.

How about you stash away my original proposal? Andy has proof that it works. 
Some of the debug messages can always be removed later when no other
regressions surface and people find the current detection routine too
verbose.

From: Arjan Opmeer <arjan@opmeer.net>

Some Logitech mice react to the magic knock like an Elantech touchpad would. 
This leads to those mice being misdetected as Elantech touchpads.  Add a
version query to elantech_detect() to distinguish the two.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
---
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index b9a25d5..5abc5f7 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -556,6 +556,22 @@ int elantech_detect(struct psmouse *psmouse, int set_properties)
 		return -1;
 	}
 
+	/*
+	 * There are Logitech mice that react to the magic knock exactly
+	 * like an Elantech touchpad would, so do a version query here to
+	 * try to distinguish the two
+	 */
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		return -1;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	if (param[0] == 0 || param[1] != 0) {
+		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
+		return -1;
+	}
+
 	if (set_properties) {
 		psmouse->vendor = "Elantech";
 		psmouse->name = "Touchpad";
@@ -610,14 +626,12 @@ int elantech_init(struct psmouse *psmouse)
 		etd->parity[i] = etd->parity[i & (i - 1)] ^ 1;
 
 	/*
-	 * Find out what version hardware this is
+	 * Do the version query again so we can store the result
 	 */
 	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
 		pr_err("elantech.c: failed to query firmware version.\n");
 		goto init_fail;
 	}
-	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
-		param[0], param[1], param[2]);
 	etd->fw_version_maj = param[0];
 	etd->fw_version_min = param[2];
 
