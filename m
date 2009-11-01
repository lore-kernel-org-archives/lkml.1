Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZKAQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZKAQ4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 11:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZKAQ4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 11:56:46 -0500
Received: from kanga.kvack.org ([205.233.56.17]:42980 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZKAQ4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 11:56:43 -0500
Date: Sun, 1 Nov 2009 11:32:31 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sysfs directory scaling: doubly linked list for dirents
Message-ID: <20091101163230.GB7911@kvack.org>
References: <20091101163130.GA7911@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101163130.GA7911@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding/removing large numbers of entries from sysfs directories, one 
hot spot is in the link and unlink operations of sysfs.  When linking a 
new sysfs_dirent into the tree, operation can be significantly sped up by 
starting at the end of the list rather than the beginning.  Unlink is 
improved by using a doubly linked list.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff -u b/fs/sysfs/dir.c b/fs/sysfs/dir.c
--- b/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -43,11 +43,18 @@
 static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
 	struct sysfs_dirent *parent_sd = sd->s_parent;
-	struct sysfs_dirent **pos;
+	struct sysfs_dirent **pos, *prev = NULL;
 	struct rb_node **new, *parent;
 
 	BUG_ON(sd->s_sibling);
 
+	if (parent_sd->s_dir.children_tail &&
+	    parent_sd->s_dir.children_tail->s_ino < sd->s_ino) {
+		prev = parent_sd->s_dir.children_tail;
+		pos = &prev->s_sibling;
+		goto got_it;
+	}
+
 	/* Store directory entries in order by ino.  This allows
 	 * readdir to properly restart without having to add a
 	 * cursor into the s_dir.children list.
@@ -55,8 +62,13 @@
 	for (pos = &parent_sd->s_dir.children; *pos; pos = &(*pos)->s_sibling) {
 		if (sd->s_ino < (*pos)->s_ino)
 			break;
+		prev = *pos;
 	}
+got_it:
+	if (prev == parent_sd->s_dir.children_tail)
+		parent_sd->s_dir.children_tail = sd;
 	sd->s_sibling = *pos;
+	sd->s_sibling_prev = prev;
 	*pos = sd;
 
 	// rb tree insert
@@ -93,17 +105,20 @@
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent **pos;
-
-	for (pos = &sd->s_parent->s_dir.children; *pos;
-	     pos = &(*pos)->s_sibling) {
-		if (*pos == sd) {
-			*pos = sd->s_sibling;
-			sd->s_sibling = NULL;
-			break;
-		}
-	}
+	struct sysfs_dirent **pos, *prev = NULL;
 
+	prev = sd->s_sibling_prev;
+	if (prev)
+		pos = &prev->s_sibling;
+	else
+		pos = &sd->s_parent->s_dir.children;
+	if (sd == sd->s_parent->s_dir.children_tail)
+		sd->s_parent->s_dir.children_tail = prev;
+	*pos = sd->s_sibling;
+	if (sd->s_sibling)
+		sd->s_sibling->s_sibling_prev = prev;
+	
+	sd->s_sibling_prev = NULL;
 	rb_erase(&sd->s_rb_node, &sd->s_parent->s_dir.child_rb_root);
 }
 
diff -u b/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
--- b/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -17,7 +17,9 @@
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
 	/* children list starts here and goes through sd->s_sibling */
+	
 	struct sysfs_dirent	*children;
+	struct sysfs_dirent	*children_tail;
 	struct rb_root		child_rb_root;
 };
 
@@ -54,6 +56,7 @@
 	atomic_t		s_active;
 	struct sysfs_dirent	*s_parent;
 	struct sysfs_dirent	*s_sibling;
+	struct sysfs_dirent	*s_sibling_prev;
 	struct rb_node		s_rb_node;
 	const char		*s_name;
 
