Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYI3Lxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYI3Lxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYI3Lxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:53:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYI3Lxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:53:34 -0400
Date: Tue, 30 Sep 2008 13:53:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] Unified trace buffer
Message-ID: <20080930115315.GA2779@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930030652.100327014@goodmis.org> <20080930094516.GA1276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930094516.GA1276@elte.hu>
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


a third type of lockdep splat surfaced in -tip testing:

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc8-tip #37560
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&cpu_buffer->lock){.+..}, at: [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e

but task is already holding lock:
 (&cpu_buffer->lock){.+..}, at: [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e

other info that might help us debug this:
2 locks held by swapper/0:
 #0:  (&rq->lock){++..}, at: [<ffffffff80754540>] schedule+0x16f/0x839
 #1:  (&cpu_buffer->lock){.+..}, at: [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.27-rc8-tip #37560
Call Trace:
 [<ffffffff802743b6>] __lock_acquire+0xb2a/0x116f
 [<ffffffff80274a88>] lock_acquire+0x8d/0xba
 [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e
 [<ffffffff80756b7c>] _spin_lock+0x29/0x34
 [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e
 [<ffffffff8039d992>] __next_cpu+0x19/0x28
 [<ffffffff802906ac>] ring_buffer_lock+0x46/0x5e
 [<ffffffff80290762>] ring_buffer_reset+0x1c/0x58
 [<ffffffff802942b9>] update_max_tr+0x5f/0x7f
 [<ffffffff802954e0>] probe_wakeup_sched_switch+0x175/0x189
 [<ffffffff80754aa8>] schedule+0x6d7/0x839
 [<ffffffff80273de2>] __lock_acquire+0x556/0x116f
 [<ffffffff807567bb>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802732c8>] trace_hardirqs_on_caller+0xb4/0xd7
 [<ffffffff807567bb>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff80269ea4>] ktime_get_ts+0x21/0x4a
 [<ffffffff8026c44f>] getnstimeofday+0x38/0x98
 [<ffffffff80269ea4>] ktime_get_ts+0x21/0x4a
 [<ffffffff80227fc8>] native_sched_clock+0x8c/0xa6
 [<ffffffff8026b485>] sched_clock_tick+0x78/0x80
 [<ffffffff8027020f>] tick_nohz_restart_sched_tick+0x16b/0x178
 [<ffffffff802732c8>] trace_hardirqs_on_caller+0xb4/0xd7
 [<ffffffff8021fd70>] cpu_idle+0x77/0x79
driver: '2-0:1.0': driver_bound: bound to device 'hub'

	Ingo
