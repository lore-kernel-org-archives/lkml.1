Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbXKFXa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbXKFXa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXKFXav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:30:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbXKFXau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:30:50 -0500
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: ia32 ptrace THREAD_AREA fix
X-Shopping-List: (1) Amusing revised trash
   (2) Flamboyant hatred
   (3) Problematic ambition
   (4) Astronomical ingredients
   (5) Flirtatious annoyers
Message-Id: <20071106233038.3C41D4D0560@magilla.localdomain>
Date: Tue,  6 Nov 2007 15:30:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The addr argument to PTRACE_GET_THREAD_AREA and PTRACE_SET_THREAD_AREA is
not a magic constant.  It's derived from the segment register values being
used, which are computed originally from the index used with set_thread_area.
The value does not need to match what a native i386 kernel would accept.
It needs to match the segment selectors that can actually be in use in this
32-bit process.  The 64-bit ptrace support for PTRACE_GET_THREAD_AREA
(normally used only on 32-bit processes) is correct, but the 32-bit emulation
of ptrace is broken.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/ia32/ptrace32.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index f52770e..fc4673d 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -228,8 +228,6 @@ static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
 	return ret;
 }
 
-#define COMPAT_GDT_ENTRY_TLS_MIN 6
-
 asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 {
 	struct task_struct *child;
@@ -248,6 +246,8 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SYSCALL:
 	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
+	case PTRACE_SET_THREAD_AREA:
+	case PTRACE_GET_THREAD_AREA:
 		return sys_ptrace(request, pid, addr, data); 
 
 	default:
@@ -271,12 +271,6 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETSIGINFO:
 	case PTRACE_GETSIGINFO:
 		return ptrace32_siginfo(request, pid, addr, data);
-
-	case PTRACE_SET_THREAD_AREA:
-	case PTRACE_GET_THREAD_AREA:
-		return sys_ptrace(request, pid,
-			addr + GDT_ENTRY_TLS_MIN - COMPAT_GDT_ENTRY_TLS_MIN,
-			data);
 	}
 
 	child = ptrace_get_task_struct(pid);
