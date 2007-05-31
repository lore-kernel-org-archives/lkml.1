Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbXEaScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbXEaScb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXEaScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:32:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbXEaScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:32:24 -0400
Date: Thu, 31 May 2007 11:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070531113155.1c6d7185.akpm@linux-foundation.org>
In-Reply-To: <465F0B83.2050100@googlemail.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<465F0B83.2050100@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 19:53:07 +0200
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton napisa__(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> > 
> 
> CPU hotplug test triggered this
> 
> [ 4972.038008] CPU 1 is now offline
> [ 4972.041411] lockdep: not fixing up alternatives.
> [ 4972.051553] 
> [ 4972.051555] =================================
> [ 4972.057562] [ INFO: inconsistent lock state ]
> [ 4972.062056] 2.6.22-rc3-mm1 #10
> [ 4972.065184] ---------------------------------
> [ 4972.069663] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> [ 4972.075758] sh/702 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 4972.080554]  (&n->list_lock){++..}, at: [<c0181288>] add_partial+0xe/0x27
> 
> l *0xc0181288
> 0xc0181288 is in add_partial (/home/devel/linux-mm/mm/slub.c:1193).
> 1188    }
> 1189
> 1190    static void add_partial(struct kmem_cache_node *n, struct page *page)
> 1191    {
> 1192            spin_lock(&n->list_lock);
> 1193            n->nr_partial++;
> 1194            list_add(&page->lru, &n->partial);
> 1195            spin_unlock(&n->list_lock);
> 1196    }
> 1197
> 
> 
> [ 4972.087650] {in-hardirq-W} state was registered at:
> [ 4972.092656]   [<c0143bfe>] mark_lock+0x82/0x557
> [ 4972.097323]   [<c0144c5f>] __lock_acquire+0x476/0xd36
> [ 4972.102562]   [<c01455bd>] lock_acquire+0x9e/0xb8
> [ 4972.107342]   [<c0348993>] _spin_lock+0x38/0x62
> [ 4972.111993]   [<c0181d29>] deactivate_slab+0xb9/0x179
> [ 4972.117300]   [<c0181e56>] flush_slab+0x6d/0x72
> [ 4972.122063]   [<c0181e8c>] __flush_cpu_slab+0x31/0x36
> [ 4972.127335]   [<c0181ea5>] flush_cpu_slab+0x14/0x17
> [ 4972.132401]   [<c0113d6f>] smp_call_function_interrupt+0x3a/0x56
> [ 4972.138607]   [<c0104c73>] call_function_interrupt+0x33/0x38
> [ 4972.144503]   [<c0102b59>] default_idle+0x50/0x69
> [ 4972.149421]   [<c01023eb>] cpu_idle+0xb3/0xf8
> [ 4972.153889]   [<c03454fa>] rest_init+0x56/0x58
> [ 4972.158402]   [<c04f39c7>] start_kernel+0x351/0x359
> [ 4972.163450]   [<ffffffff>] 0xffffffff
> [ 4972.167221] irq event stamp: 2451

Yep, that's a bug in slub.  We take that lock in the IPI handler.  If a CPU
is currently holding that lock and then takes the IPI and enters
add_partial(), it'll deadlock.

> [ 4972.243670] 
> [ 4972.243670] stack backtrace:
> [ 4972.248166]  [<c0105281>] dump_trace+0x63/0x1eb
> [ 4972.252755]  [<c0105423>] show_trace_log_lvl+0x1a/0x2f
> [ 4972.257969]  [<c0106061>] show_trace+0x12/0x14
> [ 4972.262463]  [<c0106079>] dump_stack+0x16/0x18
> [ 4972.266974]  [<c0142ff8>] print_usage_bug+0x140/0x14a
> [ 4972.272109]  [<c0143e1a>] mark_lock+0x29e/0x557
> [ 4972.276708]  [<c0144cda>] __lock_acquire+0x4f1/0xd36
> [ 4972.281740]  [<c01455bd>] lock_acquire+0x9e/0xb8
> [ 4972.286416]  [<c0348993>] _spin_lock+0x38/0x62
> [ 4972.290936]  [<c0181288>] add_partial+0xe/0x27
> [ 4972.295458]  [<c0181cd7>] deactivate_slab+0x67/0x179
> [ 4972.300497]  [<c0181e56>] flush_slab+0x6d/0x72
> [ 4972.305018]  [<c0181e8c>] __flush_cpu_slab+0x31/0x36
> [ 4972.310049]  [<c01836e8>] slab_cpuup_callback+0x38/0x5b
> [ 4972.315348]  [<c01325d2>] notifier_call_chain+0x2b/0x4a
> [ 4972.320637]  [<c013261e>] __raw_notifier_call_chain+0x19/0x1e
> [ 4972.326473]  [<c013263d>] raw_notifier_call_chain+0x1a/0x1c
> [ 4972.332117]  [<c014bb62>] _cpu_down+0x19c/0x25a
> [ 4972.336724]  [<c014bc48>] cpu_down+0x28/0x3a
> [ 4972.341063]  [<c027f800>] store_online+0x27/0x5a
> [ 4972.345757]  [<c027c854>] sysdev_store+0x20/0x25
> [ 4972.350443]  [<c01c2739>] sysfs_write_file+0xc5/0xfd
> [ 4972.355482]  [<c0187243>] vfs_write+0xd1/0x15a
> [ 4972.360004]  [<c0187873>] sys_write+0x3d/0x72
> [ 4972.364411]  [<c01041e0>] syscall_call+0x7/0xb
> [ 4972.368924]  [<b7ff0410>] 0xb7ff0410
> [ 4972.372562]  =======================
> [ 4975.412963] lockdep: not fixing up alternatives.

Perhaps a suitable fix would be local_irq_disable() in flush_slab().
