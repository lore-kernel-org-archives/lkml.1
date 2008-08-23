Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYHWLd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYHWLd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 07:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYHWLdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 07:33:18 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:19822 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYHWLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 07:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SFrcbKuLI34o3oq56cz+fOP22uZwj/rlI2uqyY53/8/pNUibLp2PYts0mc5Uz24Puv
         bWyMRkG9AcRrHwH7rejSRevjrNTurFgXRcE9ShifCKvwwEJvTcEdZSA77FGuLeHSqNuE
         3l8EBz6YIuVPfp1c7s1iLuo+RSkLSzoxUz7wM=
Message-ID: <520f0cf10808230433o6bcb4d4foa8d73c641dcfa7f1@mail.gmail.com>
Date: Sat, 23 Aug 2008 13:33:15 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.26.3-rt3
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0808222134310.5686@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219441175.22710.22.camel@localhost.localdomain>
	 <520f0cf10808221639k5c58dcc1p36e85f4da8f025d1@mail.gmail.com>
	 <alpine.DEB.1.10.0808222123370.5290@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0808222134310.5686@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 3:36 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 22 Aug 2008, Steven Rostedt wrote:
>
>>
>>
>> On Sat, 23 Aug 2008, John Kacur wrote:
>> >
>> > One more patch that was missed - it was discussed here
>> > http://marc.info/?l=linux-rt-users&m=121846031913931&w=2
>> >
>> > I am resending it, please consider for -rt4.
>> > Without it I continue to get the following type of message.
>> >
>>
>> Actually this was left out intentionally. The quick fix would be the one
>> that Gregory Haskins suggested about not reporting when the task is bound
>> to one CPU. This bothers me a little, but is probably OK for now. A task
>> can still migrate from one cpu to another by the user, and this can cause
>> havic if a smp_processor_id is used.

Hmnn, the e-mail thread died out at that point and moved to IRC after
we released that
debug_smp_processor_id(void)
ALREADY had a check to see if the kernel thread was bound to a single
cpu. (see below)

	/*
	 * Kernel threads bound to a single CPU can safely use
	 * smp_processor_id():
	 */
	this_mask = cpumask_of_cpu(this_cpu);

	if (cpus_equal(current->cpus_allowed, this_mask))
		goto out;

I'm inclined to believe that the test is correct and we really were
calling smp_processor_id in preemptible code which is why I offered my
patch up again.

>>
>> I needed to examine this a bit closer before coming up with a proper fix.
>
>
> This patch below should be sufficient. I just changed your local_irqs_save
> to preempt_disabled: I have this queued for -rt4, but that is where I also

Ok, good, I'm running with your lighter weight patch to make sure that
it is sufficient. Thanks.

> plan on adding the latest ftrace updates so it may take a bit to get it
> out.
>
> -- Steve
>
>
> =======
> From: Steven Rostedt <srostedt@redhat.com>
> Subject: suppress warning of smp_processor_id use.
>
> John Kacur pointed out that the get_cpu_var used in net/sched/sch_generic.c
> would trigger warnings. This was happing on a statistic variable and
> by a softirq which is bound to a single thread.
>
> John sent a patch that used local_irq_save which is a little bit of
> overkill. This version uses preempt disable, but we still need to create
> a preempt_disable_rt API that is only activated when PREEMPT_RT is configured.
>

Could you perhaps leave in my original Signed-off-by: or at least convert it to
Debugged-by: John Kacur <jkacur at gmail dot com>

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  net/sched/sch_generic.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-2.6.26.3-rt3/net/sched/sch_generic.c
> ===================================================================
> --- linux-2.6.26.3-rt3.orig/net/sched/sch_generic.c     2008-08-22 21:28:50.000000000 -0400
> +++ linux-2.6.26.3-rt3/net/sched/sch_generic.c  2008-08-22 21:29:38.000000000 -0400
> @@ -112,7 +112,9 @@ static inline int handle_dev_cpu_collisi
>                 * Another cpu is holding lock, requeue & delay xmits for
>                 * some time.
>                 */
> +               preempt_disable(); /* FIXME: we need an _rt version of this */

I think you should drop the FIXME comment. The discussion was about
the debug version of smp_processor_id that is called via
__get_cpu_var() below, and it appears that it doesn't need any
fix-ups.
(Of course there is the chance that I misunderstood and you really do
mean some changes to preempt_disable() - let me know pls)

>                __get_cpu_var(netdev_rx_stat).cpu_collision++;
> +               preempt_enable();
>                ret = dev_requeue_skb(skb, dev, q);
>        }
>
>
