Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbYECM2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbYECM2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYECM2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:28:00 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:33730 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYECM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:27:59 -0400
MIME-Version: 1.0
Date: Sat, 03 May 2008 14:27:54 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [OP] 04-vfs-fix-permission-checking-in-sys_utimensat.patch added to
 queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <494fd3cee207c1311e9273ef9a4e0b1e@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
git://repo.or.cz/linux-2.6.22.y-op-patches.git

---

From: Miklos Szeredi <mszeredi@suse.cz>
Date: Thu, 1 May 2008 04:34:45 -0700
Subject: [PATCH] vfs: fix permission checking in sys_utimensat

If utimensat() is called with both times set to UTIME_NOW or one of them to
UTIME_NOW and the other to UTIME_OMIT, then it will update the file time
without any permission checking.

I don't think this can be used for anything other than a local DoS, but
could
be quite bewildering at that (e.g.  "Why was that large source tree rebuilt
when I didn't modify anything???")

This affects all kernels from 2.6.22, when the utimensat() syscall was
introduced.

Fix by doing the same permission checking as for the "times == NULL" case.

Thanks to Michael Kerrisk, whose utimensat-non-conformances-and-fixes.patch
in
-mm also fixes this (and breaks other stuff), only he didn't realize the
security implications of this bug.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Backported-to-2.6.22.y: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/utimes.c b/fs/utimes.c
index f28a919..88432eb 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -39,9 +39,14 @@ asmlinkage long sys_utime(char __user *filename, struct
utimbuf __user *times)
 
 #endif
 
+static bool nsec_special(long nsec)
+{
+	return nsec == UTIME_OMIT || nsec == UTIME_NOW;
+}
+
 static bool nsec_valid(long nsec)
 {
-	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
+	if (nsec_special(nsec))
 		return true;
 
 	return nsec >= 0 && nsec <= 999999999;
@@ -115,7 +120,15 @@ long do_utimes(int dfd, char __user *filename, struct
timespec *times, int flags
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
-	} else {
+	}
+
+	/*
+	 * If times is NULL or both times are either UTIME_OMIT or
+	 * UTIME_NOW, then need to check permissions, because
+	 * inode_change_ok() won't do it.
+	 */
+	if (!times || (nsec_special(times[0].tv_nsec) &&
+		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
                         goto dput_and_out;


