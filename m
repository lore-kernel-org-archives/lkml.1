Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYIZVUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYIZVUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYIZVTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48400 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbYIZVTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:10 -0400
Subject: [RFC 6/11] fanotify: add group priorities
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:04 -0400
Message-Id: <1222463944.2872.217.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: add group priorities

From: Eric Paris <eparis@redhat.com>

In preperation for blocking fanotify calls group priorities must be added.
async events will be sent as quickly as possible without waiting for a
response.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h   |    5 +++--
 fs/notify/group.c      |   36 +++++++++++++++++++++++++++++++-----
 fs/notify/group_user.c |   14 ++++++++------
 fs/notify/info_user.c  |    2 +-
 4 files changed, 43 insertions(+), 14 deletions(-)


diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 2a00668..12fb8d3 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -25,6 +25,7 @@ struct fanotify_group {
 	struct mutex fastpath_mutex;	/* protect fastpath_entries list */
 	struct list_head fastpath_entries; /* all fastpath entries for this group */
 
+	unsigned int priority;		/* order this group should receive msgs.  low first */
 	char *name;			/* group name used for register/unregister matching */
 	struct dentry *subdir;		/* pointer to fanotify/name dentry */
 	struct dentry *notification;	/* pointer to fanotify/name/notification dentry */
@@ -129,6 +130,6 @@ extern __init int fastpath_uninit(void);
 
 extern void fanotify_get_group(struct fanotify_group *group);
 extern void fanotify_put_group(struct fanotify_group *group);
-extern int fanotify_register_group(char *name, unsigned int mask);
-extern int fanotify_unregister_group(char *name, unsigned int mask);
+extern int fanotify_register_group(char *name, unsigned int priority, unsigned int mask);
+extern int fanotify_unregister_group(char *name, unsigned int priority, unsigned int mask);
 #endif	/* _LINUX_FANOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index dc23127..81563ad 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -71,7 +71,7 @@ void fanotify_put_group(struct fanotify_group *group)
 	return;
 }
 
-int fanotify_register_group(char *name, unsigned int mask)
+int fanotify_register_group(char *name, unsigned int priority, unsigned int mask)
 {
 	struct dentry *subdir;
 	struct fanotify_group *group, *group_iter;
@@ -82,6 +82,10 @@ int fanotify_register_group(char *name, unsigned int mask)
 		if (!strcmp(name, group_iter->name)) {
 			mutex_unlock(&groups_mutex);
 			return -EEXIST;
+		} else if (group_iter->priority == priority) {
+			/* don't allow 2 groups with same priority */
+			mutex_unlock(&groups_mutex);
+			return -EINVAL;
 		}
 	}
 
@@ -96,6 +100,7 @@ int fanotify_register_group(char *name, unsigned int mask)
 	atomic_set(&group->num_clients, 0);
 
 	group->mask = mask;
+	group->priority = priority;
 
 	/* create sub-directory for this group. */
 	subdir = securityfs_create_dir(name, fanotify_fs_root);
@@ -118,8 +123,27 @@ int fanotify_register_group(char *name, unsigned int mask)
 	if (rc)
 		goto out_clean_info;
 
-	/* add it */
-	list_add_rcu(&group->group_list, &groups);
+	/* Do we need to be the first entry? */
+	if (list_empty(&groups)) {
+		list_add_rcu(&group->group_list, &groups);
+		mutex_unlock(&groups_mutex);
+		return 0;
+	}
+
+	list_for_each_entry(group_iter, &groups, group_list) {
+		/* insert in front of this one? */
+		if (priority < group_iter->priority) {
+			/* I used list_add_tail() to insert in front of group_iter...  */
+			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
+			break;
+		}
+
+		/* are we at the end?  if so insert at end */
+		if (list_is_last(&group_iter->group_list, &groups)) {
+			list_add_tail_rcu(&group->group_list, &groups);
+			break;
+		}
+	}
 	mutex_unlock(&groups_mutex);
 
 	return 0;
@@ -138,14 +162,16 @@ out:
 	return rc;
 }
 
-int fanotify_unregister_group(char *name, unsigned int mask)
+int fanotify_unregister_group(char *name, unsigned int priority, unsigned int mask)
 {
 	int found = 0;
 	struct fanotify_group *group;
 
 	mutex_lock(&groups_mutex);
 	list_for_each_entry_rcu(group, &groups, group_list) {
-		if (!strcmp(group->name, name) && (group->mask == mask)) {
+		if (!strcmp(group->name, name) &&
+		    (group->mask == mask) &&
+		    (group->priority == priority)) {
 			found = 1;
 			break;
 		}
diff --git a/fs/notify/group_user.c b/fs/notify/group_user.c
index 49ba712..a8663c1 100644
--- a/fs/notify/group_user.c
+++ b/fs/notify/group_user.c
@@ -45,6 +45,7 @@ static ssize_t fanotify_register_write(struct file *file, const char __user *buf
 	char *p;
 	char *group_name;
 	unsigned int mask;
+	unsigned int priority;
 	int rc = 0;
 
 	p = simple_transaction_get(file, buf, lenp);
@@ -57,15 +58,15 @@ static ssize_t fanotify_register_write(struct file *file, const char __user *buf
 		goto out;
 	}
 
-	rc = sscanf(p, "%s %x\n", group_name, &mask);
-	if (rc != 2) {
+	rc = sscanf(p, "%s %u %x\n", group_name, &priority, &mask);
+	if (rc != 3) {
 		if (rc >= 0)
 			rc = -EPROTO;
 		goto out;
 	}
 
 	// FIXME do mask validation
-	rc = fanotify_register_group(group_name, mask);
+	rc = fanotify_register_group(group_name, priority, mask);
 	if (rc)
 		goto out;
 
@@ -81,6 +82,7 @@ static ssize_t fanotify_unregister_write(struct file *file, const char __user *b
 	char *p;
 	char *group_name;
 	unsigned int mask;
+	unsigned int priority;
 	int rc = 0;
 
 	group_name = kzalloc(lenp, GFP_KERNEL);
@@ -93,14 +95,14 @@ static ssize_t fanotify_unregister_write(struct file *file, const char __user *b
 		goto out;
 	}
 
-	rc = sscanf(p, "%s %x\n", group_name, &mask);
-	if (rc != 2) {
+	rc = sscanf(p, "%s %u %x\n", group_name, &priority, &mask);
+	if (rc != 3) {
 		if (rc >= 0)
 			rc = -EPROTO;
 		goto out;
 	}
 
-	rc = fanotify_unregister_group(group_name, mask);
+	rc = fanotify_unregister_group(group_name, priority, mask);
 	if (rc)
 		goto out;
 
diff --git a/fs/notify/info_user.c b/fs/notify/info_user.c
index 21a4465..6402e2d 100644
--- a/fs/notify/info_user.c
+++ b/fs/notify/info_user.c
@@ -48,7 +48,7 @@ static ssize_t fanotify_info_read(struct file *file, char __user *buf, size_t le
 		return -ENOMEM;
 
 	/* Build metadata string to send to the listener */
-	len = snprintf(output, PAGE_SIZE, "%s %x\n", group->name, group->mask);
+	len = snprintf(output, PAGE_SIZE, "%s %u %x\n", group->name, group->priority, group->mask);
 	if (len < 0)
 		goto out;
 	len = simple_read_from_buffer(buf, lenp, offset, output, len);


