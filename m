Return-Path: <linux-kernel-owner+w=401wt.eu-S933659AbZAOUdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbZAOUdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbZAOUCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:05 -0500
Received: from kroah.org ([198.145.64.141]:49342 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763983AbZAOUCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:04 -0500
Date: Thu, 15 Jan 2009 11:59:12 -0800
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
Subject: [patch 50/94] [PATCH 19/44] [CVE-2009-0029] System call wrappers
	part 09
Message-ID: <20090115195912.GX14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0019--CVE-2009-0029-System-call-wrappers-part-09.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit a5f8fa9e9ba5ef3305e147f41ad6e1e84ac1f0bd upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sync.c       |    6 +++---
 kernel/signal.c |   21 ++++++++-------------
 2 files changed, 11 insertions(+), 16 deletions(-)

--- a/fs/sync.c
+++ b/fs/sync.c
@@ -36,7 +36,7 @@ static void do_sync(unsigned long wait)
 		laptop_sync_completion();
 }
 
-asmlinkage long sys_sync(void)
+SYSCALL_DEFINE0(sync)
 {
 	do_sync(1);
 	return 0;
@@ -118,12 +118,12 @@ static long __do_fsync(unsigned int fd, 
 	return ret;
 }
 
-asmlinkage long sys_fsync(unsigned int fd)
+SYSCALL_DEFINE1(fsync, unsigned int, fd)
 {
 	return __do_fsync(fd, 0);
 }
 
-asmlinkage long sys_fdatasync(unsigned int fd)
+SYSCALL_DEFINE1(fdatasync, unsigned int, fd)
 {
 	return __do_fsync(fd, 1);
 }
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2258,7 +2258,7 @@ static int do_tkill(pid_t tgid, pid_t pi
  *  exists but it's not belonging to the target process anymore. This
  *  method solves the problem of threads exiting and PIDs getting reused.
  */
-asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig)
+SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0 || tgid <= 0)
@@ -2270,8 +2270,7 @@ asmlinkage long sys_tgkill(pid_t tgid, p
 /*
  *  Send a signal to only one task, even if it's a CLONE_THREAD task.
  */
-asmlinkage long
-sys_tkill(pid_t pid, int sig)
+SYSCALL_DEFINE2(tkill, pid_t, pid, int, sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0)
@@ -2280,8 +2279,8 @@ sys_tkill(pid_t pid, int sig)
 	return do_tkill(0, pid, sig);
 }
 
-asmlinkage long
-sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
+SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
+		siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
 
@@ -2505,15 +2504,13 @@ out:
 /*
  * For backwards compatibility.  Functionality superseded by sigprocmask.
  */
-asmlinkage long
-sys_sgetmask(void)
+SYSCALL_DEFINE0(sgetmask)
 {
 	/* SMP safe */
 	return current->blocked.sig[0];
 }
 
-asmlinkage long
-sys_ssetmask(int newmask)
+SYSCALL_DEFINE1(ssetmask, int, newmask)
 {
 	int old;
 
@@ -2533,8 +2530,7 @@ sys_ssetmask(int newmask)
 /*
  * For backwards compatibility.  Functionality superseded by sigaction.
  */
-asmlinkage long
-sys_signal(int sig, __sighandler_t handler)
+SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
 {
 	struct k_sigaction new_sa, old_sa;
 	int ret;
@@ -2551,8 +2547,7 @@ sys_signal(int sig, __sighandler_t handl
 
 #ifdef __ARCH_WANT_SYS_PAUSE
 
-asmlinkage long
-sys_pause(void)
+SYSCALL_DEFINE0(pause)
 {
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();

