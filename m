Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbXKCALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbXKCALc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761767AbXKCACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:23 -0400
Received: from ns.suse.de ([195.135.220.2]:41183 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761274AbXKCACW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/54] Driver Core: add kobj_attribute handling
Date: Fri,  2 Nov 2007 16:59:12 -0700
Message-Id: <1194047972-9850-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Add kobj_sysfs_ops to replace subsys_sysfs_ops. There is no
need for special kset operations, we want to be able to use
simple attribute operations at any kobject, not only ksets.

The whole concept of any default sysfs attribute operations
will go away with the upcoming removal of subsys_sysfs_ops.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |   10 ++++++++++
 lib/kobject.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 8f4a38c..cf9768a 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -119,6 +119,16 @@ struct kset_uevent_ops {
 		      struct kobj_uevent_env *env);
 };
 
+struct kobj_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+extern struct sysfs_ops kobj_sysfs_ops;
+
 /**
  * struct kset - a set of kobjects of a specific type, belonging to a specific subsystem.
  *
diff --git a/lib/kobject.c b/lib/kobject.c
index 725fe2e..bc2ba8c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -488,6 +488,35 @@ void kobject_put(struct kobject * kobj)
 		kref_put(&kobj->kref, kobject_release);
 }
 
+/* default kobject attribute operations */
+static ssize_t kobj_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->show)
+		ret = kattr->show(kobj, kattr, buf);
+	return ret;
+}
+
+static ssize_t kobj_attr_store(struct kobject *kobj, struct attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct kobj_attribute *kattr;
+	ssize_t ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->store)
+		ret = kattr->store(kobj, kattr, buf, count);
+	return ret;
+}
+
+struct sysfs_ops kobj_sysfs_ops = {
+	.show	= kobj_attr_show,
+	.store	= kobj_attr_store,
+};
 
 static void dir_release(struct kobject *kobj)
 {
-- 
1.5.3.4

