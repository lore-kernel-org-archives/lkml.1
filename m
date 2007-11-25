Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXKYWHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXKYWHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXKYWGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:06:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbXKYWGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:06:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 21/27] ptrace: generic PTRACE_SINGLEBLOCK
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Windows: more than enough rope.
Message-Id: <20071125220611.245BB26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:06:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This makes ptrace_request handle PTRACE_SINGLEBLOCK along with
PTRACE_CONT et al.  The new generic code makes use of the
arch_has_block_step macro and generic entry points on machines
that define them.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 309796a..2824726 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -373,6 +373,12 @@ static int ptrace_setsiginfo(struct task_struct *child, siginfo_t __user * data)
 #define is_singlestep(request)		0
 #endif
 
+#ifdef PTRACE_SINGLEBLOCK
+#define is_singleblock(request)		((request) == PTRACE_SINGLEBLOCK)
+#else
+#define is_singleblock(request)		0
+#endif
+
 #ifdef PTRACE_SYSEMU
 #define is_sysemu_singlestep(request)	((request) == PTRACE_SYSEMU_SINGLESTEP)
 #else
@@ -396,7 +402,11 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 		clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 
-	if (is_singlestep(request) || is_sysemu_singlestep(request)) {
+	if (is_singleblock(request)) {
+		if (unlikely(!arch_has_block_step()))
+			return -EIO;
+		user_enable_block_step(child);
+	} else if (is_singlestep(request) || is_sysemu_singlestep(request)) {
 		if (unlikely(!arch_has_single_step()))
 			return -EIO;
 		user_enable_single_step(child);
@@ -438,6 +448,9 @@ int ptrace_request(struct task_struct *child, long request,
 #ifdef PTRACE_SINGLESTEP
 	case PTRACE_SINGLESTEP:
 #endif
+#ifdef PTRACE_SINGLEBLOCK
+	case PTRACE_SINGLEBLOCK:
+#endif
 #ifdef PTRACE_SYSEMU
 	case PTRACE_SYSEMU:
 	case PTRACE_SYSEMU_SINGLESTEP:
