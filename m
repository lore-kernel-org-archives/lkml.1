Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXFUEcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXFUEcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbXFUEbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:31:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:59864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbXFUEbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:31:09 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:59 +1000
Message-Id: <1070621043059.1111@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Alexander Soule <soule@umich.edu>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 005 of 8] knfsd: nfsd4: fix handling of acl errrors
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


nfs4_acl_nfsv4_to_posix() returns an error and returns any posix acls
calculated in two caller-provided pointers.  It was setting these
pointers to -errno in some error cases, resulting in
nfsd4_set_nfs4_acl() calling posix_acl_release() with a -errno as an
argument.

Fix both the caller and the callee, by modifying nfsd4_set_nfs4_acl() to
stop relying on the passed-in-pointers being left as NULL in the error
case, and by modifying nfs4_acl_nfsv4_to_posix() to stop returning
garbage in those pointers.

Thanks to Alex Soule for reporting the bug.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Alexander Soule <soule@umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |    3 +++
 ./fs/nfsd/vfs.c     |   22 +++++++---------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-06-21 14:10:06.000000000 +1000
+++ ./fs/nfsd/nfs4acl.c	2007-06-21 14:11:02.000000000 +1000
@@ -737,13 +737,16 @@ int nfs4_acl_nfsv4_to_posix(struct nfs4_
 	*pacl = posix_state_to_acl(&effective_acl_state, flags);
 	if (IS_ERR(*pacl)) {
 		ret = PTR_ERR(*pacl);
+		*pacl = NULL;
 		goto out_dstate;
 	}
 	*dpacl = posix_state_to_acl(&default_acl_state,
 						flags | NFS4_ACL_TYPE_DEFAULT);
 	if (IS_ERR(*dpacl)) {
 		ret = PTR_ERR(*dpacl);
+		*dpacl = NULL;
 		posix_acl_release(*pacl);
+		*pacl = NULL;
 		goto out_dstate;
 	}
 	sort_pacl(*pacl);

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-06-21 13:46:38.000000000 +1000
+++ ./fs/nfsd/vfs.c	2007-06-21 14:11:02.000000000 +1000
@@ -435,7 +435,7 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 	/* Get inode */
 	error = fh_verify(rqstp, fhp, 0 /* S_IFREG */, MAY_SATTR);
 	if (error)
-		goto out;
+		return error;
 
 	dentry = fhp->fh_dentry;
 	inode = dentry->d_inode;
@@ -444,33 +444,25 @@ nfsd4_set_nfs4_acl(struct svc_rqst *rqst
 
 	host_error = nfs4_acl_nfsv4_to_posix(acl, &pacl, &dpacl, flags);
 	if (host_error == -EINVAL) {
-		error = nfserr_attrnotsupp;
-		goto out;
+		return nfserr_attrnotsupp;
 	} else if (host_error < 0)
 		goto out_nfserr;
 
 	host_error = set_nfsv4_acl_one(dentry, pacl, POSIX_ACL_XATTR_ACCESS);
 	if (host_error < 0)
-		goto out_nfserr;
+		goto out_release;
 
-	if (S_ISDIR(inode->i_mode)) {
+	if (S_ISDIR(inode->i_mode))
 		host_error = set_nfsv4_acl_one(dentry, dpacl, POSIX_ACL_XATTR_DEFAULT);
-		if (host_error < 0)
-			goto out_nfserr;
-	}
-
-	error = nfs_ok;
 
-out:
+out_release:
 	posix_acl_release(pacl);
 	posix_acl_release(dpacl);
-	return (error);
 out_nfserr:
 	if (host_error == -EOPNOTSUPP)
-		error = nfserr_attrnotsupp;
+		return nfserr_attrnotsupp;
 	else
-		error = nfserrno(host_error);
-	goto out;
+		return nfserrno(host_error);
 }
 
 static struct posix_acl *
