Return-Path: <linux-kernel-owner+w=401wt.eu-S936301AbZAOWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936301AbZAOWgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764853AbZAOWDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:39 -0500
Received: from kroah.org ([198.145.64.141]:38874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933958AbZAOWDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:36 -0500
Date: Thu, 15 Jan 2009 14:01:13 -0800
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
Subject: [patch 61/85] [PATCH 41/44] [CVE-2009-0029] System call wrappers
	part 31
Message-ID: <20090115220113.GJ17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0041--CVE-2009-0029-System-call-wrappers-part-31.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 836f92adf121f806e9beb5b6b88bd5c9c4ea3f24 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/signalfd.c  |    8 ++++----
 fs/splice.c    |   12 ++++++------
 fs/timerfd.c   |    8 ++++----
 kernel/futex.c |   11 +++++------
 kernel/sys.c   |    4 ++--
 5 files changed, 21 insertions(+), 22 deletions(-)

--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -205,8 +205,8 @@ static const struct file_operations sign
 	.read		= signalfd_read,
 };
 
-asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask,
-			      size_t sizemask, int flags)
+SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
+		size_t, sizemask, int, flags)
 {
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
@@ -259,8 +259,8 @@ asmlinkage long sys_signalfd4(int ufd, s
 	return ufd;
 }
 
-asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask,
-			     size_t sizemask)
+SYSCALL_DEFINE3(signalfd, int, ufd, sigset_t __user *, user_mask,
+		size_t, sizemask)
 {
 	return sys_signalfd4(ufd, user_mask, sizemask, 0);
 }
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1434,8 +1434,8 @@ static long vmsplice_to_pipe(struct file
  * Currently we punt and implement it as a normal copy, see pipe_to_user().
  *
  */
-asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
-			     unsigned long nr_segs, unsigned int flags)
+SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, iov,
+		unsigned long, nr_segs, unsigned int, flags)
 {
 	struct file *file;
 	long error;
@@ -1460,9 +1460,9 @@ asmlinkage long sys_vmsplice(int fd, con
 	return error;
 }
 
-asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
-			   int fd_out, loff_t __user *off_out,
-			   size_t len, unsigned int flags)
+SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
+		int, fd_out, loff_t __user *, off_out,
+		size_t, len, unsigned int, flags)
 {
 	long error;
 	struct file *in, *out;
@@ -1684,7 +1684,7 @@ static long do_tee(struct file *in, stru
 	return ret;
 }
 
-asmlinkage long sys_tee(int fdin, int fdout, size_t len, unsigned int flags)
+SYSCALL_DEFINE4(tee, int, fdin, int, fdout, size_t, len, unsigned int, flags)
 {
 	struct file *in;
 	int error, fput_in;
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -179,7 +179,7 @@ static struct file *timerfd_fget(int fd)
 	return file;
 }
 
-asmlinkage long sys_timerfd_create(int clockid, int flags)
+SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 {
 	int ufd;
 	struct timerfd_ctx *ctx;
@@ -210,9 +210,9 @@ asmlinkage long sys_timerfd_create(int c
 	return ufd;
 }
 
-asmlinkage long sys_timerfd_settime(int ufd, int flags,
-				    const struct itimerspec __user *utmr,
-				    struct itimerspec __user *otmr)
+SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
+		const struct itimerspec __user *, utmr,
+		struct itimerspec __user *, otmr)
 {
 	struct file *file;
 	struct timerfd_ctx *ctx;
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1797,9 +1797,8 @@ pi_faulted:
  * @head: pointer to the list-head
  * @len: length of the list-head, as userspace expects
  */
-asmlinkage long
-sys_set_robust_list(struct robust_list_head __user *head,
-		    size_t len)
+SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
+		size_t, len)
 {
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -1820,9 +1819,9 @@ sys_set_robust_list(struct robust_list_h
  * @head_ptr: pointer to a list-head pointer, the kernel fills it in
  * @len_ptr: pointer to a length field, the kernel fills in the header size
  */
-asmlinkage long
-sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
-		    size_t __user *len_ptr)
+SYSCALL_DEFINE3(get_robust_list, int, pid,
+		struct robust_list_head __user * __user *, head_ptr,
+		size_t __user *, len_ptr)
 {
 	struct robust_list_head __user *head;
 	unsigned long ret;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1736,8 +1736,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	return error;
 }
 
-asmlinkage long sys_getcpu(unsigned __user *cpup, unsigned __user *nodep,
-			   struct getcpu_cache __user *unused)
+SYSCALL_DEFINE3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep,
+		struct getcpu_cache __user *, unused)
 {
 	int err = 0;
 	int cpu = raw_smp_processor_id();

