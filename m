Return-Path: <linux-kernel-owner+w=401wt.eu-S935310AbXGKXgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935310AbXGKXgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934998AbXGKXd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934993AbXGKXd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/61] PM: Simplify suspend_device
Date: Wed, 11 Jul 2007 16:31:28 -0700
Message-Id: <1184196783245-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841967793134-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Reduce code duplication in drivers/base/suspend.c by introducing a separate
function for printing diagnostic messages.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/suspend.c |   49 +++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index 19fae88..af2cedf 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -40,6 +40,14 @@ static inline char *suspend_verb(u32 event)
 }
 
 
+static void
+suspend_device_dbg(struct device *dev, pm_message_t state, char *info)
+{
+	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
+		((state.event == PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
+		", may wakeup" : "");
+}
+
 /**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
@@ -66,37 +74,21 @@ int suspend_device(struct device * dev, pm_message_t state)
 	dev->power.prev_state = dev->power.power_state;
 
 	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
-		dev_dbg(dev, "class %s%s\n",
-			suspend_verb(state.event),
-			((state.event == PM_EVENT_SUSPEND)
-					&& device_may_wakeup(dev))
-				? ", may wakeup"
-				: ""
-			);
+		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->type && dev->type->suspend && !dev->power.power_state.event) {
-		dev_dbg(dev, "%s%s\n",
-			suspend_verb(state.event),
-			((state.event == PM_EVENT_SUSPEND)
-					&& device_may_wakeup(dev))
-				? ", may wakeup"
-				: ""
-			);
+	if (!error && dev->type && dev->type->suspend
+	    && !dev->power.power_state.event) {
+		suspend_device_dbg(dev, state, "type ");
 		error = dev->type->suspend(dev, state);
 		suspend_report_result(dev->type->suspend, error);
 	}
 
-	if (!error && dev->bus && dev->bus->suspend && !dev->power.power_state.event) {
-		dev_dbg(dev, "%s%s\n",
-			suspend_verb(state.event),
-			((state.event == PM_EVENT_SUSPEND)
-					&& device_may_wakeup(dev))
-				? ", may wakeup"
-				: ""
-			);
+	if (!error && dev->bus && dev->bus->suspend
+	    && !dev->power.power_state.event) {
+		suspend_device_dbg(dev, state, "");
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
@@ -114,14 +106,9 @@ static int suspend_device_late(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late && !dev->power.power_state.event) {
-		dev_dbg(dev, "LATE %s%s\n",
-			suspend_verb(state.event),
-			((state.event == PM_EVENT_SUSPEND)
-					&& device_may_wakeup(dev))
-				? ", may wakeup"
-				: ""
-			);
+	if (dev->bus && dev->bus->suspend_late
+	    && !dev->power.power_state.event) {
+		suspend_device_dbg(dev, state, "LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);
 	}
-- 
1.5.2.2

