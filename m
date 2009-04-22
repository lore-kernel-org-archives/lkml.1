Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZDVLM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZDVLM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZDVLMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:12:07 -0400
Received: from mga07.intel.com ([143.182.124.22]:17216 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbZDVLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,230,1239001200"; 
   d="scan'208";a="134392591"
Message-ID: <49EEFB7E.4020605@linux.intel.com>
Date: Wed, 22 Apr 2009 13:11:58 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:

Basic concept is good and it fixes some long standing problems.

But some details need to be improved I think:

> +/*
> + * Initialize MCE per-CPU log buffer
> + */
> +static void mce_log_init(void)
> +{
> +	int cpu;
> +	struct mce_log_cpu *mcelog_cpu;
> +
> +	if (mcelog.log_cpus)
> +		return;
> +	mcelog.log_cpus = kmalloc(num_possible_cpus() * sizeof(mcelog_cpu),
> +				  GFP_KERNEL);
> +	for_each_possible_cpu(cpu) {
> +		mcelog_cpu = &per_cpu(mcelog_cpus, cpu);
> +		mcelog.log_cpus[cpu] = mcelog_cpu;
> +	}

I don't understand why the separate allocation. Can't you just put
the whole log buffer directly into the per cpu data?

This would also make the initialization cleaner because you would need to only
initialize state for the currently initialized CPU.


> +			while (!mcelog_cpu->entry[i].finished) {
> +				rdtscll(now);
> +				if (now - start > WRITER_TIMEOUT_CYC) {
> +					memset(mcelog_cpu->entry + i, 0,
>  					       sizeof(struct mce));
> +					head = mcelog_cpu->head;
>  					goto timeout;

This timeout should be reported somehow, perhaps with a printk.
Also it's problematic to hardcode cycles here, i think it would
be better to use a similar scheme as the Monarch timeout
with a ndelay() and a spinunit. That is guaranteed to stay
the same even as CPU frequencies change.

> +static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
> +			loff_t *off)
> +{
> +	char __user *ubuf = inubuf;
> +	struct mce_log_cpu *mcelog_cpu;
> +	int cpu, new_mce, err = 0;
> +	static DEFINE_MUTEX(mce_read_mutex);
> +	size_t usize_limit;
> +
> +	/* Too large user buffer size may cause system not response */

Did you understand why that happens? It's worrying.

> +static ssize_t show_log_flags(struct sys_device *s,
> +			      struct sysdev_attribute *attr,
> +			      char *buf)
> +{
> +	int cpu = s->id;
> +	struct mce_log_cpu *mcelog_cpu = &per_cpu(mcelog_cpus, cpu);
> +	unsigned flags;
> +	do {
> +		flags = mcelog_cpu->flags;
> +	} while (cmpxchg((unsigned *)&mcelog_cpu->flags, flags, 0) != flags);
> +	return sprintf(buf, "0x%x\n", flags);
> +}
> +
>  static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
>  static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
>  ACCESSOR(check_interval,check_interval,mce_restart())
> +static SYSDEV_ATTR(log_flags, 0644, show_log_flags, NULL);

Do we really need that interface? It seems rather obscure.
mcelog should get these flags anyways. Better to drop it.

-Andi
