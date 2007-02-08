Return-Path: <linux-kernel-owner+w=401wt.eu-S1422930AbXBHAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930AbXBHAcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422938AbXBHAcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422930AbXBHAcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:18 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/28] driver core: Don't stop probing on ->probe errors.
Date: Wed,  7 Feb 2007 16:30:03 -0800
Message-Id: <1170894670676-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946672133-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Don't stop on the first ->probe error that is not -ENODEV/-ENXIO.

There might be a driver registered returning an unresonable return code, and
this stops probing completely even though it may make sense to try the next
possible driver. At worst, we may end up with an unbound device.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 510e788..f705137 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -136,18 +136,17 @@ probe_failed:
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
 
-	if (ret == -ENODEV || ret == -ENXIO) {
-		/* Driver matched, but didn't support device
-		 * or device not found.
-		 * Not an error; keep going.
-		 */
-		ret = 0;
-	} else {
+	if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
 		       "%s: probe of %s failed with error %d\n",
 		       drv->name, dev->bus_id, ret);
 	}
+	/*
+	 * Ignore errors returned by ->probe so that the next driver can try
+	 * its luck.
+	 */
+	ret = 0;
 done:
 	kfree(data);
 	atomic_dec(&probe_count);
-- 
1.4.4.4

