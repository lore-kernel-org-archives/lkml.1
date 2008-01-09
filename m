Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYAIJKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYAIJKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYAIJKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:10:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35116 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYAIJKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:10:12 -0500
Date: Wed, 9 Jan 2008 10:09:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109090956.GA14274@elte.hu>
References: <20080109035534.GA30321@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109035534.GA30321@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Unfortunately simply adding __vsyscall_fn to native_read_tsc doesn't 
> work -- causes early kernel faults like
> 
> PANIC: early exception rip ffffffffff600105 error 10 cr2 ffffffffff600105
> Pid: 0, comm: swapper Not tainted 2.6.24-rc6 #58
> 
> Call Trace:
>  [<ffffffff80211dec>] native_sched_clock+0x9/0x3f
>  [<ffffffff8022b758>] init_idle+0x33/0xd1
>  [<ffffffff80825449>] sched_init+0x26d/0x283
>  [<ffffffff80815899>] start_kernel+0x10b/0x2bd
>  [<ffffffff80815114>] _sinittext+0x114/0x11b
> 
> Not sure why that is -- in theory the vsyscall functions should be 
> callable from the main kernel. Might be a binutils problem or another 
> code regression.

nope, it's a 64-bit setup/dependency bug/problem: the vsyscall mappings 
are installed via an __initcall, and that's too late for early use. The 
combo patch below fixed the crash for me, does it work on your box too?

	Ingo

Index: linux-x86.q/arch/x86/kernel/rtc.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/rtc.c
+++ linux-x86.q/arch/x86/kernel/rtc.c
@@ -195,7 +195,7 @@ int update_persistent_clock(struct times
 	return set_rtc_mmss(now.tv_sec);
 }
 
-unsigned long long native_read_tsc(void)
+unsigned long long __vsyscall_fn native_read_tsc(void)
 {
 	DECLARE_ARGS(val, low, high);
 
Index: linux-x86.q/arch/x86/kernel/setup_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_64.c
+++ linux-x86.q/arch/x86/kernel/setup_64.c
@@ -46,6 +46,7 @@
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
+#include <asm/vsyscall.h>
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/msr.h>
@@ -464,6 +465,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	reserve_crashkernel();
 	paging_init();
+	map_vsyscall();
 
 	early_quirks();
 
Index: linux-x86.q/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-x86.q/arch/x86/kernel/vsyscall_64.c
@@ -319,7 +319,7 @@ cpu_vsyscall_notifier(struct notifier_bl
 	return NOTIFY_DONE;
 }
 
-static void __init map_vsyscall(void)
+void __init map_vsyscall(void)
 {
 	extern char __vsyscall_0;
 	unsigned long physaddr_page0 = __pa_symbol(&__vsyscall_0);
@@ -335,7 +335,6 @@ static int __init vsyscall_init(void)
 	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
 	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
-	map_vsyscall();
 #ifdef CONFIG_SYSCTL
 	register_sysctl_table(kernel_root_table2);
 #endif
