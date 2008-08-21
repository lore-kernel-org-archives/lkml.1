Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbYHURiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbYHURiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbYHURi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:38:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:58128 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760512AbYHURiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M0g3xLuwFlh816A6rW4uSOOv5Urd0cjjK1Ozdm2WMLV9T4hIKT7lRizGmgIaxv4PmI
         6imvaFpoYGHyYjwBAh/46c9fttwPPDf/tw6DmFW/mzFELsuR2c2B9VTbDorAv+V9GefV
         dIgYqmgiNh6U2BrvWwO64Jnk8nZWhuoWsElRM=
Message-ID: <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com>
Date: Thu, 21 Aug 2008 19:38:23 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ cc: Peter and Oleg ]

heh, my mind might have been also 'hibernated' by the everning but I
still dare to speculate :-)


=======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-00003-ga798564 #28
> -------------------------------------------------------
> events/0/10 is trying to acquire lock:
>  (cpu_add_remove_lock){--..}, at: [<c013bd9f>] cpu_maps_update_begin+0xf/0x20
> but task is already holding lock:
>  (poweroff_work){--..}, at: [<c014ae17>] run_workqueue+0x107/0x200
> which lock already depends on the new lock.
> the existing dependency chain (in reverse order) is:
> -> #2 (poweroff_work){--..}:
>       [<c015f9e6>] validate_chain+0x976/0xe90
>       [<c0160159>] __lock_acquire+0x259/0xa00
>       [<c0160989>] lock_acquire+0x89/0xc0
>       [<c014ae75>] run_workqueue+0x165/0x200
>       [<c014b9bd>] worker_thread+0x7d/0xe0
>       [<c014e252>] kthread+0x42/0x70
>       [<c0105cf3>] kernel_thread_helper+0x7/0x14
>       [<ffffffff>] 0xffffffff
> -> #1 (events){--..}:
>       [<c015f9e6>] validate_chain+0x976/0xe90
>       [<c0160159>] __lock_acquire+0x259/0xa00
>       [<c0160989>] lock_acquire+0x89/0xc0
>       [<c014b09e>] cleanup_workqueue_thread+0x3e/0x70
>       [<c0663bfc>] workqueue_cpu_callback+0x7c/0x130
>       [<c0152f97>] notifier_call_chain+0x37/0x70
>       [<c0153009>] __raw_notifier_call_chain+0x19/0x20
>       [<c015302a>] raw_notifier_call_chain+0x1a/0x20
>       [<c0661e9a>] _cpu_down+0x1ea/0x270
>       [<c013bf18>] disable_nonboot_cpus+0x58/0xe0
>       [<c0168897>] hibernation_snapshot+0x117/0x220
>       [<c0168a80>] hibernate+0xe0/0x180
>       [<c01675ef>] state_store+0xbf/0xd0
>       [<c0375f84>] kobj_attr_store+0x24/0x30
>       [<c01fa4c2>] sysfs_write_file+0xa2/0x100
>       [<c01bbf96>] vfs_write+0x96/0x130
>       [<c01bc4dd>] sys_write+0x3d/0x70
>       [<c0104f3b>] sysenter_do_call+0x12/0x3f

this path is triggered as a result of "echo disk > /sys/power/state"

disable_nonboot_cpus() calls cpu_maps_update_being() which takes
"cpu_add_remove_lock" (lock-1).

If we go down the road cleanup_workqueue_thread() ->
flush_cpu_workqueue() will take "cwq->lock" (lock-2).
So this should be the second lock.


>       [<ffffffff>] 0xffffffff
> -> #0 (cpu_add_remove_lock){--..}:
>       [<c015f5ba>] validate_chain+0x54a/0xe90
>       [<c0160159>] __lock_acquire+0x259/0xa00
>       [<c0160989>] lock_acquire+0x89/0xc0
>       [<c06859cb>] mutex_lock_nested+0xab/0x300
>       [<c013bd9f>] cpu_maps_update_begin+0xf/0x20
>       [<c013bed3>] disable_nonboot_cpus+0x13/0xe0
>       [<c0148990>] kernel_power_off+0x20/0x40
>       [<c016c0a8>] do_poweroff+0x8/0x10
>       [<c014ae7a>] run_workqueue+0x16a/0x200
>       [<c014b9bd>] worker_thread+0x7d/0xe0
>       [<c014e252>] kthread+0x42/0x70
>       [<c0105cf3>] kernel_thread_helper+0x7/0x14

hmm, did you somehow hit "Sysrq + o"?

'cause I don't see any other places (say, with handle_sysrq(k,...)
where "k" migth be 'o') from where do_power_off() might have been
triggered...

however, I think there are 2 problems with handle_poweroff()
[ kernel/power/poweroff.c ]

(1) it doesn't ensure that the 'cpu' it gets via
first_cpu(cpu_online_map) can't disappear (race with cpu_down()) on
the way to schedule_work_on()

[ I pressume, neither generic sysrq nor console layer takes care of
it. They shoudn't of course ]

(2) run_workqueue() [ which in the end calls do_poweroff() ] takes the
"cwq->lock" (which is lock-2 in our terminology)

well, actually it release it before calling "work->fun()" but is the
'lockdep' annotation right here? Peter?

(I admit, I never looked at lockdep and do make assumptions on its syntax here).

The lock-1 will be taken as a result of

then, do_poweroff() -> kernel_power_off() -> disable_nonboot_cpus()

which calls cpu_maps_update_begin() and takes "cpu_add_remove_lock"

and this looks dangerous. Due to the same reason as was before with
the use of get_online_cpus() by workqueue handlers before
CPU_POST_DEAD introduction
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3da1c84c00c7e5fa8348336bd8c342f9128b0f14)

I guess, it may deadlock as the lock-1 has been already taken before
calling cleanup_workqueue_thread() -> flush_cpu_workqueue() and
completion of the former chain depends in turn on being able to
acquire the very same lock.

hm?


>       [<ffffffff>] 0xffffffff
> other info that might help us debug this:
> 2 locks held by events/0/10:
>  #0:  (events){--..}, at: [<c014ae17>] run_workqueue+0x107/0x200
>  #1:  (poweroff_work){--..}, at: [<c014ae17>] run_workqueue+0x107/0x200
> stack backtrace:
> Pid: 10, comm: events/0 Not tainted 2.6.27-rc4-00003-ga798564 #28
>  [<c015f029>] print_circular_bug_tail+0x79/0xc0
>  [<c015c193>] ? print_circular_bug_entry+0x43/0x50
>  [<c015f5ba>] validate_chain+0x54a/0xe90
>  [<c015b565>] ? add_lock_to_list+0x45/0xb0
>  [<c039b7dd>] ? acpi_os_acquire_lock+0x8/0xa
>  [<c0160159>] __lock_acquire+0x259/0xa00
>  [<c015b67b>] ? trace_hardirqs_off+0xb/0x10
>  [<c0160989>] lock_acquire+0x89/0xc0
>  [<c013bd9f>] ? cpu_maps_update_begin+0xf/0x20
>  [<c06859cb>] mutex_lock_nested+0xab/0x300
>  [<c013bd9f>] ? cpu_maps_update_begin+0xf/0x20
>  [<c013bd9f>] ? cpu_maps_update_begin+0xf/0x20
>  [<c013bd9f>] cpu_maps_update_begin+0xf/0x20
>  [<c013bed3>] disable_nonboot_cpus+0x13/0xe0
>  [<c0148990>] kernel_power_off+0x20/0x40
>  [<c016c0a8>] do_poweroff+0x8/0x10
>  [<c014ae7a>] run_workqueue+0x16a/0x200
>  [<c014ae17>] ? run_workqueue+0x107/0x200
>  [<c016c0a0>] ? do_poweroff+0x0/0x10
>  [<c014b9bd>] worker_thread+0x7d/0xe0
>  [<c014e560>] ? autoremove_wake_function+0x0/0x50
>  [<c014b940>] ? worker_thread+0x0/0xe0
>  [<c014e252>] kthread+0x42/0x70
>  [<c014e210>] ? kthread+0x0/0x70
>  [<c0105cf3>] kernel_thread_helper+0x7/0x14
>  =======================
> Disabling non-boot CPUs ...
> Unmapping cpu 1 from all nodes
> Unmapping cpu 1 from all nodes
> CPU 1 is now offline
> lockdep: fixing up alternatives.
> SMP alternatives: switching to UP code
> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0 level CPU
>  groups: 0
> CPU1 is down
> Power down.
> acpi_power_off called
>  hwsleep-0326 [00] enter_sleep_state     : Entering sleep state [S5]
>
> ...the machine would shut down, but not resume:
>
> Trying to resume from /dev/VolGroup00/LogVol01
> No suspend signature on swap, not resuming.
> Creating root device.
> Mounting root filesystem.
>
> I previously also saw some SLUB errors on resuming (but those didn't
> make it to the serial console, unfortunately); will post follow-up if
> I can manage to get a capture.
>
> I don't know if it's related, but I was reading some files from /sys
> while doing the "echo disk > /sys/power/state".
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
>



-- 
Best regards,
Dmitry Adamushko
