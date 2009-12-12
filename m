Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbZLLJkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbZLLJkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 04:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761377AbZLLJkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 04:40:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760840AbZLLJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 04:40:05 -0500
Date: Sat, 12 Dec 2009 01:39:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-Id: <20091212013927.58d386d1.akpm@linux-foundation.org>
In-Reply-To: <20091212084611.GA28266@elte.hu>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 09:46:11 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Greg KH <gregkh@suse.de> wrote:
> 
> > Here's the big TTY patchset for your .33-git tree.
> 
> FYI, one of the changes in this tree is causing lockups on x86.
> 
> Config attached.
> 
> Possible suspects would one of these:
> 
>  36ba782: tty: split the lock up a bit further
>  5ec93d1: tty: Move the leader test in disassociate
>  38c70b2: tty: Push the bkl down a bit in the hangup code
>  f18f949: tty: Push the lock down further into the ldisc code
>  eeb89d9: tty: push the BKL down into the handlers a bit
> 
> as they deal with locking details and are fresher than two weeks.

yes, I started getting lockups yesterday when all this hit linux-next.
Seems to be quite .config-dependent.

I get all-cpu backtraces which show all eight CPUs stuck on either
lock_kernel() or files_lock().  It appears that both locks are held.

The do_tty_hangup()->tty_fasync() path takes the locks in the
file_list_lock()->lock_kernel() direction whereas most other code takes
them in the other direction, which cannot be good.  But I'm not sure
that this recent merge significantly changed anything in that area. 
Enabling lockdep makes the hang go away.

Have a trace.  I'm actually wondering if perhaps there's a missing
unlock_kernel() somewhere else, and the tty code is just the victim of
that.

(hm, this trace only showed 6 CPUs.  It's a bit of a mess)

[   72.525902] INFO: RCU detected CPU 0 stall (t=2500 jiffies)
[   72.525969] NMI backtrace for cpu 4
[   72.526024] CPU 4 
[   72.526154] Process irqbalance (pid: 3152, threadinfo ffff88025d86e000, task ffff880256fac040)
[   72.526209] Stack:
[   72.526255]  0000000000000000 ffff88025d86fd08 ffffffff811a12f5 ffff88025d86fd38
[   72.526434] <0> ffffffff811a572f ffff88025f0a2910 ffff88024a85c4c0 0000000000000000
[   72.526698] <0> ffff88024a63f698 ffff88025d86fd48 ffffffff81383af9 ffff88025d86fd68
[   72.527005] Call Trace:
[   72.527057]  [<ffffffff811a12f5>] __delay+0xa/0xc
[   72.527112]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527165]  [<ffffffff81383af9>] _spin_lock+0x9/0xb
[   72.527220]  [<ffffffff810ce929>] file_move+0x1e/0x4d
[   72.527247]  [<ffffffff810cd033>] __dentry_open+0x17e/0x2ef
[   72.527247]  [<ffffffff810cd26e>] nameidata_to_filp+0x3e/0x4f
[   72.527247]  [<ffffffff810d8bd5>] do_filp_open+0x529/0x972
[   72.527247]  [<ffffffff8105935b>] ? hrtimer_cancel+0x11/0x1d
[   72.527247]  [<ffffffff811a1fa3>] ? __strncpy_from_user+0x2b/0x55
[   72.527247]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527247]  [<ffffffff810e2520>] ? alloc_fd+0x111/0x121
[   72.527247]  [<ffffffff810cc77d>] do_sys_open+0x5c/0x123
[   72.527247]  [<ffffffff810cc86d>] sys_open+0x1b/0x1d
[   72.527247]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
[   72.527247] Code: 02 98 00 00 00 3e 48 89 c8 f7 e2 48 8d 7a 01 e8 b8 ff ff ff c9 c3 55 48 89 e5 50 65 8b 34 25 b0 cd 00 00 66 66 90 0f ae e8 0f 31 <41> 89 c0 66 66 90 0f ae e8 0f 31 89 c0 4c 29 c0 48 39 f8 73 20 
[   72.527247] Call Trace:
[   72.527247]  <#DB[1]>  <<EOE>> Pid: 3152, comm: irqbalance Not tainted 2.6.32-mm1 #8
[   72.527247] Call Trace:
[   72.527247]  <NMI>  [<ffffffff81001098>] ? show_regs+0x23/0x27
[   72.527247]  [<ffffffff81385175>] nmi_watchdog_tick+0xc9/0x1ad
[   72.527247]  [<ffffffff813846b0>] do_nmi+0xa7/0x256
[   72.527247]  [<ffffffff8138433a>] nmi+0x1a/0x20
[   72.527247]  [<ffffffff811a134a>] ? delay_tsc+0x15/0x4c
[   72.527247]  <<EOE>>  [<ffffffff811a12f5>] __delay+0xa/0xc
[   72.527247]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527247]  [<ffffffff81383af9>] _spin_lock+0x9/0xb
[   72.527247]  [<ffffffff810ce929>] file_move+0x1e/0x4d
[   72.527247]  [<ffffffff810cd033>] __dentry_open+0x17e/0x2ef
[   72.527247]  [<ffffffff810cd26e>] nameidata_to_filp+0x3e/0x4f
[   72.527247]  [<ffffffff810d8bd5>] do_filp_open+0x529/0x972
[   72.527247]  [<ffffffff8105935b>] ? hrtimer_cancel+0x11/0x1d
[   72.527247]  [<ffffffff811a1fa3>] ? __strncpy_from_user+0x2b/0x55
[   72.527247]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527247]  [<ffffffff810e2520>] ? alloc_fd+0x111/0x121
[   72.527247]  [<ffffffff810cc77d>] do_sys_open+0x5c/0x123
[   72.527247]  [<ffffffff810cc86d>] sys_open+0x1b/0x1d
[   72.527247]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
[   72.527230] NMI backtrace for cpu 6
[   72.527230] CPU 6 
[   72.527230] Process mingetty (pid: 4105, threadinfo ffff88024aac4000, task ffff880256e2f810)
[   72.527230] Stack:
[   72.527230]  ffffffff811a12f5 ffff88024aac5dc8 ffffffff811a572f 00007ffffbf94690
[   72.527230] <0> 0000000000000000 000000000000033a ffffffff814ef5d0 ffff88024aac5e08
[   72.527230] <0> ffffffff81383e0a ffff88025d5a3bc0 00007ffffbf94690 ffff88025d5a3bc0
[   72.527230] Call Trace:
[   72.527230]  [<ffffffff811a12f5>] ? __delay+0xa/0xc
[   72.527230]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527230]  [<ffffffff81383e0a>] _lock_kernel+0x63/0x7c
[   72.527230]  [<ffffffff81101396>] __posix_lock_file+0x79/0x40e
[   72.527230]  [<ffffffff811018bf>] posix_lock_file+0x11/0x13
[   72.527230]  [<ffffffff811018ec>] vfs_lock_file+0x2b/0x2d
[   72.527230]  [<ffffffff81101ad4>] fcntl_setlk+0x139/0x278
[   72.527230]  [<ffffffff810da34c>] sys_fcntl+0x2ef/0x4a7
[   72.527230]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
[   72.527230] Code: 48 8b 04 c5 60 85 86 81 48 c7 c2 c0 31 01 00 48 89 e5 48 6b 94 02 98 00 00 00 3e 48 89 c8 f7 e2 48 8d 7a 01 e8 b8 ff ff ff c9 c3 <55> 48 89 e5 50 65 8b 34 25 b0 cd 00 00 66 66 90 0f ae e8 0f 31 
[   72.527230] Call Trace:
[   72.527230]  <#DB[1]>  <<EOE>> Pid: 4105, comm: mingetty Not tainted 2.6.32-mm1 #8
[   72.527230] Call Trace:
[   72.527230]  <NMI>  [<ffffffff81001098>] ? show_regs+0x23/0x27
[   72.527230]  [<ffffffff81385175>] nmi_watchdog_tick+0xc9/0x1ad
[   72.527230]  [<ffffffff813846b0>] do_nmi+0xa7/0x256
[   72.527230]  [<ffffffff8138433a>] nmi+0x1a/0x20
[   72.527230]  [<ffffffff811a1335>] ? delay_tsc+0x0/0x4c
[   72.527230]  <<EOE>>  [<ffffffff811a12f5>] ? __delay+0xa/0xc
[   72.527230]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527230]  [<ffffffff81383e0a>] _lock_kernel+0x63/0x7c
[   72.527230]  [<ffffffff81101396>] __posix_lock_file+0x79/0x40e
[   72.527230]  [<ffffffff811018bf>] posix_lock_file+0x11/0x13
[   72.527230]  [<ffffffff811018ec>] vfs_lock_file+0x2b/0x2d
[   72.527230]  [<ffffffff81101ad4>] fcntl_setlk+0x139/0x278
[   72.527230]  [<ffffffff810da34c>] sys_fcntl+0x2ef/0x4a7
[   72.527230]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
[   72.527211] NMI backtrace for cpu 1
[   72.527230] INFO: RCU detected CPU 6 stall (t=2500 jiffies)
[   72.527211] CPU 1 
[   72.527211] Process hald-addon-stor (pid: 3999, threadinfo ffff88025235c000, task ffff880256e2a080)
[   72.527211] Stack:
[   72.527211]  0000000000000000 ffff88025235dd08 ffffffff811a12f5 ffff88025235dd38
[   72.527211] <0> ffffffff811a572f ffff88025d47ad10 ffff88025d4fd7c0 0000000000000000
[   72.527211] <0> ffff8802583c78d0 ffff88025235dd48 ffffffff81383af9 ffff88025235dd68
[   72.527211] Call Trace:
[   72.527211]  [<ffffffff811a12f5>] __delay+0xa/0xc
[   72.527211]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527211]  [<ffffffff81383af9>] _spin_lock+0x9/0xb
[   72.527211]  [<ffffffff810ce929>] file_move+0x1e/0x4d
[   72.527211]  [<ffffffff810cd033>] __dentry_open+0x17e/0x2ef
[   72.527211]  [<ffffffff810cd26e>] nameidata_to_filp+0x3e/0x4f
[   72.527211]  [<ffffffff810d8bd5>] do_filp_open+0x529/0x972
[   72.527211]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527211]  [<ffffffff811a1fa3>] ? __strncpy_from_user+0x2b/0x55
[   72.527211]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527211]  [<ffffffff810e2520>] ? alloc_fd+0x111/0x121
[   72.527211]  [<ffffffff810cc77d>] do_sys_open+0x5c/0x123
[   72.527211]  [<ffffffff810cc86d>] sys_open+0x1b/0x1d
[   72.527211]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
[   72.527211] Code: 7a 01 e8 b8 ff ff ff c9 c3 55 48 89 e5 50 65 8b 34 25 b0 cd 00 00 66 66 90 0f ae e8 0f 31 41 89 c0 66 66 90 0f ae e8 0f 31 89 c0 <4c> 29 c0 48 39 f8 73 20 f3 90 65 8b 0c 25 b0 cd 00 00 39 ce 74 
[   72.527211] Call Trace:
[   72.527211]  <#DB[1]>  <<EOE>> Pid: 3999, comm: hald-addon-stor Not tainted 2.6.32-mm1 #8
[   72.527211] Call Trace:
[   72.527211]  <NMI>  [<ffffffff81001098>] ? show_regs+0x23/0x27
[   72.527211]  [<ffffffff81385175>] nmi_watchdog_tick+0xc9/0x1ad
[   72.527211]  [<ffffffff813846b0>] do_nmi+0xa7/0x256
[   72.527211]  [<ffffffff8138433a>] nmi+0x1a/0x20
[   72.527211]  [<ffffffff811a1357>] ? delay_tsc+0x22/0x4c
[   72.527211]  <<EOE>>  [<ffffffff811a12f5>] __delay+0xa/0xc
[   72.527211]  [<ffffffff811a572f>] _raw_spin_lock+0xbc/0x125
[   72.527211]  [<ffffffff81383af9>] _spin_lock+0x9/0xb
[   72.527211]  [<ffffffff810ce929>] file_move+0x1e/0x4d
[   72.527211]  [<ffffffff810cd033>] __dentry_open+0x17e/0x2ef
[   72.527211]  [<ffffffff810cd26e>] nameidata_to_filp+0x3e/0x4f
[   72.527211]  [<ffffffff810d8bd5>] do_filp_open+0x529/0x972
[   72.527211]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527211]  [<ffffffff811a1fa3>] ? __strncpy_from_user+0x2b/0x55
[   72.527211]  [<ffffffff81383b04>] ? _spin_unlock+0x9/0xb
[   72.527211]  [<ffffffff810e2520>] ? alloc_fd+0x111/0x121
[   72.527211]  [<ffffffff810cc77d>] do_sys_open+0x5c/0x123
[   72.527211]  [<ffffffff810cc86d>] sys_open+0x1b/0x1d
[   72.527211]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b


