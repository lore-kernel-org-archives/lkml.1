Return-Path: <linux-kernel-owner+w=401wt.eu-S937078AbYD1U6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937078AbYD1U6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934881AbYD1U5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:57:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934566AbYD1U5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:57:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ptrace: conditionalize compat_ptrace_request
In-Reply-To: Ingo Molnar's message of  Monday, 28 April 2008 14:33:13 +0200 <20080428123313.GC27997@elte.hu>
References: <20080428123313.GC27997@elte.hu>
Emacs: the Swiss Army of Editors.
Message-Id: <20080428205719.E612126F8F0@magilla.localdomain>
Date: Mon, 28 Apr 2008 13:57:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My recent additions to compat_ptrace_request made it mandatory
for CONFIG_COMPAT arch's to define copy_siginfo_from_user32.
This broke some builds, though they all really should get cleaned
up in that way.

Since all the arch's that actually call compat_ptrace_request have
now been cleaned up to use the generic compat_sys_ptrace, we can
avoid the build problems on the crufty arch's by changing the
conditionals on the definition.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 67e392e..dac4b4e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -612,7 +612,7 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
 	return (copied == sizeof(data)) ? 0 : -EIO;
 }
 
-#ifdef CONFIG_COMPAT
+#if defined CONFIG_COMPAT && defined __ARCH_WANT_COMPAT_SYS_PTRACE
 #include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
@@ -667,7 +667,6 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 	return ret;
 }
 
-#ifdef __ARCH_WANT_COMPAT_SYS_PTRACE
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data)
 {
@@ -710,6 +709,4 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 	unlock_kernel();
 	return ret;
 }
-#endif /* __ARCH_WANT_COMPAT_SYS_PTRACE */
-
-#endif	/* CONFIG_COMPAT */
+#endif	/* CONFIG_COMPAT && __ARCH_WANT_COMPAT_SYS_PTRACE */
