Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZALTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZALTAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZALTAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:00:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbZALTAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:00:06 -0500
Date: Mon, 12 Jan 2009 19:59:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dieter Ries <clip2@gmx.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, travis@sgi.com,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090112185954.GB15494@elte.hu>
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu> <496B3331.1070709@gmx.de> <20090112122145.GA28636@elte.hu> <496B71D5.8030002@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B71D5.8030002@gmx.de>
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


* Dieter Ries <clip2@gmx.de> wrote:

> Hi,
> 
> Ingo Molnar schrieb:
> > 
> > So you did get stacktraces? You might want to boot with 
> > CONFIG_PROVE_LOCKING=y, that could also catch and report the lockup 
> > scenario.
> 
> This is what I have got:
> 
> [   12.340122] =============================================
> [   12.341044] [ INFO: possible recursive locking detected ]
> [   12.341044] 2.6.29-rc1-00041-gacd1e11 #143
> [   12.341044] ---------------------------------------------
> [   12.341044] events/0/9 is trying to acquire lock:
> [   12.341044]  (events){--..}, at: [<ffffffff80254783>]
> flush_work+0x33/0x100
> [   12.341044]
> 
> [   12.341044] but task is already holding lock:
> 
> [   12.341044]  (events){--..}, at: [<ffffffff80253ef7>]
> run_workqueue+0x107/0x230
> 
> [   12.341044]
> 
> [   12.341044] other info that might help us debug this:
> 
> [   12.341044] 3 locks held by events/0/9:
> 
> [   12.341044]  #0:  (events){--..}, at: [<ffffffff80253ef7>]
> run_workqueue+0x107/0x230
> 
> [   12.341044]  #1:  ((dbs_work).work){--..}, at: [<ffffffff80253ef7>]
> run_workqueue+0x107/0x230
> 
> [   12.341044]  #2:  (dbs_mutex){--..}, at: [<ffffffff805692f5>]
> do_dbs_timer+0x25/0x250
> 
> [   12.341044]
> 
> [   12.341044] stack backtrace:
> 
> [   12.341044] Pid: 9, comm: events/0 Not tainted
> 2.6.29-rc1-00041-gacd1e11 #143
> [   12.341044] Call Trace:
> 
> [   12.341044]  [<ffffffff80269e69>] validate_chain+0xb69/0x1200
> 
> [   12.341044]  [<ffffffff8026a93e>] __lock_acquire+0x43e/0xa50
> 
> [   12.341044]  [<ffffffff8026afa8>] lock_acquire+0x58/0x80
> 
> [   12.341044]  [<ffffffff80254783>] ? flush_work+0x33/0x100
> 
> [   12.341044]  [<ffffffff802547a8>] flush_work+0x58/0x100
> 
> [   12.341044]  [<ffffffff80254783>] ? flush_work+0x33/0x100
> 
> [   12.341044]  [<ffffffff80268b7d>] ? trace_hardirqs_on+0xd/0x10
> 
> [   12.341044]  [<ffffffff80254a3c>] ? __queue_work+0x3c/0x50
> 
> [   12.341044]  [<ffffffff80254ad4>] ? queue_work_on+0x44/0x60
> 
> [   12.341044]  [<ffffffff8021bd20>] ? do_drv_write+0x0/0x60
> 
> [   12.341044]  [<ffffffff8021bd20>] ? do_drv_write+0x0/0x60
> 
> [   12.341044]  [<ffffffff80254ba3>] work_on_cpu+0x93/0xc0
> 
> [   12.341044]  [<ffffffff80253cc0>] ? do_work_for_cpu+0x0/0x20
> 
> [   12.341044]  [<ffffffff8021bd20>] ? do_drv_write+0x0/0x60
> 
> [   12.341044]  [<ffffffff8025cba1>] ?
> srcu_notifier_call_chain+0x11/0x20
> [   12.341044]  [<ffffffff8021c5c9>] acpi_cpufreq_target+0x239/0x350
> 
> [   12.341044]  [<ffffffff80268af2>] ?
> trace_hardirqs_on_caller+0x112/0x190
> [   12.341044]  [<ffffffff80699ac8>] ? mutex_lock_nested+0x228/0x2f0
> 
> [   12.341044]  [<ffffffff80565731>] __cpufreq_driver_target+0x81/0x90
> 
> [   12.341044]  [<ffffffff8056940e>] do_dbs_timer+0x13e/0x250
> 
> [   12.341044]  [<ffffffff805692d0>] ? do_dbs_timer+0x0/0x250
> 
> [   12.341044]  [<ffffffff80253f49>] run_workqueue+0x159/0x230
> 
> [   12.341044]  [<ffffffff80253ef7>] ? run_workqueue+0x107/0x230
> 
> [   12.341044]  [<ffffffff80254d1f>] worker_thread+0xbf/0x120
> 
> [   12.341044]  [<ffffffff80258550>] ? autoremove_wake_function+0x0/0x40
> 
> [   12.341044]  [<ffffffff80254c60>] ? worker_thread+0x0/0x120
> 
> [   12.341044]  [<ffffffff8025811d>] kthread+0x4d/0x80
> 
> [   12.341044]  [<ffffffff8020c87a>] child_rip+0xa/0x20
> 
> [   12.341044]  [<ffffffff8020c27c>] ? restore_args+0x0/0x30
> [   12.341044]  [<ffffffff802580d0>] ? kthread+0x0/0x80
> [   12.341044]  [<ffffffff8020c870>] ? child_rip+0x0/0x20
> 
> 
> complete log and config are attached.
> 
> The different git hash is because I reverted that revert patch. It is 
> exactly the same like the kernel on which I first found the problem, 
> only with some debugging enabled now. Maybe I should make more use of 
> gits capabilities...
> 
> Hope that helps,

thanks, it helps!

the problem isnt even the hotplug lock, but that work_on_cpu() uses the 
normal generic kevent workqueue - which workqueue can already contain 
items related to the cpufreq code hence it's not safe to call it with any 
cpufreq mutex held.

so Mike, i think we could solve this by work_on_cpu() getting its own 
workqueue?

	Ingo
