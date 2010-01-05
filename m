Return-Path: <linux-kernel-owner+w=401wt.eu-S932117Ab0AEUip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0AEUip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289Ab0AEUiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:38:01 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33632 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0AEUh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:37:59 -0500
From: serue@us.ibm.com
To: greg@kroah.com
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/6] p9auth: use setresuid
Date: Tue,  5 Jan 2010 14:37:27 -0600
Message-Id: <1262723850-9870-3-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1262723850-9870-1-git-send-email-serue@us.ibm.com>
References: <1262723850-9870-1-git-send-email-serue@us.ibm.com>
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
index fb73c5b..16c0a04 100644
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

