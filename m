Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbYBGUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbYBGUH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbYBGUDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38645 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbYBGUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=xTjG4y1qJpHnDd7rkZD8LMQfaxGeLeTzjcwY9usmP2eImeqbKR6t0lLmIoT5pyanW5DmPfIU9dWC0Chxy1UcLw+VLyNuZhS5C4Yfb5iTw9NxCFOQYvbLuqx0WI9CduAc7woIYgJOj/WHn054FrLI8uKRS0V2LKMARX0iS91h5as=
Message-ID: <6101e8c40802071203t53a5a88cseb39c4f8aa61e832@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:41 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {10/14} - knfsd: fix spurious EINVAL errors on first access of new filesystem - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: nfsacl-retval.patch

From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 2 Nov 2007 15:36:08 -0400
Subject: [PATCH] knfsd: fix spurious EINVAL errors on first access of
new filesystem
References: 340873

mainline: ac8587dcb58e40dd336d99d60f852041e06cc3dd

The v2/v3 acl code in nfsd is translating any return from fh_verify() to
nfserr_inval.  This is particularly unfortunate in the case of an
nfserr_dropit return, which is an internal error meant to indicate to
callers that this request has been deferred and should just be dropped
pending the results of an upcall to mountd.

Thanks to Roland <devzero@web.de> for bug report and data collection.

Cc: Roland <devzero@web.de>
Acked-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>

Index: linux-2.6.23/fs/nfsd/nfs2acl.c
===================================================================
--- linux-2.6.23.orig/fs/nfsd/nfs2acl.c
+++ linux-2.6.23/fs/nfsd/nfs2acl.c
@@ -41,7 +41,7 @@ static __be32 nfsacld_proc_getacl(struct

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);
Index: linux-2.6.23/fs/nfsd/nfs3acl.c
===================================================================
--- linux-2.6.23.orig/fs/nfsd/nfs3acl.c
+++ linux-2.6.23/fs/nfsd/nfs3acl.c
@@ -37,7 +37,7 @@ static __be32 nfsd3_proc_getacl(struct s

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);


-- 
Thanks,
Oliver
