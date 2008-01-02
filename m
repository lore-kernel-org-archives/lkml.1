Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYABSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYABSnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYABSnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:43:16 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:59958 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYABSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pHgEIwBoNjzbkOZtPw7DheDlCcCzmbpiTUt34QZFZrrPeLo3nXL5dL4vnk81YP94EUZFc77L/zlG4XoLVqMY8yz+MUmIaOVM1MUlXhkHspkoe/fnnT+Gnz1X88sleNTAtS4ZXqW1oS1LQ7SLf/hzaeuPOLfW4Tn/mZlwYQpKHd4=
Message-ID: <64bb37e0801021043l26e33aafpa08265b44f0f4c82@mail.gmail.com>
Date: Wed, 2 Jan 2008 19:43:12 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: root <root@dyad.programming.kicks-ass.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>, "Jan Blunck" <jblunck@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20071117230049.GA25905@dyad>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <20071117180946.GA14055@elte.hu> <20071117230049.GA25905@dyad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC's somewhat trimmed...
On Nov 18, 2007 12:00 AM, root <root@dyad.programming.kicks-ass.net> wrote:
> On Sat, Nov 17, 2007 at 07:09:46PM +0100, Ingo Molnar wrote:
> > * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> >
> > > Sadly lockdep does not work for me, as it gets turned off early:
> > > [   39.851594] ---------------------------------
> > > [   39.855963] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> > > [   39.861981] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> > > [   39.866963]  (&n->list_lock){-+..}, at: [<ffffffff802935c1>]
> >
> > hey, that means it found a bug - which is not sad at all :-)
>
> ---
> Subject: lockdep: slub: annotate boot time node->list_lock usage
>
> inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
>  (&n->list_lock){-+..}, at: [<ffffffff802935c1>] add_partial+0x31/0xa0
> {softirq-on-W} state was registered at:
>   [<ffffffff80259fb8>] __lock_acquire+0x3e8/0x1140
>   [<ffffffff80259838>] debug_check_no_locks_freed+0x188/0x1a0
>   [<ffffffff8025ad65>] lock_acquire+0x55/0x70
>   [<ffffffff802935c1>] add_partial+0x31/0xa0
>   [<ffffffff805c76de>] _spin_lock+0x1e/0x30
>   [<ffffffff802935c1>] add_partial+0x31/0xa0
>   [<ffffffff80296f9c>] kmem_cache_open+0x1cc/0x330
>   [<ffffffff805c7984>] _spin_unlock_irq+0x24/0x30
>   [<ffffffff802974f4>] create_kmalloc_cache+0x64/0xf0
>   [<ffffffff80295640>] init_alloc_cpu_cpu+0x70/0x90
>   [<ffffffff8080ada5>] kmem_cache_init+0x65/0x1d0
>   [<ffffffff807f1b4e>] start_kernel+0x23e/0x350
>   [<ffffffff807f112d>] _sinittext+0x12d/0x140
>   [<ffffffffffffffff>] 0xffffffffffffffff
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Christoph Lameter <clameter@sgi.com>
> CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  mm/slub.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c
> +++ linux-2.6/mm/slub.c
> @@ -2155,6 +2155,7 @@ static struct kmem_cache_node *early_kme
>  {
>         struct page *page;
>         struct kmem_cache_node *n;
> +       unsigned long flags;
>
>         BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
>
> @@ -2179,7 +2180,14 @@ static struct kmem_cache_node *early_kme
>  #endif
>         init_kmem_cache_node(n);
>         atomic_long_inc(&n->nr_slabs);
> +       /*
> +        * lockdep requires consistent irq usage for each lock
> +        * so even though there cannot be a race this early in
> +        * the boot sequence, we still disable irqs.
> +        */
> +       local_irq_save(flags);
>         add_partial(kmalloc_caches, page, 0);
> +       local_irq_restore(flags);
>         return n;
>  }

I just tested something with vanilla 2.6.24-rc6 and had the same problem.
Should this patch, or something similar be included for 2.6.24?

The lockdep report:
[   40.057281] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[   40.063736] PCI: Not using MMCONFIG.
[   40.067329] PCI: Using configuration type 1
[   40.063153]
[   40.063154] =================================
[   40.063156] [ INFO: inconsistent lock state ]
[   40.063157] 2.6.24-rc6 #1
[   40.063158] ---------------------------------
[   40.063160] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
[   40.063162] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
[   40.063163]  (&n->list_lock){-+..}, at: [<ffffffff8029409c>]
add_partial+0x1c/0x50
[   40.063172] {softirq-on-W} state was registered at:
[   40.063173]   [<ffffffff8025a237>] __lock_acquire+0x3c7/0x1140
[   40.063179]   [<ffffffff8025991f>] trace_hardirqs_on+0xbf/0x160
[   40.063182]   [<ffffffff8025b00b>] lock_acquire+0x5b/0x80
[   40.063185]   [<ffffffff8029409c>] add_partial+0x1c/0x50
[   40.063187]   [<ffffffff805d0345>] _spin_lock+0x25/0x40
[   40.063192]   [<ffffffff8029409c>] add_partial+0x1c/0x50
[   40.063195]   [<ffffffff802979a7>] kmem_cache_open+0x1c7/0x330
[   40.063198]   [<ffffffff80297f23>] create_kmalloc_cache+0x63/0xc0
[   40.063200]   [<ffffffff80812d65>] kmem_cache_init+0x65/0x1d0
[   40.063204]   [<ffffffff807f9bc5>] start_kernel+0x245/0x360
[   40.063208]   [<ffffffff807f9131>] _sinittext+0x131/0x140
[   40.063211]   [<ffffffffffffffff>] 0xffffffffffffffff
[   40.063214] irq event stamp: 569
[   40.063215] hardirqs last  enabled at (568): [<ffffffff8029677d>]
kmem_cache_free+0xcd/0x100
[   40.063219] hardirqs last disabled at (569): [<ffffffff80296718>]
kmem_cache_free+0x68/0x100
[   40.063222] softirqs last  enabled at (550): [<ffffffff8023bb7f>]
__do_softirq+0xef/0x110
[   40.063226] softirqs last disabled at (557): [<ffffffff8020cf0c>]
call_softirq+0x1c/0x30
[   40.063230]
[   40.063230] other info that might help us debug this:
[   40.063231] no locks held by swapper/0.
[   40.063232]
[   40.063233] stack backtrace:
[   40.063235] Pid: 0, comm: swapper Not tainted 2.6.24-rc6 #1
[   40.063236]
[   40.063236] Call Trace:
[   40.063237]  <IRQ>  [<ffffffff80258699>] print_usage_bug+0x189/0x190
[   40.063243]  [<ffffffff802596fd>] mark_lock+0x63d/0x650
[   40.063246]  [<ffffffff8025a1ee>] __lock_acquire+0x37e/0x1140
[   40.063248]  [<ffffffff8020d1b7>] dump_trace+0xd7/0x2d0
[   40.063250]  [<ffffffff802144a8>] save_stack_trace+0x28/0x50
[   40.063253]  [<ffffffff802b4084>] free_fdtable_rcu+0x94/0xa0
[   40.063255]  [<ffffffff8025b00b>] lock_acquire+0x5b/0x80
[   40.063257]  [<ffffffff8029409c>] add_partial+0x1c/0x50
[   40.063259]  [<ffffffff805d0345>] _spin_lock+0x25/0x40
[   40.063261]  [<ffffffff8029409c>] add_partial+0x1c/0x50
[   40.063264]  [<ffffffff80295c3f>] __slab_free+0xaf/0x2f0
[   40.063265]  [<ffffffff802b4084>] free_fdtable_rcu+0x94/0xa0
[   40.063267]  [<ffffffff802b4084>] free_fdtable_rcu+0x94/0xa0
[   40.063269]  [<ffffffff80296751>] kmem_cache_free+0xa1/0x100
[   40.063271]  [<ffffffff802b4084>] free_fdtable_rcu+0x94/0xa0
[   40.063274]  [<ffffffff80249589>] __rcu_process_callbacks+0x89/0x240
[   40.063276]  [<ffffffff80249763>] rcu_process_callbacks+0x23/0x50
[   40.063278]  [<ffffffff8023bc43>] tasklet_action+0x53/0xd0
[   40.063280]  [<ffffffff8023bb14>] __do_softirq+0x84/0x110
[   40.063284]  [<ffffffff802377fe>] profile_tick+0x5e/0xa0
[   40.063286]  [<ffffffff8020ac50>] default_idle+0x0/0x60
[   40.063288]  [<ffffffff8020cf0c>] call_softirq+0x1c/0x30
[   40.063290]  [<ffffffff8020f115>] do_softirq+0x65/0xc0
[   40.063292]  [<ffffffff8023ba85>] irq_exit+0x95/0xa0
[   40.063296]  [<ffffffff8021bcf9>] smp_apic_timer_interrupt+0x49/0x70
[   40.063297]  [<ffffffff8020ac50>] default_idle+0x0/0x60
[   40.063300]  [<ffffffff8020c9bb>] apic_timer_interrupt+0x6b/0x70
[   40.063301]  <EOI>  [<ffffffff8020ac87>] default_idle+0x37/0x60
[   40.063304]  [<ffffffff8020ac85>] default_idle+0x35/0x60
[   40.063305]  [<ffffffff8020ad1b>] cpu_idle+0x6b/0xa0
[   40.063308]  [<ffffffff808061d8>] start_secondary+0x2f8/0x430
[   40.063310]
[   40.419678] ACPI: EC: Look up EC in DSDT
[   40.428641] ACPI: Interpreter enabled
[   40.432320] ACPI: (supports S0 S5)
[   40.435823] ACPI: Using IOAPIC for interrupt routing
