Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYFRRKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYFRRKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYFRRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:09:25 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60065 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbYFRRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:09:10 -0400
Message-Id: <20080618170730.556230532@theryb.frec.bull.fr>
References: <20080618170729.808539948@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Wed, 18 Jun 2008 19:07:59 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 03/11] sysfs: Implement __sysfs_get_dentry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs: Implement __sysfs_get_dentry

This function is similar but much simpler to sysfs_get_dentry
returns a sysfs dentry if one curently exists.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
---
 fs/sysfs/dir.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: linux-mm/fs/sysfs/dir.c
===================================================================
--- linux-mm.orig/fs/sysfs/dir.c
+++ linux-mm/fs/sysfs/dir.c
@@ -764,6 +764,45 @@ void sysfs_remove_dir(struct kobject * k
 	__sysfs_remove_dir(sd);
 }
 
+/**
+ *	__sysfs_get_dentry - get dentry for the given sysfs_dirent
+ *	@sb: superblock of the dentry to return
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Get dentry for @sd.  Only return a dentry if one currently
+ *	exists.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	Pointer to found dentry on success, NULL on failure.
+ */
+static struct dentry *__sysfs_get_dentry(struct super_block *sb,
+					 struct sysfs_dirent *sd)
+{
+	struct inode *inode;
+	struct dentry *dentry = NULL;
+
+	inode = ilookup5_nowait(sysfs_sb, sd->s_ino, sysfs_ilookup_test, sd);
+	if (inode && !(inode->i_state & I_NEW)) {
+		struct dentry *alias;
+		spin_lock(&dcache_lock);
+		list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+			if (!IS_ROOT(alias) && d_unhashed(alias))
+				continue;
+			if (alias->d_sb != sb)
+				continue;
+			dentry = alias;
+			dget_locked(dentry);
+			break;
+		}
+		spin_unlock(&dcache_lock);
+	}
+	iput(inode);
+	return dentry;
+}
+
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
 	struct sysfs_dirent *sd = kobj->sd;

-- 
