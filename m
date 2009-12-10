Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZLJTdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZLJTdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbZLJTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:32:58 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40180 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbZLJTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:32:53 -0500
Date: Thu, 10 Dec 2009 11:32:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: kordex - <kordex@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/rcutree.c:1228
Message-ID: <20091210193258.GD6756@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091209140334.GB6812@linux.vnet.ibm.com> <8b8dd87a0912090657y2702ecd7x5f41beb3ab785ccf@mail.gmail.com> <20091209165304.GB6938@linux.vnet.ibm.com> <8b8dd87a0912090935s75de7011s905c3007311a6b6b@mail.gmail.com> <20091209183042.GD6938@linux.vnet.ibm.com> <8b8dd87a0912091036t3a3499c4p67be783252d80dc@mail.gmail.com> <20091209191807.GA16422@linux.vnet.ibm.com> <8b8dd87a0912091309m21b8e560pd68e47e7ec38f097@mail.gmail.com> <20091210024809.GJ6938@linux.vnet.ibm.com> <8b8dd87a0912100624t44e2025ak1b72eff3813ce514@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b8dd87a0912100624t44e2025ak1b72eff3813ce514@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:24:07PM +0200, kordex - wrote:
> Hey,
> 
> memtester under Linux runs fine if i don't tell it to test too much
> memory at one time: I have 512M installed and right after boot i can
> test as root 460M but if i increase it too much so like it would mlock
> 470M I get faults. The odd thing is that when running as unpriviledged
> user I get faults too but the program tells that it can't even get ram
> at all mlocked.
> 
> When running as unpriviledged (not root):
> 
> navi:~> memtester 470 1
> 
> Copyright (C) 2007 Charles Cazabon.
> Licensed under the GNU General Public License version 2 (only).
> 
> pagesize is 4096
> pagesizemask is 0xfffff000
> want 470MB (492830720 bytes)
> got  470MB (492830720 bytes), trying mlock ...too many pages, reducing...
> got  469MB (492826624 bytes), trying mlock ...too many pages, reducing...
> got  469MB (492822528 bytes), trying mlock ...too many pages, reducing...
> 
> ...
> 
> got  0MB (81920 bytes), trying mlock ...too many pages, reducing...
> got  0MB (77824 bytes), trying mlock ...too many pages, reducing...
> got  0MB (73728 bytes), trying mlock ...too many pages, reducing...
> got  0MB (69632 bytes), trying mlock ...too many pages, reducing...
> got  0MB (65536 bytes), trying mlock ...locked.
> Loop 1/1:
>   Stuck Address       : ok
>   Random Value        : ok
>   Compare XOR         : ok
>   Compare SUB         : ok
>   Compare MUL         : ok
>   Compare DIV         : ok
>   Compare OR          : ok
>   Compare AND         : ok
>   Sequential Increment: ok
>   Solid Bits          : ok
>   Block Sequential    : ok
>   Checkerboard        : ok
>   Bit Spread          : ok
>   Bit Flip            : ok
>   Walking Ones        : ok
>   Walking Zeroes      : ok
> 
> Done.
> navi:~>

OK, thank you for running this!

If you get a chance, could you please try Tiny RCU?  It is in current
mainline (after 2.6.32), or you can find the patch at:

	http://lkml.org/lkml/2009/10/25/147

							Thanx, Paul

> dmesg:
> 
> munin-update: page allocation failure. order:1, mode:0x20
> Call Trace:
> [d8f35a30] [c0008a24] show_stack+0x4c/0x14c (unreliable)
> [d8f35a70] [c005817c] __alloc_pages_nodemask+0x468/0x4b8
> [d8f35b00] [c0077470] cache_alloc_refill+0x2d8/0x55c
> [d8f35b50] [c0077858] kmem_cache_alloc+0x64/0xb0
> [d8f35b70] [c0486320] sk_prot_alloc+0x2c/0x78
> [d8f35b90] [c0486404] sk_clone+0x20/0x1b0
> [d8f35bb0] [c04bca98] inet_csk_clone+0x1c/0x8c
> [d8f35bc0] [c04d1380] tcp_create_openreq_child+0x20/0x2c4
> [d8f35be0] [c04d00c8] tcp_v4_syn_recv_sock+0x58/0x17c
> [d8f35c00] [c04d11ec] tcp_check_req+0x268/0x3dc
> [d8f35c40] [c04cf8a4] tcp_v4_do_rcv+0xa0/0x198
> [d8f35c70] [c04cfde0] tcp_v4_rcv+0x444/0x6d4
> [d8f35ca0] [c04b4530] ip_local_deliver+0x104/0x1d8
> [d8f35cc0] [c04b43f4] ip_rcv+0x508/0x540
> [d8f35cf0] [c04922a0] netif_receive_skb+0x390/0x3bc
> [d8f35d20] [c0492368] process_backlog+0x9c/0x134
> [d8f35d50] [c0492b68] net_rx_action+0x80/0x190
> [d8f35d80] [c0028e8c] __do_softirq+0xa4/0x120
> [d8f35dc0] [c0006a0c] do_softirq+0x40/0x58
> [d8f35dd0] [c0028db4] local_bh_enable+0x7c/0x9c
> [d8f35de0] [c04852ec] release_sock+0x94/0xa8
> [d8f35e00] [c04dcd70] inet_stream_connect+0x224/0x29c
> [d8f35e50] [c0482a78] sys_connect+0x78/0xa8
> [d8f35f00] [c04840ac] sys_socketcall+0xf0/0x240
> [d8f35f40] [c0013cf4] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfd51434
>     LR = 0xff66550
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:  186, btch:  31 usd:   9
> active_anon:5179 inactive_anon:4611 isolated_anon:0
>  active_file:5690 inactive_file:104841 isolated_file:0
>  unevictable:0 dirty:26 writeback:0 unstable:0
>  free:2044 slab_reclaimable:2732 slab_unreclaimable:866
>  mapped:4325 shmem:161 pagetables:357 bounce:0
> DMA free:8176kB min:2884kB low:3604kB high:4324kB active_anon:20716kB
> inactive_anon:18444kB active_file:22760kB inactive_file:419364kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB
> mlocked:0kB dirty:104kB writeback:0kB mapped:17300kB shmem:644kB
> slab_reclaimable:10928kB slab_unreclaimable:3464kB kernel_stack:912kB
> pagetables:1428kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> DMA: 2044*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 8176kB
> 110693 total pagecache pages
> 0 pages in swap cache
> Swap cache stats: add 0, delete 0, find 0/0
> Free swap  = 779144kB
> Total swap = 779144kB
> 131072 pages RAM
> 0 pages HighMem
> 3391 pages reserved
> 113688 pages shared
> 24092 pages non-shared
> munin-update: page allocation failure. order:1, mode:0x20
> Call Trace:
> [d62efa30] [c0008a24] show_stack+0x4c/0x14c (unreliable)
> [d62efa70] [c005817c] __alloc_pages_nodemask+0x468/0x4b8
> [d62efb00] [c0077470] cache_alloc_refill+0x2d8/0x55c
> [d62efb50] [c0077858] kmem_cache_alloc+0x64/0xb0
> [d62efb70] [c0486320] sk_prot_alloc+0x2c/0x78
> [d62efb90] [c0486404] sk_clone+0x20/0x1b0
> [d62efbb0] [c04bca98] inet_csk_clone+0x1c/0x8c
> [d62efbc0] [c04d1380] tcp_create_openreq_child+0x20/0x2c4
> [d62efbe0] [c04d00c8] tcp_v4_syn_recv_sock+0x58/0x17c
> [d62efc00] [c04d11ec] tcp_check_req+0x268/0x3dc
> [d62efc40] [c04cf8a4] tcp_v4_do_rcv+0xa0/0x198
> [d62efc70] [c04cfde0] tcp_v4_rcv+0x444/0x6d4
> [d62efca0] [c04b4530] ip_local_deliver+0x104/0x1d8
> [d62efcc0] [c04b43f4] ip_rcv+0x508/0x540
> [d62efcf0] [c04922a0] netif_receive_skb+0x390/0x3bc
> [d62efd20] [c0492368] process_backlog+0x9c/0x134
> [d62efd50] [c0492b68] net_rx_action+0x80/0x190
> [d62efd80] [c0028e8c] __do_softirq+0xa4/0x120
> [d62efdc0] [c0006a0c] do_softirq+0x40/0x58
> [d62efdd0] [c0028db4] local_bh_enable+0x7c/0x9c
> [d62efde0] [c04852ec] release_sock+0x94/0xa8
> [d62efe00] [c04dcd70] inet_stream_connect+0x224/0x29c
> [d62efe50] [c0482a78] sys_connect+0x78/0xa8
> [d62eff00] [c04840ac] sys_socketcall+0xf0/0x240
> [d62eff40] [c0013cf4] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfd51434
>     LR = 0xff66550
> Mem-Info:
> DMA per-cpu:
> CPU    0: hi:  186, btch:  31 usd: 152
> active_anon:5217 inactive_anon:5036 isolated_anon:0
>  active_file:7419 inactive_file:100929 isolated_file:0
>  unevictable:0 dirty:22 writeback:0 unstable:0
>  free:3562 slab_reclaimable:2788 slab_unreclaimable:873
>  mapped:4388 shmem:161 pagetables:358 bounce:0
> DMA free:14248kB min:2884kB low:3604kB high:4324kB active_anon:20868kB
> inactive_anon:20144kB active_file:29676kB inactive_file:403716kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:520192kB
> mlocked:0kB dirty:88kB writeback:0kB mapped:17552kB shmem:644kB
> slab_reclaimable:11152kB slab_unreclaimable:3492kB kernel_stack:896kB
> pagetables:1432kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> DMA: 3562*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
> 0*1024kB 0*2048kB 0*4096kB = 14248kB
> 108510 total pagecache pages
> 0 pages in swap cache
> Swap cache stats: add 0, delete 0, find 0/0
> Free swap  = 779144kB
> Total swap = 779144kB
> 131072 pages RAM
> 0 pages HighMem
> 3391 pages reserved
> 110176 pages shared
> 26054 pages non-shared
> 
> 
> Running as root:
> 
> navi:~# memtester 470 1
> memtester version 4.0.8 (32-bit)
> Copyright (C) 2007 Charles Cazabon.
> Licensed under the GNU General Public License version 2 (only).
> 
> pagesize is 4096
> pagesizemask is 0xfffff000
> want 470MB (492830720 bytes)
> got  470MB (492830720 bytes), trying mlock ...locked.
> Loop 1/1:
>   Stuck Address       : ok
>   Random Value        : ok
>   Compare XOR         : ok
>   Compare SUB         : ok
>   Compare MUL         : ok
>   Compare DIV         : ok
>   Compare OR          : ok
>   Compare AND         : ok
>   Sequential Increment: ok
> ^C (takes too much time)
> 
> Dmesg did not show anything new.
> 
> Running as root:
> 
> navi:~# memtester 490 1
> 
> Trying to mlock: I lost console access, I guess ssh server got oom killed.
> 
> Reconnecting. Machine responses very slowly, logon took some 10 seconds.
> 
> Dmesgs:
> 
> As user:
> http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.memtester.after.nonroot.txt
> As root  memtester 490 1
> http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.memtester.after.root.toomuch.txt
> 
> 
> --Mikko Kortelainen
> 
> 2009/12/10 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Wed, Dec 09, 2009 at 11:09:34PM +0200, kordex - wrote:
> >> No, I have not, is there a way to do that while the system is running?
> >
> > This depends on the motherboard and firmware -- and I must unfortunately
> > defer to others on this.  However, in my experience, you must usually
> > do this from firmware prompt.
> >
> >                                                        Thanx, Paul
> >
> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> > On Wed, Dec 09, 2009 at 08:36:33PM +0200, kordex - wrote:
> >> >> I will turn debugging options on after
> >> >> http://lkml.org/lkml/2009/12/9/44 gets traced down so I can do that.
> >> >
> >> > Hmmm...  You have recently run a memory test on your system, right?
> >> >
> >> >                                                        Thanx, Paul
> >> >
> >> >> --Mikko Kortelainen
> >> >>
> >> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> >> > In that case, the best thing would be to drop the warning into the
> >> >> > beginnings and ends of processing for system calls used by your workload.
> >> >> > The hope would be to find it triggering at the end of a given syscall,
> >> >> > permitting you to binary search the intervening code.
> >> >> >
> >> >> > Given that I cannot reproduce this, I cannot do much more than to offer
> >> >> > random hints.
> >> >> >
> >> >> >                                                        Thanx, Paul
> >> >> >
> >> >> > On Wed, Dec 09, 2009 at 07:35:44PM +0200, kordex - wrote:
> >> >> >> It did actually show the Badness after system had been running a long
> >> >> >> time. And this cut from it shows that system was fully done kernel
> >> >> >> init routines as there is ntpd running:
> >> >> >>
> >> >> >> warning: `ntpd' uses 32-bit capabilities (legacy support in use)
> >> >> >> ------------[ cut here ]------------
> >> >> >> Badness at kernel/rcutree.c:1228
> >> >> >> NIP: c004ecbc LR: c004f14c CTR: c007bd70
> >> >> >> REGS: df34dde0 TRAP: 0700   Not tainted  (2.6.32)
> >> >> >>
> >> >> >> --Mikko Kortelainen
> >> >> >>
> >> >> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> >> >> > Hmmm...  Didn't the first console output you sent me show the beenonline
> >> >> >> > WARN_ON_ONCE() triggering during late boot?  Yes, you had other failures
> >> >> >> > later, but it might be that whatever is triggering this warning is
> >> >> >> > related to those failures, right?
> >> >> >> >
> >> >> >> >                                                        Thanx, Paul
> >> >> >> >
> >> >> >> > On Wed, Dec 09, 2009 at 04:57:54PM +0200, kordex - wrote:
> >> >> >> >> Sorry but,
> >> >> >> >>
> >> >> >> >> Where actually this "down nearer to the point in the boot-up sequence"
> >> >> >> >> would be as I encountered the errors while the system was running (had
> >> >> >> >> been for days).
> >> >> >> >>
> >> >> >> >> --Mikko Kortelainen
> >> >> >> >>
> >> >> >> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> >> >> >> > On Wed, Dec 09, 2009 at 11:15:17AM +0200, kordex - wrote:
> >> >> >> >> >> Hey,
> >> >> >> >> >>
> >> >> >> >> >> I hope it's in the right place.
> >> >> >> >> >
> >> >> >> >> > Looks fine to me.
> >> >> >> >> >
> >> >> >> >> > And the fact that you did -not- see anything in your dmesg indicates
> >> >> >> >> > that the beenonline fields are set correctly at that point, as expected.
> >> >> >> >> > You will only see a complaint if the beenonline fields have been
> >> >> >> >> > corrupted.
> >> >> >> >> >
> >> >> >> >> > Please move them down nearer to the point in the boot-up sequence where
> >> >> >> >> > you were seeing the failure.  Please note that interrupts had been on
> >> >> >> >> > for one good long time when your original kernel complained, so there
> >> >> >> >> > had been a very large number of executions with beenonline set
> >> >> >> >> > correctly.
> >> >> >> >> >
> >> >> >> >> > So it will probably be faster to start at the original failure
> >> >> >> >> > and move towards boot rather than vice versa.
> >> >> >> >> >
> >> >> >> >> >                                                        Thanx, Paul
> >> >> >> >> >
> >> >> >> >> >> --Mikko Kortelainen
> >> >> >> >> >>
> >> >> >> >> >> navi:/usr/src# diff -Naur a/init/main.c b/init/main.c
> >> >> >> >> >> --- a/init/main.c       2009-12-03 05:51:21.000000000 +0200
> >> >> >> >> >> +++ b/init/main.c       2009-12-09 03:22:15.000000000 +0200
> >> >> >> >> >> @@ -81,6 +81,9 @@
> >> >> >> >> >>  #include <asm/smp.h>
> >> >> >> >> >>  #endif
> >> >> >> >> >>
> >> >> >> >> >> +/* DEBUG STATEMENT 2009/12/08 */
> >> >> >> >> >> +#include <linux/rcutree.h>
> >> >> >> >> >> +
> >> >> >> >> >>  static int kernel_init(void *);
> >> >> >> >> >>
> >> >> >> >> >>  extern void init_IRQ(void);
> >> >> >> >> >> @@ -589,6 +592,10 @@
> >> >> >> >> >>                 local_irq_disable();
> >> >> >> >> >>         }
> >> >> >> >> >>         rcu_init();
> >> >> >> >> >> +
> >> >> >> >> >> +       /* DEBUG STATEMENT 2009/12/08 */
> >> >> >> >> >> +       WARN_ON_ONCE(rcu_check_beenonline());
> >> >> >> >> >> +
> >> >> >> >> >>         /* init some links before init_ISA_irqs() */
> >> >> >> >> >>         early_irq_init();
> >> >> >> >> >>         init_IRQ();
> >> >> >> >> >>
> >> >> >> >> >>
> >> >> >> >> >>
> >> >> >> >> >> 2009/12/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> >> >> >> >> > On Wed, Dec 09, 2009 at 03:41:00AM +0200, kordex - wrote:
> >> >> >> >> >> >> Hey,
> >> >> >> >> >> >>
> >> >> >> >> >> >> I put the debug function under init/main.c after rcu_init(); but there
> >> >> >> >> >> >> is no output on dmesg which means that it receives zero value.
> >> >> >> >> >> >>
> >> >> >> >> >> >> Full dmesg: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.dmesg.rcu-init.txt
> >> >> >> >> >> >
> >> >> >> >> >> > Could you please send the patch you applied to, as you said, put the
> >> >> >> >> >> > debug function under init/main.c after rcu_init()?
> >> >> >> >> >> >
> >> >> >> >> >> >                                                        Thanx, Paul
> >> >> >> >> >> >
> >> >> >> >> >> >> --Mikko Kortelainen
> >> >> >> >> >> >>
> >> >> >> >> >> >> 2009/12/8 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> >> >> >> >> >> > On Tue, Dec 08, 2009 at 11:22:07AM -0800, Paul E. McKenney wrote:
> >> >> >> >> >> >> >> At this point, I must defer to those more skilled than I at diagnosing
> >> >> >> >> >> >> >> early-boot problems.
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > Well, that is silly on my part -- the problem seems to appear late in
> >> >> >> >> >> >> > boot, and you had no problem capturing that portion of the boot log.
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > So please see below for a patch providing a rcu_check_beenonline()
> >> >> >> >> >> >> > function that, when called after rcu_init(), returns non-zero if the
> >> >> >> >> >> >> > beenonline fields have become corrupted.  So put calls of the form:
> >> >> >> >> >> >> >
> >> >> >> >> >> >> >        WARN_ON_ONCE(rcu_check_beenonline());
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > in the initialization code path preceding the problem.  Either #include
> >> >> >> >> >> >> > rcupdate.h or explicitly declare the function as appropriate.
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> >> >> >> >> >> > ---
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> >> >> >> >> >> >> > index 9642c6b..190a687 100644
> >> >> >> >> >> >> > --- a/include/linux/rcutree.h
> >> >> >> >> >> >> > +++ b/include/linux/rcutree.h
> >> >> >> >> >> >> > @@ -39,6 +39,8 @@ extern int rcu_cpu_notify(struct notifier_block *self,
> >> >> >> >> >> >> >  extern int rcu_needs_cpu(int cpu);
> >> >> >> >> >> >> >  extern int rcu_expedited_torture_stats(char *page);
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > +extern int rcu_check_beenonline(void);
> >> >> >> >> >> >> > +
> >> >> >> >> >> >> >  #ifdef CONFIG_TREE_PREEMPT_RCU
> >> >> >> >> >> >> >
> >> >> >> >> >> >> >  extern void __rcu_read_lock(void);
> >> >> >> >> >> >> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> >> >> >> >> >> >> > index 207125b..27d3722 100644
> >> >> >> >> >> >> > --- a/kernel/rcutree.c
> >> >> >> >> >> >> > +++ b/kernel/rcutree.c
> >> >> >> >> >> >> > @@ -77,6 +77,17 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
> >> >> >> >> >> >> >  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
> >> >> >> >> >> >> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> >> >> >> >> >> >> >
> >> >> >> >> >> >> > +/*
> >> >> >> >> >> >> > + * Ad-hoc diagnostic function, for use only after rcu_init() has
> >> >> >> >> >> >> > + * returned.  Assumes that the boot CPU is CPU 0.  Assumes that
> >> >> >> >> >> >> > + * the kernel has been built with CONFIG_TREE_RCU.  Not for inclusion.
> >> >> >> >> >> >> > + * Usage: "WARN_ON_ONCE(rcu_check_beenonline());"
> >> >> >> >> >> >> > + */
> >> >> >> >> >> >> > +int rcu_check_beenonline(void)
> >> >> >> >> >> >> > +{
> >> >> >> >> >> >> > +       return !per_cpu(rcu_sched_data, 0).beenonline ||
> >> >> >> >> >> >> > +              !per_cpu(rcu_bh_data, 0).beenonline;
> >> >> >> >> >> >> > +}
> >> >> >> >> >> >> >
> >> >> >> >> >> >> >  /*
> >> >> >> >> >> >> >  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
> >> >> >> >> >> >> >
> >> >> >> >> >> >
> >> >> >> >> >
> >> >> >> >
> >> >> >
> >> >
> >
