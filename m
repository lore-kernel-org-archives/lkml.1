Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZFVPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZFVPfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZFVPfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:35:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZFVPfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:35:33 -0400
Date: Mon, 22 Jun 2009 17:35:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at
	source code level
Message-ID: <20090622153522.GB18466@elte.hu>
References: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp> <tip-d11ad9b3631b942b0d2e5b754a6c62158efb799f@git.kernel.org> <20090617163111.GA16128@elte.hu> <20090618.191448.886429908004553840.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618.191448.886429908004553840.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
> Date: Wed, 17 Jun 2009 18:31:11 +0200
> 
> > ition: inline
> > Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
> > From: Ingo Molnar <mingo@elte.hu>
> > To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
> > 	mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de
> > Cc: linux-tip-commits@vger.kernel.org
> > Date: Wed, 17 Jun 2009 18:31:11 +0200
> > User-Agent: Mutt/1.5.18 (2008-05-17)
> > Received-SPF: neutral (mx2.mail.elte.hu: 157.181.1.14 is neither permitted nor denied by domain of elte.hu) client-ip=157.181.1.14; envelope-from=mingo@elte.hu; helo=elvis.elte.hu;
> > X-Mew: tab/spc characters on Subject: are simplified.
> > 
> > 
> > * tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -6630,7 +6630,7 @@ EXPORT_SYMBOL(yield);
> > >   */
> > >  void __sched io_schedule(void)
> > >  {
> > > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > > +	struct rq *rq = this_rq();
> > >  
> > >  	delayacct_blkio_start();
> > >  	atomic_inc(&rq->nr_iowait);
> > > @@ -6642,7 +6642,7 @@ EXPORT_SYMBOL(io_schedule);
> > >  
> > >  long __sched io_schedule_timeout(long timeout)
> > >  {
> > > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > > +	struct rq *rq = this_rq();
> > >  	long ret;
> > 
> > I removed these two changes. Did you notice the __raw prefix?
> > 
> > 	Ingo
> > 
> 
> Thanks for your fix, I didn't notice...
> I wrote a patch to fix these two points.
> 
> After applying this patch,
> all direct reference to runqueues is in macros. How is this?
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8ec9d13..e2ca8c1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
>  #define this_rq()		(&__get_cpu_var(runqueues))
>  #define task_rq(p)		cpu_rq(task_cpu(p))
>  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> +#define raw_rq()		(&__raw_get_cpu_var(runqueues))
>  
>  inline void update_rq_clock(struct rq *rq)
>  {
> @@ -6625,7 +6626,7 @@ EXPORT_SYMBOL(yield);
>   */
>  void __sched io_schedule(void)
>  {
> -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> +	struct rq *rq = raw_rq();
>  
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> @@ -6637,7 +6638,7 @@ EXPORT_SYMBOL(io_schedule);
>  
>  long __sched io_schedule_timeout(long timeout)
>  {
> -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> +	struct rq *rq = raw_rq();
>  	long ret;
>  
>  	delayacct_blkio_start();

Looks good - mind submitting a separate patch with a changelog, etc?

	Ingo
