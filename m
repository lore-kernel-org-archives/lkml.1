Return-Path: <linux-kernel-owner+w=401wt.eu-S1763905AbYBTOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763905AbYBTOVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763328AbYBTOU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:20:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:46697 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763303AbYBTOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MjLJDG261QaxLD9Rj3vikhsTHKrtiPbi5/DqEHXLpnOKxLib/5OZCdRJBmpLH7h73IKFtZei78WvoIlZSfLfqquqfhMlGLPGNbnV91XngZ+5lXqhaetWzmd8GDdhp+13VgNLBg4ASXnbohcnj1J25yLPRmz7Ij4T2S8LqGuMeoc=
Message-ID: <b647ffbd0802200620h4015ca78o2482429b4502510a@mail.gmail.com>
Date: Wed, 20 Feb 2008 15:20:52 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH] Tasklets: Avoid duplicating __tasklet_{,hi_}schedule() code
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080220133718.GA8205@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219153720.GA2967@ubuntu> <20080219155252.GA27280@elte.hu>
	 <20080219162718.GA3372@ubuntu> <20080220104113.GI3881@elte.hu>
	 <20080220133718.GA8205@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/2008, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> On Wed, Feb 20, 2008 at 11:41:13AM +0100, Ingo Molnar wrote:
> >
> > * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> >
> > > > > -               local_irq_disable();
> > > > > -               t->next = __get_cpu_var(tasklet_vec).list;
> > > > > -               __get_cpu_var(tasklet_vec).list = t;
> > > > > -               __raise_softirq_irqoff(TASKLET_SOFTIRQ);
> > > > > -               local_irq_enable();
> > > > > +               /* We were not lucky enough to run, reschedule. */
> > > > > +               __tasklet_schedule(t);
> > > >
> > > > i think there's a subtle difference that you missed: this one does
> > > > __raise_softirq_irqoff(), while __tasklet_schedule() does a
> > > > raise_softirq_irqoff(). (note the lack of undescores)
> > > >
> > > > the reason is to avoid infinitely self-activating tasklets.
> > >
> > > Indeed, thanks a lot for the explanation. (maybe it's time to check
> > > for new eyeglasses ;)).
> >
> > nah, it's rather subtle and the code looked good to me at first but i
> > remembered that there was some small detail here to watch out for.
> >
> > i really dont like tasklets due to their many, arbitrary scheduling
> > limitations, we should really use the "turn tasklets into kthreads"
> > patch i posted last year.
> >
>
> While we are at it, there's a small question that is bothering me
> for a while (and I'm really thankful for help).
>
> I keep reading that softirqs (and naturally, tasklets) got executed
> in interrupt context at the return from hardirq code path.
>
> Checking entry_32.S, I find no mentioning of softirqs on the return
> path (beginning from ret_from_intr: to restore_all: )
>
> The only invocation I'm able to find is from local_bh_enable() and
> from ksoftirqd/n threads (by calling do_softirq()). AFAIK, both
> invocations occur in a _nont-interrupt_ context (exception context).
>
> So, where does the interrupt-context tasklets invocation really
> occur ?

Look at irq_exit() in softirq.c.

The common sequence is ... -> do_IRQ() --> irq_exit() --> invoke_softirq()


-- 
Best regards,
Dmitry Adamushko
