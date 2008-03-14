Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYCNXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYCNXmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYCNXmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:42:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36496 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYCNXmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:42:09 -0400
Date: Fri, 14 Mar 2008 19:42:05 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080314234205.GO2119@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org> <20080314195303.GA4390@ics.muni.cz> <20080314200510.GL2119@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314200510.GL2119@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 04:05:10PM -0400, bfields wrote:
> I find that a little contorted.  So I'll go ahead and submit this small
> patch to 2.6.25 and stable now (I have since managed to reproduce what I
> believe is your bug, though my symptoms were a little different), and
> then submit to 2.6.26 some cleanup which makes this more understandable,

Here's an attempt.  We could break up fh_verify even more, though.--b.

>From ce83cbd34a40153aed8bf559f24576a06e3e378a Mon Sep 17 00:00:00 2001
From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 14 Mar 2008 17:51:12 -0400
Subject: [PATCH] nfsd: move most of fh_verify to separate function

Move the code that actually parses the filehandle and looks up the
dentry and export to a separate function.  This simplifies the reference
counting a little and moves fh_verify() a little closer to the kernel
ideal of small, minimally-indentended functions.  Clean up a few other
minor style sins along the way.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/nfsfh.c |  223 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 118 insertions(+), 105 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 3e6b3f4..fc1d98b 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -112,6 +112,119 @@ static __be32 nfsd_setuser_and_check_port(struct svc_rqst *rqstp,
 	return nfserrno(nfsd_setuser(rqstp, exp));
 }
 
+static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
+{
+	struct knfsd_fh	*fh = &fhp->fh_handle;
+	struct fid *fid = NULL, sfid;
+	struct svc_export *exp;
+	struct dentry *dentry;
+	int fileid_type;
+	int data_left = fh->fh_size/4;
+	__be32 error;
+
+	error = nfserr_stale;
+	if (rqstp->rq_vers > 2)
+		error = nfserr_badhandle;
+	if (rqstp->rq_vers == 4 && fh->fh_size == 0)
+		return nfserr_nofilehandle;
+
+	if (fh->fh_version == 1) {
+		int len;
+
+		if (--data_left < 0)
+			return error;
+		if (fh->fh_auth_type != 0)
+			return error;
+		len = key_len(fh->fh_fsid_type) / 4;
+		if (len == 0)
+			return error;
+		if  (fh->fh_fsid_type == FSID_MAJOR_MINOR) {
+			/* deprecated, convert to type 3 */
+			len = key_len(FSID_ENCODE_DEV)/4;
+			fh->fh_fsid_type = FSID_ENCODE_DEV;
+			fh->fh_fsid[0] = new_encode_dev(MKDEV(ntohl(fh->fh_fsid[0]), ntohl(fh->fh_fsid[1])));
+			fh->fh_fsid[1] = fh->fh_fsid[2];
+		}
+		data_left -= len;
+		if (data_left < 0)
+			return error;
+		exp = rqst_exp_find(rqstp, fh->fh_fsid_type, fh->fh_auth);
+		fid = (struct fid *)(fh->fh_auth + len);
+	} else {
+		__u32 tfh[2];
+		dev_t xdev;
+		ino_t xino;
+
+		if (fh->fh_size != NFS_FHSIZE)
+			return error;
+		/* assume old filehandle format */
+		xdev = old_decode_dev(fh->ofh_xdev);
+		xino = u32_to_ino_t(fh->ofh_xino);
+		mk_fsid(FSID_DEV, tfh, xdev, xino, 0, NULL);
+		exp = rqst_exp_find(rqstp, FSID_DEV, tfh);
+	}
+
+	error = nfserr_stale;
+	if (PTR_ERR(exp) == -ENOENT)
+		return error;
+
+	if (IS_ERR(exp))
+		return nfserrno(PTR_ERR(exp));
+
+	error = nfsd_setuser_and_check_port(rqstp, exp);
+	if (error)
+		goto out;
+
+	/*
+	 * Look up the dentry using the NFS file handle.
+	 */
+	error = nfserr_stale;
+	if (rqstp->rq_vers > 2)
+		error = nfserr_badhandle;
+
+	if (fh->fh_version != 1) {
+		sfid.i32.ino = fh->ofh_ino;
+		sfid.i32.gen = fh->ofh_generation;
+		sfid.i32.parent_ino = fh->ofh_dirino;
+		fid = &sfid;
+		data_left = 3;
+		if (fh->ofh_dirino == 0)
+			fileid_type = FILEID_INO32_GEN;
+		else
+			fileid_type = FILEID_INO32_GEN_PARENT;
+	} else
+		fileid_type = fh->fh_fileid_type;
+
+	if (fileid_type == FILEID_ROOT)
+		dentry = dget(exp->ex_path.dentry);
+	else {
+		dentry = exportfs_decode_fh(exp->ex_path.mnt, fid,
+				data_left, fileid_type,
+				nfsd_acceptable, exp);
+	}
+	if (dentry == NULL)
+		goto out;
+	if (IS_ERR(dentry)) {
+		if (PTR_ERR(dentry) != -EINVAL)
+			error = nfserrno(PTR_ERR(dentry));
+		goto out;
+	}
+
+	if (S_ISDIR(dentry->d_inode->i_mode) &&
+			(dentry->d_flags & DCACHE_DISCONNECTED)) {
+		printk("nfsd: find_fh_dentry returned a DISCONNECTED directory: %s/%s\n",
+				dentry->d_parent->d_name.name, dentry->d_name.name);
+	}
+
+	fhp->fh_dentry = dentry;
+	fhp->fh_export = exp;
+	nfsd_nr_verified++;
+	return 0;
+out:
+	exp_put(exp);
+	return error;
+}
+
 /*
  * Perform sanity checks on the dentry in a client's file handle.
  *
@@ -124,115 +237,18 @@ static __be32 nfsd_setuser_and_check_port(struct svc_rqst *rqstp,
 __be32
 fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 {
-	struct knfsd_fh	*fh = &fhp->fh_handle;
-	struct svc_export *exp = NULL;
+	struct svc_export *exp;
 	struct dentry	*dentry;
-	__be32		error = 0;
+	__be32		error;
 
 	dprintk("nfsd: fh_verify(%s)\n", SVCFH_fmt(fhp));
 
 	if (!fhp->fh_dentry) {
-		struct fid *fid = NULL, sfid;
-		int fileid_type;
-		int data_left = fh->fh_size/4;
-
-		error = nfserr_stale;
-		if (rqstp->rq_vers > 2)
-			error = nfserr_badhandle;
-		if (rqstp->rq_vers == 4 && fh->fh_size == 0)
-			return nfserr_nofilehandle;
-
-		if (fh->fh_version == 1) {
-			int len;
-			if (--data_left<0) goto out;
-			switch (fh->fh_auth_type) {
-			case 0: break;
-			default: goto out;
-			}
-			len = key_len(fh->fh_fsid_type) / 4;
-			if (len == 0) goto out;
-			if  (fh->fh_fsid_type == FSID_MAJOR_MINOR) {
-				/* deprecated, convert to type 3 */
-				len = key_len(FSID_ENCODE_DEV)/4;
-				fh->fh_fsid_type = FSID_ENCODE_DEV;
-				fh->fh_fsid[0] = new_encode_dev(MKDEV(ntohl(fh->fh_fsid[0]), ntohl(fh->fh_fsid[1])));
-				fh->fh_fsid[1] = fh->fh_fsid[2];
-			}
-			if ((data_left -= len)<0) goto out;
-			exp = rqst_exp_find(rqstp, fh->fh_fsid_type,
-					    fh->fh_auth);
-			fid = (struct fid *)(fh->fh_auth + len);
-		} else {
-			__u32 tfh[2];
-			dev_t xdev;
-			ino_t xino;
-			if (fh->fh_size != NFS_FHSIZE)
-				goto out;
-			/* assume old filehandle format */
-			xdev = old_decode_dev(fh->ofh_xdev);
-			xino = u32_to_ino_t(fh->ofh_xino);
-			mk_fsid(FSID_DEV, tfh, xdev, xino, 0, NULL);
-			exp = rqst_exp_find(rqstp, FSID_DEV, tfh);
-		}
-
-		error = nfserr_stale;
-		if (PTR_ERR(exp) == -ENOENT)
-			goto out;
-
-		if (IS_ERR(exp)) {
-			error = nfserrno(PTR_ERR(exp));
-			goto out;
-		}
-
-		error = nfsd_setuser_and_check_port(rqstp, exp);
+		error = nfsd_set_fh_dentry(rqstp, fhp);
 		if (error)
 			goto out;
-
-		/*
-		 * Look up the dentry using the NFS file handle.
-		 */
-		error = nfserr_stale;
-		if (rqstp->rq_vers > 2)
-			error = nfserr_badhandle;
-
-		if (fh->fh_version != 1) {
-			sfid.i32.ino = fh->ofh_ino;
-			sfid.i32.gen = fh->ofh_generation;
-			sfid.i32.parent_ino = fh->ofh_dirino;
-			fid = &sfid;
-			data_left = 3;
-			if (fh->ofh_dirino == 0)
-				fileid_type = FILEID_INO32_GEN;
-			else
-				fileid_type = FILEID_INO32_GEN_PARENT;
-		} else
-			fileid_type = fh->fh_fileid_type;
-
-		if (fileid_type == FILEID_ROOT)
-			dentry = dget(exp->ex_path.dentry);
-		else {
-			dentry = exportfs_decode_fh(exp->ex_path.mnt, fid,
-					data_left, fileid_type,
-					nfsd_acceptable, exp);
-		}
-		if (dentry == NULL)
-			goto out;
-		if (IS_ERR(dentry)) {
-			if (PTR_ERR(dentry) != -EINVAL)
-				error = nfserrno(PTR_ERR(dentry));
-			goto out;
-		}
-
-		if (S_ISDIR(dentry->d_inode->i_mode) &&
-		    (dentry->d_flags & DCACHE_DISCONNECTED)) {
-			printk("nfsd: find_fh_dentry returned a DISCONNECTED directory: %s/%s\n",
-			       dentry->d_parent->d_name.name, dentry->d_name.name);
-		}
-
-		fhp->fh_dentry = dentry;
-		fhp->fh_export = exp;
-		nfsd_nr_verified++;
-		cache_get(&exp->h);
+		dentry = fhp->fh_dentry;
+		exp = fhp->fh_export;
 	} else {
 		/*
 		 * just rechecking permissions
@@ -242,7 +258,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 		dprintk("nfsd: fh_verify - just checking\n");
 		dentry = fhp->fh_dentry;
 		exp = fhp->fh_export;
-		cache_get(&exp->h);
 		/*
 		 * Set user creds for this exportpoint; necessary even
 		 * in the "just checking" case because this may be a
@@ -281,8 +296,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 			access, ntohl(error));
 	}
 out:
-	if (exp && !IS_ERR(exp))
-		exp_put(exp);
 	if (error == nfserr_stale)
 		nfsdstats.fh_stale++;
 	return error;
-- 
1.5.4.rc2.60.gb2e62

