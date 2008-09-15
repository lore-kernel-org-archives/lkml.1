Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYIOVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYIOVLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbYIOVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:07:00 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:64431 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbYIOVG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:06:29 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       "Matthew N. Dodd" <Matthew.Dodd@sparta.com>
Subject: [PATCH 11/14] NFS/RPC: Add the auth_seclabel security flavor to allow the process label to be sent to the server.
Date: Mon, 15 Sep 2008 16:41:15 -0400
Message-Id: <1221511278-28051-12-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
References: <1221511278-28051-1-git-send-email-dpquigl@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new RPC flavor that allows the NFSv4 client to pass the
process label of the calling process on the client to the server to make an
access control decision. This is accomplished by taking the credential from the
wire and replacing the acting credential on the server for the NFSD process
with that new context.

Signed-off-by: Matthew N. Dodd <Matthew.Dodd@sparta.com>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/nfs/nfs4proc.c               |    6 +-
 fs/nfsd/auth.c                  |   21 +++
 include/linux/sunrpc/auth.h     |    4 +
 include/linux/sunrpc/msg_prot.h |    1 +
 include/linux/sunrpc/svcauth.h  |    4 +
 net/sunrpc/Makefile             |    1 +
 net/sunrpc/auth.c               |   16 ++
 net/sunrpc/auth_seclabel.c      |  291 +++++++++++++++++++++++++++++++++++++++
 net/sunrpc/svc.c                |    1 +
 net/sunrpc/svcauth.c            |    6 +
 net/sunrpc/svcauth_unix.c       |   97 +++++++++++++-
 security/security.c             |    2 +
 security/selinux/hooks.c        |    2 +-
 13 files changed, 446 insertions(+), 6 deletions(-)
 create mode 100644 net/sunrpc/auth_seclabel.c

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c4a4271..92522cc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1410,6 +1410,9 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	struct nfs4_state *state;
 	struct dentry *res;
 
+	cred = rpc_lookup_cred();
+	if (IS_ERR(cred))
+		return (struct dentry *)cred;
 	if (nd->flags & LOOKUP_CREATE) {
 		attr.ia_mode = nd->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
@@ -1420,9 +1423,6 @@ nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 		BUG_ON(nd->intent.open.flags & O_CREAT);
 	}
 
-	cred = rpc_lookup_cred();
-	if (IS_ERR(cred))
-		return (struct dentry *)cred;
 	parent = dentry->d_parent;
 	/* Protect against concurrent sillydeletes */
 	nfs_block_sillyrename(parent);
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 294992e..400edf5 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -10,6 +10,9 @@
 #include <linux/sunrpc/svcauth.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/export.h>
+#ifdef CONFIG_SECURITY
+#include <linux/security.h>
+#endif
 #include "auth.h"
 
 int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
@@ -32,6 +35,24 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
+#ifdef CONFIG_SECURITY
+	if (cred.cr_label_len != 0) {
+		ret = security_setprocattr(current, "current",
+				(void *)cred.cr_label, cred.cr_label_len);
+		if (ret < 0) {
+			printk(KERN_ERR "%s(): "
+					"flavor %d "
+					"security_setprocattr(\"%*s\", %d) = %d\n",
+					__func__,
+					rqstp->rq_flavor,
+					cred.cr_label_len,
+					(char *)cred.cr_label,
+					cred.cr_label_len, ret);
+			return ret;
+		}
+	}
+#endif
+	
 	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
 		cred.cr_gid = exp->ex_anon_gid;
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index 3f63218..11c054d 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -27,6 +27,10 @@ struct auth_cred {
 	gid_t	gid;
 	struct group_info *group_info;
 	unsigned char machine_cred : 1;
+#ifdef CONFIG_SECURITY
+	char   *label;
+	size_t  label_len;
+#endif
 };
 
 /*
diff --git a/include/linux/sunrpc/msg_prot.h b/include/linux/sunrpc/msg_prot.h
index 70df4f1..e2667f6 100644
--- a/include/linux/sunrpc/msg_prot.h
+++ b/include/linux/sunrpc/msg_prot.h
@@ -24,6 +24,7 @@ enum rpc_auth_flavors {
 	RPC_AUTH_DES   = 3,
 	RPC_AUTH_KRB   = 4,
 	RPC_AUTH_GSS   = 6,
+	RPC_AUTH_SECLABEL = 7,
 	RPC_AUTH_MAXFLAVOR = 8,
 	/* pseudoflavors: */
 	RPC_AUTH_GSS_KRB5  = 390003,
diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index d39dbdc..5557361 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -21,6 +21,10 @@ struct svc_cred {
 	uid_t			cr_uid;
 	gid_t			cr_gid;
 	struct group_info	*cr_group_info;
+#ifdef CONFIG_SECURITY
+	void			*cr_label;
+	u32			cr_label_len;
+#endif
 };
 
 struct svc_rqst;		/* forward decl */
diff --git a/net/sunrpc/Makefile b/net/sunrpc/Makefile
index 5369aa3..5e03065 100644
--- a/net/sunrpc/Makefile
+++ b/net/sunrpc/Makefile
@@ -6,6 +6,7 @@
 obj-$(CONFIG_SUNRPC) += sunrpc.o
 obj-$(CONFIG_SUNRPC_GSS) += auth_gss/
 obj-$(CONFIG_SUNRPC_XPRT_RDMA) += xprtrdma/
+obj-$(CONFIG_SECURITY) += auth_seclabel.o
 
 sunrpc-y := clnt.o xprt.o socklib.o xprtsock.o sched.o \
 	    auth.o auth_null.o auth_unix.o auth_generic.o \
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 6bfea9e..b1d9e4e 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -14,6 +14,7 @@
 #include <linux/hash.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/spinlock.h>
+#include <linux/security.h>
 
 #ifdef RPC_DEBUG
 # define RPCDBG_FACILITY	RPCDBG_AUTH
@@ -359,11 +360,19 @@ rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 
 	dprintk("RPC:       looking up %s cred\n",
 		auth->au_ops->au_name);
+#ifdef CONFIG_SECURITY
+	acred.label_len = security_getprocattr(current, "current",&acred.label);
+#endif
 	get_group_info(acred.group_info);
 	ret = auth->au_ops->lookup_cred(auth, &acred, flags);
 	put_group_info(acred.group_info);
+#ifdef CONFIG_SECURITY
+	if (acred.label != NULL)
+		security_release_secctx(acred.label, acred.label_len);
+#endif
 	return ret;
 }
+EXPORT_SYMBOL_GPL(rpcauth_lookupcred);
 
 void
 rpcauth_init_cred(struct rpc_cred *cred, const struct auth_cred *acred,
@@ -403,11 +412,18 @@ rpcauth_bind_root_cred(struct rpc_task *task)
 
 	dprintk("RPC: %5u looking up %s cred\n",
 		task->tk_pid, task->tk_client->cl_auth->au_ops->au_name);
+#ifdef CONFIG_SECURITY
+	acred.label_len = security_getprocattr(current, "current",&acred.label);
+#endif
 	ret = auth->au_ops->lookup_cred(auth, &acred, 0);
 	if (!IS_ERR(ret))
 		task->tk_msg.rpc_cred = ret;
 	else
 		task->tk_status = PTR_ERR(ret);
+#ifdef CONFIG_SECURITY
+	if (acred.label != NULL)
+		security_release_secctx(acred.label, acred.label_len);
+#endif
 }
 
 static void
diff --git a/net/sunrpc/auth_seclabel.c b/net/sunrpc/auth_seclabel.c
new file mode 100644
index 0000000..3e3b8ef
--- /dev/null
+++ b/net/sunrpc/auth_seclabel.c
@@ -0,0 +1,291 @@
+/*
+ * linux/net/sunrpc/auth_seclabel.c
+ *
+ * UNIX-style authentication; no AUTH_SHORT support
+ * SECLABEL-style authentication with security label support
+ *
+ * Copyright (C) 2007, 2008, SPARTA, Inc.
+ * Copyright (C) 1996, Olaf Kirch <okir@monad.swb.de>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+#include <linux/sunrpc/clnt.h>
+#include <linux/sunrpc/auth.h>
+#include <linux/security.h>
+
+#define NFS_NGROUPS	16
+
+struct seclabel_cred {
+	struct rpc_cred		slc_base;
+	gid_t			slc_gid;
+	gid_t			slc_gids[NFS_NGROUPS];
+	char		       *slc_label;
+	size_t			slc_label_len;
+};
+#define slc_uid			slc_base.cr_uid
+
+#define UNX_WRITESLACK		(21 + (UNX_MAXNODENAME >> 2))
+
+#ifdef RPC_DEBUG
+# define RPCDBG_FACILITY	RPCDBG_AUTH
+#endif
+
+static struct rpc_auth		seclabel_auth;
+static struct rpc_cred_cache	seclabel_cred_cache;
+static const struct rpc_credops	seclabel_credops;
+
+static struct rpc_auth *
+seclabel_create(struct rpc_clnt *clnt, rpc_authflavor_t flavor)
+{
+	dprintk("RPC:       creating SECLABEL authenticator for client %p\n",
+			clnt);
+	atomic_inc(&seclabel_auth.au_count);
+	return &seclabel_auth;
+}
+
+static void
+seclabel_destroy(struct rpc_auth *auth)
+{
+	dprintk("RPC:       destroying SECLABEL authenticator %p\n", auth);
+	rpcauth_clear_credcache(auth->au_credcache);
+}
+
+/*
+ * Lookup AUTH_SECLABEL creds for current process
+ */
+static struct rpc_cred *
+seclabel_lookup_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+{
+	return rpcauth_lookup_credcache(auth, acred, flags);
+}
+
+static struct rpc_cred *
+seclabel_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
+{
+	struct seclabel_cred	*cred;
+	unsigned int groups = 0;
+	unsigned int i;
+
+	dprintk("RPC:       allocating SECLABEL cred for uid %d gid %d\n",
+			acred->uid, acred->gid);
+
+	if (!(cred = kmalloc(sizeof(*cred), GFP_KERNEL)))
+		return ERR_PTR(-ENOMEM);
+
+	cred->slc_label = kmalloc(acred->label_len, GFP_KERNEL);
+	if (cred->slc_label == NULL) {
+		kfree(cred);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rpcauth_init_cred(&cred->slc_base, acred, auth, &seclabel_credops);
+	cred->slc_base.cr_flags = 1UL << RPCAUTH_CRED_UPTODATE;
+
+	if (acred->group_info != NULL)
+		groups = acred->group_info->ngroups;
+	if (groups > NFS_NGROUPS)
+		groups = NFS_NGROUPS;
+
+	cred->slc_gid = acred->gid;
+	for (i = 0; i < groups; i++)
+		cred->slc_gids[i] = GROUP_AT(acred->group_info, i);
+	if (i < NFS_NGROUPS)
+		cred->slc_gids[i] = NOGROUP;
+
+	cred->slc_label_len = acred->label_len;
+	memcpy(cred->slc_label, acred->label, acred->label_len);
+
+	return &cred->slc_base;
+}
+
+static void
+seclabel_free_cred(struct seclabel_cred *seclabel_cred)
+{
+	dprintk("RPC:       seclabel_free_cred %p\n", seclabel_cred);
+	security_release_secctx(seclabel_cred->slc_label,
+				seclabel_cred->slc_label_len);
+	kfree(seclabel_cred);
+}
+
+static void
+seclabel_free_cred_callback(struct rcu_head *head)
+{
+	struct seclabel_cred *seclabel_cred = container_of(head, struct seclabel_cred, slc_base.cr_rcu);
+	seclabel_free_cred(seclabel_cred);
+}
+
+static void
+seclabel_destroy_cred(struct rpc_cred *cred)
+{
+	call_rcu(&cred->cr_rcu, seclabel_free_cred_callback);
+}
+
+/*
+ * Match credentials against current process creds.
+ * The root_override argument takes care of cases where the caller may
+ * request root creds (e.g. for NFS swapping).
+ */
+static int
+seclabel_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
+{
+	struct seclabel_cred	*cred = container_of(rcred, struct seclabel_cred, slc_base);
+	unsigned int groups = 0;
+	unsigned int i;
+
+
+	if (acred->label_len != cred->slc_label_len)
+		return 0;
+	if (strcmp(acred->label, cred->slc_label) != 0)
+		return 0;
+	if (cred->slc_uid != acred->uid || cred->slc_gid != acred->gid)
+		return 0;
+
+	if (acred->group_info != NULL)
+		groups = acred->group_info->ngroups;
+	if (groups > NFS_NGROUPS)
+		groups = NFS_NGROUPS;
+	for (i = 0; i < groups ; i++)
+		if (cred->slc_gids[i] != GROUP_AT(acred->group_info, i))
+			return 0;
+	return 1;
+}
+
+/*
+ * Marshal credentials.
+ * Maybe we should keep a cached credential for performance reasons.
+ */
+static __be32 *
+seclabel_marshal(struct rpc_task *task, __be32 *p)
+{
+	struct rpc_clnt	*clnt = task->tk_client;
+	struct seclabel_cred	*cred = container_of(task->tk_msg.rpc_cred, struct seclabel_cred, slc_base);
+	__be32		*base, *hold;
+	int		i;
+
+	*p++ = htonl(RPC_AUTH_SECLABEL);
+	base = p++;
+	*p++ = htonl(jiffies/HZ);
+
+	/*
+	 * Copy the UTS nodename captured when the client was created.
+	 */
+	p = xdr_encode_array(p, clnt->cl_nodename, clnt->cl_nodelen);
+
+	/*
+	 * Label
+	 */
+	p = xdr_encode_array(p, cred->slc_label, cred->slc_label_len);
+
+	*p++ = htonl((u32) cred->slc_uid);
+	*p++ = htonl((u32) cred->slc_gid);
+	hold = p++;
+	for (i = 0; i < 16 && cred->slc_gids[i] != (gid_t) NOGROUP; i++)
+		*p++ = htonl((u32) cred->slc_gids[i]);
+	*hold = htonl(p - hold - 1);		/* gid array length */
+	*base = htonl((p - base - 1) << 2);	/* cred length */
+
+	*p++ = htonl(RPC_AUTH_NULL);
+	*p++ = htonl(0);
+
+	return p;
+}
+
+/*
+ * Refresh credentials. This is a no-op for AUTH_SECLABEL
+ */
+static int
+seclabel_refresh(struct rpc_task *task)
+{
+	set_bit(RPCAUTH_CRED_UPTODATE, &task->tk_msg.rpc_cred->cr_flags);
+	return 0;
+}
+
+static __be32 *
+seclabel_validate(struct rpc_task *task, __be32 *p)
+{
+	rpc_authflavor_t	flavor;
+	u32			size;
+
+	flavor = ntohl(*p++);
+	if (flavor != RPC_AUTH_NULL &&
+	    flavor != RPC_AUTH_SECLABEL &&
+	    flavor != RPC_AUTH_SHORT) {
+		printk("RPC: bad verf flavor: %u\n", flavor);
+		return NULL;
+	}
+
+	size = ntohl(*p++);
+	if (size > RPC_MAX_AUTH_SIZE) {
+		printk("RPC: giant verf size: %u\n", size);
+		return NULL;
+	}
+	task->tk_msg.rpc_cred->cr_auth->au_rslack = (size >> 2) + 2;
+	p += (size >> 2);
+
+	return p;
+}
+
+static const struct rpc_authops authseclabel_ops = {
+	.owner		= THIS_MODULE,
+	.au_flavor	= RPC_AUTH_SECLABEL,
+	.au_name	= "SECLABEL",
+	.create		= seclabel_create,
+	.destroy	= seclabel_destroy,
+	.lookup_cred	= seclabel_lookup_cred,
+	.crcreate	= seclabel_create_cred,
+};
+
+static struct rpc_cred_cache	seclabel_cred_cache = {
+};
+
+static struct rpc_auth		seclabel_auth = {
+	.au_cslack	= UNX_WRITESLACK,
+	.au_rslack	= 2,			/* assume AUTH_NULL verf */
+	.au_ops		= &authseclabel_ops,
+	.au_flavor	= RPC_AUTH_SECLABEL,
+	.au_count	= ATOMIC_INIT(0),
+	.au_credcache	= &seclabel_cred_cache,
+};
+
+static const struct rpc_credops seclabel_credops = {
+	.cr_name	= "AUTH_SECLABEL",
+	.crdestroy	= seclabel_destroy_cred,
+	.crbind		= rpcauth_generic_bind_cred,
+	.crmatch	= seclabel_match,
+	.crmarshal	= seclabel_marshal,
+	.crrefresh	= seclabel_refresh,
+	.crvalidate	= seclabel_validate,
+};
+
+/*
+ * Initialize RPCSEC_GSS module
+ */
+static int __init init_auth_seclabel(void)
+{
+	int err = 0;
+
+	err = rpcauth_register(&authseclabel_ops);
+	if (err)
+		goto out;
+
+	spin_lock_init(&seclabel_cred_cache.lock);
+
+	return 0;
+out:
+	rpcauth_unregister(&authseclabel_ops);
+	return err;
+}
+
+static void __exit exit_auth_seclabel(void)
+{
+        rpcauth_unregister(&authseclabel_ops);
+}
+
+MODULE_LICENSE("GPL");
+module_init(init_auth_seclabel)
+module_exit(exit_auth_seclabel)
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 5a32cb7..126eeb1 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -830,6 +830,7 @@ svc_process(struct svc_rqst *rqstp)
 	rqstp->rq_res.buflen = PAGE_SIZE;
 	rqstp->rq_res.tail[0].iov_base = NULL;
 	rqstp->rq_res.tail[0].iov_len = 0;
+	memset(&rqstp->rq_cred, 0, sizeof(struct svc_cred));
 	/* Will be turned off only in gss privacy case: */
 	rqstp->rq_splice_ok = 1;
 
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index 8a73cbb..ca8c99f 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -26,11 +26,17 @@
  */
 extern struct auth_ops svcauth_null;
 extern struct auth_ops svcauth_unix;
+#ifdef CONFIG_SECURITY
+extern struct auth_ops svcauth_seclabel;
+#endif
 
 static DEFINE_SPINLOCK(authtab_lock);
 static struct auth_ops	*authtab[RPC_AUTH_MAXFLAVOR] = {
 	[0] = &svcauth_null,
 	[1] = &svcauth_unix,
+#ifdef CONFIG_SECURITY
+	[RPC_AUTH_SECLABEL] = &svcauth_seclabel,
+#endif
 };
 
 int
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index f24800f..4dfecf0 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -31,6 +31,9 @@ struct unix_domain {
 };
 
 extern struct auth_ops svcauth_unix;
+#ifdef CONFIG_SECURITY
+extern struct auth_ops svcauth_seclabel;
+#endif
 
 struct auth_domain *unix_domain_find(char *name)
 {
@@ -43,7 +46,11 @@ struct auth_domain *unix_domain_find(char *name)
 			if (new && rv != &new->h)
 				auth_domain_put(&new->h);
 
-			if (rv->flavour != &svcauth_unix) {
+			if (rv->flavour != &svcauth_unix
+#ifdef CONFIG_SECURITY
+			    && rv->flavour != &svcauth_seclabel
+#endif
+			   ) {
 				auth_domain_put(rv);
 				return NULL;
 			}
@@ -358,7 +365,11 @@ int auth_unix_add_addr(struct in6_addr *addr, struct auth_domain *dom)
 	struct unix_domain *udom;
 	struct ip_map *ipmp;
 
-	if (dom->flavour != &svcauth_unix)
+	if (dom->flavour != &svcauth_unix
+#ifdef CONFIG_SECURITY
+	    && dom->flavour != &svcauth_seclabel
+#endif
+	   )
 		return -EINVAL;
 	udom = container_of(dom, struct unix_domain, h);
 	ipmp = ip_map_lookup("nfsd", addr);
@@ -374,6 +385,11 @@ int auth_unix_forget_old(struct auth_domain *dom)
 {
 	struct unix_domain *udom;
 
+	if (dom->flavour != &svcauth_unix
+#ifdef CONFIG_SECURITY
+	    && dom->flavour != &svcauth_seclabel
+#endif
+	   )
 	if (dom->flavour != &svcauth_unix)
 		return -EINVAL;
 	udom = container_of(dom, struct unix_domain, h);
@@ -873,3 +889,80 @@ struct auth_ops svcauth_unix = {
 	.set_client	= svcauth_unix_set_client,
 };
 
+#ifdef CONFIG_SECURITY
+static int
+svcauth_seclabel_accept(struct svc_rqst *rqstp, __be32 *authp)
+{
+	struct kvec	*argv = &rqstp->rq_arg.head[0];
+	struct kvec	*resv = &rqstp->rq_res.head[0];
+	struct svc_cred	*cred = &rqstp->rq_cred;
+	u32		slen, i;
+	int		len   = argv->iov_len;
+
+	cred->cr_group_info = NULL;
+	rqstp->rq_client = NULL;
+
+	if ((len -= 3*4) < 0)
+		return SVC_GARBAGE;
+
+	svc_getu32(argv);			/* length */
+	svc_getu32(argv);			/* time stamp */
+	slen = XDR_QUADLEN(svc_getnl(argv));	/* machname length */
+	if (slen > 64 || (len -= (slen + 3)*4) < 0)
+		goto badcred;
+	argv->iov_base = (void*)((__be32*)argv->iov_base + slen);	/* skip machname */
+	argv->iov_len -= slen*4;
+
+	slen = svc_getnl(argv);			/* security label length */
+	/* XXX: sanity check label... */
+	cred->cr_label = argv->iov_base;
+	cred->cr_label_len = slen;
+	argv->iov_base = (void*)((__be32*)argv->iov_base + XDR_QUADLEN(slen));
+	argv->iov_len -= slen;
+
+	cred->cr_uid = svc_getnl(argv);		/* uid */
+	cred->cr_gid = svc_getnl(argv);		/* gid */
+	slen = svc_getnl(argv);			/* gids length */
+	if (slen > 16 || (len -= (slen + 2)*4) < 0)
+		goto badcred;
+	if (unix_gid_find(cred->cr_uid, &cred->cr_group_info, rqstp)
+	    == -EAGAIN)
+		return SVC_DROP;
+	if (cred->cr_group_info == NULL) {
+		cred->cr_group_info = groups_alloc(slen);
+		if (cred->cr_group_info == NULL)
+			return SVC_DROP;
+		for (i = 0; i < slen; i++)
+			GROUP_AT(cred->cr_group_info, i) = svc_getnl(argv);
+	} else {
+		for (i = 0; i < slen ; i++)
+			svc_getnl(argv);
+	}
+	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
+		*authp = rpc_autherr_badverf;
+		return SVC_DENIED;
+	}
+
+	/* Put NULL verifier */
+	svc_putnl(resv, RPC_AUTH_NULL);
+	svc_putnl(resv, 0);
+
+	rqstp->rq_flavor = RPC_AUTH_SECLABEL;
+	return SVC_OK;
+
+badcred:
+	*authp = rpc_autherr_badcred;
+	return SVC_DENIED;
+}
+
+struct auth_ops svcauth_seclabel = {
+	.name		= "seclabel",
+	.owner		= THIS_MODULE,
+	.flavour	= RPC_AUTH_SECLABEL,
+	.accept 	= svcauth_seclabel_accept,
+	.release	= svcauth_unix_release,
+	.domain_release	= svcauth_unix_domain_release,
+	.set_client	= svcauth_unix_set_client,
+};
+#endif
+
diff --git a/security/security.c b/security/security.c
index 1955094..2337d7f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -841,11 +841,13 @@ int security_getprocattr(struct task_struct *p, char *name, char **value)
 {
 	return security_ops->getprocattr(p, name, value);
 }
+EXPORT_SYMBOL(security_getprocattr);
 
 int security_setprocattr(struct task_struct *p, char *name, void *value, size_t size)
 {
 	return security_ops->setprocattr(p, name, value, size);
 }
+EXPORT_SYMBOL(security_setprocattr);
 
 int security_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6919766..05a10be 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5298,7 +5298,7 @@ static int selinux_setprocattr(struct task_struct *p,
 			return -EINVAL;
 
 		/* Only allow single threaded processes to change context */
-		if (atomic_read(&p->mm->mm_users) != 1) {
+		if (p->mm && atomic_read(&p->mm->mm_users) != 1) {
 			struct task_struct *g, *t;
 			struct mm_struct *mm = p->mm;
 			read_lock(&tasklist_lock);
-- 
1.5.5.1

