Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZLNMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZLNMVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbZLNMVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:21:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:50794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbZLNMVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:21:34 -0500
Subject: Re: [Next] CPU Hotplug test failures on powerpc
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4B261D7A.9040802@in.ibm.com>
References: <4B2224C7.1020908@in.ibm.com> <1260786122.4165.142.camel@twins>
	 <4B261D7A.9040802@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 14 Dec 2009 13:19:42 +0100
Message-ID: <1260793182.4165.223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 16:41 +0530, Sachin Sant wrote:
> Peter Zijlstra wrote:
> > On Fri, 2009-12-11 at 16:23 +0530, Sachin Sant wrote:
> >   
> >> While executing cpu_hotplug(from autotest) tests against latest
> >> next on a power6 box, the machine locks up. A soft reset shows
> >> the following trace
> >>
> >> cpu 0x0: Vector: 100 (System Reset) at [c00000000c9333d0]
> >>     pc: c0000000003433d8: .find_next_bit+0x54/0xc4
> >>     lr: c000000000342f10: .cpumask_next_and+0x4c/0x94
> >>     sp: c00000000c933650
> >>    msr: 8000000000089032
> >>   current = 0xc00000000c173840
> >>   paca    = 0xc000000000bc2600
> >>     pid   = 2602, comm = hotplug06.top.s
> >> enter ? for help
> >> [link register   ] c000000000342f10 .cpumask_next_and+0x4c/0x94
> >> [c00000000c933650] c0000000000e9f34 .cpuset_cpus_allowed_locked+0x38/0x74 (unreliable)
> >> [c00000000c9336e0] c000000000090074 .move_task_off_dead_cpu+0xc4/0x1ac
> >> [c00000000c9337a0] c0000000005e4e5c .migration_call+0x304/0x830
> >> [c00000000c933880] c0000000005e0880 .notifier_call_chain+0x68/0xe0
> >> [c00000000c933920] c00000000012a92c ._cpu_down+0x210/0x34c
> >> [c00000000c933a90] c00000000012aad8 .cpu_down+0x70/0xa8
> >> [c00000000c933b20] c000000000525940 .store_online+0x54/0x894
> >> [c00000000c933bb0] c000000000463430 .sysdev_store+0x3c/0x50
> >> [c00000000c933c20] c0000000001f8320 .sysfs_write_file+0x124/0x18c
> >> [c00000000c933ce0] c00000000017edac .vfs_write+0xd4/0x1fc
> >> [c00000000c933d80] c00000000017efdc .SyS_write+0x58/0xa0
> >> [c00000000c933e30] c0000000000085b4 syscall_exit+0x0/0x40
> >> --- Exception: c01 (System Call) at 00000fff9fa8a8f8
> >> SP (fffe7aef200) is in userspace
> >> 0:mon> e
> >> cpu 0x0: Vector: 100 (System Reset) at [c00000000c9333d0]
> >>     pc: c0000000003433d8: .find_next_bit+0x54/0xc4
> >>     lr: c000000000342f10: .cpumask_next_and+0x4c/0x94
> >>     sp: c00000000c933650
> >>    msr: 8000000000089032
> >>   current = 0xc00000000c173840
> >>   paca    = 0xc000000000bc2600
> >>     pid   = 2602, comm = hotplug06.top.s
> >>

OK so how do I read that above thing? What's a System Reset? Is that
like the x86 triple fault thing?

>From what I can make of it, its in move_task_off_dead_cpu(), right after
having called cpuset_cpus_allowed_locked(), doing that cpumask_any_and()
call.

static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
{
        int dest_cpu;
        const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));

again:
        /* Look for allowed, online CPU in same node. */
        for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
                if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
                        goto move;

        /* Any allowed, online CPU? */
        dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
        if (dest_cpu < nr_cpu_ids)
                goto move;

        /* No more Mr. Nice Guy. */
        if (dest_cpu >= nr_cpu_ids) {
                cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
====>           dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);

                /*
                 * Don't tell them about moving exiting tasks or
                 * kernel threads (both mm NULL), since they never
                 * leave kernel.
                 */
                if (p->mm && printk_ratelimit()) {
                        pr_info("process %d (%s) no longer affine to cpu%d\n",
                                task_pid_nr(p), p->comm, dead_cpu);
                }
        }

move:
        /* It can have affinity changed while we were choosing. */
        if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
                goto again;
}

Both masks, p->cpus_allowed and cpu_active_mask are stable in that p
won't go away since we hold the tasklist_lock (in migrate_list_tasks),
and cpu_active_mask is static storage, so WTH is it going funny on?
