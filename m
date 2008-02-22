Return-Path: <linux-kernel-owner+w=401wt.eu-S935714AbYBVVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714AbYBVVvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbYBVVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:46584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933746AbYBVVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:47 -0500
Date: Fri, 22 Feb 2008 13:40:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland <devzero@web.de>, Andreas Gruenbacher <agruen@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 15/23] knfsd: fix spurious EINVAL errors on first access of
	new filesystem
Message-ID: <20080222214042.GP8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="knfsd-fix-spurious-einval-errors-on-first-access-of-new-filesystem.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

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
Reviewed-By: NeilBrown <neilb@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs2acl.c |    2 +-
 fs/nfsd/nfs3acl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -41,7 +41,7 @@ static __be32 nfsacld_proc_getacl(struct
 
 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);
 
 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -37,7 +37,7 @@ static __be32 nfsd3_proc_getacl(struct s
 
 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);
 
 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);

-- 
