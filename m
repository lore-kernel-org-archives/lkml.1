Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYFZJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYFZJe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYFZJeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:34:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:9722 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYFZJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mF6E9KiMNnsDANbzSpDaNH6FFFYkKThMvsIl/1dnkRjEgM98ejmXiQHkEcgJGyAPGS
         2q3NkSk3507Bshf352tRXuVgZ3A9+HDjizV15EbwPuV75fDUe8LNn62dLGCZBIvZJESL
         2Rlk/6WLlqfuKo4bQsekZigdzEaI3ybo/KziI=
Message-ID: <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
Date: Thu, 26 Jun 2008 11:34:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Cc: "Paul Jackson" <pj@sgi.com>, a.p.zijlstra@chello.nl, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <48634BC1.8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48634BC1.8@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 9:56 AM, Paul Menage <menage@google.com> wrote:
> CPUsets: Move most calls to rebuild_sched_domains() to the workqueue
>
> In the current cpusets code the lock nesting between cgroup_mutex and
> cpuhotplug.lock when calling rebuild_sched_domains is inconsistent -
> in the CPU hotplug path cpuhotplug.lock nests outside cgroup_mutex,
> and in all other paths that call rebuild_sched_domains() it nests
> inside.
>
> This patch makes most calls to rebuild_sched_domains() asynchronous
> via the workqueue, which removes the nesting of the two locks in that
> case. In the case of an actual hotplug event, cpuhotplug.lock nests
> outside cgroup_mutex as now.
>
> Signed-off-by: Paul Menage <menage@google.com>
>
> ---
>
> Note that all I've done with this patch is verify that it compiles
> without warnings; I'm not sure how to trigger a hotplug event to test
> the lock dependencies or verify that scheduler domain support is still
> behaving correctly. Vegard, does this fix the problems that you were
> seeing? Paul/Max, does this still seem sane with regard to scheduler
> domains?

Nope, sorry :-(

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc8-dirty #39
-------------------------------------------------------
bash/3510 is trying to acquire lock:
 (events){--..}, at: [<c0145690>] cleanup_workqueue_thread+0x10/0x70

but task is already holding lock:
 (&cpu_hotplug.lock){--..}, at: [<c015d9da>] cpu_hotplug_begin+0x1a/0x50

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&cpu_hotplug.lock){--..}:
       [<c0158e65>] __lock_acquire+0xf45/0x1040
       [<c0158ff8>] lock_acquire+0x98/0xd0
       [<c057e6a1>] mutex_lock_nested+0xb1/0x300
       [<c015da3c>] get_online_cpus+0x2c/0x40
       [<c0162c98>] delayed_rebuild_sched_domains+0x8/0x30
       [<c014548b>] run_workqueue+0x15b/0x1f0
       [<c0145f09>] worker_thread+0x99/0xf0
       [<c0148772>] kthread+0x42/0x70
       [<c0105a63>] kernel_thread_helper+0x7/0x14
       [<ffffffff>] 0xffffffff

-> #1 (rebuild_sched_domains_work){--..}:
       [<c0158e65>] __lock_acquire+0xf45/0x1040
       [<c0158ff8>] lock_acquire+0x98/0xd0
       [<c0145486>] run_workqueue+0x156/0x1f0
       [<c0145f09>] worker_thread+0x99/0xf0
       [<c0148772>] kthread+0x42/0x70
       [<c0105a63>] kernel_thread_helper+0x7/0x14
       [<ffffffff>] 0xffffffff

-> #0 (events){--..}:
       [<c0158a15>] __lock_acquire+0xaf5/0x1040
       [<c0158ff8>] lock_acquire+0x98/0xd0
       [<c01456b6>] cleanup_workqueue_thread+0x36/0x70
       [<c055d91a>] workqueue_cpu_callback+0x7a/0x130
       [<c014d497>] notifier_call_chain+0x37/0x70
       [<c014d509>] __raw_notifier_call_chain+0x19/0x20
       [<c014d52a>] raw_notifier_call_chain+0x1a/0x20
       [<c055bb28>] _cpu_down+0x148/0x240
       [<c055bc4b>] cpu_down+0x2b/0x40
       [<c055ce69>] store_online+0x39/0x80
       [<c02fb91b>] sysdev_store+0x2b/0x40
       [<c01dd0a2>] sysfs_write_file+0xa2/0x100
       [<c019ecc6>] vfs_write+0x96/0x130
       [<c019f38d>] sys_write+0x3d/0x70
       [<c0104ceb>] sysenter_past_esp+0x78/0xd1
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by bash/3510:
 #0:  (&buffer->mutex){--..}, at: [<c01dd02b>] sysfs_write_file+0x2b/0x100
 #1:  (cpu_add_remove_lock){--..}, at: [<c015d97f>]
cpu_maps_update_begin+0xf/0x20
 #2:  (&cpu_hotplug.lock){--..}, at: [<c015d9da>] cpu_hotplug_begin+0x1a/0x50

stack backtrace:
Pid: 3510, comm: bash Not tainted 2.6.26-rc8-dirty #39
 [<c0156517>] print_circular_bug_tail+0x77/0x90
 [<c0155b93>] ? print_circular_bug_entry+0x43/0x50
 [<c0158a15>] __lock_acquire+0xaf5/0x1040
 [<c010aeb5>] ? native_sched_clock+0xb5/0x110
 [<c0157895>] ? mark_held_locks+0x65/0x80
 [<c0158ff8>] lock_acquire+0x98/0xd0
 [<c0145690>] ? cleanup_workqueue_thread+0x10/0x70
 [<c01456b6>] cleanup_workqueue_thread+0x36/0x70
 [<c0145690>] ? cleanup_workqueue_thread+0x10/0x70
 [<c055d91a>] workqueue_cpu_callback+0x7a/0x130
 [<c0580613>] ? _spin_unlock_irqrestore+0x43/0x70
 [<c014d497>] notifier_call_chain+0x37/0x70
 [<c014d509>] __raw_notifier_call_chain+0x19/0x20
 [<c014d52a>] raw_notifier_call_chain+0x1a/0x20
 [<c055bb28>] _cpu_down+0x148/0x240
 [<c015d97f>] ? cpu_maps_update_begin+0xf/0x20
 [<c055bc4b>] cpu_down+0x2b/0x40
 [<c055ce69>] store_online+0x39/0x80
 [<c055ce30>] ? store_online+0x0/0x80
 [<c02fb91b>] sysdev_store+0x2b/0x40
 [<c01dd0a2>] sysfs_write_file+0xa2/0x100
 [<c019ecc6>] vfs_write+0x96/0x130
 [<c01dd000>] ? sysfs_write_file+0x0/0x100
 [<c019f38d>] sys_write+0x3d/0x70
 [<c0104ceb>] sysenter_past_esp+0x78/0xd1
 =======================


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
