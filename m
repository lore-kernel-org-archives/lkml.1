Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbYI3GeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbYI3GeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYI3GeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:34:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51461 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYI3GeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:34:07 -0400
Date: Tue, 30 Sep 2008 08:33:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many
	thread hang.
Message-ID: <20080930063313.GA23690@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com> <20080916084143.GC17287@elte.hu> <1221678187.13420.17.camel@bobble.smo.corp.google.com> <20080918102353.GD20967@elte.hu> <1222114936.21579.20.camel@bobble.smo.corp.google.com> <1222291416.30299.6.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222291416.30299.6.camel@bobble.smo.corp.google.com>
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

>  /*
>   * Return any ns on the sched_clock that have not yet been banked in
>   * @p in case that task is currently running.
> - *
> - * Called with task_rq_lock() held on @rq.
>   */
> -static unsigned long long task_delta_exec(struct task_struct *p, struct rq *rq)
> +unsigned long long task_delta_exec(struct task_struct *p)
>  {
> +	struct rq *rq;
> +	unsigned long flags;
> +	u64 ns = 0;
> +
>  	if (task_current(rq, p)) {
>  		u64 delta_exec;

hmmm ... where do we get 'rq' from?

in v3 you did this:

-       rq = task_rq_lock(p, &flags);

which removed the deadlock but left us with a random uninitialized rq 
variable ...

the right solution for the bug would have been to unlock it. 
Miraculously we didnt actually crash anywhere visibly, found it by 
reviewing the code. I thought this code gets excercised quite 
frequently. The commit below fixes it.

Could you please functionality-test latest tip/master:

  http://people.redhat.com/mingo/tip.git/README

with your testcase that excercises these codepaths heavily?

Thanks,

	Ingo
