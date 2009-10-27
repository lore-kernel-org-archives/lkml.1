Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZJ0TKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZJ0TKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZJ0TKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665AbZJ0TKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:10:22 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 6/6] dnotify: rename mark_entry to mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:10:25 -0400
Message-ID: <20091027191024.27472.14740.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
References: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nomenclature change.  Used to call things 'entries' but now we just call
them 'marks.'  Do those changes for dnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c |  170 ++++++++++++++++++++++---------------------
 1 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index b202bc5..3efb8b9 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -29,7 +29,7 @@
 int dir_notify_enable __read_mostly = 1;
 
 static struct kmem_cache *dnotify_struct_cache __read_mostly;
-static struct kmem_cache *dnotify_mark_entry_cache __read_mostly;
+static struct kmem_cache *dnotify_mark_cache __read_mostly;
 static struct fsnotify_group *dnotify_group __read_mostly;
 static DEFINE_MUTEX(dnotify_mark_mutex);
 
@@ -38,8 +38,8 @@ static DEFINE_MUTEX(dnotify_mark_mutex);
  * is being watched by dnotify.  If multiple userspace applications are watching
  * the same directory with dnotify their information is chained in dn
  */
-struct dnotify_mark_entry {
-	struct fsnotify_mark fsn_entry;
+struct dnotify_mark {
+	struct fsnotify_mark fsn_mark;
 	struct dnotify_struct *dn;
 };
 
@@ -51,27 +51,27 @@ struct dnotify_mark_entry {
  * it calls the fsnotify function so it can update the set of all events relevant
  * to this inode.
  */
-static void dnotify_recalc_inode_mask(struct fsnotify_mark *entry)
+static void dnotify_recalc_inode_mask(struct fsnotify_mark *fsn_mark)
 {
 	__u32 new_mask, old_mask;
 	struct dnotify_struct *dn;
-	struct dnotify_mark_entry *dnentry  = container_of(entry,
-							   struct dnotify_mark_entry,
-							   fsn_entry);
+	struct dnotify_mark *dn_mark  = container_of(fsn_mark,
+						     struct dnotify_mark,
+						     fsn_mark);
 
-	assert_spin_locked(&entry->lock);
+	assert_spin_locked(&fsn_mark->lock);
 
-	old_mask = entry->mask;
+	old_mask = fsn_mark->mask;
 	new_mask = 0;
-	for (dn = dnentry->dn; dn != NULL; dn = dn->dn_next)
+	for (dn = dn_mark->dn; dn != NULL; dn = dn->dn_next)
 		new_mask |= (dn->dn_mask & ~FS_DN_MULTISHOT);
-	entry->mask = new_mask;
+	fsn_mark->mask = new_mask;
 
 	if (old_mask == new_mask)
 		return;
 
-	if (entry->i.inode)
-		fsnotify_recalc_inode_mask(entry->i.inode);
+	if (fsn_mark->i.inode)
+		fsnotify_recalc_inode_mask(fsn_mark->i.inode);
 }
 
 /*
@@ -85,8 +85,8 @@ static void dnotify_recalc_inode_mask(struct fsnotify_mark *entry)
 static int dnotify_handle_event(struct fsnotify_group *group,
 				struct fsnotify_event *event)
 {
-	struct fsnotify_mark *entry = NULL;
-	struct dnotify_mark_entry *dnentry;
+	struct fsnotify_mark *fsn_mark = NULL;
+	struct dnotify_mark *dn_mark;
 	struct inode *to_tell;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
@@ -96,16 +96,16 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	to_tell = event->to_tell;
 
 	spin_lock(&to_tell->i_lock);
-	entry = fsnotify_find_mark(group, to_tell);
+	fsn_mark = fsnotify_find_mark(group, to_tell);
 	spin_unlock(&to_tell->i_lock);
 
 	/* unlikely since we alreay passed dnotify_should_send_event() */
-	if (unlikely(!entry))
+	if (unlikely(!fsn_mark))
 		return 0;
-	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	spin_lock(&entry->lock);
-	prev = &dnentry->dn;
+	spin_lock(&fsn_mark->lock);
+	prev = &dn_mark->dn;
 	while ((dn = *prev) != NULL) {
 		if ((dn->dn_mask & test_mask) == 0) {
 			prev = &dn->dn_next;
@@ -118,12 +118,12 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 		else {
 			*prev = dn->dn_next;
 			kmem_cache_free(dnotify_struct_cache, dn);
-			dnotify_recalc_inode_mask(entry);
+			dnotify_recalc_inode_mask(fsn_mark);
 		}
 	}
 
-	spin_unlock(&entry->lock);
-	fsnotify_put_mark(entry);
+	spin_unlock(&fsn_mark->lock);
+	fsnotify_put_mark(fsn_mark);
 
 	return 0;
 }
@@ -136,7 +136,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 				      struct inode *inode, struct vfsmount *mnt,
 				      __u32 mask, void *data, int data_type)
 {
-	struct fsnotify_mark *entry;
+	struct fsnotify_mark *fsn_mark;
 	bool send;
 
 	/* !dir_notify_enable should never get here, don't waste time checking
@@ -148,30 +148,30 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 		return false;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
 
 	/* no mark means no dnotify watch */
-	if (!entry)
+	if (!fsn_mark)
 		return false;
 
 	mask = (mask & ~FS_EVENT_ON_CHILD);
-	send = (mask & entry->mask);
+	send = (mask & fsn_mark->mask);
 
-	fsnotify_put_mark(entry); /* matches fsnotify_find_mark */
+	fsnotify_put_mark(fsn_mark); /* matches fsnotify_find_mark */
 
 	return send;
 }
 
-static void dnotify_free_mark(struct fsnotify_mark *entry)
+static void dnotify_free_mark(struct fsnotify_mark *fsn_mark)
 {
-	struct dnotify_mark_entry *dnentry = container_of(entry,
-							  struct dnotify_mark_entry,
-							  fsn_entry);
+	struct dnotify_mark *dn_mark = container_of(fsn_mark,
+						    struct dnotify_mark,
+						    fsn_mark);
 
-	BUG_ON(dnentry->dn);
+	BUG_ON(dn_mark->dn);
 
-	kmem_cache_free(dnotify_mark_entry_cache, dnentry);
+	kmem_cache_free(dnotify_mark_cache, dn_mark);
 }
 
 static struct fsnotify_ops dnotify_fsnotify_ops = {
@@ -191,8 +191,8 @@ static struct fsnotify_ops dnotify_fsnotify_ops = {
  */
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
-	struct fsnotify_mark *entry;
-	struct dnotify_mark_entry *dnentry;
+	struct fsnotify_mark *fsn_mark;
+	struct dnotify_mark *dn_mark;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
@@ -202,37 +202,37 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark(dnotify_group, inode);
+	fsn_mark = fsnotify_find_mark(dnotify_group, inode);
 	spin_unlock(&inode->i_lock);
-	if (!entry)
+	if (!fsn_mark)
 		return;
-	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
 	mutex_lock(&dnotify_mark_mutex);
 
-	spin_lock(&entry->lock);
-	prev = &dnentry->dn;
+	spin_lock(&fsn_mark->lock);
+	prev = &dn_mark->dn;
 	while ((dn = *prev) != NULL) {
 		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
 			*prev = dn->dn_next;
 			kmem_cache_free(dnotify_struct_cache, dn);
-			dnotify_recalc_inode_mask(entry);
+			dnotify_recalc_inode_mask(fsn_mark);
 			break;
 		}
 		prev = &dn->dn_next;
 	}
 
-	spin_unlock(&entry->lock);
+	spin_unlock(&fsn_mark->lock);
 
 	/* nothing else could have found us thanks to the dnotify_mark_mutex */
-	if (dnentry->dn == NULL)
-		fsnotify_destroy_mark(entry);
+	if (dn_mark->dn == NULL)
+		fsnotify_destroy_mark(fsn_mark);
 
 	fsnotify_recalc_group_mask(dnotify_group);
 
 	mutex_unlock(&dnotify_mark_mutex);
 
-	fsnotify_put_mark(entry);
+	fsnotify_put_mark(fsn_mark);
 }
 
 /* this conversion is done only at watch creation */
@@ -264,12 +264,12 @@ static __u32 convert_arg(unsigned long arg)
  * onto that mark.  This function either attaches the new dnotify_struct onto
  * that list, or it |= the mask onto an existing dnofiy_struct.
  */
-static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnentry,
+static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark *dn_mark,
 		     fl_owner_t id, int fd, struct file *filp, __u32 mask)
 {
 	struct dnotify_struct *odn;
 
-	odn = dnentry->dn;
+	odn = dn_mark->dn;
 	while (odn != NULL) {
 		/* adding more events to existing dnofiy_struct? */
 		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
@@ -284,8 +284,8 @@ static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnent
 	dn->dn_fd = fd;
 	dn->dn_filp = filp;
 	dn->dn_owner = id;
-	dn->dn_next = dnentry->dn;
-	dnentry->dn = dn;
+	dn->dn_next = dn_mark->dn;
+	dn_mark->dn = dn;
 
 	return 0;
 }
@@ -297,8 +297,8 @@ static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnent
  */
 int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
-	struct dnotify_mark_entry *new_dnentry, *dnentry;
-	struct fsnotify_mark *new_entry, *entry;
+	struct dnotify_mark *new_dn_mark, *dn_mark;
+	struct fsnotify_mark *new_fsn_mark, *fsn_mark;
 	struct dnotify_struct *dn;
 	struct inode *inode;
 	fl_owner_t id = current->files;
@@ -307,7 +307,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	__u32 mask;
 
 	/* we use these to tell if we need to kfree */
-	new_entry = NULL;
+	new_fsn_mark = NULL;
 	dn = NULL;
 
 	if (!dir_notify_enable) {
@@ -337,8 +337,8 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	}
 
 	/* new fsnotify mark, we expect most fcntl calls to add a new mark */
-	new_dnentry = kmem_cache_alloc(dnotify_mark_entry_cache, GFP_KERNEL);
-	if (!new_dnentry) {
+	new_dn_mark = kmem_cache_alloc(dnotify_mark_cache, GFP_KERNEL);
+	if (!new_dn_mark) {
 		error = -ENOMEM;
 		goto out_err;
 	}
@@ -346,29 +346,29 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	/* convert the userspace DN_* "arg" to the internal FS_* defines in fsnotify */
 	mask = convert_arg(arg);
 
-	/* set up the new_entry and new_dnentry */
-	new_entry = &new_dnentry->fsn_entry;
-	fsnotify_init_mark(new_entry, dnotify_free_mark);
-	new_entry->mask = mask;
-	new_dnentry->dn = NULL;
+	/* set up the new_fsn_mark and new_dn_mark */
+	new_fsn_mark = &new_dn_mark->fsn_mark;
+	fsnotify_init_mark(new_fsn_mark, dnotify_free_mark);
+	new_fsn_mark->mask = mask;
+	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
 	mutex_lock(&dnotify_mark_mutex);
 
-	/* add the new_entry or find an old one. */
+	/* add the new_fsn_mark or find an old one. */
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark(dnotify_group, inode);
+	fsn_mark = fsnotify_find_mark(dnotify_group, inode);
 	spin_unlock(&inode->i_lock);
-	if (entry) {
-		dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
-		spin_lock(&entry->lock);
+	if (fsn_mark) {
+		dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
+		spin_lock(&fsn_mark->lock);
 	} else {
-		fsnotify_add_mark(new_entry, dnotify_group, inode, 0);
-		spin_lock(&new_entry->lock);
-		entry = new_entry;
-		dnentry = new_dnentry;
-		/* we used new_entry, so don't free it */
-		new_entry = NULL;
+		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, 0);
+		spin_lock(&new_fsn_mark->lock);
+		fsn_mark = new_fsn_mark;
+		dn_mark = new_dn_mark;
+		/* we used new_fsn_mark, so don't free it */
+		new_fsn_mark = NULL;
 	}
 
 	rcu_read_lock();
@@ -377,17 +377,17 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	/* if (f != filp) means that we lost a race and another task/thread
 	 * actually closed the fd we are still playing with before we grabbed
-	 * the dnotify_mark_mutex and entry->lock.  Since closing the fd is the
+	 * the dnotify_mark_mutex and fsn_mark->lock.  Since closing the fd is the
 	 * only time we clean up the marks we need to get our mark off
 	 * the list. */
 	if (f != filp) {
 		/* if we added ourselves, shoot ourselves, it's possible that
-		 * the flush actually did shoot this entry.  That's fine too
+		 * the flush actually did shoot this fsn_mark.  That's fine too
 		 * since multiple calls to destroy_mark is perfectly safe, if
-		 * we found a dnentry already attached to the inode, just sod
+		 * we found a dn_mark already attached to the inode, just sod
 		 * off silently as the flush at close time dealt with it.
 		 */
-		if (dnentry == new_dnentry)
+		if (dn_mark == new_dn_mark)
 			destroy = 1;
 		goto out;
 	}
@@ -395,13 +395,13 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
 	if (error) {
 		/* if we added, we must shoot */
-		if (dnentry == new_dnentry)
+		if (dn_mark == new_dn_mark)
 			destroy = 1;
 		goto out;
 	}
 
-	error = attach_dn(dn, dnentry, id, fd, filp, mask);
-	/* !error means that we attached the dn to the dnentry, so don't free it */
+	error = attach_dn(dn, dn_mark, id, fd, filp, mask);
+	/* !error means that we attached the dn to the dn_mark, so don't free it */
 	if (!error)
 		dn = NULL;
 	/* -EEXIST means that we didn't add this new dn and used an old one.
@@ -409,20 +409,20 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	else if (error == -EEXIST)
 		error = 0;
 
-	dnotify_recalc_inode_mask(entry);
+	dnotify_recalc_inode_mask(fsn_mark);
 out:
-	spin_unlock(&entry->lock);
+	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark(entry);
+		fsnotify_destroy_mark(fsn_mark);
 
 	fsnotify_recalc_group_mask(dnotify_group);
 
 	mutex_unlock(&dnotify_mark_mutex);
-	fsnotify_put_mark(entry);
+	fsnotify_put_mark(fsn_mark);
 out_err:
-	if (new_entry)
-		fsnotify_put_mark(new_entry);
+	if (new_fsn_mark)
+		fsnotify_put_mark(new_fsn_mark);
 	if (dn)
 		kmem_cache_free(dnotify_struct_cache, dn);
 	return error;
@@ -431,7 +431,7 @@ out_err:
 static int __init dnotify_init(void)
 {
 	dnotify_struct_cache = KMEM_CACHE(dnotify_struct, SLAB_PANIC);
-	dnotify_mark_entry_cache = KMEM_CACHE(dnotify_mark_entry, SLAB_PANIC);
+	dnotify_mark_cache = KMEM_CACHE(dnotify_mark, SLAB_PANIC);
 
 	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops);
 	if (IS_ERR(dnotify_group))

