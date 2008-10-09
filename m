Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbYJIGWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbYJIGWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYJIGWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:22:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbYJIGWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:22:22 -0400
Message-ID: <48EDA2A6.9070707@cn.fujitsu.com>
Date: Thu, 09 Oct 2008 14:20:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com>
In-Reply-To: <20081009010846.GA10188@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hello!
> 
> This is a tracing patch for Classic RCU, which creates an "rcu/rcucb"
> file in debugfs.  This patch can be handy when you need to work out
> why RCU is refusing to end the current grace period.
> 
> Reading from the file results in something like the following:
> 
> 	rcu: cur=1129  completed=1128  np=0  s=0
> 		0,3,7
> 	rcu_bh: cur=-287  completed=-287  np=0  s=0
> 
> 	online: 0-7
> 
> The first two lines are for rcu, the second two for rcu_bh.
> The cur= is the current grace-period number, and the completed=
> is the number of the last completed grace period.  If these two
> numbers are equal, the corresponding flavor of RCU is idle.
> The np= is a flag indicating that an additional RCU grace period
> beyond the current one will be required.  The s=, if non-zero,
> indicates that a round of reschedule IPIs has been send to
> attempt to expedite the current grace period.
> 
> The second and fourth lines are a comma/dash-separated list of
> the CPUs that have not yet reported a quiescent state for the
> current grace period (CPUs 0, 3, and 7 for "rcu" above).
> 
> The last line lists the online CPUs.
> 
> Tested on x86 and Power.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rcuclassic.h |    3 +
>  kernel/Kconfig.preempt     |    1 
>  kernel/Makefile            |    2 
>  kernel/rcuclassic.c        |    4 -
>  kernel/rcuclassic_trace.c  |  126 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 133 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 4ab8436..061a272 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -54,6 +54,9 @@ struct rcu_ctrlblk {
>  				 /* for current batch to proceed.        */
>  } ____cacheline_internodealigned_in_smp;
>  
> +extern struct rcu_ctrlblk rcu_ctrlblk;
> +extern struct rcu_ctrlblk rcu_bh_ctrlblk;
> +
>  /* Is batch a before batch b ? */
>  static inline int rcu_batch_before(long a, long b)
>  {
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

I think that we can move it to lib/Kconfig.debug.

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
> index aad93cd..517eaa9 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -57,13 +57,13 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
>  
>  
>  /* Definition for rcupdate control block. */
> -static struct rcu_ctrlblk rcu_ctrlblk = {
> +struct rcu_ctrlblk rcu_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
>  	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
>  	.cpumask = CPU_MASK_NONE,
>  };
> -static struct rcu_ctrlblk rcu_bh_ctrlblk = {
> +struct rcu_ctrlblk rcu_bh_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
>  	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
> diff --git a/kernel/rcuclassic_trace.c b/kernel/rcuclassic_trace.c
> new file mode 100644
> index 0000000..f8b9313
> --- /dev/null
> +++ b/kernel/rcuclassic_trace.c
> @@ -0,0 +1,126 @@
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
> +#define RCUCLASSIC_TRACE_BUF_SIZE (20*NR_CPUS + 100)
> +
> +static int print_one_rcu_ctrlblk(struct rcu_ctrlblk *rcp, char *buf, char *ebuf)
> +{
> +	int cnt = 0;
> +
> +	cnt += snprintf(&buf[cnt], ebuf - &buf[cnt], "cur=%ld  completed=%ld  "
> +			"np=%d  s=%d\n\t",
> +			rcp->cur, rcp->completed,
> +			rcp->next_pending, rcp->signaled);
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
> +static struct file_operations rcucb_fops = {
> +	.owner = THIS_MODULE,
> +	.read = rcucb_read,
> +};
> +
> +static struct dentry *rcudir, *cbdir;
> +static int rcuclassic_debugfs_init(void)

add __init:
static int __init rcuclassic_debugfs_init(void)

> +{
> +	rcudir = debugfs_create_dir("rcu", NULL);
> +	if (!rcudir)
> +		goto out;
> +	cbdir = debugfs_create_file("rcucb", 0444, rcudir, NULL, &rcucb_fops);
> +	if (!cbdir)
> +		goto free_out;
> +	return 0;
> +free_out:
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

I'm wondering about this.
rcuclassic_trace_buf is kmalloc-ed when init module.

In this case, why not define it as:
static char buf[20*NR_CPUS + 100];

and use it like:
pos += snprintf(buf + cnt, sizeof(buf) - cnt, ...);


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
> +	debugfs_remove(cbdir);
> +	debugfs_remove(rcudir);
> +	kfree(rcuclassic_trace_buf);
> +}
> +
> +
> +module_init(rcuclassic_trace_init);
> +module_exit(rcuclassic_trace_cleanup);


I think this trace file shows too little vars for classic rcu.

It is better that this trace file shows more data.
such as some data in struct rcu_data(quiescent state handling fields, batch, qlen).

or add new files: rcu/rcu_data<cpu#>


Thanks, Lai

