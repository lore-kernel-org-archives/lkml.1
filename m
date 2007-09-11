Return-Path: <linux-kernel-owner+w=401wt.eu-S965623AbXIKUMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965623AbXIKUMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934328AbXIKUCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:02:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934315AbXIKUCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:02:40 -0400
Message-Id: <20070911200014.674433000@chello.nl>
References: <20070911195350.825778000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 11 Sep 2007 21:54:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 13/23] mtd: bdi init hooks
Content-Disposition: inline; filename=bdi_init_mtd.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

split off because the relevant mtd changes seem particular to -mm

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtdcore.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/mtd/mtdcore.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtdcore.c
+++ linux-2.6/drivers/mtd/mtdcore.c
@@ -48,6 +48,7 @@ static LIST_HEAD(mtd_notifiers);
 int add_mtd_device(struct mtd_info *mtd)
 {
 	int i;
+	int err;
 
 	if (!mtd->backing_dev_info) {
 		switch (mtd->type) {
@@ -62,6 +63,9 @@ int add_mtd_device(struct mtd_info *mtd)
 			break;
 		}
 	}
+	err = bdi_init(mtd->backing_dev_info);
+	if (err)
+		return 1;
 
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
@@ -102,6 +106,7 @@ int add_mtd_device(struct mtd_info *mtd)
 		}
 
 	mutex_unlock(&mtd_table_mutex);
+	bdi_destroy(mtd->backing_dev_info);
 	return 1;
 }
 
@@ -144,6 +149,10 @@ int del_mtd_device (struct mtd_info *mtd
 	}
 
 	mutex_unlock(&mtd_table_mutex);
+
+	if (mtd->backing_dev_info)
+		bdi_destroy(mtd->backing_dev_info);
+
 	return ret;
 }
 

--

