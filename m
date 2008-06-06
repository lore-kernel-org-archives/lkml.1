Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbYFFPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbYFFPur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759805AbYFFPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:49:06 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38865 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbYFFPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:49:04 -0400
Message-Id: <20080606154655.690660081@theryb.frec.bull.fr>
References: <20080606154654.356185262@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 17:48:24 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 09/11] sysfs: add sysfs_ns_exit routine
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs routine sysfs_ns_exit() to allow a namespace to go away while
sysfs is still mounted. 

The exiting namespace calls this routine and pass it a callback to be 
called for every sysfs superblocks present. The callback contains the 
necessary code to clean the superblock tag data associated with this 
namespace.

Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 fs/sysfs/mount.c      |   21 +++++++++++++++++++++
 include/linux/sysfs.h |    8 ++++++++
 2 files changed, 29 insertions(+)

Index: linux-mm/fs/sysfs/mount.c
===================================================================
--- linux-mm.orig/fs/sysfs/mount.c
+++ linux-mm/fs/sysfs/mount.c
@@ -181,6 +181,27 @@ restart:
 	spin_unlock(&sb_lock);
 }
 
+/* Clean sysfs tags related to a given namespace when it exits */
+void sysfs_ns_exit(void (*func)(struct sysfs_tag_info *, void *), void *data)
+{
+	/* Allow the namespace to go away while sysfs is still mounted. */
+	struct super_block *sb;
+	mutex_lock(&sysfs_rename_mutex);
+	sysfs_grab_supers();
+	mutex_lock(&sysfs_mutex);
+	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
+
+		struct sysfs_super_info *info = sysfs_info(sb);
+		/* Call the cleaning routine provided by the namespace.
+		 * data is the current namespace id passed by the namespace.
+		 */
+		func(&info->tag, data);
+	}
+	mutex_unlock(&sysfs_mutex);
+	sysfs_release_supers();
+	mutex_unlock(&sysfs_rename_mutex);
+}
+
 int __init sysfs_init(void)
 {
 	int err = -ENOMEM;
Index: linux-mm/include/linux/sysfs.h
===================================================================
--- linux-mm.orig/include/linux/sysfs.h
+++ linux-mm/include/linux/sysfs.h
@@ -134,6 +134,9 @@ void sysfs_printk_last_file(void);
 int sysfs_enable_tagging(struct kobject *kobj,
 			 const struct sysfs_tagged_dir_operations *tag_ops);
 
+void sysfs_ns_exit(void (*func)(struct sysfs_tag_info *, void *),
+		   void *data);
+
 extern int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
@@ -247,6 +250,11 @@ static inline int sysfs_enable_tagging(s
 	return 0;
 }
 
+static inline void sysfs_ns_exit(void (*func)(struct sysfs_tag_info *, void *),
+				 void *data)
+{
+}
+
 static inline int __must_check sysfs_init(void)
 {
 	return 0;

-- 
