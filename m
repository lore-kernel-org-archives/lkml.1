Return-Path: <linux-kernel-owner+w=401wt.eu-S1765804AbYEHRpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765804AbYEHRpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbYEHRnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:47696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874AbYEHRnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:16 -0400
Date: Thu, 8 May 2008 10:42:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Miklos Szeredi <mszeredi@suse.cz>, Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: [patch 04/16] vfs: fix permission checking in sys_utimensat
Message-ID: <20080508174203.GE855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vfs-fix-permission-checking-in-sys_utimensat.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

commit: 02c6be615f1fcd37ac5ed93a3ad6692ad8991cd9 upstream

If utimensat() is called with both times set to UTIME_NOW or one of them to
UTIME_NOW and the other to UTIME_OMIT, then it will update the file time
without any permission checking.

I don't think this can be used for anything other than a local DoS, but could
be quite bewildering at that (e.g.  "Why was that large source tree rebuilt
when I didn't modify anything???")

This affects all kernels from 2.6.22, when the utimensat() syscall was
introduced.

Fix by doing the same permission checking as for the "times == NULL" case.

Thanks to Michael Kerrisk, whose utimensat-non-conformances-and-fixes.patch in
-mm also fixes this (and breaks other stuff), only he didn't realize the
security implications of this bug.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/utimes.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -39,9 +39,14 @@ asmlinkage long sys_utime(char __user *f
 
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
@@ -115,7 +120,15 @@ long do_utimes(int dfd, char __user *fil
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

-- 
