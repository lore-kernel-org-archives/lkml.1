Return-Path: <linux-kernel-owner+w=401wt.eu-S1764996AbYHFJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764996AbYHFJi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbYHFJia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:38:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:56682 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbYHFJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EuE8j2CN1zgmRADkhOAXatsCcAm53/ZrMNJwo4/p7KjHFVorxxASheEQTryDXwkxdv
         U3q2K1noWM5+4KQG+bNQr5ygR4Nrxhs0ahL5awfA5/Rp2StrtTNAHiO2x1mSBVQwQdQE
         W4KU4WY2Z86cY5bqyGyFhB/7lRvkigyO1e6Hw=
Message-ID: <520f0cf10808060238r513c2f35l16c0da5511cea0f1@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:38:26 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: tracing WARN_ON in rt kernel
Cc: rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, the following is one for you.

The kernel is 2.6.26.1 plus the 2.6.26-rt1 patch (yes it applies
against 2.6.26.1) and some of the patches that were discussed in the
lists. I don't think it is relevant which patches, but if you need an
exact list I will provide it.

WARNING: at kernel/trace/trace_hist.c:396
tracing_hist_preempt_stop+0x23d/0x301()
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.26.1-rt1.jk #4

Call Trace:
 [<ffffffff802397f4>] warn_on_slowpath+0x5d/0x99
 [<ffffffff80212a0d>] ? native_sched_clock+0x2b/0x76
 [<ffffffff802127d5>] ? sched_clock+0x9/0xc
 [<ffffffff80283231>] ? ftrace_now+0x9/0xb
 [<ffffffff80288439>] ? tracing_hist_preempt_stop+0xd9/0x301
 [<ffffffff8020b48c>] ? do_notify_resume+0x14/0x8ef
 [<ffffffff80286499>] ? trace_hardirqs_on+0x1b/0x138
 [<ffffffff8020b48c>] ? do_notify_resume+0x14/0x8ef
 [<ffffffff8028859d>] tracing_hist_preempt_stop+0x23d/0x301
 [<ffffffff8020c4db>] ? sysret_signal+0x30/0x4f
 [<ffffffff80286499>] trace_hardirqs_on+0x1b/0x138
 [<ffffffff8020b478>] ? do_notify_resume+0x0/0x8ef
 [<ffffffff8020c4db>] ? sysret_signal+0x30/0x4f
 [<ffffffff8020b4e6>] do_notify_resume+0x6e/0x8ef
 [<ffffffff8046ce35>] ? rt_spin_lock+0xe/0x10
 [<ffffffff8024ea2a>] ? remove_wait_queue+0x3e/0x43
 [<ffffffff8023d214>] ? do_wait+0xb6b/0xbf7
 [<ffffffff80212a0d>] ? native_sched_clock+0x2b/0x76
 [<ffffffff802127d5>] ? sched_clock+0x9/0xc
 [<ffffffff80283231>] ? ftrace_now+0x9/0xb
 [<ffffffff80288637>] ? tracing_hist_preempt_stop+0x2d7/0x301
 [<ffffffff8020c4b0>] ? sysret_signal+0x5/0x4f
 [<ffffffff8046ca94>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff8020c4db>] ? sysret_signal+0x30/0x4f
 [<ffffffff8020c8b7>] ptregscall_common+0x67/0xb0

---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------


This above is triggered by the WARN_ON in the following code in
function tracing_hist_preempt_stop()

#if defined(CONFIG_INTERRUPT_OFF_HIST) && defined(CONFIG_PREEMPT_OFF_HIST)
	if (((!irqs_on && !irqs_disabled()) ||
	     (irqs_on && !preempt_count()) ||
	     (irqs_on == TRACE_STOP)) &&
	    per_cpu(hist_preemptirqsoff_tracing, cpu)) {
		WARN_ON(!preempt_count() && !irqs_disabled());
		if (1 || !stop_set)
			stop = ftrace_now(cpu);
		start = per_cpu(hist_preemptirqsoff_start, cpu);
		latency = (long)nsecs_to_usecs(stop - start);
		if (latency > 1000000) {
			printk("%d: latency = %ld (%lu)\n", __LINE__, latency, latency);
			printk("%d: start=%Ld  stop=%Ld\n", __LINE__, start, stop);
		}
		barrier();
		per_cpu(hist_preemptirqsoff_tracing, cpu) = 0;
		latency_hist(PREEMPT_INTERRUPT_LATENCY, cpu, latency);
	}
#endif
