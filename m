Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbZLZJpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbZLZJpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 04:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZLZJpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 04:45:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42878 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZLZJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 04:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tkEHTMkM7S2mVri9JcbUv868ZcglhLEn/ulmlsM6YSbM/w8MUqMfRrJVTsnHInhPbR
         6U+GrVSBT6EsBRHenRpL9Mdqu3YwqGt2rbntyJckT6jnTAO55AKI/q9H9lCSCa6j3ZZf
         iT2wSKI524kKEZatn1PbtCNYI1lKWWfgDnvhs=
Date: Sat, 26 Dec 2009 10:45:04 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Airlie <airlied@linux.ie>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: drm_vm.c:drm_mmap: possible circular locking dependency detected
 (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
Message-ID: <20091226094504.GA6214@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this jumped into dmesg upon resume (.config and dmesg are attached in
the previous "EHCI resume sysfs duplicates..." message in this thread):

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.33-rc2-00001-g6d7daec #1
-------------------------------------------------------
Xorg/3076 is trying to acquire lock:
 (&dev->struct_mutex){+.+.+.}, at: [<ffffffff81223fd4>] drm_mmap+0x38/0x5c

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff810b7509>] sys_mmap_pgoff+0xd6/0x1b4

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_sem){++++++}:
       [<ffffffff810694c0>] __lock_acquire+0x1373/0x16fd
       [<ffffffff8106993c>] lock_acquire+0xf2/0x116
       [<ffffffff810bb2b5>] might_fault+0x95/0xb8
       [<ffffffff810e87d6>] filldir+0x75/0xd0
       [<ffffffff8112be2a>] sysfs_readdir+0x10f/0x149
       [<ffffffff810e895b>] vfs_readdir+0x6b/0xa8
       [<ffffffff810e8ae1>] sys_getdents+0x81/0xd1
       [<ffffffff810022f2>] system_call_fastpath+0x16/0x1b

-> #2 (sysfs_mutex){+.+.+.}:
       [<ffffffff810694c0>] __lock_acquire+0x1373/0x16fd
       [<ffffffff8106993c>] lock_acquire+0xf2/0x116
       [<ffffffff813e9e5c>] mutex_lock_nested+0x63/0x354
       [<ffffffff8112c488>] sysfs_addrm_start+0x26/0x28
       [<ffffffff8112c940>] sysfs_remove_dir+0x52/0x8d
       [<ffffffff8118b6f9>] kobject_del+0x16/0x37
       [<ffffffff8118b758>] kobject_release+0x3e/0x66
       [<ffffffff8118c5b5>] kref_put+0x43/0x4d
       [<ffffffff8118b674>] kobject_put+0x47/0x4b
       [<ffffffff813e11c1>] cacheinfo_cpu_callback+0xa2/0xdb
       [<ffffffff8105c317>] notifier_call_chain+0x37/0x63
       [<ffffffff8105c3c7>] raw_notifier_call_chain+0x14/0x16
       [<ffffffff813d58ec>] _cpu_down+0x1a5/0x29a
       [<ffffffff8103c851>] disable_nonboot_cpus+0x74/0x10d
       [<ffffffff8107793e>] hibernation_snapshot+0x99/0x1d3
       [<ffffffff81077b46>] hibernate+0xce/0x172
       [<ffffffff810768d4>] state_store+0x5c/0xd3
       [<ffffffff8118b48b>] kobj_attr_store+0x17/0x19
       [<ffffffff8112b4bd>] sysfs_write_file+0x108/0x144
       [<ffffffff810daf53>] vfs_write+0xb2/0x153
       [<ffffffff810db0b7>] sys_write+0x4a/0x71
       [<ffffffff810022f2>] system_call_fastpath+0x16/0x1b

-> #1 (cpu_hotplug.lock){+.+.+.}:
       [<ffffffff810694c0>] __lock_acquire+0x1373/0x16fd
       [<ffffffff8106993c>] lock_acquire+0xf2/0x116
       [<ffffffff813e9e5c>] mutex_lock_nested+0x63/0x354
       [<ffffffff8103c980>] get_online_cpus+0x3c/0x50
       [<ffffffff81014c1a>] mtrr_del_page+0x3e/0x13c
       [<ffffffff81014d5f>] mtrr_del+0x47/0x4f
       [<ffffffff8121c23b>] drm_rmmap_locked+0xdc/0x1a2
       [<ffffffff812226e3>] drm_master_destroy+0x86/0x11f
       [<ffffffff8118c5b5>] kref_put+0x43/0x4d
       [<ffffffff812225c4>] drm_master_put+0x20/0x2b
       [<ffffffff8121ea71>] drm_release+0x54b/0x688
       [<ffffffff810dbb24>] __fput+0x125/0x1e7
       [<ffffffff810dbc00>] fput+0x1a/0x1c
       [<ffffffff810d8d02>] filp_close+0x5d/0x67
       [<ffffffff810d8db9>] sys_close+0xad/0xe7
       [<ffffffff810022f2>] system_call_fastpath+0x16/0x1b

-> #0 (&dev->struct_mutex){+.+.+.}:
       [<ffffffff81069170>] __lock_acquire+0x1023/0x16fd
       [<ffffffff8106993c>] lock_acquire+0xf2/0x116
       [<ffffffff813e9e5c>] mutex_lock_nested+0x63/0x354
       [<ffffffff81223fd4>] drm_mmap+0x38/0x5c
       [<ffffffff810c34f5>] mmap_region+0x2e0/0x4ff
       [<ffffffff810c39a4>] do_mmap_pgoff+0x290/0x2f3
       [<ffffffff810b7529>] sys_mmap_pgoff+0xf6/0x1b4
       [<ffffffff8100719b>] sys_mmap+0x22/0x27
       [<ffffffff810022f2>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by Xorg/3076:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810b7509>] sys_mmap_pgoff+0xd6/0x1b4

stack backtrace:
Pid: 3076, comm: Xorg Tainted: G        W  2.6.33-rc2-00001-g6d7daec #1
Call Trace:
 [<ffffffff81067c10>] print_circular_bug+0xae/0xbd
 [<ffffffff81069170>] __lock_acquire+0x1023/0x16fd
 [<ffffffff81223fd4>] ? drm_mmap+0x38/0x5c
 [<ffffffff8106993c>] lock_acquire+0xf2/0x116
 [<ffffffff81223fd4>] ? drm_mmap+0x38/0x5c
 [<ffffffff81223fd4>] ? drm_mmap+0x38/0x5c
 [<ffffffff81223fd4>] ? drm_mmap+0x38/0x5c
 [<ffffffff813e9e5c>] mutex_lock_nested+0x63/0x354
 [<ffffffff81223fd4>] ? drm_mmap+0x38/0x5c
 [<ffffffff81067526>] ? mark_held_locks+0x52/0x70
 [<ffffffff810d55f6>] ? kmem_cache_alloc+0xc2/0x168
 [<ffffffff810c3452>] ? mmap_region+0x23d/0x4ff
 [<ffffffff810677b1>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81223fd4>] drm_mmap+0x38/0x5c
 [<ffffffff813eac54>] ? __down_write_nested+0x1c/0xcc
 [<ffffffff810c34f5>] mmap_region+0x2e0/0x4ff
 [<ffffffff810c39a4>] do_mmap_pgoff+0x290/0x2f3
 [<ffffffff810b7529>] sys_mmap_pgoff+0xf6/0x1b4
 [<ffffffff810677b1>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff813eae16>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100719b>] sys_mmap+0x22/0x27
 [<ffffffff810022f2>] system_call_fastpath+0x16/0x1b
[drm] Setting GART location based on new memory map
[drm] Loading RV635 CP Microcode
platform r600_cp.0: firmware: using built-in firmware radeon/RV635_pfp.bin
platform r600_cp.0: firmware: using built-in firmware radeon/RV635_me.bin
[drm] Resetting GPU
[drm] writeback test succeeded in 1 usecs


-- 
Regards/Gruss,
    Boris.
