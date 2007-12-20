Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXLTL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXLTL5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbXLTL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:56:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760350AbXLTL4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:56:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 09/43] compat_sys_ptrace
Message-Id: <20071220115551.73EE026F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:55:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic definition of compat_sys_ptrace that calls
compat_arch_ptrace, parallel to sys_ptrace/arch_ptrace.  Some
machines needing this already define a function by that name.
The new generic function is defined only on machines that
put #define __ARCH_WANT_COMPAT_SYS_PTRACE into asm/ptrace.h.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/compat.h |    7 +++++++
 kernel/ptrace.c        |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index e70a2a1..aa3a55e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -275,5 +275,12 @@ extern int compat_ptrace_request(struct task_struct *child,
 				 compat_long_t request,
 				 compat_ulong_t addr, compat_ulong_t data);
 
+#ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
+extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			       compat_ulong_t addr, compat_ulong_t data);
+asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
+				  compat_long_t addr, compat_long_t data);
+#endif	/* __ARCH_WANT_COMPAT_SYS_PTRACE */
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index bc1a764..319ab4a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -642,4 +642,50 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 
 	return ret;
 }
+
+#ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
+asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
+				  compat_long_t addr, compat_long_t data)
+{
+	struct task_struct *child;
+	long ret;
+
+	/*
+	 * This lock_kernel fixes a subtle race with suid exec
+	 */
+	lock_kernel();
+	if (request == PTRACE_TRACEME) {
+		ret = ptrace_traceme();
+		goto out;
+	}
+
+	child = ptrace_get_task_struct(pid);
+	if (IS_ERR(child)) {
+		ret = PTR_ERR(child);
+		goto out;
+	}
+
+	if (request == PTRACE_ATTACH) {
+		ret = ptrace_attach(child);
+		/*
+		 * Some architectures need to do book-keeping after
+		 * a ptrace attach.
+		 */
+		if (!ret)
+			arch_ptrace_attach(child);
+		goto out_put_task_struct;
+	}
+
+	ret = ptrace_check_attach(child, request == PTRACE_KILL);
+	if (!ret)
+		ret = compat_arch_ptrace(child, request, addr, data);
+
+ out_put_task_struct:
+	put_task_struct(child);
+ out:
+	unlock_kernel();
+	return ret;
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_PTRACE */
+
 #endif	/* CONFIG_COMPAT */
-- 
1.5.3.6

