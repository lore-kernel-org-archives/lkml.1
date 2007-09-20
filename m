Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbXITILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbXITILZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXITIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:41897 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbXITIFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=nM9xg+sfOPiGn6SKSR6p2qTH1sO2UDEpV4w8zfNzIbjPvY9IwWdxYf2uvAbCOjdhZLWcDne92tzDx1DhptAIAkkI1ztRzh5tUIisk+ud0vk5DLVpXQ/Vsz1kxAuBk2DuZGOX0tv0BakId8e51BjUTTt4vYuyZZI/1ko62TSqlj0=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 05/22] sysfs: implement sysfs_find_child()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755393509-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement sysfs_find_child() which finds a child of a sysfs_dirent by
name.  This function does not grab reference of the found child.  The
caller is supposed to have reference if the child exists.  This
function is useful for callers which own the sysfs_dirent to be looked
up but don't wanna keep a pointer to it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |   33 +++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |    9 +++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 584f17c..7a6be9a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -647,6 +647,39 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 	return sd;
 }
 
+/**
+ *	sysfs_find_child - find sysfs_dirent with the given name
+ *	@parent: sysfs_dirent to search under
+ *	@name: name to look for
+ *
+ *	This is exported version of sysfs_find_dirent().  This
+ *	function doesn't grab reference to the found dirent.  The
+ *	caller must already have a reference to it.  This function is
+ *	useful for callers which own the sysfs_dirent to be looked up
+ *	but don't wanna keep a pointer to it.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the looked up sysfs_dirent on success, NULL if
+ *	there's no such entry, ERR_PTR(-EBADF) is @parent is ERR_PTR()
+ *	value.
+ *
+ */
+struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
+				      const char *name)
+{
+	struct sysfs_dirent *sd;
+
+	mutex_lock(&sysfs_mutex);
+	sd = sysfs_find_dirent(parent, name);
+	mutex_unlock(&sysfs_mutex);
+
+	return sd;
+}
+EXPORT_SYMBOL_GPL(sysfs_find_child);
+
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 5646e56..f030dc6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -32,10 +32,19 @@ struct vm_area_struct;
 
 #ifdef CONFIG_SYSFS
 
+struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
+				      const char *name);
+
 int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
+static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
+						    const char *name)
+{
+	return NULL;
+}
+
 static inline int __must_check sysfs_init(void)
 {
 	return 0;
-- 
1.5.0.3


