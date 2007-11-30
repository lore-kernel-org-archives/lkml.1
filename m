Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXK3WBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXK3WBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXK3WB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:01:29 -0500
Received: from mail.fieldses.org ([66.93.2.214]:36177 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbXK3WB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:01:29 -0500
Date: Fri, 30 Nov 2007 17:01:27 -0500
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Neil Brown <neilb@suse.de>
Subject: Re: nfsd bug: create file with specific uid/gid
Message-ID: <20071130220127.GJ24887@fieldses.org>
References: <475042FB.8020106@filmlight.ltd.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475042FB.8020106@filmlight.ltd.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 05:06:03PM +0000, Roger Willcocks wrote:
> nfsd/vfs.c:nfsd_create (the v2 version of create) says:
>
> "Set file attributes. Mode has already been set and
> setting uid/gid works only for root"
>
> but it doesn't actually test for root-ness (which could happen if the 
> access is no-root-squash). There's similar code without the comment in 
> nfsd_create_v3. In both cases the test:
>
>    if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0)
>
> should read:
>
>    if (current->fsuid != 0)
>        iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
>    if ((iap->ia_valid &= ~ATTR_MODE) != 0)
>
> although arguably they should return an EPERM error if the uid/gid bits are 
> set, instead of silently ignoring them.

Assignments (especially with things like &=) inside of conditionals
always make my head hurt for some reason.  So maybe something like the
below?

Although I'd be happier if we could get a comment from someone with a
better understanding of why this hack was added in the first place.

Thanks for the bug report!  (And, by the way, how did you run across
this?)

--b.


commit 38574420b8992d69f469ca86041f75b6e2283174
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Fri Nov 30 16:55:23 2007 -0500

    nfsd: allow root to set uid and gid on create
    
    The server silently ignores attempts to set the uid and gid on create.
    Based on the comment, this appears to have been done to prevent some
    overly-clever IRIX client from causing itself problems.
    
    Perhaps we should remove that hack completely.  For now, at least, it
    makes sense to allow root (when no_root_squash is set) to set uid and
    gid.
    
    Thanks to Roger Willcocks <roger@filmlight.ltd.uk> for the bug report
    and original patch on which this is based.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 755ba43..8a8bf06 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1257,12 +1257,16 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 
-	/* Set file attributes. Mode has already been set and
-	 * setting uid/gid works only for root. Irix appears to
+	/* Mode has already been set: */
+	iap->ia_valid &= ~ATTR_MODE;
+	/*
+	 * Setting uid/gid works only for root.  Irix appears to
 	 * send along the gid when it tries to implement setgid
-	 * directories via NFS.
+	 * directories via NFS:
 	 */
-	if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0) {
+	if (current->fsuid != 0)
+		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
+	if (iap->ia_valid) {
 		__be32 err2 = nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
 		if (err2)
 			err = err2;
