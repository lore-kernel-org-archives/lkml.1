Return-Path: <linux-kernel-owner+w=401wt.eu-S934925AbYBTUtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925AbYBTUtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763704AbYBTUsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:48:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:50716 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761745AbYBTUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H1EUX6r9ZH9X046YsyI7WcTy4cCBWpGBr4LoocXG3tSqRVfwvJvKkmml+BR+sKGd20hnHaISXa1j8b8HVqUU04HoQX0mA4E+0jzHtgCglpoH9hWrCsrt/F6axRRtojoFxhV3N34KXnDFIgwOS5JAJZLKAodbocffJ7IOlGGfUzI=
Subject: [PATCH 1/2] nfsd: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:49:00 -0800
Message-Id: <1203540540.25307.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extern to nfsd/nfsd.h
fs/nfsd/nfssvc.c:146:5: warning: symbol 'nfsd_nrthreads' was not declared. Should it be static?
fs/nfsd/nfssvc.c:261:5: warning: symbol 'nfsd_nrpools' was not declared. Should it be static?
fs/nfsd/nfssvc.c:269:5: warning: symbol 'nfsd_get_nrthreads' was not declared. Should it be static?
fs/nfsd/nfssvc.c:281:5: warning: symbol 'nfsd_set_nrthreads' was not declared. Should it be static?
fs/nfsd/export.c:1534:23: warning: symbol 'nfs_exports_op' was not declared. Should it be static?

Add include of auth.h
fs/nfsd/auth.c:27:5: warning: symbol 'nfsd_setuser' was not declared. Should it be static?

Make static, move forward declaration closer to where it's needed.
fs/nfsd/nfs4state.c:1877:1: warning: symbol 'laundromat_main' was not declared. Should it be static?

Make static, forward declaration was already marked static.
fs/nfsd/nfs4idmap.c:206:1: warning: symbol 'idtoname_parse' was not declared. Should it be static?
fs/nfsd/vfs.c:1156:1: warning: symbol 'nfsd_create_setattr' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/nfsd/auth.c            |    1 +
 fs/nfsd/nfs4idmap.c       |    2 +-
 fs/nfsd/nfs4state.c       |   10 +++++-----
 fs/nfsd/nfsctl.c          |    7 -------
 fs/nfsd/vfs.c             |    2 +-
 include/linux/nfsd/nfsd.h |    8 ++++++++
 6 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index d13403e..294992e 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -10,6 +10,7 @@
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/export.h>
+#include "auth.h"
 
 int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
 {
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 996bd88..5b39842 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -202,7 +202,7 @@ static struct cache_detail idtoname_cache = {
 	.alloc		= ent_alloc,
 };
 
-int
+static int
 idtoname_parse(struct cache_detail *cd, char *buf, int buflen)
 {
 	struct ent ent, *res;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index bcb97d8..c7c92ae 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1762,10 +1762,6 @@ out:
 	return status;
 }
 
-static struct workqueue_struct *laundry_wq;
-static void laundromat_main(struct work_struct *);
-static DECLARE_DELAYED_WORK(laundromat_work, laundromat_main);
-
 __be32
 nfsd4_renew(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	    clientid_t *clid)
@@ -1873,7 +1869,11 @@ nfs4_laundromat(void)
 	return clientid_val;
 }
 
-void
+static struct workqueue_struct *laundry_wq;
+static void laundromat_main(struct work_struct *);
+static DECLARE_DELAYED_WORK(laundromat_work, laundromat_main);
+
+static void
 laundromat_main(struct work_struct *not_used)
 {
 	time_t t;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 8516137..73d3f28 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -149,7 +149,6 @@ static const struct file_operations transaction_ops = {
 	.release	= simple_transaction_release,
 };
 
-extern struct seq_operations nfs_exports_op;
 static int exports_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &nfs_exports_op);
@@ -347,8 +346,6 @@ static ssize_t write_filehandle(struct file *file, char *buf, size_t size)
 	return mesg - buf;	
 }
 
-extern int nfsd_nrthreads(void);
-
 static ssize_t write_threads(struct file *file, char *buf, size_t size)
 {
 	/* if size > 0, look for a number of threads and call nfsd_svc
@@ -371,10 +368,6 @@ static ssize_t write_threads(struct file *file, char *buf, size_t size)
 	return strlen(buf);
 }
 
-extern int nfsd_nrpools(void);
-extern int nfsd_get_nrthreads(int n, int *);
-extern int nfsd_set_nrthreads(int n, int *);
-
 static ssize_t write_pool_threads(struct file *file, char *buf, size_t size)
 {
 	/* if size > 0, look for an array of number of threads per node
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 46f59d5..0265310 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1152,7 +1152,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 }
 #endif /* CONFIG_NFSD_V3 */
 
-__be32
+static __be32
 nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 			struct iattr *iap)
 {
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index 8caf4c4..f4de14d 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -56,12 +56,20 @@ extern struct svc_program	nfsd_program;
 extern struct svc_version	nfsd_version2, nfsd_version3,
 				nfsd_version4;
 extern struct svc_serv		*nfsd_serv;
+
+extern struct seq_operations nfs_exports_op;
+
 /*
  * Function prototypes.
  */
 int		nfsd_svc(unsigned short port, int nrservs);
 int		nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp);
 
+int		nfsd_nrthreads(void);
+int		nfsd_nrpools(void);
+int		nfsd_get_nrthreads(int n, int *);
+int		nfsd_set_nrthreads(int n, int *);
+
 /* nfsd/vfs.c */
 int		fh_lock_parent(struct svc_fh *, struct dentry *);
 int		nfsd_racache_init(int);
-- 
1.5.4.2.200.g99e75


