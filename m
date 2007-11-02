Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXKCAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXKCAA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXKCAAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbXKCAAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Michael A. Halcrow" <mahalcro@us.ibm.com>,
       "Michael C. Thompson" <mcthomps@us.ibm.com>,
       Tyler Hicks <tyhicks@ou.edu>
Subject: [PATCH 01/54] ecryptfs: clean up attribute mess
Date: Fri,  2 Nov 2007 16:58:39 -0700
Message-Id: <1194047972-9850-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't that hard to add simple kset attributes, so don't go through
all the gyrations of creating your own object type and show and store
functions.  Just use the functions that are already present.  This makes
things much simpler.

Note, the version_str string violates the "one value per file" rule for
sysfs.  I suggest changing this now (individual files per type supported
is one suggested way.)


Cc: Michael A. Halcrow <mahalcro@us.ibm.com>
Cc: Michael C. Thompson <mcthomps@us.ibm.com>
Cc: Tyler Hicks <tyhicks@ou.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |   85 +++++++++++-----------------------------------------
 1 files changed, 18 insertions(+), 67 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b83a512..82b34f2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -730,58 +730,14 @@ static int ecryptfs_init_kmem_caches(void)
 	return 0;
 }
 
-struct ecryptfs_obj {
-	char *name;
-	struct list_head slot_list;
-	struct kobject kobj;
-};
-
-struct ecryptfs_attribute {
-	struct attribute attr;
-	ssize_t(*show) (struct ecryptfs_obj *, char *);
-	ssize_t(*store) (struct ecryptfs_obj *, const char *, size_t);
-};
-
-static ssize_t
-ecryptfs_attr_store(struct kobject *kobj,
-		    struct attribute *attr, const char *buf, size_t len)
-{
-	struct ecryptfs_obj *obj = container_of(kobj, struct ecryptfs_obj,
-						kobj);
-	struct ecryptfs_attribute *attribute =
-		container_of(attr, struct ecryptfs_attribute, attr);
-
-	return (attribute->store ? attribute->store(obj, buf, len) : 0);
-}
-
-static ssize_t
-ecryptfs_attr_show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	struct ecryptfs_obj *obj = container_of(kobj, struct ecryptfs_obj,
-						kobj);
-	struct ecryptfs_attribute *attribute =
-		container_of(attr, struct ecryptfs_attribute, attr);
-
-	return (attribute->show ? attribute->show(obj, buf) : 0);
-}
-
-static struct sysfs_ops ecryptfs_sysfs_ops = {
-	.show = ecryptfs_attr_show,
-	.store = ecryptfs_attr_store
-};
+static decl_subsys(ecryptfs, NULL, NULL);
 
-static struct kobj_type ecryptfs_ktype = {
-	.sysfs_ops = &ecryptfs_sysfs_ops
-};
-
-static decl_subsys(ecryptfs, &ecryptfs_ktype, NULL);
-
-static ssize_t version_show(struct ecryptfs_obj *obj, char *buff)
+static ssize_t version_show(struct kset *kset, char *buff)
 {
 	return snprintf(buff, PAGE_SIZE, "%d\n", ECRYPTFS_VERSIONING_MASK);
 }
 
-static struct ecryptfs_attribute sysfs_attr_version = __ATTR_RO(version);
+static struct subsys_attribute version_attr = __ATTR_RO(version);
 
 static struct ecryptfs_version_str_map_elem {
 	u32 flag;
@@ -795,7 +751,7 @@ static struct ecryptfs_version_str_map_elem {
 	{ECRYPTFS_VERSIONING_MULTKEY, "multiple keys per file"}
 };
 
-static ssize_t version_str_show(struct ecryptfs_obj *obj, char *buff)
+static ssize_t version_str_show(struct kset *kset, char *buff)
 {
 	int i;
 	int remaining = PAGE_SIZE;
@@ -822,7 +778,17 @@ out:
 	return total_written;
 }
 
-static struct ecryptfs_attribute sysfs_attr_version_str = __ATTR_RO(version_str);
+static struct subsys_attribute version_attr_str = __ATTR_RO(version_str);
+
+static struct attribute *attributes[] = {
+	&version_attr.attr,
+	&version_attr_str.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attributes,
+};
 
 static int do_sysfs_registration(void)
 {
@@ -834,23 +800,11 @@ static int do_sysfs_registration(void)
 		       "Unable to register ecryptfs sysfs subsystem\n");
 		goto out;
 	}
-	rc = sysfs_create_file(&ecryptfs_subsys.kobj,
-			       &sysfs_attr_version.attr);
+	rc = sysfs_create_group(&ecryptfs_subsys.kobj, &attr_group);
 	if (rc) {
 		printk(KERN_ERR
-		       "Unable to create ecryptfs version attribute\n");
+		       "Unable to create ecryptfs version attributes\n");
 		subsystem_unregister(&ecryptfs_subsys);
-		goto out;
-	}
-	rc = sysfs_create_file(&ecryptfs_subsys.kobj,
-			       &sysfs_attr_version_str.attr);
-	if (rc) {
-		printk(KERN_ERR
-		       "Unable to create ecryptfs version_str attribute\n");
-		sysfs_remove_file(&ecryptfs_subsys.kobj,
-				  &sysfs_attr_version.attr);
-		subsystem_unregister(&ecryptfs_subsys);
-		goto out;
 	}
 out:
 	return rc;
@@ -858,10 +812,7 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
-			  &sysfs_attr_version.attr);
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
-			  &sysfs_attr_version_str.attr);
+	sysfs_remove_group(&ecryptfs_subsys.kobj, &attr_group);
 	subsystem_unregister(&ecryptfs_subsys);
 }
 
-- 
1.5.3.4

