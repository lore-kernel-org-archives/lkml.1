Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbYDHLZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbYDHLZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYDHLTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:1279 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbYDHLT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:28 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 28/29] drivers: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:35 +0400
Message-Id: <1207653576-12640-28-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/i8k.c     |    6 ++----
 drivers/char/misc.c    |   27 +++++++++++++++------------
 drivers/char/rtc.c     |    6 ++----
 drivers/char/toshiba.c |    3 +--
 drivers/char/viotape.c |    9 +++------
 5 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 8609b82..f49037b 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -82,6 +82,7 @@ static int i8k_ioctl(struct inode *, struct file *, unsigned int,
 		     unsigned long);
 
 static const struct file_operations i8k_fops = {
+	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -554,13 +555,10 @@ static int __init i8k_init(void)
 		return -ENODEV;
 
 	/* Register the proc entry */
-	proc_i8k = create_proc_entry("i8k", 0, NULL);
+	proc_i8k = proc_create("i8k", 0, NULL, &i8k_fops);
 	if (!proc_i8k)
 		return -ENOENT;
 
-	proc_i8k->proc_fops = &i8k_fops;
-	proc_i8k->owner = THIS_MODULE;
-
 	printk(KERN_INFO
 	       "Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n",
 	       I8K_VERSION);
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index bc717e4..2f8ceb0 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -262,23 +262,26 @@ EXPORT_SYMBOL(misc_deregister);
 
 static int __init misc_init(void)
 {
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *ent;
+	int err;
 
-	ent = create_proc_entry("misc", 0, NULL);
-	if (ent)
-		ent->proc_fops = &misc_proc_fops;
+#ifdef CONFIG_PROC_FS
+	proc_create("misc", 0, NULL, &misc_proc_fops);
 #endif
 	misc_class = class_create(THIS_MODULE, "misc");
+	err = PTR_ERR(misc_class);
 	if (IS_ERR(misc_class))
-		return PTR_ERR(misc_class);
+		goto fail_remove;
 
-	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops)) {
-		printk("unable to get major %d for misc devices\n",
-		       MISC_MAJOR);
-		class_destroy(misc_class);
-		return -EIO;
-	}
+	err = -EIO;
+	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
+		goto fail_printk;
 	return 0;
+
+fail_printk:
+	printk("unable to get major %d for misc devices\n", MISC_MAJOR);
+	class_destroy(misc_class);
+fail_remove:
+	remove_proc_entry("misc", NULL);
+	return err;
 }
 subsys_initcall(misc_init);
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 5c3142b..b775df9 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -1068,10 +1068,8 @@ no_irq:
 	}
 
 #ifdef CONFIG_PROC_FS
-	ent = create_proc_entry("driver/rtc", 0, NULL);
-	if (ent)
-		ent->proc_fops = &rtc_proc_fops;
-	else
+	ent = proc_create("driver/rtc", 0, NULL, &rtc_proc_fops);
+	if (!ent)
 		printk(KERN_WARNING "rtc: Failed to register with procfs.\n");
 #endif
 
diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index ce5ebe3..64f1cee 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -520,12 +520,11 @@ static int __init toshiba_init(void)
 	{
 		struct proc_dir_entry *pde;
 
-		pde = create_proc_entry("toshiba", 0, NULL);
+		pde = proc_create("toshiba", 0, NULL, &proc_toshiba_fops);
 		if (!pde) {
 			misc_deregister(&tosh_device);
 			return -ENOMEM;
 		}
-		pde->proc_fops = &proc_toshiba_fops;
 	}
 #endif
 
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index db7a731..58aad63 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -249,6 +249,7 @@ static int proc_viotape_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_viotape_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_viotape_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -915,7 +916,6 @@ static struct vio_driver viotape_driver = {
 int __init viotap_init(void)
 {
 	int ret;
-	struct proc_dir_entry *e;
 
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
 		return -ENODEV;
@@ -968,11 +968,8 @@ int __init viotap_init(void)
 	if (ret)
 		goto unreg_class;
 
-	e = create_proc_entry("iSeries/viotape", S_IFREG|S_IRUGO, NULL);
-	if (e) {
-		e->owner = THIS_MODULE;
-		e->proc_fops = &proc_viotape_operations;
-	}
+	proc_create("iSeries/viotape", S_IFREG|S_IRUGO, NULL,
+		    &proc_viotape_operations);
 
 	return 0;
 
-- 
1.5.3.rc5

