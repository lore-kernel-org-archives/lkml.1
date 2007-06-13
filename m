Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbXFMVbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbXFMVbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXFMV3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbXFMV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 6/7] PM: Remove power_state.event checks from suspend core code
Date: Wed, 13 Jun 2007 17:16:57 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706131716.57915.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The suspend routines should be called for every device during a system sleep
transition, regardless of the device's state, so that drivers can regard these
method calls as notifications that the system is about to go to sleep, rather
than as directives to put their devices into the 'off' state.

This is documented in Documentation/power/devices.txt and is already done in
the core resume code, so it seems reasonable to make the core suspend code
behave accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/suspend.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -71,14 +71,13 @@ int suspend_device(struct device * dev, 
 			dev->parent->power.power_state.event);
 	}
 
-	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
+	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->bus && dev->bus->suspend
-	    && !dev->power.power_state.event) {
+	if (!error && dev->bus && dev->bus->suspend) {
 		suspend_device_dbg(dev, state, "");
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
@@ -97,8 +96,7 @@ static int suspend_device_late(struct de
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late
-	    && !dev->power.power_state.event) {
+	if (dev->bus && dev->bus->suspend_late) {
 		suspend_device_dbg(dev, state, "LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);

