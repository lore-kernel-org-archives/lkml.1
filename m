Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYEMUPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYEMUPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761905AbYEMUNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:13:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761895AbYEMUNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:13:52 -0400
Date: Tue, 13 May 2008 13:11:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/37] sparc: Fix fork/clone/vfork system call restart.
Message-ID: <20080513201149.GI31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-fix-fork-clone-vfork-system-call-restart.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: 1e38c126c9252b612697e34f43b1b3371c8ee31d ]

We clobber %i1 as well as %i0 for these system calls,
because they give two return values.

Therefore, on error, we have to restore %i1 properly
or else the restart explodes since it uses the wrong
arguments.

This fixes glibc's nptl/tst-eintr1.c testcase.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/process.c   |   20 ++++++++++++++++----
 arch/sparc64/kernel/process.c |   18 +++++++++++++++---
 2 files changed, 31 insertions(+), 7 deletions(-)

--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -507,6 +507,8 @@ asmlinkage long sparc_do_fork(unsigned l
 			      unsigned long stack_size)
 {
 	int __user *parent_tid_ptr, *child_tid_ptr;
+	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	long ret;
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT)) {
@@ -519,9 +521,19 @@ asmlinkage long sparc_do_fork(unsigned l
 		child_tid_ptr = (int __user *) regs->u_regs[UREG_I4];
 	}
 
-	return do_fork(clone_flags, stack_start,
-		       regs, stack_size,
-		       parent_tid_ptr, child_tid_ptr);
+	ret = do_fork(clone_flags, stack_start,
+		      regs, stack_size,
+		      parent_tid_ptr, child_tid_ptr);
+
+	/* If we get an error and potentially restart the system
+	 * call, we're screwed because copy_thread() clobbered
+	 * the parent's %o1.  So detect that case and restore it
+	 * here.
+	 */
+	if ((unsigned long)ret >= -ERESTART_RESTARTBLOCK)
+		regs->u_regs[UREG_I1] = orig_i1;
+
+	return ret;
 }
 
 /* Copy a Sparc thread.  The fork() return value conventions
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -421,14 +421,26 @@ asmlinkage int sparc_do_fork(unsigned lo
                              unsigned long stack_size)
 {
 	unsigned long parent_tid_ptr, child_tid_ptr;
+	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	long ret;
 
 	parent_tid_ptr = regs->u_regs[UREG_I2];
 	child_tid_ptr = regs->u_regs[UREG_I4];
 
-	return do_fork(clone_flags, stack_start,
-		       regs, stack_size,
-		       (int __user *) parent_tid_ptr,
-		       (int __user *) child_tid_ptr);
+	ret = do_fork(clone_flags, stack_start,
+		      regs, stack_size,
+		      (int __user *) parent_tid_ptr,
+		      (int __user *) child_tid_ptr);
+
+	/* If we get an error and potentially restart the system
+	 * call, we're screwed because copy_thread() clobbered
+	 * the parent's %o1.  So detect that case and restore it
+	 * here.
+	 */
+	if ((unsigned long)ret >= -ERESTART_RESTARTBLOCK)
+		regs->u_regs[UREG_I1] = orig_i1;
+
+	return ret;
 }
 
 /* Copy a Sparc thread.  The fork() return value conventions

-- 
