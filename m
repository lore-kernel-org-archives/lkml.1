Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbXIHH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbXIHH5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXIHH4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:56:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:54990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752742AbXIHH4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:56:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+/L7woCUK/21U5QMb1hHzNLPtV9y5QpUSHmB1dFL
	j/5N5m1rIL8jxv
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <Pine.LNX.4.64.0709071634450.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
	 <1188694367.11196.42.camel@dhcp193.mvista.com>
	 <20070902072029.GA24427@elte.hu>
	 <Pine.LNX.4.64.0709071634450.1817@scrub.home>
Content-Type: text/plain
Date: Sat, 08 Sep 2007 09:56:48 +0200
Message-Id: <1189238208.6575.54.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 17:35 +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 2 Sep 2007, Ingo Molnar wrote:
> 
> Below is a patch updated against the latest git tree, no major changes.

Interesting, I see major behavioral changes.

I still see an aberration with fairtest2.  On startup, the hog component
will consume 100% cpu for a bit, then the sleeper shows up.  This
doesn't always happen, but happens quite often.  The time it takes for
the sleeper to show up varies, but is roughly as below.  With the
previous kernel, sleeper starvation was permanent once the hog ran for a
bit.  This behavior inverted itself, starvation now goes away after a
bit.

6573 root      20   0  1568  468  384 R   51  0.0   0:08.30 1 fairtest2
6574 root      20   0  1568  112   28 R   47  0.0   0:01.07 1 fairtest2

Once it coughs up it's fairtest2 startup-furball, it does well on mixed
load (various interval sleepers + hog) fairness.  The previous kernel
did not do at all well at mixed load, as soon as I added a hog, it was
all over for sleepers, and even without a hog, fairness among the
various interval sleepers was not at all good.

On the interactivity front, your first cut was not really usable here,
but this one seems fine <not heavily tested caveat>.  One test I do here
is Amarok song switch time under hefty kbuild load, and this kernel
passes that test just fine.  I didn't try this test with your first cut,
because it was very ragged even under modest load.  All in all, this one
is behaving quite well, which is radically different than my experience
with first cut.

Debug messages triggered on boot, but haven't triggered since.

[  113.426575] audit(1189232695.670:2): audit_backlog_limit=256 old=64 by auid=4294967295 res=1
[  113.953958] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[  115.851209] audit(1189232698.095:3): audit_pid=5597 old=0 by auid=4294967295
[  116.707631] 2,f73035a0(5624): 1fa78027f5c,1fb37ff0000,f7d035a0(5626),1
[  116.723091] WARNING: at kernel/sched_norm.c:243 verify_queue()
[  116.737979]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  116.752191]  [<c0105d83>] show_trace+0x12/0x14
[  116.765544]  [<c0105d9b>] dump_stack+0x16/0x18
[  116.778579]  [<c011e489>] verify_queue+0x158/0x388
[  116.791716]  [<c011e6db>] enqueue_entity+0x22/0x19a
[  116.804880]  [<c011e9e2>] task_new_fair+0xa9/0xd2
[  116.817724]  [<c0123c47>] wake_up_new_task+0x9e/0xad
[  116.830723]  [<c0125ddc>] do_fork+0x13c/0x205
[  116.843063]  [<c0102258>] sys_clone+0x33/0x39
[  116.855353]  [<c0104182>] sysenter_past_esp+0x5f/0x85
[  116.868344]  =======================
[  116.879674] 2,f7303ae0(5618): 1fbf7fca89d,1fb37ff0000,f7d035a0(5626),1
[  116.894100] WARNING: at kernel/sched_norm.c:250 verify_queue()
[  116.907863]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  116.920912]  [<c0105d83>] show_trace+0x12/0x14
[  116.933141]  [<c0105d9b>] dump_stack+0x16/0x18
[  116.945361]  [<c011e5b9>] verify_queue+0x288/0x388
[  116.957945]  [<c011e6db>] enqueue_entity+0x22/0x19a
[  116.970363]  [<c011e9e2>] task_new_fair+0xa9/0xd2
[  116.982308]  [<c0123c47>] wake_up_new_task+0x9e/0xad
[  116.994597]  [<c0125ddc>] do_fork+0x13c/0x205
[  117.006331]  [<c0102258>] sys_clone+0x33/0x39
[  117.017848]  [<c0104182>] sysenter_past_esp+0x5f/0x85
[  117.029869]  =======================

<repeats dozen times or so>


