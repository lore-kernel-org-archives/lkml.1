Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZBBJ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZBBJ66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBBJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:58:50 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44950 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZBBJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:58:49 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH/RFC] NOHZ: fix nohz on cpu unplug
Date: Mon, 2 Feb 2009 10:58:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, Siddha@cborntra,
       Suresh B <suresh.b.siddha@intel.com>
References: <200901301729.30284.borntraeger@de.ibm.com>
In-Reply-To: <200901301729.30284.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021058.45230.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a reminder mail. I still dont know if my fix is correct, although
it seems to work..
I also CCed: Siddha, Suresh B <suresh.b.siddha@intel.com>

> Ingo, Thomas,
>
> After using cpu unplug I have seen one cpu with enabled ticks on s390,
> even on a idle systems. It turned out that nohz.cpu_mask is not
> updated on cpu unplug.
> In select_nohz_load_balancer we check if the system is completely
> idle to turn of load balancing. We compare the weights of
> cpu_online_map with nohz.cpu_mask.
> Since cpu_online_map is updated on cpu unplug, but nohz.cpu_mask is
> not, the check fails and the scheduler believes that we need an
> "idle load balancer" even on a fully idle system. Since the ilb
> cpu does not deactivate the timer tick this "breaks" NOHZ.
>
> One possible fix is to only add the cpu to the nohz.cpu_mask,
> if the cpu is active.
>
> The alternative is to add nohz.cpu_mask in the cpu hotplug path.
>
> This patch seems to work on s390 (Shortly tested with kvm guests
> with cpu hotplug and kvm_stat on the host), but I want to hear your
> opinion.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  kernel/sched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: kvm/kernel/sched.c
> ===================================================================
> --- kvm.orig/kernel/sched.c
> +++ kvm/kernel/sched.c
> @@ -3880,7 +3880,8 @@ int select_nohz_load_balancer(int stop_t
>  	int cpu = smp_processor_id();
>
>  	if (stop_tick) {
> -		cpumask_set_cpu(cpu, nohz.cpu_mask);
> +		if (cpu_active(cpu))
> +			cpumask_set_cpu(cpu, nohz.cpu_mask);
>  		cpu_rq(cpu)->in_nohz_recently = 1;
>
>  		/*


