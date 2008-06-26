Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbYFZNj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbYFZNj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYFZNjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:39:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYFZNjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:39:44 -0400
Date: Thu, 26 Jun 2008 15:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>,
       PeterZijlstra <peterz@infradead.org>, "Daniel K." <dk@uw.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: divide error trying to set rt_period to zero
Message-ID: <20080626133924.GA20188@elte.hu>
References: <1214432249.5464.22.camel@Palanthas.Krynn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214432249.5464.22.camel@Palanthas.Krynn>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Dario Faggioli <raistlin@linux.it> wrote:

> Hi all again,
> 
> Here it is another little Oops we found:
> 
> echo 0 > /dev/cgroups/0/cpu.rt_period_us
> or
> echo 4294967296 > /dev/cgroups/0/cpu.rt_period_us
> 
> [  205.509825] divide error: 0000 [#1] 
> [  205.510151] Modules linked in:
> [  205.510151] 
> [  205.510151] Pid: 2339, comm: bash Not tainted (2.6.26-rc8 #33)
> [  205.510151] EIP: 0060:[<c030c6ef>] EFLAGS: 00000293 CPU: 0
> [  205.510151] EIP is at div64_u64+0x5f/0x70
> [  205.510151] EAX: 0000389f EBX: 00000000 ECX: 00000000 EDX: 00000000
> [  205.510151] ESI: d9800000 EDI: 00000000 EBP: c6cede60 ESP: c6cede50
> [  205.510151]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  205.510151] Process bash (pid: 2339, ti=c6cec000 task=c79be370 task.ti=c6cec000)
> [  205.510151] Stack: d9800000 0000389f c05971a0 d9800000 c6cedeb4 c0214dbd 00000000 00000000 
> [  205.510151]        c6cede88 c0242bd8 c05377c0 c7a41b40 00000000 00000000 00000000 c05971a0 
> [  205.510151]        c780ed20 c7508494 c7a41b40 00000000 00000002 c6cedebc c05971a0 ffffffea 
> [  205.510151] Call Trace:
> [  205.510151]  [<c0214dbd>] ? __rt_schedulable+0x1cd/0x240
> [  205.510151]  [<c0242bd8>] ? cgroup_file_open+0x18/0xe0
> [  205.510151]  [<c0214fe4>] ? tg_set_bandwidth+0xa4/0xf0
> [  205.510151]  [<c0215066>] ? sched_group_set_rt_period+0x36/0x50
> [  205.510151]  [<c021508e>] ? cpu_rt_period_write_uint+0xe/0x10
> [  205.510151]  [<c0242dc5>] ? cgroup_file_write+0x125/0x160
> [  205.510151]  [<c0232c15>] ? hrtimer_interrupt+0x155/0x190
> [  205.510151]  [<c02f047f>] ? security_file_permission+0xf/0x20
> [  205.510151]  [<c0277ad8>] ? rw_verify_area+0x48/0xc0
> [  205.510151]  [<c0283744>] ? dupfd+0x104/0x130
> [  205.510151]  [<c027838c>] ? vfs_write+0x9c/0x160
> [  205.510151]  [<c0242ca0>] ? cgroup_file_write+0x0/0x160
> [  205.510151]  [<c027850d>] ? sys_write+0x3d/0x70
> [  205.510151]  [<c0203019>] ? sysenter_past_esp+0x6a/0x91
> [  205.510151]  =======================
> [  205.510151] Code: 0f 45 de 31 f6 0f ad d0 d3 ea f6 c1 20 0f 45 c2 0f 45 d6 89 45 f0 89 55 f4 8b 55 f4 31 c9 8b 45 f0 39 d3 89 c6 77 08 89 d0 31 d2 <f7> f3 89 c1 83 c4 08 89 f0 f7 f3 89 ca 5b 5e 5d c3 55 89 e5 56 
> [  205.510151] EIP: [<c030c6ef>] div64_u64+0x5f/0x70 SS:ESP 0068:c6cede50
> 
> The attached patch solves the issue for me.

> @@ -8501,6 +8501,9 @@ int sched_group_set_rt_period(struct task_group
> *tg, long rt_period_us)
>  	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
>  	rt_runtime = tg->rt_bandwidth.rt_runtime;
>  
> +	if (period == 0)
> +		return -EINVAL;

this patch doesnt even build, because there's no "period" variable.

	Ingo
