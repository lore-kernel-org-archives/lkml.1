Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZHSQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZHSQdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZHSQdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:33:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54384 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752108AbZHSQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:33:39 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] bsdacct: switch credentials for writing to the accounting file
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Date: Wed, 19 Aug 2009 18:36:18 +0200
Message-ID: <20090819163616.3716.18477.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When process accounting is enabled, every exiting process writes a log
to the account file. In addition, every once in a while one of the
exiting processes checks whether there's enough free space for the log.

SELinux policy may or may not allow the exiting process to stat the fs.
So unsuspecting processes start generating AVC denials just because
someone enabled process accounting.

For these filesystem operations, the exiting process's credentials
should be temporarily switched to that of the process which enabled
accounting, because it's really that process who wanted to have the
accounting information logged.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 kernel/acct.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 9f33910..54956cc 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -76,7 +76,7 @@ int acct_parm[3] = {4, 2, 30};
  * External references and all of the globals.
  */
 static void do_acct_process(struct bsd_acct_struct *acct,
-		struct pid_namespace *ns, struct file *);
+		struct pid_namespace *ns, struct file *, const struct cred *);
 
 /*
  * This structure is used so that all the data protected by lock
@@ -90,6 +90,7 @@ struct bsd_acct_struct {
 	struct pid_namespace	*ns;
 	struct timer_list	timer;
 	struct list_head	list;
+	const struct cred	*cred;
 };
 
 static DEFINE_SPINLOCK(acct_lock);
@@ -181,20 +182,24 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 {
 	struct file *old_acct = NULL;
 	struct pid_namespace *old_ns = NULL;
+	const struct cred *old_cred = NULL;
 
 	if (acct->file) {
 		old_acct = acct->file;
 		old_ns = acct->ns;
+		old_cred = acct->cred;
 		del_timer(&acct->timer);
 		acct->active = 0;
 		acct->needcheck = 0;
 		acct->file = NULL;
 		acct->ns = NULL;
+		acct->cred = NULL;
 		list_del(&acct->list);
 	}
 	if (file) {
 		acct->file = file;
 		acct->ns = ns;
+		acct->cred = get_current_cred();
 		acct->needcheck = 0;
 		acct->active = 1;
 		list_add(&acct->list, &acct_list);
@@ -206,7 +211,8 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 	if (old_acct) {
 		mnt_unpin(old_acct->f_path.mnt);
 		spin_unlock(&acct_lock);
-		do_acct_process(acct, old_ns, old_acct);
+		do_acct_process(acct, old_ns, old_acct, old_cred);
+		put_cred(old_cred);
 		filp_close(old_acct, NULL);
 		spin_lock(&acct_lock);
 	}
@@ -481,7 +487,7 @@ static u32 encode_float(u64 value)
  *  do_acct_process does all actual work. Caller holds the reference to file.
  */
 static void do_acct_process(struct bsd_acct_struct *acct,
-		struct pid_namespace *ns, struct file *file)
+	struct pid_namespace *ns, struct file *file, const struct cred *cred)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
 	acct_t ac;
@@ -491,13 +497,17 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	u64 run_time;
 	struct timespec uptime;
 	struct tty_struct *tty;
+	const struct cred *orig_cred;
+
+	/* Perform file operations on behalf of whoever enabled accounting */
+	orig_cred = override_creds(cred);
 
 	/*
 	 * First check to see if there is enough free_space to continue
 	 * the process accounting system.
 	 */
 	if (!check_free_space(acct, file))
-		return;
+		goto out;
 
 	/*
 	 * Fill the accounting struct with the needed info as recorded
@@ -578,6 +588,8 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 			       sizeof(acct_t), &file->f_pos);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 	set_fs(fs);
+out:
+	revert_creds(orig_cred);
 }
 
 /**
@@ -636,6 +648,7 @@ static void acct_process_in_ns(struct pid_namespace *ns)
 {
 	struct file *file = NULL;
 	struct bsd_acct_struct *acct;
+	const struct cred *cred;
 
 	acct = ns->bacct;
 	/*
@@ -651,9 +664,11 @@ static void acct_process_in_ns(struct pid_namespace *ns)
 		return;
 	}
 	get_file(file);
+	cred = get_cred(acct->cred);
 	spin_unlock(&acct_lock);
 
-	do_acct_process(acct, ns, file);
+	do_acct_process(acct, ns, file, cred);
+	put_cred(cred);
 	fput(file);
 }
 

