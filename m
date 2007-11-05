Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXKEQdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXKEQdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXKEQdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:33:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:39261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbXKEQdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:33:32 -0500
Message-Id: <20071105163234.240126105@hasse.suse.de>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 17:32:39 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: bfields@fieldses.org, neilb@suse.de
Subject: [PATCH 7/9] Use struct path in struct svc_expkey
References: <20071105163232.550298985@hasse.suse.de>
Content-Disposition: inline; filename=vfs/nfsd-svc_expkey_use_struct_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm embedding struct path into struct svc_expkey.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/nfsd/export.c            |   30 +++++++++++++-----------------
 include/linux/nfsd/export.h |    3 +--
 2 files changed, 14 insertions(+), 19 deletions(-)

Index: b/fs/nfsd/export.c
===================================================================
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -63,10 +63,8 @@ static void expkey_put(struct kref *ref)
 	struct svc_expkey *key = container_of(ref, struct svc_expkey, h.ref);
 
 	if (test_bit(CACHE_VALID, &key->h.flags) &&
-	    !test_bit(CACHE_NEGATIVE, &key->h.flags)) {
-		dput(key->ek_dentry);
-		mntput(key->ek_mnt);
-	}
+	    !test_bit(CACHE_NEGATIVE, &key->h.flags))
+		path_put(&key->ek_path);
 	auth_domain_put(key->ek_client);
 	kfree(key);
 }
@@ -169,9 +167,8 @@ static int expkey_parse(struct cache_det
 			goto out;
 
 		dprintk("Found the path %s\n", buf);
-		key.ek_mnt = nd.path.mnt;
-		key.ek_dentry = nd.path.dentry;
-		
+		key.ek_path = nd.path;
+
 		ek = svc_expkey_update(&key, ek);
 		if (ek)
 			cache_put(&ek->h, &svc_expkey_cache);
@@ -206,7 +203,7 @@ static int expkey_show(struct seq_file *
 	if (test_bit(CACHE_VALID, &h->flags) && 
 	    !test_bit(CACHE_NEGATIVE, &h->flags)) {
 		seq_printf(m, " ");
-		seq_path(m, ek->ek_mnt, ek->ek_dentry, "\\ \t\n");
+		seq_path(m, ek->ek_path.mnt, ek->ek_path.dentry, "\\ \t\n");
 	}
 	seq_printf(m, "\n");
 	return 0;
@@ -243,8 +240,8 @@ static inline void expkey_update(struct 
 	struct svc_expkey *new = container_of(cnew, struct svc_expkey, h);
 	struct svc_expkey *item = container_of(citem, struct svc_expkey, h);
 
-	new->ek_mnt = mntget(item->ek_mnt);
-	new->ek_dentry = dget(item->ek_dentry);
+	new->ek_path = item->ek_path;
+	path_get(&item->ek_path);
 }
 
 static struct cache_head *expkey_alloc(void)
@@ -814,8 +811,7 @@ static int exp_set_key(svc_client *clp, 
 	key.ek_client = clp;
 	key.ek_fsidtype = fsid_type;
 	memcpy(key.ek_fsid, fsidv, key_len(fsid_type));
-	key.ek_mnt = exp->ex_path.mnt;
-	key.ek_dentry = exp->ex_path.dentry;
+	key.ek_path = exp->ex_path;
 	key.h.expiry_time = NEVER;
 	key.h.flags = 0;
 
@@ -864,7 +860,7 @@ static svc_export *exp_get_by_name(svc_c
 {
 	struct svc_export *exp, key;
 	int err;
-	
+
 	if (!clp)
 		return ERR_PTR(-ENOENT);
 
@@ -1036,9 +1032,9 @@ exp_export(struct nfsctl_export *nxp)
 	/* must make sure there won't be an ex_fsid clash */
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (!IS_ERR(fsid_key = exp_get_fsid_key(clp, nxp->ex_dev))) &&
-	    fsid_key->ek_mnt &&
-	    (fsid_key->ek_mnt != nd.path.mnt ||
-	     fsid_key->ek_dentry != nd.path.dentry))
+	    fsid_key->ek_path.mnt &&
+	    (fsid_key->ek_path.mnt != nd.path.mnt ||
+	     fsid_key->ek_path.dentry != nd.path.dentry))
 		goto finish;
 
 	if (!IS_ERR(exp)) {
@@ -1219,7 +1215,7 @@ static struct svc_export *exp_find(struc
 	if (IS_ERR(ek))
 		return ERR_PTR(PTR_ERR(ek));
 
-	exp = exp_get_by_name(clp, ek->ek_mnt, ek->ek_dentry, reqp);
+	exp = exp_get_by_name(clp, ek->ek_path.mnt, ek->ek_path.dentry, reqp);
 	cache_put(&ek->h, &svc_expkey_cache);
 
 	if (IS_ERR(exp))
Index: b/include/linux/nfsd/export.h
===================================================================
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -106,8 +106,7 @@ struct svc_expkey {
 	int			ek_fsidtype;
 	u32			ek_fsid[6];
 
-	struct vfsmount *	ek_mnt;
-	struct dentry *		ek_dentry;
+	struct path		ek_path;
 };
 
 #define EX_SECURE(exp)		(!((exp)->ex_flags & NFSEXP_INSECURE_PORT))


