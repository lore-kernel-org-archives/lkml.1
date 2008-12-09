Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYLILEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYLILEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYLILDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:03:45 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:3140 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYLILDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:03:43 -0500
Date: Tue, 9 Dec 2008 12:03:37 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: BUG: bad unlock balance detected! e1000e
Message-ID: <20081209110337.GJ4864@gambetta>
References: <c4e36d110812080324y68c0e453qcb68a040da7ac9a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110812080324y68c0e453qcb68a040da7ac9a2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Zdenek,

This could be due to 717d438d1fde94decef874b9808379d1f4523453
    "e1000e: debug contention on NVM SWFLAG"
Error handling is missing from e1000_reset_hw_ich8lan so it may happen
that we don't acquire the nvm_mutex if the card times out.

Adding Thomas to CC.

Regards,
Frederik

It some error checking is missing in e1000e: debug contention on NVM
SWFLAG
On Mon, Dec 08, 2008 at 12:24:09PM +0100, Zdenek Kabelac wrote:
> Hi
> 
> During occasional scan of message log - I've found out this BUG which
> happened on Dec3 with the -rc7 from that day.
> (So if it's now fixed in current git feel free to ignore :))
> 
> My machine T61 - C2D, 2GB, 64bit kernel - message appeared during
> shutdown and was actually not noticed by me...
> 
> 
> NetworkManager: <WARN>  nm_signal_handler(): Caught signal 15,
> shutting down normally.
> NetworkManager: <info>  (eth0): now unmanaged
> NetworkManager: <info>  (eth0): device state change: 3 -> 1
> NetworkManager: <info>  (eth0): cleaning up...
> NetworkManager: <info>  (eth0): taking down device.
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> NetworkManager/2058 is trying to release lock (nvm_mutex) at:
> [<ffffffff8052acb9>] mutex_unlock+0x9/0x10
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 1 lock held by NetworkManager/2058:
>  #0:  (rtnl_mutex){--..}, at: [<ffffffff804b09ba>] rtnetlink_rcv+0x1a/0x40
> 
> stack backtrace:
> Pid: 2058, comm: NetworkManager Not tainted 2.6.28-rc7 #90
> Call Trace:
>  [<ffffffff8026bf6b>] print_unlock_inbalance_bug+0xfb/0x120
>  [<ffffffff8026db76>] ? mark_held_locks+0x56/0xa0
>  [<ffffffff802500ba>] ? try_to_del_timer_sync+0x5a/0x70
>  [<ffffffff8052ce23>] ? _spin_unlock_irqrestore+0x43/0x70
>  [<ffffffff8026f468>] lock_release_non_nested+0x1a8/0x2a0
>  [<ffffffff802500ba>] ? try_to_del_timer_sync+0x5a/0x70
>  [<ffffffff8052acb9>] ? mutex_unlock+0x9/0x10
>  [<ffffffff8026f61b>] lock_release+0xbb/0x200
>  [<ffffffff8052abc6>] __mutex_unlock_slowpath+0x86/0x170
>  [<ffffffff8052acb9>] mutex_unlock+0x9/0x10
>  [<ffffffffa019cf45>] e1000_release_swflag_ich8lan+0x35/0x40 [e1000e]
>  [<ffffffffa019de19>] e1000_reset_hw_ich8lan+0xa9/0x130 [e1000e]
>  [<ffffffffa01ab140>] e1000e_reset+0xf0/0x260 [e1000e]
>  [<ffffffff802500ea>] ? del_timer_sync+0x1a/0x30
>  [<ffffffffa01ab4d8>] e1000e_down+0x178/0x180 [e1000e]
>  [<ffffffffa01ad0b6>] e1000_close+0x26/0xd0 [e1000e]
>  [<ffffffff804a59b6>] dev_close+0x76/0xc0
>  [<ffffffff804a7bd6>] dev_change_flags+0x96/0x1e0
>  [<ffffffff804b1b4c>] do_setlink+0x2ac/0x440
>  [<ffffffff8052cd46>] ? _read_unlock+0x26/0x30
>  [<ffffffff804b1ded>] rtnl_setlink+0x10d/0x150
>  [<ffffffff8052aeb2>] ? mutex_lock_nested+0x1f2/0x300
>  [<ffffffff804b09ba>] ? rtnetlink_rcv+0x1a/0x40
>  [<ffffffff804b0b6d>] rtnetlink_rcv_msg+0x18d/0x240
>  [<ffffffff804b09e0>] ? rtnetlink_rcv_msg+0x0/0x240
>  [<ffffffff804bba29>] netlink_rcv_skb+0x89/0xb0
>  [<ffffffff804b09c9>] rtnetlink_rcv+0x29/0x40
>  [<ffffffff804bb74d>] netlink_unicast+0x2bd/0x2d0
>  [<ffffffff8049e3ee>] ? __alloc_skb+0x6e/0x150
>  [<ffffffff804bc6c4>] netlink_sendmsg+0x204/0x2f0
>  [<ffffffff80499ed8>] ? sock_def_readable+0x68/0x70
>  [<ffffffff80498077>] sock_sendmsg+0x107/0x130
>  [<ffffffff8025c690>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff80213853>] ? native_sched_clock+0x13/0x60
>  [<ffffffff802d60e6>] ? fget_light+0x106/0x110
>  [<ffffffff80497987>] ? move_addr_to_kernel+0x57/0x60
>  [<ffffffff804a087f>] ? verify_iovec+0x3f/0xe0
>  [<ffffffff80498229>] sys_sendmsg+0x189/0x320
>  [<ffffffff8049851d>] ? sys_sendto+0xfd/0x120
>  [<ffffffff802e6650>] ? d_free+0x50/0x60
>  [<ffffffff802d6691>] ? __fput+0x171/0x1e0
>  [<ffffffff8026dda3>] ? trace_hardirqs_on_caller+0x133/0x190
>  [<ffffffff8028e02f>] ? audit_syscall_entry+0x15f/0x190
>  [<ffffffff8052c906>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8020c57b>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
