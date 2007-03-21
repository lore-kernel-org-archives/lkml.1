Return-Path: <linux-kernel-owner+w=401wt.eu-S965194AbXCUWS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194AbXCUWS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965322AbXCUWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:18:26 -0400
Received: from mx.pathscale.com ([198.186.3.68]:35506 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965194AbXCUWSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:18:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] IB/ipath: check return value of lookup_one_len
X-Mercurial-Node: e3e94873cfa04ae59dbcf65ff0055d962512d2fd
Message-Id: <e3e94873cfa04ae59dbc.1174515494@eng-12.pathscale.com>
Date: Wed, 21 Mar 2007 15:18:14 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: skyhover.pi@gmail.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes kernel.org bug 8003.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 2a2b2b882891 -r e3e94873cfa0 drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c	Wed Mar 21 15:16:07 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c	Wed Mar 21 15:16:07 2007 -0700
@@ -456,11 +456,17 @@ bail:
 	return ret;
 }
 
-static void remove_file(struct dentry *parent, char *name)
+static int remove_file(struct dentry *parent, char *name)
 {
 	struct dentry *tmp;
+	int ret;
 
 	tmp = lookup_one_len(name, parent, strlen(name));
+
+	if (IS_ERR(tmp)) {
+		ret = PTR_ERR(tmp);
+		goto bail;
+	}
 
 	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
@@ -474,6 +480,14 @@ static void remove_file(struct dentry *p
 		spin_unlock(&tmp->d_lock);
 		spin_unlock(&dcache_lock);
 	}
+
+	ret = 0;
+bail:
+	/*
+	 * We don't expect clients to care about the return value, but
+	 * it's there if they need it.
+	 */
+	return ret;
 }
 
 static int remove_device_files(struct super_block *sb,
