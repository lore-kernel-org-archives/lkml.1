Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYFCW0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYFCW0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758605AbYFCWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:25:46 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:19831 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560AbYFCWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=q0kvcosbd2+d2B5K8rOGEzElX+XTGZ4SnUU3qt9Akl0iJqONYlah8lwEwKocWmjaiCufHus4QcCenK73Z76LxPN2iME+qKFV4vTqufbt9u6leiLGN1q8hGDGBzbwCBXCeSExmerEgX6AvFwM6OnbpK8vzhbv06YD+35icR8oUTY=
Message-ID: <4845C4CA.5070403@gmail.com>
Date: Wed, 04 Jun 2008 00:25:14 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [parch 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSIX.1 draft spec for utimensat() says that to do anything
other than setting both timestamps to a time other than the
current time (i.e., times is not NULL, and both tv_nsec fields
are not UTIME_NOW and both tv_nsec fields are not UTIME_OMIT),
either:

a) the caller's effective user ID must match the file owner; or
b) the caller must have appropriate privileges.

If this condition is violated, then the error EPERM should result.
However, the current implementation does not generate EPERM if
one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT.
It should give this error for that case.

This patch:

a) Repairs that problem.
b) Removes the now unneeded nsec_special() helper function.

Miklos suggested an alternative idea, migrating the
is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
later, but for now I've gone with this version, which is
simpler, and can be more easily read as being correct.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>


--- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 23:11:53.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 23:04:48.000000000 +0200
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
@@ -135,8 +130,7 @@
 	 * UTIME_NOW, then need to check permissions, because
 	 * inode_change_ok() won't do it.
 	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
+	if (!times) {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
@@ -151,6 +145,18 @@
 					goto mnt_drop_write_and_out;
 			}
 		}
+	} else if ((times[0].tv_nsec == UTIME_NOW &&
+		    times[1].tv_nsec == UTIME_OMIT)
+		  ||
+		   (times[0].tv_nsec == UTIME_OMIT &&
+		    times[1].tv_nsec == UTIME_NOW)) {
+		error =-EPERM;
+
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+			goto mnt_drop_write_and_out;
+
+		if (!is_owner_or_cap(inode))
+			goto mnt_drop_write_and_out;
 	}
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);


