Return-Path: <linux-kernel-owner+w=401wt.eu-S1030322AbXBZQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322AbXBZQnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXBZQna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:43:30 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:28385 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030322AbXBZQn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:43:29 -0500
Date: Mon, 26 Feb 2007 19:50:24 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org, ak@suse.de,
       linux-arch@vger.kernel.org
Subject: [PATCH 4/3] lutimesat: compat syscall and wire up on x86_64
Message-ID: <20070226165024.GB11154@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Apply after:
 lutimesat-simplify-utime2.patch
 lutimesat-extend-do_utimes-with-flags.patch
 lutimesat-actual-syscall-and-wire-up-on-i386.patch

 Tweak compat syscall number to match normal syscall number if needed.]

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 arch/x86_64/ia32/ia32entry.S |    1 +
 fs/compat.c                  |   14 ++++++++++++++
 fs/utimes.c                  |    2 +-
 include/linux/time.h         |    1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -719,4 +719,5 @@ #endif
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad compat_sys_lutimesat	/* 320 */
 ia32_syscall_end:		
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -109,6 +109,20 @@ asmlinkage long compat_sys_utimes(char _
 	return compat_sys_futimesat(AT_FDCWD, filename, t);
 }
 
+asmlinkage long compat_sys_lutimesat(int dfd, char __user *filename, struct compat_timespec __user *utimes)
+{
+	struct timespec ts[2];
+
+	if (utimes) {
+		if (get_user(ts[0].tv_sec, &utimes[0].tv_sec) ||
+		    get_user(ts[0].tv_nsec, &utimes[0].tv_nsec) ||
+		    get_user(ts[1].tv_sec, &utimes[1].tv_sec) ||
+		    get_user(ts[1].tv_nsec, &utimes[1].tv_nsec))
+			return -EFAULT;
+	}
+	return do_utimes_nsec(dfd, filename, utimes ? ts : NULL, AT_SYMLINK_NOFOLLOW);
+}
+
 asmlinkage long compat_sys_newstat(char __user * filename,
 		struct compat_stat __user *statbuf)
 {
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -40,7 +40,7 @@ #endif
  * must be owner or have write permission.
  * Else, update from *times, must be owner or super user.
  */
-static long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags)
+long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags)
 {
 	int error = -EINVAL;
 	struct nameidata nd;
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -110,6 +110,7 @@ extern int do_settimeofday(struct timesp
 extern int do_sys_settimeofday(struct timespec *tv, struct timezone *tz);
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, char __user *filename, struct timeval *times, int flags);
+extern long do_utimes_nsec(int dfd, char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);

