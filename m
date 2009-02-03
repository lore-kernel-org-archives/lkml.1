Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbZBCIti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbZBCIti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZBCIta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:49:30 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:40386 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZBCIt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:49:29 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v2] NOHZ: fix nohz on cpu unplug
Date: Tue, 3 Feb 2009 09:48:13 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200901301729.30284.borntraeger@de.ibm.com> <200902021323.44015.borntraeger@de.ibm.com> <1233619023.16238.12.camel@vayu>
In-Reply-To: <1233619023.16238.12.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030948.13519.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 03 February 2009 00:57:03 schrieb Suresh Siddha:
> Does this patch fix the issue? Thanks.

I fixed up a compile error. (See below). After that, the patch does indeed fix 
the problem.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>


> diff --git a/kernel/sched.c b/kernel/sched.c
> index 96439a4..8a0419b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4026,19 +4026,24 @@ int select_nohz_load_balancer(int stop_tick)
>  	int cpu = smp_processor_id();
>
>  	if (stop_tick) {
> -		cpumask_set_cpu(cpu, nohz.cpu_mask);
>  		cpu_rq(cpu)->in_nohz_recently = 1;
>
> -		/*
> -		 * If we are going offline and still the leader, give up!
> -		 */
> -		if (!cpu_active(cpu) &&
> -		    atomic_read(&nohz.load_balancer) == cpu) {
> +		if (!cpu_active(cpu) {

That does not compile...I used the following:
		if (!cpu_active(cpu)) {

> +			if (atomic_read(&nohz.load_balancer) != cpu)
> +				return 0;
> +
> +			/*
> +			 * If we are going offline and still the leader,
> +			 * give up!
> +			 */
>  			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
>  				BUG();
> +
>  			return 0;
>  		}
>
> +		cpumask_set_cpu(cpu, nohz.cpu_mask);
> +
>  		/* time for ilb owner also to sleep */
>  		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
>  			if (atomic_read(&nohz.load_balancer) == cpu)


