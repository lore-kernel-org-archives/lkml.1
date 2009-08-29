Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZH2LZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZH2LZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 07:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZH2LZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 07:25:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZH2LZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 07:25:55 -0400
Date: Sat, 29 Aug 2009 11:25:09 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251472247.17617.74.camel@laptop>
References: <1251472247.17617.74.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter: Fix /0 bug in swcounters
Message-ID: <tip-eced1dfcfcf6b0a35e925d73916a9d8e36ab5457@git.kernel.org>
Git-Commit-ID: eced1dfcfcf6b0a35e925d73916a9d8e36ab5457
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 11:25:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eced1dfcfcf6b0a35e925d73916a9d8e36ab5457
Gitweb:     http://git.kernel.org/tip/eced1dfcfcf6b0a35e925d73916a9d8e36ab5457
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 28 Aug 2009 17:10:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 13:20:11 +0200

perf_counter: Fix /0 bug in swcounters

We have a race in the swcounter stuff where we can start
counting a counter that has never been enabled, this leads to a
/0 situation.

The below avoids the /0 but doesn't close the race, this would
need a new counter state.

The race is due to perf_swcounter_is_counting() which cannot
discern between disabled due to scheduled out, and disabled for
any other reason.

Such a crash has been seen by Ingo:

[  967.092372] divide error: 0000 [#1] SMP
[  967.096499] last sysfs file: /sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[  967.104846] CPU 5
[  967.106965] Modules linked in:
[  967.110169] Pid: 3351, comm: hackbench Not tainted 2.6.31-rc8-tip-01158-gd940a54-dirty #1568 X8DTN
[  967.119456] RIP: 0010:[<ffffffff810c0aba>]  [<ffffffff810c0aba>] perf_swcounter_ctx_event+0x127/0x1af
[  967.129137] RSP: 0018:ffff8801a95abd70  EFLAGS: 00010046
[  967.134699] RAX: 0000000000000002 RBX: ffff8801bd645c00 RCX: 0000000000000002
[  967.142162] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801bd645d40
[  967.149584] RBP: ffff8801a95abdb0 R08: 0000000000000001 R09: ffff8801a95abe00
[  967.157042] R10: 0000000000000037 R11: ffff8801aa1245f8 R12: ffff8801a95abe00
[  967.164481] R13: ffff8801a95abe00 R14: ffff8801aa1c0e78 R15: 0000000000000001
[  967.171953] FS:  0000000000000000(0000) GS:ffffc90000a00000(0063) knlGS:00000000f7f486c0
[  967.180406] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  967.186374] CR2: 000000004822c0ac CR3: 00000001b19a2000 CR4: 00000000000006e0
[  967.193770] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  967.201224] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  967.208692] Process hackbench (pid: 3351, threadinfo ffff8801a95aa000, task ffff8801a96b0000)
[  967.217607] Stack:
[  967.219711]  0000000000000000 0000000000000037 0000000200000001 ffffc90000a1107c
[  967.227296] <0> ffff8801a95abe00 0000000000000001 0000000000000001 0000000000000037
[  967.235333] <0> ffff8801a95abdf0 ffffffff810c0c20 0000000200a14f30 ffff8801a95abe40
[  967.243532] Call Trace:
[  967.246103]  [<ffffffff810c0c20>] do_perf_swcounter_event+0xde/0xec
[  967.252635]  [<ffffffff810c0ca7>] perf_tpcounter_event+0x79/0x7b
[  967.258957]  [<ffffffff81037f73>] ftrace_profile_sched_switch+0xc0/0xcb
[  967.265791]  [<ffffffff8155f22d>] schedule+0x429/0x4c4
[  967.271156]  [<ffffffff8100c01e>] int_careful+0xd/0x14

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1251472247.17617.74.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 7d4bb83..d7cbc57 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4066,6 +4066,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	hwc->sample_period = attr->sample_period;
 	if (attr->freq && attr->sample_freq)
 		hwc->sample_period = 1;
+	hwc->last_period = hwc->sample_period;
 
 	atomic64_set(&hwc->period_left, hwc->sample_period);
 
