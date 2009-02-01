Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZBABFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZBABFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZBABFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:05:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48542 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbZBABFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:05:35 -0500
Subject: Re: irq_desc_lock_class is held when it is freed
From: Eric Paris <eparis@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
In-Reply-To: <4984D59F.4030700@kernel.org>
References: <1233437601.11984.41.camel@localhost.localdomain>
	 <4984D59F.4030700@kernel.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 20:05:22 -0500
Message-Id: <1233450323.19217.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 14:50 -0800, Yinghai Lu wrote:
> Eric Paris wrote:
> > I have an hp dl785g5 which is unable to successfully run
> > 2.6.29-0.66.rc3.fc11.x86_64 or 2.6.29-rc2-next-20090126.  During bootup
> > (early in userspace daemons starting) I get the below BUG, which quickly
> > renders the machine dead.  I assume it is because sparse_irq_lock never
> > gets released when the BUG kills that task.  But maybe it dies for some
> > other reason, but the machine is dead, gotta hit the vitual power
> > button.
> > 
> > setting CONFIG_NUMA_MIGRATE_IRQ_DESC=n allowed me to successfully boot
> > the linux-next kernel.  2.6.28 booted and worked fine (although it
> > doesn't have this config option, so that isn't surprising.)
> > 
> > attached you will find the linux-next config and dmesg output from the
> > machine in question when booted using linux-next WITHOUT the
> > MIGRATE_IRQ_DESC.  The only difference between the working and broken
> > config is if CONFIG_NUMA_MIGRATE_IRQ_DESC is set or not.
> > 
> > Please if there is anything I can collect, test, or do, don't hesitate
> > to let me know.
> > 
> it seems there is some merge problem... also there could be another problem...
> 
> please check
> 
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index 6c02c25..610ce0a 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -2511,14 +2511,15 @@ static void irq_complete_move(struct irq_desc **descp)
>  
>  	vector = ~get_irq_regs()->orig_ax;
>  	me = smp_processor_id();
> +
> +	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
>  #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
>  		*descp = desc = move_irq_desc(desc, me);
>  		/* get the new one */
>  		cfg = desc->chip_data;
>  #endif
> -
> -	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
>  		send_cleanup_vector(cfg);
> +	}
>  }
>  #else
>  static inline void irq_complete_move(struct irq_desc **descp) {}

Looks like I got the same thing.....

Starting Avahi daemon... [  OK  ]

=========================
[ BUG: held lock freed! ]
-------------------------
swapper/0 is freeing memory ffff88042c2196d0-ffff88042c2198cf, with a lock still held there!
 (&irq_desc_lock_class){++..}, at: [<ffffffff81093218>] handle_fasteoi_irq+0xa9/0xd4
2 locks held by swapper/0:
 #0:  (&irq_desc_lock_class){++..}, at: [<ffffffff81093218>] handle_fasteoi_irq+0xa9/0xd4
 #1:  (sparse_irq_lock){+...}, at: [<ffffffff810940a1>] move_irq_desc+0x69/0x1dc

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.29-rc2-next-20090126 #2
Call Trace:
 <IRQ>  [<ffffffff8106b973>] debug_check_no_locks_freed+0x10d/0x14e
 [<ffffffff810d2f87>] kfree+0x99/0x117
 [<ffffffff810941e7>] ? move_irq_desc+0x1af/0x1dc
 [<ffffffff810941e7>] move_irq_desc+0x1af/0x1dc
 [<ffffffff810241dc>] irq_complete_move+0x7c/0x8c
 [<ffffffff8102490c>] ack_apic_level+0x22/0x74
 [<ffffffff81093218>] ? handle_fasteoi_irq+0xa9/0xd4
 [<ffffffff81093229>] handle_fasteoi_irq+0xba/0xd4
 [<ffffffff81013b15>] do_IRQ+0xd5/0x140
 [<ffffffff81011e13>] ret_from_intr+0x0/0x2e
 <EOI> <6>bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex



