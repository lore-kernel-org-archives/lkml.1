Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbYAYHk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbYAYHk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbYAYHSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:49 -0500
Received: from ns1.suse.de ([195.135.220.2]:52974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525AbYAYHSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 073/196] Driver Core: add kobj_attribute handling
Date: Thu, 24 Jan 2008 23:10:11 -0800
Message-Id: <1201245134-4876-73-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index a6dd669..e694261 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -126,6 +126,16 @@ struct kset_uevent_ops {
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
index 67c3d38..1c343fe 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -697,6 +697,35 @@ void kset_init(struct kset * k)
 	spin_lock_init(&k->list_lock);
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
 
 /**
  *	kset_add - add a kset object to the hierarchy.
-- 
1.5.3.8

