Return-Path: <linux-kernel-owner+w=401wt.eu-S1030242AbXCJJUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242AbXCJJUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766583AbXCJJUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:20:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33513 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030242AbXCJJTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:19:51 -0500
Date: Sat, 10 Mar 2007 10:19:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070310091942.GC18250@elte.hu>
References: <20070309193925.B60891B8028@attica.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309193925.B60891B8028@attica.americas.sgi.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed
> 
> Diffed against 2.6.21-rc3 (Andrew's current top of tree)

looks good to me.

Acked-by: Ingo Molnar <mingo@elte.hu>

> +	/* try to stay on the same cpuset */
> +	if (dest_cpu == NR_CPUS) {
> +		p->cpus_allowed = cpuset_cpus_allowed(p);
> +		dest_cpu = any_online_cpu(p->cpus_allowed);
> +	}

what's the practical effect of this - when moving the last CPU offline 
from a node you got jobs migrated to really alien nodes? Thus i think we 
should queue this up for v2.6.21 too, correct? It's a NOP on systems 
that do not set up cpusets, so it's low-risk.

btw., unrelated to your patch, there's this bit right after the code 
above:

        /* No more Mr. Nice Guy. */
        if (dest_cpu == NR_CPUS) {
                rq = task_rq_lock(p, &flags);
                cpus_setall(p->cpus_allowed);
                dest_cpu = any_online_cpu(p->cpus_allowed);

out of consistency, shouldnt the cpus_setall() rather be:

		p->cpus_allowed = cpu_possible_map;

? It shouldnt make any real difference but it looks more consistent.

	Ingo
