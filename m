Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbYCGFCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbYCGFCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbYCGFCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:02:33 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:46528 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbYCGFCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:02:31 -0500
Date: Fri, 7 Mar 2008 10:30:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Message-ID: <20080307050039.GB11805@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	vatsa@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
References: <20080229043242.110741439@linux.vnet.ibm.com> <20080229043751.555866685@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080229043751.555866685@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dhaval Giani <dhaval@linux.vnet.ibm.com> [2008-02-29 10:02:44]:

> Currently the schedstats implementation does not allow the statistics
> to be reset. This patch aims to allow that.
> 
> echo 0 > cpuacct.usage
> 
> resets the usage. Any other value is not allowed and returns -EINVAL.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  kernel/sched.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c	2008-02-28 20:05:27.000000000 +0530
> +++ linux-2.6/kernel/sched.c	2008-02-28 20:05:30.000000000 +0530
> @@ -8243,10 +8243,34 @@ static u64 cpuusage_read(struct cgroup *
>  	return totalcpuusage;
>  }
> 
> +static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
> +								u64 reset)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int err = 0;
> +	int i;
> +
> +	if (reset) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +

Why not use

        if (reset)
                return -EINVAL;


> +	for_each_possible_cpu(i) {
> +		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
> +
> +		spin_lock_irq(&cpu_rq(i)->lock);
> +		*cpuusage = 0;
> +		spin_unlock_irq(&cpu_rq(i)->lock);
> +	}
> +out:
> +	return err;
> +}
> +
>  static struct cftype files[] = {
>  	{
>  		.name = "usage",
>  		.read_uint = cpuusage_read,
> +		.write_uint = cpuusage_write,
>  	},
>  };
> 
> 

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
