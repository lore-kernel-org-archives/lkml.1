Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab0CKNqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:46:00 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45128 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab0CKNp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:45:59 -0500
Date: Thu, 11 Mar 2010 05:45:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
Message-ID: <20100311134556.GA6344@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <2375c9f91003110205v1d7f00bfk89472cb11bd985d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91003110205v1d7f00bfk89472cb11bd985d3@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 06:05:38PM +0800, Américo Wang wrote:
> Hello, Paul and Peter,
> 
> Attached is the lockdep warning that I triggered today.
> 
> I am not sure if this is a bug of rcu lockdep, because I am
> testing my patch when this occurred. However, in the backtrace,
> there is none of the functions that I touched, weird.
> 
> So, please help to check if this is a bug of rcu lockdep.

This sort of thing is caused by acquiring the same lock with softirq
(AKA BH) blocked and not, which can result in self-deadlock.

There was such a bug in the RCU lockdep stuff in -tip, but it has long
since been fixed.  If you were seeing that bug, rcu_do_batch() would
be on the stack, which it does not appear to be.

So does your patch involve the usbfs_mutex?  Or attempt to manipulate
vfs/fs state from withing networking softirq/BH context?

							Thanx, Paul

> Please Cc netdev when necessary.
> 
> Thanks much!

> Mar 11 17:11:22 dhcp-66-70-5 kernel: =================================
> Mar 11 17:11:22 dhcp-66-70-5 kernel: [ INFO: inconsistent lock state ]
> Mar 11 17:11:22 dhcp-66-70-5 kernel: 2.6.34-rc1 #58
> Mar 11 17:11:22 dhcp-66-70-5 kernel: ---------------------------------
> Mar 11 17:11:22 dhcp-66-70-5 kernel: inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> Mar 11 17:11:22 dhcp-66-70-5 kernel: swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  (usbfs_mutex){+.?...}, at: [<ffffffff8146419f>] netif_receive_skb+0xe7/0x819
> Mar 11 17:11:22 dhcp-66-70-5 kernel: {SOFTIRQ-ON-W} state was registered at:
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff810a6dc2>] __lock_acquire+0xaec/0xe55
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff810a9585>] lock_acquire+0x163/0x1aa
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff8154f5f9>] mutex_lock_nested+0x64/0x4e9
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff813e5ec5>] usbdev_open+0x115/0x4e9
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff8117af83>] chrdev_open+0x27a/0x2fe
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81172f98>] __dentry_open+0x2d4/0x4d2
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81174560>] nameidata_to_filp+0x58/0x7e
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff811858e9>] do_last+0x81b/0xa3d
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81187220>] do_filp_open+0x2ff/0x869
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81172b53>] do_sys_open+0x8c/0x187
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81172c96>] sys_open+0x27/0x30
> Mar 11 17:11:22 dhcp-66-70-5 kernel:   [<ffffffff81003a5b>] system_call_fastpath+0x16/0x1b
> Mar 11 17:11:22 dhcp-66-70-5 kernel: irq event stamp: 7135619
> Mar 11 17:11:22 dhcp-66-70-5 kernel: hardirqs last  enabled at (7135618): [<ffffffff8116c69f>] __kmalloc_node_track_caller+0x18d/0x256
> Mar 11 17:11:22 dhcp-66-70-5 kernel: hardirqs last disabled at (7135619): [<ffffffff8155220a>] _raw_spin_lock_irqsave+0x3f/0xe2
> Mar 11 17:11:22 dhcp-66-70-5 kernel: softirqs last  enabled at (7135604): [<ffffffff8106a9a8>] __do_softirq+0x334/0x35f
> Mar 11 17:11:22 dhcp-66-70-5 kernel: softirqs last disabled at (7135611): [<ffffffff8100498c>] call_softirq+0x1c/0x4c
> Mar 11 17:11:22 dhcp-66-70-5 kernel: 
> Mar 11 17:11:22 dhcp-66-70-5 kernel: other info that might help us debug this:
> Mar 11 17:11:22 dhcp-66-70-5 kernel: 2 locks held by swapper/0:
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81468baa>] net_rx_action+0xc9/0x40f
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  #1:  (&(&napi->poll_lock)->rlock){+.-...}, at: [<ffffffff81468c39>] net_rx_action+0x158/0x40f
> Mar 11 17:11:22 dhcp-66-70-5 kernel: 
> Mar 11 17:11:22 dhcp-66-70-5 kernel: stack backtrace:
> Mar 11 17:11:22 dhcp-66-70-5 kernel: Pid: 0, comm: swapper Not tainted 2.6.34-rc1 #58
> Mar 11 17:11:22 dhcp-66-70-5 kernel: Call Trace:
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  <IRQ>  [<ffffffff810a1985>] print_usage_bug+0x26b/0x283
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810a4486>] ? check_usage_forwards+0x0/0x141
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810a1e7d>] mark_lock+0x4e0/0x8ff
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810a6ce3>] __lock_acquire+0xa0d/0xe55
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810a9585>] lock_acquire+0x163/0x1aa
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8146419f>] ? netif_receive_skb+0xe7/0x819
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81552237>] _raw_spin_lock_irqsave+0x6c/0xe2
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8146419f>] ? netif_receive_skb+0xe7/0x819
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8146419f>] netif_receive_skb+0xe7/0x819
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff814649a8>] napi_skb_finish+0x37/0x6a
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81465118>] napi_gro_receive+0x44/0x50
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffffa01d8bdc>] tg3_poll_work+0x9c6/0xfab [tg3]
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810a7063>] ? __lock_acquire+0xd8d/0xe55
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffffa01d92bc>] tg3_poll+0xfb/0x322 [tg3]
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81468c95>] net_rx_action+0x1b4/0x40f
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81468baa>] ? net_rx_action+0xc9/0x40f
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8106a808>] __do_softirq+0x194/0x35f
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8100498c>] call_softirq+0x1c/0x4c
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81006d10>] do_softirq+0x8c/0x181
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8106a66b>] irq_exit+0xa5/0xae
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8155c2aa>] do_IRQ+0x10a/0x136
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81553453>] ret_from_intr+0x0/0xf
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  <EOI>  [<ffffffff81332544>] ? acpi_safe_halt+0x61/0x84
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8133253b>] ? acpi_safe_halt+0x58/0x84
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8133270e>] acpi_idle_enter_c1+0xd7/0x17b
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff815581b4>] ? __atomic_notifier_call_chain+0x92/0xa7
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8142960f>] ? ladder_select_state+0x42/0x23d
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81428439>] cpuidle_idle_call+0x104/0x1b4
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff810020df>] cpu_idle+0xfd/0x163
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8152cb36>] rest_init+0x13a/0x145
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff8152c9fc>] ? rest_init+0x0/0x145
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81c92702>] start_kernel+0x789/0x79d
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81c912f4>] x86_64_start_reservations+0x104/0x10f
> Mar 11 17:11:22 dhcp-66-70-5 kernel:  [<ffffffff81c914df>] x86_64_start_kernel+0x1e0/0x1ee

