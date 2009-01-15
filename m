Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbZAOU2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbZAOU2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZAOUBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:30 -0500
Received: from kroah.org ([198.145.64.141]:49263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932102AbZAOUBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:09 -0500
Date: Thu, 15 Jan 2009 11:58:54 -0800
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
Subject: [patch 45/94] [PATCH 14/44] [CVE-2009-0029] System call wrappers
	part 04
Message-ID: <20090115195854.GS14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0014--CVE-2009-0029-System-call-wrappers-part-04.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit b290ebe2c46d01b742b948ce03f09e8a3efb9a92 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/acct.c        |    2 +-
 kernel/capability.c  |    4 ++--
 kernel/exec_domain.c |    3 +--
 kernel/itimer.c      |    2 +-
 kernel/signal.c      |    7 +++----
 kernel/sys.c         |    6 +++---
 6 files changed, 11 insertions(+), 13 deletions(-)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -277,7 +277,7 @@ static int acct_on(char *name)
  * should be written. If the filename is NULL, accounting will be
  * shutdown.
  */
-asmlinkage long sys_acct(const char __user *name)
+SYSCALL_DEFINE1(acct, const char __user *, name)
 {
 	int error;
 
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(cap_set_effective);
  *
  * Returns 0 on success and < 0 on error.
  */
-asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
+SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 {
 	int ret = 0;
 	pid_t pid;
@@ -425,7 +425,7 @@ asmlinkage long sys_capget(cap_user_head
  *
  * Returns 0 on success and < 0 on error.
  */
-asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
+SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 {
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy;
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -209,8 +209,7 @@ static int __init proc_execdomains_init(
 module_init(proc_execdomains_init);
 #endif
 
-asmlinkage long
-sys_personality(u_long personality)
+SYSCALL_DEFINE1(personality, u_long, personality)
 {
 	u_long old = current->personality;
 
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -100,7 +100,7 @@ int do_getitimer(int which, struct itime
 	return 0;
 }
 
-asmlinkage long sys_getitimer(int which, struct itimerval __user *value)
+SYSCALL_DEFINE2(getitimer, int, which, struct itimerval __user *, value)
 {
 	int error = -EFAULT;
 	struct itimerval get_buffer;
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2413,8 +2413,7 @@ out:
 
 #ifdef __ARCH_WANT_SYS_SIGPENDING
 
-asmlinkage long
-sys_sigpending(old_sigset_t __user *set)
+SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
 	return do_sigpending(set, sizeof(*set));
 }
@@ -2425,8 +2424,8 @@ sys_sigpending(old_sigset_t __user *set)
 /* Some platforms have their own version with special arguments others
    support only sys_rt_sigprocmask.  */
 
-asmlinkage long
-sys_sigprocmask(int how, old_sigset_t __user *set, old_sigset_t __user *oset)
+SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, set,
+		old_sigset_t __user *, oset)
 {
 	int error;
 	old_sigset_t old_set, new_set;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -893,7 +893,7 @@ SYSCALL_DEFINE1(times, struct tms __user
  * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
  * LBT 04.03.94
  */
-asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
+SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 {
 	struct task_struct *p;
 	struct task_struct *group_leader = current->group_leader;
@@ -1029,7 +1029,7 @@ out:
 	return retval;
 }
 
-asmlinkage long sys_setsid(void)
+SYSCALL_DEFINE0(setsid)
 {
 	struct task_struct *group_leader = current->group_leader;
 	struct pid *sid = task_pid(group_leader);
@@ -1266,7 +1266,7 @@ out:
  *	without another task interfering.
  */
  
-asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
+SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 {
 	struct group_info *group_info;
 	int retval;

