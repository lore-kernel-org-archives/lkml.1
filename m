Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbXFMVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbXFMVan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXFMV3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbXFMV3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/7] PM: Simplify suspend_device
Date: Wed, 13 Jun 2007 16:19:27 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131619.27986.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Reduce code duplication in drivers/base/suspend.c by introducing a separate
function for printing diagnostic messages.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/base/power/suspend.c |   49 +++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -40,6 +40,14 @@ static inline char *suspend_verb(u32 eve
 }
 
 
+static void
+suspend_device_dbg(struct device * dev, pm_message_t state, char *info)
+{
+	dev_dbg(dev, "%s%s%s\n", info, suspend_verb(state.event),
+		((state.event == PM_EVENT_SUSPEND) && device_may_wakeup(dev)) ?
+		", may wakeup" : "");
+}
+
 /**
  *	suspend_device - Save state of one device.
  *	@dev:	Device.
@@ -66,37 +74,21 @@ int suspend_device(struct device * dev, 
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
@@ -114,14 +106,9 @@ static int suspend_device_late(struct de
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

