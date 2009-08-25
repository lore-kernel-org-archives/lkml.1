Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZHYMRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZHYMRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZHYMRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:17:07 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:45132 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbZHYMRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:17:06 -0400
From: Eric Blake <ebb9@byu.net>
To: linux-kernel@vger.kernel.org
Cc: bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Davide Libenzi <davidel@xmailserver.org>, Eric Blake <ebb9@byu.net>
Subject: [PATCH] open: introduce O_NOSTD
Date: Tue, 25 Aug 2009 06:16:33 -0600
Message-Id: <1251202593-3676-1-git-send-email-ebb9@byu.net>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-Reply-To: <4A9285FC.8000606@byu.net>
References: <4A9285FC.8000606@byu.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many applications have subtle bugs if started with one or more of the
STD*_FILENO file descriptors closed; although this is an uncommon
case, it should be considered during security audits.  For example, an
attempt to write a message to stderr during 'cp a b >&- 2>&-' in a
naive implementation of 'cp' could end up corrupting the contents of
file 'b'.  In general, if any of the standard streams are used by an
application (including via its libraries), then the safest course of
action is to ensure that all other fds created by the process will not
interfere with the three standard fds.

One solution is for the application to manually ensure that all three
std fds are open (either inherited, or to an innocuous replacement
like /dev/null) prior to opening fds during normal behavior; but this
costs extra syscalls up front for all invocations, even though a
closed standard fd is an uncommon case.  Unfortunately, opening a
dummy file interferes with the ability to conditionally warn on
improper use of inheriting a closed standard fd; GNU coreutils
intentionally distinguishes between the successful 'cp a b <&-' and
the fatal 'cp -i a b <&-'.

Another solution is for the application to sanitize all newly-created
fds: GNU coreutils provides a wrapper open_safer, which does nothing
extra in the common case that open() returned 3 or larger, but calls
fcntl(n,F_DUPFD,3)/close(n) before returning if n was less than 3.
However, this leads to triple the syscall cost for every open() call
if the process starts life with a std fd closed; and if O_CLOEXEC is
not used, still leaves a window of time where the fd can be leaked
through another thread's use of fork/exec.

With the recent addition of O_CLOEXEC support, all fd creation sites
now take a flags parameter that can be used to provide this
sanitization in the kernel, rather than via an application wrapper
that requires additional syscalls.  The new flag O_NOSTD guarantees
that a created fd will be 3 or larger, regardless of whether any of
the standard fds are currently closed.  Adding this flag in the kernel
allows for the absolute minimum in syscalls, while still guaranteeing
safety that unrelated fds will never be confused with the standard
streams.

This patch implements O_NOSTD for open, pipe2, socket, socketpair, and
accept4.  It does not add support for Linux-only fd creation, such as
inotify_init, although that can be done later.  It intentionally does
not support O_NOSTD for dup3, since that syscall does not return the
next available fd.

Signed-off-by: Eric Blake <ebb9@byu.net>
---
 arch/alpha/include/asm/fcntl.h  |    1 +
 arch/parisc/include/asm/fcntl.h |    1 +
 arch/sparc/include/asm/fcntl.h  |    1 +
 fs/file.c                       |    2 ++
 fs/pipe.c                       |    2 +-
 include/asm-generic/fcntl.h     |    3 +++
 include/linux/net.h             |    1 +
 net/socket.c                    |   12 +++++++-----
 8 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index 25da001..5af6265 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -17,6 +17,7 @@
 #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
 #define O_NOATIME	04000000
 #define O_CLOEXEC	010000000 /* set close_on_exec */
+#define O_NOSTD		020000000 /* avoid fd 0, 1, 2 */

 #define F_GETLK		7
 #define F_SETLK		8
diff --git a/arch/parisc/include/asm/fcntl.h b/arch/parisc/include/asm/fcntl.h
index 1e1c824..688c5d2 100644
--- a/arch/parisc/include/asm/fcntl.h
+++ b/arch/parisc/include/asm/fcntl.h
@@ -15,6 +15,7 @@
 #define O_RSYNC		002000000 /* HPUX only */
 #define O_NOATIME	004000000
 #define O_CLOEXEC	010000000 /* set close_on_exec */
+#define O_NOSTD		020000000 /* avoid fd 0, 1, 2 */

 #define O_DIRECTORY	000010000 /* must be a directory */
 #define O_NOFOLLOW	000000200 /* don't follow links */
diff --git a/arch/sparc/include/asm/fcntl.h b/arch/sparc/include/asm/fcntl.h
index d4d9c9d..a7dae19 100644
--- a/arch/sparc/include/asm/fcntl.h
+++ b/arch/sparc/include/asm/fcntl.h
@@ -20,6 +20,7 @@
 #define O_DIRECT        0x100000 /* direct disk access hint */
 #define O_NOATIME	0x200000
 #define O_CLOEXEC	0x400000
+#define O_NOSTD		0x800000 /* avoid fd 0, 1, 2 */

 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff --git a/fs/file.c b/fs/file.c
index f313314..94e1f67 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -444,6 +444,8 @@ int alloc_fd(unsigned start, unsigned flags)
 	int error;
 	struct fdtable *fdt;

+	if (start < 3 && (flags & O_NOSTD))
+		start = 3;
 	spin_lock(&files->file_lock);
 repeat:
 	fdt = files_fdtable(files);
diff --git a/fs/pipe.c b/fs/pipe.c
index 52c4151..d5f52bb 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1033,7 +1033,7 @@ int do_pipe_flags(int *fd, int flags)
 	int error;
 	int fdw, fdr;

-	if (flags & ~(O_CLOEXEC | O_NONBLOCK))
+	if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_NOSTD))
 		return -EINVAL;

 	fw = create_write_pipe(flags);
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 4d3e483..b9b4290 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -51,6 +51,9 @@
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
+#ifndef O_NOSTD
+#define O_NOSTD		04000000	/* avoid fd 0, 1, 2 */
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
diff --git a/include/linux/net.h b/include/linux/net.h
index 4fc2ffd..a489122 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -105,6 +105,7 @@ enum sock_type {
 #ifndef SOCK_NONBLOCK
 #define SOCK_NONBLOCK	O_NONBLOCK
 #endif
+#define SOCK_NOSTD	O_NOSTD

 #endif /* ARCH_HAS_SOCKET_TYPES */

diff --git a/net/socket.c b/net/socket.c
index 6d47165..177bfb2 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1271,12 +1271,14 @@ SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)

 	/* Check the SOCK_* constants for consistency.  */
 	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(SOCK_NOSTD != O_NOSTD);
 	BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
 	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
 	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
+	BUILD_BUG_ON(SOCK_NOSTD & SOCK_TYPE_MASK);

 	flags = type & ~SOCK_TYPE_MASK;
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK | SOCK_NOSTD))
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;

@@ -1287,7 +1289,7 @@ SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
 	if (retval < 0)
 		goto out;

-	retval = sock_map_fd(sock, flags & (O_CLOEXEC | O_NONBLOCK));
+	retval = sock_map_fd(sock, flags & (O_CLOEXEC | O_NONBLOCK | O_NOSTD));
 	if (retval < 0)
 		goto out_release;

@@ -1337,13 +1339,13 @@ SYSCALL_DEFINE4(socketpair, int, family, int, type, int, protocol,
 	if (err < 0)
 		goto out_release_both;

-	fd1 = sock_alloc_fd(&newfile1, flags & O_CLOEXEC);
+	fd1 = sock_alloc_fd(&newfile1, flags & (O_CLOEXEC | O_NOSTD));
 	if (unlikely(fd1 < 0)) {
 		err = fd1;
 		goto out_release_both;
 	}

-	fd2 = sock_alloc_fd(&newfile2, flags & O_CLOEXEC);
+	fd2 = sock_alloc_fd(&newfile2, flags & (O_CLOEXEC | O_NOSTD));
 	if (unlikely(fd2 < 0)) {
 		err = fd2;
 		put_filp(newfile1);
@@ -1498,7 +1500,7 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 	 */
 	__module_get(newsock->ops->owner);

-	newfd = sock_alloc_fd(&newfile, flags & O_CLOEXEC);
+	newfd = sock_alloc_fd(&newfile, flags & (O_CLOEXEC | O_NOSTD));
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
-- 
1.6.3.3.334.g916e1

