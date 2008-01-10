Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbYAJGE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbYAJGE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYAJGEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:04:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56659 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYAJGEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:04:48 -0500
Date: Wed, 9 Jan 2008 22:04:21 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Fix x86 32 bit FRAME_POINTER chasing code
Message-ID: <20080109220421.630d3516@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is simple; I don't know if it's .24 candidate; the bug is pretty bad but not a recent regression,
and there is obviously some risk with touching this code.



Subject: Fix x86 32 bit FRAME_POINTER chasing code
From: Arjan van de Ven <arjan@linux.intel.com>

The current x86 32 bit FRAME_POINTER chasing code has a nasty bug in
that the EBP tracer doesn't actually update the value of EBP it is
tracing, so that the code doesn't actually switch to the irq stack properly.

The result is a truncated backtrace:

WARNING: at timeroops.c:8 kerneloops_regression_test() (Not tainted)
Pid: 0, comm: swapper Not tainted 2.6.24-0.77.rc4.git4.fc9 #1
 [<c040649a>] show_trace_log_lvl+0x1a/0x2f
 [<c0406d41>] show_trace+0x12/0x14
 [<c0407061>] dump_stack+0x6c/0x72
 [<e0258049>] kerneloops_regression_test+0x44/0x46 [timeroops]
 [<c04371ac>] run_timer_softirq+0x127/0x18f
 [<c0434685>] __do_softirq+0x78/0xff
 [<c0407759>] do_softirq+0x74/0xf7
 =======================

This patch fixes the code to update EBP properly, and to check the EIP
before printing (as the non-framepointer backtracer does) so that 
the same test backtrace now looks like this:

WARNING: at timeroops.c:8 kerneloops_regression_test()
Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #4
 [<c0405d17>] show_trace_log_lvl+0x1a/0x2f
 [<c0406681>] show_trace+0x12/0x14
 [<c0406ef2>] dump_stack+0x6a/0x70
 [<e01f6040>] kerneloops_regression_test+0x3b/0x3d [timeroops]
 [<c0426f07>] run_timer_softirq+0x11b/0x17c
 [<c04243ac>] __do_softirq+0x42/0x94
 [<c040704c>] do_softirq+0x50/0xb6
 [<c04242a9>] irq_exit+0x37/0x67
 [<c040714c>] do_IRQ+0x9a/0xaf
 [<c04057da>] common_interrupt+0x2e/0x34
 [<c05807fe>] cpuidle_idle_call+0x52/0x78
 [<c04034f3>] cpu_idle+0x46/0x60
 [<c05fbbd3>] rest_init+0x43/0x45
 [<c070aa3d>] start_kernel+0x279/0x27f
 =======================

This shows that the backtrace goes all the way down to user context now.
This bug was found during the port to 64 bit of the frame pointer backtracer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/kernel/traps_32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.24-rc7.orig/arch/x86/kernel/traps_32.c
+++ linux-2.6.24-rc7/arch/x86/kernel/traps_32.c
@@ -124,7 +124,8 @@ static inline unsigned long print_contex
 		unsigned long addr;
 
 		addr = frame->return_address;
-		ops->address(data, addr);
+		if (__kernel_text_address(addr))
+			ops->address(data, addr);
 		/*
 		 * break out of recursive entries (such as
 		 * end_of_stack_stop_unwind_function). Also,
@@ -132,6 +133,7 @@ static inline unsigned long print_contex
 		 * move downwards!
 		 */
 		next = frame->next_frame;
+		ebp = (unsigned long) next;
 		if (next <= frame)
 			break;
 		frame = next;

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
