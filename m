Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbYECMWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbYECMWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYECMWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:22:25 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:41256 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYECMWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:22:24 -0400
MIME-Version: 1.0
Date: Sat, 03 May 2008 14:22:17 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [OP] 01-vfs-check-nanoseconds-in-utimensat.patch added  to
 queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <360d0e9809dec86d69bbe425374de813@zipernowsky.hu>
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

>From 043f46f6151df2c518988b5e41376e42491257b5 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@suse.cz>
Date: Tue, 16 Oct 2007 23:27:07 -0700
Subject: [PATCH] VFS: check nanoseconds in utimensat

utimensat() (and possibly other callers of do_utimes()) didn't check if the
nanosecond value was within the allowed range.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/utimes.c b/fs/utimes.c
index 682eb63..b9912ec 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -38,6 +38,14 @@ asmlinkage long sys_utime(char __user *filename, struct
utimbuf __user *times)
 
 #endif
 
+static bool nsec_valid(long nsec)
+{
+	if (nsec == UTIME_OMIT || nsec == UTIME_NOW)
+		return true;
+
+	return nsec >= 0 && nsec <= 999999999;
+}
+
 /* If times==NULL, set access and modification to current time,
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
@@ -52,6 +60,11 @@ long do_utimes(int dfd, char __user *filename, struct
timespec *times, int flags
 	struct file *f = NULL;
 
 	error = -EINVAL;
+	if (times && (!nsec_valid(times[0].tv_nsec) ||
+		      !nsec_valid(times[1].tv_nsec))) {
+		goto out;
+	}
+
 	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
 


