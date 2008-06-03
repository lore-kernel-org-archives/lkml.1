Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYFCW0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYFCW0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYFCWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:25:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:19854 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbYFCWZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=fxzfVBty3EMt9+vpGLy/L0DRnXs4HqfRjutz2s9Rww+HucINt69QvQN8xX6rAXcRoGZ6fOBfGKVmvgyKXVQnUDx2TnDgotp2vdgNuMH9VfUwri69Q4qzVX9/ze9WXw5cGyDTOtJIhbjGuo3cXgl90j2PIyGtG82fI1ORvbBJHqM=
Message-ID: <4845C4BD.70805@gmail.com>
Date: Wed, 04 Jun 2008 00:25:01 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
       Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       jamie@shareable.org, Ulrich Drepper <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [parch 2/4] vfs: utimensat(): be consistent with utime() for immutable
 and append-only files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes utimensat() to make its behavior consistent
with that of utime()/utimes() when dealing with files marked
immutable and append-only.

The current utimensat() implementation also returns EPERM if
'times' is non-NULL and the tv_nsec fields are both UTIME_NOW.
For consistency, the

(times != NULL && times[0].tv_nsec == UTIME_NOW &&
                  times[1].tv_nsec == UTIME_NOW)

case should be treated like the traditional utimes() case where
'times' is NULL.  That is, the call should succeed for a file
marked append-only and should give the error EACCES if the file
is marked as immutable.

The simple way to do this is to set 'times' to NULL
if (times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec == UTIME_NOW).

This is also the natural approach, since POSIX.1 semantics consider the
times == {{x, UTIME_NOW}, {y, UTIME_NOW}}
to be exactly equivalent to the case for
times == NULL.

(Thanks to Miklos for pointing this out.)

Patch 3 in this series relies on the simplification provided
by this patch.

CC: Miklos Szeredi <miklos@szeredi.hu>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.26-rc4/fs/utimes.c	2008-06-03 22:47:07.000000000 +0200
+++ linux-2.6.26-rc4-utimensat-fix-v4/fs/utimes.c	2008-06-03 22:59:55.000000000 +0200
@@ -102,6 +102,10 @@
 	if (error)
 		goto dput_and_out;

+	if (times && times[0].tv_nsec == UTIME_NOW &&
+		     times[1].tv_nsec == UTIME_NOW)
+		times = NULL;
+
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {


