Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320Ab0AFVow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0AFVow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745Ab0AFVow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:44:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35809 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab0AFVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sauGaMkOqypCJkQdVSiN3Pt0AWpppOe54E8tDu+8LxVFJ9+cVh/d5esh1LWLky4r8P
         zFZyrvbmKaFyotmLH1dkgX97OPLE7gFRX6sFZN6ot0h9pB5EM0QXEMlIUmHIEI3JSGHp
         /D310T+VsPehPSMzJ0MTWvGhvU5CK61Bh8FhM=
Subject: [PATCH 1/9] MTD: call remove notifiers before removing the device
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262814216.14552.22.camel@maxim-laptop>
References: <1262814216.14552.22.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 23:44:45 +0200
Message-ID: <1262814285.14552.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d8cb6b03919de5ab1587cd4340c684f2c468aec7 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Tue, 5 Jan 2010 22:29:31 +0200
Subject: [PATCH 1/9] MTD: call remove notifiers before removing the device, so users
 have chance to free the mtd device

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtdcore.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 467a4f1..738e329 100644
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



