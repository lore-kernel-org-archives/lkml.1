Return-Path: <linux-kernel-owner+w=401wt.eu-S935474AbXGKXjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474AbXGKXjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934798AbXGKXeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:33221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933491AbXGKXd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/61] PM: Remove power_state.event checks from suspend core code
Date: Wed, 11 Jul 2007 16:31:34 -0700
Message-Id: <11841968151257-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968111201-git-send-email-gregkh@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/suspend.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index 5178b0f..a3ff394 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -71,21 +71,19 @@ int suspend_device(struct device * dev, pm_message_t state)
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
@@ -104,8 +102,7 @@ static int suspend_device_late(struct device *dev, pm_message_t state)
 {
 	int error = 0;
 
-	if (dev->bus && dev->bus->suspend_late
-	    && !dev->power.power_state.event) {
+	if (dev->bus && dev->bus->suspend_late) {
 		suspend_device_dbg(dev, state, "LATE ");
 		error = dev->bus->suspend_late(dev, state);
 		suspend_report_result(dev->bus->suspend_late, error);
-- 
1.5.2.2

