Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYINPOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYINPOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYINPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:14:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYINPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:14:22 -0400
Date: Sun, 14 Sep 2008 17:14:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080914151404.GA28850@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Frank Mayhar <fmayhar@google.com> wrote:

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h

> +/**
> + * thread_group_cputime_account_user - Maintain utime for a thread group.
> + *
> + * @tgtimes:	Pointer to thread_group_cputime structure.
> + * @cputime:	Time value by which to increment the utime field of that
> + *		structure.
> + *
> + * If thread group time is being maintained, get the structure for the
> + * running CPU and update the utime field there.
> + */
> +static inline void thread_group_cputime_account_user(
> +	struct thread_group_cputime *tgtimes,
> +	cputime_t cputime)
> +{
> +	if (tgtimes->totals) {
> +		struct task_cputime *times;
> +
> +		times = per_cpu_ptr(tgtimes->totals, get_cpu());
> +		times->utime = cputime_add(times->utime, cputime);
> +		put_cpu_no_resched();
> +	}
> +}
> +
> +/**
> + * thread_group_cputime_account_system - Maintain stime for a thread group.
> + *
> + * @tgtimes:	Pointer to thread_group_cputime structure.
> + * @cputime:	Time value by which to increment the stime field of that
> + *		structure.
> + *
> + * If thread group time is being maintained, get the structure for the
> + * running CPU and update the stime field there.
> + */
> +static inline void thread_group_cputime_account_system(
> +	struct thread_group_cputime *tgtimes,
> +	cputime_t cputime)
> +{
> +	if (tgtimes->totals) {
> +		struct task_cputime *times;
> +
> +		times = per_cpu_ptr(tgtimes->totals, get_cpu());
> +		times->stime = cputime_add(times->stime, cputime);
> +		put_cpu_no_resched();
> +	}
> +}
> +
> +/**
> + * thread_group_cputime_account_exec_runtime - Maintain exec runtime for a
> + *						thread group.
> + *
> + * @tgtimes:	Pointer to thread_group_cputime structure.
> + * @ns:		Time value by which to increment the sum_exec_runtime field
> + *		of that structure.
> + *
> + * If thread group time is being maintained, get the structure for the
> + * running CPU and update the sum_exec_runtime field there.
> + */
> +static inline void thread_group_cputime_account_exec_runtime(
> +	struct thread_group_cputime *tgtimes,
> +	unsigned long long ns)
> +{
> +	if (tgtimes->totals) {
> +		struct task_cputime *times;
> +
> +		times = per_cpu_ptr(tgtimes->totals, get_cpu());
> +		times->sum_exec_runtime += ns;
> +		put_cpu_no_resched();
> +	}
> +}

please uninline these functions.

	Ingo
