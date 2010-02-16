Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab0BPWpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:45:36 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38784 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab0BPWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:45:32 -0500
From: Serge Hallyn <serue@us.ibm.com>
To: serue@us.ibm.com
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: [PATCH 5/8] p9auth cleanup
Date: Tue, 16 Feb 2010 16:44:58 -0600
Message-Id: <1266360301-30081-5-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Move the code doing the actual uid change into its own helper
function.  Next it will become a bit more complicated when I
add primary and auxiliary groups handling.

Split the handling of /dev/capuse and /dev/caphash writes into
their own functions.

Changelog:
	Jan 3: fix memory leak in error case

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
Cc: Ron Minnich <rminnich@gmail.com>
---
 drivers/staging/p9auth/p9auth.c |  308 +++++++++++++++++++++------------------
 1 files changed, 168 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index fb27459..50447d4 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -165,26 +165,180 @@ static int cap_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+struct id_set {
+	char *source_user, *target_user;
+	char *randstr;
+	uid_t old_uid, new_uid;
+	char *full;  /* The full entry which must be freed */
+};
+
+/*
+ * read an entry.  For now it is
+ * source_user@target_user@rand
+ * Next it will become
+ * source_user@target_user@target_group@numgroups@grp1..@grpn@rand
+ */
+static int parse_user_capability(char *s, struct id_set *set)
+{
+	char *tmpu;
+
+	/*
+	 * break the supplied string into tokens with @ as the
+	 * delimiter If the string is "user1@user2@randomstring" we
+	 * need to split it and hash 'user1@user2' using 'randomstring'
+	 * as the key.
+	 */
+	tmpu = set->full = kstrdup(s, GFP_KERNEL);
+	if (!tmpu)
+		return -ENOMEM;
+
+	set->source_user = strsep(&tmpu, "@");
+	set->target_user = strsep(&tmpu, "@");
+	set->randstr = tmpu;
+	if (!set->source_user || !set->target_user || !set->randstr) {
+		kfree(set->full);
+		return -EINVAL;
+	}
+
+	set->new_uid = simple_strtoul(set->target_user, NULL, 0);
+	set->old_uid = simple_strtoul(set->source_user, NULL, 0);
+
+	return 0;
+}
+
+static int grant_id(struct id_set *set)
+{
+	struct cred *new;
+	int ret;
+
+	/*
+	 * Check whether the process writing to capuse
+	 * is actually owned by the source owner
+	 */
+	if (set->old_uid != current_uid()) {
+		printk(KERN_ALERT
+		       "Process is not owned by the source user of the capability.\n");
+		return -EFAULT;
+	}
+
+	/*
+	 * Change uid, euid, and fsuid.  The suid remains for
+	 * flexibility - though I'm torn as to the tradeoff of
+	 * usefulness vs. danger in that.
+	 */
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = cred_setresuid(new, set->new_uid, set->new_uid, set->new_uid,
+			     CRED_SETID_FORCE);
+	if (ret == 0)
+		commit_creds(new);
+	else
+		abort_creds(new);
+
+	return ret;
+}
+
+static int add_caphash_entry(struct cap_dev *dev, char *user_buf, size_t count)
+{
+	struct cap_node *node_ptr;
+
+	if (count > CAP_NODE_SIZE)
+		return -EINVAL;
+	if (!capable(CAP_GRANT_ID))
+		return -EPERM;
+	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
+	if (!node_ptr)
+		return -ENOMEM;
+
+	printk(KERN_INFO "Capability being written to /dev/caphash : \n");
+	hexdump(user_buf, count);
+	memcpy(node_ptr->data, user_buf, count);
+	list_add(&(node_ptr->list), &(dev->head->list));
+
+	return 0;
+}
+
+static int use_caphash_entry(struct cap_dev *dev, char *user_buf)
+{
+	struct cap_node *node;
+	struct id_set set;
+	int ret, len, found = 0;
+	char *tohash, *hashed;
+	struct list_head *pos;
+
+	if (!cap_devices[0].head)
+		return -EINVAL;
+	if (list_empty(&(cap_devices[0].head->list)))
+		return -EINVAL;
+
+	ret = parse_user_capability(user_buf, &set);
+	if (ret)
+		return ret;
+
+	/* hash the string user1@user2 with randstr as the key */
+	len = strlen(set.source_user) + strlen(set.target_user) + 1;
+	/* src, @, len, \0 */
+	tohash = kzalloc(len+1, GFP_KERNEL);
+	if (!tohash) {
+		kfree(set.full);
+		return -ENOMEM;
+	}
+	strcat(tohash, set.source_user);
+	strcat(tohash, "@");
+	strcat(tohash, set.target_user);
+	printk(KERN_ALERT "the source user is %s \n", set.source_user);
+	printk(KERN_ALERT "the target user is %s \n", set.target_user);
+	hashed = cap_hash(tohash, len, set.randstr, strlen(set.randstr));
+	kfree(set.full);
+	kfree(tohash);
+	if (NULL == hashed)
+		return -EFAULT;
+
+	/* Change the process's uid if the hash is present in the
+	 * list of hashes
+	 */
+	list_for_each(pos, &(cap_devices->head->list)) {
+		/*
+		 * Change the user id of the process if the hashes
+		 * match
+		 */
+		node = list_entry(pos, struct cap_node, list);
+		if (0 == memcmp(hashed, node->data, CAP_NODE_SIZE)) {
+			ret = grant_id(&set);
+			if (ret < 0)
+				goto out;
+
+			/* Capability may only be used once */
+			list_del(pos);
+			kfree(node);
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		printk(KERN_ALERT
+		       "Invalid capabiliy written to /dev/capuse\n");
+		ret = -EFAULT;
+	}
+out:
+	kfree(hashed);
+	return ret;
+}
+
 static ssize_t cap_write(struct file *filp, const char __user *buf,
 			 size_t count, loff_t *f_pos)
 {
-	struct cap_node *node_ptr, *tmp;
-	struct list_head *pos;
 	struct cap_dev *dev = filp->private_data;
 	ssize_t retval = -ENOMEM;
-	struct cred *new;
-	int len, target_int, source_int, flag = 0;
-	char *user_buf, *user_buf_running, *source_user, *target_user,
-	    *rand_str, *hash_str, *result;
+	char *user_buf;
 
 	if (down_interruptible(&dev->sem))
 		return -ERESTARTSYS;
 
-	user_buf_running = NULL;
-	hash_str = NULL;
-	node_ptr = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
 	user_buf = kzalloc(count+1, GFP_KERNEL);
-	if (!node_ptr || !user_buf)
+	if (!user_buf)
 		goto out;
 
 	if (copy_from_user(user_buf, buf, count)) {
@@ -196,134 +350,11 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 	 * If the minor number is 0 ( /dev/caphash ) then simply add the
 	 * hashed capability supplied by the user to the list of hashes
 	 */
-	if (0 == iminor(filp->f_dentry->d_inode)) {
-		if (count > CAP_NODE_SIZE) {
-			retval = -EINVAL;
-			goto out;
-		}
-		if (!capable(CAP_GRANT_ID)) {
-			retval = -EPERM;
-			goto out;
-		}
-		printk(KERN_INFO "Capability being written to /dev/caphash : \n");
-		hexdump(user_buf, count);
-		memcpy(node_ptr->data, user_buf, count);
-		list_add(&(node_ptr->list), &(dev->head->list));
-		node_ptr = NULL;
-	} else {
-		char *tmpu;
-		if (!cap_devices[0].head ||
-				list_empty(&(cap_devices[0].head->list))) {
-			retval = -EINVAL;
-			goto out;
-		}
-		/*
-		 * break the supplied string into tokens with @ as the
-		 * delimiter If the string is "user1@user2@randomstring" we
-		 * need to split it and hash 'user1@user2' using 'randomstring'
-		 * as the key.
-		 */
-		tmpu = user_buf_running = kstrdup(user_buf, GFP_KERNEL);
-		source_user = strsep(&tmpu, "@");
-		target_user = strsep(&tmpu, "@");
-		rand_str = tmpu;
-		if (!source_user || !target_user || !rand_str) {
-			retval = -EINVAL;
-			goto out;
-		}
+	if (0 == iminor(filp->f_dentry->d_inode))
+		retval = add_caphash_entry(dev, user_buf, count);
+	else
+		retval = use_caphash_entry(dev, user_buf);
 
-		/* hash the string user1@user2 with rand_str as the key */
-		len = strlen(source_user) + strlen(target_user) + 1;
-		/* src, @, len, \0 */
-		hash_str = kzalloc(len+1, GFP_KERNEL);
-		strcat(hash_str, source_user);
-		strcat(hash_str, "@");
-		strcat(hash_str, target_user);
-
-		printk(KERN_ALERT "the source user is %s \n", source_user);
-		printk(KERN_ALERT "the target user is %s \n", target_user);
-
-		result = cap_hash(hash_str, len, rand_str, strlen(rand_str));
-		if (NULL == result) {
-			retval = -EFAULT;
-			goto out;
-		}
-		memcpy(node_ptr->data, result, CAP_NODE_SIZE);  /* why? */
-		/* Change the process's uid if the hash is present in the
-		 * list of hashes
-		 */
-		list_for_each(pos, &(cap_devices->head->list)) {
-			/*
-			 * Change the user id of the process if the hashes
-			 * match
-			 */
-			if (0 ==
-			    memcmp(result,
-				   list_entry(pos, struct cap_node,
-					      list)->data,
-				   CAP_NODE_SIZE)) {
-				target_int = (unsigned int)
-				    simple_strtol(target_user, NULL, 0);
-				source_int = (unsigned int)
-				    simple_strtol(source_user, NULL, 0);
-				flag = 1;
-
-				/*
-				 * Check whether the process writing to capuse
-				 * is actually owned by the source owner
-				 */
-				if (source_int != current_uid()) {
-					printk(KERN_ALERT
-					       "Process is not owned by the source user of the capability.\n");
-					retval = -EFAULT;
-					goto out;
-				}
-				/*
-				 * Change all uids.  It might be useful to
-				 * keep suid unchanged, however that will
-				 * mean that changing from uid=0 to uid=!0
-				 * pP is not emptied (only pE is), and when
-				 * changing from  uid=!0 to  uid=0, sets are
-				 * not filled.  They will be correct after
-				 * the next exec, but this is IMO not
-				 * sufficient.  So change all uids.
-				 */
-				new = prepare_creds();
-				if (!new) {
-					retval = -ENOMEM;
-					goto out;
-				}
-				retval = cred_setresuid(new, target_int,
-					 target_int, target_int,
-					 CRED_SETID_FORCE);
-				if (retval == 0)
-					commit_creds(new);
-				else {
-					abort_creds(new);
-					goto out;
-				}
-
-				/*
-				 * Remove the capability from the list and
-				 * break
-				 */
-				tmp = list_entry(pos, struct cap_node, list);
-				list_del(pos);
-				kfree(tmp);
-				break;
-			}
-		}
-		if (0 == flag) {
-			/*
-			 * The capability is not present in the list of the
-			 * hashes stored, hence return failure
-			 */
-			printk(KERN_ALERT
-			       "Invalid capabiliy written to /dev/capuse \n");
-			retval = -EFAULT;
-			goto out;
-		}
-	}
 	*f_pos += count;
 	retval = count;
 	/* update the size */
@@ -331,10 +362,7 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 		dev->size = *f_pos;
 
 out:
-	kfree(node_ptr);
 	kfree(user_buf);
-	kfree(user_buf_running);
-	kfree(hash_str);
 	up(&dev->sem);
 	return retval;
 }
-- 
1.6.1

