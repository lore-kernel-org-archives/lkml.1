Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZIGIly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZIGIly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZIGIlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:41:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56536 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZIGIlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:41:53 -0400
To: akpm@linux-foundation.org
CC: Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, miklos@szeredi.hu,
       akpm@linux-foundation.org, matthew@wil.cx, agruen@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, linux-kernel@vger.kernel.org
In-reply-to: <E1MkZk0-00006N-So@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 07 Sep 2009 10:38:24 +0200)
Subject: [patch 2/2] vfs: revert /proc/mounts to old behavior for unreachable mountpoints
References: <2818.1252160549@turing-police.cc.vt.edu> <1252312254.4733.12.camel@tucsk> <E1MkZk0-00006N-So@pomaz-ex.szeredi.hu>
Message-Id: <E1MkZn7-00007W-4B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Sep 2009 10:41:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

"vfs: fix d_path() for unreachable paths" prefixes unreachable paths
with "(unreachable)" in the result of getcwd(2), /proc/*/mounts,
/proc/*/cwd, /proc/*/fd/*, etc...

Hugh Dickins reported that an old version of gnome-vfs-daemon crashes
because it finds an entry in /proc/mounts where the mountpoint is
unreachable.

This patch reverts /proc/mounts to the old behavior (or rather a less
crazy version of the old behavior).

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2009-09-04 15:25:36.000000000 +0200
+++ linux-2.6/fs/namespace.c	2009-09-04 15:40:25.000000000 +0200
@@ -789,6 +789,61 @@ static void show_type(struct seq_file *m
 	}
 }
 
+/*
+ * Same as d_path() except it doesn't stick "(unreachable)" in front
+ * of unreachable paths.
+ */
+static char *d_path_compat(struct path *path, char *buf, int buflen)
+{
+	char *res;
+	struct path root;
+	struct path tmp;
+
+	read_lock(&current->fs->lock);
+	root = current->fs->root;
+	path_get(&root);
+	read_unlock(&current->fs->lock);
+	spin_lock(&dcache_lock);
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
+	if (!IS_ERR(res) &&
+	    (tmp.mnt != root.mnt || tmp.dentry != root.dentry)) {
+		/*
+		 * Unreachable path found, redo with the global root
+		 * so we get a normal looking path.
+		 */
+		res = __d_path(path, &tmp, buf, buflen);
+	}
+	spin_unlock(&dcache_lock);
+	path_put(&root);
+
+	return res;
+}
+
+/*
+ * Some old programs break if /proc/mounts contains a mountpoint
+ * beginning with "(unreachable)".  Revert this back to the old way of
+ * displaying the path from the global root instead.
+ */
+static int show_path_old(struct seq_file *m, struct path *path, char *esc)
+{
+	char *buf;
+	size_t size = seq_get_buf(m, &buf);
+	int res = -1;
+
+	if (size) {
+		char *p = d_path_compat(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+		}
+	}
+	seq_commit(m, res);
+
+	return res;
+}
+
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
@@ -797,7 +852,7 @@ static int show_vfsmnt(struct seq_file *
 
 	mangle(m, mnt->mnt_devname ? mnt->mnt_devname : "none");
 	seq_putc(m, ' ');
-	seq_path(m, &mnt_path, " \t\n\\");
+	show_path_old(m, &mnt_path, " \t\n\\");
 	seq_putc(m, ' ');
 	show_type(m, mnt->mnt_sb);
 	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
