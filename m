Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZIHRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZIHRri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZIHRrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:47:37 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:50812 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZIHRrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:47:36 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC48B@exchange.ZeugmaSystems.local>
Date: Tue, 8 Sep 2009 10:41:38 -0700
Cc: Anirban Sinha <ani@anirban.org>, Anirban Sinha <ASinha@zeugmasystems.com>
Content-Transfer-Encoding: 7bit
Message-Id: <217247FB-ED91-4A24-B698-71CEEFA58636@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <DDFD17CC94A9BD49A82147DDF7D545C54DC48B@exchange.ZeugmaSystems.local>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Dario Faggioli <raistlin@linux.it>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-09-08, at 10:32 AM, Anirban Sinha wrote:

>
>
>
> -----Original Message-----
> From: Mike Galbraith [mailto:efault@gmx.de]
> Sent: Sat 9/5/2009 11:32 PM
> To: Anirban Sinha
> Cc: Lucas De Marchi; linux-kernel@vger.kernel.org; Peter Zijlstra;  
> Ingo Molnar
> Subject: Re: question on sched-rt group allocation cap:  
> sched_rt_runtime_us
>
> On Sat, 2009-09-05 at 19:32 -0700, Ani wrote:
> > On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com>  
> wrote:
> > >
> > > Indeed. I've tested this same test program in a single core  
> machine and it
> > > produces the expected behavior:
> > >
> > > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > > 95%                              4.48%
> > > 60%                              54.84%
> > > 50%                              86.03%
> > > 40%                              OTHER completed first
> > >
> >
> > Hmm. This does seem to indicate that there is some kind of
> > relationship with SMP. So I wonder whether there is a way to turn  
> this
> > 'RT bandwidth accumulation' heuristic off.
>
> No there isn't, but maybe there should be, since this isn't the first
> time it's come up.  One pro argument is that pinned tasks are  
> thoroughly
> screwed when an RT hog lands on their runqueue.  On the con side, the
> whole RT bandwidth restriction thing is intended (AFAIK) to allow an
> admin to regain control should RT app go insane, which the default 5%
> aggregate accomplishes just fine.
>
> Dunno.  Fly or die little patchlet (toss).

So it would be nice to have a knob like this when CGROUPS is disabled  
(it say 'say N  when unsure' :)). CPUSETS depends on CGROUPS.


>
> sched: allow the user to disable RT bandwidth aggregation.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>


Verified-by: Anirban Sinha <asinha@zeugmasystems.com>


> LKML-Reference: <new-submission>
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8736ba1..6e6d4c7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1881,6 +1881,7 @@ static inline unsigned int  
> get_sysctl_timer_migration(void)
>  #endif
>  extern unsigned int sysctl_sched_rt_period;
>  extern int sysctl_sched_rt_runtime;
> +extern int sysctl_sched_rt_bandwidth_aggregate;
>
>  int sched_rt_handler(struct ctl_table *table, int write,
>                 struct file *filp, void __user *buffer, size_t *lenp,
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c512a02..ca6a378 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -864,6 +864,12 @@ static __read_mostly int scheduler_running;
>   */
>  int sysctl_sched_rt_runtime = 950000;
>
> +/*
> + * aggregate bandwidth, ie allow borrowing from neighbors when
> + * bandwidth for an individual runqueue is exhausted.
> + */
> +int sysctl_sched_rt_bandwidth_aggregate = 1;
> +
>  static inline u64 global_rt_period(void)
>  {
>         return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 2eb4bd6..75daf88 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -495,6 +495,9 @@ static int balance_runtime(struct rt_rq *rt_rq)
>  {
>         int more = 0;
>
> +       if (!sysctl_sched_rt_bandwidth_aggregate)
> +               return 0;
> +
>         if (rt_rq->rt_time > rt_rq->rt_runtime) {
>                 spin_unlock(&rt_rq->rt_runtime_lock);
>                 more = do_balance_runtime(rt_rq);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index cdbe8d0..0ad08e5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -368,6 +368,14 @@ static struct ctl_table kern_table[] = {
>         },
>         {
>                 .ctl_name       = CTL_UNNUMBERED,
> +               .procname       = "sched_rt_bandwidth_aggregate",
> +               .data           =  
> &sysctl_sched_rt_bandwidth_aggregate,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = &sched_rt_handler,
> +       },
> +       {
> +               .ctl_name       = CTL_UNNUMBERED,
>                 .procname       = "sched_compat_yield",
>                 .data           = &sysctl_sched_compat_yield,
>                 .maxlen         = sizeof(unsigned int),
>
>
>
>

