Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYI3JNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYI3JNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYI3JNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:13:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYI3JNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:13:38 -0400
Date: Tue, 30 Sep 2008 11:13:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 0/6] ftrace: port to the new ring_buffer
Message-ID: <20080930091305.GA10822@elte.hu>
References: <20080930030236.230994826@goodmis.org> <20080930074514.GB2838@elte.hu> <20080930082302.GA2852@elte.hu> <20080930083051.GA10127@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930083051.GA10127@elte.hu>
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


ok, -tip testing found a serious-looking locking bug:

[    4.044005] calling  init_irqsoff_tracer+0x0/0x11 @ 1
[    4.048005] Testing tracer irqsoff: 
[    4.056202] =============================================
[    4.060000] [ INFO: possible recursive locking detected ]
[    4.060000] 2.6.27-rc8-tip-00917-g01214de-dirty #37512
[    4.060000] ---------------------------------------------
[    4.060000] swapper/1 is trying to acquire lock:
[    4.060000]  (&cpu_buffer->lock){++..}, at: [<c015a216>] ring_buffer_lock+0x3b/0x50
[    4.060000] 
[    4.060000] but task is already holding lock:
[    4.060000]  (&cpu_buffer->lock){++..}, at: [<c015a216>] ring_buffer_lock+0x3b/0x50
[    4.060000] 
[    4.060000] other info that might help us debug this:
[    4.060000] 3 locks held by swapper/1:
[    4.060000]  #0:  (trace_types_lock){--..}, at: [<c015d758>] register_tracer+0x2f/0x14f
[    4.060000]  #1:  (max_trace_lock){....}, at: [<c015eab0>] check_critical_timing+0x5d/0x113
[    4.060000]  #2:  (&cpu_buffer->lock){++..}, at: [<c015a216>] ring_buffer_lock+0x3b/0x50
[    4.060000] 
[    4.060000] stack backtrace:
[    4.060000] Pid: 1, comm: swapper Not tainted 2.6.27-rc8-tip-00917-g01214de-dirty #37512
[    4.060000]  [<c014446d>] validate_chain+0x4e9/0xb4c
[    4.060000]  [<c0108b54>] ? native_sched_clock+0xe2/0x101
[    4.060000]  [<c014519a>] __lock_acquire+0x6ca/0x730
[    4.060000]  [<c014525b>] lock_acquire+0x5b/0x81
[    4.060000]  [<c015a216>] ? ring_buffer_lock+0x3b/0x50
[    4.060000]  [<c05908cf>] _spin_lock+0x23/0x50
[    4.060000]  [<c015a216>] ? ring_buffer_lock+0x3b/0x50
[    4.060000]  [<c015a216>] ring_buffer_lock+0x3b/0x50
[    4.060000]  [<c015a2b3>] ring_buffer_reset+0x16/0x46
[    4.060000]  [<c015e16f>] update_max_tr_single+0x65/0xc0
[    4.060000]  [<c015eb15>] check_critical_timing+0xc2/0x113
[    4.060000]  [<c015d270>] ? trace_selftest_startup_irqsoff+0x49/0xac
[    4.060000]  [<c015d270>] ? trace_selftest_startup_irqsoff+0x49/0xac
[    4.060000]  [<c015ec0c>] time_hardirqs_on+0xa6/0xb9
[    4.060000]  [<c014393c>] ? trace_hardirqs_on+0xb/0xd
[    4.060000]  [<c01437fb>] trace_hardirqs_on_caller+0x16/0x14c
[    4.060000]  [<c014393c>] trace_hardirqs_on+0xb/0xd
[    4.060000]  [<c015d270>] trace_selftest_startup_irqsoff+0x49/0xac
[    4.060000]  [<c0128ba9>] ? printk+0x1a/0x1c
[    4.060000]  [<c015d7f1>] register_tracer+0xc8/0x14f
[    4.060000]  [<c08803fc>] init_irqsoff_tracer+0xd/0x11
[    4.060000]  [<c010104f>] do_one_initcall+0x4f/0x130
[    4.060000]  [<c08803ef>] ? init_irqsoff_tracer+0x0/0x11
[    4.060000]  [<c0121390>] ? wake_up_process+0xf/0x11
[    4.060000]  [<c0134ab2>] ? start_workqueue_thread+0x22/0x25
[    4.060000]  [<c0134d99>] ? __create_workqueue_key+0xa9/0x141
[    4.060000]  [<c086c5c3>] kernel_init+0x17b/0x1e2
[    4.060000]  [<c086c448>] ? kernel_init+0x0/0x1e2
[    4.060000]  [<c0104ab3>] kernel_thread_helper+0x7/0x10
[    4.060000]  =======================
[    4.064053] PASSED
[    4.066133] initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 15 msecs
[    4.068005] calling  init_wakeup_tracer+0x0/0xf @ 1

	Ingo
