Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbZEFWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbZEFWLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761555AbZEFVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:59 -0400
Received: from kroah.org ([198.145.64.141]:57266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761162AbZEFVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:00 2009
Message-Id: <20090506214800.542670611@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 38/58] Get rid of bumping fs_struct refcount in pivot_root(2)
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=get-rid-of-bumping-fs_struct-refcount-in-pivot_root.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit f8ef3ed2bebd2c4cb9ece92efa185d7aead8831a upstream.

Not because execve races with _that_ are serious - we really
need a situation when final drop of fs_struct refcount is
done by something that used to have it as current->fs.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2127,25 +2127,33 @@ static void chroot_fs_refs(struct path *
 {
 	struct task_struct *g, *p;
 	struct fs_struct *fs;
+	int count = 0;
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
-			atomic_inc(&fs->count);
-			task_unlock(p);
+			write_lock(&fs->lock);
 			if (fs->root.dentry == old_root->dentry
-			    && fs->root.mnt == old_root->mnt)
-				set_fs_root(fs, new_root);
+			    && fs->root.mnt == old_root->mnt) {
+				path_get(new_root);
+				fs->root = *new_root;
+				count++;
+			}
 			if (fs->pwd.dentry == old_root->dentry
-			    && fs->pwd.mnt == old_root->mnt)
-				set_fs_pwd(fs, new_root);
-			put_fs_struct(fs);
-		} else
-			task_unlock(p);
+			    && fs->pwd.mnt == old_root->mnt) {
+				path_get(new_root);
+				fs->pwd = *new_root;
+				count++;
+			}
+			write_unlock(&fs->lock);
+		}
+		task_unlock(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
+	while (count--)
+		path_put(old_root);
 }
 
 /*


