Return-Path: <linux-kernel-owner+w=401wt.eu-S1765021AbZDBXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765021AbZDBXmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763885AbZDBXl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:41:58 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:34988 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442AbZDBXl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z0kt2XYmdRtqjUzoFvZte1iad1aCB7JRGGDNkyJ7vDAThynSJWQhu9cB93sgZtagr+
         4wTyNF8MuR5a4biERf6qzsyfm/umSrqDU9LKidP+B+xSKlU3+T2oHeipGacebVPWgiLa
         CB7U3Aht+ZMeow/ny+oulPk6NdMH48gZ6cYxc=
MIME-Version: 1.0
In-Reply-To: <200903260042.42091.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net>
Date: Thu, 2 Apr 2009 16:41:47 -0700
Message-ID: <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a follow-up patch to apply on top of David Brownell's original
MTD driver model patch at:

http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html

Changes:

1) Add more sysfs attributes: mtd_flags, mtd_size, mtd_erasesize,
mtd_writesize, mtd_oobsize, mtd_numeraseregions, mtd_name .

2) Move core_initcall() code into init_mtd().  The original approach
does not work if CONFIG_MTD=m .

3) Add device_unregister() in del_mtd_device() so that devices get
removed from sysfs as each driver is unloaded.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/mtdcore.c |  107 ++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a88f8bc..19897ba 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -91,9 +91,87 @@ static ssize_t mtd_type_show(struct device *dev,
 }
 static DEVICE_ATTR(mtd_type, S_IRUGO, mtd_type_show, NULL);

+static ssize_t mtd_flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n", (unsigned long)mtd->flags);
+
+}
+static DEVICE_ATTR(mtd_flags, S_IRUGO, mtd_flags_show, NULL);
+
+static ssize_t mtd_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+		(unsigned long long)mtd->size);
+
+}
+static DEVICE_ATTR(mtd_size, S_IRUGO, mtd_size_show, NULL);
+
+static ssize_t mtd_erasesize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->erasesize);
+
+}
+static DEVICE_ATTR(mtd_erasesize, S_IRUGO, mtd_erasesize_show, NULL);
+
+static ssize_t mtd_writesize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->writesize);
+
+}
+static DEVICE_ATTR(mtd_writesize, S_IRUGO, mtd_writesize_show, NULL);
+
+static ssize_t mtd_oobsize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->oobsize);
+
+}
+static DEVICE_ATTR(mtd_oobsize, S_IRUGO, mtd_oobsize_show, NULL);
+
+static ssize_t mtd_numeraseregions_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", mtd->numeraseregions);
+
+}
+static DEVICE_ATTR(mtd_numeraseregions, S_IRUGO, mtd_numeraseregions_show,
+	NULL);
+
+static ssize_t mtd_name_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", mtd->name);
+
+}
+static DEVICE_ATTR(mtd_name, S_IRUGO, mtd_name_show, NULL);
+
 static struct attribute *mtd_attrs[] = {
 	&dev_attr_mtd_type.attr,
-	/* FIXME provide a /proc/mtd superset */
+	&dev_attr_mtd_flags.attr,
+	&dev_attr_mtd_size.attr,
+	&dev_attr_mtd_erasesize.attr,
+	&dev_attr_mtd_writesize.attr,
+	&dev_attr_mtd_oobsize.attr,
+	&dev_attr_mtd_numeraseregions.attr,
+	&dev_attr_mtd_name.attr,
 	NULL,
 };

@@ -236,6 +314,8 @@ int del_mtd_device (struct mtd_info *mtd)
 	} else {
 		struct mtd_notifier *not;

+		device_unregister(&mtd->dev);
+
 		/* No need to get a refcount on the module containing
 		   the notifier, since we hold the mtd_table_mutex */
 		list_for_each_entry(not, &mtd_notifiers, list)
@@ -455,24 +535,6 @@ EXPORT_SYMBOL_GPL(register_mtd_user);
 EXPORT_SYMBOL_GPL(unregister_mtd_user);
 EXPORT_SYMBOL_GPL(default_mtd_writev);

-static int __init mtd_setup(void)
-{
-	mtd_class = class_create(THIS_MODULE, "mtd");
-
-	if (IS_ERR(mtd_class)) {
-		pr_err("Error creating mtd class.\n");
-		return PTR_ERR(mtd_class);
-	}
-	return 0;
-}
-core_initcall(mtd_setup);
-
-static void __exit mtd_teardown(void)
-{
-	class_destroy(mtd_class);
-}
-__exitcall(mtd_teardown);
-
 #ifdef CONFIG_PROC_FS

 /*====================================================================*/
@@ -528,6 +590,12 @@ done:

 static int __init init_mtd(void)
 {
+	mtd_class = class_create(THIS_MODULE, "mtd");
+
+	if (IS_ERR(mtd_class)) {
+		pr_err("Error creating mtd class.\n");
+		return PTR_ERR(mtd_class);
+	}
 	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
 		proc_mtd->read_proc = mtd_read_proc;
 	return 0;
@@ -537,6 +605,7 @@ static void __exit cleanup_mtd(void)
 {
         if (proc_mtd)
 		remove_proc_entry( "mtd", NULL);
+	class_destroy(mtd_class);
 }

 module_init(init_mtd);
-- 
1.5.6.3
