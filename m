Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZFJO2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZFJO2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZFJO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:27:54 -0400
Received: from mail-px0-f200.google.com ([209.85.216.200]:45672 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbZFJO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pQyaAgVDp7bfzeBaC2/RTPUME+wMmJlGuA6YR91Cien/8fA4ckKFk6K5cnSKN16UGV
         oe66ffDaCYy5MUuswownHkxorrLeIQMD1wtxbYyhLUmvlqb9DRXzylsS+w8r13gMN3M9
         a+tmnzpPKpnlJ/wNcNmZ95iyHrqv9ROKmbsO4=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] driver core: introduce devtmpfs_wait_for_dev()
Date: Wed, 10 Jun 2009 22:27:44 +0800
Message-Id: <1244644064-32737-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch introduces devtmpfs_wait_for_dev(), which is based on devtmpfs
and can be used to remove polling for root device before mounting rootfs.

This patch also gives a generic and simple way to wait for a device in
kernel mode based on devtmpfs.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/devtmpfs.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h  |    7 ++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 51c410f..4e20c71 100644
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
@@ -310,6 +317,54 @@ out:
 	return err;
 }
 
+static int devtmpfs_query_dev(const char *dev_path)
+{
+	const char *nodename;
+	const struct cred *curr_cred;
+	struct nameidata nd;
+	struct dentry *dentry;
+	int err;
+
+	if (!dev_mnt)
+		return -ENOENT;
+
+	nodename = dev_path + 5;
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
+int devtmpfs_wait_for_dev(const char *dev_path, unsigned long seconds)
+{
+	if (strncmp(dev_path, "/dev/", 5) != 0)
+		return -1;
+
+	return wait_event_timeout(devtmpfs_waitqueue,
+		devtmpfs_query_dev(dev_path) == 0,
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

