Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432Ab0AEAlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0AEAlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755Ab0AEAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:41:11 -0500
Received: from kroah.org ([198.145.64.141]:42410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0AEAgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 77/97] xen: wait up to 5 minutes for device connetion
Date: Mon,  4 Jan 2010 16:33:30 -0800
Message-Id: <1262651630-7354-77-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit ae7888012969355a548372e99b066d9e31153b62 upstream.

Increases the device timeout from 10s to 5 minutes, giving the user a
visual indication during that time in case there are problems.  The patch
is a backport of changesets 144 and 150 in the Xenbits tree.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/xen/xenbus/xenbus_probe.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 9246a8c..649fcdf 100644
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
1.6.6

