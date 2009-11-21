Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZKUNkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZKUNkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZKUNkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:36522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbZKUNkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:00 -0500
Date: Sat, 21 Nov 2009 13:39:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
References: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints, x86: Fix modular KVM build
Message-ID: <tip-68efa37df779b3e04280598e8b5b3a1919b65fee@git.kernel.org>
Git-Commit-ID: 68efa37df779b3e04280598e8b5b3a1919b65fee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68efa37df779b3e04280598e8b5b3a1919b65fee
Gitweb:     http://git.kernel.org/tip/68efa37df779b3e04280598e8b5b3a1919b65fee
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 14 Nov 2009 01:35:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 15:32:53 +0100

hw-breakpoints, x86: Fix modular KVM build

This build error:

arch/x86/kvm/x86.c:3655: error: implicit declaration of function 'hw_breakpoint_restore'

Happens because in the CONFIG_KVM=m case there's no 'CONFIG_KVM' define
in the kernel - it's CONFIG_KVM_MODULE in that case.

Make the prototype available unconditionally.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/debugreg.h |    2 --
 arch/x86/kernel/hw_breakpoint.c |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 0f6e92a..fdabd84 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -96,9 +96,7 @@ static inline int hw_breakpoint_active(void)
 
 extern void aout_dump_debugregs(struct user *dump);
 
-#ifdef CONFIG_KVM
 extern void hw_breakpoint_restore(void);
-#endif
 
 #endif	/* __KERNEL__ */
 
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 57dcee5..752daeb 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -43,6 +43,7 @@
 
 /* Per cpu debug control register value */
 DEFINE_PER_CPU(unsigned long, dr7);
+EXPORT_PER_CPU_SYMBOL(dr7);
 
 /* Per cpu debug address registers values */
 static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
@@ -409,6 +410,7 @@ void aout_dump_debugregs(struct user *dump)
 
 	dump->u_debugreg[7] = dr7;
 }
+EXPORT_SYMBOL_GPL(aout_dump_debugregs);
 
 /*
  * Release the user breakpoints used by ptrace
@@ -424,7 +426,6 @@ void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
 	}
 }
 
-#ifdef CONFIG_KVM
 void hw_breakpoint_restore(void)
 {
 	set_debugreg(__get_cpu_var(cpu_debugreg[0]), 0);
@@ -435,7 +436,6 @@ void hw_breakpoint_restore(void)
 	set_debugreg(__get_cpu_var(dr7), 7);
 }
 EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
-#endif
 
 /*
  * Handle debug exception notifications.
