Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZFEHCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZFEHCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZFEHCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:02:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33726 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZFEHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:02:00 -0400
Message-ID: <4A28C2E2.4090309@jp.fujitsu.com>
Date: Fri, 05 Jun 2009 16:01:54 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Re-implement MCE log ring buffer as per-CPU ring buffer for better
> scalability. Basic design is as follow:

That would be great.  This should be in .31, I think.

Some minor points:

>  struct mce_log {
> -	char signature[12]; /* "MACHINECHECK" */
> +	char signature[12]; /* "MACHINECHEC2" */
>  	unsigned len;	    /* = MCE_LOG_LEN */
> -	unsigned next;
>  	unsigned flags;
>  	unsigned pad0;
> -	struct mce entry[MCE_LOG_LEN];
> +	struct mce_log_cpu *mcelog_cpus;
>  };

What is this *mcelog_cpus to be used for?
It seems it will point one of per-CPU buffers (maybe cpu#0's buffer)
if I have read the following mce_log_init() correctly.

> @@ -642,6 +669,16 @@ static int mce_cap_init(void)
>  	return 0;
>  }
>  
> +/*
> + * Initialize MCE per-CPU log buffer
> + */
> +static __cpuinit void mce_log_init(void)
> +{
> +	if (mcelog.mcelog_cpus)
> +		return;
> +	mcelog.mcelog_cpus = &per_cpu_var(mce_log_cpus);
> +}
> +
>  static void mce_init(void)
>  {
>  	mce_banks_t all_banks;


Next,

> +static int mce_empty_cpu(struct mce_log_cpu *mcelog_cpu)
> +{
> +	int head, tail;
> +	head = mcelog_cpu->head;
> +	tail = mcelog_cpu->tail;
> +	return head == tail;
> +}

Are there any race condition?
Why we cannot have "return (mcelog_cpu->head == mcelog_cpu->tail);"?


Last,

> +static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
> +			loff_t *off)
> +{
> +	char __user *ubuf = inubuf;
> +	struct mce_log_cpu *mcelog_cpu;
> +	int cpu, new_mce, err = 0;
> +	static DEFINE_MUTEX(mce_read_mutex);
> +
(snip)
> +	return err ? : ubuf - inubuf;
>  }

It would be better to put "static DEFINE_MUTEX(mce_read_mutex)" to outside of
the function.

And it looks work, but I'd prefer:
	return err ? err : ubuf - inubuf;


Overall it looks good.
Unfortunately there were updates on tip/mce3 so I could not apply this
patch on the top of the branch.  I'd appreciate it if you could rebase
this patch again.


Thanks,
H.Seto

