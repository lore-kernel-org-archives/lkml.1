Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZHFJkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZHFJkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZHFJkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:40:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:52895 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZHFJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rxdD7H3Q/RB0Lw0Jqidyx9cVfZdsfDU0lnl2vMsT7eJr9GOV/4G38+3LdWEy/HG+zB
         4xQbqXxTO/yjYjJrK+DrLUOx/Dc0Wioh9hqs+UBSeWAZ02tVNjPI2yt9CbyPErgHMqsK
         iNgzjUBfMYNe2oZlbn6SPSenh2cwketoicW4A=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] driver core: introduce devtmpfs_wait_for_dev() v1
Date: Thu,  6 Aug 2009 17:40:02 +0800
Message-Id: <1249551602-13147-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch introduces devtmpfs_wait_for_dev(), which is based on devtmpfs
and can be used to remove polling for root device before mounting rootfs.

This patch also gives a generic and simple way to wait for a device in
kernel mode based on devtmpfs.

This version takes Kay Sievers's suggestion: pass relative path to
devtmpfs_wait_for_dev(), for devtmpfs has no clue where it is
mounted.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/devtmpfs.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h  |    7 ++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 51c410f..3a04252 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -30,6 +30,9 @@ static int dev_mount = 1;
 static int dev_mount;
 #endif
 
+static DECLARE_WAIT_QUEUE_HEAD(devtmpfs_waitqueue);
+
+
 static int __init mount_param(char *str)
 {
 	dev_mount = simple_strtoul(str, NULL, 0);
@@ -178,6 +181,10 @@ int devtmpfs_create_node(struct device *dev)
 
 	path_put(&nd.path);
 out:
+	/*notify others that we have created a dev node*/
+	if (!err)
+		wake_up(&devtmpfs_waitqueue);
+
 	kfree(tmp);
 	revert_creds(curr_cred);
 	return err;
@@ -310,6 +317,49 @@ out:
 	return err;
 }
 
+static int devtmpfs_query_dev(const char *nodename)
+{
+	const struct cred *curr_cred;
+	struct nameidata nd;
+	struct dentry *dentry;
+	int err;
+
+	if (!dev_mnt)
+		return -ENOENT;
+
+	curr_cred = override_creds(&init_cred);
+	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
+			      nodename, LOOKUP_PARENT, &nd);
+	if (err)
+		goto out;
+
+	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	dentry = lookup_one_len(nd.last.name, nd.path.dentry, nd.last.len);
+	if (!IS_ERR(dentry)) {
+		if (dentry->d_inode)
+			err = 0;
+		else
+			err = -ENOENT;
+		dput(dentry);
+	} else {
+		err = PTR_ERR(dentry);
+	}
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+
+	path_put(&nd.path);
+out:
+	revert_creds(curr_cred);
+	return err;
+}
+
+int devtmpfs_wait_for_dev(const char *dev_name, unsigned long seconds)
+{
+
+	return wait_event_timeout(devtmpfs_waitqueue,
+		devtmpfs_query_dev(dev_name) == 0,
+		seconds*HZ);
+}
+
 /*
  * If configured, or requested by the commandline, devtmpfs will be
  * auto-mounted after the kernel mounted the root filesystem.
diff --git a/include/linux/device.h b/include/linux/device.h
index 65f5b5a..1fa1b19 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -557,10 +557,17 @@ extern void wait_for_device_probe(void);
 extern int devtmpfs_create_node(struct device *dev);
 extern int devtmpfs_delete_node(struct device *dev);
 extern int devtmpfs_mount(const char *mountpoint);
+extern int devtmpfs_wait_for_dev(const char *dev_path,
+				unsigned long seconds);
 #else
 static inline int devtmpfs_create_node(struct device *dev) { return 0; }
 static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
 static inline int devtmpfs_mount(const char *mountpoint) { return 0; }
+static inline int devtmpfs_wait_for_dev(const char *dev_path,
+			unsigned long seconds)
+{
+	return 0;
+}
 #endif
 
 /* drivers/base/power/shutdown.c */
-- 
1.6.0.GIT

