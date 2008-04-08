Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYDHLV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYDHLV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYDHLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2205 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYDHLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:20 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 16/29] s390: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:23 +0400
Message-Id: <1207653576-12640-16-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE
to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: linux-s390@vger.kernel.org
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/block/dasd_proc.c |   10 +++++-----
 drivers/s390/char/tape_proc.c  |    7 +++----
 drivers/s390/cio/blacklist.c   |    7 ++-----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 8ae9406..03c0e40 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -157,6 +157,7 @@ static int dasd_devices_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations dasd_devices_file_ops = {
+	.owner		= THIS_MODULE,
 	.open		= dasd_devices_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -315,13 +316,12 @@ dasd_proc_init(void)
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
 	dasd_proc_root_entry->owner = THIS_MODULE;
-	dasd_devices_entry = create_proc_entry("devices",
-					       S_IFREG | S_IRUGO | S_IWUSR,
-					       dasd_proc_root_entry);
+	dasd_devices_entry = proc_create("devices",
+					 S_IFREG | S_IRUGO | S_IWUSR,
+					 dasd_proc_root_entry,
+					 &dasd_devices_file_ops);
 	if (!dasd_devices_entry)
 		goto out_nodevices;
-	dasd_devices_entry->proc_fops = &dasd_devices_file_ops;
-	dasd_devices_entry->owner = THIS_MODULE;
 	dasd_statistics_entry = create_proc_entry("statistics",
 						  S_IFREG | S_IRUGO | S_IWUSR,
 						  dasd_proc_root_entry);
diff --git a/drivers/s390/char/tape_proc.c b/drivers/s390/char/tape_proc.c
index 0c39636..e7c888c 100644
--- a/drivers/s390/char/tape_proc.c
+++ b/drivers/s390/char/tape_proc.c
@@ -111,6 +111,7 @@ static int tape_proc_open(struct inode *inode, struct file *file)
 
 static const struct file_operations tape_proc_ops =
 {
+	.owner		= THIS_MODULE,
 	.open		= tape_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -124,14 +125,12 @@ void
 tape_proc_init(void)
 {
 	tape_proc_devices =
-		create_proc_entry ("tapedevices", S_IFREG | S_IRUGO | S_IWUSR,
-				   NULL);
+		proc_create("tapedevices", S_IFREG | S_IRUGO | S_IWUSR, NULL,
+			    &tape_proc_ops);
 	if (tape_proc_devices == NULL) {
 		PRINT_WARN("tape: Cannot register procfs entry tapedevices\n");
 		return;
 	}
-	tape_proc_devices->proc_fops = &tape_proc_ops;
-	tape_proc_devices->owner = THIS_MODULE;
 }
 
 /*
diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index ef33d5d..40ef948 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -374,13 +374,10 @@ cio_ignore_proc_init (void)
 {
 	struct proc_dir_entry *entry;
 
-	entry = create_proc_entry ("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR,
-				   NULL);
+	entry = proc_create("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR, NULL,
+			    &cio_ignore_proc_fops);
 	if (!entry)
 		return -ENOENT;
-
-	entry->proc_fops = &cio_ignore_proc_fops;
-
 	return 0;
 }
 
-- 
1.5.3.rc5

