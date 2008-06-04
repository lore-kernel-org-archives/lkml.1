Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYFDOvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYFDOvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYFDOvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:51:35 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:61526 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYFDOvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=RK5IFus0O86+Y+tzgnpfpsrdRt6FZ8EkYp/HbRxq0Z/Q9RFthcMYSqg+oLW3tJdKxa
         hwm1xrozXiHbOQcbDJABMZ8/1KDlJ9oYG2NR8NDSTzDCCnJ8nNhOgr5SmFSPhhzPsLje
         zACDraiHc5NeNANWUSFKh4F6JYXb+nWPE/+Qo=
Message-ID: <4846ABD3.4000600@gmail.com>
Date: Wed, 04 Jun 2008 16:50:59 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: [patch 3/4 v2] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
References: <484694E7.3080405@gmail.com>
In-Reply-To: <484694E7.3080405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patch improves the indentation of the previous patch.
(No other changes).

Cheers,

Michael

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
+		     ||
+		     (times[0].tv_nsec == UTIME_OMIT &&
+			    times[1].tv_nsec == UTIME_NOW))
+		    && !is_owner_or_cap(inode))
+			goto mnt_drop_write_and_out;
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


