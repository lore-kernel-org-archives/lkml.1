Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYJUNm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYJUNm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYJUNmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:42:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:35080 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750718AbYJUNmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:42:19 -0400
From: Michal Hocko <mhocko@suse.cz>
Organization: SUSE Linux s.r.o
To: david@lang.hm
Subject: Re: sched_yield() options
Date: Tue, 21 Oct 2008 15:42:16 +0200
User-Agent: KMail/1.9.9
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm> <20081020225318.GA10352@ghostprotocols.net> <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211542.16563.mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue October 21 2008 01:08:39 david@lang.hm wrote:
> On Mon, 20 Oct 2008, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Oct 20, 2008 at 03:34:07PM -0700, david@lang.hm escreveu:
> >> I've seen a lot of discussion about how sched_yield is abused by
> >> applications. I'm working with a developer on one application that looks
> >> like it's falling into this same trap (mutexes between threads and using
> >> sched_yield (or more precisely pthread_yield()) to let other threads get
> >> the lock)
> >>
> >> however I've been having a hard time tracking down the appropriate
> >> discussions to forward on to the developer (both for why what he's doing
> >> is bad, and for what he should be doing instead)
> >>
> >> could someone point out appropriate mailing list threads, or other
> >> documentation for this?
> >
> > http://kerneltrap.org/Linux/Using_sched_yield_Improperly
>
> that helps, but the case that seems closest to what I'm looking at is
>
> > > > One example I know of is a defragmenter for a multi-threaded memory
> > > > allocator, and it has to lock whole pools. When it releases these
> > > > locks, it calls yield before re-acquiring them to go back to work.
> > > > The idea is to "go to the back of the line" if any threads are
> > > > blocking on those mutexes.
> > >
> > > at a quick glance this seems broken too - but if you show the specific
> > > code i might be able to point out the breakage in detail. (One
> > > underlying problem here appears to be fairness: a quick unlock/lock
> > > sequence may starve out other threads. yield wont solve that
> > > fundamental problem either, and it will introduce random latencies
> > > into apps using this memory allocator.)
> >
> > You are assuming that random latencies are necessarily bad. Random
> > latencies may be significantly better than predictable high latency.
>
> in the case I'm looking at there are two (or more) threads running with
> one message queue in the center.
>
> 'input threads' are grabbing the lock to add messages to the queue
>
> 'output threads' are grabbing the lock to remove messages from the queue
>
> the programmer is doing a pthread_yield() after each message is processed
> in an attempt to help fairness (he initially added it in when he started
> seeing starvation on single-core systems)
>
> what should he be doing instead?

This sounds like standard producer/consumer problem. Why don't you simply use 
counting semaphore (increased by producers/input and decreased by 
consumers/output threads)?
Using pthread_yield sounds really broken (unpredictable results depending on 
system implementation of yield) here.

>
> the link above talks about other cases more, but really doesn't say what
> the right thing to do is for this case.
>
> David Lang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
