Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbYBTKmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbYBTKmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYBTKlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:41:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYBTKly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:41:54 -0500
Date: Wed, 20 Feb 2008 11:41:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Tasklets: Avoid duplicating __tasklet_{,hi_}schedule()
	code
Message-ID: <20080220104113.GI3881@elte.hu>
References: <20080219153720.GA2967@ubuntu> <20080219155252.GA27280@elte.hu> <20080219162718.GA3372@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219162718.GA3372@ubuntu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> > > -		local_irq_disable();
> > > -		t->next = __get_cpu_var(tasklet_vec).list;
> > > -		__get_cpu_var(tasklet_vec).list = t;
> > > -		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
> > > -		local_irq_enable();
> > > +		/* We were not lucky enough to run, reschedule. */
> > > +		__tasklet_schedule(t);
> > 
> > i think there's a subtle difference that you missed: this one does 
> > __raise_softirq_irqoff(), while __tasklet_schedule() does a 
> > raise_softirq_irqoff(). (note the lack of undescores)
> > 
> > the reason is to avoid infinitely self-activating tasklets.
> 
> Indeed, thanks a lot for the explanation. (maybe it's time to check 
> for new eyeglasses ;)).

nah, it's rather subtle and the code looked good to me at first but i 
remembered that there was some small detail here to watch out for.

i really dont like tasklets due to their many, arbitrary scheduling 
limitations, we should really use the "turn tasklets into kthreads" 
patch i posted last year.

	Ingo
