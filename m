Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYFDNOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYFDNOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbYFDNNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:13:45 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:42160 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbYFDNNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=SxgJ6cWBmIbqNKwD5Sxt3fTUZ9Th2yS4q/UAO1cGBWD3/vLAH4rv3bQRkzXgUuh5DO
         ZlaSwKSSqmofOqeP2fTWxzv3Nx5AuFurYnR3pXjICA9OlvfvyUpMnDnZYbmK+GM6G7aF
         pZuhn/pat8P6TRdYJ0gvHMRk+B4gYalO0wZZs=
Message-ID: <484694E7.3080405@gmail.com>
Date: Wed, 04 Jun 2008 15:13:11 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [patch 3/4 v2] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX.1 draft spec for utimensat() says:

    Only a process with the effective user ID equal to the
    user ID of the file or with appropriate privileges may use
    futimens() or utimensat() with a non-null times argument
    that does not have both tv_nsec fields set to UTIME_NOW
    and does not have both tv_nsec fields set to UTIME_OMIT.

If this condition is violated, then the error EPERM should result.
However, the current implementation does not generate EPERM if
one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT.
It should give this error for that case.

This patch:

a) Repairs that problem.
b) Removes the now unneeded nsec_special() helper function.
c) Adds some comments to explain the checks that are being
   performed.

Thanks to Miklos, who provided comments on the previous iteration
of this patch.  As a result, this version is a little simpler and
and its logic is better structured.

Miklos suggested an alternative idea, migrating the
is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
later, but for now I've gone with this version, which is
IMO simpler, and can be more easily read as being correct.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-06-04 13:36:33.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-04 13:35:14.000000000 +0200
@@ -40,14 +40,9 @@

 #endif

-static bool nsec_special(long nsec)
-{
-	return nsec == UTIME_OMIT || nsec == UTIME_NOW;
-}
-
 static bool nsec_valid(long nsec)
 {
-	if (nsec_special(nsec))
+	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
 		return true;

 	return nsec >= 0 && nsec <= 999999999;
@@ -106,7 +101,7 @@
 		     times[1].tv_nsec == UTIME_NOW)
 		times = NULL;

-	/* Don't worry, the checks are done in inode_change_ok() */
+	/* In most cases, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
 		error = -EPERM;
@@ -128,15 +123,26 @@
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
-	}

-	/*
-	 * If times is NULL or both times are either UTIME_OMIT or
-	 * UTIME_NOW, then need to check permissions, because
-	 * inode_change_ok() won't do it.
-	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
+		/*
+		 * For the UTIME_OMIT/UTIME_NOW and UTIME_NOW/UTIME_OMIT
+		 * cases, we need to make an extra check that is not done by
+		 * inode_change_ok().
+		 */
+		if (((times[0].tv_nsec == UTIME_NOW &&
+			    times[1].tv_nsec == UTIME_OMIT)
+			  ||
+			   (times[0].tv_nsec == UTIME_OMIT &&
+			    times[1].tv_nsec == UTIME_NOW))
+		     && !is_owner_or_cap(inode))
+				goto mnt_drop_write_and_out;
+	} else {
+
+		/*
+		 * If times is NULL (or both times are UTIME_NOW),
+		 * then we need to check permissions, because
+		 * inode_change_ok() won't do it.
+		 */
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;


