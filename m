Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbYDHLW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbYDHLW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYDHLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16943 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYDHLTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:21 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 14/29] scsi: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:21 +0400
Message-Id: <1207653576-12640-14-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/scsi_proc.c |    4 ++--
 drivers/scsi/sg.c        |   12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index db8163b..7b5563c 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -408,6 +408,7 @@ static int proc_scsi_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_scsi_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_scsi_open,
 	.read		= seq_read,
 	.write		= proc_scsi_write,
@@ -426,10 +427,9 @@ int __init scsi_init_procfs(void)
 	if (!proc_scsi)
 		goto err1;
 
-	pde = create_proc_entry("scsi/scsi", 0, NULL);
+	pde = proc_create("scsi/scsi", 0, NULL, &proc_scsi_operations);
 	if (!pde)
 		goto err2;
-	pde->proc_fops = &proc_scsi_operations;
 
 	return 0;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2029422..c9d7f72 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2667,7 +2667,6 @@ sg_proc_init(void)
 {
 	int k, mask;
 	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
-	struct proc_dir_entry *pdep;
 	struct sg_proc_leaf * leaf;
 
 	sg_proc_sgp = proc_mkdir(sg_proc_sg_dirname, NULL);
@@ -2676,13 +2675,10 @@ sg_proc_init(void)
 	for (k = 0; k < num_leaves; ++k) {
 		leaf = &sg_proc_leaf_arr[k];
 		mask = leaf->fops->write ? S_IRUGO | S_IWUSR : S_IRUGO;
-		pdep = create_proc_entry(leaf->name, mask, sg_proc_sgp);
-		if (pdep) {
-			leaf->fops->owner = THIS_MODULE,
-			leaf->fops->read = seq_read,
-			leaf->fops->llseek = seq_lseek,
-			pdep->proc_fops = leaf->fops;
-		}
+		leaf->fops->owner = THIS_MODULE;
+		leaf->fops->read = seq_read;
+		leaf->fops->llseek = seq_lseek;
+		proc_create(leaf->name, mask, sg_proc_sgp, leaf->fops);
 	}
 	return 0;
 }
-- 
1.5.3.rc5

