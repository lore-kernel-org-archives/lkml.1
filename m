Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYJYPjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYJYPjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 11:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJYPjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 11:39:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYJYPi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 11:38:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=TidqBoH6IUCINMnKxjhxWrRT/p1LdW1IGkKVtpnpo6cot3zOcL5uR7t4zIWqtNAws
	OA6/1FMcLd23C0m4nw96w==
Message-ID: <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
Date: Sat, 25 Oct 2008 08:38:52 -0700
From: "Paul Menage" <menage@google.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting controller
Cc: linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081025060157.GA4614@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023054335.GC3280@in.ibm.com>
	 <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
	 <20081024050830.GA4387@in.ibm.com>
	 <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	 <20081025060157.GA4614@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 11:01 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
>
> Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

Reviewed-by: Paul Menage <menage@google.com>

So in technical terms this patch looks fine now. There's still the
question of whether it's OK to change the existing API, since it's
been in the kernel in its currently (non-hierarchical) form for
several releases now.

> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Paul Menage <menage@google.com>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> ---
>  kernel/sched.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9131,6 +9131,7 @@ struct cpuacct {
>        struct cgroup_subsys_state css;
>        /* cpuusage holds pointer to a u64-type object on every cpu */
>        u64 *cpuusage;
> +       struct cpuacct *parent;
>  };
>
>  struct cgroup_subsys cpuacct_subsys;
> @@ -9164,6 +9165,9 @@ static struct cgroup_subsys_state *cpuac
>                return ERR_PTR(-ENOMEM);
>        }
>
> +       if (cgrp->parent)
> +               ca->parent = cgroup_ca(cgrp->parent);
> +
>        return &ca->css;
>  }
>
> @@ -9243,14 +9247,16 @@ static int cpuacct_populate(struct cgrou
>  static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>  {
>        struct cpuacct *ca;
> +       int cpu;
>
>        if (!cpuacct_subsys.active)
>                return;
>
> +       cpu = task_cpu(tsk);
>        ca = task_ca(tsk);
> -       if (ca) {
> -               u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
>
> +       for (; ca; ca = ca->parent) {
> +               u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>                *cpuusage += cputime;
>        }
>  }
>
