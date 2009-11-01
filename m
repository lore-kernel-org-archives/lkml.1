Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZKAQ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZKAQ4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 11:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZKAQ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 11:56:44 -0500
Received: from kanga.kvack.org ([205.233.56.17]:42979 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbZKAQ4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 11:56:43 -0500
X-Greylist: delayed 1517 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Nov 2009 11:56:43 EST
Date: Sun, 1 Nov 2009 11:33:09 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sysfs directory scaling: count number of children dirs
Message-ID: <20091101163309.GC7911@kvack.org>
References: <20091101163130.GA7911@kvack.org> <20091101163230.GB7911@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101163230.GB7911@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_count_nlink() is a bottleneck during mass bring up of network 
interfaces.  Eliminate this problem by tracking the number of directories.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff -u b/fs/sysfs/dir.c b/fs/sysfs/dir.c
--- b/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -70,6 +70,7 @@
 	sd->s_sibling = *pos;
 	sd->s_sibling_prev = prev;
 	*pos = sd;
+	parent_sd->s_nr_children_dir += (sysfs_type(sd) == SYSFS_DIR);
 
 	// rb tree insert
 	new = &(parent_sd->s_dir.child_rb_root.rb_node);
@@ -118,6 +119,7 @@
 	if (sd->s_sibling)
 		sd->s_sibling->s_sibling_prev = prev;
 	
+	sd->s_parent->s_nr_children_dir -= (sysfs_type(sd) == SYSFS_DIR);
 	sd->s_sibling_prev = NULL;
 	rb_erase(&sd->s_rb_node, &sd->s_parent->s_dir.child_rb_root);
 }
diff -u b/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
--- b/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -71,6 +71,8 @@
 	ino_t			s_ino;
 	umode_t			s_mode;
 	struct sysfs_inode_attrs *s_iattr;
+
+	int			s_nr_children_dir;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
only in patch2:
unchanged:
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -191,14 +191,7 @@ static struct lock_class_key sysfs_inode_imutex_key;
 
 static int sysfs_count_nlink(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent *child;
-	int nr = 0;
-
-	for (child = sd->s_dir.children; child; child = child->s_sibling)
-		if (sysfs_type(child) == SYSFS_DIR)
-			nr++;
-
-	return nr + 2;
+	return sd->s_nr_children_dir + 2;
 }
 
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
