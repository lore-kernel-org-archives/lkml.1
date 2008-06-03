Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYFCUOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYFCUOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYFCUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:14:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:25019 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYFCUOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=RhXXVchJaMTKNut6csJwldGXTyOxoj/Pi4ORBk9uuywIlQ9Kwz+pbUTg3fUtJ2Eme67wYzFozoLCpeNpRit0mCqJ+v0LZWPf7R9O1mWfB6cxz+TlDvYdTRnqPLVpg50sci1MGqgA0q89PxmEBRFYkjYco7S4+C33Q5cBqXFaeO0=
Message-ID: <4845A606.6070005@gmail.com>
Date: Tue, 03 Jun 2008 22:13:58 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: utimensat() non-conformances and fixes [v4] (patch)
References: <48454F1D.6060507@gmail.com>
In-Reply-To: <48454F1D.6060507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patch fixes all of the utimensat() bugs outlined in my
previous mail.

I could have split the patch out into a few pieces, but given
that it is not long, and all against a single file, I've made
one patch.  Let me know if you would like separate patches for
the pieces below.

Miklos suggested an alternative idea, migrating the
is_owner_or_cap() check into fs/attr.c:inode_change_ok() via
the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
later, but for now I've one with this version, which is
simpler, and can be more easily read as being correct.

Roughly, the changes accomplish the following:

==
@@ -102,11 +97,15 @@

Addresses bug 4, and simplifies the code, since the
times == NULL and times == {UTIME_NOW, UTIME_NOW} should,
according to the POSIX.1 draft, be exactly equivalent.

==
@@ -131,15 +130,16 @@
[...]
 		if (!is_owner_or_cap(inode)) {
 			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
+				error = permission(inode, MAY_WRITE, NULL);
+				if (error)

Addresses bug 2.

==
@@ -169,14 +182,6 @@

Addresses bug 3.

==
@@ -147,7 +147,20 @@

Addresses bug 1

==

The patch also

a) removes the now unneeded nsec_special() helper function.

b) Makes a whitespace cleanup (tabs instead of spaces).

==

Thanks to Miklos, who's comments helped me improve and complete
the patch.

Cheers,

Michael


Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-05-27 14:24:13.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 15:38:53.000000000 +0200
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
@@ -102,11 +97,15 @@
 	if (error)
 		goto dput_and_out;

+	if (times && times[0].tv_nsec == UTIME_NOW &&
+		     times[1].tv_nsec == UTIME_NOW)
+		times = NULL;
+
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
 		error = -EPERM;
-                if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;

 		if (times[0].tv_nsec == UTIME_OMIT)
@@ -131,15 +130,16 @@
 	 * UTIME_NOW, then need to check permissions, because
 	 * inode_change_ok() won't do it.
 	 */
-	if (!times || (nsec_special(times[0].tv_nsec) &&
-		       nsec_special(times[1].tv_nsec))) {
+	if (!times) {
 		error = -EACCES;
+
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;

 		if (!is_owner_or_cap(inode)) {
 			if (f) {
-				if (!(f->f_mode & FMODE_WRITE))
+				error = permission(inode, MAY_WRITE, NULL);
+				if (error)
 					goto mnt_drop_write_and_out;
 			} else {
 				error = vfs_permission(&nd, MAY_WRITE);
@@ -147,7 +147,20 @@
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
+
 	mutex_lock(&inode->i_mutex);
 	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
@@ -169,14 +182,6 @@
 	if (utimes) {
 		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
 			return -EFAULT;
-		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
-		     tstimes[0].tv_nsec == UTIME_NOW) &&
-		    tstimes[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
-		     tstimes[1].tv_nsec == UTIME_NOW) &&
-		    tstimes[1].tv_sec != 0)
-			return -EINVAL;

 		/* Nothing to do, we must not even check the path.  */
 		if (tstimes[0].tv_nsec == UTIME_OMIT &&




