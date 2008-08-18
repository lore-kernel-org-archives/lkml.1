Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbYHRUsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbYHRUsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYHRUsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:48:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbYHRUsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:48:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: oprofile + hibernation = badness
Date: Mon, 18 Aug 2008 22:51:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pavel Machek" <pavel@suse.cz>, "Robert Richter" <robert.richter@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@linux.intel.com>,
       "Philippe Elie" <phil.el@wanadoo.fr>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
In-Reply-To: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182251.31113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Vegard Nossum wrote:
> Hi,
> 
> I'm probably crazy to do it, but...
> 
>     $ opcontrol --start
>     $ echo disk > /sys/power/state
> 
> ...leads to lots of badness/strangeness. First, lots of APIC errors:
> 
> APIC error on CPU0: 40(40)
> [repeat 8 times]
> APIC error on CPU1: 40(40)
> APIC error on CPU1: 40(40)
> APIC error on CPU0: 40(40)
> 
> These keep on coming all through the suspend/shutdown sequence, also
> intermixing with other messages. I'm guessing oprofile is trying to
> NMI CPUs that have been brought down?

They CPUs are taken down after suspending devices.  If you boot the
kernel with 'no_console_suspend' in the command line, there will be more
debug information to have a look at.

Also, you can do

# echo core > /sys/power/pm_test

before the '$ echo disk > /sys/power/state' (that only tests the suspend
sequence without actually hibernating) and see what symptoms will be
reproduced.

> Now I get some ACPI Exceptions, but I think that these are unrelated
> to starting oprofile, because I have seen them on regular shutdowns as
> well:
> 
> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Shrinking memory... done (0 pages freed)
> PM: Freed 0 kbytes in 0.44 seconds (0.00 MB/s)
> Suspending console(s) (use no_console_suspend to debug)
> ACPI Exception (exoparg2-0444): AE_AML_PACKAGE_LIMIT, Index
> (000000007) is beyond end of object [20080609]
> ACPI Error (psparse-0530): Method parse/execution failed
> [\_SB_.PCI0.IDE0.GTM_] (Node f783bfc0), AE_AML_PACKAGE_LIMIT
> ACPI Error (psparse-0530): Method parse/execution failed
> [\_SB_.PCI0.IDE0.CHN0._GTM] (Node f783bb40), AE_AML_PACKAGE_LIMIT
> ACPI handle has no context!
> serial 00:0d: disabled
> serial 00:06: disabled
> ehci_hcd 0000:00:1d.7: PCI INT A disabled
> uhci_hcd 0000:00:1d.3: PCI INT D disabled
> uhci_hcd 0000:00:1d.2: PCI INT C disabled
> uhci_hcd 0000:00:1d.1: PCI INT B disabled
> uhci_hcd 0000:00:1d.0: PCI INT A disabled
> ACPI: Preparing to enter system sleep state S4
> 
> After that, I see the message "WQ on CPU0, prefer CPU1" a few times.
> This must also be bad.
> 
> Now some warnings:
> 
> ------------[ cut here ]------------
> WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328 s
> mp_call_function_mask+0x194/0x1a0()
> Pid: 3711, comm: bash Not tainted 2.6.27-rc3-00415-g122c9e0 #10
>  [<c013584f>] warn_on_slowpath+0x4f/0x80
>  [<c0585ff8>] ? log_sample+0xa8/0xc0
>  [<c03e4e8d>] ? device_power_down+0x5d/0x110
>  [<c0586140>] ? oprofile_add_ext_sample+0x40/0xc0
>  [<c05861f4>] ? oprofile_add_sample+0x34/0x50
>  [<c0588f5c>] ? p4_check_ctr+0x13c/0x160
>  [<c0160c54>] smp_call_function_mask+0x194/0x1a0
>  [<c0587940>] ? nmi_cpu_stop+0x0/0x30
>  [<c014e04c>] ? __atomic_notifier_call_chain+0x3c/0x50
>  [<c014e07a>] ? atomic_notifier_call_chain+0x1a/0x20
>  [<c014e0ad>] ? notify_die+0x2d/0x30
>  [<c0587940>] ? nmi_cpu_stop+0x0/0x30
>  [<c0160c90>] smp_call_function+0x30/0x60
>  [<c0587940>] ? nmi_cpu_stop+0x0/0x30
>  [<c013a16c>] on_each_cpu+0x2c/0x80
>  [<c05878d4>] nmi_stop+0x14/0x20
>  [<c05878f5>] nmi_suspend+0x15/0x20
>  [<c03dff63>] sysdev_suspend+0xa3/0x1f0
>  [<c03e4f0c>] device_power_down+0xdc/0x110
>  [<c016355b>] hibernation_snapshot+0x15b/0x220
>  [<c013644b>] ? printk+0x1b/0x20
>  [<c0162742>] ? freeze_processes+0x52/0xa0
>  [<c0163700>] hibernate+0xe0/0x180
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c016226f>] state_store+0xbf/0xd0
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c03618d4>] kobj_attr_store+0x24/0x30
>  [<c01e66c2>] sysfs_write_file+0xa2/0x100
>  [<c01a85b6>] vfs_write+0x96/0x130
>  [<c01e6620>] ? sysfs_write_file+0x0/0x100
>  [<c01a8afd>] sys_write+0x3d/0x70
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  [<c0670000>] ? _read_unlock_irqrestore+0x60/0x70
>  =======================
> ---[ end trace df36f449a70f1c8e ]---
> PM: Creating hibernation image:
> PM: Need to copy 54048 pages
> PM: Hibernation image created (54048 pages copied)
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Intel machine check architecture supported.
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/3711
> caller is intel_p4_mcheck_init+0xb9/0x2b0
> Pid: 3711, comm: bash Tainted: G        W 2.6.27-rc3-00415-g122c9e0 #10
>  [<c037664e>] debug_smp_processor_id+0xce/0xd0
>  [<c010e919>] intel_p4_mcheck_init+0xb9/0x2b0
>  [<c010dcd9>] mcheck_init+0x59/0x80
>  [<c0589636>] restore_processor_state+0x1f6/0x230
>  [<c01635d1>] hibernation_snapshot+0x1d1/0x220
>  [<c013644b>] ? printk+0x1b/0x20
>  [<c0162742>] ? freeze_processes+0x52/0xa0
>  [<c0163700>] hibernate+0xe0/0x180
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c016226f>] state_store+0xbf/0xd0
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c03618d4>] kobj_attr_store+0x24/0x30
>  [<c01e66c2>] sysfs_write_file+0xa2/0x100
>  [<c01a85b6>] vfs_write+0x96/0x130
>  [<c01e6620>] ? sysfs_write_file+0x0/0x100
>  [<c01a8afd>] sys_write+0x3d/0x70
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  [<c0670000>] ? _read_unlock_irqrestore+0x60/0x70
>  =======================
> Intel machine check reporting enabled on CPU#0.
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/3711
> caller is intel_p4_mcheck_init+0x100/0x2b0
> Pid: 3711, comm: bash Tainted: G        W 2.6.27-rc3-00415-g122c9e0 #10
>  [<c037664e>] debug_smp_processor_id+0xce/0xd0
>  [<c010e960>] intel_p4_mcheck_init+0x100/0x2b0
>  [<c010dcd9>] mcheck_init+0x59/0x80
>  [<c0589636>] restore_processor_state+0x1f6/0x230
>  [<c01635d1>] hibernation_snapshot+0x1d1/0x220
>  [<c013644b>] ? printk+0x1b/0x20
>  [<c0162742>] ? freeze_processes+0x52/0xa0
>  [<c0163700>] hibernate+0xe0/0x180
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c016226f>] state_store+0xbf/0xd0
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c03618d4>] kobj_attr_store+0x24/0x30
>  [<c01e66c2>] sysfs_write_file+0xa2/0x100
>  [<c01a85b6>] vfs_write+0x96/0x130
>  [<c01e6620>] ? sysfs_write_file+0x0/0x100
>  [<c01a8afd>] sys_write+0x3d/0x70
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  [<c0670000>] ? _read_unlock_irqrestore+0x60/0x70
>  =======================
> CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/3711
> caller is intel_p4_mcheck_init+0x119/0x2b0
> Pid: 3711, comm: bash Tainted: G        W 2.6.27-rc3-00415-g122c9e0 #10
>  [<c037664e>] debug_smp_processor_id+0xce/0xd0
>  [<c010e979>] intel_p4_mcheck_init+0x119/0x2b0
>  [<c010dcd9>] mcheck_init+0x59/0x80
>  [<c0589636>] restore_processor_state+0x1f6/0x230
>  [<c01635d1>] hibernation_snapshot+0x1d1/0x220
>  [<c013644b>] ? printk+0x1b/0x20
>  [<c0162742>] ? freeze_processes+0x52/0xa0
>  [<c0163700>] hibernate+0xe0/0x180
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c016226f>] state_store+0xbf/0xd0
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c03618d4>] kobj_attr_store+0x24/0x30
>  [<c01e66c2>] sysfs_write_file+0xa2/0x100
>  [<c01a85b6>] vfs_write+0x96/0x130
>  [<c01e6620>] ? sysfs_write_file+0x0/0x100
>  [<c01a8afd>] sys_write+0x3d/0x70
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  [<c0670000>] ? _read_unlock_irqrestore+0x60/0x70
>  =======================
> CPU0: Thermal monitoring enabled
> Force enabled HPET at resume
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/3711
> caller is retrigger_next_event+0x15/0xb0
> Pid: 3711, comm: bash Tainted: G        W 2.6.27-rc3-00415-g122c9e0 #10
>  [<c037664e>] debug_smp_processor_id+0xce/0xd0
>  [<c014c6c5>] retrigger_next_event+0x15/0xb0
>  [<c066d3bf>] ? preempt_schedule+0x3f/0x50
>  [<c066fe1c>] ? _spin_unlock+0x3c/0x50
>  [<c014c76a>] hres_timers_resume+0xa/0x10
>  [<c01509bc>] timekeeping_resume+0x12c/0x180
>  [<c03df894>] __sysdev_resume+0x14/0x50
>  [<c03dfdae>] sysdev_resume+0x3e/0x80
>  [<c03e4f4b>] device_power_up+0xb/0x20
>  [<c01635b0>] hibernation_snapshot+0x1b0/0x220
>  [<c013644b>] ? printk+0x1b/0x20
>  [<c0162742>] ? freeze_processes+0x52/0xa0
>  [<c0163700>] hibernate+0xe0/0x180
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c016226f>] state_store+0xbf/0xd0
>  [<c01621b0>] ? state_store+0x0/0xd0
>  [<c03618d4>] kobj_attr_store+0x24/0x30
>  [<c01e66c2>] sysfs_write_file+0xa2/0x100
>  [<c01a85b6>] vfs_write+0x96/0x130
>  [<c01e6620>] ? sysfs_write_file+0x0/0x100
>  [<c01a8afd>] sys_write+0x3d/0x70
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  [<c0670000>] ? _read_unlock_irqrestore+0x60/0x70
>  =======================
> Enabling non-boot CPUs ...
> 
> ...and then, while writing the image, it looks something like this:
> 
> APIC error on CPU1: 40(40)
> ^H^H^H^H  3%<7>APIC error on CPU1: 40(40)
> WQ on CPU0, prefer CPU1
> APIC error on CPU1: 40(40)
> [8 times]
> APIC error on CPU1: 40(40)
> WQ on CPU0, prefer CPU1
> ...
> 
> The machine comes back with this spamming the logs (rate of about 2 KB/sec):
> 
> WQ on CPU0, prefer CPU1
> APIC error on CPU1: 40(40)
> [9 times, repeat]
> 
> I can still log in with ssh and reboot the machine, which finally
> gives this warning:
> 
> BUG: sleeping function called from invalid context at kernel/sched.c:4625
> in_atomic():1, irqs_disabled():0
> INFO: lockdep is turned off.
> Pid: 4027, comm: oprofiled Tainted: G        W 2.6.27-rc3-00415-g122c9e0 #10
>  [<c012c98e>] __might_sleep+0xee/0x140
>  [<c066c8d8>] wait_for_common+0x28/0x130
>  [<c01595bb>] ? trace_hardirqs_on+0xb/0x10
>  [<c066ff13>] ? _spin_unlock_irqrestore+0x43/0x70
>  [<c066ca72>] wait_for_completion+0x12/0x20
>  [<c014715d>] synchronize_rcu+0x2d/0x40
>  [<c01471f0>] ? wakeme_after_rcu+0x0/0x10
>  [<c01595bb>] ? trace_hardirqs_on+0xb/0x10
>  [<c014e156>] atomic_notifier_chain_unregister+0x36/0x50
>  [<c014e17f>] unregister_die_notifier+0xf/0x20
>  [<c0587b84>] nmi_shutdown+0x44/0x80
>  [<c0585d4a>] oprofile_shutdown+0x2a/0x60
>  [<c0586b50>] event_buffer_release+0x10/0x40
>  [<c01a8f26>] __fput+0xb6/0x180
>  [<c01a92a9>] fput+0x19/0x20
>  [<c01a63c7>] filp_close+0x47/0x70
>  [<c013741b>] put_files_struct+0x9b/0xb0
>  [<c0137472>] exit_files+0x42/0x60
>  [<c01386a2>] do_exit+0x192/0x880
>  [<c014d3b6>] ? up_read+0x16/0x30
>  [<c0120493>] ? do_page_fault+0x2e3/0x700
>  [<c01a7cc0>] ? do_sync_write+0x0/0x110
>  [<c0138dc1>] do_group_exit+0x31/0x90
>  [<c0138e2f>] sys_exit_group+0xf/0x20
>  [<c01040db>] sysenter_do_call+0x12/0x3f
>  =======================
> Sending all processes the KILL signal...
> 
> The last time I did this, the machine also came up with a corrupt ext3
> root filesystem. But it didn't happen this time, so I guess it could
> also be unrelated.
> 
> What would be the proper way to fix all this? Should oprofile be able
> to profile the suspend/resume code as well? Or should "echo disk" give
> -EBUSY if oprofile is running? Or
> do we simply insert a huge kludge in the form of mutual exclusion
> between oprofile and suspend in the Kconfig?

That last thing is probably the safest to do at the moment.

Apparently nmi_suspend() conflicts with oprofile somehow.  Also, the offlining
of non-boot CPUs may confuse it.  It would be helpful to check if the CPU
hotplug works with oprofile.

Thanks,
Rafael
