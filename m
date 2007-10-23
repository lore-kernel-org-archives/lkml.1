Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbXJWDSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbXJWDSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXJWDR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:17:58 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51716 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbXJWDR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:17:58 -0400
Message-ID: <471D67B5.1020802@linux.vnet.ibm.com>
Date: Tue, 23 Oct 2007 08:47:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
References: <471D4523.4040509@google.com>
In-Reply-To: <471D4523.4040509@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Report CPU usage in CFS Cgroup directories
> 
> Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
> milliseconds for that cgroup's tasks
> 
> This replaces the "example CPU Accounting CGroup subsystem" that
> was merged into mainline last week.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> kernel/sched.c |   32 +++++++++++++++++++++++++++-----
> 1 file changed, 27 insertions(+), 5 deletions(-)
> 
> Index: container-2.6.23-mm1/kernel/sched.c
> ===================================================================
> --- container-2.6.23-mm1.orig/kernel/sched.c
> +++ container-2.6.23-mm1/kernel/sched.c
> @@ -7005,15 +7005,37 @@ static u64 cpu_shares_read_uint(struct c
>     return (u64) tg->shares;
> }
> 
> -static struct cftype cpu_shares = {
> -    .name = "shares",
> -    .read_uint = cpu_shares_read_uint,
> -    .write_uint = cpu_shares_write_uint,
> +static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +    struct task_group *tg = cgroup_tg(cgrp);
> +    int i;
> +    u64 res = 0;
> +    for_each_possible_cpu(i) {
> +        unsigned long flags;
> +        spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);
> +        res += tg->se[i]->sum_exec_runtime;
> +        spin_unlock_irqrestore(&tg->cfs_rq[i]->rq->lock, flags);
> +    }
> +    /* Convert from ns to ms */
> +    do_div(res, 1000000);
> +    return res;
> +}
> +

I think we also need the notion of load, like we have in cpu_acct.c
Don't we need to do a css_get() on the cgrp to ensure that the cgroup
does not go away if it's empty and someone does an rmdir on it?


> +static struct cftype cpu_files[] = {
> +    {
> +        .name = "shares",
> +        .read_uint = cpu_shares_read_uint,
> +        .write_uint = cpu_shares_write_uint,
> +    },
> +    {
> +        .name = "usage",
> +        .read_uint = cpu_usage_read,
> +    },
> };
> 
> static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup
> *cont)
> {
> -    return cgroup_add_file(cont, ss, &cpu_shares);
> +    return cgroup_add_files(cont, ss, cpu_files, ARRAY_SIZE(cpu_files));
> }
> 
> struct cgroup_subsys cpu_cgroup_subsys = {


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
