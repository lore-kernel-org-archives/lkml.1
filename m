Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXL2SDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXL2SDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXL2SDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:03:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42293 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbXL2SDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:03:08 -0500
Subject: Re: WARNING: at kernel/lockdep.c:2658 check_flags()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071229170554.GA21506@joi>
References: <20071229170554.GA21506@joi>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 19:03:07 +0100
Message-Id: <1198951387.31975.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-29 at 18:06 +0100, Marcin Slusarz wrote:
> Hi
> Today I've got this (while i was upgrading my gentoo box):
> 
> WARNING: at kernel/lockdep.c:2658 check_flags()
> Pid: 21680, comm: conftest Not tainted 2.6.24-rc6 #63
> 
> Call Trace:
>  [<ffffffff80253457>] check_flags+0x1c7/0x1d0
>  [<ffffffff80257217>] lock_acquire+0x57/0xc0
>  [<ffffffff8024d5c0>] __atomic_notifier_call_chain+0x60/0xd0
>  [<ffffffff8024d641>] atomic_notifier_call_chain+0x11/0x20
>  [<ffffffff8024d67e>] notify_die+0x2e/0x30
>  [<ffffffff8020da0a>] do_divide_error+0x5a/0xa0
>  [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff80255b89>] trace_hardirqs_on+0xd9/0x180
>  [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff80523c2d>] error_exit+0x0/0xa9
> 
> possible reason: unannotated irqs-off.
> irq event stamp: 4693
> hardirqs last  enabled at (4693): [<ffffffff80522bdd>] trace_hardirqs_on_thunk+0x35/0x3a
> hardirqs last disabled at (4692): [<ffffffff80522c17>] trace_hardirqs_off_thunk+0x35/0x37
> softirqs last  enabled at (3546): [<ffffffff80238343>] __do_softirq+0xb3/0xd0
> softirqs last disabled at (3521): [<ffffffff8020c97c>] call_softirq+0x1c/0x30

more early fixups for notify_die()..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 8fc3a27..3a10cf6 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -543,6 +543,7 @@ void do_##name(struct pt_regs * regs, long error_code) \
 	info.si_errno = 0; \
 	info.si_code = sicode; \
 	info.si_addr = (void __user *)siaddr; \
+	trace_hardirqs_fixup(); \
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
 						== NOTIFY_STOP) \
 		return; \
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 778667a..5e07af1 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -635,6 +635,7 @@ asmlinkage void do_##name(struct pt_regs * regs, long error_code) \
 	info.si_errno = 0; \
 	info.si_code = sicode; \
 	info.si_addr = (void __user *)siaddr; \
+	trace_hardirqs_fixup(); \
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
 							== NOTIFY_STOP) \
 		return; \


