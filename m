Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399Ab0AWAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0AWAZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849Ab0AWAZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:25:41 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37950 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0AWAZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:25:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jQfpDBwkARsmig7tbwDBT4t8hnEoWZlIIhJviKOgsYy+rcCN5wpg11OC6DmRMQ9cuZ
         UXgj7iFgTCD6ipOf4tIjWPrItHtxR7vV792VWp9VBg8qGS2qS1UOC5nnNT5G+d+9LNOr
         EsriJ5dFfPlW9vakWVcc3YvgZsEWR8oUCUb7k=
Subject: [PATCH 7/8] MTD: call remove notifiers before removing the device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1264205925.31827.3.camel@maxim-laptop>
References: <1264205925.31827.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 02:25:33 +0200
Message-ID: <1264206333.31827.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6ab6770f8a575441dfb42095f72f34d77727fa0c Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Sat, 23 Jan 2010 02:09:31 +0200
Subject: [PATCH 7/8] MTD: call remove notifiers before removing the device

This is first step in implementing proper hotplug support.
Now all users of the mtd device have a chance to put the mtd device
when they are notified to do so, and they have to do so to make hotplug work.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdcore.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 3bdb7e8..0e86208 100644
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



