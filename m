Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbYBTQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbYBTQJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763809AbYBTQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:08:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbYBTQIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/37] Security: Make NFSD work with detached security
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:52 +0000
Message-ID: <20080220160652.4715.50448.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make NFSD work with detached security, using the patches that excise the
security information from task_struct to struct task_security as a base.

Each time NFSD wants a new security descriptor (to do NFS4 recovery or just to
do NFS operations), a task_security record is derived from NFSD's *objective*
security, modified and then applied as the *subjective* security.  This means
(a) the changes are not visible to anyone looking at NFSD through /proc, (b)
there is no leakage between two consecutive ops with different security
configurations.

Consideration should probably be given to caching the task_security record on
the basis that there'll probably be several ops that will want to use any
particular security configuration.

Furthermore, nfs4recover.c perhaps ought to set an appropriate LSM context on
the record pointed to by rec_security so that the disk is accessed
appropriately (see set_security_override[_from_ctx]()).

NOTE!  This patch must be rolled in to one of the earlier security patches to
make it compile fully.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfsd/auth.c        |   37 +++++++++++++++++++---------
 fs/nfsd/nfs4recover.c |   64 +++++++++++++++++++++++++++++++------------------
 2 files changed, 65 insertions(+), 36 deletions(-)


diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 5586157..ebdc562 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/cred.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
@@ -26,12 +27,17 @@ int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
-	struct task_security *act_as = current->act_as;
+	struct task_security *sec, *old;
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
 	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
+	/* derive the new security record from nfsd's objective security */
+	sec = get_kernel_security(current);
+	if (!sec)
+		return -ENOMEM;
+
 	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
 		cred.cr_gid = exp->ex_anon_gid;
@@ -55,26 +61,33 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 		get_group_info(cred.cr_group_info);
 
 	if (cred.cr_uid != (uid_t) -1)
-		act_as->fsuid = cred.cr_uid;
+		sec->fsuid = cred.cr_uid;
 	else
-		act_as->fsuid = exp->ex_anon_uid;
+		sec->fsuid = exp->ex_anon_uid;
 	if (cred.cr_gid != (gid_t) -1)
-		act_as->fsgid = cred.cr_gid;
+		sec->fsgid = cred.cr_gid;
 	else
-		act_as->fsgid = exp->ex_anon_gid;
+		sec->fsgid = exp->ex_anon_gid;
 
-	if (!cred.cr_group_info)
+	if (!cred.cr_group_info) {
+		put_task_security(sec);
 		return -ENOMEM;
-	ret = set_groups(act_as, cred.cr_group_info);
+	}
+	ret = set_groups(sec, cred.cr_group_info);
 	put_group_info(cred.cr_group_info);
 	if ((cred.cr_uid)) {
-		act_as->cap_effective =
-			cap_drop_nfsd_set(act_as->cap_effective);
+		sec->cap_effective =
+			cap_drop_nfsd_set(sec->cap_effective);
 	} else {
-		act_as->cap_effective =
-			cap_raise_nfsd_set(act_as->cap_effective,
-					   act_as->cap_permitted);
+		sec->cap_effective =
+			cap_raise_nfsd_set(sec->cap_effective,
+					   sec->cap_permitted);
 	}
+
+	/* set the new security as nfsd's subjective security */
+	old = current->act_as;
+	current->act_as = sec;
+	put_task_security(old);
 	return ret;
 }
 
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index afddc9b..c86aa92 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -46,27 +46,37 @@
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <linux/sched.h>
+#include <linux/cred.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
 /* Globals */
 static struct nameidata rec_dir;
 static int rec_dir_init = 0;
+static struct task_security *rec_security;
 
+/*
+ * switch the special recovery access security in on the current task's
+ * subjective security
+ */
 static void
-nfs4_save_user(uid_t *saveuid, gid_t *savegid)
+nfs4_begin_secure(struct task_security **saved_sec)
 {
-	*saveuid = current->act_as->fsuid;
-	*savegid = current->act_as->fsgid;
-	current->act_as->fsuid = 0;
-	current->act_as->fsgid = 0;
+	*saved_sec = current->act_as;
+	current->act_as = get_task_security(rec_security);
 }
 
+/*
+ * return the current task's subjective security to its former glory
+ */
 static void
-nfs4_reset_user(uid_t saveuid, gid_t savegid)
+nfs4_end_secure(struct task_security *saved_sec)
 {
-	current->act_as->fsuid = saveuid;
-	current->act_as->fsgid = savegid;
+	struct task_security *discard;
+
+	discard = current->act_as;
+	current->act_as = saved_sec;
+	put_task_security(discard);
 }
 
 static void
@@ -128,10 +138,9 @@ nfsd4_sync_rec_dir(void)
 int
 nfsd4_create_clid_dir(struct nfs4_client *clp)
 {
+	struct task_security *saved_sec;
 	char *dname = clp->cl_recdir;
 	struct dentry *dentry;
-	uid_t uid;
-	gid_t gid;
 	int status;
 
 	dprintk("NFSD: nfsd4_create_clid_dir for \"%s\"\n", dname);
@@ -139,7 +148,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	if (!rec_dir_init || clp->cl_firststate)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	nfs4_begin_secure(&saved_sec);
 
 	/* lock the parent */
 	mutex_lock(&rec_dir.path.dentry->d_inode->i_mutex);
@@ -163,7 +172,7 @@ out_unlock:
 		clp->cl_firststate = 1;
 		nfsd4_sync_rec_dir();
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_end_secure(saved_sec);
 	dprintk("NFSD: nfsd4_create_clid_dir returns %d\n", status);
 	return status;
 }
@@ -206,20 +215,19 @@ nfsd4_build_dentrylist(void *arg, const char *name, int namlen,
 static int
 nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 {
+	struct task_security *saved_sec;
 	struct file *filp;
 	struct dentry_list_arg dla = {
 		.parent = dir,
 	};
 	struct list_head *dentries = &dla.dentries;
 	struct dentry_list *child;
-	uid_t uid;
-	gid_t gid;
 	int status;
 
 	if (!rec_dir_init)
 		return 0;
 
-	nfs4_save_user(&uid, &gid);
+	nfs4_begin_secure(&saved_sec);
 
 	filp = dentry_open(dget(dir), mntget(rec_dir.path.mnt), O_RDONLY);
 	status = PTR_ERR(filp);
@@ -244,7 +252,7 @@ out:
 		dput(child->dentry);
 		kfree(child);
 	}
-	nfs4_reset_user(uid, gid);
+	nfs4_end_secure(saved_sec);
 	return status;
 }
 
@@ -306,17 +314,16 @@ out:
 void
 nfsd4_remove_clid_dir(struct nfs4_client *clp)
 {
-	uid_t uid;
-	gid_t gid;
+	struct task_security *saved_sec;
 	int status;
 
 	if (!rec_dir_init || !clp->cl_firststate)
 		return;
 
 	clp->cl_firststate = 0;
-	nfs4_save_user(&uid, &gid);
+	nfs4_begin_secure(&saved_sec);
 	status = nfsd4_unlink_clid_dir(clp->cl_recdir, HEXDIR_LEN-1);
-	nfs4_reset_user(uid, gid);
+	nfs4_end_secure(saved_sec);
 	if (status == 0)
 		nfsd4_sync_rec_dir();
 	if (status)
@@ -387,8 +394,7 @@ nfsd4_recdir_load(void) {
 void
 nfsd4_init_recdir(char *rec_dirname)
 {
-	uid_t			uid = 0;
-	gid_t			gid = 0;
+	struct task_security	*saved_sec;
 	int 			status;
 
 	printk("NFSD: Using %s as the NFSv4 state recovery directory\n",
@@ -396,7 +402,15 @@ nfsd4_init_recdir(char *rec_dirname)
 
 	BUG_ON(rec_dir_init);
 
-	nfs4_save_user(&uid, &gid);
+	/* derive the security record from this task's objective security */
+	rec_security = get_kernel_security(current);
+	if (!rec_security) {
+		printk("NFSD:"
+		       " unable to allocate recovery directory security\n");
+		return;
+	}
+
+	nfs4_begin_secure(&saved_sec);
 
 	status = path_lookup(rec_dirname, LOOKUP_FOLLOW | LOOKUP_DIRECTORY,
 			&rec_dir);
@@ -406,7 +420,8 @@ nfsd4_init_recdir(char *rec_dirname)
 
 	if (!status)
 		rec_dir_init = 1;
-	nfs4_reset_user(uid, gid);
+
+	nfs4_end_secure(saved_sec);
 }
 
 void
@@ -416,4 +431,5 @@ nfsd4_shutdown_recdir(void)
 		return;
 	rec_dir_init = 0;
 	path_put(&rec_dir.path);
+	put_task_security(rec_security);
 }

