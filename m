Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZAEHr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZAEHr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZAEHrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:47:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbZAEHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:47:19 -0500
Date: Sun, 4 Jan 2009 23:46:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] cpuset: don't allocate trial cpuset on stack
Message-Id: <20090104234659.19e62245.akpm@linux-foundation.org>
In-Reply-To: <495B2F19.7040806@cn.fujitsu.com>
References: <495B2EA6.7010808@cn.fujitsu.com>
	<495B2EC2.9090305@cn.fujitsu.com>
	<495B2EE7.4040406@cn.fujitsu.com>
	<495B2EFB.302@cn.fujitsu.com>
	<495B2F19.7040806@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 16:36:41 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Impact: cleanups, reduce stack usage
> 
> This patch prepares for the next patch. When we convert cpuset.cpus_allowed
> to cpumask_var_t, (trialcs = *cs) no longer works.
> 
> Another result of this patch is reducing stack usage of trialcs. sizeof(*cs)
> can be as large as 148 bytes on x86_64, so it's really not good to have it
> on stack.
> 

err, what?

> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -415,6 +415,24 @@ static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
>  		is_mem_exclusive(p) <= is_mem_exclusive(q);
>  }
>  
> +/**
> + * alloc_trial_cpuset - allocate a trial cpuset
> + * @cs: the cpuset that the trial cpuset duplicates
> + */
> +static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
> +{
> +	return kmemdup(cs, sizeof(*cs), GFP_KERNEL);
> +}

We copy a cpuset by value?

> -static int update_cpumask(struct cpuset *cs, const char *buf)
> +static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
> +			  const char *buf)
>  {
>  	struct ptr_heap heap;
> -	struct cpuset trialcs;
>  	int retval;
>  	int is_load_balanced;
>  
> @@ -891,8 +909,6 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
>  	if (cs == &top_cpuset)
>  		return -EACCES;
>  
> -	trialcs = *cs;

Yes, we already do.

That thing contains spinlocks and list_heads (at least), which cannot
be copied in this way.

Seems that we're doing this gross thing because it just so happens that
we only use the cpus_allowed and mems_allowed fields, and because
several of the called functions require a cpuset*, but only needed a
cpumask_t.

How perfectly beastly.

