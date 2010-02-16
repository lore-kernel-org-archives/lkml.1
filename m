Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab0BPWpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:45:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42623 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181Ab0BPWpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:45:15 -0500
From: Serge Hallyn <serue@us.ibm.com>
To: serue@us.ibm.com
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: [PATCH 3/8] p9auth: use setresuid
Date: Tue, 16 Feb 2010 16:44:56 -0600
Message-Id: <1266360301-30081-3-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Use setresuid to set userids through p9auth capability device, to
make sure MAC checks and setuid fixup are done.  In particular,
becoming root or dropping root should tweak capability sets.

Have the cred_setresuid() helper take a 'int force' argument,
which means the setuid has been authorized, so no need to
check CAP_SETUID.  (Analogous for cred_setresgid, which will
also eventually be used).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
Cc: Ron Minnich <rminnich@gmail.com>
---
 drivers/staging/p9auth/p9auth.c |   12 ++++++++----
 include/linux/cred.h            |    8 ++++++--
 kernel/cred.c                   |   11 ++++++-----
 kernel/sys.c                    |    4 ++--
 4 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 70ef45b..8f70daa 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -289,11 +289,15 @@ static ssize_t cap_write(struct file *filp, const char __user *buf,
 					retval = -ENOMEM;
 					goto out;
 				}
-				new->uid = (uid_t) target_int;
-				new->suid = new->fsuid = new->euid = new->uid;
-				retval = commit_creds(new);
-				if (retval)
+				retval = cred_setresuid(new, target_int,
+					 target_int, target_int,
+					 CRED_SETID_FORCE);
+				if (retval == 0)
+					commit_creds(new);
+				else {
+					abort_creds(new);
 					goto out;
+				}
 
 				/*
 				 * Remove the capability from the list and
diff --git a/include/linux/cred.h b/include/linux/cred.h
index e35631e..6337e18 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -399,8 +399,12 @@ do {						\
 	*(_fsgid) = __cred->fsgid;		\
 } while(0)
 
-int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid);
-int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid);
+#define CRED_SETID_NOFORCE 0
+#define CRED_SETID_FORCE 1
+int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid,
+		   int force);
+int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid,
+		   int force);
 int cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid);
 int cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid);
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 6eee59c..8640988 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -780,7 +780,8 @@ int set_create_files_as(struct cred *new, struct inode *inode)
 }
 EXPORT_SYMBOL(set_create_files_as);
 
-int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid)
+int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid,
+		   int force)
 {
 	int retval;
 	const struct cred *old;
@@ -790,7 +791,7 @@ int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid)
 		return retval;
 	old = current_cred();
 
-	if (!capable(CAP_SETUID)) {
+	if (!force && !capable(CAP_SETUID)) {
 		if (ruid != (uid_t) -1 && ruid != old->uid &&
 		    ruid != old->euid  && ruid != old->suid)
 			return -EPERM;
@@ -820,8 +821,8 @@ int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid)
 }
 EXPORT_SYMBOL_GPL(cred_setresuid);
 
-int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid,
-			gid_t sgid)
+int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid,
+		   int force)
 {
 	const struct cred *old = current_cred();
 	int retval;
@@ -830,7 +831,7 @@ int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid,
 	if (retval)
 		return retval;
 
-	if (!capable(CAP_SETGID)) {
+	if (!force && !capable(CAP_SETGID)) {
 		if (rgid != (gid_t) -1 && rgid != old->gid &&
 		    rgid != old->egid  && rgid != old->sgid)
 			return -EPERM;
diff --git a/kernel/sys.c b/kernel/sys.c
index 1927edf..f6c2534 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -720,7 +720,7 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 	if (!new)
 		return -ENOMEM;
 
-	retval = cred_setresuid(new, ruid, euid, suid);
+	retval = cred_setresuid(new, ruid, euid, suid, CRED_SETID_NOFORCE);
 	if (retval == 0)
 		return commit_creds(new);
 
@@ -752,7 +752,7 @@ SYSCALL_DEFINE3(setresgid, gid_t, rgid, gid_t, egid, gid_t, sgid)
 	if (!new)
 		return -ENOMEM;
 
-	retval = cred_setresgid(new, rgid, egid, sgid);
+	retval = cred_setresgid(new, rgid, egid, sgid, CRED_SETID_NOFORCE);
 	if (retval == 0)
 		return commit_creds(new);
 
-- 
1.6.1

