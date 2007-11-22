Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbXKVNyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbXKVNyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 08:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXKVNyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 08:54:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:48911 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbXKVNyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 08:54:14 -0500
Subject: Re: cpufreq deadlock (?sysfs related?)
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Jiri Slaby <jirislaby@gmail.com>
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       Greg KH <gregkh@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <47455DEE.4050107@gmail.com>
References: <47455DEE.4050107@gmail.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 22 Nov 2007 14:54:13 +0100
Message-Id: <1195739653.10587.89.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-22 at 11:46 +0100, Jiri Slaby wrote:
> Hi,
> 
> some people hit this bug, I'm able to reproduce it too, but I'm out of ideas
> what could have cause it. Here are some traces of D processes:
Could this have to do with the problem Venkatesh/Luming recently sent a
patch for to the cpufreq list:
Eliminate cpufreq_userspace scaling_setspeed deadlock
http://article.gmane.org/gmane.linux.kernel.cpufreq/5629

   Thomas
> 
> tee           D ffff8100041e3c28     0 15798  13503
>  ffff8100041e3bc8 0000000000000086 0000000000000000 ffffffff804a007b
>  ffff8100041e3be8 ffff8100029d8000 ffff810001fc9560 ffffffff8828e094
>  ffff810008af1ba0 ffff8100029d8000 ffff810001fc9560 ffff81002ae74e40
> Call Trace:
>  [<ffffffff804a007b>] thread_return+0x0/0x5a5
>  [<ffffffff8828e094>] :cpufreq_stats:cpufreq_stats_update+0x54/0x70 /*
> _spin_unlock */
>  [<ffffffff804a0731>] wait_for_completion+0xa1/0xf0
>  [<ffffffff8022ee90>] default_wake_function+0x0/0x10
>  [<ffffffff802d583f>] sysfs_addrm_finish+0x1ef/0x270 /* wait_for_completion */
>  [<ffffffff802d3fb6>] sysfs_hash_and_remove+0xa6/0xc0
>  [<ffffffff880120cc>] :cpufreq_userspace:cpufreq_governor_userspace+0xac/0x220
>  [<ffffffff803c4cd2>] __cpufreq_governor+0x32/0x110
>  [<ffffffff803c56f3>] __cpufreq_set_policy+0x113/0x180
>  [<ffffffff803c5852>] store_scaling_governor+0xf2/0x200
>  [<ffffffff803c5f50>] handle_update+0x0/0x10
> 
> here started the scheduled work ^^^
> 
>  [<ffffffff8026a2c3>] __alloc_pages+0x73/0x320 /* get_page_from_freelist */
>  [<ffffffff803c662b>] store+0x7b/0x90 /* fattr->store(), holding write sem */
>  [<ffffffff802d46ef>] sysfs_write_file+0xcf/0x150
>  [<ffffffff8028c778>] vfs_write+0xc8/0x170
>  [<ffffffff8028ce53>] sys_write+0x53/0x90
>  [<ffffffff8020bd6e>] system_call+0x7e/0x83
> 
> tee           D 0000000000000000     0 15800  22179
>  ffff8100058b7e28 0000000000000086 0000000000000000 001bdcd0000f32a0
>  0000000000000000 ffff810005f8ce40 ffff810001fd6e40 0000000000000001
>  0000000101281d48 000000008057bec0 0000000000000003 000280d000000000
> Call Trace:
>  [<ffffffff804a1ed9>] __down_write_nested+0x79/0xc0
>  [<ffffffff803c5e21>] lock_policy_rwsem_write+0x41/0x80
>  [<ffffffff803c660c>] store+0x5c/0x90
>  [<ffffffff802d46ef>] sysfs_write_file+0xcf/0x150
>  [<ffffffff8028c778>] vfs_write+0xc8/0x170
>  [<ffffffff8028ce53>] sys_write+0x53/0x90
>  [<ffffffff8020bd6e>] system_call+0x7e/0x83
> 
> cat           D 0000000000000000     0 15801  13587
>  ffff810008f69e38 0000000000000082 0000000000000000 ffffffff8026a119
>  ffffffff80624fa0 ffff810005f8d560 ffffffff805703a0 ffffffff8057bec0
>  0000000101282286 0000000000000000 0000000000000003 000000010697e4a0
> Call Trace:
>  [<ffffffff8026a119>] get_page_from_freelist+0x339/0x470
>  [<ffffffff804a1fa9>] __down_read+0x79/0xb2 /* schedule */
>  [<ffffffff803c6681>] lock_policy_rwsem_read+0x41/0x80
>  [<ffffffff803c67cd>] show+0x4d/0x80
>  [<ffffffff802d4bed>] sysfs_read_file+0x9d/0x150
>  [<ffffffff8028c8e5>] vfs_read+0xc5/0x160
>  [<ffffffff8028cdc3>] sys_read+0x53/0x90
>  [<ffffffff8020bd6e>] system_call+0x7e/0x83
> 
> I reproduced it by executing these 3 scripts:
> #!/bin/bash
> 
> while true
> do
> echo userspace | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> sleep 2
> echo performance | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> sleep 4
> echo ondemand | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> sleep 10
> done
> 
> #!/bin/bash
> 
> while true
> do
> echo userspace | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> for (( a = 0; a < 10000; a++ )); do echo aaa >/dev/null; done
> echo performance | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> for (( a = 0; a < 11500; a++ )); do echo aaa >/dev/null; done
> echo ondemand | tee /sys/devices/system/cpu/*/cpufreq/scaling_governor
> cat /sys/devices/system/cpu/*/cpufreq/scaling_governor
> sleep 1
> done
> 
> #!/bin/bash
> 
> while true
> do cat /sys/devices/system/cpu/*/cpufreq/*
> sleep 10
> done
> 
> This was on 2.6.23, however it is known to be also in older kernels. I
> suspect same race between wait_for_completion and complete() -- it wakes
> only one process, but not the other in sysfs/dir.c (would complete_all
> help?)? Any ideas?
> 
> Here are events workers (seems OK):
> events/1      S 0000000000000000     0 13126      2
>  ffff81003fe71ec0 0000000000000046 0000000000000000 0000000000000202
>  ffff810001e120c0 ffff81003d821560 ffff810001fd6e40 00000000ffffffff
>  00000001012df7e1 0000000080248f2a 0000000000000003 ffff810001e120c8
> Call Trace:
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff80249165>] worker_thread+0x105/0x130
>  [<ffffffff8024cb20>] autoremove_wake_function+0x0/0x30
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff8024c71b>] kthread+0x4b/0x80
>  [<ffffffff8020cbb8>] child_rip+0xa/0x12
>  [<ffffffff8024c6d0>] kthread+0x0/0x80
>  [<ffffffff8020cbae>] child_rip+0x0/0x12
> 
> events/0      S 0000000000000000     0     7      2
>  ffff81003ff0bec0 0000000000000046 0000000000000000 0000000000000202
>  ffff810001e0a0c0 ffff810001fd7560 ffffffff805703a0 00000000ffffffff
>  00000001012df7c6 0000000080248f2a 0000000000000003 ffff810001e0a0c8
> Call Trace:
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff80249165>] worker_thread+0x105/0x130
>  [<ffffffff8024cb20>] autoremove_wake_function+0x0/0x30
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff80249060>] worker_thread+0x0/0x130
>  [<ffffffff8024c71b>] kthread+0x4b/0x80
>  [<ffffffff8020cbb8>] child_rip+0xa/0x12
>  [<ffffffff8024c6d0>] kthread+0x0/0x80
>  [<ffffffff8020cbae>] child_rip+0x0/0x12
> 
> I'm now trying to reproduce this with LOCKDEP on, but it's not easy to get
> to that state.


