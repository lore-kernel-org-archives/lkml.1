Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbYB0ATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbYB0ATS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYB0ATF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:19:05 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYB0ATB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:19:01 -0500
Date: Tue, 26 Feb 2008 16:17:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: INFO: possible circular locking in the resume
Message-Id: <20080226161759.7fd96c29.akpm@linux-foundation.org>
In-Reply-To: <c4e36d110802261529o76514be0ob1b538177796dca3@mail.gmail.com>
References: <c4e36d110802261529o76514be0ob1b538177796dca3@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 00:29:21 +0100 "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:

> Hi
> 
> I'm getting this INFO: from suspend/resume process.
> (Kernel uses patches from this bugzilla to survive suspend
> http://bugzilla.kernel.org/show_bug.cgi?id=10030)
> (Config is available in the bugzilla)
> 
> 
> [   42.097522] MMC: killing requests for dead queue
> [   42.098738] PM: Finishing wakeup.
> [   42.098740] Restarting tasks ... <6>usb 3-2: USB disconnect, address 2
> [   42.129810] done.
> [   42.258523]
> [   42.258524] =======================================================
> [   42.258626] [ INFO: possible circular locking dependency detected ]
> [   42.258681] 2.6.25-rc3 #81
> [   42.258736] -------------------------------------------------------
> [   42.258787] sh/1973 is trying to acquire lock:
> [   42.258839]  (&cpu_hotplug.lock){--..}, at: [<ffffffff8106d7a5>]
> get_online_cpus+0x35/0x50

heh.

> [   42.259068]
> [   42.259068] but task is already holding lock:
> [   42.259166]  (&sp->mutex){--..}, at: [<ffffffff8105adb0>]
> synchronize_srcu+0x20/0x90
> [   42.259376]
> [   42.259377] which lock already depends on the new lock.
> [   42.259377]
> [   42.259501]
> [   42.259501] the existing dependency chain (in reverse order) is:
> [   42.259501]
> [   42.259501] -> #3 (&sp->mutex){--..}:
> [   42.259501]        [<ffffffff81066d30>] __lock_acquire+0xfb0/0x1040
> [   42.259501]        [<ffffffff81066e68>] lock_acquire+0xa8/0xf0
> [   42.259501]        [<ffffffff812ef5ac>] mutex_lock_nested+0xcc/0x370
> [   42.259501]        [<ffffffff8105adb0>] synchronize_srcu+0x20/0x90
> [   42.259501]        [<ffffffff8105b2b4>]
> srcu_notifier_chain_unregister+0x74/0xe0
> [   42.259501]        [<ffffffff8125a337>] cpufreq_unregister_notifier+0x17/0x40
> [   42.259501]        [<ffffffff8829e296>]
> cpufreq_governor_userspace+0x1b6/0x1f4 [cpufreq_userspace]
> [   42.259501]        [<ffffffff81259923>] __cpufreq_governor+0xd3/0x150
> [   42.259501]        [<ffffffff8125a0b5>] __cpufreq_set_policy+0x115/0x170
> [   42.259501]        [<ffffffff8125a819>] store_scaling_governor+0xc9/0x260
> [   42.259501]        [<ffffffff8125b527>] store+0x87/0xa0
> [   42.259501]        [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
> [   42.259501]        [<ffffffff810bb82b>] vfs_write+0xcb/0x170
> [   42.259501]        [<ffffffff810bb9c0>] sys_write+0x50/0x90
> [   42.259501]        [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
> [   42.259501]        [<ffffffffffffffff>] 0xffffffffffffffff
> [   42.259501]
> [   42.259501] -> #2 (userspace_mutex){--..}:
> [   42.259501]        [<ffffffff81066d30>] __lock_acquire+0xfb0/0x1040
> [   42.259501]        [<ffffffff81066e68>] lock_acquire+0xa8/0xf0
> [   42.259501]        [<ffffffff812ef5ac>] mutex_lock_nested+0xcc/0x370
> [   42.259501]        [<ffffffff8829e13c>]
> cpufreq_governor_userspace+0x5c/0x1f4 [cpufreq_userspace]
> [   42.259501]        [<ffffffff81259923>] __cpufreq_governor+0xd3/0x150
> [   42.259501]        [<ffffffff8125a0cb>] __cpufreq_set_policy+0x12b/0x170
> [   42.259501]        [<ffffffff8125a819>] store_scaling_governor+0xc9/0x260
> [   42.259501]        [<ffffffff8125b527>] store+0x87/0xa0
> [   42.259501]        [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
> [   42.259501]        [<ffffffff810bb82b>] vfs_write+0xcb/0x170
> [   42.259501]        [<ffffffff810bb9c0>] sys_write+0x50/0x90
> [   42.259501]        [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
> [   42.259501]        [<ffffffffffffffff>] 0xffffffffffffffff
> [   42.259501]
> [   42.259501] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
> [   42.259501]        [<ffffffff81066d30>] __lock_acquire+0xfb0/0x1040
> [   42.259501]        [<ffffffff81066e68>] lock_acquire+0xa8/0xf0
> [   42.259501]        [<ffffffff812effc8>] down_write+0x38/0x70
> [   42.259501]        [<ffffffff8125ae7c>] lock_policy_rwsem_write+0x4c/0x90
> [   42.259501]        [<ffffffff812edbed>] cpufreq_cpu_callback+0x6d/0x90
> [   42.259501]        [<ffffffff812f578f>] notifier_call_chain+0x3f/0x80
> [   42.259501]        [<ffffffff8105b059>] __raw_notifier_call_chain+0x9/0x10
> [   42.259501]        [<ffffffff8106d368>] _cpu_down+0xa8/0x290
> [   42.259501]        [<ffffffff8106d621>] disable_nonboot_cpus+0x71/0x110
> [   42.259501]        [<ffffffff810730d5>] suspend_devices_and_enter+0xe5/0x1a0
> [   42.259501]        [<ffffffff81073306>] enter_state+0x146/0x1d0
> [   42.259501]        [<ffffffff8107344a>] state_store+0xba/0x100
> [   42.259501]        [<ffffffff811757f7>] kobj_attr_store+0x17/0x20
> [   42.259501]        [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
> [   42.259501]        [<ffffffff810bb82b>] vfs_write+0xcb/0x170
> [   42.259501]        [<ffffffff810bb9c0>] sys_write+0x50/0x90
> [   42.259501]        [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
> [   42.259501]        [<ffffffffffffffff>] 0xffffffffffffffff
> [   42.259501]
> [   42.259501] -> #0 (&cpu_hotplug.lock){--..}:
> [   42.259501]        [<ffffffff81066c3d>] __lock_acquire+0xebd/0x1040
> [   42.259501]        [<ffffffff81066e68>] lock_acquire+0xa8/0xf0
> [   42.259501]        [<ffffffff812ef5ac>] mutex_lock_nested+0xcc/0x370
> [   42.259501]        [<ffffffff8106d7a5>] get_online_cpus+0x35/0x50
> [   42.259501]        [<ffffffff8103837e>] sched_getaffinity+0x1e/0xa0
> [   42.259501]        [<ffffffff8108b386>] __synchronize_sched+0x16/0x90
> [   42.259501]        [<ffffffff8105add5>] synchronize_srcu+0x45/0x90
> [   42.259501]        [<ffffffff8105b2b4>]
> srcu_notifier_chain_unregister+0x74/0xe0
> [   42.259501]        [<ffffffff8125a337>] cpufreq_unregister_notifier+0x17/0x40
> [   42.259501]        [<ffffffff8829e296>]
> cpufreq_governor_userspace+0x1b6/0x1f4 [cpufreq_userspace]
> [   42.259501]        [<ffffffff81259923>] __cpufreq_governor+0xd3/0x150
> [   42.259501]        [<ffffffff8125a0b5>] __cpufreq_set_policy+0x115/0x170
> [   42.259501]        [<ffffffff8125a819>] store_scaling_governor+0xc9/0x260
> [   42.259501]        [<ffffffff8125b527>] store+0x87/0xa0
> [   42.259501]        [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
> [   42.259501]        [<ffffffff810bb82b>] vfs_write+0xcb/0x170
> [   42.259501]        [<ffffffff810bb9c0>] sys_write+0x50/0x90
> [   42.259501]        [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
> [   42.259501]        [<ffffffffffffffff>] 0xffffffffffffffff
> [   42.259501]
> [   42.259501] other info that might help us debug this:
> [   42.259501]
> [   42.259501] 4 locks held by sh/1973:
> [   42.259501]  #0:  (&buffer->mutex){--..}, at: [<ffffffff81110173>]
> sysfs_write_file+0x43/0x140
> [   42.259501]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at:
> [<ffffffff8125ae7c>] lock_policy_rwsem_write+0x4c/0x90
> [   42.259501]  #2:  (userspace_mutex){--..}, at: [<ffffffff8829e22e>]
> cpufreq_governor_userspace+0x14e/0x1f4 [cpufreq_userspace]
> [   42.259501]  #3:  (&sp->mutex){--..}, at: [<ffffffff8105adb0>]
> synchronize_srcu+0x20/0x90
> [   42.259501]
> [   42.259501] stack backtrace:
> [   42.259501] Pid: 1973, comm: sh Not tainted 2.6.25-rc3 #81
> [   42.259501]
> [   42.259501] Call Trace:
> [   42.259501]  [<ffffffff81065ac4>] print_circular_bug_tail+0x84/0x90
> [   42.259501]  [<ffffffff81065872>] ? print_circular_bug_entry+0x52/0x60
> [   42.259501]  [<ffffffff81066c3d>] __lock_acquire+0xebd/0x1040
> [   42.259501]  [<ffffffff8106353b>] ? find_usage_backwards+0xcb/0x110
> [   42.259502]  [<ffffffff8106353b>] ? find_usage_backwards+0xcb/0x110
> [   42.259502]  [<ffffffff8106d7a5>] ? get_online_cpus+0x35/0x50
> [   42.259502]  [<ffffffff81066e68>] lock_acquire+0xa8/0xf0
> [   42.259502]  [<ffffffff8106d7a5>] ? get_online_cpus+0x35/0x50
> [   42.259502]  [<ffffffff812ef5ac>] mutex_lock_nested+0xcc/0x370
> [   42.259502]  [<ffffffff8106d7a5>] ? get_online_cpus+0x35/0x50
> [   42.259502]  [<ffffffff81065649>] ? trace_hardirqs_on+0x139/0x1a0
> [   42.259502]  [<ffffffff8106d7a5>] get_online_cpus+0x35/0x50
> [   42.259502]  [<ffffffff8103837e>] sched_getaffinity+0x1e/0xa0
> [   42.259502]  [<ffffffff8108b386>] __synchronize_sched+0x16/0x90
> [   42.259502]  [<ffffffff8105add5>] synchronize_srcu+0x45/0x90
> [   42.259502]  [<ffffffff8105b2b4>] srcu_notifier_chain_unregister+0x74/0xe0
> [   42.259502]  [<ffffffff8125a337>] cpufreq_unregister_notifier+0x17/0x40
> [   42.259502]  [<ffffffff8829e296>]
> :cpufreq_userspace:cpufreq_governor_userspace+0x1b6/0x1f4
> [   42.259502]  [<ffffffff81259923>] __cpufreq_governor+0xd3/0x150
> [   42.259502]  [<ffffffff8125a0b5>] __cpufreq_set_policy+0x115/0x170
> [   42.259502]  [<ffffffff8125a819>] store_scaling_governor+0xc9/0x260
> [   42.259502]  [<ffffffff8125b650>] ? handle_update+0x0/0x10
> [   42.259502]  [<ffffffff812efff0>] ? down_write+0x60/0x70
> [   42.259502]  [<ffffffff8125b527>] store+0x87/0xa0
> [   42.259502]  [<ffffffff811101fa>] sysfs_write_file+0xca/0x140
> [   42.259502]  [<ffffffff810bb82b>] vfs_write+0xcb/0x170
> [   42.259502]  [<ffffffff810bb9c0>] sys_write+0x50/0x90
> [   42.259502]  [<ffffffff8100c70a>] system_call_after_swapgs+0x8a/0x8f
> [   42.259502]
> [   41.439840] mmc0: new SD card at address 5a61
> [   41.440027] mmcblk0: mmc0:5a61 S016B 14560KiB
> [   41.440123]  mmcblk0: p1
> [   41.916006] usb 3-2: new full speed USB device using uhci_hcd and address 3
> [   42.900716] usb 3-2: configuration #1 chosen from 1 choice
> [   42.080814] usb 3-2: New USB device found, idVendor=0483, idProduct=2016
> [   42.080939] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   42.081094] usb 3-2: Product: Biometric Coprocessor
> [   42.081212] usb 3-2: Manufacturer: STMicroelectronics
> [   47.925651] PM: Syncing filesystems ... done.
> [   47.925845] PM: Preparing system for mem sleep
> [   47.925925] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [   47.926302] Freezing remaining freezable tasks ... (elapsed 0.00
> seconds) done.
> [   47.926596] PM: Entering mem sleep
> [   47.929993] ACPI: Preparing to enter system sleep state S3
> [   49.169572] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   49.169771] sd 0:0:0:0: [sda] Stopping disk
> [   51.204365] mmc0: card 5a61 removed
> [   51.204365] ACPI handle has no context!
> [   51.204365] ACPI: PCI interrupt for device 0000:15:00.2 disabled
> [   51.204365] ACPI handle has no context!

Something for Gautham and the USB people to scratch their heads over.
