Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZIQLnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZIQLnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZIQLnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:43:00 -0400
Received: from relay.heise.de ([193.99.145.50]:35160 "EHLO relay.heise.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZIQLm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:42:59 -0400
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 07:42:59 EDT
Message-ID: <4AB21B6D.2010706@ct.heise.de>
Date: Thu, 17 Sep 2009 13:20:13 +0200
From: Thorsten Leemhuis <thl@ct.heise.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block: add blk-iopoll, a NAPI like approach for block devices
References: <200909150203.n8F239jo018484@hera.kernel.org>
In-Reply-To: <200909150203.n8F239jo018484@hera.kernel.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://lwn.net/Articles/346219/

On 15.09.2009 04:03, Linux Kernel Mailing List wrote:
>  * [http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e605b64a183a6c0e84cdb99a6f8acb1f8200437 block: add blk-iopoll, a NAPI like approach for block devices]
> 
> Author:     Jens Axboe <jens.axboe@oracle.com>
> AuthorDate: Wed Aug 5 09:07:21 2009 +0200
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Fri Sep 11 14:33:31 2009 +0200
> 
>     block: add blk-iopoll, a NAPI like approach for block devices
>     
>     This borrows some code from NAPI and implements a polled completion
>     mode for block devices. The idea is the same as NAPI - instead of
>     doing the command completion when the irq occurs, schedule a dedicated
>     softirq in the hopes that we will complete more IO when the iopoll
>     handler is invoked. Devices have a budget of commands assigned, and will
>     stay in polled mode as long as they continue to consume their budget
>     from the iopoll softirq handler. If they do not, the device is set back
>     to interrupt completion mode.
>     
>     This patch holds the core bits for blk-iopoll, device driver support
>     sold separately.
>     
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/Makefile             |    2 +-
>  block/blk-iopoll.c         |  220 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blk-iopoll.h |   41 ++++++++
>  include/linux/interrupt.h  |    1 +
>  kernel/sysctl.c            |   10 ++-
>  5 files changed, 272 insertions(+), 2 deletions(-)
> 
> diff --git a/block/Makefile b/block/Makefile
> index 6c54ed0..ba74ca6 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -5,7 +5,7 @@
>  obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
>  			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
>  			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
> -			ioctl.o genhd.o scsi_ioctl.o
> +			blk-iopoll.o ioctl.o genhd.o scsi_ioctl.o
>  
>  obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
>  obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
> diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
> new file mode 100644
> index 0000000..566db1e
> --- /dev/null
> +++ b/block/blk-iopoll.c
> @@ -0,0 +1,220 @@
> +/*
> + * Functions related to interrupt-poll handling in the block layer. This
> + * is similar to NAPI for network devices.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +#include <linux/interrupt.h>
> +#include <linux/cpu.h>
> +#include <linux/blk-iopoll.h>
> +#include <linux/delay.h>
> +
> +#include "blk.h"
> +
> +int blk_iopoll_enabled = 1;
> +EXPORT_SYMBOL(blk_iopoll_enabled);
> +
> +static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
> +
> +/**
> + * blk_iopoll_sched - Schedule a run of the iopoll handler
> + * @iop:      The parent iopoll structure
> + *
> + * Description:
> + *     Add this blk_iopoll structure to the pending poll list and trigger the raise
> + *     of the blk iopoll softirq. The driver must already have gotten a succesful
> + *     return from blk_iopoll_sched_prep() before calling this.
> + **/
> +void blk_iopoll_sched(struct blk_iopoll *iop)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
> +	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL(blk_iopoll_sched);
> +
> +/**
> + * __blk_iopoll_complete - Mark this @iop as un-polled again
> + * @iop:      The parent iopoll structure
> + *
> + * Description:
> + *     See blk_iopoll_complete(). This function must be called with interrupts disabled.
> + **/
> +void __blk_iopoll_complete(struct blk_iopoll *iop)
> +{
> +	list_del(&iop->list);
> +	smp_mb__before_clear_bit();
> +	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
> +}
> +EXPORT_SYMBOL(__blk_iopoll_complete);
> +
> +/**
> + * blk_iopoll_complete - Mark this @iop as un-polled again
> + * @iop:      The parent iopoll structure
> + *
> + * Description:
> + *     If a driver consumes less than the assigned budget in its run of the iopoll
> + *     handler, it'll end the polled mode by calling this function. The iopoll handler
> + *     will not be invoked again before blk_iopoll_sched_prep() is called.
> + **/
> +void blk_iopoll_complete(struct blk_iopoll *iopoll)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__blk_iopoll_complete(iopoll);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL(blk_iopoll_complete);
> +
> +static void blk_iopoll_softirq(struct softirq_action *h)
> +{
> +	struct list_head *list = &__get_cpu_var(blk_cpu_iopoll);
> +	unsigned long start_time = jiffies;
> +	int rearm = 0, budget = 64;
> +
> +	local_irq_disable();
> +
> +	while (!list_empty(list)) {
> +		struct blk_iopoll *iop;
> +		int work, weight;
> +
> +		/*
> +		 * If softirq window is exhausted then punt.
> +		 */
> +		if (budget <= 0 || time_after(jiffies, start_time)) {
> +			rearm = 1;
> +			break;
> +		}
> +
> +		local_irq_enable();
> +
> +		/* Even though interrupts have been re-enabled, this
> +		 * access is safe because interrupts can only add new
> +		 * entries to the tail of this list, and only ->poll()
> +		 * calls can remove this head entry from the list.
> +		 */
> +		iop = list_entry(list->next, struct blk_iopoll, list);
> +
> +		weight = iop->weight;
> +		work = 0;
> +		if (test_bit(IOPOLL_F_SCHED, &iop->state))
> +			work = iop->poll(iop, weight);
> +
> +		budget -= work;
> +
> +		local_irq_disable();
> +
> +		/* Drivers must not modify the NAPI state if they
> +		 * consume the entire weight.  In such cases this code
> +		 * still "owns" the NAPI instance and therefore can
> +		 * move the instance around on the list at-will.
> +		 */
> +		if (work >= weight) {
> +			if (blk_iopoll_disable_pending(iop))
> +				__blk_iopoll_complete(iop);
> +			else
> +				list_move_tail(&iop->list, list);
> +		}
> +	}
> +
> +	if (rearm)
> +		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
> +
> +	local_irq_enable();
> +}
> +
> +/**
> + * blk_iopoll_disable - Disable iopoll on this @iop
> + * @iop:      The parent iopoll structure
> + *
> + * Description:
> + *     Disable io polling and wait for any pending callbacks to have completed.
> + **/
> +void blk_iopoll_disable(struct blk_iopoll *iop)
> +{
> +	set_bit(IOPOLL_F_DISABLE, &iop->state);
> +	while (test_and_set_bit(IOPOLL_F_SCHED, &iop->state))
> +		msleep(1);
> +	clear_bit(IOPOLL_F_DISABLE, &iop->state);
> +}
> +EXPORT_SYMBOL(blk_iopoll_disable);
> +
> +/**
> + * blk_iopoll_enable - Enable iopoll on this @iop
> + * @iop:      The parent iopoll structure
> + *
> + * Description:
> + *     Enable iopoll on this @iop. Note that the handler run will not be scheduled, it
> + *     will only mark it as active.
> + **/
> +void blk_iopoll_enable(struct blk_iopoll *iop)
> +{
> +	BUG_ON(!test_bit(IOPOLL_F_SCHED, &iop->state));
> +        smp_mb__before_clear_bit();
> +	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
> +}
> +EXPORT_SYMBOL(blk_iopoll_enable);
> +
> +/**
> + * blk_iopoll_init - Initialize this @iop
> + * @iop:      The parent iopoll structure
> + * @weight:   The default weight (or command completion budget)
> + * @poll_fn:  The handler to invoke
> + *
> + * Description:
> + *     Initialize this blk_iopoll structure. Before being actively used, the driver
> + *     must call blk_iopoll_enable().
> + **/
> +void blk_iopoll_init(struct blk_iopoll *iop, int weight, blk_iopoll_fn *poll_fn)
> +{
> +	memset(iop, 0, sizeof(*iop));
> +	INIT_LIST_HEAD(&iop->list);
> +	iop->weight = weight;
> +	iop->poll = poll_fn;
> +	set_bit(IOPOLL_F_SCHED, &iop->state);
> +}
> +EXPORT_SYMBOL(blk_iopoll_init);
> +
> +static int __cpuinit blk_iopoll_cpu_notify(struct notifier_block *self,
> +					  unsigned long action, void *hcpu)
> +{
> +	/*
> +	 * If a CPU goes away, splice its entries to the current CPU
> +	 * and trigger a run of the softirq
> +	 */
> +	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
> +		int cpu = (unsigned long) hcpu;
> +
> +		local_irq_disable();
> +		list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
> +				 &__get_cpu_var(blk_cpu_iopoll));
> +		raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
> +		local_irq_enable();
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block __cpuinitdata blk_iopoll_cpu_notifier = {
> +	.notifier_call	= blk_iopoll_cpu_notify,
> +};
> +
> +static __init int blk_iopoll_setup(void)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i)
> +		INIT_LIST_HEAD(&per_cpu(blk_cpu_iopoll, i));
> +
> +	open_softirq(BLOCK_IOPOLL_SOFTIRQ, blk_iopoll_softirq);
> +	register_hotcpu_notifier(&blk_iopoll_cpu_notifier);
> +	return 0;
> +}
> +subsys_initcall(blk_iopoll_setup);
> diff --git a/include/linux/blk-iopoll.h b/include/linux/blk-iopoll.h
> new file mode 100644
> index 0000000..b2e1739
> --- /dev/null
> +++ b/include/linux/blk-iopoll.h
> @@ -0,0 +1,41 @@
> +#ifndef BLK_IOPOLL_H
> +#define BLK_IOPOLL_H
> +
> +struct blk_iopoll;
> +typedef int (blk_iopoll_fn)(struct blk_iopoll *, int);
> +
> +struct blk_iopoll {
> +	struct list_head list;
> +	unsigned long state;
> +	unsigned long data;
> +	int weight;
> +	int max;
> +	blk_iopoll_fn *poll;
> +};
> +
> +enum {
> +	IOPOLL_F_SCHED		= 0,
> +	IOPOLL_F_DISABLE	= 1,
> +};
> +
> +static inline int blk_iopoll_sched_prep(struct blk_iopoll *iop)
> +{
> +	return !test_bit(IOPOLL_F_DISABLE, &iop->state) &&
> +		!test_and_set_bit(IOPOLL_F_SCHED, &iop->state);
> +}
> +
> +static inline int blk_iopoll_disable_pending(struct blk_iopoll *iop)
> +{
> +	return test_bit(IOPOLL_F_DISABLE, &iop->state);
> +}
> +
> +extern void blk_iopoll_sched(struct blk_iopoll *);
> +extern void blk_iopoll_init(struct blk_iopoll *, int, blk_iopoll_fn *);
> +extern void blk_iopoll_complete(struct blk_iopoll *);
> +extern void __blk_iopoll_complete(struct blk_iopoll *);
> +extern void blk_iopoll_enable(struct blk_iopoll *);
> +extern void blk_iopoll_disable(struct blk_iopoll *);
> +
> +extern int blk_iopoll_enabled;
> +
> +#endif
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 35e7df1..edd8d5c 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -344,6 +344,7 @@ enum
>  	NET_TX_SOFTIRQ,
>  	NET_RX_SOFTIRQ,
>  	BLOCK_SOFTIRQ,
> +	BLOCK_IOPOLL_SOFTIRQ,
>  	TASKLET_SOFTIRQ,
>  	SCHED_SOFTIRQ,
>  	HRTIMER_SOFTIRQ,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 58be760..0ed9fa6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -92,6 +92,7 @@ extern int sysctl_nr_trim_pages;
>  #ifdef CONFIG_RCU_TORTURE_TEST
>  extern int rcutorture_runnable;
>  #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
> +extern int blk_iopoll_enabled;
>  
>  /* Constants used for minimum and  maximum */
>  #ifdef CONFIG_DETECT_SOFTLOCKUP
> @@ -990,7 +991,14 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  #endif
> -
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "blk_iopoll",
> +		.data		= &blk_iopoll_enabled,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
>  /*
>   * NOTE: do not add new entries to this table unless you have read
>   * Documentation/sysctl/ctl_unnumbered.txt
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Thorsten Leemhuis
 c't- Magazin für Computertechnik       web    http://www.heise.de/ct/
 Heise Zeitschriften Verlag GmbH&Co.KG  phone  +49 (0)511 5352 300
 Helstorfer Str. 7                      icq    140593172
 D-30625 Hannover, Germany              jabber thl_at_work@jabber.ccc.de

/* Heise Zeitschriften Verlag GmbH & Co. KG, Registergericht:
   Amtsgericht Hannover HRA 26709; Persönlich haftende Gesellschafterin:
   Heise Zeitschriften Verlag Geschäftsführung GmbH, Registergericht:
   Amtsgericht Hannover, HRB 60405 Geschäftsführer: Ansgar Heise,
   Steven P. Steinkraus, Dr. Alfons Schräder                          */
