Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZB1DK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZB1DK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZB1DKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:10:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbZB1DKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:10:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 1/2] x86-64: syscall-audit: fix 32/64 syscall hole
In-Reply-To: Roland McGrath's message of  Friday, 27 February 2009 19:02:26 -0800 <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090228030324.0D84EFC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 19:03:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, a 32-bit process (TIF_IA32) can switch to 64-bit mode with
ljmp, and then use the "syscall" instruction to make a 64-bit system
call.  A 64-bit process make a 32-bit system call with int $0x80.

In both these cases, audit_syscall_entry() will use the wrong system
call number table and the wrong system call argument registers.  This
could be used to circumvent a syscall audit configuration that filters
based on the syscall numbers or argument details.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5a4c23d..06ca07f 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1388,7 +1388,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 #ifdef CONFIG_X86_32
 # define IS_IA32	1
 #elif defined CONFIG_IA32_EMULATION
-# define IS_IA32	test_thread_flag(TIF_IA32)
+# define IS_IA32	is_compat_task()
 #else
 # define IS_IA32	0
 #endif
