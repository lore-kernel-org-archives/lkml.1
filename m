Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbXKCALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbXKCALs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762047AbXKCAC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:34886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761997AbXKCAC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/54] Driver Core: switch all dynamic ksets to kobj_sysfs_ops
Date: Fri,  2 Nov 2007 16:59:13 -0700
Message-Id: <1194047972-9850-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Switch all dynamically created ksets, that export simple attributes,
to kobj_attribute from subsys_attribute. Struct subsys_attribute will
be removed.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c   |   10 ++++++----
 kernel/ksysfs.c      |   35 +++++++++++++++++++++--------------
 kernel/power/disk.c  |   18 ++++++++++++------
 kernel/power/main.c  |   12 ++++++++----
 kernel/power/power.h |    2 +-
 lib/kobject.c        |    8 ++++----
 6 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b72a495..828fb99 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -732,12 +732,13 @@ static int ecryptfs_init_kmem_caches(void)
 
 static struct kset *ecryptfs_kset;
 
-static ssize_t version_show(struct kset *kset, char *buff)
+static ssize_t version_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buff)
 {
 	return snprintf(buff, PAGE_SIZE, "%d\n", ECRYPTFS_VERSIONING_MASK);
 }
 
-static struct subsys_attribute version_attr = __ATTR_RO(version);
+static struct kobj_attribute version_attr = __ATTR_RO(version);
 
 static struct ecryptfs_version_str_map_elem {
 	u32 flag;
@@ -751,7 +752,8 @@ static struct ecryptfs_version_str_map_elem {
 	{ECRYPTFS_VERSIONING_MULTKEY, "multiple keys per file"}
 };
 
-static ssize_t version_str_show(struct kset *kset, char *buff)
+static ssize_t version_str_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buff)
 {
 	int i;
 	int remaining = PAGE_SIZE;
@@ -778,7 +780,7 @@ out:
 	return total_written;
 }
 
-static struct subsys_attribute version_attr_str = __ATTR_RO(version_str);
+static struct kobj_attribute version_attr_str = __ATTR_RO(version_str);
 
 static struct attribute *attributes[] = {
 	&version_attr.attr,
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index b4f5116..ea07bcf 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -18,30 +18,34 @@
 #include <linux/err.h>
 
 #define KERNEL_ATTR_RO(_name) \
-static struct subsys_attribute _name##_attr = __ATTR_RO(_name)
+static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
 #define KERNEL_ATTR_RW(_name) \
-static struct subsys_attribute _name##_attr = \
+static struct kobj_attribute _name##_attr = \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
 /* current uevent sequence number */
-static ssize_t uevent_seqnum_show(struct kset *kset, char *page)
+static ssize_t uevent_seqnum_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(page, "%llu\n", (unsigned long long)uevent_seqnum);
+	return sprintf(buf, "%llu\n", (unsigned long long)uevent_seqnum);
 }
 KERNEL_ATTR_RO(uevent_seqnum);
 
 /* uevent helper program, used during early boo */
-static ssize_t uevent_helper_show(struct kset *kset, char *page)
+static ssize_t uevent_helper_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(page, "%s\n", uevent_helper);
+	return sprintf(buf, "%s\n", uevent_helper);
 }
-static ssize_t uevent_helper_store(struct kset *kset, const char *page, size_t count)
+static ssize_t uevent_helper_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
 {
 	if (count+1 > UEVENT_HELPER_PATH_LEN)
 		return -ENOENT;
-	memcpy(uevent_helper, page, count);
+	memcpy(uevent_helper, buf, count);
 	uevent_helper[count] = '\0';
 	if (count && uevent_helper[count-1] == '\n')
 		uevent_helper[count-1] = '\0';
@@ -51,21 +55,24 @@ KERNEL_ATTR_RW(uevent_helper);
 #endif
 
 #ifdef CONFIG_KEXEC
-static ssize_t kexec_loaded_show(struct kset *kset, char *page)
+static ssize_t kexec_loaded_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(page, "%d\n", !!kexec_image);
+	return sprintf(buf, "%d\n", !!kexec_image);
 }
 KERNEL_ATTR_RO(kexec_loaded);
 
-static ssize_t kexec_crash_loaded_show(struct kset *kset, char *page)
+static ssize_t kexec_crash_loaded_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(page, "%d\n", !!kexec_crash_image);
+	return sprintf(buf, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
-static ssize_t vmcoreinfo_show(struct kset *kset, char *page)
+static ssize_t vmcoreinfo_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(page, "%lx %x\n",
+	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
 		       (unsigned int)vmcoreinfo_max_size);
 }
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 05fbe67..c8062cc 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -557,7 +557,8 @@ static const char * const hibernation_modes[] = {
  *	supports it (as determined by having hibernation_ops).
  */
 
-static ssize_t disk_show(struct kset *kset, char *buf)
+static ssize_t disk_show(struct kobject *kobj, struct kobj_attribut *attr,
+			 char *buf)
 {
 	int i;
 	char *start = buf;
@@ -587,7 +588,8 @@ static ssize_t disk_show(struct kset *kset, char *buf)
 }
 
 
-static ssize_t disk_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t disk_store(struct kobject *kobj, struct kobj_attribut *attr,
+			  const char *buf, size_t n)
 {
 	int error = 0;
 	int i;
@@ -632,13 +634,15 @@ static ssize_t disk_store(struct kset *kset, const char *buf, size_t n)
 
 power_attr(disk);
 
-static ssize_t resume_show(struct kset *kset, char *buf)
+static ssize_t resume_show(struct kobject *kobj, struct kobj_attribut *attr,
+			   char *buf)
 {
 	return sprintf(buf,"%d:%d\n", MAJOR(swsusp_resume_device),
 		       MINOR(swsusp_resume_device));
 }
 
-static ssize_t resume_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t resume_store(struct kobject *kobj, struct kobj_attribut *attr,
+			    const char *buf, size_t n)
 {
 	unsigned int maj, min;
 	dev_t res;
@@ -664,12 +668,14 @@ static ssize_t resume_store(struct kset *kset, const char *buf, size_t n)
 
 power_attr(resume);
 
-static ssize_t image_size_show(struct kset *kset, char *buf)
+static ssize_t image_size_show(struct kobject *kobj, struct kobj_attribut *attr,
+			       char *buf)
 {
 	return sprintf(buf, "%lu\n", image_size);
 }
 
-static ssize_t image_size_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t image_size_store(struct kobject *kobj, struct kobj_attribut *attr,
+				const char *buf, size_t n)
 {
 	unsigned long size;
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 6651a3c..f0f506b 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -287,7 +287,8 @@ struct kset *power_kset;
  *	proper enumerated value, and initiates a suspend transition.
  */
 
-static ssize_t state_show(struct kset *kset, char *buf)
+static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
+			  char *buf)
 {
 	char *s = buf;
 #ifdef CONFIG_SUSPEND
@@ -308,7 +309,8 @@ static ssize_t state_show(struct kset *kset, char *buf)
 	return (s - buf);
 }
 
-static ssize_t state_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
 	suspend_state_t state = PM_SUSPEND_STANDBY;
@@ -345,13 +347,15 @@ power_attr(state);
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
-static ssize_t pm_trace_show(struct kset *kset, char *buf)
+static ssize_t pm_trace_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
 {
 	return sprintf(buf, "%d\n", pm_trace_enabled);
 }
 
 static ssize_t
-pm_trace_store(struct kset *kset, const char *buf, size_t n)
+pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
+	       const char *buf, size_t n)
 {
 	int val;
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 1083e6b..2093c3a 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -54,7 +54,7 @@ extern int pfn_is_nosave(unsigned long);
 extern struct mutex pm_mutex;
 
 #define power_attr(_name) \
-static struct subsys_attribute _name##_attr = {	\
+static struct kobj_attribute _name##_attr = {	\
 	.attr	= {				\
 		.name = __stringify(_name),	\
 		.mode = 0644,			\
diff --git a/lib/kobject.c b/lib/kobject.c
index bc2ba8c..dda6614 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -524,9 +524,8 @@ static void dir_release(struct kobject *kobj)
 }
 
 static struct kobj_type dir_ktype = {
+	.sysfs_ops	= &kobj_sysfs_ops,
 	.release	= dir_release,
-	.sysfs_ops	= NULL,
-	.default_attrs	= NULL,
 };
 
 /**
@@ -699,7 +698,8 @@ static void kset_release(struct kobject *kobj)
 	kfree(kset);
 }
 
-static struct kobj_type kset_type = {
+static struct kobj_type kset_ktype = {
+	.sysfs_ops	= &kobj_sysfs_ops,
 	.release = kset_release,
 };
 
@@ -741,7 +741,7 @@ static struct kset *kset_create(const char *name,
 	kset->uevent_ops = uevent_ops;
 	kset->kobj.parent = parent_kobj;
 	kset->kobj.kset = parent_kset;
-	kset->kobj.ktype = &kset_type;
+	kset->kobj.ktype = &kset_ktype;
 
 	return kset;
 }
-- 
1.5.3.4

