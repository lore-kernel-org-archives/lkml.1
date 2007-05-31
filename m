Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXEaRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXEaRxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbXEaRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:53:26 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:2111 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbXEaRxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=PQYhDRGHn6grf69V7OltSTLOv9YeaN+7ppPu7fd0i6EOZ1bpeIHWFYWYRamf6eFxS4a0qOrg4coVtykCoBik0+lJcX16ds8Za3zUaFJcec6BO/AzwAIA+kALXALnDJy2odWK7eGLhWG5Gxq0vA0YZevX81/fcgAVlgC8gwPERCE=
Message-ID: <465F0B83.2050100@googlemail.com>
Date: Thu, 31 May 2007 19:53:07 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> 

CPU hotplug test triggered this

[ 4972.038008] CPU 1 is now offline
[ 4972.041411] lockdep: not fixing up alternatives.
[ 4972.051553] 
[ 4972.051555] =================================
[ 4972.057562] [ INFO: inconsistent lock state ]
[ 4972.062056] 2.6.22-rc3-mm1 #10
[ 4972.065184] ---------------------------------
[ 4972.069663] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[ 4972.075758] sh/702 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4972.080554]  (&n->list_lock){++..}, at: [<c0181288>] add_partial+0xe/0x27

l *0xc0181288
0xc0181288 is in add_partial (/home/devel/linux-mm/mm/slub.c:1193).
1188    }
1189
1190    static void add_partial(struct kmem_cache_node *n, struct page *page)
1191    {
1192            spin_lock(&n->list_lock);
1193            n->nr_partial++;
1194            list_add(&page->lru, &n->partial);
1195            spin_unlock(&n->list_lock);
1196    }
1197


[ 4972.087650] {in-hardirq-W} state was registered at:
[ 4972.092656]   [<c0143bfe>] mark_lock+0x82/0x557
[ 4972.097323]   [<c0144c5f>] __lock_acquire+0x476/0xd36
[ 4972.102562]   [<c01455bd>] lock_acquire+0x9e/0xb8
[ 4972.107342]   [<c0348993>] _spin_lock+0x38/0x62
[ 4972.111993]   [<c0181d29>] deactivate_slab+0xb9/0x179
[ 4972.117300]   [<c0181e56>] flush_slab+0x6d/0x72
[ 4972.122063]   [<c0181e8c>] __flush_cpu_slab+0x31/0x36
[ 4972.127335]   [<c0181ea5>] flush_cpu_slab+0x14/0x17
[ 4972.132401]   [<c0113d6f>] smp_call_function_interrupt+0x3a/0x56
[ 4972.138607]   [<c0104c73>] call_function_interrupt+0x33/0x38
[ 4972.144503]   [<c0102b59>] default_idle+0x50/0x69
[ 4972.149421]   [<c01023eb>] cpu_idle+0xb3/0xf8
[ 4972.153889]   [<c03454fa>] rest_init+0x56/0x58
[ 4972.158402]   [<c04f39c7>] start_kernel+0x351/0x359
[ 4972.163450]   [<ffffffff>] 0xffffffff
[ 4972.167221] irq event stamp: 2451
[ 4972.170695] hardirqs last  enabled at (2451): [<c0104228>] restore_nocheck+0x12/0x15
[ 4972.178699] hardirqs last disabled at (2449): [<c012b4e9>] __do_softirq+0x93/0xe5
[ 4972.186393] softirqs last  enabled at (2450): [<c012b535>] __do_softirq+0xdf/0xe5
[ 4972.194216] softirqs last disabled at (2443): [<c0106d39>] do_softirq+0x68/0x11f

l *0xc0104228
0xc0104228 is at include2/asm/bitops.h:246.
241     static int test_bit(int nr, const volatile void * addr);
242     #endif
243
244     static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
245     {
246             return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
247     }
248
249     static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
250     {

l *0xc012b4e9
0xc012b4e9 is in __do_softirq (/home/devel/linux-mm/kernel/softirq.c:241).
236                     pending >>= 1;
237             } while (pending);
238
239             local_irq_disable();
240
241             pending = local_softirq_pending();
242             if (pending && --max_restart)
243                     goto restart;
244
245             if (pending)

l *0xc012b535
0xc012b535 is in __do_softirq (/home/devel/linux-mm/kernel/softirq.c:252).
247
248             trace_softirq_exit();
249
250             account_system_vtime(current);
251             _local_bh_enable();
252     }
253
254     #ifndef __ARCH_HAS_DO_SOFTIRQ
255
256     asmlinkage void do_softirq(void)

l *0xc0106d39
0xc0106d39 is in do_softirq (/home/devel/linux-mm/arch/i386/kernel/irq.c:222).
217                     irqctx->tinfo.previous_esp = current_stack_pointer;
218
219                     /* build the stack frame on the softirq stack */
220                     isp = (u32*) ((char*)irqctx + sizeof(*irqctx));
221
222                     asm volatile(
223                             "       xchgl   %%ebx,%%esp     \n"
224                             "       call    __do_softirq    \n"
225                             "       movl    %%ebx,%%esp     \n"
226                             : "=b"(isp)


[ 4972.201901] 
[ 4972.201902] other info that might help us debug this:
[ 4972.208669] 4 locks held by sh/702:
[ 4972.212265]  #0:  (cpu_add_remove_lock){--..}, at: [<c0347499>] mutex_lock+0x1c/0x1f
[ 4972.220304]  #1:  (sched_hotcpu_mutex){--..}, at: [<c0347499>] mutex_lock+0x1c/0x1f
[ 4972.228273]  #2:  (workqueue_mutex){--..}, at: [<c0347499>] mutex_lock+0x1c/0x1f
[ 4972.235821]  #3:  (slub_lock){----}, at: [<c01836d6>] slab_cpuup_callback+0x26/0x5b

l *0xc0347499
0xc0347499 is in mutex_lock (/home/devel/linux-mm/kernel/mutex.c:92).
87              /*
88               * The locking fastpath is the 1->0 transition from
89               * 'unlocked' into 'locked' state.
90               */
91              __mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
92      }
93
94      EXPORT_SYMBOL(mutex_lock);
95
96      static void fastcall noinline __sched

l *0xc01836d6
0xc01836d6 is in slab_cpuup_callback (/home/devel/linux-mm/mm/slub.c:2656).
2651    static void for_all_slabs(void (*func)(struct kmem_cache *, int), int cpu)
2652    {
2653            struct list_head *h;
2654
2655            down_read(&slub_lock);
2656            list_for_each(h, &slab_caches) {
2657                    struct kmem_cache *s =
2658                            container_of(h, struct kmem_cache, list);
2659
2660                    func(s, cpu);


[ 4972.243670] 
[ 4972.243670] stack backtrace:
[ 4972.248166]  [<c0105281>] dump_trace+0x63/0x1eb
[ 4972.252755]  [<c0105423>] show_trace_log_lvl+0x1a/0x2f
[ 4972.257969]  [<c0106061>] show_trace+0x12/0x14
[ 4972.262463]  [<c0106079>] dump_stack+0x16/0x18
[ 4972.266974]  [<c0142ff8>] print_usage_bug+0x140/0x14a
[ 4972.272109]  [<c0143e1a>] mark_lock+0x29e/0x557
[ 4972.276708]  [<c0144cda>] __lock_acquire+0x4f1/0xd36
[ 4972.281740]  [<c01455bd>] lock_acquire+0x9e/0xb8
[ 4972.286416]  [<c0348993>] _spin_lock+0x38/0x62
[ 4972.290936]  [<c0181288>] add_partial+0xe/0x27
[ 4972.295458]  [<c0181cd7>] deactivate_slab+0x67/0x179
[ 4972.300497]  [<c0181e56>] flush_slab+0x6d/0x72
[ 4972.305018]  [<c0181e8c>] __flush_cpu_slab+0x31/0x36
[ 4972.310049]  [<c01836e8>] slab_cpuup_callback+0x38/0x5b
[ 4972.315348]  [<c01325d2>] notifier_call_chain+0x2b/0x4a
[ 4972.320637]  [<c013261e>] __raw_notifier_call_chain+0x19/0x1e
[ 4972.326473]  [<c013263d>] raw_notifier_call_chain+0x1a/0x1c
[ 4972.332117]  [<c014bb62>] _cpu_down+0x19c/0x25a
[ 4972.336724]  [<c014bc48>] cpu_down+0x28/0x3a
[ 4972.341063]  [<c027f800>] store_online+0x27/0x5a
[ 4972.345757]  [<c027c854>] sysdev_store+0x20/0x25
[ 4972.350443]  [<c01c2739>] sysfs_write_file+0xc5/0xfd
[ 4972.355482]  [<c0187243>] vfs_write+0xd1/0x15a
[ 4972.360004]  [<c0187873>] sys_write+0x3d/0x72
[ 4972.364411]  [<c01041e0>] syscall_call+0x7/0xb
[ 4972.368924]  [<b7ff0410>] 0xb7ff0410
[ 4972.372562]  =======================
[ 4975.412963] lockdep: not fixing up alternatives.

Suspects:
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/console2.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc3-mm1/mm-config

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
