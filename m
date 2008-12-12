Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYLLV4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYLLV4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbYLLVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbYLLVwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:40 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 14/14] shit on top for debugging
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:28 -0500
Message-ID: <20081212215228.27112.72672.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 fs/notify/dnotify/dnotify.c          |    6 ++++++
 fs/notify/fsnotify.c                 |    1 +
 fs/notify/group.c                    |   18 ++++++++++++++++++
 fs/notify/inode_mark.c               |   10 ++++++++++
 fs/notify/inotify/inotify_fsnotify.c |    7 +++++++
 fs/notify/inotify/inotify_kernel.c   |    6 ++++++
 fs/notify/inotify/inotify_user.c     |    3 +++
 fs/notify/notification.c             |    2 ++
 include/linux/fsnotify.h             |    1 +
 9 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index dae1bd6..d7f201e 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -66,6 +66,8 @@ static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 	unsigned long new_mask;
 	struct dnotify_struct *dn;
 
+	printk(KERN_CRIT "%s: inode=%p\n", __func__, entry->inode);
+
 	new_mask = 0;
 	dn = (struct dnotify_struct *)entry->private;
 	for (; dn != NULL; dn = dn->dn_next)
@@ -174,6 +176,8 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	if (!entry)
 		return;
 
+	printk(KERN_CRIT "%s: found entry=%p entry->group=%p\n", __func__, entry, entry->group);
+
 	spin_lock(&entry->lock);
 	prev = (struct dnotify_struct **)&entry->private;
 	while ((dn = *prev) != NULL) {
@@ -241,6 +245,8 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	if (!dir_notify_enable)
 		return -EINVAL;
 
+	printk(KERN_CRIT "%s: fd=%d filp=%p arg=%lx\n", __func__, fd, filp, arg);
+
 	if ((arg & ~DN_MULTISHOT) == 0) {
 		dnotify_flush(filp, id);
 		return 0;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index f6973a8..5b0d632 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -65,6 +65,7 @@ void fsnotify(struct inode *to_tell, __u64 mask, void *data, int data_is, const
 		if (mask & group->mask) {
 			if (!group->ops->should_send_event(group, to_tell, mask))
 				continue;
+			printk(KERN_CRIT "%s: to_tell=%p data=%p data_is=%d mask=%llx fsnotify_mask=%llx\n", __func__, to_tell, data, data_is, mask, fsnotify_mask);
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data, data_is, file_name, cookie);
 				/* shit, we OOM'd and now we can't tell, lets hope something else blows up */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index b041e6d..0509443 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -39,12 +39,17 @@ void fsnotify_recalc_global_mask(void)
 	__u64 mask = 0;
 	int idx;
 
+	printk(KERN_CRIT "%s: starting fsnotify_mask=%llx\n", __func__, fsnotify_mask);
+
 	idx = srcu_read_lock(&fsnotify_grp_srcu_struct);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
+		printk(KERN_CRIT "%s: group=%p group->mask=%llx\n", __func__, group, group->mask);
 		mask |= group->mask;
 	}
 	srcu_read_unlock(&fsnotify_grp_srcu_struct, idx);
 	fsnotify_mask = mask;
+
+	printk(KERN_CRIT "%s: ending fsnotify_mask=%llx\n", __func__, fsnotify_mask);
 }
 
 void fsnotify_recalc_group_mask(struct fsnotify_group *group)
@@ -54,13 +59,19 @@ void fsnotify_recalc_group_mask(struct fsnotify_group *group)
 	struct fsnotify_mark_entry *entry;
 
 	spin_lock(&group->mark_lock);
+
+	printk(KERN_CRIT "%s: group=%p starting group->mask=%llx\n", __func__, group, group->mask);
+
 	list_for_each_entry(entry, &group->mark_entries, g_list) {
+		printk(KERN_CRIT "%s: entry=%p entry->mask=%llx\n", __func__, entry, entry->mask);
 		mask |= entry->mask;
 	}
 	spin_unlock(&group->mark_lock);
 
 	group->mask = mask;
 
+	printk(KERN_CRIT "%s: group=%p finishing group->mask=%llx\n", __func__, group, group->mask);
+
 	if (old_mask != mask)
 		fsnotify_recalc_global_mask();
 }
@@ -87,10 +98,14 @@ static void fsnotify_add_group(struct fsnotify_group *group)
 void fsnotify_get_group(struct fsnotify_group *group)
 {
 	atomic_inc(&group->refcnt);
+
+	printk(KERN_CRIT "%s: group=%p refcnt=%d\n", __func__, group, atomic_read(&group->refcnt));
 }
 
 static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
+	printk(KERN_CRIT "%s: group=%p refcnt=%d\n", __func__, group, atomic_read(&group->refcnt));
+
 	/* clear the notification queue of all events */
 	fsnotify_flush_notif(group);
 
@@ -105,6 +120,7 @@ static void fsnotify_destroy_group(struct fsnotify_group *group)
 
 void fsnotify_put_group(struct fsnotify_group *group)
 {
+	printk(KERN_CRIT "%s: group=%p refcnt=%d\n", __func__, group, atomic_read(&group->refcnt));
 	if (atomic_dec_and_test(&group->refcnt)) {
 		mutex_lock(&fsnotify_grp_mutex);
 		list_del_rcu(&group->group_list);
@@ -200,5 +216,7 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
 	if (mask)
 		fsnotify_recalc_global_mask();
 
+	printk(KERN_CRIT "%s: group=%p refcnt=%d\n", __func__, group, atomic_read(&group->refcnt));
+
 	return group;
 }
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 339a368..7c1edf2 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -58,11 +58,13 @@ static struct fsnotify_mark_entry *fsnotify_alloc_mark(void)
 
 void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
 {
+	printk(KERN_CRIT "%s: entry=%p refcnt BEFORE the get=%x\n", __func__, entry, atomic_read(&entry->refcnt));
 	atomic_inc(&entry->refcnt);
 }
 
 void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
 {
+	printk(KERN_CRIT "%s: entry=%p refcnt BEFORE the put=%x\n", __func__, entry, atomic_read(&entry->refcnt));
 	if (atomic_dec_and_test(&entry->refcnt)) {
 		spin_lock(&entry->lock);
 		/* entries can only be found by the kernel by searching the
@@ -95,6 +97,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
 
 	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
 		fsnotify_get_mark(entry);
+		printk(KERN_CRIT "%s: entry=%p entry->inode=%p entry->group=%p\n", __func__, entry, entry->inode, entry->group);
 		spin_lock(&entry->lock);
 		inode = entry->inode;
 		if (!inode) {
@@ -127,6 +130,8 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 
 	spin_lock(&entry->lock);
 
+	printk(KERN_CRIT "%s: entry=%p entry->inode=%p entry->group=%p\n", __func__, entry, entry->inode, entry->group);
+
 	group = entry->group;
 	if (group)
 		spin_lock(&group->mark_lock);
@@ -156,6 +161,9 @@ void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags)
 	struct fsnotify_mark_entry *lentry, *entry;
 	LIST_HEAD(free_list);
 
+	if (!list_empty(&inode->i_fsnotify_mark_entries))
+		printk(KERN_CRIT "%s: inode=%p flags=%d\n", __func__, inode, flags);
+
 	spin_lock(&inode->i_lock);
 	list_for_each_entry_safe(entry, lentry, &inode->i_fsnotify_mark_entries, i_list) {
 		list_del_init(&entry->i_list);
@@ -241,6 +249,8 @@ struct fsnotify_mark_entry *fsnotify_mark_add(struct fsnotify_group *group, stru
 out_unlock:
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&group->mark_lock);
+
+	printk(KERN_CRIT "%s: group=%p inode=%p entry=%p mask=%llx\n", __func__, group, inode, entry, mask);
 	return entry;
 }
 
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 30c0a91..a078472 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -51,6 +51,8 @@ static int inotify_event_to_notif(struct fsnotify_group *group, struct fsnotify_
 	struct inotify_mark_private_data *mark_priv;
 	int wd, ret = 0;
 
+	printk(KERN_CRIT "%s: group=%p event=%p\n", __func__, group, event);
+
 	to_tell = event->to_tell;
 
 	spin_lock(&to_tell->i_lock);
@@ -100,7 +102,10 @@ static void inotify_mark_clear_inode(struct fsnotify_mark_entry *entry, struct i
 	list_add(&entry->i_list, &inode->i_fsnotify_mark_entries);
 	spin_unlock(&inode->i_lock);
 
+	printk(KERN_CRIT "%s: entry=%p inode=%p flags=%d\n", __func__, entry, inode, flags);
+
 	fsnotify(inode, FS_IN_IGNORED, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+
 	inotify_destroy_mark_entry(entry);
 }
 
@@ -162,6 +167,8 @@ static void inotify_free_mark_priv(struct fsnotify_mark_entry *entry)
 	struct inotify_mark_private_data *mark_priv = entry->private;
 	struct inode *inode = mark_priv->inode;
 
+	printk(KERN_CRIT "%s: entry=%p\n", __func__, entry);
+
 	BUG_ON(!entry->private);
 
 	mark_priv = entry->private;
diff --git a/fs/notify/inotify/inotify_kernel.c b/fs/notify/inotify/inotify_kernel.c
index 269fd87..ace0b51 100644
--- a/fs/notify/inotify/inotify_kernel.c
+++ b/fs/notify/inotify/inotify_kernel.c
@@ -56,6 +56,10 @@ int find_inode(const char __user *dirname, struct path *path, unsigned flags)
 {
 	int error;
 
+	char *tmp = getname(dirname);
+	printk(KERN_CRIT "%s: pathname=%s\n", __func__, tmp);
+	putname(tmp);
+
 	error = user_path_at(AT_FDCWD, dirname, flags, path);
 	if (error)
 		return error;
@@ -74,6 +78,8 @@ void inotify_destroy_mark_entry(struct fsnotify_mark_entry *entry)
 	struct idr *idr;
 	int wd;
 
+	printk(KERN_CRIT "%s: entry=%p refct=%d\n", __func__, entry, atomic_read(&entry->refcnt));
+
 	spin_lock(&entry->lock);
 
 	mark_priv = entry->private;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 2df65ff..37cf619 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -202,6 +202,9 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 		__inotify_free_event_priv(priv);
 		spin_unlock(&event->lock);
 
+		printk(KERN_CRIT "%s: event->wd=%d event->mask=%x event->cookie=%d event->len=%d event->file_name=%s\n",
+			__func__, inotify_event.wd, inotify_event.mask, inotify_event.cookie, inotify_event.len, event->file_name);
+
 		if (copy_to_user(buf, &inotify_event, event_size)) {
 			ret = -EFAULT;
 			break;
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 7243b20..631b82f 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -263,6 +263,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 
 	event->mask = mask;
 
+	printk(KERN_CRIT "%s: event=%p event->to_tell=%p event->data=%p event->flag=%d event->file=%s\n", __func__, event, event->to_tell, event->inode, event->flag, event->file_name);
+
 	return event;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 3d10004..763a2b1 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -96,6 +96,7 @@ static inline void fsnotify_parent(struct dentry *dentry, __u64 orig_mask)
 	p_inode = parent->d_inode;
 
 	if (p_inode && (p_inode->i_fsnotify_mask & mask)) {
+		printk(KERN_CRIT "%s: dentry=%p orig_mask=%llx mask=%llx parent=%p parent->inode=%p p_inode->i_fsnotify_mask=%llx\n", __func__, dentry, orig_mask, mask, parent, p_inode, p_inode->i_fsnotify_mask);
 		dget(parent);
 		spin_unlock(&dentry->d_lock);
 		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE, dentry->d_name.name, 0);

