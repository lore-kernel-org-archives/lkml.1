Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565Ab0AXLT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0AXLT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 06:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085Ab0AXLT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 06:19:56 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62688 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0AXLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 06:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bLuAXVRdk/wN0EpEFlIQLq3VIVdP7FzJgMCkfaUPdADsILPbKlQ6J4hVcIIUo/Nl+H
         qkVLfdTtDynZLi5JhKyeo4L3IYC6DtY7gUobnwnG21pZAHwtSZRNxjyF3cu13niiswzG
         KFRJAfOPxbILdSCDd3+Ff+fXLBVnnO3QCzVmw=
Date: Sun, 24 Jan 2010 12:19:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <glisse@freedesktop.org>
Subject: Re: Linux 2.6.33-rc5
Message-ID: <20100124111946.GA4170@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Jerome Glisse <glisse@freedesktop.org>
References: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001211535360.13231@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 03:44:26PM -0800, Linus Torvalds wrote:
> 
> Hmm. I don't think there is anything earth-shaking here, although the i915 
> KMS changes might be noticeable. Notably if you have eDP ("embedded 
> DisplayPort" - I think mainly a feature you'd find on a new imac), in 
> which case it now hopefully works, but more commonly if you saw the 
> flickering on your laptop panel due to LVDS downclocking (which saves 
> power, but is now disabled by default until that thing is resolved).
> 
> And there's a new DVB "Mantis" driver there.
> 
> Other than that, it's a lot of random fixes, mostly small. And some 
> defconfig updates, mostly huge and totally boring.

Two problems I got with this on my machine:

1. After suspend, the right monitor shows very funny colors, as if it is
on crack, in contrast to the left one which looks fine:

http://userweb.kernel.org/~bp/right_monitor.jpg
http://userweb.kernel.org/~bp/left_monitor.jpg

This started to appear after .33-rc4 and it could be a KMS-related
glitch since switching to one of the text terminals with
<CTRL>+<ALT>+<F1> and back to X seems to fix it. Ccing relevant parties.

2. During suspend I get this juicy lockdep warning:

[   52.549427] PM: Syncing filesystems ... done.
[   52.611462] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   52.624666] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[   52.635612] PM: Preallocating image memory... done (allocated 120806 pages)
[   52.900467] PM: Allocated 483224 kbytes in 0.26 seconds (1858.55 MB/s)
[   52.900507] Suspending console(s) (use no_console_suspend to debug)
[   52.901572] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[   52.903094] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   53.110577] ACPI handle has no context!
[   53.113252] serial 00:0b: disabled
[   53.225921] HDA Intel 0000:01:00.1: PCI INT B disabled
[   53.226078] ACPI handle has no context!
[   53.236488] pci 0000:01:00.0: PCI INT A disabled
[   53.337572] HDA Intel 0000:00:14.2: PCI INT A disabled
[   53.337819] ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
[   53.383175] ahci 0000:00:11.0: PCI INT A disabled
[   53.383738] PM: freeze of devices complete after 482.467 msecs
[   53.386516] PM: late freeze of devices complete after 2.771 msecs
[   53.387737] Disabling non-boot CPUs ...
[   53.401107] 
[   53.401110] =======================================================
[   53.401115] [ INFO: possible circular locking dependency detected ]
[   53.401121] 2.6.33-rc5 #3
[   53.401125] -------------------------------------------------------
[   53.401130] hib.sh/2129 is trying to acquire lock:
[   53.401135]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff812c610d>] lock_policy_rwsem_write+0x4a/0x7a
[   53.401153] 
[   53.401155] but task is already holding lock:
[   53.401158]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81032ba1>] cpu_hotplug_begin+0x27/0x4e
[   53.401172] 
[   53.401173] which lock already depends on the new lock.
[   53.401176] 
[   53.401179] 
[   53.401180] the existing dependency chain (in reverse order) is:
[   53.401184] 
[   53.401186] -> #4 (cpu_hotplug.lock){+.+.+.}:
[   53.401188]        [<ffffffff81056688>] validate_chain+0xa8f/0xd7e
[   53.401188]        [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]        [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]        [<ffffffff813976f4>] mutex_lock_nested+0x65/0x34d
[   53.401188]        [<ffffffff81032d5c>] get_online_cpus+0x37/0x4b
[   53.401188]        [<ffffffff81012249>] mtrr_del_page+0x39/0x137
[   53.401188]        [<ffffffff81012389>] mtrr_del+0x42/0x4b
[   53.401188]        [<ffffffff811df06d>] drm_rmmap_locked+0xe3/0x1a9
[   53.401188]        [<ffffffff811e4ce8>] drm_master_destroy+0x8d/0x132
[   53.401188]        [<ffffffff8114bc15>] kref_put+0x43/0x4d
[   53.401188]        [<ffffffff811e4bc7>] drm_master_put+0x1b/0x26
[   53.401188]        [<ffffffff811e15b6>] drm_release+0x55e/0x6a7
[   53.401188]        [<ffffffff810a743d>] __fput+0x120/0x1e2
[   53.401188]        [<ffffffff810a7514>] fput+0x15/0x17
[   53.401188]        [<ffffffff810a47e3>] filp_close+0x58/0x62
[   53.401188]        [<ffffffff810a4895>] sys_close+0xa8/0xe2
[   53.401188]        [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[   53.401188] 
[   53.401188] -> #3 (&dev->struct_mutex){+.+.+.}:
[   53.401188]        [<ffffffff81056688>] validate_chain+0xa8f/0xd7e
[   53.401188]        [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]        [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]        [<ffffffff813976f4>] mutex_lock_nested+0x65/0x34d
[   53.401188]        [<ffffffff811e63c3>] drm_mmap+0x33/0x58
[   53.401188]        [<ffffffff810905c7>] mmap_region+0x2db/0x4fa
[   53.401188]        [<ffffffff81090a71>] do_mmap_pgoff+0x28b/0x2ee
[   53.401188]        [<ffffffff81090bc5>] sys_mmap_pgoff+0xf1/0x129
[   53.401188]        [<ffffffff81006b17>] sys_mmap+0x1d/0x22
[   53.401188]        [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[   53.401188] 
[   53.401188] -> #2 (&mm->mmap_sem){++++++}:
[   53.401188]        [<ffffffff81056688>] validate_chain+0xa8f/0xd7e
[   53.401188]        [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]        [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]        [<ffffffff810889f8>] might_fault+0x90/0xb3
[   53.401188]        [<ffffffff810b363c>] filldir+0x70/0xcb
[   53.401188]        [<ffffffff810f3d4c>] sysfs_readdir+0x10a/0x144
[   53.401188]        [<ffffffff810b37b7>] vfs_readdir+0x66/0xa3
[   53.401188]        [<ffffffff810b3933>] sys_getdents+0x7c/0xcc
[   53.401188]        [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[   53.401188] 
[   53.401188] -> #1 (sysfs_mutex){+.+.+.}:
[   53.401188]        [<ffffffff81056688>] validate_chain+0xa8f/0xd7e
[   53.401188]        [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]        [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]        [<ffffffff813976f4>] mutex_lock_nested+0x65/0x34d
[   53.401188]        [<ffffffff810f4375>] sysfs_addrm_start+0x21/0x23
[   53.401188]        [<ffffffff810f489c>] create_dir+0x4d/0x93
[   53.401188]        [<ffffffff810f491a>] sysfs_create_dir+0x38/0x4b
[   53.401188]        [<ffffffff8114b057>] kobject_add_internal+0xdf/0x1a0
[   53.401188]        [<ffffffff8114b1ee>] kobject_add_varg+0x41/0x50
[   53.401188]        [<ffffffff8114b249>] kobject_init_and_add+0x4c/0x57
[   53.401188]        [<ffffffff812c6381>] cpufreq_add_dev_interface+0x3d/0x295
[   53.401188]        [<ffffffff812c6d07>] cpufreq_add_dev+0x462/0x472
[   53.401188]        [<ffffffff812526f6>] sysdev_driver_register+0xc4/0x11e
[   53.401188]        [<ffffffff812c5764>] cpufreq_register_driver+0x94/0x13e
[   53.401188]        [<ffffffffa0136586>] powernowk8_init+0xa0/0xab [powernow_k8]
[   53.401188]        [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[   53.401188]        [<ffffffff81062430>] sys_init_module+0xd3/0x237
[   53.401188]        [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[   53.401188] 
[   53.401188] -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[   53.401188]        [<ffffffff81056338>] validate_chain+0x73f/0xd7e
[   53.401188]        [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]        [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]        [<ffffffff81397c54>] down_write+0x44/0x77
[   53.401188]        [<ffffffff812c610d>] lock_policy_rwsem_write+0x4a/0x7a
[   53.401188]        [<ffffffff813956c5>] cpufreq_cpu_callback+0x52/0x7a
[   53.401188]        [<ffffffff8104a022>] notifier_call_chain+0x32/0x5e
[   53.401188]        [<ffffffff8104a0ad>] __raw_notifier_call_chain+0x9/0xb
[   53.401188]        [<ffffffff813843cf>] _cpu_down+0x93/0x295
[   53.401188]        [<ffffffff81032c37>] disable_nonboot_cpus+0x6f/0x108
[   53.401188]        [<ffffffff81063d57>] hibernation_snapshot+0x94/0x1be
[   53.401188]        [<ffffffff81063f4a>] hibernate+0xc9/0x16d
[   53.401188]        [<ffffffff81062dab>] state_store+0x57/0xce
[   53.401188]        [<ffffffff8114ac4f>] kobj_attr_store+0x17/0x19
[   53.401188]        [<ffffffff810f3515>] sysfs_write_file+0x103/0x13f
[   53.401188]        [<ffffffff810a68ca>] vfs_write+0xad/0x14e
[   53.401188]        [<ffffffff810a6a24>] sys_write+0x45/0x6c
[   53.401188]        [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[   53.401188] 
[   53.401188] other info that might help us debug this:
[   53.401188] 
[   53.401188] 6 locks held by hib.sh/2129:
[   53.401188]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff810f3449>] sysfs_write_file+0x37/0x13f
[   53.401188]  #1:  (s_active){++++.+}, at: [<ffffffff810f49c6>] sysfs_get_active_two+0x1f/0x45
[   53.401188]  #2:  (s_active){++++.+}, at: [<ffffffff810f49d3>] sysfs_get_active_two+0x2c/0x45
[   53.401188]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff81063e98>] hibernate+0x17/0x16d
[   53.401188]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81032b66>] cpu_maps_update_begin+0x12/0x14
[   53.401188]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81032ba1>] cpu_hotplug_begin+0x27/0x4e
[   53.401188] 
[   53.401188] stack backtrace:
[   53.401188] Pid: 2129, comm: hib.sh Not tainted 2.6.33-rc5 #3
[   53.401188] Call Trace:
[   53.401188]  [<ffffffff810556ae>] print_circular_bug+0xae/0xbd
[   53.401188]  [<ffffffff81056338>] validate_chain+0x73f/0xd7e
[   53.401188]  [<ffffffff81057234>] __lock_acquire+0x8bd/0x93d
[   53.401188]  [<ffffffff813993b8>] ? _raw_spin_unlock_irq+0x36/0x53
[   53.401188]  [<ffffffff81057337>] lock_acquire+0x83/0x9d
[   53.401188]  [<ffffffff812c610d>] ? lock_policy_rwsem_write+0x4a/0x7a
[   53.401188]  [<ffffffff81397c54>] down_write+0x44/0x77
[   53.401188]  [<ffffffff812c610d>] ? lock_policy_rwsem_write+0x4a/0x7a
[   53.401188]  [<ffffffff812c610d>] lock_policy_rwsem_write+0x4a/0x7a
[   53.401188]  [<ffffffff813956c5>] cpufreq_cpu_callback+0x52/0x7a
[   53.401188]  [<ffffffff8104a022>] notifier_call_chain+0x32/0x5e
[   53.401188]  [<ffffffff8104a0ad>] __raw_notifier_call_chain+0x9/0xb
[   53.401188]  [<ffffffff813843cf>] _cpu_down+0x93/0x295
[   53.401188]  [<ffffffff81032c37>] disable_nonboot_cpus+0x6f/0x108
[   53.401188]  [<ffffffff81063d57>] hibernation_snapshot+0x94/0x1be
[   53.401188]  [<ffffffff81063f4a>] hibernate+0xc9/0x16d
[   53.401188]  [<ffffffff81062dab>] state_store+0x57/0xce
[   53.401188]  [<ffffffff8114ac4f>] kobj_attr_store+0x17/0x19
[   53.401188]  [<ffffffff810f3515>] sysfs_write_file+0x103/0x13f
[   53.401188]  [<ffffffff810a68ca>] vfs_write+0xad/0x14e
[   53.401188]  [<ffffffff8105529f>] ? trace_hardirqs_on_caller+0x114/0x13f
[   53.401188]  [<ffffffff810a6a24>] sys_write+0x45/0x6c
[   53.401188]  [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b


Let me know if more info is needed.

Thanks.

-- 
Regards/Gruss,
    Boris.
