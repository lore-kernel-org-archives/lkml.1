Return-Path: <linux-kernel-owner+w=401wt.eu-S1763275AbYAYHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763275AbYAYHwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbYAYHgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:07 -0500
Received: from ns1.suse.de ([195.135.220.2]:55275 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761426AbYAYHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Mark Fasheh <mark.fasheh@oracle.com>,
       Kurt Hackel <kurt.hackel@oracle.com>
Subject: [PATCH 093/196] kset: convert ocfs2 to use kset_create
Date: Thu, 24 Jan 2008 23:32:02 -0800
Message-Id: <1201246425-5058-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Also use the new kobj_attribute which cleans up this file a _lot_.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ocfs2/cluster/masklog.c |    4 +-
 fs/ocfs2/cluster/sys.c     |   83 +++++++++++--------------------------------
 2 files changed, 23 insertions(+), 64 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index dead319..23c732f 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -146,7 +146,7 @@ static struct kset mlog_kset = {
 	.kobj   = {.ktype = &mlog_ktype},
 };
 
-int mlog_sys_init(struct kset *o2cb_subsys)
+int mlog_sys_init(struct kset *o2cb_kset)
 {
 	int i = 0;
 
@@ -157,7 +157,7 @@ int mlog_sys_init(struct kset *o2cb_subsys)
 	mlog_attr_ptrs[i] = NULL;
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
-	mlog_kset.kobj.kset = o2cb_subsys;
+	mlog_kset.kobj.kset = o2cb_kset;
 	return kset_register(&mlog_kset);
 }
 
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 880d013..a4b0773 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -28,96 +28,55 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/fs.h>
 
 #include "ocfs2_nodemanager.h"
 #include "masklog.h"
 #include "sys.h"
 
-struct o2cb_attribute {
-	struct attribute	attr;
-	ssize_t (*show)(char *buf);
-	ssize_t (*store)(const char *buf, size_t count);
-};
-
-#define O2CB_ATTR(_name, _mode, _show, _store)	\
-struct o2cb_attribute o2cb_attr_##_name = __ATTR(_name, _mode, _show, _store)
-
-#define to_o2cb_attr(_attr) container_of(_attr, struct o2cb_attribute, attr)
 
-static ssize_t o2cb_interface_revision_show(char *buf)
+static ssize_t version_show(struct kobject *kobj, struct kobj_attribute *attr,
+			    char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%u\n", O2NM_API_VERSION);
 }
-
-static O2CB_ATTR(interface_revision, S_IFREG | S_IRUGO, o2cb_interface_revision_show, NULL);
+static struct kobj_attribute attr_version =
+	__ATTR(interface_revision, S_IFREG | S_IRUGO, version_show, NULL);
 
 static struct attribute *o2cb_attrs[] = {
-	&o2cb_attr_interface_revision.attr,
+	&attr_version.attr,
 	NULL,
 };
 
-static ssize_t
-o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer);
-static ssize_t
-o2cb_store(struct kobject * kobj, struct attribute * attr,
-	   const char * buffer, size_t count);
-static struct sysfs_ops o2cb_sysfs_ops = {
-	.show	= o2cb_show,
-	.store	= o2cb_store,
+static struct attribute_group o2cb_attr_group = {
+	.attrs = o2cb_attrs,
 };
 
-static struct kobj_type o2cb_subsys_type = {
-	.default_attrs	= o2cb_attrs,
-	.sysfs_ops	= &o2cb_sysfs_ops,
-};
-
-/* gives us o2cb_subsys */
-static decl_subsys(o2cb, NULL);
-
-static ssize_t
-o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
-{
-	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
-	struct kset *sbs = to_kset(kobj);
-
-	BUG_ON(sbs != &o2cb_subsys);
-
-	if (o2cb_attr->show)
-		return o2cb_attr->show(buffer);
-	return -EIO;
-}
-
-static ssize_t
-o2cb_store(struct kobject * kobj, struct attribute * attr,
-	     const char * buffer, size_t count)
-{
-	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
-	struct kset *sbs = to_kset(kobj);
-
-	BUG_ON(sbs != &o2cb_subsys);
-
-	if (o2cb_attr->store)
-		return o2cb_attr->store(buffer, count);
-	return -EIO;
-}
+static struct kset *o2cb_kset;
 
 void o2cb_sys_shutdown(void)
 {
 	mlog_sys_shutdown();
-	subsystem_unregister(&o2cb_subsys);
+	kset_unregister(o2cb_kset);
 }
 
 int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_subsys.kobj.ktype = &o2cb_subsys_type;
-	ret = subsystem_register(&o2cb_subsys);
+	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
+	if (!o2cb_kset)
+		return -ENOMEM;
+
+	ret = sysfs_create_group(&o2cb_kset->kobj, &o2cb_attr_group);
 	if (ret)
-		return ret;
+		goto error;
 
-	ret = mlog_sys_init(&o2cb_subsys);
+	ret = mlog_sys_init(o2cb_kset);
 	if (ret)
-		subsystem_unregister(&o2cb_subsys);
+		goto error;
+	return 0;
+error:
+	kset_unregister(o2cb_kset);
 	return ret;
 }
-- 
1.5.3.8

