Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZEYIva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZEYIva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZEYIvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:51:14 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:26846 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZEYIvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <uSztiUhmDDC.A.8iB.a-bGKB@chimera>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera>
	 <uSztiUhmDDC.A.8iB.a-bGKB@chimera>
Date: Mon, 25 May 2009 09:51:10 +0100
X-Google-Sender-Auth: 5c32595dc6605ad2
Message-ID: <b2cdc9f30905250151v6e4e5916j1d88c70d44077cc5@mail.gmail.com>
Subject: Re: [Bug #13171] 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = 
	corruption
From: Alex Bennee <kernel-hacker@bennee.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       xorg <xorg@lists.freedesktop.org>,
       intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/24 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13171
> Subject         : 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS = corruption
> Submitter       : Alex Bennee <kernel-hacker@bennee.com>
> Date            : 2009-04-19 6:27 (36 days old)
> References      : http://marc.info/?l=linux-kernel&m=124022460014812&w=4
>                  https://bugs.freedesktop.org/show_bug.cgi?id=21480
>

I've tested on the latest rc7 kernel and can now boot into the X with
KMS enabled. I believe that's probably good enough for this regression
to be cleared.

I still have some issues with KMS enabled which means it shouldn't be
made a default for intel just yet however I'm not sure where the
problem lie between kernel, X and apps. Compared to a none KMS system
(same xorg.conf, same kernel):

1. GDM gets confused about screen sizes and comes up 1440x900 instead
of stretching the screen to 1680x1050. However the X session itself
gets the right size.

2. Full screen video freezes X. At this point I cannot switch to VT
and need to ssh in to kill and restore X. The logs/dmesg are fairly
mute as to why though.

3. Performance seems to be lower. The compiz benchmark happily report
120fps without KMS on my normal display and around 60FPS with it
enabled. Some displays (like the big wall plugin) the difference is
less marked (14FPS to 9FPS).

I've also seen some oopses occur while running:

[  406.818468] [drm] TMDS-8: set mode  2e
[  478.370123] [drm] DAC-6: set mode 1440x900 1b
[  478.475342] [drm] TMDS-8: set mode 1680x1050 2d
[  660.644103] [drm] TMDS-8: set mode  2f
[  960.272242] INFO: task events/0:9 blocked for more than 120 seconds.
[  960.272245] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  960.272248] events/0      D ffff8800b70a58c0     0     9      2
[  960.272254]  ffff8800b70b5de0 0000000000000046 ffff8800b103dc41
ffff880001028980
[  960.272260]  0000000000004000 0000000000010dc0 000000000000ca38
ffff8800b0d31678
[  960.272265]  ffff8800b70b5d60 ffff8800b70a58c0 ffffffff80648350
ffff8800b70a5c48
[  960.272270] Call Trace:
[  960.272280]  [<ffffffff804bfce6>] ? thread_return+0x3e/0xaa
[  960.272285]  [<ffffffff804c0589>] __mutex_lock_slowpath+0xdf/0x129
[  960.272290]  [<ffffffff804c092d>] mutex_lock+0x23/0x3b
[  960.272295]  [<ffffffff803cecd3>] i915_gem_retire_work_handler+0x2d/0x6b
[  960.272301]  [<ffffffff80247666>] worker_thread+0x176/0x20f
[  960.272306]  [<ffffffff803ceca6>] ? i915_gem_retire_work_handler+0x0/0x6b
[  960.272311]  [<ffffffff8024b463>] ? autoremove_wake_function+0x0/0x3d
[  960.272315]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[  960.272319]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[  960.272323]  [<ffffffff8024b061>] kthread+0x5b/0x88
[  960.272329]  [<ffffffff8020c0ba>] child_rip+0xa/0x20
[  960.272333]  [<ffffffff8024b006>] ? kthread+0x0/0x88
[  960.272337]  [<ffffffff8020c0b0>] ? child_rip+0x0/0x20
[ 1200.272036] INFO: task events/0:9 blocked for more than 120 seconds.
[ 1200.272039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.272043] events/0      D ffff8800b70a58c0     0     9      2
[ 1200.272048]  ffff8800b70b5de0 0000000000000046 ffff8800b103dc41
ffff880001028980
[ 1200.272054]  0000000000004000 0000000000010dc0 000000000000ca38
ffff8800b0d31678
[ 1200.272059]  ffff8800b70b5d60 ffff8800b70a58c0 ffff8800a6c98000
ffff8800b70a5c48
[ 1200.272064] Call Trace:
[ 1200.272074]  [<ffffffff804bfce6>] ? thread_return+0x3e/0xaa
[ 1200.272079]  [<ffffffff804c0589>] __mutex_lock_slowpath+0xdf/0x129
[ 1200.272083]  [<ffffffff804c092d>] mutex_lock+0x23/0x3b
[ 1200.272089]  [<ffffffff803cecd3>] i915_gem_retire_work_handler+0x2d/0x6b
[ 1200.272095]  [<ffffffff80247666>] worker_thread+0x176/0x20f
[ 1200.272100]  [<ffffffff803ceca6>] ? i915_gem_retire_work_handler+0x0/0x6b
[ 1200.272105]  [<ffffffff8024b463>] ? autoremove_wake_function+0x0/0x3d
[ 1200.272109]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[ 1200.272114]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[ 1200.272117]  [<ffffffff8024b061>] kthread+0x5b/0x88
[ 1200.272123]  [<ffffffff8020c0ba>] child_rip+0xa/0x20
[ 1200.272127]  [<ffffffff8024b006>] ? kthread+0x0/0x88
[ 1200.272131]  [<ffffffff8020c0b0>] ? child_rip+0x0/0x20
[ 1200.272154] INFO: task bash:5541 blocked for more than 120 seconds.
[ 1200.272156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.272159] bash          D ffff88009cb01a90     0  5541      1
[ 1200.272163]  ffff88009cb01928 0000000000000046 ffff8800b6a03400
ffff88009cb01988
[ 1200.272168]  0000000000004000 0000000000010dc0 000000000000ca38
0000000000000000
[ 1200.272173]  ffff88009cb019e8 ffff88009e0058c0 ffff8800a9544290
ffff88009e005c48
[ 1200.272178] Call Trace:
[ 1200.272184]  [<ffffffff8027a5b8>] ? find_get_page+0x28/0x89
[ 1200.272189]  [<ffffffff8027e28e>] ? __rmqueue_smallest+0xb7/0x141
[ 1200.272193]  [<ffffffff804bfd60>] schedule+0xe/0x22
[ 1200.272197]  [<ffffffff804c007b>] schedule_timeout+0x29/0x162
[ 1200.272201]  [<ffffffff8027e552>] ? rmqueue_bulk+0x47/0x91
[ 1200.272205]  [<ffffffff804bff10>] wait_for_common+0xd4/0x13a
[ 1200.272210]  [<ffffffff80230c9f>] ? default_wake_function+0x0/0x14
[ 1200.272215]  [<ffffffff804c0019>] wait_for_completion+0x1d/0x1f
[ 1200.272219]  [<ffffffff8024794c>] flush_cpu_workqueue+0x72/0x7e
[ 1200.272223]  [<ffffffff802479bd>] ? wq_barrier_func+0x0/0x14
[ 1200.272228]  [<ffffffff80247f5d>] flush_workqueue+0x46/0x6c
[ 1200.272232]  [<ffffffff80247f98>] flush_scheduled_work+0x15/0x17
[ 1200.272237]  [<ffffffff8039fb26>] tty_ldisc_release+0x4f/0x1da
[ 1200.272242]  [<ffffffff8022a89a>] ? __wake_up+0x48/0x55
[ 1200.272253]  [<ffffffff8039b5d6>] tty_release_dev+0x4ae/0x4e3
[ 1200.272257]  [<ffffffff802a18cd>] ? discard_slab+0x43/0x45
[ 1200.272260]  [<ffffffff8039b629>] tty_release+0x1e/0x29
[ 1200.272263]  [<ffffffff802a87ed>] __fput+0xe4/0x19d
[ 1200.272266]  [<ffffffff802a88c3>] fput+0x1d/0x1f
[ 1200.272270]  [<ffffffff802a5b42>] filp_close+0x5e/0x68
[ 1200.272273]  [<ffffffff802392d7>] put_files_struct+0x70/0xc7
[ 1200.272276]  [<ffffffff8023937a>] exit_files+0x4c/0x55
[ 1200.272279]  [<ffffffff8023ac10>] do_exit+0x1c7/0x637
[ 1200.272282]  [<ffffffff80230cc3>] ? wake_up_state+0x10/0x12
[ 1200.272286]  [<ffffffff80242cc1>] ? signal_wake_up+0x3d/0x41
[ 1200.272289]  [<ffffffff8023b0f7>] do_group_exit+0x77/0xa4
[ 1200.272292]  [<ffffffff80244944>] get_signal_to_deliver+0x318/0x338
[ 1200.272296]  [<ffffffff8020a525>] do_notify_resume+0x90/0x6f9
[ 1200.272299]  [<ffffffff8024391c>] ? kill_pid_info+0x3f/0x4d
[ 1200.272302]  [<ffffffff80243b2e>] ? sys_kill+0x90/0x17b
[ 1200.272305]  [<ffffffff8024221a>] ? sys_rt_sigaction+0x7a/0x98
[ 1200.272308]  [<ffffffff8020b235>] sysret_signal+0x6d/0xb7
[ 1320.272017] INFO: task events/0:9 blocked for more than 120 seconds.
[ 1320.272020] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.272023] events/0      D ffff8800b70a58c0     0     9      2
[ 1320.272029]  ffff8800b70b5de0 0000000000000046 ffff8800b103dc41
ffff880001028980
[ 1320.272034]  0000000000004000 0000000000010dc0 000000000000ca38
ffff8800b0d31678
[ 1320.272040]  ffff8800b70b5d60 ffff8800b70a58c0 ffff8800a6c98000
ffff8800b70a5c48
[ 1320.272045] Call Trace:
[ 1320.272053]  [<ffffffff804bfce6>] ? thread_return+0x3e/0xaa
[ 1320.272059]  [<ffffffff804c0589>] __mutex_lock_slowpath+0xdf/0x129
[ 1320.272063]  [<ffffffff804c092d>] mutex_lock+0x23/0x3b
[ 1320.272068]  [<ffffffff803cecd3>] i915_gem_retire_work_handler+0x2d/0x6b
[ 1320.272074]  [<ffffffff80247666>] worker_thread+0x176/0x20f
[ 1320.272078]  [<ffffffff803ceca6>] ? i915_gem_retire_work_handler+0x0/0x6b
[ 1320.272083]  [<ffffffff8024b463>] ? autoremove_wake_function+0x0/0x3d
[ 1320.272088]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[ 1320.272092]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[ 1320.272096]  [<ffffffff8024b061>] kthread+0x5b/0x88
[ 1320.272101]  [<ffffffff8020c0ba>] child_rip+0xa/0x20
[ 1320.272105]  [<ffffffff8024b006>] ? kthread+0x0/0x88
[ 1320.272110]  [<ffffffff8020c0b0>] ? child_rip+0x0/0x20

But I've been unable to replicate these reliably on a kernel with
mutex debugging enabled.

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
