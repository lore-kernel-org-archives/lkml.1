Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYAEKTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYAEKTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 05:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYAEKTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 05:19:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:35344 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYAEKTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 05:19:31 -0500
Subject: Re: Idle loadavg of ~1, maybe MD related
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20080105100455.GB911@curie-int.orbis-terrarum.net>
References: <20071230100614.GX17327@curie-int.orbis-terrarum.net>
	 <20080105013037.a354b33a.akpm@linux-foundation.org>
	 <20080105100455.GB911@curie-int.orbis-terrarum.net>
Content-Type: text/plain
Date: Sat, 05 Jan 2008 21:18:52 +1100
Message-Id: <1199528332.7291.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 02:04 -0800, Robin H. Johnson wrote:
> On Sat, Jan 05, 2008 at 01:30:37AM -0800, Andrew Morton wrote:
> > >From that I'd suspect that kwindfarm is being a bad citizen.
> > If a process is consistently stuck in D state, run
> Windfarm.

It's an unfortunate artifact that kernel threads that do
non-interruptible sleep are counted as load...

In the case of windfarm, it does a lot (a _LOT_) of accesses to various
i2c busses and the SMU (the system management unit which controls the
fans). All those are done in the form of short requests during which the
process is doing a wait_for_completion() or similar.

I don't see a better way to do that, I think we could have good use of
something that stops counting those in the load average...

Ben.

> > 	echo w > /proc/sysrq-trigger
> > then record the resulting dmesg output so we can see where it got stuck.
> 
> Traceback:
> [552710.416174] SysRq : Show Blocked State
> [552710.417876]   task                        PC stack   pid father
> [552710.417888] kwindfarm     D 0000000000000000     0   829      2
> [552710.417892] Call Trace:
> [552710.417895] [c00000036c9835f0] [c000000000528b90] 0xc000000000528b90 (unreliable)
> [552710.417908] [c00000036c9837c0] [c00000000000f4a8] .__switch_to+0xd8/0x110
> [552710.417985] [c00000036c983850] [c0000000003bb2a0] .schedule+0x62c/0x6c8
> [552710.417992] [c00000036c983940] [c0000000003bb8c4] .schedule_timeout+0x3c/0xe8
> [552710.417997] [c00000036c983a10] [c0000000003bb51c] .wait_for_common+0x100/0x1bc
> [552710.418002] [c00000036c983ae0] [c000000000285300] .smu_fan_set+0x17c/0x1e4
> [552710.418009] [c00000036c983c30] [c000000000284078] .pm112_wf_notify+0xc50/0x12d0
> [552710.418015] [c00000036c983d20] [c0000000003bfb84] .notifier_call_chain+0x5c/0xcc
> [552710.418021] [c00000036c983dc0] [c00000000006f4b4] .__blocking_notifier_call_chain+0x70/0xb0
> [552710.418027] [c00000036c983e70] [c000000000282d9c] .wf_thread_func+0x78/0x11c
> [552710.418032] [c00000036c983f00] [c000000000069b00] .kthread+0x78/0xc4
> [552710.418039] [c00000036c983f90] [c000000000023d0c] .kernel_thread+0x4c/0x68
> [552710.418064] Sched Debug Version: v0.07, 2.6.24-rc6-prod-g6f0f5304 #10
> [552710.418067] now at 552723945.170635 msecs
> [552710.418070]   .sysctl_sched_latency                    : 60.000000
> [552710.418073]   .sysctl_sched_min_granularity            : 12.000000
> [552710.418076]   .sysctl_sched_wakeup_granularity         : 30.000000
> [552710.418079]   .sysctl_sched_batch_wakeup_granularity   : 30.000000
> [552710.418082]   .sysctl_sched_child_runs_first           : 0.000001
> [552710.418085]   .sysctl_sched_features                   : 7
> 
> Full output at
> http://dev.gentoo.org/~robbat2/20080105_windfarm_sysrq_w.txt
> 

