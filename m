Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYJGK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYJGK5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYJGK4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:56:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46208 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYJGK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:56:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<m163o47kc5.fsf_-_@frodo.ebiederm.org>
	<m11vys7k92.fsf_-_@frodo.ebiederm.org>
Date: Tue, 07 Oct 2008 03:51:17 -0700
In-Reply-To: <m11vys7k92.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 07 Oct 2008 03:49:29 -0700")
Message-ID: <m1vdw465lm.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0931]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 2/3] sysfs: Fix and sysfs_mv_dir by using lock_rename.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysfs_mv_dir picks an arbitrary mutex lock ordering and busy waits
until it can grab the inode mutexes in that order.  This can dead lock
on UP systems.

Instead use the generic lock_rename that guarantees we grab parent
directories before child directories, so there is not need to spin and
no chance of deadlock.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c |   43 +++++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a76fb54..94f2ed1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -955,12 +955,22 @@ err_out:
 	return error;
 }
 
+static void sysfs_lock_rename(struct sysfs_rename_struct *srs)
+{
+	lock_rename(srs->old_parent, srs->new_parent);
+}
+
+static void sysfs_unlock_rename(struct sysfs_rename_struct *srs)
+{
+	unlock_rename(srs->old_parent, srs->new_parent);
+}
+
 static int sysfs_mv_dir(struct sysfs_dirent *sd,
 	struct sysfs_dirent *new_parent_sd, const char *new_name)
 {
 	struct list_head todo;
 	struct sysfs_rename_struct *srs;
-	struct inode *old_parent_inode = NULL, *new_parent_inode = NULL;
+	struct sysfs_dirent *old_parent_sd;
 	const char *dup_name = NULL;
 	const void *old_tag, *tag;
 	int error;
@@ -971,11 +981,12 @@ static int sysfs_mv_dir(struct sysfs_dirent *sd,
 	if (!new_parent_sd)
 		new_parent_sd = &sysfs_root;
 
+	old_parent_sd = sysfs_get(sd->s_parent);
 	old_tag = sd->s_tag;
-	tag = sysfs_creation_tag(sd->s_parent, sd);
+	tag = sysfs_creation_tag(old_parent_sd, sd);
 
 	error = 0;
-	if ((sd->s_parent == new_parent_sd) && (old_tag == tag) &&
+	if ((old_parent_sd == new_parent_sd) && (old_tag == tag) &&
 	    (strcmp(sd->s_name, new_name) == 0))
 		goto out;	/* nothing to do */
 
@@ -986,22 +997,8 @@ static int sysfs_mv_dir(struct sysfs_dirent *sd,
 			goto out_release;
 	}
 
-	error = -ENOMEM;
-	mutex_lock(&sysfs_mutex);
-	old_parent_inode = sysfs_get_inode(sd->s_parent);
-	new_parent_inode = sysfs_get_inode(new_parent_sd);
-	mutex_unlock(&sysfs_mutex);
-	if (!old_parent_inode || !new_parent_inode)
-		goto out_release;
-
-again:
-	mutex_lock(&old_parent_inode->i_mutex);
-	if (old_parent_inode != new_parent_inode) {
-		if (!mutex_trylock(&new_parent_inode->i_mutex)) {
-			mutex_unlock(&old_parent_inode->i_mutex);
-			goto again;
-		}
-	}
+	if (!list_empty(&todo))
+		sysfs_lock_rename(list_first_entry(&todo, struct sysfs_rename_struct, list));
 	mutex_lock(&sysfs_mutex);
 
 	error = -EEXIST;
@@ -1048,17 +1045,15 @@ again:
 	error = 0;
 out_unlock:
 	mutex_unlock(&sysfs_mutex);
-	if (new_parent_inode != old_parent_inode)
-		mutex_unlock(&new_parent_inode->i_mutex);
-	mutex_unlock(&old_parent_inode->i_mutex);
+	if (!list_empty(&todo))
+		sysfs_unlock_rename(list_first_entry(&todo, struct sysfs_rename_struct, list));
 	kfree(dup_name);
 
 out_release:
-	iput(new_parent_inode);
-	iput(old_parent_inode);
 	post_rename(&todo);
 	sysfs_release_supers();
 out:
+	sysfs_put(old_parent_sd);
 	mutex_unlock(&sysfs_rename_mutex);
 	return error;
 }
-- 
1.5.3.rc6.17.g1911

