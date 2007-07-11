Return-Path: <linux-kernel-owner+w=401wt.eu-S935516AbXGKXkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516AbXGKXkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934989AbXGKXeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:33232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934984AbXGKXeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/61] PM: Do not check parent state in suspend and resume core code
Date: Wed, 11 Jul 2007 16:31:35 -0700
Message-Id: <1184196818497-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968151257-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/resume.c  |    7 -------
 drivers/base/power/suspend.c |    7 -------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
index 0c96106..00fd84a 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
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
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index a3ff394..26df9b2 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -63,13 +63,6 @@ int suspend_device(struct device * dev, pm_message_t state)
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
-- 
1.5.2.2

