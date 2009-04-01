Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbZDAMxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbZDAMxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbZDAMxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:53:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZDAMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:53:35 -0400
Date: Wed, 1 Apr 2009 14:53:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401125314.GM12966@elte.hu>
References: <20090331145947.A12565@sedona.ch.intel.com> <20090401001729.GC28228@redhat.com> <20090401114140.GB23678@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E926D537D@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E926D537D@irsmsx504.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Wednesday, April 01, 2009 1:42 PM
> >To: Oleg Nesterov; Peter Zijlstra
> 
> 
> >* Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> On 03/31, Markus Metzger wrote:
> >> >
> >> > +static void wait_to_unschedule(struct task_struct *task)
> >> > +{
> >> > +	unsigned long nvcsw;
> >> > +	unsigned long nivcsw;
> >> > +
> >> > +	if (!task)
> >> > +		return;
> >> > +
> >> > +	if (task == current)
> >> > +		return;
> >> > +
> >> > +	nvcsw  = task->nvcsw;
> >> > +	nivcsw = task->nivcsw;
> >> > +	for (;;) {
> >> > +		if (!task_is_running(task))
> >> > +			break;
> >> > +		/*
> >> > +		 * The switch count is incremented before the actual
> >> > +		 * context switch. We thus wait for two switches to be
> >> > +		 * sure at least one completed.
> >> > +		 */
> >> > +		if ((task->nvcsw - nvcsw) > 1)
> >> > +			break;
> >> > +		if ((task->nivcsw - nivcsw) > 1)
> >> > +			break;
> >> > +
> >> > +		schedule();
> >>
> >> schedule() is a nop here. We can wait unpredictably long...
> >>
> >> Ingo, do have have any ideas to improve this helper?
> >
> >hm, there's a similar looking existing facility:
> >wait_task_inactive(). Have i missed some subtle detail that makes it
> >inappropriate for use here?
> 
> wait_task_inactive() waits until the task is no longer 
> TASK_RUNNING.

No, that's wrong, wait_task_inactive() waits until the task 
deschedules.

	Ingo
