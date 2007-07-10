Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbXGJC3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbXGJC3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762558AbXGJC2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:10 -0400
Received: from ns.suse.de ([195.135.220.2]:38304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762303AbXGJC2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:07 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:28:02 +1000
Message-Id: <1070710022802.13577@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Andy Adamson <andros@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Usha Ketineni <uketinen@us.ibm.com>
Subject: [PATCH 017 of 20] knfsd: nfsd4: implement secinfo
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andy Adamson <andros@citi.umich.edu>

Implement the secinfo operation.

(Thanks to Usha Ketineni wrote an earlier version of this support.)

Cc: Usha Ketineni <uketinen@us.ibm.com>
Signed-off-by: Andy Adamson <andros@citi.umich.edu>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4proc.c        |   28 ++++++++++++++++
 ./fs/nfsd/nfs4xdr.c         |   75 ++++++++++++++++++++++++++++++++++++++++++++
 ./include/linux/nfsd/nfsd.h |    3 +
 ./include/linux/nfsd/xdr4.h |    7 ++++
 4 files changed, 113 insertions(+)

diff .prev/fs/nfsd/nfs4proc.c ./fs/nfsd/nfs4proc.c
--- .prev/fs/nfsd/nfs4proc.c	2007-07-10 11:33:32.000000000 +1000
+++ ./fs/nfsd/nfs4proc.c	2007-07-10 11:51:37.000000000 +1000
@@ -47,6 +47,7 @@
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
 #include <linux/nfs4_acl.h>
+#include <linux/sunrpc/gss_api.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
@@ -610,6 +611,30 @@ nfsd4_rename(struct svc_rqst *rqstp, str
 }
 
 static __be32
+nfsd4_secinfo(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
+	      struct nfsd4_secinfo *secinfo)
+{
+	struct svc_fh resfh;
+	struct svc_export *exp;
+	struct dentry *dentry;
+	__be32 err;
+
+	fh_init(&resfh, NFS4_FHSIZE);
+	err = nfsd_lookup_dentry(rqstp, &cstate->current_fh,
+				    secinfo->si_name, secinfo->si_namelen,
+				    &exp, &dentry);
+	if (err)
+		return err;
+	if (dentry->d_inode == NULL) {
+		exp_put(exp);
+		err = nfserr_noent;
+	} else
+		secinfo->si_exp = exp;
+	dput(dentry);
+	return err;
+}
+
+static __be32
 nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	      struct nfsd4_setattr *setattr)
 {
@@ -1008,6 +1033,9 @@ static struct nfsd4_operation nfsd4_ops[
 	[OP_SAVEFH] = {
 		.op_func = (nfsd4op_func)nfsd4_savefh,
 	},
+	[OP_SECINFO] = {
+		.op_func = (nfsd4op_func)nfsd4_secinfo,
+	},
 	[OP_SETATTR] = {
 		.op_func = (nfsd4op_func)nfsd4_setattr,
 	},

diff .prev/fs/nfsd/nfs4xdr.c ./fs/nfsd/nfs4xdr.c
--- .prev/fs/nfsd/nfs4xdr.c	2007-07-10 11:33:32.000000000 +1000
+++ ./fs/nfsd/nfs4xdr.c	2007-07-10 11:52:23.000000000 +1000
@@ -56,6 +56,7 @@
 #include <linux/nfsd_idmap.h>
 #include <linux/nfs4.h>
 #include <linux/nfs4_acl.h>
+#include <linux/sunrpc/gss_api.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -819,6 +820,23 @@ nfsd4_decode_renew(struct nfsd4_compound
 }
 
 static __be32
+nfsd4_decode_secinfo(struct nfsd4_compoundargs *argp,
+		     struct nfsd4_secinfo *secinfo)
+{
+	DECODE_HEAD;
+
+	READ_BUF(4);
+	READ32(secinfo->si_namelen);
+	READ_BUF(secinfo->si_namelen);
+	SAVEMEM(secinfo->si_name, secinfo->si_namelen);
+	status = check_filename(secinfo->si_name, secinfo->si_namelen,
+								nfserr_noent);
+	if (status)
+		return status;
+	DECODE_TAIL;
+}
+
+static __be32
 nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *setattr)
 {
 	DECODE_HEAD;
@@ -1131,6 +1149,9 @@ nfsd4_decode_compound(struct nfsd4_compo
 		case OP_SAVEFH:
 			op->status = nfs_ok;
 			break;
+		case OP_SECINFO:
+			op->status = nfsd4_decode_secinfo(argp, &op->u.secinfo);
+			break;
 		case OP_SETATTR:
 			op->status = nfsd4_decode_setattr(argp, &op->u.setattr);
 			break;
@@ -1847,11 +1868,19 @@ nfsd4_encode_dirent_fattr(struct nfsd4_r
 	if (d_mountpoint(dentry)) {
 		int err;
 
+		/*
+		 * Why the heck aren't we just using nfsd_lookup??
+		 * Different "."/".." handling?  Something else?
+		 * At least, add a comment here to explain....
+		 */
 		err = nfsd_cross_mnt(cd->rd_rqstp, &dentry, &exp);
 		if (err) {
 			nfserr = nfserrno(err);
 			goto out_put;
 		}
+		nfserr = check_nfsd_access(exp, cd->rd_rqstp);
+		if (nfserr)
+			goto out_put;
 
 	}
 	nfserr = nfsd4_encode_fattr(NULL, exp, dentry, p, buflen, cd->rd_bmval,
@@ -2419,6 +2448,49 @@ nfsd4_encode_rename(struct nfsd4_compoun
 	}
 }
 
+static void
+nfsd4_encode_secinfo(struct nfsd4_compoundres *resp, int nfserr,
+		     struct nfsd4_secinfo *secinfo)
+{
+	int i = 0;
+	struct svc_export *exp = secinfo->si_exp;
+	ENCODE_HEAD;
+
+	if (nfserr)
+		goto out;
+	RESERVE_SPACE(4);
+	WRITE32(exp->ex_nflavors);
+	ADJUST_ARGS();
+	for (i = 0; i < exp->ex_nflavors; i++) {
+		u32 flav = exp->ex_flavors[i].pseudoflavor;
+		struct gss_api_mech *gm = gss_mech_get_by_pseudoflavor(flav);
+
+		if (gm) {
+			RESERVE_SPACE(4);
+			WRITE32(RPC_AUTH_GSS);
+			ADJUST_ARGS();
+			RESERVE_SPACE(4 + gm->gm_oid.len);
+			WRITE32(gm->gm_oid.len);
+			WRITEMEM(gm->gm_oid.data, gm->gm_oid.len);
+			ADJUST_ARGS();
+			RESERVE_SPACE(4);
+			WRITE32(0); /* qop */
+			ADJUST_ARGS();
+			RESERVE_SPACE(4);
+			WRITE32(gss_pseudoflavor_to_service(gm, flav));
+			ADJUST_ARGS();
+			gss_mech_put(gm);
+		} else {
+			RESERVE_SPACE(4);
+			WRITE32(flav);
+			ADJUST_ARGS();
+		}
+	}
+out:
+	if (exp)
+		exp_put(exp);
+}
+
 /*
  * The SETATTR encode routine is special -- it always encodes a bitmap,
  * regardless of the error status.
@@ -2559,6 +2631,9 @@ nfsd4_encode_operation(struct nfsd4_comp
 		break;
 	case OP_SAVEFH:
 		break;
+	case OP_SECINFO:
+		nfsd4_encode_secinfo(resp, op->status, &op->u.secinfo);
+		break;
 	case OP_SETATTR:
 		nfsd4_encode_setattr(resp, op->status, &op->u.setattr);
 		break;

diff .prev/include/linux/nfsd/nfsd.h ./include/linux/nfsd/nfsd.h
--- .prev/include/linux/nfsd/nfsd.h	2007-07-10 11:40:31.000000000 +1000
+++ ./include/linux/nfsd/nfsd.h	2007-07-10 11:51:19.000000000 +1000
@@ -71,6 +71,9 @@ int		nfsd_cross_mnt(struct svc_rqst *rqs
 		                struct svc_export **expp);
 __be32		nfsd_lookup(struct svc_rqst *, struct svc_fh *,
 				const char *, int, struct svc_fh *);
+__be32		 nfsd_lookup_dentry(struct svc_rqst *, struct svc_fh *,
+				const char *, int,
+				struct svc_export **, struct dentry **);
 __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
 				struct iattr *, int, time_t);
 #ifdef CONFIG_NFSD_V4

diff .prev/include/linux/nfsd/xdr4.h ./include/linux/nfsd/xdr4.h
--- .prev/include/linux/nfsd/xdr4.h	2007-07-10 11:19:53.000000000 +1000
+++ ./include/linux/nfsd/xdr4.h	2007-07-10 11:51:19.000000000 +1000
@@ -293,6 +293,12 @@ struct nfsd4_rename {
 	struct nfsd4_change_info  rn_tinfo; /* response */
 };
 
+struct nfsd4_secinfo {
+	u32 si_namelen;					/* request */
+	char *si_name;					/* request */
+	struct svc_export *si_exp;			/* response */
+};
+
 struct nfsd4_setattr {
 	stateid_t	sa_stateid;         /* request */
 	u32		sa_bmval[2];        /* request */
@@ -365,6 +371,7 @@ struct nfsd4_op {
 		struct nfsd4_remove		remove;
 		struct nfsd4_rename		rename;
 		clientid_t			renew;
+		struct nfsd4_secinfo		secinfo;
 		struct nfsd4_setattr		setattr;
 		struct nfsd4_setclientid	setclientid;
 		struct nfsd4_setclientid_confirm setclientid_confirm;
