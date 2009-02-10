Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZBJWgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZBJWgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZBJWg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:36:27 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63400 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZBJWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HFIe04i0hDEpnpFHn/2W3seQHuhakXSxcRdxgrZx92b1VWM+/SocXkWr2Hc3224uh7
         rPSJu0ZxU/xxEVTzsVmFcL+GOHu3Lw832W4jocDNvTnQ5HbjY9V3DH+EmqK54fDRXuw3
         3VhxotEq2Grr5qF6AmPqoOk8B1JRtnT7wzw+U=
Date: Wed, 11 Feb 2009 00:37:12 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12574] possible circular locking dependency detected
Message-ID: <20090210223711.GA6809@google.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.4cG.E30jJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.4cG.E30jJB@chimera>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, dri guys,
Could you take a look at this circular dependency please (below)?  I
observe it when suspending laptop with radeon drm loaded and with
lockdep enabled. It seems that the root of the problem is that
various vm ops such as drm_vm_open, drm_mmap) are called with mm
semaphore taken, and take dev->struct_mutex. On the other hand,
drm_rmmap_locked is called with dev->struct_mutex, and calls mtrr_del
which depends on mm semaphore indirectly.

What do you think?

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12574
Subject         : possible circular locking dependency detected
Submitter       : Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date            : 2009-01-29 11:35 (11 days old)

/var/log/message dump below.


 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.29-rc4-mst-debug #95
 -------------------------------------------------------
 sleep.sh/6730 is trying to acquire lock:
  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<c02c0da1>] lock_policy_rwsem_write+0x31/0x70
 
 but task is already holding lock:
  (&cpu_hotplug.lock){--..}, at: [<c012d89a>] cpu_hotplug_begin+0x1a/0x50
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #6 (&cpu_hotplug.lock){--..}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c0366c5d>] mutex_lock_nested+0x9d/0x2e0
        [<c012d8fc>] get_online_cpus+0x2c/0x40
        [<c010d96f>] mtrr_del_page+0x2f/0x160
        [<c010dada>] mtrr_del+0x3a/0x50
        [<f851a342>] drm_rmmap_locked+0xc2/0x180 [drm]
        [<f8521d31>] drm_master_destroy+0x151/0x160 [drm]
        [<c022a37c>] kref_put+0x2c/0x80
        [<f8521af2>] drm_master_put+0x12/0x20 [drm]
        [<f851dd1b>] drm_release+0x25b/0x4a0 [drm]
        [<c019781d>] __fput+0xbd/0x1d0
        [<c0197c09>] fput+0x19/0x20
        [<c0194a47>] filp_close+0x47/0x70
        [<c0194ada>] sys_close+0x6a/0xc0
        [<c0103215>] sysenter_do_call+0x12/0x35
        [<ffffffff>] 0xffffffff
 
 -> #5 (&dev->struct_mutex){--..}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c0366c5d>] mutex_lock_nested+0x9d/0x2e0
        [<f8522add>] drm_vm_open+0x2d/0x50 [drm]
        [<c012a397>] dup_mm+0x227/0x310
        [<c012b22f>] copy_process+0xd7f/0x1020
        [<c012b5e8>] do_fork+0x78/0x320
        [<c01017ef>] sys_clone+0x2f/0x40
        [<c0103215>] sysenter_do_call+0x12/0x35
        [<ffffffff>] 0xffffffff
 
 -> #4 (&mm->mmap_sem/1){--..}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c01441e8>] down_write_nested+0x48/0x70
        [<c012a238>] dup_mm+0xc8/0x310
        [<c012b22f>] copy_process+0xd7f/0x1020
        [<c012b5e8>] do_fork+0x78/0x320
        [<c01017ef>] sys_clone+0x2f/0x40
        [<c0103292>] syscall_call+0x7/0xb
        [<ffffffff>] 0xffffffff
 
 -> #3 (&mm->mmap_sem){----}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c0183d73>] might_fault+0x73/0x90
        [<c022f633>] copy_to_user+0x33/0x60
        [<c01a3975>] filldir64+0xb5/0xe0
        [<c01e0c2f>] sysfs_readdir+0x11f/0x1f0
        [<c01a3b0d>] vfs_readdir+0x8d/0xb0
        [<c01a3b99>] sys_getdents64+0x69/0xc0
        [<c0103292>] syscall_call+0x7/0xb
        [<ffffffff>] 0xffffffff
 
 -> #2 (sysfs_mutex){--..}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c0366c5d>] mutex_lock_nested+0x9d/0x2e0
        [<c01e0f0c>] sysfs_addrm_start+0x2c/0xb0
        [<c01e14a0>] create_dir+0x40/0x90
        [<c01e1556>] sysfs_create_subdir+0x16/0x20
        [<c01e2770>] internal_create_group+0x50/0x1a0
        [<c01e28ec>] sysfs_create_group+0xc/0x10
        [<f81674fc>] cpufreq_stat_notifier_policy+0x9c/0x230 [cpufreq_stats]
        [<c036b007>] notifier_call_chain+0x37/0x80
        [<c0144d24>] __blocking_notifier_call_chain+0x44/0x60
        [<c0144d5a>] blocking_notifier_call_chain+0x1a/0x20
        [<c02c0226>] __cpufreq_set_policy+0xd6/0x230
        [<c02c14a8>] cpufreq_add_dev+0x4e8/0x6b0
        [<c029d5a5>] sysdev_driver_register+0x75/0x130
        [<c02bff55>] cpufreq_register_driver+0xb5/0x1c0
        [<f808b0bd>] uinput_destroy_device+0x4d/0x60 [uinput]
        [<c010111a>] do_one_initcall+0x2a/0x160
        [<c015bdf5>] sys_init_module+0x85/0x1b0
        [<c0103215>] sysenter_do_call+0x12/0x35
        [<ffffffff>] 0xffffffff
 
 -> #1 ((cpufreq_policy_notifier_list).rwsem){----}:
        [<c0152221>] validate_chain+0xb51/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c0367441>] down_read+0x41/0x60
        [<c0144d0a>] __blocking_notifier_call_chain+0x2a/0x60
        [<c0144d5a>] blocking_notifier_call_chain+0x1a/0x20
        [<c02c1165>] cpufreq_add_dev+0x1a5/0x6b0
        [<c029d5a5>] sysdev_driver_register+0x75/0x130
        [<c02bff55>] cpufreq_register_driver+0xb5/0x1c0
        [<f808b0bd>] uinput_destroy_device+0x4d/0x60 [uinput]
        [<c010111a>] do_one_initcall+0x2a/0x160
        [<c015bdf5>] sys_init_module+0x85/0x1b0
        [<c0103215>] sysenter_do_call+0x12/0x35
        [<ffffffff>] 0xffffffff
 
 -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
        [<c0151cbb>] validate_chain+0x5eb/0x1150
        [<c0152a66>] __lock_acquire+0x246/0xa50
        [<c01532d0>] lock_acquire+0x60/0x80
        [<c03674a1>] down_write+0x41/0x60
        [<c02c0da1>] lock_policy_rwsem_write+0x31/0x70
        [<c03655a5>] cpufreq_cpu_callback+0x45/0x80
        [<c036b007>] notifier_call_chain+0x37/0x80
        [<c0144b49>] __raw_notifier_call_chain+0x19/0x20
        [<c03574c9>] _cpu_down+0x79/0x280
        [<c012da5c>] disable_nonboot_cpus+0x7c/0x100
        [<c015cac5>] suspend_devices_and_enter+0xd5/0x170
        [<c015cd40>] enter_state+0x1b0/0x1c0
        [<c015cddf>] state_store+0x8f/0xd0
        [<c0228cf4>] kobj_attr_store+0x24/0x30
        [<c01e02d2>] sysfs_write_file+0xa2/0x100
        [<c0196e89>] vfs_write+0x99/0x130
        [<c01973cd>] sys_write+0x3d/0x70
        [<c0103215>] sysenter_do_call+0x12/0x35
        [<ffffffff>] 0xffffffff
 
 other info that might help us debug this:
 
 4 locks held by sleep.sh/6730:
  #0:  (&buffer->mutex){--..}, at: [<c01e025b>] sysfs_write_file+0x2b/0x100
  #1:  (pm_mutex){--..}, at: [<c015cbdb>] enter_state+0x4b/0x1c0
  #2:  (cpu_add_remove_lock){--..}, at: [<c012d83f>] cpu_maps_update_begin+0xf/0x20
  #3:  (&cpu_hotplug.lock){--..}, at: [<c012d89a>] cpu_hotplug_begin+0x1a/0x50
 
 stack backtrace:
 Pid: 6730, comm: sleep.sh Not tainted 2.6.29-rc4-mst-debug #95
 Call Trace:
  [<c015166c>] print_circular_bug_tail+0x7c/0xe0
  [<c0151cbb>] validate_chain+0x5eb/0x1150
  [<c0152a66>] __lock_acquire+0x246/0xa50
  [<c013cf1e>] ? __cancel_work_timer+0x2e/0x190
  [<c01532d0>] lock_acquire+0x60/0x80
  [<c02c0da1>] ? lock_policy_rwsem_write+0x31/0x70
  [<c03674a1>] down_write+0x41/0x60
  [<c02c0da1>] ? lock_policy_rwsem_write+0x31/0x70
  [<c02c0da1>] lock_policy_rwsem_write+0x31/0x70
  [<c03655a5>] cpufreq_cpu_callback+0x45/0x80
  [<c036b007>] notifier_call_chain+0x37/0x80
  [<c0144b49>] __raw_notifier_call_chain+0x19/0x20
  [<c03574c9>] _cpu_down+0x79/0x280
  [<c012d83f>] ? cpu_maps_update_begin+0xf/0x20
  [<c012da5c>] disable_nonboot_cpus+0x7c/0x100
  [<c02531cb>] ? acpi_disable_all_gpes+0x25/0x2a
  [<c015cac5>] suspend_devices_and_enter+0xd5/0x170
  [<c015cd40>] enter_state+0x1b0/0x1c0
  [<c015cddf>] state_store+0x8f/0xd0
  [<c015cd50>] ? state_store+0x0/0xd0
  [<c0228cf4>] kobj_attr_store+0x24/0x30
  [<c01e02d2>] sysfs_write_file+0xa2/0x100
  [<c0196e89>] vfs_write+0x99/0x130
  [<c0103247>] ? sysenter_exit+0xf/0x18
  [<c01e0230>] ? sysfs_write_file+0x0/0x100
  [<c01973cd>] sys_write+0x3d/0x70
  [<c0103215>] sysenter_do_call+0x12/0x35

-- 
MST
