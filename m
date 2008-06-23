Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYFWNFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYFWNFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYFWNFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:05:46 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52020 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYFWNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:05:46 -0400
Date: Mon, 23 Jun 2008 06:05:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ryan Hope <rmh3093@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Message-ID: <20080623130536.GA10595@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <200806231229.42943.nickpiggin@yahoo.com.au> <48f7fe350806222051g15edcd98g6faecc4a23f727ab@mail.gmail.com> <200806232154.52820.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806232154.52820.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 09:54:52PM +1000, Nick Piggin wrote:
> On Monday 23 June 2008 13:51, Ryan Hope wrote:
> > well i get the hardlock on -mm with out using reiser4, i am pretty
> > sure is swap related
> 
> The guys seeing hangs don't use PREEMPT_RCU, do they?
> 
> In my swapping tests, I found -mm3 to be stable with classic RCU, but
> on a hunch, I tried PREEMPT_RCU and it crashed a couple of times rather
> quickly. First crash was in find_get_pages so I suspected lockless
> pagecache doing something subtly wrong with the RCU API, but I just got
> another crash in __d_lookup:

Could you please send me a repeat-by?  (At least Alexey is no longer
alone!)

						Thanx, Paul

> BUG: unable to handle kernel paging request at ffff81004a139f38
> IP: [<ffffffff802bb82c>] __d_lookup+0x8c/0x160
> PGD 8063 PUD 7fc3f163 PMD 7df50163 PTE 800000004a139160
> Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> CPU 0
> Modules linked in: brd
> Pid: 29563, comm: cc1 Not tainted 2.6.26-rc5-mm3 #467
> RIP: 0010:[<ffffffff802bb82c>]  [<ffffffff802bb82c>] __d_lookup+0x8c/0x160
> RSP: 0018:ffff81004bf7dba8  EFLAGS: 00010282
> RAX: 0000000000000007 RBX: ffff81004a139f38 RCX: 0000000000000000
> RDX: ffff810028057808 RSI: 0000000000000000 RDI: ffff81004bf7a880
> RBP: ffff81004bf7dbf8 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff81004a139ef8
> R13: 0000000073885cf7 R14: ffff810070f53ef8 R15: ffff81004bf7dca8
> FS:  00002abe0a1decf0(0000) GS:ffffffff80779dc0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff81004a139f38 CR3: 0000000057569000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process cc1 (pid: 29563, threadinfo ffff81004bf7c000, task ffff81004bf7a880)
> Stack:  0000000100000001 0000000000000007 ffff810070f53f00 00000007000041ed
>  ffff810001ce2013 ffff81004bf7dca8 00000000000041ed ffff81004bf7de48
>  ffff81004bf7dca8 ffff81004bf7dcb8 ffff81004bf7dc48 ffffffff802af2b5
> Call Trace:
>  [<ffffffff802af2b5>] do_lookup+0x35/0x230
>  [<ffffffff80312d60>] ? ext3_permission+0x10/0x20
>  [<ffffffff802b0cbb>] __link_path_walk+0x39b/0x10a0
>  [<ffffffff802b1a26>] path_walk+0x66/0xd0
>  [<ffffffff802b1cde>] do_path_lookup+0x9e/0x240
>  [<ffffffff802b21d7>] __path_lookup_intent_open+0x67/0xd0
>  [<ffffffff802b224c>] path_lookup_open+0xc/0x10
>  [<ffffffff802b31ba>] do_filp_open+0xaa/0x9f0
>  [<ffffffff805445f0>] ? _spin_unlock+0x30/0x60
>  [<ffffffff802a467d>] ? get_unused_fd_flags+0xed/0x140
>  [<ffffffff802a4746>] do_sys_open+0x76/0x100
>  [<ffffffff802a47fb>] sys_open+0x1b/0x20
>  [<ffffffff8020b90b>] system_call_after_swapgs+0x7b/0x80
> 
> This path is completely independent of the pagecache, but it does
> also use RCU, so I suspect PREEMPT_RCU is freeing things before
> the proper grace period. These are showing up as oopses for me
> because I have DEBUG_PAGEALLOC set, but if you don't have that set
> then you'll get much more subtle corruption.
> 
> Here is the find_get_pages bug FYI:
> BUG: unable to handle kernel paging request at ffff8100c7997de0
> IP: [<ffffffff802732ee>] find_get_pages+0xce/0x130
> PGD 8063 PUD 7fa6e163 PMD cfa64163 PTE 80000000c7997163
> Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> CPU 0
> Modules linked in: brd
> Pid: 446, comm: kswapd0 Not tainted 2.6.26-rc5-mm3 #465
> RIP: 0010:[<ffffffff802732ee>]  [<ffffffff802732ee>] find_get_pages+0xce/0x130
> RSP: 0000:ffff81007e4cbbf0  EFLAGS: 00010246
> RAX: ffff8100c7997de0 RBX: ffff81007e4cbc90 RCX: 0000000000000001
> RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffe2000447f080
> RBP: ffff81007e4cbc30 R08: ffffe2000447f088 R09: 0000000000000004
> R10: 0000000000000040 R11: 0000000000000040 R12: 0000000000000000
> R13: ffff81007e4cbc90 R14: ffff8100c7996e18 R15: 0000000000000000
> 240 97   7184  1FS:  00002b774a14ccf0(0000) GS:ffffffff807e5dc0(0000) 
> knlGS:0000
> 000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> 2204  25364 4164CR2: ffff8100c7997de0 CR3: 0000000000201000 CR4: 
> 00000000000006e
> 0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 88    0    8    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 000000000000040
> 0
> Process kswapd0 (pid: 446, threadinfo ffff81007e4ca000, task ffff81007e4d2a00)
>  ffff81007e4cbcb0 0000000e00000000000000437 65 35  0  0
>                                    ffff81007e4cbc80
>  0000000000000080 0000000000000052 0000000000000000 ffffffffffffffff
>  ffff81007e4cbc50 ffffffff8027dcdf 0000000000000000 ffff8100c7996c28
> Call Trace:
>  [<ffffffff8027dcdf>] pagevec_lookup+0x1f/0x30
>  [<ffffffff8027ef43>] __invalidate_mapping_pages+0x83/0x1b0
>  [<ffffffff8027f07b>] invalidate_mapping_pages+0xb/0x10
>  [<ffffffff802be2a3>] shrink_icache_memory+0x293/0x2a0
>  [<ffffffff80281632>] ? shrink_slab+0x32/0x220
>  [<ffffffff8028172d>] shrink_slab+0x12d/0x220
>  [<ffffffff8028202a>] kswapd+0x53a/0x670
>  [<ffffffff8027f830>] ? isolate_pages_global+0x0/0x280
>  [<ffffffff805a1ada>] ? thread_return+0xa6/0x3bc
>  [<ffffffff802513f0>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff80281af0>] ? kswapd+0x0/0x670
>  [<ffffffff80251059>] kthread+0x49/0x80
>  [<ffffffff8020c878>] child_rip+0xa/0x12
>  [<ffffffff8020bf63>] ? restore_args+0x0/0x30
>  [<ffffffff80251010>] ? kthread+0x0/0x80
>  [<ffffffff8020c86e>] ? child_rip+0x0/0x12
> 
> If you're not using PREEMPT_RCU, then I'm stumped for the moment. You'll
> have to send .configs over...
> 
