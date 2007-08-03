Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXHCM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXHCM6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762039AbXHCM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:57:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761228AbXHCM4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:56:55 -0400
Message-Id: <20070803125236.426044000@chello.nl>
References: <20070803123712.987126000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 14:37:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 12/23] mtd: bdi init hooks
Content-Disposition: inline; filename=bdi_init_mtd.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

split off because the relevant mtd changes seem particular to -mm

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

