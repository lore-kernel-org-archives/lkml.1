Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbYDVTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbYDVTUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYDVTUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:20:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYDVTUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:20:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 x86/latest] x86_64 ia32 ptrace: use compat_ptrace_request for siginfo
X-Fcc: ~/Mail/linus
X-Zippy-Says: Eisenhower!!  Your mimeograph machine upsets my stomach!!
Message-Id: <20080422192020.C5DDF270381@magilla.localdomain>
Date: Tue, 22 Apr 2008 12:20:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the special-case handling for PTRACE_GETSIGINFO
and PTRACE_SETSIGINFO from x86_64's sys32_ptrace.  The generic
compat_ptrace_request code handles these.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 1edbb13..b564116 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1301,32 +1301,6 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
-static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
-{
-	siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
-	compat_siginfo_t __user *si32 = compat_ptr(data);
-	siginfo_t ssi;
-	int ret;
-
-	if (request == PTRACE_SETSIGINFO) {
-		memset(&ssi, 0, sizeof(siginfo_t));
-		ret = copy_siginfo_from_user32(&ssi, si32);
-		if (ret)
-			return ret;
-		if (copy_to_user(si, &ssi, sizeof(siginfo_t)))
-			return -EFAULT;
-	}
-	ret = sys_ptrace(request, pid, addr, (unsigned long)si);
-	if (ret)
-		return ret;
-	if (request == PTRACE_GETSIGINFO) {
-		if (copy_from_user(&ssi, si, sizeof(siginfo_t)))
-			return -EFAULT;
-		ret = copy_siginfo_to_user32(si32, &ssi);
-	}
-	return ret;
-}
-
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
 	struct task_struct *child;
@@ -1374,11 +1348,9 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETFPXREGS:
 	case PTRACE_GETFPXREGS:
 	case PTRACE_GETEVENTMSG:
-		break;
-
 	case PTRACE_SETSIGINFO:
 	case PTRACE_GETSIGINFO:
-		return ptrace32_siginfo(request, pid, addr, data);
+		break;
 	}
 
 	child = ptrace_get_task_struct(pid);
