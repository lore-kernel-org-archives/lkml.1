Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZJEHIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZJEHIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbZJEHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:08:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55245 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZJEHIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:08:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99B23.9090701@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 16:07:15 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the diff between Huang's original change and the result of changes
by my patch set.

I'll going to explain what I changed from the original.

> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 2d5c42a..4b5ef3c 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -52,7 +52,7 @@
>  #define MCE_INJ_NMI_BROADCAST	(1 << 2)	/* do NMI broadcasting */
>  #define MCE_INJ_EXCEPTION	(1 << 3)	/* raise as exception */
>  
> -/* Fields are zero when not available */
> +/* MCE log entry. Fields are zero when not available. */
>  struct mce {
>  	__u64 status;
>  	__u64 misc;
> @@ -63,12 +63,12 @@ struct mce {
>  	__u64 time;	/* wall time_t when error was detected */
>  	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
>  	__u8  inject_flags;	/* software inject flags */
> -	__u16  pad;
> +	__u16 pad;
>  	__u32 cpuid;	/* CPUID 1 EAX */
> -	__u8  cs;		/* code segment */
> +	__u8  cs;	/* code segment */
>  	__u8  bank;	/* machine check bank */
>  	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
> -	__u8  finished;   /* entry is valid */
> +	__u8  finished;	/* 1 if write to entry is finished & entry is valid */
>  	__u32 extcpu;	/* linux cpu number that detected the error */
>  	__u32 socketid;	/* CPU socket ID */
>  	__u32 apicid;	/* CPU initial apic ID */
> @@ -76,10 +76,9 @@ struct mce {
>  };
>  
>  /*
> - * This structure contains all data related to the MCE log.  Also
> - * carries a signature to make it easier to find from external
> - * debugging tools.  Each entry is only valid when its finished flag
> - * is set.
> + * This structure contains all data related to the MCE log.  Also carries
> + * a signature to make it easier to find from external debugging tools.
> + * Each entry is only valid when its finished flag is set.
>   */

Small clean up.

>  
>  #define MCE_LOG_LEN		32
> @@ -93,12 +92,18 @@ static inline int mce_log_index(int n)
>  struct mce_log_cpu;
>  
>  struct mce_log {
> -	char signature[12]; /* "MACHINECHEC2" */
> -	unsigned len;	    /* = MCE_LOG_LEN */
> -	unsigned flags;
> -	unsigned recordlen;	/* length of struct mce */
> -	unsigned nr_mcelog_cpus;
> +	char signature[12];		/* "MACHINECHEC2" */
> +
> +	/* points the table of per-CPU buffers */
>  	struct mce_log_cpu **mcelog_cpus;
> +	unsigned int nr_mcelog_cpus;	/* = num_possible_cpus() */
> +
> +	/* spec of per-CPU buffer */
> +	unsigned int header_len; 	/* offset of array "entry" */
> +	unsigned int nr_record;		/* array size (= MCE_LOG_LEN) */
> +	unsigned int record_len;	/* length of struct mce */
> +
> +	unsigned flags;
>  };

Add a member header_len, and renamed "len" to "nr_record" which is easier
to understand.  Please refer the description of patch 6/10.

>  
>  #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 5db3f5b..fad3daa 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -122,54 +122,53 @@ EXPORT_PER_CPU_SYMBOL_GPL(mce_fake_banks);
>   * separate MCEs from kernel messages to avoid bogus bug reports.
>   */
>  
> -static struct mce_log mcelog = {
> -	.signature	= MCE_LOG_SIGNATURE,
> -	.len		= MCE_LOG_LEN,
> -	.recordlen	= sizeof(struct mce),
> -};
> -
>  struct mce_log_cpu {
>  	int head;
>  	int tail;
> -	unsigned long flags;
>  	struct mce entry[MCE_LOG_LEN];
>  };

Removed "flags" from per-CPU structure since mce_ioctl only cares global flags
in struct mce_log.

>  
>  DEFINE_PER_CPU(struct mce_log_cpu, mce_log_cpus);
>  
> +static struct mce_log mcelog = {
> +	.signature	= MCE_LOG_SIGNATURE,
> +	.header_len	= offsetof(struct mce_log_cpu, entry),
> +	.nr_record	= MCE_LOG_LEN,
> +	.record_len	= sizeof(struct mce),
> +};
> +
>  void mce_log(struct mce *mce)
>  {
>  	struct mce_log_cpu *mcelog_cpu = &__get_cpu_var(mce_log_cpus);
>  	int head, ihead, tail, next;
>  
> +	/* mce->finished must be set to 0 before written to buffer */
>  	mce->finished = 0;
> -	/*
> -	 * mce->finished must be set to 0 before written to ring
> -	 * buffer
> -	 */
>  	smp_wmb();
> +
>  	do {
>  		head = mcelog_cpu->head;
>  		tail = mcelog_cpu->tail;
>  		ihead = mce_log_index(head);
> +
>  		/*
>  		 * When the buffer fills up discard new entries.
>  		 * Assume that the earlier errors are the more
>  		 * interesting.
>  		 */
>  		if (ihead == mce_log_index(tail) && head != tail) {
> -			set_bit(MCE_OVERFLOW, &mcelog_cpu->flags);
> +			set_bit(MCE_OVERFLOW, (unsigned long *)&mcelog.flags);

Use global flags which is cared by mce_ioctl.

>  			return;
>  		}
>  		next = head == MCE_LOG_LIMIT ? 0 : head + 1;
>  	} while (cmpxchg_local(&mcelog_cpu->head, head, next) != head);
> +
>  	memcpy(mcelog_cpu->entry + ihead, mce, sizeof(struct mce));
> -	/*
> -	 * ".finished" of MCE record in ring buffer must be set after
> -	 * copy
> -	 */
> +
> +	/* ".finished" of MCE record in buffer must be set after copy */
>  	smp_wmb();
>  	mcelog_cpu->entry[ihead].finished = 1;
> +
>  	/* bit 0 of notify_user should be set after finished be set */
>  	smp_wmb();
>  	mce->finished = 1;


Changes from here to ....

> @@ -1195,19 +1194,40 @@ int mce_notify_irq(void)
>  }
>  EXPORT_SYMBOL_GPL(mce_notify_irq);
>  
> -static int mce_banks_init(void)
> +static __cpuinit int mce_banks_init(void)
>  {
>  	int i;
>  
>  	mce_banks = kzalloc(banks * sizeof(struct mce_bank), GFP_KERNEL);
>  	if (!mce_banks)
>  		return -ENOMEM;
> +
>  	for (i = 0; i < banks; i++) {
>  		struct mce_bank *b = &mce_banks[i];
>  
>  		b->ctl = -1ULL;
>  		b->init = 1;
>  	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Initialize MCE per-CPU log buffer
> + */
> +static __cpuinit int mce_log_init(void)
> +{
> +	int cpu;
> +
> +	mcelog.nr_mcelog_cpus = num_possible_cpus();
> +	mcelog.mcelog_cpus = kzalloc(sizeof(void *) * num_possible_cpus(),
> +				     GFP_KERNEL);
> +	if (!mcelog.mcelog_cpus)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu)
> +		mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
> +
>  	return 0;
>  }
>  
> @@ -1234,6 +1254,7 @@ static int __cpuinit mce_cap_init(void)
>  	/* Don't support asymmetric configurations today */
>  	WARN_ON(banks != 0 && b != banks);
>  	banks = b;
> +
>  	if (!mce_banks) {
>  		int err = mce_banks_init();
>  
> @@ -1241,6 +1262,13 @@ static int __cpuinit mce_cap_init(void)
>  			return err;
>  	}
>  
> +	if (!mcelog.mcelog_cpus) {
> +		int err = mce_log_init();
> +
> +		if (err)
> +			return err;
> +	}
> +
>  	/* Use accurate RIP reporting if available. */
>  	if ((cap & MCG_EXT_P) && MCG_EXT_CNT(cap) >= 9)
>  		rip_msr = MSR_IA32_MCG_EIP;
> @@ -1251,22 +1279,6 @@ static int __cpuinit mce_cap_init(void)
>  	return 0;
>  }
>  
> -/*
> - * Initialize MCE per-CPU log buffer
> - */
> -static __cpuinit void mce_log_init(void)
> -{
> -	int cpu;
> -
> -	if (mcelog.mcelog_cpus)
> -		return;
> -	mcelog.nr_mcelog_cpus = num_possible_cpus();
> -	mcelog.mcelog_cpus = kzalloc(sizeof(void *) * num_possible_cpus(),
> -				     GFP_KERNEL);
> -	for_each_possible_cpu(cpu)
> -		mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
> -}
> -
>  static void mce_init(void)
>  {
>  	mce_banks_t all_banks;
> @@ -1437,7 +1449,6 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
>  		mce_disabled = 1;
>  		return;
>  	}
> -	mce_log_init();
>  
>  	machine_check_vector = do_machine_check;
>  

... here are what done in patch 10/10.

> @@ -1486,15 +1497,14 @@ static int mce_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static ssize_t mce_read_cpu(struct mce_log_cpu *mcelog_cpu,
> -			    char __user *inubuf, size_t usize)
> +static ssize_t mce_read_cpu(int cpu, char __user *inubuf, size_t usize)
>  {
> +	struct mce_log_cpu *mcelog_cpu = &per_cpu(mce_log_cpus, cpu);

Changed 1st arg to cpu number.

>  	char __user *ubuf = inubuf;
>  	int head, tail, pos, i, err = 0;
>  
>  	head = mcelog_cpu->head;
>  	tail = mcelog_cpu->tail;
> -
>  	if (head == tail)
>  		return 0;
>  
> @@ -1503,13 +1513,14 @@ static ssize_t mce_read_cpu(struct mce_log_cpu *mcelog_cpu,
>  		i = mce_log_index(pos);
>  		if (!mcelog_cpu->entry[i].finished) {
>  			int timeout = WRITER_TIMEOUT_NS;
> +
>  			while (!mcelog_cpu->entry[i].finished) {
>  				if (timeout-- <= 0) {
>  					memset(mcelog_cpu->entry + i, 0,
>  					       sizeof(struct mce));
>  					head = mcelog_cpu->head;
>  					printk(KERN_WARNING "mcelog: timeout "
> -					       "waiting for writer to finish!\n");
> +					     "waiting for writer to finish!\n");
>  					goto timeout;
>  				}
>  				ndelay(1);
> @@ -1538,11 +1549,6 @@ timeout:
>  	return err ? -EFAULT : ubuf - inubuf;
>  }
>  
> -static int mce_empty_cpu(struct mce_log_cpu *mcelog_cpu)
> -{
> -	return mcelog_cpu->head == mcelog_cpu->tail;
> -}
> -
>  static int mce_empty(void)
>  {
>  	int cpu;
> @@ -1550,33 +1556,34 @@ static int mce_empty(void)
>  
>  	for_each_possible_cpu(cpu) {
>  		mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
> -		if (!mce_empty_cpu(mcelog_cpu))
> +		if (mcelog_cpu->head != mcelog_cpu->tail)

Inlined.  Or it would be better to have static inlines in header file.

>  			return 0;
>  	}
>  	return 1;
>  }
>  
> +static DEFINE_MUTEX(mce_read_mutex);
> +
>  static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
>  			loff_t *off)
>  {
>  	char __user *ubuf = inubuf;
> -	struct mce_log_cpu *mcelog_cpu;
> -	int cpu, new_mce, err = 0;
> -	static DEFINE_MUTEX(mce_read_mutex);
> +	int cpu, err = 0;
> +
> +	/* Only supports full reads right now */
> +	if (*off != 0 || usize < sizeof(struct mce))
> +		return -EINVAL;

Picked up what implicitly dropped.

>  
>  	mutex_lock(&mce_read_mutex);
> -	do {
> -		new_mce = 0;
> +
> +	while (!mce_empty()) {
>  		for_each_possible_cpu(cpu) {
>  			if (usize < sizeof(struct mce))
>  				goto out;
> -			mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
> -			err = mce_read_cpu(mcelog_cpu, ubuf,
> -					   sizeof(struct mce));
> +			err = mce_read_cpu(cpu, ubuf, sizeof(struct mce));
>  			if (err > 0) {
>  				ubuf += sizeof(struct mce);
>  				usize -= sizeof(struct mce);
> -				new_mce = 1;
>  				err = 0;
>  			} else if (err < 0)
>  				goto out;
> @@ -1586,9 +1593,10 @@ static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
>  			cond_resched();
>  			mutex_lock(&mce_read_mutex);
>  		}
> -	} while (new_mce || !mce_empty());
> +	}

I could not catch the intent of "new_mce," so replaced do-while by
simple while statement.

>  out:
>  	mutex_unlock(&mce_read_mutex);
> +
>  	return err ? err : ubuf - inubuf;
>  }
>  

That's all.

Thanks,
H.Seto

