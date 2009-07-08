Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZGHK2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZGHK2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZGHK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:27:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41610 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZGHK1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:27:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/3 v2] xen: improvement to wait_for_devices()
Date: Wed,  8 Jul 2009 12:27:38 +0200
Message-Id: <1247048859-31845-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1247048859-31845-1-git-send-email-pbonzini@redhat.com>
References: <4A5272A6.6090302@citrix.com>
 <1247048859-31845-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing a warning about a timed-out device, print the
current state of both ends of the device connection (i.e., backend as
well as frontend).  This backports half of changeset 146 from the
Xenbits tree.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	The other half of changeset 146 is buggy and hence superseded
	by patch 1/3.

 drivers/xen/xenbus/xenbus_probe.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index c543766..3a867a5 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -885,10 +885,13 @@ static int print_device_status(struct device *dev, void *data)
 		/* Information only: is this too noisy? */
 		printk(KERN_INFO "XENBUS: Device with no driver: %s\n",
 		       xendev->nodename);
-	} else if (xendev->state != XenbusStateConnected) {
+	} else if (xendev->state < XenbusStateConnected) {
+		enum xenbus_state rstate = XenbusStateUnknown;
+		if (xendev->otherend)
+			rstate = xenbus_read_driver_state(xendev->otherend);
 		printk(KERN_WARNING "XENBUS: Timeout connecting "
-		       "to device: %s (state %d)\n",
-		       xendev->nodename, xendev->state);
+		       "to device: %s (local state %d, remote state %d)\n",
+		       xendev->nodename, xendev->state, rstate);
 	}
 
 	return 0;
-- 
1.6.2.5


