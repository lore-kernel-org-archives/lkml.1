Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYKPHLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYKPHLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYKPHLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:11:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbYKPHLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:11:04 -0500
Date: Sun, 16 Nov 2008 08:10:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Luis Henriques <henrix@sapo.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] using smp_processor_id() in preemptible
Message-ID: <20081116071059.GA19646@elte.hu>
References: <20081115233050.GA13439@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115233050.GA13439@hades>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luis Henriques <henrix@sapo.pt> wrote:

> Hi Ingo,
> 
> while running latencytop, got the following:
> 
> [  775.663239] BUG: using smp_processor_id() in preemptible [00000000] code: latencytop/6585
> [  775.663303] caller is native_sched_clock+0x3a/0x80
> [  775.663314] Pid: 6585, comm: latencytop Tainted: G        W 2.6.28-rc4-00355-g9c7c354 #1
> [  775.663322] Call Trace:
> [  775.663343]  [<ffffffff803a94e4>] debug_smp_processor_id+0xe4/0xf0
> [  775.663356]  [<ffffffff80213f7a>] native_sched_clock+0x3a/0x80
> [  775.663368]  [<ffffffff80213e19>] sched_clock+0x9/0x10
> [  775.663381]  [<ffffffff8024550d>] proc_sched_show_task+0x8bd/0x10e0
> [  775.663395]  [<ffffffff8034466e>] sched_show+0x3e/0x80
> [  775.663408]  [<ffffffff8031039b>] seq_read+0xdb/0x350
> [  775.663421]  [<ffffffff80368776>] ? security_file_permission+0x16/0x20
> [  775.663435]  [<ffffffff802f4198>] vfs_read+0xc8/0x170
> [  775.663447]  [<ffffffff802f4335>] sys_read+0x55/0x90
> [  775.663460]  [<ffffffff8020c67a>] system_call_fastpath+0x16/0x1b
> ...
> 
> I am running 2.6.28-rc4-00355-g9c7c354 and, after taking a look at 
> the code, it looks like the problem is in commit 
> 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5, where native_sched_clock 
> is modified to use __cycles_2_ns instead of cycles_2_ns.

indeed. Does the fix below work for you?

Thanks,

	Ingo

-------------->
>From 29d7b90c15035741d15421b36000509212b3e135 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 16 Nov 2008 08:07:15 +0100
Subject: [PATCH] sched: fix kernel warning on /proc/sched_debug access

Luis Henriques reported that with CONFIG_PREEMPT=y + CONFIG_PREEMPT_DEBUG=y +
CONFIG_SCHED_DEBUG=y + CONFIG_LATENCYTOP=y enabled, the following warning
triggers when using latencytop:

> [  775.663239] BUG: using smp_processor_id() in preemptible [00000000] code: latencytop/6585
> [  775.663303] caller is native_sched_clock+0x3a/0x80
> [  775.663314] Pid: 6585, comm: latencytop Tainted: G        W 2.6.28-rc4-00355-g9c7c354 #1
> [  775.663322] Call Trace:
> [  775.663343]  [<ffffffff803a94e4>] debug_smp_processor_id+0xe4/0xf0
> [  775.663356]  [<ffffffff80213f7a>] native_sched_clock+0x3a/0x80
> [  775.663368]  [<ffffffff80213e19>] sched_clock+0x9/0x10
> [  775.663381]  [<ffffffff8024550d>] proc_sched_show_task+0x8bd/0x10e0
> [  775.663395]  [<ffffffff8034466e>] sched_show+0x3e/0x80
> [  775.663408]  [<ffffffff8031039b>] seq_read+0xdb/0x350
> [  775.663421]  [<ffffffff80368776>] ? security_file_permission+0x16/0x20
> [  775.663435]  [<ffffffff802f4198>] vfs_read+0xc8/0x170
> [  775.663447]  [<ffffffff802f4335>] sys_read+0x55/0x90
> [  775.663460]  [<ffffffff8020c67a>] system_call_fastpath+0x16/0x1b
> ...

This breakage was caused by me via:

  7cbaef9: sched: optimize sched_clock() a bit

Change the calls to cpu_clock().

Reported-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/sched_debug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 48ecc51..26ed8e3 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -423,10 +423,11 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 #undef __P
 
 	{
+		unsigned int this_cpu = raw_smp_processor_id();
 		u64 t0, t1;
 
-		t0 = sched_clock();
-		t1 = sched_clock();
+		t0 = cpu_clock(this_cpu);
+		t1 = cpu_clock(this_cpu);
 		SEQ_printf(m, "%-35s:%21Ld\n",
 			   "clock-delta", (long long)(t1-t0));
 	}

