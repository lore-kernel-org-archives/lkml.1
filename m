Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXFMVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXFMVcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXFMV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48332 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXFMV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 7/7] PM: Do not check parent state in suspend and resume core code
Date: Wed, 13 Jun 2007 17:17:07 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706131717.08806.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The checks if the device's parent is in the right state done in
drivers/base/power/suspend.c and drivers/base/power/resume.c serve no particular
purpose, since if the parent is in a wrong power state, the device's suspend or
resume callbacks are supposed to return an error anyway.  Moreover, they are
also useless from the sanity checking point of view, because they rely on the
code being checked to set dev->parent->power.power_state.event appropriately,
which need not happen if that code is buggy.  For these reasons they can be
removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/base/power/resume.c  |    7 -------
 drivers/base/power/suspend.c |    7 -------
 2 files changed, 14 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/resume.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
@@ -29,13 +29,6 @@ int resume_device(struct device * dev)
 
 	down(&dev->sem);
 
-	if (dev->parent && dev->parent->power.power_state.event) {
-		dev_err(dev, "PM: resume from %d, parent %s still %d\n",
-			dev->power.power_state.event,
-			dev->parent->bus_id,
-			dev->parent->power.power_state.event);
-	}
-
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
 		error = dev->bus->resume(dev);
Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -63,13 +63,6 @@ int suspend_device(struct device * dev, 
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
 	}
-	if (dev->parent && dev->parent->power.power_state.event) {
-		dev_err(dev,
-			"PM: suspend %d->%d, parent %s already %d\n",
-			dev->power.power_state.event, state.event,
-			dev->parent->bus_id,
-			dev->parent->power.power_state.event);
-	}
 
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");

