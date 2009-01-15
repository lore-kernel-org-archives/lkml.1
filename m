Return-Path: <linux-kernel-owner+w=401wt.eu-S936198AbZAOWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936198AbZAOWfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbZAOWDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:35 -0500
Received: from kroah.org ([198.145.64.141]:38833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762757AbZAOWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:32 -0500
Date: Thu, 15 Jan 2009 14:01:07 -0800
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
Subject: [patch 58/85] [PATCH 38/44] [CVE-2009-0029] System call wrappers
	part 28
Message-ID: <20090115220107.GG17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0038--CVE-2009-0029-System-call-wrappers-part-28.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 938bb9f5e840eddbf54e4f62f6c5ba9b3ae12c9d upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/inotify_user.c      |    4 ++--
 fs/ioprio.c            |    5 ++---
 mm/mempolicy.c         |   24 +++++++++++-------------
 mm/migrate.c           |    8 ++++----
 security/keys/keyctl.c |    4 ++--
 5 files changed, 21 insertions(+), 24 deletions(-)

--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -579,7 +579,7 @@ static const struct inotify_operations i
 	.destroy_watch	= free_inotify_user_watch,
 };
 
-asmlinkage long sys_inotify_init1(int flags)
+SYSCALL_DEFINE1(inotify_init1, int, flags)
 {
 	struct inotify_device *dev;
 	struct inotify_handle *ih;
@@ -658,7 +658,7 @@ out_put_fd:
 	return ret;
 }
 
-asmlinkage long sys_inotify_init(void)
+SYSCALL_DEFINE0(inotify_init)
 {
 	return sys_inotify_init1(0);
 }
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -65,7 +65,7 @@ static int set_task_ioprio(struct task_s
 	return err;
 }
 
-asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
+SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
 {
 	int class = IOPRIO_PRIO_CLASS(ioprio);
 	int data = IOPRIO_PRIO_DATA(ioprio);
@@ -181,7 +181,7 @@ int ioprio_best(unsigned short aprio, un
 		return aprio;
 }
 
-asmlinkage long sys_ioprio_get(int which, int who)
+SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 {
 	struct task_struct *g, *p;
 	struct user_struct *user;
@@ -245,4 +245,3 @@ asmlinkage long sys_ioprio_get(int which
 	read_unlock(&tasklist_lock);
 	return ret;
 }
-
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1059,10 +1059,9 @@ static int copy_nodes_to_user(unsigned l
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
 
-asmlinkage long sys_mbind(unsigned long start, unsigned long len,
-			unsigned long mode,
-			unsigned long __user *nmask, unsigned long maxnode,
-			unsigned flags)
+SYSCALL_DEFINE6(mbind, unsigned long, start, unsigned long, len,
+		unsigned long, mode, unsigned long __user *, nmask,
+		unsigned long, maxnode, unsigned, flags)
 {
 	nodemask_t nodes;
 	int err;
@@ -1082,8 +1081,8 @@ asmlinkage long sys_mbind(unsigned long 
 }
 
 /* Set the process memory policy */
-asmlinkage long sys_set_mempolicy(int mode, unsigned long __user *nmask,
-		unsigned long maxnode)
+SYSCALL_DEFINE3(set_mempolicy, int, mode, unsigned long __user *, nmask,
+		unsigned long, maxnode)
 {
 	int err;
 	nodemask_t nodes;
@@ -1101,9 +1100,9 @@ asmlinkage long sys_set_mempolicy(int mo
 	return do_set_mempolicy(mode, flags, &nodes);
 }
 
-asmlinkage long sys_migrate_pages(pid_t pid, unsigned long maxnode,
-		const unsigned long __user *old_nodes,
-		const unsigned long __user *new_nodes)
+SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
+		const unsigned long __user *, old_nodes,
+		const unsigned long __user *, new_nodes)
 {
 	struct mm_struct *mm;
 	struct task_struct *task;
@@ -1171,10 +1170,9 @@ out:
 
 
 /* Retrieve NUMA policy */
-asmlinkage long sys_get_mempolicy(int __user *policy,
-				unsigned long __user *nmask,
-				unsigned long maxnode,
-				unsigned long addr, unsigned long flags)
+SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
+		unsigned long __user *, nmask, unsigned long, maxnode,
+		unsigned long, addr, unsigned long, flags)
 {
 	int err;
 	int uninitialized_var(pval);
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -979,10 +979,10 @@ set_status:
  * Move a list of pages in the address space of the currently executing
  * process.
  */
-asmlinkage long sys_move_pages(pid_t pid, unsigned long nr_pages,
-			const void __user * __user *pages,
-			const int __user *nodes,
-			int __user *status, int flags)
+SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
+		const void __user * __user *, pages,
+		const int __user *, nodes,
+		int __user *, status, int, flags)
 {
 	int err = 0;
 	int i;
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1152,8 +1152,8 @@ long keyctl_get_security(key_serial_t ke
 /*
  * the key control system call
  */
-asmlinkage long sys_keyctl(int option, unsigned long arg2, unsigned long arg3,
-			   unsigned long arg4, unsigned long arg5)
+SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
+		unsigned long, arg4, unsigned long, arg5)
 {
 	switch (option) {
 	case KEYCTL_GET_KEYRING_ID:

