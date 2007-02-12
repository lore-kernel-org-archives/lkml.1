Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXBLXqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXBLXqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030517AbXBLXpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:45:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:53436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030518AbXBLXpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:45:25 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:44:32 +1100
Message-Id: <1070212234432.29300@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 006 of 9] knfsd: nfsd4: fix error return on unsupported acl
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>
We should be returning ATTRNOTSUPP, not NOTSUPP, when acls are unsupported.

Also fix a comment.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4xdr.c |    2 +-
 ./fs/nfsd/vfs.c     |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff .prev/fs/nfsd/nfs4xdr.c ./fs/nfsd/nfs4xdr.c
--- .prev/fs/nfsd/nfs4xdr.c	2007-02-13 10:36:40.000000000 +1100
+++ ./fs/nfsd/nfs4xdr.c	2007-02-13 10:37:00.000000000 +1100
@@ -253,7 +253,7 @@ nfsd4_decode_fattr(struct nfsd4_compound
 		return status;
 
 	/*
-	 * According to spec, unsupported attributes return ERR_NOTSUPP;
+	 * According to spec, unsupported attributes return ERR_ATTRNOTSUPP;
 	 * read-only attributes return ERR_INVAL.
 	 */
 	if ((bmval[0] & ~NFSD_SUPPORTED_ATTRS_WORD0) || (bmval[1] & ~NFSD_SUPPORTED_ATTRS_WORD1))

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-02-13 09:50:24.000000000 +1100
+++ ./fs/nfsd/vfs.c	2007-02-13 10:37:00.000000000 +1100
@@ -466,7 +466,10 @@ out:
 	posix_acl_release(dpacl);
 	return (error);
 out_nfserr:
-	error = nfserrno(host_error);
+	if (host_error == -EOPNOTSUPP)
+		error = nfserr_attrnotsupp;
+	else
+		error = nfserrno(host_error);
 	goto out;
 }
 
