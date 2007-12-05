Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbXLEOeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbXLEOeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXLEOeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:34:31 -0500
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:62876 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267AbXLEOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:34:30 -0500
Date: Wed, 5 Dec 2007 17:35:18 +0300
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, marcus@better.se, containers@lists.osdl.org,
       devel@openvz.org, linux-kernel@vger.kernel.org, den@openvz.org
Subject: [PATCH] lost content of /proc/sys/fs/binfmt_misc
Message-ID: <20071205143518.GA24886@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/sys/fs/binfmt_misc dentry disappeared during d_revalidate.
d_revalidate only dentries from shadowed one and below.
http://bugzilla.kernel.org/show_bug.cgi?id=9504

CC: Eric W. Biederman <ebiederm@xmission.com>
CC: Marcus Better <marcus@better.se>
Signed-off-by: Denis V. Lunev <den@openvz.org>

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 5fccfe2..1497ac4 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -380,12 +380,17 @@ static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
 	return 0;
 }
 
-static struct dentry_operations proc_dentry_operations =
+static struct dentry_operations proc_dentry_shadow_operations =
 {
 	.d_delete	= proc_delete_dentry,
 	.d_revalidate	= proc_revalidate_dentry,
 };
 
+static struct dentry_operations proc_dentry_operations =
+{
+	.d_delete	= proc_delete_dentry,
+};
+
 /*
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
@@ -394,6 +399,7 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 {
 	struct inode *inode = NULL;
 	struct proc_dir_entry * de;
+	int use_shadow = 0;
 	int error = -ENOENT;
 
 	lock_kernel();
@@ -406,8 +412,10 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 				unsigned int ino;
 
-				if (de->shadow_proc)
+				if (de->shadow_proc) {
 					de = de->shadow_proc(current, de);
+					use_shadow = 1;
+				}
 				ino = de->low_ino;
 				de_get(de);
 				spin_unlock(&proc_subdir_lock);
@@ -423,6 +431,8 @@ struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nam
 
 	if (inode) {
 		dentry->d_op = &proc_dentry_operations;
+		dentry->d_op = use_shadow ?
+			&proc_dentry_shadow_operations : dentry->d_parent->d_op;
 		d_add(dentry, inode);
 		return NULL;
 	}
