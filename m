Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbXLCLDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbXLCLDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbXLCLCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:02:52 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:47248 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbXLCLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:02:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Tv68ixCg+cuJIuDESq/uCWAhqayhswMi0peYID3coiZdVhVSnrBM6YHcNGfUhk2JCh5vqd2wsWUw284Z55YF8YvyW0DCmUQXy3vkh7es7g1F1F4fdaRH2/dsl6blP9y8ozQ110OP9ns5G0jog8yu2rGODBgA/0XPaFU7VU8QKvs=  ;
X-YMail-OSG: ZRHeMM4VM1kSS9r8WDOqeunb1usJwHdSEqRxNOSBoSGJz8kirjLnaCrck935wlzb6blgh6ucrQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 22:02:37 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200712032115.43275.nickpiggin@yahoo.com.au> <20071203103326.GD30050@elte.hu>
In-Reply-To: <20071203103326.GD30050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032202.37975.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 21:33, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > I was just talking about the default because I didn't know the
> > > > reason for the way it was set -- now that I do, we should talk
> > > > about trying to improve the actual code so we don't need 2
> > > > defaults.
> > >
> > > I've got the patch below queued up: it uses the more agressive yield
> > > implementation for SCHED_BATCH tasks. SCHED_BATCH is a natural
> > > differentiator, it's a "I dont care about latency, it's all about
> > > throughput for me" signal from the application.
> >
> > First and foremost, do you realize that I'm talking about existing
> > userspace working well on future kernels right? (ie. backwards
> > compatibility).
>
> given how poorly sched_yield() is/was defined the only "compatible"
> solution would be to go back to the old yield code.

While it is technically allowed to do anything with SCHED_OTHER class,
putting the thread to the back of the runnable tasks, or at least having
it give up _some_ priority (like the old scheduler) is less surprising
than having it do _nothing_.

I mean, if firefox really works best if sched_yield does nothing, it
surely shouldn't be calling it at all (nothing to do with it being open
source or not).

Wheras JVMs (eg. that have garbage collectors call yield), presumably
get quite a lot of tuning, and that was probably done with the less
surprising (and more common) sched_yield behaviour.


> (And note that you 
> are rehashing arguments that were covered on lkml months ago already.)

I'm just wondering whether the outcome was the right one.


> > > But first and foremost, do you realize that there will be no easy
> > > solutions to this topic, that it's not just about 'flipping a
> > > default'?
> >
> > Of course ;) I already answered that in the email that you're replying
> >
> > to:
> > > > I was just talking about the default because I didn't know the
> > > > reason for the way it was set -- now that I do, we should talk
> > > > about trying to improve the actual code so we don't need 2
> > > > defaults.
>
> well, in case you were wondering why i was a bit pointy about this, this
> topic of yield has been covered on lkml quite extensively a couple of
> months ago. I assumed you knew about that already, but perhaps not?

I did, but I haven't always followed the scheduler discussions closely
recently. I was surprised to find it hasn't changed much.

I appreciate you can never do exactly the right thing for everyone and
you can't (and don't want, by definition) to make behaviour exactly the
same.

Clearly the current default is far less aggressive (almost noop), and the
compat behaviour is probably more aggressive in most cases than the old
scheduler. I would have thought looking for a middle ground might be a
good idea.

Or just ignore firefox and get them to fix it, if the occasional stalls
are during really high scheduler stressing workloads (do you have a pointer
to that thread, btw?).


> > Anyway, I'd hope it can actually be improved and even the sysctl
> > removed completely.
>
> i think the sanest long-term solution is to strongly discourage the use
> of SCHED_OTHER::yield, because there's just no sane definition for yield
> that apps could rely upon. (well Linus suggested a pretty sane
> definition but that would necessiate the burdening of the scheduler
> fastpath - we dont want to do that.) New ideas are welcome of course.

sched_yield is defined to put the calling task at the end of the queue for
the given priority level as you know (ie. at the end of all other priority
0 tasks, for SCHED_OTHER).

So, while SCHED_OTHER technically allows _any_ task to be picked, I think
it would be least surprising to have the calling task go to the end of the
queue, rather than not doing very much at all...


> [ also, actual technical feedback on the SCHED_BATCH patch i sent (which
>   was the only "forward looking" moment in this thread so far ;-) would
>   be nice too. ]

I dislike a wholesale change in behaviour like that. Especially when it
is changing behaviour of yield among SCHED_BATCH tasks versus yield among
SCHED_OTHER tasks.

