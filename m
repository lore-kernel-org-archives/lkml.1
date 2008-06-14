Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYFNKyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYFNKyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYFNKyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:54:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:55691 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYFNKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UrC9qM8Hnp26GKwScoIOEfZgGReVuNI6JjsldnLWPHMEZg1e9vW5TWPQRbtF7Oe2xv
         YrdtPur4YwaVhyTbC0afwvpw3It2WEKXQ4AqRPieOdnCpLaBG5VFmx3RfRsH5uRIi9nM
         mmQmAJdg43kfKWuHuEkD/ywFdY78r0cK8vWhg=
Message-ID: <6278d2220806140354i7f163086i6127664d8c2d88a9@mail.gmail.com>
Date: Sat, 14 Jun 2008 11:54:02 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: 2.6.26-rc5: SLUB debug, lockdep warning...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling lockdep + SLUB debugging, I spotted this recursive
lock-acquisition warning [1] when booting, however it doesn't always
pop out.

Let me know if you need further information etc.

Daniel

--- [1]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc5-201c #1
-------------------------------------------------------
nscd/3669 is trying to acquire lock:
 (&n->list_lock){.+..}, at: [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0

but task is already holding lock:
 (&obj_hash[i].lock){++..}, at: [<ffffffff803fa56f>]
__debug_object_init+0x2f/0x350

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&obj_hash[i].lock){++..}:
       [<ffffffff80278dad>] __lock_acquire+0xbdd/0x1020
       [<ffffffff80279255>] lock_acquire+0x65/0x90
       [<ffffffff805e1027>] _spin_lock_irqsave+0x47/0x80
       [<ffffffff803f9eec>] __debug_check_no_obj_freed+0x6c/0x160
       [<ffffffff803f9ff5>] debug_check_no_obj_freed+0x15/0x20
       [<ffffffff80296b6d>] free_hot_cold_page+0x10d/0x250
       [<ffffffff80296cfb>] free_hot_page+0xb/0x10
       [<ffffffff80296d25>] __free_pages+0x25/0x40
       [<ffffffff802ba886>] __free_slab+0x96/0x150
       [<ffffffff802ba96f>] discard_slab+0x2f/0x50
       [<ffffffff802bebe0>] kmem_cache_shrink+0x150/0x280
       [<ffffffff8040a8ae>] acpi_os_purge_cache+0x9/0xd
       [<ffffffff804217b0>] acpi_purge_cached_objects+0x10/0x38
       [<ffffffff80421836>] acpi_initialize_objects+0x49/0x54
       [<ffffffff8082ba27>] acpi_init+0x8c/0x221
       [<ffffffff80812a98>] kernel_init+0x138/0x320
       [<ffffffff80227418>] child_rip+0xa/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&n->list_lock){.+..}:
       [<ffffffff80278c17>] __lock_acquire+0xa47/0x1020
       [<ffffffff80279255>] lock_acquire+0x65/0x90
       [<ffffffff805e0c41>] _spin_lock+0x31/0x60
       [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0
       [<ffffffff802bbb12>] __slab_alloc+0x132/0x550
       [<ffffffff802bc0d0>] kmem_cache_alloc+0xc0/0xd0
       [<ffffffff803fa7f4>] __debug_object_init+0x2b4/0x350
       [<ffffffff803fa8ac>] debug_object_init_on_stack+0x1c/0x30
       [<ffffffff8026ce59>] hrtimer_init_on_stack+0x29/0x50
       [<ffffffff8027ae09>] futex_wait+0x249/0x480
       [<ffffffff8027c248>] do_futex+0xb8/0xad0
       [<ffffffff8027cd05>] sys_futex+0xa5/0x120
       [<ffffffff802264ab>] system_call_after_swapgs+0x7b/0x80
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by nscd/3669:
 #0:  (&obj_hash[i].lock){++..}, at: [<ffffffff803fa56f>]
__debug_object_init+0x2f/0x350

stack backtrace:
Pid: 3669, comm: nscd Not tainted 2.6.26-rc5-201c #1

Call Trace:
 [<ffffffff80276683>] print_circular_bug_tail+0x83/0x90
 [<ffffffff80278c17>] __lock_acquire+0xa47/0x1020
 [<ffffffff80279255>] lock_acquire+0x65/0x90
 [<ffffffff802bab03>] ? deactivate_slab+0x173/0x1e0
 [<ffffffff805e0c41>] _spin_lock+0x31/0x60
 [<ffffffff802bab03>] deactivate_slab+0x173/0x1e0
 [<ffffffff802bbb12>] __slab_alloc+0x132/0x550
 [<ffffffff803fa7f4>] ? __debug_object_init+0x2b4/0x350
 [<ffffffff803fa7f4>] ? __debug_object_init+0x2b4/0x350
 [<ffffffff802bc0d0>] kmem_cache_alloc+0xc0/0xd0
 [<ffffffff803fa7f4>] __debug_object_init+0x2b4/0x350
 [<ffffffff803fa8ac>] debug_object_init_on_stack+0x1c/0x30
 [<ffffffff8026ce59>] hrtimer_init_on_stack+0x29/0x50
 [<ffffffff8027ae09>] futex_wait+0x249/0x480
 [<ffffffff80275103>] ? get_lock_stats+0x23/0x70
 [<ffffffff8023c815>] ? flat_send_IPI_mask+0x55/0x90
 [<ffffffff8023711e>] ? native_smp_send_reschedule+0x2e/0x50
 [<ffffffff8024740b>] ? __resched_task+0x6b/0x80
 [<ffffffff8024782c>] ? hrtick_start_fair+0x11c/0x160
 [<ffffffff80249e20>] ? default_wake_function+0x0/0x10
 [<ffffffff8027c248>] do_futex+0xb8/0xad0
 [<ffffffff80275103>] ? get_lock_stats+0x23/0x70
 [<ffffffff802751e6>] ? lock_release_holdtime+0x66/0x80
 [<ffffffff803f246d>] ? __up_read+0x4d/0xb0
 [<ffffffff805e1475>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff80277c8f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff8022d059>] ? read_tsc+0x9/0x20
 [<ffffffff8026f266>] ? getnstimeofday+0x36/0xb0
 [<ffffffff8026d04a>] ? ktime_get_ts+0x4a/0x60
 [<ffffffff8027cd05>] sys_futex+0xa5/0x120
 [<ffffffff802264ab>] system_call_after_swapgs+0x7b/0x80
-- 
Daniel J Blueman
