Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbZAOUqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbZAOUqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbZAOUCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:41 -0500
Received: from kroah.org ([198.145.64.141]:49661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932298AbZAOUCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:31 -0500
Date: Thu, 15 Jan 2009 12:00:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 73/94] [PATCH 42/44] [CVE-2009-0029] System call wrappers
	part 32
Message-ID: <20090115200005.GU14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0042--CVE-2009-0029-System-call-wrappers-part-32.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d4e82042c4cfa87a7d51710b71f568fe80132551 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/eventfd.c             |    5 ++---
 fs/pipe.c                |    2 +-
 fs/readdir.c             |    3 ++-
 fs/select.c              |   11 ++++++-----
 fs/timerfd.c             |    2 +-
 include/linux/syscalls.h |    7 +++++++
 kernel/signal.c          |   11 +++++------
 7 files changed, 24 insertions(+), 17 deletions(-)

--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -198,7 +198,7 @@ struct file *eventfd_fget(int fd)
 	return file;
 }
 
-asmlinkage long sys_eventfd2(unsigned int count, int flags)
+SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
 	struct eventfd_ctx *ctx;
@@ -228,8 +228,7 @@ asmlinkage long sys_eventfd2(unsigned in
 	return fd;
 }
 
-asmlinkage long sys_eventfd(unsigned int count)
+SYSCALL_DEFINE1(eventfd, unsigned int, count)
 {
 	return sys_eventfd2(count, 0);
 }
-
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1048,7 +1048,7 @@ int do_pipe(int *fd)
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
  */
-asmlinkage long sys_pipe2(int __user *fildes, int flags)
+SYSCALL_DEFINE2(pipe2, int __user *, fildes, int, flags)
 {
 	int fd[2];
 	int error;
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -102,7 +102,8 @@ efault:
 	return -EFAULT;
 }
 
-asmlinkage long sys_old_readdir(unsigned int fd, struct old_linux_dirent __user * dirent, unsigned int count)
+SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
+		struct old_linux_dirent __user *, dirent, unsigned int, count)
 {
 	int error;
 	struct file * file;
--- a/fs/select.c
+++ b/fs/select.c
@@ -586,8 +586,9 @@ static long do_pselect(int n, fd_set __u
  * which has a pointer to the sigset_t itself followed by a size_t containing
  * the sigset size.
  */
-asmlinkage long sys_pselect6(int n, fd_set __user *inp, fd_set __user *outp,
-	fd_set __user *exp, struct timespec __user *tsp, void __user *sig)
+SYSCALL_DEFINE6(pselect6, int, n, fd_set __user *, inp, fd_set __user *, outp,
+		fd_set __user *, exp, struct timespec __user *, tsp,
+		void __user *, sig)
 {
 	size_t sigsetsize = 0;
 	sigset_t __user *up = NULL;
@@ -841,9 +842,9 @@ SYSCALL_DEFINE3(poll, struct pollfd __us
 }
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
-	struct timespec __user *tsp, const sigset_t __user *sigmask,
-	size_t sigsetsize)
+SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
+		struct timespec __user *, tsp, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts, end_time, *to = NULL;
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -265,7 +265,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 	return 0;
 }
 
-asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr)
+SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
 {
 	struct file *file;
 	struct timerfd_ctx *ctx;
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -678,6 +678,13 @@ asmlinkage long sys_eventfd(unsigned int
 asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 asmlinkage long sys_old_readdir(unsigned int, struct old_linux_dirent __user *, unsigned int);
+asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
+			     fd_set __user *, struct timespec __user *,
+			     void __user *);
+asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
+			  struct timespec __user *, const sigset_t __user *,
+			  size_t);
+asmlinkage long sys_pipe2(int __user *, int);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2470,11 +2470,10 @@ out:
 #endif /* __ARCH_WANT_SYS_SIGPROCMASK */
 
 #ifdef __ARCH_WANT_SYS_RT_SIGACTION
-asmlinkage long
-sys_rt_sigaction(int sig,
-		 const struct sigaction __user *act,
-		 struct sigaction __user *oact,
-		 size_t sigsetsize)
+SYSCALL_DEFINE4(rt_sigaction, int, sig,
+		const struct sigaction __user *, act,
+		struct sigaction __user *, oact,
+		size_t, sigsetsize)
 {
 	struct k_sigaction new_sa, old_sa;
 	int ret = -EINVAL;
@@ -2557,7 +2556,7 @@ SYSCALL_DEFINE0(pause)
 #endif
 
 #ifdef __ARCH_WANT_SYS_RT_SIGSUSPEND
-asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize)
+SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 {
 	sigset_t newset;
 

