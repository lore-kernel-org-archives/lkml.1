Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960Ab0AVPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0AVPdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764Ab0AVPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:33:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:36482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0AVPdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:33:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GryUA/ZsDs3I59TgkJS7uLwneaUQr7oWnvQCF7tPK19VJoez3oRHzPpDEkU+g8gJwN
         5hKbkP+Pz4cBCwWdgmL2RsSW9dwcSQaYoH0s6NAW3PIA56gTzWLxKsxp6tCl1T439oQZ
         Mwb/VqThbfLym0H/8MMdYazIfDdk6gXAx9ut0=
Subject: [PATCH 1/4] MTD: call remove notifiers before removing the device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264174316.24012.17.camel@maxim-laptop>
References: <1264174316.24012.17.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:33:27 +0200
Message-ID: <1264174407.24012.19.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e74bb4a1e1222ec35fa8ed0d0d40b8e3607992d8 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 22 Jan 2010 15:00:53 +0200
Subject: [PATCH 1/4] MTD: call remove notifiers before removing the device

This is first step in implementing proper hotplug support.
Now all users of the mtd device have a chance to put the mtd device
when they are notified to do so, and they have to do so to make hotplug work.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdcore.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c356c0a..87ff83f 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -341,31 +341,32 @@ int add_mtd_device(struct mtd_info *mtd)
 int del_mtd_device (struct mtd_info *mtd)
 {
 	int ret;
+	struct mtd_notifier *not;
 
 	mutex_lock(&mtd_table_mutex);
 
 	if (mtd_table[mtd->index] != mtd) {
 		ret = -ENODEV;
-	} else if (mtd->usecount) {
+		goto out_error;
+	}
+
+	/* No need to get a refcount on the module containing
+		the notifier, since we hold the mtd_table_mutex */
+	list_for_each_entry(not, &mtd_notifiers, list)
+		not->remove(mtd);
+
+	if (mtd->usecount) {
 		printk(KERN_NOTICE "Removing MTD device #%d (%s) with use count %d\n",
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
-		struct mtd_notifier *not;
-
 		device_unregister(&mtd->dev);
-
-		/* No need to get a refcount on the module containing
-		   the notifier, since we hold the mtd_table_mutex */
-		list_for_each_entry(not, &mtd_notifiers, list)
-			not->remove(mtd);
-
 		mtd_table[mtd->index] = NULL;
-
 		module_put(THIS_MODULE);
 		ret = 0;
 	}
 
+out_error:
 	mutex_unlock(&mtd_table_mutex);
 	return ret;
 }
-- 
1.6.3.3



