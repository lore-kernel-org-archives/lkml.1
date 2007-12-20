Return-Path: <linux-kernel-owner+w=401wt.eu-S1761862AbXLTMCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761862AbXLTMCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbXLTMAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760201AbXLTMAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 24/43] powerpc compat_sys_ptrace
Message-Id: <20071220115855.D937126F98D@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces powerpc's compat_sys_ptrace with a compat_arch_ptrace and
enables the new generic definition of compat_sys_ptrace instead.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace32.c |   33 +++++----------------------------
 include/asm-powerpc/ptrace.h   |    2 ++
 2 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 6612304..0f6eea0 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -85,33 +85,13 @@ static long compat_ptrace_old(struct task_struct *child, long request,
 	return ret;
 }
 
-long compat_sys_ptrace(int request, int pid, unsigned long addr,
-		       unsigned long data)
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	struct task_struct *child;
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
 	int ret;
 
-	lock_kernel();
-	if (request == PTRACE_TRACEME) {
-		ret = ptrace_traceme();
-		goto out;
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child)) {
-		ret = PTR_ERR(child);
-		goto out;
-	}
-
-	if (request == PTRACE_ATTACH) {
-		ret = ptrace_attach(child);
-		goto out_tsk;
-	}
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out_tsk;
-
 	switch (request) {
 	/*
 	 * Read 4 bytes of the other process' storage
@@ -375,9 +355,6 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
 		ret = compat_ptrace_request(child, request, addr, data);
 		break;
 	}
-out_tsk:
-	put_task_struct(child);
-out:
-	unlock_kernel();
+
 	return ret;
 }
diff --git a/include/asm-powerpc/ptrace.h b/include/asm-powerpc/ptrace.h
index 3063363..a8cb00c 100644
--- a/include/asm-powerpc/ptrace.h
+++ b/include/asm-powerpc/ptrace.h
@@ -55,6 +55,8 @@ struct pt_regs {
 
 #ifdef __powerpc64__
 
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+
 #define STACK_FRAME_OVERHEAD	112	/* size of minimum stack frame */
 
 /* Size of dummy stack frame allocated when calling signal handler. */
-- 
1.5.3.6

