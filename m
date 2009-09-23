Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZIWLtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZIWLtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZIWLtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:49:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:43383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZIWLtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:49:50 -0400
Date: Wed, 23 Sep 2009 11:49:05 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, gorcunov@gmail.com, mail@chrismalley.co.uk,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mail@chrismalley.co.uk, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event, x86: Fix 'perf sched record' crashing the machine
Message-ID: <tip-7d42896628202a551ad1107697cd215dc5fca099@git.kernel.org>
Git-Commit-ID: 7d42896628202a551ad1107697cd215dc5fca099
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 11:49:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d42896628202a551ad1107697cd215dc5fca099
Gitweb:     http://git.kernel.org/tip/7d42896628202a551ad1107697cd215dc5fca099
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 23 Sep 2009 11:03:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 11:25:56 +0200

perf_event, x86: Fix 'perf sched record' crashing the machine

Chris Malley reported that 'perf sched record' sometimes
crashes his box with:

[  389.272175] BUG: unable to handle kernel paging request at ffffb300
[  389.272294] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
[  389.272366] *pde = 0073f067 *pte = 00000000
[  389.274708] Call Trace:
[  389.274752]  [<c010e3b4>] ?  set_perf_event_pending+0x14/0x20
[  389.274801]  [<c01b9751>] ?  perf_output_unlock+0x121/0x1a0
[  389.274848]  [<c01b981a>] ? perf_output_end+0x4a/0x70
[  389.274893]  [<c01ba690>] ?  __perf_event_overflow+0x240/0x2f0
[  389.274942]  [<c030963e>] ? atomic64_cmpxchg+0x1e/0x30
[  389.274988]  [<c01ba8f4>] ?  perf_swevent_ctx_event+0x1b4/0x1c0
[  389.275035]  [<c01ba773>] ?  perf_swevent_ctx_event+0x33/0x1c0
[  389.275081]  [<c01ba9a7>] ? do_perf_sw_event+0xa7/0x160
[  389.275127]  [<c01baae2>] ? perf_tp_event+0x82/0xa0
[  389.275174]  [<c012e9c6>] ?  ftrace_profile_sched_stat_runtime+0xe6/0x120
[  389.275224]  [<c012e8e0>] ?  ftrace_profile_sched_stat_runtime+0x0/0x120
[  389.275273]  [<c013c85a>] ? update_curr+0x18a/0x230
[  389.275318]  [<c013cdc5>] ?  put_prev_task_fair+0x155/0x160
[  389.275366]  [<c01618b5>] ? sched_clock_cpu+0xd5/0x110
[  389.275413]  [<c04e7525>] ? _spin_lock_irq+0x45/0x50
[  389.275458]  [<c04e424e>] ? schedule+0x20e/0xb10

The problem is that the box has no lapic enabled:

  [    0.042445] Local APIC not detected. Using dummy APIC emulation.

The below seems like the best fix. We disabled all lapic bits, except
the self-IPI-resend logic.

Reported-by: Chris Malley <mail@chrismalley.co.uk>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a3c7adb..b5801c3 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1790,6 +1790,9 @@ void smp_perf_pending_interrupt(struct pt_regs *regs)
 void set_perf_event_pending(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
+	if (!x86_pmu.apic || !x86_pmu_initialized())
+		return;
+
 	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
 #endif
 }
