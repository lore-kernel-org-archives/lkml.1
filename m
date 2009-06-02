Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZFBH45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZFBH45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbZFBH4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:56:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732AbZFBH4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:56:49 -0400
Date: Tue, 2 Jun 2009 09:56:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Provide functions for locking and
	pinning the context for a task
Message-ID: <20090602075637.GB12411@elte.hu>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com> <18979.35192.995732.609215@cargo.ozlabs.ibm.com> <20090601162109.GA8459@elte.hu> <18980.19019.158462.125715@cargo.ozlabs.ibm.com> <20090601231428.GF749@elte.hu> <18980.47776.940214.789245@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18980.47776.940214.789245@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Yeah, indeed that box has a CPU hotplug testcase - sets cpu1 to 
> > offline then online.
> > 
> > There should be no counters active anywhere during that.
> 
> OK, I can't reproduce this on powerpc.  I guess you have dynamic 
> per-cpu patches in there, and per-cpu areas are getting 
> reinitialized when cpus come up.  That, combined with the fact 
> that the migration_notifier in kernel/sched.c puts itself at 
> priority 10, means that we're getting a call to 
> perf_counter_task_migration() for a newly-added CPU before 
> perf_cpu_notify() has been called for that CPU, and so we're 
> trying to use an uninitialized perf_cpu_context and we go boom.

Sounds very plausible.

> Could you try the same test with this patch?  If this fixes it, 
> then that's what the problem is.  It's up to you whether 
> increasing the priority on perf_cpu_nb is the right solution or 
> whether we should solve the problem some other way.
> 
> Paul.
> 
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -3902,8 +3902,12 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
>  	return NOTIFY_OK;
>  }
>  
> +/*
> + * This has to have a higher priority than migration_notifier in sched.c.
> + */
>  static struct notifier_block __cpuinitdata perf_cpu_nb = {
>  	.notifier_call		= perf_cpu_notify,
> +	.priority		= 20,
>  };

Makes sense. Mind doing a full patch with a changelog, and with a 
comment that explains what the priority rules are? Perhaps add a 
comment to the counterpart in sched.c too.

	Ingo
