Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbXFQSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbXFQSKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXFQSJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:09:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbXFQSJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:09:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH -mm 2/3] PM: Remove power_state.event checks from suspend core code
Date: Sun, 17 Jun 2007 19:49:20 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <20070614231402.GA6317@kroah.com> <200706171946.26174.rjw@sisk.pl>
In-Reply-To: <200706171946.26174.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171949.21087.rjw@sisk.pl>
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
 drivers/base/power/suspend.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc4/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/power/suspend.c	2007-06-16 01:08:13.000000000 +0200
+++ linux-2.6.22-rc4/drivers/base/power/suspend.c	2007-06-16 01:12:04.000000000 +0200
@@ -71,21 +71,19 @@ int suspend_device(struct device * dev, 
 			dev->parent->power.power_state.event);
 	}
 
-	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
+	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
 		suspend_report_result(dev->class->suspend, error);
 	}
 
-	if (!error && dev->type && dev->type->suspend
-	    && !dev->power.power_state.event) {
+	if (!error && dev->type && dev->type->suspend) {
 		suspend_device_dbg(dev, state, "type ");
 		error = dev->type->suspend(dev, state);
 		suspend_report_result(dev->type->suspend, error);
 	}
 
-	if (!error && dev->bus && dev->bus->suspend
-	    && !dev->power.power_state.event) {
+	if (!error && dev->bus && dev->bus->suspend) {
 		suspend_device_dbg(dev, state, "");
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
@@ -104,8 +102,7 @@ static int suspend_device_late(struct de
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late
-	    && !dev->power.power_state.event) {
+	if (dev->bus && dev->bus->suspend_late) {
 		suspend_device_dbg(dev, state, "LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);

