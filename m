Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539Ab0AEAgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0AEAgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505Ab0AEAgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:01 -0500
Received: from kroah.org ([198.145.64.141]:42402 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0AEAf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 76/97] xen: improvement to wait_for_devices()
Date: Mon,  4 Jan 2010 16:33:29 -0800
Message-Id: <1262651630-7354-76-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit f8dc33088febc63286b7a60e6b678de8e064de8e upstream.

When printing a warning about a timed-out device, print the
current state of both ends of the device connection (i.e., backend as
well as frontend).  This backports half of changeset 146 from the
Xenbits tree.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/xen/xenbus/xenbus_probe.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 19bce3e..9246a8c 100644
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
1.6.6

