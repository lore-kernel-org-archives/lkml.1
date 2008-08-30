Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYH3KAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYH3KAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYH3KAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:00:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYH3KAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:00:30 -0400
Message-ID: <48B919C2.1040809@cn.fujitsu.com>
Date: Sat, 30 Aug 2008 17:58:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, rostedt@goodmis.org,
       peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com>
In-Reply-To: <20080830004935.GA28548@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a fast review. so my comments is nothing but cleanup.

          Thanks, Lai.

Paul E. McKenney wrote:
> Hello!

> +rcu_start_gp(struct rcu_state *rsp, unsigned long iflg)
> +	__releases(rsp->rda[smp_processor_id()]->lock)
> +{
> +	unsigned long flags = iflg;
> +	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
> +	struct rcu_node *rnp = rcu_get_root(rsp);
> +	struct rcu_node *rnp_cur;
> +	struct rcu_node *rnp_end;
> +
> +	if (!cpu_needs_another_gp(rsp, rdp)) {
>  
>  		/*
> -		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
> -		 * Barrier  Otherwise it can cause tickless idle CPUs to be
> -		 * included in rcp->cpumask, which will extend graceperiods
> -		 * unnecessarily.
> +		 * Either there is no need to detect any more grace periods
> +		 * at the moment, or we are already in the process of
> +		 * detecting one.  Either way, we should not start a new
> +		 * RCU grace period, so drop the lock and return.
>  		 */
> -		smp_mb();
> -		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
> +		spin_unlock_irqrestore(&rnp->lock, flags);
> +		return;
> +	}
> +
> +	/* Advance to a new grace period and initialize state. */
> +
> +	rsp->gpnum++;
> +	rsp->signaled = RCU_SIGNAL_INIT;
> +	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
> +	record_gp_stall_check_time();
> +	dyntick_save_completed(rsp, rsp->completed - 1);
> +	note_new_gpnum(rsp, rdp);
> +
> +	/*
> +	 * Because we are first, we know that all our callbacks will
> +	 * be covered by this upcoming grace period, even the ones
> +	 * that were registered arbitrarily recently.
> +	 */
> +
> +	rcu_next_callbacks_are_ready(rdp);
> +	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
>  
> -		rcp->signaled = 0;
> +	/* Special-case the common single-level case. */
> +
> +	if (NUM_RCU_NODES == 1) {
> +		rnp->qsmask = rnp->qsmaskinit;

I tried a mask like qsmaskinit before. The system came to deadlock
when I did on/offline cpus.
I didn't find out the whys for I bethought of these two problem:

problem 1:
----race condition 1:
<cpu_down>
synchronize_rcu <called from offline handler in other subsystem>
rcu_offline_cpu


-----race condition 2:
rcu_online_cpu
synchronize_rcu <called from online handler in other subsystem>
<cpu_up>

in these two condition, synchronize_rcu isblocked for ever for
synchronize_rcu have to wait a cpu in rnp->qsmask, but this
cpu don't run.



problem 2:
we need call rcu_offline_cpu() in these two cases in rcu_cpu_notify()
since qsmaskinit had changed by rcu_online_cpu()

	case CPU_UP_CANCELED:
	case CPU_UP_CANCELED_FROZEN:


> +static void
> +cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long *lastcomp)
>  {
>  	unsigned long flags;
> +	long mask;

long mask -> unsigned long mask


> +static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
>  {
> -	if (list) {
> -		local_irq_disable();
> -		this_rdp->batch = batch;
> -		*this_rdp->nxttail[2] = list;
> -		this_rdp->nxttail[2] = tail;
> -		local_irq_enable();
> +	int i;
> +	unsigned long flags;
> +	long mask;

long mask -> unsigned long mask


> + * Queue an RCU callback for invocation after a grace period.
> + */
> +void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	__call_rcu(head, &rcu_state, &__get_cpu_var(rcu_data));
> +	local_irq_restore(flags);
> +}

struct rcu_state has a field: struct rcu_data *rda[NR_CPUS]
so we can move these lines around __call_rcu into __call_rcu.

__call_rcu(struct rcu_head *head, struct rcu_state *rsp)
{
	local_irq_save(flags);
	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
.....
	local_irq_save(flags);
}


> +static void
> +rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
>  {
> -	if (user ||
> -	    (idle_cpu(cpu) && !in_softirq() &&
> -				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> -
> -		/*
> -		 * Get here if this CPU took its interrupt from user
> -		 * mode or from the idle loop, and if this is not a
> -		 * nested interrupt.  In this case, the CPU is in
> -		 * a quiescent state, so count it.
> -		 *
> -		 * Also do a memory barrier.  This is needed to handle
> -		 * the case where writes from a preempt-disable section
> -		 * of code get reordered into schedule() by this CPU's
> -		 * write buffer.  The memory barrier makes sure that
> -		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
> -		 * by other CPUs to happen after any such write.
> -		 */
> +	unsigned long flags;
> +	int i;
> +	long mask;

long mask -> unsigned long mask


> +
> +/*
> + * Helper function for rcu_init() that initializes one rcu_state structure.
> + */
> +static void __init rcu_init_one(struct rcu_state *rsp)
> +{
> +	int i;
> +	int j;
> +	struct rcu_node *rnp;
> +
> +	/* Initialize the level-tracking arrays. */
> +
> +	for (i = 1; i < NUM_RCU_LVLS; i++) {
> +		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> +	}
> +	rcu_init_levelspread(rsp);
> +
> +	/* Initialize the elements themselves, starting from the leaves. */
> +
> +	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
> +		rnp = rsp->level[i];
> +		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
> +			spin_lock_init(&rnp->lock);
> +			rnp->qsmask = 0;
> +			rnp->grplo = j * rsp->levelspread[i];
> +			rnp->grphi = (j + 1) * rsp->levelspread[i] - 1;
> +			if (rnp->grphi >= rsp->levelcnt[i + 1])
> +				rnp->grphi = rsp->levelcnt[i + 1] - 1;
> +			rnp->qsmaskinit = 0;

if no other reason, I will init fields with the order as they are declared.

> +			if (i != NUM_RCU_LVLS - 1)
> +				rnp->grplo = rnp->grphi = 0;
> +			if (i == 0) {
> +				rnp->grpnum = 0;
> +				rnp->parent = NULL;
> +			} else {
> +				rnp->grpnum = j % rsp->levelspread[i - 1];
> +				rnp->parent = rsp->level[i - 1] + 
> +					      j / rsp->levelspread[i - 1];
> +			}
> +			rnp->level = i;
> +		}
> +	}
> +}
> +
> +/*
> + * Helper macro for rcu_init().  To be used nowhere else!

rcu_init -> __rcu_init

> + * Assigns leaf node pointers into each CPU's rcu_data structure.
> + */
> +#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
> +do { \
> +	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
> +	j = 0; \
> +	for_each_possible_cpu(i) { \
> +		if (i > rnp[j].grphi) \
> +			j++; \
> +		per_cpu(rcu_data, i).mynode = &rnp[j]; \
> +		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
> +	} \
> +} while (0)
> +
>  static struct notifier_block __cpuinitdata rcu_nb = {
>  	.notifier_call	= rcu_cpu_notify,
>  };
>  

