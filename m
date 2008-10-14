Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYJND4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYJND4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 23:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYJND4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 23:56:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYJND4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 23:56:23 -0400
Message-ID: <48F417B2.4050704@cn.fujitsu.com>
Date: Tue, 14 Oct 2008 11:53:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] v3 rudimentary tracing for Classic RCU
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <20081010034421.GA12449@linux.vnet.ibm.com> <20081013230914.GA27467@linux.vnet.ibm.com>
In-Reply-To: <20081013230914.GA27467@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hello!
> 
> This is v3 of a tracing patch for Classic RCU, which creates "rcu/rcucb"
> and "rcu/rcudata" files in debugfs.  This patch can be handy when you
> need to work out why RCU is refusing to end the current grace period.
> 
> Should be ready for inclusion in tip/core/rcu, Ingo, please apply.

Hi, Paul,

I'm sorry that I'm a little busy these days, so I have not
ported it to seq_file, and you lost one choice.

I found that seq_cpumask_list() is needed when I tried to ported v2
to seq_file, so I introduced seq_cpumask_list() for seq_file, I'm
waiting procfs hackers apply that patch too.

Lai.

> 
> Changes since v2:  Add flag to rcu_data to avoid printing rcu_data for
> 		   CPUs that have never been online.
> 
> 		   Add documentation (below).
> 
> Changes since v1:  Adds (crude) tracing for rcu_data structures.
> 
> Reading from the "rcu/rcucb" file results in something like the following:
> 
> 	rcu: cur=1129  completed=1128  pending=0  s=0
> 		0,3,7

use "somename: 0,3,7" ? then when mask is empty, I think "somename:" is
better than empty line.

> 	rcu_bh: cur=-287  completed=-287  pending=0  s=0
> 
> 	online: 0-7
> 
> The first two lines are for rcu, the second two for rcu_bh.  The cur=
> is the current grace-period number, and the completed= is the number
> of the last completed grace period.  If these two numbers are equal,
> the corresponding flavor of RCU is idle.  The pending= is the furthest
> future batch number that is required, if equal to cur=, no additional
> grace periods are required.  The s=, if non-zero, indicates that a round
> of reschedule IPIs has been send to attempt to expedite the current
> grace period.
> 
> The second and fourth lines are a comma/dash-separated list of
> the CPUs that have not yet reported a quiescent state for the
> current grace period (CPUs 0, 3, and 7 for "rcu" above).
> 
> The last line lists the online CPUs.
> 
> 
> Reading from the "rcu/rcudata" file results in the following:
> 
> 	rcu:
> 	  0 qb=885 b=884 pq=1 qsp=0 ql=0 bl=10
> 	  1 qb=885 b=882 pq=1 qsp=0 ql=2 bl=10
> 	  2 qb=885 b=854 pq=1 qsp=0 ql=0 bl=10
> 	  3 qb=885 b=885 pq=1 qsp=0 ql=0 bl=10
> 	rcu_bh:
> 	  0 qb=-291 b=-291 pq=1 qsp=0 ql=0 bl=10
> 	  1 qb=-291 b=0 pq=1 qsp=0 ql=0 bl=10
> 	  2 qb=-291 b=0 pq=1 qsp=0 ql=0 bl=10
> 	  3 qb=-291 b=-298 pq=1 qsp=0 ql=0 bl=10
> 
> This output is again split into rcu and rcu_bh portions.  Within each
> portion, there is one line per CPU, but only for those CPUs that have
> been online at least once since boot.  The number at the beginning of
> each line is the CPU number, followed by an "!" if the corresponding CPU
> is currently offline.  The qb= is the batch number for the RCU core,
> the b= is the batch number corresponding to the callbacks waiting for
> the current grace period for this CPU, the pq= is a flag indicating that
> this CPU has passed through a quiescent state for the current grace
> period, the qsp= is a flag indicating that the RCU core has been
> informed that this CPU has passed through a quiescent state for the
> current grace period, the ql= is the number of RCU callbacks currently
> enqueued on this CPU (regardless of their state), and the bl= is the
> current limit of the number of callbacks to be invoked at one shot.
> 
> Tested on x86 and Power, rebased to -tip.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rcuclassic.h |    4 +
>  kernel/Kconfig.preempt     |    1 
>  kernel/Makefile            |    2 
>  kernel/rcuclassic.c        |    5 -
>  kernel/rcuclassic_trace.c  |  179 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 188 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 5f89b62..ce183a8 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -63,6 +63,9 @@ struct rcu_ctrlblk {
>  				 /* for current batch to proceed.        */
>  } ____cacheline_internodealigned_in_smp;
>  
> +extern struct rcu_ctrlblk rcu_ctrlblk;
> +extern struct rcu_ctrlblk rcu_bh_ctrlblk;
> +
>  /* Is batch a before batch b ? */
>  static inline int rcu_batch_before(long a, long b)
>  {
> @@ -81,6 +84,7 @@ struct rcu_data {
>  	long		quiescbatch;     /* Batch # for grace period */
>  	int		passed_quiesc;	 /* User-mode/idle loop etc. */
>  	int		qs_pending;	 /* core waits for quiesc state */
> +	bool		beenonline;	 /* CPU online at least once */
>  
>  	/* 2) batch handling */
>  	/*
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index 9fdba03..ba32338 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -68,7 +68,6 @@ config PREEMPT_RCU
>  
>  config RCU_TRACE
>  	bool "Enable tracing for RCU - currently stats in debugfs"
> -	depends on PREEMPT_RCU
>  	select DEBUG_FS
>  	default y
>  	help
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 4e1d7df..e0bfce7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -77,6 +77,8 @@ obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
>  obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
>  ifeq ($(CONFIG_PREEMPT_RCU),y)
>  obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
> +else
> +obj-$(CONFIG_RCU_TRACE) += rcuclassic_trace.o
>  endif
>  obj-$(CONFIG_RELAY) += relay.o
>  obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 37f72e5..54bd23b 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -58,14 +58,14 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
>  
>  
>  /* Definition for rcupdate control block. */
> -static struct rcu_ctrlblk rcu_ctrlblk = {
> +struct rcu_ctrlblk rcu_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
>  	.pending = -300,
>  	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
>  	.cpumask = CPU_MASK_NONE,
>  };
> -static struct rcu_ctrlblk rcu_bh_ctrlblk = {
> +struct rcu_ctrlblk rcu_bh_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
>  	.pending = -300,
> @@ -725,6 +725,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
>  	rdp->donetail = &rdp->donelist;
>  	rdp->quiescbatch = rcp->completed;
>  	rdp->qs_pending = 0;
> +	rdp->beenonline = 1;
>  	rdp->cpu = cpu;
>  	rdp->blimit = blimit;
>  	spin_unlock_irqrestore(&rcp->lock, flags);
> diff --git a/kernel/rcuclassic_trace.c b/kernel/rcuclassic_trace.c
> new file mode 100644
> index 0000000..d19780b
> --- /dev/null
> +++ b/kernel/rcuclassic_trace.c
> @@ -0,0 +1,179 @@
> +/*
> + * Read-Copy Update tracing for classic implementation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright IBM Corporation, 2008
> + *
> + * Papers:  http://www.rdrop.com/users/paulmck/RCU
> + *
> + * For detailed explanation of Read-Copy Update mechanism see -
> + * 		Documentation/RCU
> + *
> + */
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/smp.h>
> +#include <linux/rcupdate.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <asm/atomic.h>
> +#include <linux/bitops.h>
> +#include <linux/module.h>
> +#include <linux/completion.h>
> +#include <linux/moduleparam.h>
> +#include <linux/percpu.h>
> +#include <linux/notifier.h>
> +#include <linux/cpu.h>
> +#include <linux/mutex.h>
> +#include <linux/debugfs.h>
> +
> +static DEFINE_MUTEX(rcuclassic_trace_mutex);
> +static char *rcuclassic_trace_buf;
> +#define RCUCLASSIC_TRACE_BUF_SIZE (128 * num_possible_cpus() + 100)
> +
> +static int print_one_rcu_data(struct rcu_data *rdp, char *buf, char *ebuf)
> +{
> +	int cnt = 0;
> +
> +	if (!rdp->beenonline)
> +		return 0;
> +	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt],
> +		"%3d%cqb=%ld b=%ld pq=%d qsp=%d ql=%ld bl=%ld\n",
> +		rdp->cpu, cpu_is_offline(rdp->cpu) ? '!' : ' ',
> +		rdp->quiescbatch, rdp->batch, rdp->passed_quiesc,
> +		rdp->qs_pending, rdp->qlen, rdp->blimit);
> +	return cnt;
> +}
> +
> +#define PRINT_RCU_DATA(name, buf, ebuf) \
> +	do { \
> +		int _p_r_d_i; \
> +		\
> +		for_each_possible_cpu(_p_r_d_i) \
> +			(buf) += print_one_rcu_data(&per_cpu(name, _p_r_d_i), \
> +						    buf, ebuf); \
> +	} while (0)
> +
> +static ssize_t rcudata_read(struct file *filp, char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	ssize_t bcount;
> +	char *buf = rcuclassic_trace_buf;
> +	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
> +
> +	mutex_lock(&rcuclassic_trace_mutex);
> +	buf += snprintf(buf, ebuf - buf, "rcu:\n");
> +	PRINT_RCU_DATA(rcu_data, buf, ebuf);
> +	buf += snprintf(buf, ebuf - buf, "rcu_bh:\n");
> +	PRINT_RCU_DATA(rcu_bh_data, buf, ebuf);
> +	bcount = simple_read_from_buffer(buffer, count, ppos,
> +			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));

Is strlen(rcuclassic_trace_buf) == buf - rcuclassic_trace_buf ?

> +	mutex_unlock(&rcuclassic_trace_mutex);
> +	return bcount;
> +}
> +
> +static int print_one_rcu_ctrlblk(struct rcu_ctrlblk *rcp, char *buf, char *ebuf)
> +{
> +	int cnt = 0;
> +
> +	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "cur=%ld  completed=%ld  "
> +			"pending=%ld  s=%d\n\t",
> +			rcp->cur, rcp->completed,
> +			rcp->pending, rcp->signaled);
> +	cnt += cpulist_scnprintf(&buf[cnt], ebuf - &buf[cnt], rcp->cpumask);
> +	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "\n");
> +	return cnt;
> +}
> +
> +static ssize_t rcucb_read(struct file *filp, char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	ssize_t bcount;
> +	char *buf = rcuclassic_trace_buf;
> +	char *ebuf = &rcuclassic_trace_buf[RCUCLASSIC_TRACE_BUF_SIZE];
> +
> +	mutex_lock(&rcuclassic_trace_mutex);
> +	buf += snprintf(buf, ebuf - buf, "rcu: ");
> +	buf += print_one_rcu_ctrlblk(&rcu_ctrlblk, buf, ebuf);
> +	buf += snprintf(buf, ebuf - buf, "rcu_bh: ");
> +	buf += print_one_rcu_ctrlblk(&rcu_bh_ctrlblk, buf, ebuf);
> +	buf += snprintf(buf, ebuf - buf, "online: ");
> +	buf += cpulist_scnprintf(buf, ebuf - buf, cpu_online_map);
> +	buf += snprintf(buf, ebuf - buf, "\n");
> +	bcount = simple_read_from_buffer(buffer, count, ppos,
> +			rcuclassic_trace_buf, strlen(rcuclassic_trace_buf));
> +	mutex_unlock(&rcuclassic_trace_mutex);
> +	return bcount;
> +}
> +
> +static struct file_operations rcudata_fops = {
> +	.owner = THIS_MODULE,
> +	.read = rcudata_read,
> +};
> +
> +static struct file_operations rcucb_fops = {
> +	.owner = THIS_MODULE,
> +	.read = rcucb_read,
> +};
> +
> +static struct dentry *rcudir, *datadir, *cbdir;
> +static int rcuclassic_debugfs_init(void)
> +{
> +	rcudir = debugfs_create_dir("rcu", NULL);
> +	if (!rcudir)
> +		goto out;
> +	datadir = debugfs_create_file("rcudata", 0444, rcudir,
> +				      NULL, &rcudata_fops);
> +	if (!datadir)
> +		goto free_out;
> +	cbdir = debugfs_create_file("rcucb", 0444, rcudir, NULL, &rcucb_fops);
> +	if (!cbdir)
> +		goto free_out;
> +	return 0;
> +free_out:
> +	if (datadir)
> +		debugfs_remove(datadir);
> +	debugfs_remove(rcudir);
> +out:
> +	return 1;
> +}
> +
> +static int __init rcuclassic_trace_init(void)
> +{
> +	int ret;
> +
> +	rcuclassic_trace_buf = kmalloc(RCUCLASSIC_TRACE_BUF_SIZE, GFP_KERNEL);
> +	if (!rcuclassic_trace_buf)
> +		return 1;
> +	ret = rcuclassic_debugfs_init();
> +	if (ret)
> +		kfree(rcuclassic_trace_buf);
> +	return ret;
> +}
> +
> +static void __exit rcuclassic_trace_cleanup(void)
> +{
> +	debugfs_remove(datadir);
> +	debugfs_remove(cbdir);
> +	debugfs_remove(rcudir);
> +	kfree(rcuclassic_trace_buf);
> +}
> +
> +
> +module_init(rcuclassic_trace_init);
> +module_exit(rcuclassic_trace_cleanup);

should have:
MODULE_LICENSE("GPL");

optional but recommend:
MODULE_AUTHOR("Paul E. McKenney");
MODULE_DESCRIPTION("DESCRIPTION");

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 



