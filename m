Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777Ab0AEUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0AEUia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775Ab0AEUi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:38:26 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52803 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0AEUiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:38:18 -0500
From: serue@us.ibm.com
To: greg@kroah.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/6] p9auth: do groups
Date: Tue,  5 Jan 2010 14:37:30 -0600
Message-Id: <1262723850-9870-6-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1262723850-9870-1-git-send-email-serue@us.ibm.com>
References: <1262723850-9870-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

A p9auth capability used to be 'old_uid@new_uid@random_string'.  Now
it is 'old_uid@new_uid@new_gid@num_groups@g_1@...@g_n@random_string'.
After using the capability, credentials will be:
	suid = old_uid;
	sgid = old_gid;
	uid = euid = fsuid = new_uid
	gid = egid = fsgid = new_gid
	auxiliary groups = g_1, g_2, ..., g_n

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/p9auth/p9auth.c |   99 +++++++++++++++++++++++++--------------
 1 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 50447d4..e94c4fe 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -167,8 +167,10 @@ static int cap_release(struct inode *inode, struct file *filp)
 
 struct id_set {
 	char *source_user, *target_user;
-	char *randstr;
 	uid_t old_uid, new_uid;
+	gid_t new_gid;
+	unsigned int ngroups;
+	struct group_info *newgroups;
 	char *full;  /* The full entry which must be freed */
 };
 
@@ -180,7 +182,8 @@ struct id_set {
  */
 static int parse_user_capability(char *s, struct id_set *set)
 {
-	char *tmpu;
+	char *tmp, *tmpu;
+	int i, ret;
 
 	/*
 	 * break the supplied string into tokens with @ as the
@@ -192,18 +195,45 @@ static int parse_user_capability(char *s, struct id_set *set)
 	if (!tmpu)
 		return -ENOMEM;
 
+	ret = -EINVAL;
 	set->source_user = strsep(&tmpu, "@");
 	set->target_user = strsep(&tmpu, "@");
-	set->randstr = tmpu;
-	if (!set->source_user || !set->target_user || !set->randstr) {
-		kfree(set->full);
-		return -EINVAL;
-	}
+	tmp = strsep(&tmpu, "@");
+	if (!set->source_user || !set->target_user || !tmp)
+		goto out;
 
 	set->new_uid = simple_strtoul(set->target_user, NULL, 0);
 	set->old_uid = simple_strtoul(set->source_user, NULL, 0);
+	set->new_gid = simple_strtoul(tmp, NULL, 0);
 
-	return 0;
+	tmp = strsep(&tmpu, "@");
+	if (!tmp)
+		goto out;
+	if (sscanf(tmp, "%d", &set->ngroups) != 1 || set->ngroups < 0)
+		goto out;
+
+	ret = -ENOMEM;
+	set->newgroups = groups_alloc(set->ngroups);
+	if (!set->newgroups)
+		goto out;
+
+	ret = -EINVAL;
+	for (i = 0; i < set->ngroups; i++) {
+		gid_t g;
+
+		tmp = strsep(&tmpu, "@");
+		if (!tmp || sscanf(tmp, "%d", &g) != 1) {
+			groups_free(set->newgroups);
+			goto out;
+		}
+		GROUP_AT(set->newgroups, i) = g;
+	}
+
+	ret = 0;
+
+out:
+	kfree(set->full);
+	return ret;
 }
 
 static int grant_id(struct id_set *set)
@@ -230,8 +260,13 @@ static int grant_id(struct id_set *set)
 	if (!new)
 		return -ENOMEM;
 
-	ret = cred_setresuid(new, set->new_uid, set->new_uid, set->new_uid,
-			     CRED_SETID_FORCE);
+	ret = set_groups(new, set->newgroups);
+	if (!ret)
+		ret = cred_setresgid(new, set->new_gid, set->new_gid,
+				     set->new_gid, CRED_SETID_FORCE);
+	if (!ret)
+		ret = cred_setresuid(new, set->new_uid, set->new_uid,
+				     set->new_uid, CRED_SETID_FORCE);
 	if (ret == 0)
 		commit_creds(new);
 	else
@@ -260,12 +295,12 @@ static int add_caphash_entry(struct cap_dev *dev, char *user_buf, size_t count)
 	return 0;
 }
 
-static int use_caphash_entry(struct cap_dev *dev, char *user_buf)
+static int use_caphash_entry(struct cap_dev *dev, char *ubuf)
 {
 	struct cap_node *node;
 	struct id_set set;
-	int ret, len, found = 0;
-	char *tohash, *hashed;
+	int ret, found = 0;
+	char *hashed = NULL, *sep;
 	struct list_head *pos;
 
 	if (!cap_devices[0].head)
@@ -273,37 +308,30 @@ static int use_caphash_entry(struct cap_dev *dev, char *user_buf)
 	if (list_empty(&(cap_devices[0].head->list)))
 		return -EINVAL;
 
-	ret = parse_user_capability(user_buf, &set);
+	ret = parse_user_capability(ubuf, &set);
 	if (ret)
 		return ret;
 
-	/* hash the string user1@user2 with randstr as the key */
-	len = strlen(set.source_user) + strlen(set.target_user) + 1;
-	/* src, @, len, \0 */
-	tohash = kzalloc(len+1, GFP_KERNEL);
-	if (!tohash) {
-		kfree(set.full);
-		return -ENOMEM;
+	/*
+	 * hash the string user1@user2@ngrp@grp... with randstr as the key
+	 * XXX is there any vulnerability we're opening ourselves up to by
+	 * not rebuilding the string from its components?
+	 */
+	sep = strrchr(ubuf, '@');
+	if (sep) {
+		char *rand = sep + 1;
+		*sep = '\0';
+		hashed = cap_hash(ubuf, strlen(ubuf), rand, strlen(rand));
+	}
+	if (NULL == hashed) {
+		ret = -EINVAL;
+		goto out;
 	}
-	strcat(tohash, set.source_user);
-	strcat(tohash, "@");
-	strcat(tohash, set.target_user);
-	printk(KERN_ALERT "the source user is %s \n", set.source_user);
-	printk(KERN_ALERT "the target user is %s \n", set.target_user);
-	hashed = cap_hash(tohash, len, set.randstr, strlen(set.randstr));
-	kfree(set.full);
-	kfree(tohash);
-	if (NULL == hashed)
-		return -EFAULT;
 
 	/* Change the process's uid if the hash is present in the
 	 * list of hashes
 	 */
 	list_for_each(pos, &(cap_devices->head->list)) {
-		/*
-		 * Change the user id of the process if the hashes
-		 * match
-		 */
 		node = list_entry(pos, struct cap_node, list);
 		if (0 == memcmp(hashed, node->data, CAP_NODE_SIZE)) {
 			ret = grant_id(&set);
@@ -323,6 +351,7 @@ static int use_caphash_entry(struct cap_dev *dev, char *user_buf)
 		ret = -EFAULT;
 	}
 out:
+	put_group_info(set.newgroups);
 	kfree(hashed);
 	return ret;
 }
-- 
1.6.1

