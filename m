Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXFLCSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXFLCSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbXFLCSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:18:13 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:37212 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXFLCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:18:12 -0400
Message-ID: <466E0224.2090405@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2007 07:47:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       wli@holomorphy.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       efault@gmx.de, pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, dmitry.adamushko@gmail.com,
       tingy@cs.umass.edu, tong.n.li@intel.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ckrm-tech] [RFC][PATCH 2/6] task's cpu information needs to
 be always correct
References: <20070611154724.GA32435@in.ibm.com> <20070611155212.GB2109@in.ibm.com>
In-Reply-To: <20070611155212.GB2109@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> We rely very much on task_cpu(p) to be correct at all times, so that we
> can correctly find the runqueue from which the task has to be removed or
> added to.
> 
> There is however one place in the scheduler where this assumption of
> task_cpu(p) being correct is broken. This patch fixes that piece of
> code.
> 
> (Thanks to Balbir Singh for pointing this out to me)
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

> ---
>  kernel/sched.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> Index: current/kernel/sched.c
> ===================================================================
> --- current.orig/kernel/sched.c	2007-06-09 15:07:17.000000000 +0530
> +++ current/kernel/sched.c	2007-06-09 15:07:32.000000000 +0530
> @@ -4624,7 +4624,7 @@
>  static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>  {
>  	struct rq *rq_dest, *rq_src;
> -	int ret = 0;
> +	int ret = 0, on_rq;
> 
>  	if (unlikely(cpu_is_offline(dest_cpu)))
>  		return ret;
> @@ -4640,9 +4640,11 @@
>  	if (!cpu_isset(dest_cpu, p->cpus_allowed))
>  		goto out;
> 
> -	set_task_cpu(p, dest_cpu);
> -	if (p->se.on_rq) {
> +	on_rq = p->se.on_rq;
> +	if (on_rq)
>  		deactivate_task(rq_src, p, 0);
> +	set_task_cpu(p, dest_cpu);
> +	if (on_rq) {
>  		activate_task(rq_dest, p, 0);
>  		check_preempt_curr(rq_dest, p);
>  	}


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
