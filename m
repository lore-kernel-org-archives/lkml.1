Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZFLU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZFLU1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZFLU1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:27:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZFLU1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:27:11 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] inotify: inotify_destroy_mark_entry could get called twice
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, viro@ZenIV.linux.org.uk
Date: Fri, 12 Jun 2009 16:26:47 -0400
Message-ID: <20090612202647.11976.87920.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify_destroy_mark_entry could get called twice for the same mark since it
is called directly in inotify_rm_watch and when the mark is being destroyed for
another reason.  As an example assume that the file being watched was just
deleted so inotify_destroy_mark_entry would get called from the path
fsnotify_inoderemove() -> fsnotify_destroy_marks_by_inode() ->
fsnotify_destroy_mark_entry() -> inotify_destroy_mark_entry().  If this
happened at the same time as userspace tried to remove a watch via
inotify_rm_watch we could attempt to remove the mark from the idr twice and
could thus double dec the ref cnt and potentially could be in a use after
free/double free situation.  The fix is to have inotify_rm_watch use the
generic recursive safe fsnotify_destroy_mark_by_entry() so we are sure the
inotify_destroy_mark_entry() function can only be called one.

This patch also renames the function to inotify_ingored_remove_idr() so it is
clear what is actually going on in the function.

Hopefully this fixes:
[   20.342058] idr_remove called for id=20 which is not allocated.
[   20.348000] Pid: 1860, comm: udevd Not tainted 2.6.30-tip #1077
[   20.353933] Call Trace:
[   20.356410]  [<ffffffff811a82b7>] idr_remove+0x115/0x18f
[   20.361737]  [<ffffffff8134259d>] ? _spin_lock+0x6d/0x75
[   20.367061]  [<ffffffff8111640a>] ? inotify_destroy_mark_entry+0xa3/0xcf
[   20.373771]  [<ffffffff8111641e>] inotify_destroy_mark_entry+0xb7/0xcf
[   20.380306]  [<ffffffff81115913>] inotify_freeing_mark+0xe/0x10
[   20.386238]  [<ffffffff8111410d>] fsnotify_destroy_mark_by_entry+0x143/0x170
[   20.393293]  [<ffffffff811163a3>] inotify_destroy_mark_entry+0x3c/0xcf
[   20.399829]  [<ffffffff811164d1>] sys_inotify_rm_watch+0x9b/0xc6
[   20.405850]  [<ffffffff8100bcdb>] system_call_fastpath+0x16/0x1b

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify.h          |    3 ++-
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 fs/notify/inotify/inotify_user.c     |   32 +++++---------------------------
 3 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index ea2605a..f234f3a 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -15,7 +15,8 @@ struct inotify_inode_mark_entry {
 	int wd;
 };
 
-extern void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
+extern void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
+					   struct fsnotify_group *group);
 extern void inotify_free_event_priv(struct fsnotify_event_private_data *event_priv);
 
 extern const struct fsnotify_ops inotify_fsnotify_ops;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 7ef75b8..47cd258 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -81,7 +81,7 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 
 static void inotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
 {
-	inotify_destroy_mark_entry(entry, group);
+	inotify_ignored_and_remove_idr(entry, group);
 }
 
 static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 982a412..ff231ad 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -363,39 +363,17 @@ static int inotify_find_inode(const char __user *dirname, struct path *path, uns
 }
 
 /*
- * When, for whatever reason, inotify is done with a mark (or what used to be a
- * watch) we need to remove that watch from the idr and we need to send IN_IGNORED
- * for the given wd.
- *
- * There is a bit of recursion here.  The loop looks like:
- * 	inotify_destroy_mark_entry -> fsnotify_destroy_mark_by_entry ->
- *	inotify_freeing_mark -> inotify_destory_mark_entry -> restart
- * But the loop is broken in 2 places.  fsnotify_destroy_mark_by_entry sets
- * entry->group = NULL before the call to inotify_freeing_mark, so the if (egroup)
- * test below will not call back to fsnotify again.  But even if that test wasn't
- * there this would still be safe since fsnotify_destroy_mark_by_entry() is
- * safe from recursion.
+ * Send IN_IGNORED for this wd, remove this wd from the idr, and drop the
+ * internal reference help on the mark because it is in the idr.
  */
-void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
+				    struct fsnotify_group *group)
 {
 	struct inotify_inode_mark_entry *ientry;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
-	struct fsnotify_group *egroup;
 	struct idr *idr;
 
-	spin_lock(&entry->lock);
-	egroup = entry->group;
-
-	/* if egroup we aren't really done and something might still send events
-	 * for this inode, on the callback we'll send the IN_IGNORED */
-	if (egroup) {
-		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark_by_entry(entry);
-		return;
-	}
-	spin_unlock(&entry->lock);
-
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
 	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
@@ -699,7 +677,7 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 	fsnotify_get_mark(entry);
 	spin_unlock(&group->inotify_data.idr_lock);
 
-	inotify_destroy_mark_entry(entry, group);
+	fsnotify_destroy_mark_by_entry(entry);
 	fsnotify_put_mark(entry);
 
 out:

