Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYJMSif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYJMSif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYJMSiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:38:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760192AbYJMSiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dO3fN4eK7DrbZ8KZAk/CTog71b5TbY8h7m5uhxMx3vHUa4I+yVfWvKOUwL6S1k4yhU
         Z8cVakZOGUmSo5HFhpMKlQje14gJBxtnoxeKMes8fUcVyVvQLX9dHP2pvs0fQPq/hAty
         s8P4UrkdDwv4dgGTBaBEBLzpDU7gHgMxqAXyA=
Date: Mon, 13 Oct 2008 20:37:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@redhat.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: inconsistent lock state (tty? input?)
Message-ID: <20081013183731.GA5676@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On current git (a447c0932445f92ce6f4c1bd020f62c5097a7842):
[   12.288256] Adding 1020112k swap on /dev/sda2.  Priority:-1 extents:1 across:1020112k
[   33.469646] Marking TSC unstable due to cpufreq changes
[   37.320027] Clocksource tsc unstable (delta = -122876252 ns)
[   46.696880]
[   46.696883] =================================
[   46.696899] [ INFO: inconsistent lock state ]
[   46.696904] 2.6.27-03556-gbc1d26d #15
[   46.696908] ---------------------------------
[   46.696912] inconsistent {hardirq-on-W} -> {in-hardirq-R} usage.
[   46.696917] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   46.696921]  (tasklist_lock){--?-}, at: [<ffffffff802a6991>] send_sigio+0x3f/0xa1
[   46.696940] {hardirq-on-W} state was registered at:
[   46.696946]   [<ffffffff80254f32>] mark_held_locks+0x52/0x72
[   46.696955]   [<ffffffff802550de>] trace_hardirqs_on_caller+0xf9/0x13a
[   46.696963]   [<ffffffff8025512c>] trace_hardirqs_on+0xd/0xf
[   46.696970]   [<ffffffff8051e065>] _spin_unlock_irq+0x30/0x57
[   46.696980]   [<ffffffff803b5ac7>] proc_clear_tty+0x4e/0x5b
[   46.696988]   [<ffffffff80241cbb>] sys_setsid+0x86/0xa2
[   46.696998]   [<ffffffff8020b4fb>] system_call_fastpath+0x16/0x1b
[   46.697006]   [<ffffffffffffffff>] 0xffffffffffffffff
[   46.697015] irq event stamp: 406110
[   46.697019] hardirqs last  enabled at (406109): [<ffffffff8025512c>] trace_hardirqs_on+0xd/0xf
[   46.697027] hardirqs last disabled at (406110): [<ffffffff8051d61d>] trace_hardirqs_off_thunk+0x3a/0x3c
[   46.697036] softirqs last  enabled at (406098): [<ffffffff8023892c>] __do_softirq+0xbc/0xc4
[   46.697045] softirqs last disabled at (406065): [<ffffffff8020c3ac>] call_softirq+0x1c/0x28
[   46.697053]
[   46.697054] other info that might help us debug this:
[   46.697059] 6 locks held by swapper/0:
[   46.697064]  #0:  (&serio->lock){++..}, at: [<ffffffff8043edc5>] serio_interrupt+0x2b/0x83
[   46.697080]  #1:  (&dev->event_lock){++..}, at: [<ffffffff80442b21>] input_event+0x40/0x7a
[   46.697096]  #2:  (rcu_read_lock){..--}, at: [<ffffffff80441566>] input_pass_event+0x0/0xfa
[   46.697111]  #3:  (rcu_read_lock){..--}, at: [<ffffffff804445b3>] mousedev_notify_readers+0x0/0x237
[   46.697127]  #4:  (fasync_lock){..+.}, at: [<ffffffff802a6a84>] kill_fasync+0x2c/0x4e
[   46.697142]  #5:  (&f->f_owner.lock){..+.}, at: [<ffffffff802a6976>] send_sigio+0x24/0xa1
[   46.697155]
[   46.697156] stack backtrace:
[   46.697165] Pid: 0, comm: swapper Not tainted 2.6.27-03556-gbc1d26d #15
[   46.697171] Call Trace:
[   46.697175]  <IRQ>  [<ffffffff802535d7>] print_usage_bug+0x1ad/0x1be
[   46.697188]  [<ffffffff80254737>] mark_lock_irq+0x29b/0x681
[   46.697193]  [<ffffffff80254d16>] mark_lock+0x1f9/0x2d1
[   46.697198]  [<ffffffff80254e1a>] mark_irqflags+0x2c/0xf2
[   46.697204]  [<ffffffff80256336>] __lock_acquire+0x4e8/0x634
[   46.697210]  [<ffffffff80256507>] lock_acquire+0x85/0xa9
[   46.697216]  [<ffffffff802a6991>] ? send_sigio+0x3f/0xa1
[   46.697222]  [<ffffffff8051dba7>] _read_lock+0x3e/0x4a
[   46.697227]  [<ffffffff802a6991>] ? send_sigio+0x3f/0xa1
[   46.697233]  [<ffffffff802a6991>] send_sigio+0x3f/0xa1
[   46.697238]  [<ffffffff802a6a47>] __kill_fasync+0x54/0x65
[   46.697244]  [<ffffffff802a6a92>] kill_fasync+0x3a/0x4e
[   46.697249]  [<ffffffff80444769>] mousedev_notify_readers+0x1b6/0x237
[   46.697256]  [<ffffffff804445b3>] ? mousedev_notify_readers+0x0/0x237
[   46.697261]  [<ffffffff80444cd1>] mousedev_event+0x119/0x14e
[   46.697267]  [<ffffffff804415fa>] input_pass_event+0x94/0xfa
[   46.697274]  [<ffffffff80441566>] ? input_pass_event+0x0/0xfa
[   46.697279]  [<ffffffff80441fda>] input_handle_event+0x25c/0x281
[   46.697286]  [<ffffffff80442b43>] input_event+0x62/0x7a
[   46.697293]  [<ffffffff80449eac>] psmouse_process_byte+0x257/0x267
[   46.697298]  [<ffffffff80449082>] psmouse_handle_byte+0x17/0x10d
[   46.697305]  [<ffffffff80449b30>] psmouse_interrupt+0x277/0x285
[   46.697311]  [<ffffffff8043edc5>] ? serio_interrupt+0x2b/0x83
[   46.697316]  [<ffffffff8043ede1>] serio_interrupt+0x47/0x83
[   46.697322]  [<ffffffff8043fdaa>] i8042_interrupt+0x20b/0x223
[   46.697328]  [<ffffffff80264031>] handle_IRQ_event+0x25/0x5a
[   46.697334]  [<ffffffff80265480>] handle_edge_irq+0xdd/0x123
[   46.697340]  [<ffffffff8020d1e0>] do_IRQ+0xe4/0x14c
[   46.697345]  [<ffffffff8020ba8b>] ret_from_intr+0x0/0xf
[   46.697350]  <EOI>  [<ffffffff80520909>] ? __atomic_notifier_call_chain+0x0/0xb7
[   46.697363]  [<ffffffff8021148c>] ? default_idle+0x32/0x4c
[   46.697369]  [<ffffffff8021148a>] ? default_idle+0x30/0x4c
[   46.697374]  [<ffffffff8020a1dc>] ? cpu_idle+0x4b/0x87
[   46.697494]  [<ffffffff80513771>] ? rest_init+0x75/0x77

Didn't happen on 4480f15b3306f43bbb0310d461142b4e897ca45b (Oct 12)
and fd048088306656824958e7783ffcee27e241b361 (Oct 11).
