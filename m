Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZIWQTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZIWQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZIWQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:19:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:39775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZIWQTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:19:48 -0400
Date: Wed, 23 Sep 2009 16:19:13 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, GNUtoo@no-log.org, ying.huang@intel.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, GNUtoo@no-log.org, ying.huang@intel.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <bug-14204-5438@http.bugzilla.kernel.org/>
References: <bug-14204-5438@http.bugzilla.kernel.org/>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: mce: Use safer ways to access MCE registers
Message-ID: <tip-11868a2dc4f5e4f2f652bfd259e1360193fcee62@git.kernel.org>
Git-Commit-ID: 11868a2dc4f5e4f2f652bfd259e1360193fcee62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 16:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11868a2dc4f5e4f2f652bfd259e1360193fcee62
Gitweb:     http://git.kernel.org/tip/11868a2dc4f5e4f2f652bfd259e1360193fcee62
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 23 Sep 2009 17:49:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 18:08:26 +0200

x86: mce: Use safer ways to access MCE registers

Use rdmsrl_safe() when accessing MCE registers. While in
theory we always 'know' which ones are safe to access from
the capability bits, there's a lot of hardware variations
and reality might differ from theory, as it did in this case:

   http://bugzilla.kernel.org/show_bug.cgi?id=14204

[    0.010016] mce: CPU supports 5 MCE banks
[    0.011029] general protection fault: 0000 [#1]
[    0.011998] last sysfs file:
[    0.011998] Modules linked in:
[    0.011998]
[    0.011998] Pid: 0, comm: swapper Not tainted (2.6.31_router #1) HP Vectra
[    0.011998] EIP: 0060:[<c100d9b9>] EFLAGS: 00010246 CPU: 0
[    0.011998] EIP is at mce_rdmsrl+0x19/0x60
[    0.011998] EAX: 00000000 EBX: 00000001 ECX: 00000407 EDX: 08000000
[    0.011998] ESI: 00000000 EDI: 8c000000 EBP: 00000405 ESP: c17d5eac

So WARN_ONCE() instead of crashing the box.

( also fix a number of stylistic inconsistencies in the code. )

Note, we might still crash in wrmsrl() if we get that far, but
we shouldnt if the registers are truly inaccessible.

Reported-by: GNUtoo <GNUtoo@no-log.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <bug-14204-5438@http.bugzilla.kernel.org/>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/mce.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2f5aab2..4b2af86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -305,13 +305,25 @@ static int msr_to_offset(u32 msr)
 static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
+
 	if (__get_cpu_var(injectm).finished) {
 		int offset = msr_to_offset(msr);
+
 		if (offset < 0)
 			return 0;
 		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
 	}
-	rdmsrl(msr, v);
+
+	if (rdmsrl_safe(msr, &v)) {
+		WARN_ONCE(1, "mce: Unable to read msr %d!\n", msr);
+		/*
+		 * Return zero in case the access faulted. This should
+		 * not happen normally but can happen if the CPU does
+		 * something weird, or if the code is buggy.
+		 */
+		v = 0;
+	}
+
 	return v;
 }
 
@@ -319,6 +331,7 @@ static void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__get_cpu_var(injectm).finished) {
 		int offset = msr_to_offset(msr);
+
 		if (offset >= 0)
 			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
 		return;
@@ -415,7 +428,7 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC 
+#ifdef CONFIG_X86_LOCAL_APIC
 /*
  * Called after interrupts have been reenabled again
  * when a MCE happened during an interrupts off region
@@ -1172,6 +1185,7 @@ static int mce_banks_init(void)
 		return -ENOMEM;
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		b->ctl = -1ULL;
 		b->init = 1;
 	}
@@ -1203,6 +1217,7 @@ static int __cpuinit mce_cap_init(void)
 	banks = b;
 	if (!mce_banks) {
 		int err = mce_banks_init();
+
 		if (err)
 			return err;
 	}
@@ -1237,6 +1252,7 @@ static void mce_init(void)
 
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (!b->init)
 			continue;
 		wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
@@ -1626,6 +1642,7 @@ static int mce_disable(void)
 
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
@@ -1911,6 +1928,7 @@ static void mce_disable_cpu(void *h)
 		cmci_clear();
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
@@ -1928,6 +1946,7 @@ static void mce_reenable_cpu(void *h)
 		cmci_reenable();
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
 	}
