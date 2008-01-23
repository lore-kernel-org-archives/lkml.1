Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYAWRdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYAWRdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYAWR1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:27:25 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:47447 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbYAWR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:27:24 -0500
Date: Wed, 23 Jan 2008 12:27:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <1201107978.13596.16.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org>  <20080123160441.236562634@goodmis.org>
 <1201107978.13596.16.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jan 2008, Daniel Walker wrote:

>
> On Wed, 2008-01-23 at 11:02 -0500, Steven Rostedt wrote:
>
> > +	if (!irqs_disabled() && wake_klogd)
> >  		wake_up_klogd();
>
> This causes a regression .. When printk is called during an OOPS in
> kernels without this change then the OOPS will get logged, since the
> logging process (klogd) is woken to handle the messages.. If you apply
> this change klogd doesn't wakeup, and hence doesn't log the oops.. So if
> you remove the wakeup here you have to add it someplace else to maintain
> the logging ..
>
> (I'm not theorizing here, I have defects logged against this specific
> piece of code..)

It wont get woken up anyway. Did you look at wake_up_klogd?

void wake_up_klogd(void)
{
	if (!oops_in_progress && waitqueue_active(&log_wait))
		wake_up_interruptible(&log_wait);
}


So if oops_in_progress is set, then it still wont get woken. Perhaps it
got woken some other way? Or is oops_in_progress not set in these oops?

One other solution is to make the runqueue locks visible externally. Like:

in sched.c:

int runqueue_is_locked(void)
{
	int cpu = get_cpu();
	struct rq *rq = cpu_rq(cpu);
	int ret;

	ret = spin_is_locked(&rq->lock);
	put_cpu();
	return ret;
}

And in printk we could do:

	if (wake_klogd && !runqueue_is_locked())
		wake_up_klogd();

This probably is the cleanest solution since it simply prevents the
deadlock from occurring.

-- Steve

