Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXGJCZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXGJCZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbXGJCZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:25:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:34029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760930AbXGJCZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:25:04 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:24:58 +1000
Message-Id: <1070710022458.13206@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 008 of 20] knfsd: nfsd: set rq_client to ip-address-determined-domain
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

We want it to be possible for users to restrict exports both by IP
address and by pseudoflavor.  The pseudoflavor information has
previously been passed using special auth_domains stored in the
rq_client field.  After the preceding patch that stored the pseudoflavor
in rq_pflavor, that's now superfluous; so now we use rq_client for the
ip information, as auth_null and auth_unix do.

However, we keep around the special auth_domain in the rq_gssclient
field for backwards compatibility purposes, so we can still do upcalls
using the old "gss/pseudoflavor" auth_domain if upcalls using the unix
domain to give us an appropriate export.  This allows us to continue
supporting old mountd.

In fact, for this first patch, we always use the "gss/pseudoflavor"
auth_domain (and only it) if it is available; thus rq_client is ignored
in the auth_gss case, and this patch on its own makes no change in
behavior; that will be left to later patches.

Note on idmap: I'm almost tempted to just replace the auth_domain in the
idmap upcall by a dummy value--no version of idmapd has ever used it,
and it's unlikely anyone really wants to perform idmapping differently
depending on the where the client is (they may want to perform
*credential* mapping differently, but that's a different matter--the
idmapper just handles id's used in getattr and setattr).  But I'm
updating the idmapd code anyway, just out of general
backwards-compatibility paranoia.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c                  |   15 +++++++++++----
 ./fs/nfsd/nfs4idmap.c               |   13 +++++++++++--
 ./fs/nfsd/nfsfh.c                   |    2 --
 ./include/linux/sunrpc/svc.h        |    1 +
 ./include/linux/sunrpc/svcauth.h    |    1 +
 ./net/sunrpc/auth_gss/svcauth_gss.c |   21 ++++++++++++++++++---
 ./net/sunrpc/svcauth_unix.c         |    4 +++-
 7 files changed, 45 insertions(+), 12 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-07-10 11:34:22.000000000 +1000
+++ ./fs/nfsd/export.c	2007-07-10 11:35:37.000000000 +1000
@@ -1237,21 +1237,28 @@ struct svc_export *
 rqst_exp_get_by_name(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
-	return exp_get_by_name(rqstp->rq_client, mnt, dentry,
-						&rqstp->rq_chandle);
+	struct auth_domain *clp;
+
+	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
+	return exp_get_by_name(clp, mnt, dentry, &rqstp->rq_chandle);
 }
 
 struct svc_export *
 rqst_exp_find(struct svc_rqst *rqstp, int fsid_type, u32 *fsidv)
 {
-	return exp_find(rqstp->rq_client, fsid_type, fsidv,
-						&rqstp->rq_chandle);
+	struct auth_domain *clp;
+
+	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
+	return exp_find(clp, fsid_type, fsidv, &rqstp->rq_chandle);
 }
 
 struct svc_export *
 rqst_exp_parent(struct svc_rqst *rqstp, struct vfsmount *mnt,
 		struct dentry *dentry)
 {
+	struct auth_domain *clp;
+
+	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
 	return exp_parent(rqstp->rq_client, mnt, dentry, &rqstp->rq_chandle);
 }
 

diff .prev/fs/nfsd/nfs4idmap.c ./fs/nfsd/nfs4idmap.c
--- .prev/fs/nfsd/nfs4idmap.c	2007-07-10 11:19:57.000000000 +1000
+++ ./fs/nfsd/nfs4idmap.c	2007-07-10 11:35:37.000000000 +1000
@@ -587,6 +587,15 @@ idmap_lookup(struct svc_rqst *rqstp,
 	return ret;
 }
 
+static char *
+rqst_authname(struct svc_rqst *rqstp)
+{
+	struct auth_domain *clp;
+
+	clp = rqstp->rq_gssclient ? rqstp->rq_gssclient : rqstp->rq_client;
+	return clp->name;
+}
+
 static int
 idmap_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen,
 		uid_t *id)
@@ -600,7 +609,7 @@ idmap_name_to_id(struct svc_rqst *rqstp,
 		return -EINVAL;
 	memcpy(key.name, name, namelen);
 	key.name[namelen] = '\0';
-	strlcpy(key.authname, rqstp->rq_client->name, sizeof(key.authname));
+	strlcpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
 	ret = idmap_lookup(rqstp, nametoid_lookup, &key, &nametoid_cache, &item);
 	if (ret == -ENOENT)
 		ret = -ESRCH; /* nfserr_badname */
@@ -620,7 +629,7 @@ idmap_id_to_name(struct svc_rqst *rqstp,
 	};
 	int ret;
 
-	strlcpy(key.authname, rqstp->rq_client->name, sizeof(key.authname));
+	strlcpy(key.authname, rqst_authname(rqstp), sizeof(key.authname));
 	ret = idmap_lookup(rqstp, idtoname_lookup, &key, &idtoname_cache, &item);
 	if (ret == -ENOENT)
 		return sprintf(name, "%u", id);

diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
--- .prev/fs/nfsd/nfsfh.c	2007-07-10 11:34:22.000000000 +1000
+++ ./fs/nfsd/nfsfh.c	2007-07-10 11:35:37.000000000 +1000
@@ -120,8 +120,6 @@ fh_verify(struct svc_rqst *rqstp, struct
 		int data_left = fh->fh_size/4;
 
 		error = nfserr_stale;
-		if (rqstp->rq_client == NULL)
-			goto out;
 		if (rqstp->rq_vers > 2)
 			error = nfserr_badhandle;
 		if (rqstp->rq_vers == 4 && fh->fh_size == 0)

diff .prev/include/linux/sunrpc/svcauth.h ./include/linux/sunrpc/svcauth.h
--- .prev/include/linux/sunrpc/svcauth.h	2007-07-10 11:19:57.000000000 +1000
+++ ./include/linux/sunrpc/svcauth.h	2007-07-10 11:35:37.000000000 +1000
@@ -127,6 +127,7 @@ extern struct auth_domain *auth_unix_loo
 extern int auth_unix_forget_old(struct auth_domain *dom);
 extern void svcauth_unix_purge(void);
 extern void svcauth_unix_info_release(void *);
+extern int svcauth_unix_set_client(struct svc_rqst *rqstp);
 
 static inline unsigned long hash_str(char *name, int bits)
 {

diff .prev/include/linux/sunrpc/svc.h ./include/linux/sunrpc/svc.h
--- .prev/include/linux/sunrpc/svc.h	2007-07-10 11:27:13.000000000 +1000
+++ ./include/linux/sunrpc/svc.h	2007-07-10 11:35:37.000000000 +1000
@@ -249,6 +249,7 @@ struct svc_rqst {
 						 */
 	/* Catering to nfsd */
 	struct auth_domain *	rq_client;	/* RPC peer info */
+	struct auth_domain *	rq_gssclient;	/* "gss/"-style peer info */
 	struct svc_cacherep *	rq_cacherep;	/* cache info */
 	struct knfsd_fh *	rq_reffh;	/* Referrence filehandle, used to
 						 * determine what device number

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-07-10 11:27:13.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-07-10 11:35:37.000000000 +1000
@@ -927,10 +927,23 @@ svcauth_gss_set_client(struct svc_rqst *
 	struct gss_svc_data *svcdata = rqstp->rq_auth_data;
 	struct rsc *rsci = svcdata->rsci;
 	struct rpc_gss_wire_cred *gc = &svcdata->clcred;
+	int stat;
 
-	rqstp->rq_client = find_gss_auth_domain(rsci->mechctx, gc->gc_svc);
-	if (rqstp->rq_client == NULL)
+	/*
+	 * A gss export can be specified either by:
+	 * 	export	*(sec=krb5,rw)
+	 * or by
+	 * 	export gss/krb5(rw)
+	 * The latter is deprecated; but for backwards compatibility reasons
+	 * the nfsd code will still fall back on trying it if the former
+	 * doesn't work; so we try to make both available to nfsd, below.
+	 */
+	rqstp->rq_gssclient = find_gss_auth_domain(rsci->mechctx, gc->gc_svc);
+	if (rqstp->rq_gssclient == NULL)
 		return SVC_DENIED;
+	stat = svcauth_unix_set_client(rqstp);
+	if (stat == SVC_DROP)
+		return stat;
 	return SVC_OK;
 }
 
@@ -1102,7 +1115,6 @@ svcauth_gss_accept(struct svc_rqst *rqst
 			svc_putnl(resv, GSS_SEQ_WIN);
 			if (svc_safe_putnetobj(resv, &rsip->out_token))
 				goto drop;
-			rqstp->rq_client = NULL;
 		}
 		goto complete;
 	case RPC_GSS_PROC_DESTROY:
@@ -1333,6 +1345,9 @@ out_err:
 	if (rqstp->rq_client)
 		auth_domain_put(rqstp->rq_client);
 	rqstp->rq_client = NULL;
+	if (rqstp->rq_gssclient)
+		auth_domain_put(rqstp->rq_gssclient);
+	rqstp->rq_gssclient = NULL;
 	if (rqstp->rq_cred.cr_group_info)
 		put_group_info(rqstp->rq_cred.cr_group_info);
 	rqstp->rq_cred.cr_group_info = NULL;

diff .prev/net/sunrpc/svcauth_unix.c ./net/sunrpc/svcauth_unix.c
--- .prev/net/sunrpc/svcauth_unix.c	2007-07-10 11:27:13.000000000 +1000
+++ ./net/sunrpc/svcauth_unix.c	2007-07-10 11:35:37.000000000 +1000
@@ -638,7 +638,7 @@ static int unix_gid_find(uid_t uid, stru
 	}
 }
 
-static int
+int
 svcauth_unix_set_client(struct svc_rqst *rqstp)
 {
 	struct sockaddr_in *sin = svc_addr_in(rqstp);
@@ -673,6 +673,8 @@ svcauth_unix_set_client(struct svc_rqst 
 	return SVC_OK;
 }
 
+EXPORT_SYMBOL(svcauth_unix_set_client);
+
 static int
 svcauth_null_accept(struct svc_rqst *rqstp, __be32 *authp)
 {
