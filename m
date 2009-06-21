Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZFUVft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZFUVft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZFUVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:35:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53853 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZFUVfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YzTYISB2+l3Ms8Cyj3Z8za9ZVEVwNPiA8YNX7vlTNm6kvwJQvGtFyxt8glS8mUmNnt
         LuzPGn3XA+dSIX00VOHCX0uxB+yWLEO39T0d8HyHbgFlF81MCcY+Lf3IQ0TifbEdlcJk
         UnwNNfMZvmyZBR5qPpCrKbckkV0ULFeCfDW24=
Date: Sun, 21 Jun 2009 23:35:25 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6.30]fbdev: possible circular locking dependency in fb_mmap
Message-ID: <20090621213525.GA2977@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this warning in vanilla 2.6.30. Reverting the patch below removes
the warning.

Regards,
Jarek P. 

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30f #39
-------------------------------------------------------
Xorg/2446 is trying to acquire lock:
 (&fb_info->lock){+.+.+.}, at: [<c02181c7>] fb_mmap+0x97/0x170

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c0106ede>] sys_mmap2+0x8e/0xc0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_sem){++++++}:
       [<c0148606>] __lock_acquire+0xf26/0x17a0
       [<c0148ede>] lock_acquire+0x5e/0x80
       [<c016f72b>] might_fault+0x8b/0xb0
       [<c01f8a36>] copy_to_user+0x36/0x120
       [<c0194f54>] filldir64+0xa4/0xf0
       [<c01cbbc9>] sysfs_readdir+0x129/0x220
       [<c01951e6>] vfs_readdir+0x86/0xa0
       [<c0195269>] sys_getdents64+0x69/0xc0
       [<c0102f49>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #2 (sysfs_mutex){+.+.+.}:
       [<c0148606>] __lock_acquire+0xf26/0x17a0
       [<c0148ede>] lock_acquire+0x5e/0x80
       [<c0303877>] mutex_lock_nested+0x57/0x300
       [<c01cbfcc>] sysfs_addrm_start+0x2c/0xb0
       [<c01cc580>] create_dir+0x40/0x90
       [<c01cc5fb>] sysfs_create_dir+0x2b/0x50
       [<c01f1ff2>] kobject_add_internal+0xc2/0x1b0
       [<c01f21e1>] kobject_add_varg+0x31/0x50
       [<c01f225c>] kobject_add+0x2c/0x60
       [<c02699ba>] device_add+0xca/0x560
       [<c0269e62>] device_register+0x12/0x20
       [<c0269f12>] device_create_vargs+0xa2/0xb0
       [<c0269f48>] device_create+0x28/0x30
       [<c026448d>] register_con_driver+0x14d/0x190
       [<c02678db>] take_over_console+0x1b/0x430
       [<c0221fbc>] fbcon_takeover+0x5c/0xb0
       [<c0225f3e>] fbcon_event_notify+0x7de/0x810
       [<c013bfad>] notifier_call_chain+0x2d/0x70
       [<c013c344>] __blocking_notifier_call_chain+0x44/0x60
       [<c013c37a>] blocking_notifier_call_chain+0x1a/0x20
       [<c0217ac1>] fb_notifier_call_chain+0x11/0x20
       [<c0218b23>] register_framebuffer+0x173/0x230
       [<c041edc2>] vesafb_probe+0x542/0x783
       [<c026cbbc>] platform_drv_probe+0xc/0x10
       [<c026bcf4>] driver_probe_device+0x74/0x190
       [<c026bef1>] __device_attach+0x41/0x50
       [<c026b35b>] bus_for_each_drv+0x5b/0x80
       [<c026bf9b>] device_attach+0x6b/0x70
       [<c026b167>] bus_attach_device+0x47/0x70
       [<c0269c20>] device_add+0x330/0x560
       [<c026d58d>] platform_device_add+0x15d/0x1a0
       [<c041f09d>] vesafb_init+0x9a/0x1ec
       [<c010111a>] do_one_initcall+0x2a/0x160
       [<c04044f5>] kernel_init+0x8d/0xe1
       [<c010372b>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #1 ((fb_notifier_list).rwsem){.+.+.+}:
       [<c0148606>] __lock_acquire+0xf26/0x17a0
       [<c0148ede>] lock_acquire+0x5e/0x80
       [<c0304231>] down_read+0x41/0x60
       [<c013c32a>] __blocking_notifier_call_chain+0x2a/0x60
       [<c013c37a>] blocking_notifier_call_chain+0x1a/0x20
       [<c0217ac1>] fb_notifier_call_chain+0x11/0x20
       [<c0218b23>] register_framebuffer+0x173/0x230
       [<c041edc2>] vesafb_probe+0x542/0x783
       [<c026cbbc>] platform_drv_probe+0xc/0x10
       [<c026bcf4>] driver_probe_device+0x74/0x190
       [<c026bef1>] __device_attach+0x41/0x50
       [<c026b35b>] bus_for_each_drv+0x5b/0x80
       [<c026bf9b>] device_attach+0x6b/0x70
       [<c026b167>] bus_attach_device+0x47/0x70
       [<c0269c20>] device_add+0x330/0x560
       [<c026d58d>] platform_device_add+0x15d/0x1a0
       [<c041f09d>] vesafb_init+0x9a/0x1ec
       [<c010111a>] do_one_initcall+0x2a/0x160
       [<c04044f5>] kernel_init+0x8d/0xe1
       [<c010372b>] kernel_thread_helper+0x7/0x1c
       [<ffffffff>] 0xffffffff

-> #0 (&fb_info->lock){+.+.+.}:
       [<c0148945>] __lock_acquire+0x1265/0x17a0
       [<c0148ede>] lock_acquire+0x5e/0x80
       [<c0303877>] mutex_lock_nested+0x57/0x300
       [<c02181c7>] fb_mmap+0x97/0x170
       [<c01768d6>] mmap_region+0x2d6/0x450
       [<c0176c1a>] do_mmap_pgoff+0x1ca/0x2f0
       [<c0106efd>] sys_mmap2+0xad/0xc0
       [<c0102ec8>] sysenter_do_call+0x12/0x36
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by Xorg/2446:
 #0:  (&mm->mmap_sem){++++++}, at: [<c0106ede>] sys_mmap2+0x8e/0xc0

stack backtrace:
Pid: 2446, comm: Xorg Not tainted 2.6.30f #39
Call Trace:
 [<c0302400>] ? printk+0x18/0x20
 [<c01471e3>] print_circular_bug_tail+0xc3/0xd0
 [<c0146f0b>] ? print_circular_bug_entry+0x4b/0x50
 [<c0148945>] __lock_acquire+0x1265/0x17a0
 [<c015e0ab>] ? __generic_file_aio_write_nolock+0x23b/0x590
 [<c014699c>] ? trace_hardirqs_on_caller+0x11c/0x160
 [<c0148ede>] lock_acquire+0x5e/0x80
 [<c02181c7>] ? fb_mmap+0x97/0x170
 [<c02181c7>] ? fb_mmap+0x97/0x170
 [<c0303877>] mutex_lock_nested+0x57/0x300
 [<c02181c7>] ? fb_mmap+0x97/0x170
 [<c01832d5>] ? kmem_cache_alloc+0xb5/0x100
 [<c014699c>] ? trace_hardirqs_on_caller+0x11c/0x160
 [<c02181c7>] fb_mmap+0x97/0x170
 [<c01768d6>] mmap_region+0x2d6/0x450
 [<c0176c1a>] do_mmap_pgoff+0x1ca/0x2f0
 [<c0106efd>] sys_mmap2+0xad/0xc0
 [<c0102ec8>] sysenter_do_call+0x12/0x36

------------------>

commit 513adb58685615b0b1d47a3f0d40f5352beff189
Author: Andrea Righi <righi.andrea@gmail.com>
Date:   Mon Apr 13 14:39:39 2009 -0700

    fbdev: fix info->lock deadlock in fbcon_event_notify()
    
    fb_notifier_call_chain() is called with info->lock held, i.e.  in
    do_fb_ioctl() => FBIOPUT_VSCREENINFO => fb_set_var() and the some
    notifier callbacks, like fbcon_event_notify(), try to re-acquire
    info->lock again.
    
    Remove the lock/unlock_fb_info() in all the framebuffer notifier
    callbacks' and be sure to always call fb_notifier_call_chain() with
    info->lock held.
    
