Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXLCQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXLCQRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXLCQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:17:42 -0500
Received: from mail.fieldses.org ([66.93.2.214]:41841 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXLCQRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:17:41 -0500
Date: Mon, 3 Dec 2007 11:17:39 -0500
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Neil Brown <neilb@suse.de>
Subject: Re: nfsd bug: create file with specific uid/gid
Message-ID: <20071203161739.GC16422@fieldses.org>
References: <475042FB.8020106@filmlight.ltd.uk> <20071130220127.GJ24887@fieldses.org> <01bf01c8340e$63e90060$6501a8c0@BODDINGTON>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01bf01c8340e$63e90060$6501a8c0@BODDINGTON>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2007 at 11:36:18AM -0000, Roger Willcocks wrote:
> J. Bruce Fields wrote:
>
>> On Fri, Nov 30, 2007 at 05:06:03PM +0000, Roger Willcocks wrote:
>>> nfsd/vfs.c:nfsd_create (the v2 version of create) says:
>>>
>>> "Set file attributes. Mode has already been set and
>>> setting uid/gid works only for root"
>>>
>>> but it doesn't actually test for root-ness
> ...
>> Assignments (especially with things like &=) inside of conditionals
>> always make my head hurt for some reason.  So maybe something like the
>> below?
>
> The patch looks fine to me, note that nfsd_create_v3 needs fixing too.

Whoops.  OK, in that case we should be call the same logic from both
places.  New (compile-tested only) patch appended.

>> Thanks for the bug report!  (And, by the way, how did you run across
>> this?)
>>
>
> I'm working on an NFSp-like server for our clustered file system and my 
> data file creates were not working as expected.

OK, thanks.  (Might be interesting to hear more about the architecture
if there's a description published someplace.)

--b.

>From 7eed8a82a42e7a1c1e63c3cbc70be7321e69d9ff Mon Sep 17 00:00:00 2001
From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 30 Nov 2007 16:55:23 -0500
Subject: [PATCH] nfsd: allow root to set uid and gid on create

The server silently ignores attempts to set the uid and gid on create.
Based on the comment, this appears to have been done to prevent some
overly-clever IRIX client from causing itself problems.

Perhaps we should remove that hack completely.  For now, at least, it
makes sense to allow root (when no_root_squash is set) to set uid and
gid.

While we're there, since nfsd_create and nfsd_create_v3 share the same
logic, pull that out into a separate function.  And spell out the
individual modifications of ia_valid instead of doing them both at once
inside a conditional.

Thanks to Roger Willcocks <roger@filmlight.ltd.uk> for the bug report
and original patch on which this is based.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/nfsd/vfs.c |   47 ++++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 755ba43..cc75e4f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1151,6 +1151,26 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 }
 #endif /* CONFIG_NFSD_V3 */
 
+__be32
+nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
+			struct iattr *iap)
+{
+	/*
+	 * Mode has already been set earlier in create:
+	 */
+	iap->ia_valid &= ~ATTR_MODE;
+	/*
+	 * Setting uid/gid works only for root.  Irix appears to
+	 * send along the gid on create when it tries to implement
+	 * setgid directories via NFS:
+	 */
+	if (current->fsuid != 0)
+		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
+	if (iap->ia_valid)
+		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
+	return 0;
+}
+
 /*
  * Create a file (regular, directory, device, fifo); UNIX sockets 
  * not yet implemented.
@@ -1167,6 +1187,7 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
+	__be32		err2;
 	int		host_err;
 
 	err = nfserr_perm;
@@ -1257,16 +1278,9 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 
-	/* Set file attributes. Mode has already been set and
-	 * setting uid/gid works only for root. Irix appears to
-	 * send along the gid when it tries to implement setgid
-	 * directories via NFS.
-	 */
-	if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0) {
-		__be32 err2 = nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
-		if (err2)
-			err = err2;
-	}
+	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
+	if (err2)
+		err = err2;
 	/*
 	 * Update the file handle to get the new inode info.
 	 */
@@ -1295,6 +1309,7 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
+	__be32		err2;
 	int		host_err;
 	__u32		v_mtime=0, v_atime=0;
 
@@ -1399,16 +1414,10 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		iap->ia_atime.tv_nsec = 0;
 	}
 
-	/* Set file attributes.
-	 * Irix appears to send along the gid when it tries to
-	 * implement setgid directories via NFS. Clear out all that cruft.
-	 */
  set_attr:
-	if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0) {
- 		__be32 err2 = nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
-		if (err2)
-			err = err2;
-	}
+	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
+	if (err2)
+		err = err2;
 
 	/*
 	 * Update the filehandle to get the new inode info.
-- 
1.5.3.5.561.g140d

