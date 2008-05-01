Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbYEASqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbYEASqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYEASqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:46:32 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:37564 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030AbYEASqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:46:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAAStGUhMROPA/2dsb2JhbACBU6sy
Date: Thu, 1 May 2008 14:46:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix SMP alternatives : use mutex instead of spinlock,
	text_poke is sleepable
Message-ID: <20080501184627.GA8853@Krystal>
References: <20080430195110.GA28743@dreamland.darkstar.lan> <20080501130453.GA28965@Krystal> <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com> <68676e00805010944y59fbbbdcyfd6524836997d3a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <68676e00805010944y59fbbbdcyfd6524836997d3a1@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:29:37 up 62 days, 14:40,  4 users,  load average: 0.45, 0.51,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luca Tettamanti (kronos.it@gmail.com) wrote:
> On Thu, May 1, 2008 at 5:02 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> > On Thu, May 1, 2008 at 3:04 PM, Mathieu Desnoyers
> >  <mathieu.desnoyers@polymtl.ca> wrote:
> >  > * Luca Tettamanti (kronos.it@gmail.com) wrote:
> >  >  > Hello,
> >  >  > with git current I'm seeing these warnings when bringing CPUs down:
> >  >  >
> >  >
> >  >
> >  >  Hi Luca,
> >  >
> >  >  Does your tree include the patch posted here ?
> >  >
> >  >  http://lkml.org/lkml/2008/4/19/139
> >
> >  Nope, I was using vanilla kernel (smp_alt is still a spinlock). Will
> >  test the patch ASAP.
> 
> Tested the patch: works fine, and the system is stable after multiple
> up&down, I'm not experiencing a reboot.
> 
> Luca

Ingo, Linus,

I guess fast-tracking pulling the following patch into mainline wouldn't
hurt. I just updated it so it applies to mainline.

Thanks,

Mathieu


Fix SMP alternatives : use mutex instead of spinlock, text_poke is sleepable

* Pekka Paalanen (pq@iki.fi) wrote:
> On Mon, 14 Apr 2008 08:57:13 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Pekka Paalanen wrote:
> > > When I tested this patch on Intel Core 2 Duo, enter_uniprocessor() 
> > > triggered the following kernel bug:
> > > 
> > > Linux version 2.6.25-rc8-sched-devel.git-x86-latest.git (paalanen@ct200006)
> > > (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #2 SMP PREEMPT Sun Apr 13
> > > 22:09:03 EEST 2008
> > > ...
> > > in mmio_trace_init
> > > mmiotrace: Disabling non-boot CPUs...
> > > CPU 1 is now offline
> > > lockdep: fixing up alternatives.
> > > SMP alternatives: switching to UP code
> > > BUG: sleeping function called from invalid context at mm/slab.c:3053
> > > in_atomic():1, irqs_disabled():0
> > > 5 locks held by bash/4423:
> > >  #0:  (trace_types_lock){--..}, at: [<ffffffff8026442f>] tracing_set_trace_write+0x93/0x11a
> > >  #1:  (mmiotrace_mutex){--..}, at: [<ffffffff802251e0>] enable_mmiotrace+0x17/0x142
> > >  #2:  (cpu_add_remove_lock){--..}, at: [<ffffffff802580e5>] cpu_maps_update_begin+0x12/0x14
> > >  #3:  (&cpu_hotplug.lock){--..}, at: [<ffffffff8025814f>] cpu_hotplug_begin+0x39/0x9f
> > >  #4:  (smp_alt){--..}, at: [<ffffffff80211bd9>] alternatives_smp_switch+0x66/0x1ab
> > > Pid: 4423, comm: bash Not tainted 2.6.25-rc8-sched-devel.git-x86-latest.git #2
> > > 
> > > Call Trace:
> > >  [<ffffffff802520c0>] ? __debug_show_held_locks+0x22/0x24
> > >  [<ffffffff8022d292>] __might_sleep+0xd9/0xdb
> > >  [<ffffffff80287326>] cache_alloc_debugcheck_before+0x23/0x32
> > >  [<ffffffff80287a32>] __kmalloc+0x34/0xa5
> > >  [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
> > >  [<ffffffff8027d7f6>] kmalloc_node+0x9/0xb
> > >  [<ffffffff8027d8e0>] __get_vm_area_node+0xa2/0x1cb
> > >  [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
> > >  [<ffffffff8027da41>] __get_vm_area+0x13/0x15
> > >  [<ffffffff8027da60>] get_vm_area+0x1d/0x1f
> > >  [<ffffffff8027e14c>] vmap+0x2a/0x5c
> > >  [<ffffffff8021191b>] text_poke+0xaa/0x136
> > >  [<ffffffff804cba2b>] ? _etext+0x0/0x5
> > >  [<ffffffff802119f6>] alternatives_smp_unlock+0x4f/0x63
> > >  [<ffffffff80211ce1>] alternatives_smp_switch+0x16e/0x1ab
> > >  [<ffffffff8021b163>] __cpu_die+0x53/0x7d
> > >  [<ffffffff802583e2>] _cpu_down+0x195/0x26c
> > >  [<ffffffff802585ca>] cpu_down+0x26/0x36
> > >  [<ffffffff80225270>] enable_mmiotrace+0xa7/0x142
> > >  [<ffffffff80266b8d>] mmio_trace_init+0x3c/0x40
> > >  [<ffffffff8026448e>] tracing_set_trace_write+0xf2/0x11a
> > >  [<ffffffff80327fac>] ? security_file_permission+0x11/0x13
> > >  [<ffffffff8028b047>] vfs_write+0xa7/0xe1
> > >  [<ffffffff8028b13b>] sys_write+0x47/0x6d
> > >  [<ffffffff8020b4db>] system_call_after_swapgs+0x7b/0x80
> > > 
> > > mmiotrace: CPU1 is down.
> > > mmiotrace: enabled.
> > > 
> > > Is this my fault, or is there a bug somewhere else? The kernel tree is 
> > > sched-devel/latest git from 12th April, IIRC.
> > 
> > there's no known bug of sched-devel/latest of this kind (or any known 
> > bug for that matter).
> > 
> > i suspect the bug is that you bring the CPU down from an atomic 
> > (spinlocked or irq disabled) context.
> 
> I have been eyeballing the code in current sched-devel/latest and there's
> something I think I found.
> 
> This is the beginning of my enter_uniprocessor() which is called from
> enable_mmiotrace() seen in the backtrace.
> 
> static void enter_uniprocessor(void)
> {
> 	int cpu;
> 	int err;
> 
> 	get_online_cpus();
> 	downed_cpus = cpu_online_map;
> 	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
> 	if (num_online_cpus() > 1)
> 		pr_notice(NAME "Disabling non-boot CPUs...\n");
> 	put_online_cpus();
> 
> 	for_each_cpu_mask(cpu, downed_cpus) {
> 		err = cpu_down(cpu);
> 
> The function get_online_cpus() calls might_sleep(), so at that
> point everything is fine.
> 
> Following the backtrace, we come to alternatives_smp_switch(),
> which does
> 	spin_lock(&smp_alt);
> and then continues eventually into this function:
> 
> void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> {
>         unsigned long flags;
>         char *vaddr;
>         int nr_pages = 2;
> 
>         BUG_ON(len > sizeof(long));
>         BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
>                 - ((long)addr & ~(sizeof(long) - 1)));
>         if (kernel_text_address((unsigned long)addr)) {
>                 struct page *pages[2] = { virt_to_page(addr),
>                         virt_to_page(addr + PAGE_SIZE) };
>                 if (!pages[1])
>                         nr_pages = 1;
>                 vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> 
> After which we find ourselves in
> 
> struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
>                                 unsigned long start, unsigned long end)
> {
> 	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL);
> 
> and in __get_vm_area_node() there is
> area = kmalloc_node(sizeof(*area), gfp_mask & GFP_RECLAIM_MASK, node);
> 
> where gfp_mask is now GFP_KERNEL. As far as I can tell, using SLAB,
> kmalloc_node() here is actually kmalloc(). Anyway, looks like we end up
> in __kmalloc with such flags that it may sleep.
> 
> I have followed the code so that the path up to kmalloc_node() is
> possible, unless there are some "should never happen" conditions
> along the way, which I just cannot know of.
> 
> Is this the bug?
> 

Yep. I think using a mutex should fix it. There is no reason to use a
spinlock rather than a mutex here.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Pekka Paalanen <pq@iki.fi>
CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/alternative.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-05-01 14:41:09.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-05-01 14:44:28.000000000 -0400
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
@@ -279,7 +279,7 @@ struct smp_alt_module {
 	struct list_head next;
 };
 static LIST_HEAD(smp_alt_modules);
-static DEFINE_SPINLOCK(smp_alt);
+static DEFINE_MUTEX(smp_alt);
 static int smp_mode = 1;	/* protected by smp_alt */
 
 void alternatives_smp_module_add(struct module *mod, char *name,
@@ -312,12 +312,12 @@ void alternatives_smp_module_add(struct 
 		__func__, smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_add_tail(&smp->next, &smp_alt_modules);
 	if (boot_cpu_has(X86_FEATURE_UP))
 		alternatives_smp_unlock(smp->locks, smp->locks_end,
 					smp->text, smp->text_end);
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_module_del(struct module *mod)
@@ -327,17 +327,17 @@ void alternatives_smp_module_del(struct 
 	if (smp_alt_once || noreplace_smp)
 		return;
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 	list_for_each_entry(item, &smp_alt_modules, next) {
 		if (mod != item->mod)
 			continue;
 		list_del(&item->next);
-		spin_unlock(&smp_alt);
+		mutex_unlock(&smp_alt);
 		DPRINTK("%s: %s\n", __func__, item->name);
 		kfree(item);
 		return;
 	}
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 void alternatives_smp_switch(int smp)
@@ -359,7 +359,7 @@ void alternatives_smp_switch(int smp)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
-	spin_lock(&smp_alt);
+	mutex_lock(&smp_alt);
 
 	/*
 	 * Avoid unnecessary switches because it forces JIT based VMs to
@@ -383,7 +383,7 @@ void alternatives_smp_switch(int smp)
 						mod->text, mod->text_end);
 	}
 	smp_mode = smp;
-	spin_unlock(&smp_alt);
+	mutex_unlock(&smp_alt);
 }
 
 #endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
