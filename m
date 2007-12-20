Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXLTMOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXLTMOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761298AbXLTMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760754AbXLTMBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:01:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 43/43] x86 ptrace generic requests
Message-Id: <20071220120120.195D826F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:01:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes duplicated code by calling the generic ptrace_request and
compat_ptrace_request functions for the things they already handle.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |   37 +------------------------------------
 1 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 25b6578..dac5503 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -760,12 +760,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
-	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
 		unsigned long tmp;
@@ -787,12 +781,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 	}
 
-	/* when I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
 		if ((addr & (sizeof(data) - 1)) || addr < 0 ||
@@ -1184,24 +1172,6 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	childregs = task_pt_regs(child);
 
 	switch (request) {
-	case PTRACE_PEEKDATA:
-	case PTRACE_PEEKTEXT:
-		ret = 0;
-		if (access_process_vm(child, addr, &val, sizeof(u32), 0) !=
-		    sizeof(u32))
-			ret = -EIO;
-		else
-			ret = put_user(val, (unsigned int __user *)datap);
-		break;
-
-	case PTRACE_POKEDATA:
-	case PTRACE_POKETEXT:
-		ret = 0;
-		if (access_process_vm(child, addr, &data, sizeof(u32), 1) !=
-		    sizeof(u32))
-			ret = -EIO;
-		break;
-
 	case PTRACE_PEEKUSR:
 		ret = getreg32(child, addr, &val);
 		if (ret == 0)
@@ -1247,13 +1217,8 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
 
-	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message,
-			       (unsigned int __user *)compat_ptr(data));
-		break;
-
 	default:
-		BUG();
+		return compat_ptrace_request(child, request, addr, data);
 	}
 
  out:
-- 
1.5.3.6
