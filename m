Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0BVSm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:42:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:9830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0BVSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:40:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KUld8fTNrMDZHJ+JkrnCDMFQz/SWgWcBA0U83LxE8qYe/s4o5SK4XHdnFeP+tqBcCU
         upLgFLi1yWe5PBxtp0ZUY7wdOUgBVUaIOfBTQkOFhZiEigUfP9WsEXwHsVdIXM+RZFwE
         Q9W49qnLNQvErk9U4+PNxp5OCckTFVAdbBQfE=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 05/15] MTD: call the remove notifiers before assuming it is in use
Date: Mon, 22 Feb 2010 20:39:32 +0200
Message-Id: <1266863982-5258-6-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that mtd block common layer is prepared for proper hotplug support,
enable it here

Now all users of the mtd device have a chance to put the mtd device
when they are notified to do so, and they have to do so to make hotplug work.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdcore.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 67669a7..70a7858 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -350,31 +350,34 @@ fail_locked:
 int del_mtd_device (struct mtd_info *mtd)
 {
 	int ret;
+	struct mtd_notifier *not;
 
 	mutex_lock(&mtd_table_mutex);
 
 	if (idr_find(&mtd_idr, mtd->index) != mtd) {
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
 
-		/* No need to get a refcount on the module containing
-		   the notifier, since we hold the mtd_table_mutex */
-		list_for_each_entry(not, &mtd_notifiers, list)
-			not->remove(mtd);
-
 		idr_remove(&mtd_idr, mtd->index);
 
 		module_put(THIS_MODULE);
 		ret = 0;
 	}
 
+out_error:
 	mutex_unlock(&mtd_table_mutex);
 	return ret;
 }
-- 
1.6.3.3

