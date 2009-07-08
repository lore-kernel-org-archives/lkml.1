Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZGHK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZGHK2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZGHK1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:27:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZGHK1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:27:45 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/3 v2] xen: wait up to 5 minutes for device connetion
Date: Wed,  8 Jul 2009 12:27:39 +0200
Message-Id: <1247048859-31845-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1247048859-31845-2-git-send-email-pbonzini@redhat.com>
References: <4A5272A6.6090302@citrix.com>
 <1247048859-31845-1-git-send-email-pbonzini@redhat.com>
 <1247048859-31845-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increases the device timeout from 10s to 5 minutes, giving the user a
visual indication during that time in case there are problems.  The patch
is a backport of changesets 144 and 150 in the Xenbits tree.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Changeset 144 introduced this logic but chose to use only 30
	seconds for the timeout.  Changeset 150 simply bumped the
	timeout to 5 minutes.  Separating them does not make sense.

 drivers/xen/xenbus/xenbus_probe.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3a867a5..4f69159 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -901,7 +901,7 @@ static int print_device_status(struct device *dev, void *data)
 static int ready_to_wait_for_devices;
 
 /*
- * On a 10 second timeout, wait for all devices currently configured.  We need
+ * On a 5-minute timeout, wait for all devices currently configured.  We need
  * to do this to guarantee that the filesystems and / or network devices
  * needed for boot are available, before we can allow the boot to proceed.
  *
@@ -916,18 +916,30 @@ static int ready_to_wait_for_devices;
  */
 static void wait_for_devices(struct xenbus_driver *xendrv)
 {
-	unsigned long timeout = jiffies + 10*HZ;
+	unsigned long start = jiffies;
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
+	unsigned int seconds_waited = 0;
 
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
 	while (exists_connecting_device(drv)) {
-		if (time_after(jiffies, timeout))
-			break;
+		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
+			if (!seconds_waited)
+				printk(KERN_WARNING "XENBUS: Waiting for "
+				       "devices to initialise: ");
+			seconds_waited += 5;
+			printk("%us...", 300 - seconds_waited);
+			if (seconds_waited == 300)
+				break;
+		}
+
 		schedule_timeout_interruptible(HZ/10);
 	}
 
+	if (seconds_waited)
+		printk("\n");
+
 	bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
 			 print_device_status);
 }
-- 
1.6.2.5

