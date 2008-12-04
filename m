Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYLDFgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYLDFgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYLDFgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:36:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51896 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYLDFgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:36:01 -0500
Message-ID: <49376BE3.1040909@cn.fujitsu.com>
Date: Thu, 04 Dec 2008 13:34:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] export percpu cpuacct cgroup stats
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
In-Reply-To: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I guess it's more appropriate to ask Ingo to pick up this patch)

Ken Chen wrote:
> This patch export per-cpu CPU cycle usage for a given cpuacct cgroup.
> There is a need for a user space monitor daemon to track group CPU
> usage on per-cpu base.  It is also useful for monitor CFS load
> balancer behavior by tracking per CPU group usage.
> 
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b7480fb..cd78948 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9345,12 +9345,34 @@ out:
>  	return err;
>  }
> 
> +static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
> +				   struct seq_file *m)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgroup);
> +	u64 percpu;
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		spin_lock_irq(&cpu_rq(i)->lock);
> +		percpu = *percpu_ptr(ca->cpuusage, i);
> +		spin_unlock_irq(&cpu_rq(i)->lock);
> +		seq_printf(m, "%lld ", percpu);

Should be %llu. And if we don't cast percpu to unsigned long long, will it trigger
compile warning in some archs?

> +	}
> +	seq_printf(m, "\n");
> +	return 0;
> +}
> +
>  static struct cftype files[] = {
>  	{
>  		.name = "usage",
>  		.read_u64 = cpuusage_read,
>  		.write_u64 = cpuusage_write,
>  	},
> +	{
> +		.name = "percpu",

IMO percpu_usage is a better name.

> +		.read_seq_string = cpuacct_percpu_seq_read,
> +	},
> +
>  };
> 
