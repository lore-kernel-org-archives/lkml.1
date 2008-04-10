Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYDJWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYDJWiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbYDJWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:38:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbYDJWiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:38:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Linus Torvalds's message of  Thursday, 10 April 2008 14:51:11 -0700 <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org>
References: <20080410155940.GA11721@redhat.com>
	<alpine.LFD.1.00.0804100906470.3143@woody.linux-foundation.org>
	<20080410165244.GV20478@devserv.devel.redhat.com>
	<alpine.LFD.1.00.0804101009420.3143@woody.linux-foundation.org>
	<alpine.LFD.1.00.0804101415450.3143@woody.linux-foundation.org>
	<20080410214114.GY20478@devserv.devel.redhat.com>
	<alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org>
Subject: [PATCH 1/2] asmlinkage_protect replaces prevent_tail_call
X-Windows: a terminal disease.
Message-Id: <20080410223738.80A8326F992@magilla.localdomain>
Date: Thu, 10 Apr 2008 15:37:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prevent_tail_call() macro works around the problem of the compiler
clobbering argument words on the stack, which for asmlinkage functions
is the caller's (user's) struct pt_regs.  The tail/sibling-call
optimization is not the only way that the compiler can decide to use
stack argument words as scratch space, which we have to prevent.
Other optimizations can do it too.

Until we have new compiler support to make "asmlinkage" binding on the
compiler's own use of the stack argument frame, we have work around all
the manifestations of this issue that crop up.

More cases seem to be prevented by also keeping the incoming argument
variables live at the end of the function.  This makes their original
stack slots attractive places to leave those variables, so the compiler
tends not clobber them for something else.  It's still no guarantee, but
it handles some observed cases that prevent_tail_call() did not.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/tls.c     |    4 ++--
 fs/open.c                 |    8 ++++----
 include/asm-x86/linkage.h |   24 +++++++++++++++++++++++-
 include/linux/linkage.h   |    4 ++--
 kernel/exit.c             |    4 ++--
 kernel/uid16.c            |   22 +++++++++++-----------
 6 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 022bcaa..ab6bf37 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -92,7 +92,7 @@ int do_set_thread_area(struct task_struct *p, int idx,
 asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
 {
 	int ret = do_set_thread_area(current, -1, u_info, 1);
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, u_info);
 	return ret;
 }
 
@@ -142,7 +142,7 @@ int do_get_thread_area(struct task_struct *p, int idx,
 asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
 	int ret = do_get_thread_area(current, -1, u_info);
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, u_info);
 	return ret;
 }
 
diff --git a/fs/open.c b/fs/open.c
index a4b1202..3fa4e4f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -335,7 +335,7 @@ asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length)
 {
 	long ret = do_sys_ftruncate(fd, length, 1);
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(2, ret, fd, length);
 	return ret;
 }
 
@@ -350,7 +350,7 @@ asmlinkage long sys_ftruncate64(unsigned int fd, loff_t length)
 {
 	long ret = do_sys_ftruncate(fd, length, 0);
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(2, ret, fd, length);
 	return ret;
 }
 #endif
@@ -1067,7 +1067,7 @@ asmlinkage long sys_open(const char __user *filename, int flags, int mode)
 
 	ret = do_sys_open(AT_FDCWD, filename, flags, mode);
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, filename, flags, mode);
 	return ret;
 }
 
@@ -1081,7 +1081,7 @@ asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 
 	ret = do_sys_open(dfd, filename, flags, mode);
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(4, ret, dfd, filename, flags, mode);
 	return ret;
 }
 
diff --git a/include/asm-x86/linkage.h b/include/asm-x86/linkage.h
index 31739c7..d605eeb 100644
--- a/include/asm-x86/linkage.h
+++ b/include/asm-x86/linkage.h
@@ -8,12 +8,34 @@
 
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
-#define prevent_tail_call(ret) __asm__ ("" : "=r" (ret) : "0" (ret))
 /*
  * For 32-bit UML - mark functions implemented in assembly that use
  * regparm input parameters:
  */
 #define asmregparm __attribute__((regparm(3)))
+
+#define asmlinkage_protect(n, ret, args...) \
+	__asmlinkage_protect##n(ret, ##args)
+#define __asmlinkage_protect_n(ret, args...) \
+	__asm__ __volatile__ ("" : "=r" (ret) : "0" (ret), ##args)
+#define __asmlinkage_protect0(ret) \
+	__asmlinkage_protect_n(ret)
+#define __asmlinkage_protect1(ret, arg1) \
+	__asmlinkage_protect_n(ret, "g" (arg1))
+#define __asmlinkage_protect2(ret, arg1, arg2) \
+	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2))
+#define __asmlinkage_protect3(ret, arg1, arg2, arg3) \
+	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3))
+#define __asmlinkage_protect4(ret, arg1, arg2, arg3, arg4) \
+	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
+			      "g" (arg4))
+#define __asmlinkage_protect5(ret, arg1, arg2, arg3, arg4, arg5) \
+	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
+			      "g" (arg4), "g" (arg5))
+#define __asmlinkage_protect6(ret, arg1, arg2, arg3, arg4, arg5, arg6) \
+	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
+			      "g" (arg4), "g" (arg5), "g" (arg6))
+
 #endif
 
 #ifdef CONFIG_X86_ALIGNMENT_16
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 0592936..fe2a39c 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -17,8 +17,8 @@
 # define asmregparm
 #endif
 
-#ifndef prevent_tail_call
-# define prevent_tail_call(ret) do { } while (0)
+#ifndef asmlinkage_protect
+# define asmlinkage_protect(n, ret, args...)	do { } while (0)
 #endif
 
 #ifndef __ALIGN
diff --git a/kernel/exit.c b/kernel/exit.c
index 53872bf..073005b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1608,7 +1608,7 @@ asmlinkage long sys_waitid(int which, pid_t upid,
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(5, ret, which, upid, infop, options, ru);
 	return ret;
 }
 
@@ -1640,7 +1640,7 @@ asmlinkage long sys_wait4(pid_t upid, int __user *stat_addr,
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(4, ret, upid, stat_addr, options, ru);
 	return ret;
 }
 
diff --git a/kernel/uid16.c b/kernel/uid16.c
index dd308ba..3e41c16 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -21,7 +21,7 @@ asmlinkage long sys_chown16(const char __user * filename, old_uid_t user, old_gi
 {
 	long ret = sys_chown(filename, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, filename, user, group);
 	return ret;
 }
 
@@ -29,7 +29,7 @@ asmlinkage long sys_lchown16(const char __user * filename, old_uid_t user, old_g
 {
 	long ret = sys_lchown(filename, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, filename, user, group);
 	return ret;
 }
 
@@ -37,7 +37,7 @@ asmlinkage long sys_fchown16(unsigned int fd, old_uid_t user, old_gid_t group)
 {
 	long ret = sys_fchown(fd, low2highuid(user), low2highgid(group));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, fd, user, group);
 	return ret;
 }
 
@@ -45,7 +45,7 @@ asmlinkage long sys_setregid16(old_gid_t rgid, old_gid_t egid)
 {
 	long ret = sys_setregid(low2highgid(rgid), low2highgid(egid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(2, ret, rgid, egid);
 	return ret;
 }
 
@@ -53,7 +53,7 @@ asmlinkage long sys_setgid16(old_gid_t gid)
 {
 	long ret = sys_setgid(low2highgid(gid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, gid);
 	return ret;
 }
 
@@ -61,7 +61,7 @@ asmlinkage long sys_setreuid16(old_uid_t ruid, old_uid_t euid)
 {
 	long ret = sys_setreuid(low2highuid(ruid), low2highuid(euid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(2, ret, ruid, euid);
 	return ret;
 }
 
@@ -69,7 +69,7 @@ asmlinkage long sys_setuid16(old_uid_t uid)
 {
 	long ret = sys_setuid(low2highuid(uid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, uid);
 	return ret;
 }
 
@@ -78,7 +78,7 @@ asmlinkage long sys_setresuid16(old_uid_t ruid, old_uid_t euid, old_uid_t suid)
 	long ret = sys_setresuid(low2highuid(ruid), low2highuid(euid),
 				 low2highuid(suid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, ruid, euid, suid);
 	return ret;
 }
 
@@ -98,7 +98,7 @@ asmlinkage long sys_setresgid16(old_gid_t rgid, old_gid_t egid, old_gid_t sgid)
 	long ret = sys_setresgid(low2highgid(rgid), low2highgid(egid),
 				 low2highgid(sgid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(3, ret, rgid, egid, sgid);
 	return ret;
 }
 
@@ -117,7 +117,7 @@ asmlinkage long sys_setfsuid16(old_uid_t uid)
 {
 	long ret = sys_setfsuid(low2highuid(uid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, uid);
 	return ret;
 }
 
@@ -125,7 +125,7 @@ asmlinkage long sys_setfsgid16(old_gid_t gid)
 {
 	long ret = sys_setfsgid(low2highgid(gid));
 	/* avoid REGPARM breakage on x86: */
-	prevent_tail_call(ret);
+	asmlinkage_protect(1, ret, gid);
 	return ret;
 }
 
