Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZHXRjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZHXRjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZHXRjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:39:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbZHXRi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:38:59 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] inotify: fix locking around inotify watching in the idr
To: linux-kernel@vger.kernel.org, linux-fs-devel@vger.kernel.org
Cc: zdenek.kabelac@gmail.com, torvalds@linux-foundation.org,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk, mikko.cal@gmail.com
Date: Mon, 24 Aug 2009 13:38:21 -0400
Message-ID: <20090824173821.14196.80746.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The are races around the idr storage of inotify watches.  It's possible
that a watch could be found from sys_inotify_rm_watch() in the idr, but it
could be removed from the idr before that code does it's removal.  Move the
locking and the refcnt'ing so that these have to happen atomically.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |   51 +++++++++++++++++++++++++++++++-------
 1 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index d8f73c2..c0ed0aa 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -364,20 +364,54 @@ static int inotify_find_inode(const char __user *dirname, struct path *path, uns
 	return error;
 }
 
+/*
+ * Remove the mark from the idr (if present) and drop the reference
+ * on the mark because it was in the idr.
+ */
 static void inotify_remove_from_idr(struct fsnotify_group *group,
 				    struct inotify_inode_mark_entry *ientry)
 {
 	struct idr *idr;
+	struct fsnotify_mark_entry *entry;
+	struct inotify_inode_mark_entry *found_ientry;
+	int wd;
 
 	spin_lock(&group->inotify_data.idr_lock);
 	idr = &group->inotify_data.idr;
-	idr_remove(idr, ientry->wd);
-	spin_unlock(&group->inotify_data.idr_lock);
+	wd = ientry->wd;
+
+	if (wd == -1)
+		goto out;
+
+	entry = idr_find(&group->inotify_data.idr, wd);
+	if (unlikely(!entry))
+		goto out;
+
+	found_ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	if (unlikely(found_ientry != ientry)) {
+		/* We found an entry in the idr with the right wd, but it's
+		 * not the entry we were told to remove.  eparis seriously
+		 * fucked up somewhere. */
+		WARN_ON(1);
+		ientry->wd = -1;
+		goto out;
+	}
+
+	/* There better be at least one ref for being in the idr and one
+	 * reference from whatever called us. */
+	BUG_ON(atomic_read(&entry->refcnt) < 2);
+
+	idr_remove(idr, wd);
 	ientry->wd = -1;
+
+	/* removed from the idr, drop that ref */
+	fsnotify_put_mark(entry);
+out:
+	spin_unlock(&group->inotify_data.idr_lock);
 }
+
 /*
- * Send IN_IGNORED for this wd, remove this wd from the idr, and drop the
- * internal reference help on the mark because it is in the idr.
+ * Send IN_IGNORED for this wd, remove this wd from the idr.
  */
 void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 				    struct fsnotify_group *group)
@@ -417,9 +451,6 @@ skip_send_ignore:
 	/* remove this entry from the idr */
 	inotify_remove_from_idr(group, ientry);
 
-	/* removed from idr, drop that reference */
-	fsnotify_put_mark(entry);
-
 	atomic_dec(&group->inotify_data.user->inotify_watches);
 }
 
@@ -535,6 +566,9 @@ retry:
 		goto out_err;
 	}
 
+	/* we put the mark on the idr, take a reference */
+	fsnotify_get_mark(&tmp_ientry->fsn_entry);
+
 	/* we are on the idr, now get on the inode */
 	ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode);
 	if (ret) {
@@ -543,9 +577,6 @@ retry:
 		goto out_err;
 	}
 
-	/* we put the mark on the idr, take a reference */
-	fsnotify_get_mark(&tmp_ientry->fsn_entry);
-
 	/* update the idr hint, who cares about races, it's just a hint */
 	group->inotify_data.last_wd = tmp_ientry->wd;
 

