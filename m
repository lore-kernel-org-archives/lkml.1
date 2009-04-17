Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbZDQVNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbZDQVNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZDQVMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbZDQVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:33 -0400
Message-Id: <20090417211231.649674806@goodmis.org>
References: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlsta <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] lockdep,x86: account for irqs enabled in paranoid_exit
Content-Disposition: inline; filename=0005-lockdep-x86-account-for-irqs-enabled-in-paranoid_ex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

I hit the check_flags error of lockdep:

WARNING: at kernel/lockdep.c:2893 check_flags+0x1a7/0x1d0()
[...]
hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0

The check_flags warning of lockdep tells me that lockdep thought interrupts
were disabled, but they were really enabled.

The numbers in the above parenthesis show the order of events:

12566: softirqs last enabled:  lock_sock_nested
12567: hardirqs last enabled:  local_bh_enable
12568: softirqs last disabled: tcp_prequeue_process
12566: hardirqs last disabled: int3

int3 is a breakpoint!

Examining this further, I have CONFIG_NET_TCPPROBE enabled which adds
break points into the kernel.

The paranoid_exit of the return of int3 does not account for enabling
interrupts on return to kernel. This code is a bit tricky since it
is also used by the nmi handler (when lockdep is off), and we must be
careful about the swapgs. We can not call kernel code after the swapgs
has been performed.

[ Impact: fix lockdep check_flags warning ]

Acked-by: Peter Zijlsta <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1ac9986..987f91f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1397,7 +1397,10 @@ ENTRY(paranoid_exit)
 paranoid_swapgs:
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
+	RESTORE_ALL 8
+	jmp irq_return
 paranoid_restore:
+	TRACE_IRQS_IRETQ 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:
-- 
1.6.2.1

-- 
