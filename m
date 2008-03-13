Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYCMIeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYCMIeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYCMIeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:34:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYCMId7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:33:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH -mm 3/4] x86_64 ia32 ptrace: use compat_ptrace_request for siginfo
In-Reply-To: Roland McGrath's message of  Thursday, 13 March 2008 01:31:07 -0700 <20080313083107.8BDE926F992@magilla.localdomain>
References: <20080313083107.8BDE926F992@magilla.localdomain>
X-Zippy-Says: JAPAN is a WONDERFUL planet -- I wonder if we'll ever reach their
    level of COMPARATIVE SHOPPING...
Message-Id: <20080313083350.0A0D426F992@magilla.localdomain>
Date: Thu, 13 Mar 2008 01:33:50 -0700 (PDT)
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
index 77d9ddd..42305fa 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1184,32 +1184,6 @@ static int genregs32_set(struct task_struct *target,
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
@@ -1255,11 +1229,9 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
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
