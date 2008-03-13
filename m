Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYCMV2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYCMV2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYCMV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:27:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51622 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYCMV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:49 -0400
Message-Id: <20080313212737.053993902@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:45 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/6] vfs: mountinfo show dominating group id
Content-Disposition: inline; filename=mountinfo_dominator_id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Show peer group ID of nearest dominating group that has intersection
with the mount's namespace.

See the the documentation update for details.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/proc.txt |   11 ++++++++---
 fs/namespace.c                     |   24 ++++++++++++++++--------
 fs/pnode.c                         |   32 ++++++++++++++++++++++++++++++++
 fs/pnode.h                         |    1 +
 4 files changed, 57 insertions(+), 11 deletions(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-13 20:45:50.000000000 +0100
+++ linux/fs/namespace.c	2008-03-13 20:45:51.000000000 +0100
@@ -798,16 +798,24 @@ static int show_mountinfo(struct seq_fil
 	show_sb_opts(m, sb);
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);
-	if (IS_MNT_SHARED(mnt)) {
-		seq_printf(m, " shared:%i", get_peer_group_id(mnt));
-		if (IS_MNT_SLAVE(mnt))
-			seq_printf(m, ",slave:%i", get_master_id(mnt));
-	} else if (IS_MNT_SLAVE(mnt)) {
-		seq_printf(m, " slave:%i", get_master_id(mnt));
+	seq_putc(m, ' ');
+	if (IS_MNT_SHARED(mnt) || IS_MNT_SLAVE(mnt)) {
+		if (IS_MNT_SHARED(mnt))
+			seq_printf(m, "shared:%i", get_peer_group_id(mnt));
+		if (IS_MNT_SLAVE(mnt)) {
+			int dominator_id = get_dominator_id_same_ns(mnt);
+
+			if (IS_MNT_SHARED(mnt))
+				seq_putc(m, ',');
+
+			seq_printf(m, "slave:%i", get_master_id(mnt));
+			if (dominator_id != -1)
+				seq_printf(m, ":%i", dominator_id);
+		}
 	} else if (IS_MNT_UNBINDABLE(mnt)) {
-		seq_printf(m, " unbindable");
+		seq_printf(m, "unbindable");
 	} else {
-		seq_printf(m, " private");
+		seq_printf(m, "private");
 	}
 	seq_putc(m, '\n');
 	return err;
Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-03-13 20:45:50.000000000 +0100
+++ linux/fs/pnode.c	2008-03-13 20:45:51.000000000 +0100
@@ -88,6 +88,38 @@ int get_master_id(struct vfsmount *mnt)
 	return id;
 }
 
+static struct vfsmount *get_peer_in_ns(struct vfsmount *mnt,
+				       struct mnt_namespace *ns)
+{
+	struct vfsmount *m = mnt;
+
+	do {
+		if (m->mnt_ns == ns)
+			return m;
+		m = next_peer(m);
+	} while (m != mnt);
+
+	return NULL;
+}
+
+int get_dominator_id_same_ns(struct vfsmount *mnt)
+{
+	int id = -1;
+	struct vfsmount *m;
+
+	spin_lock(&vfsmount_lock);
+	for (m = mnt->mnt_master; m != NULL; m = m->mnt_master) {
+		struct vfsmount *d = get_peer_in_ns(m, mnt->mnt_ns);
+		if (d) {
+			id = d->mnt_pgid;
+			break;
+		}
+	}
+	spin_unlock(&vfsmount_lock);
+
+	return id;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-03-13 20:45:50.000000000 +0100
+++ linux/fs/pnode.h	2008-03-13 20:45:51.000000000 +0100
@@ -33,4 +33,5 @@ int propagate_umount(struct list_head *)
 int propagate_mount_busy(struct vfsmount *, int);
 int get_peer_group_id(struct vfsmount *);
 int get_master_id(struct vfsmount *);
+int get_dominator_id_same_ns(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2008-03-13 20:45:50.000000000 +0100
+++ linux/Documentation/filesystems/proc.txt	2008-03-13 20:45:51.000000000 +0100
@@ -2367,15 +2367,20 @@ MNTOPTS: per mount options
 SBOPTS: per super block options
 PROPAGATION: propagation type
 
-propagation type: <propagation_flag>[:<peergrpid>][,...]
+propagation type: <propagation_flag>[:<peergrpid>[:<domgrpid>]][,...]
 	note: 'shared' flag is followed by the id of this mount's peer group
-	      'slave' flag is followed by the peer group id of its master mount
+	      'slave' flag is followed by the peer group id of its master mount,
+	      	      optionally followed by the id of the closest dominant(*)
+		      peer group in the same namespace, if one exists.
 	      'private' flag stands by itself
 	      'unbindable' flag stands by itself
 
+(*) A dominant peer group is an ancestor of this mount in the
+propagation tree, in other words, this mount receives propagation from
+the dominant peer group, but not the other way round.
+
 For more information see:
 
   Documentation/filesystems/sharedsubtree.txt
 
-
 ------------------------------------------------------------------------------

--
