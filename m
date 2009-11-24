Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbZKXV4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbZKXV4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbZKXV4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:56:31 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:59035 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986AbZKXV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:56:30 -0500
Date: Tue, 24 Nov 2009 22:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 0/3] tracepoint: Add signal events
Message-ID: <20091124213727.GA11347@elte.hu>
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
 <20091123175740.GA15594@elte.hu>
 <20091124212247.GA11773@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124212247.GA11773@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 11/23, Ingo Molnar wrote:
> >
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >
> > > Hi,
> > >
> > > These patches add signal related tracepoints including
> > > signal generation, delivery, and loss. First patch also
> > > moves signal-sending tracepoint from events/sched.h to
> > > events/signal.h.
> > >
> > > Changes in v3
> > > - Add Docbook style comments
> > >
> > > Changes in v2
> > > - Add siginfo arguments
> > >
> > > Thank you,
> > >
> > > ---
> > >
> > > Masami Hiramatsu (3):
> > >       tracepoint: Add signal loss events
> > >       tracepoint: Add signal deliver event
> > >       tracepoint: Move signal sending tracepoint to events/signal.h
> > >
> > >
> > >  Documentation/DocBook/tracepoint.tmpl |    5 +
> > >  include/trace/events/sched.h          |   25 -----
> > >  include/trace/events/signal.h         |  173 +++++++++++++++++++++++++++++++++
> > >  kernel/signal.c                       |   27 ++++-
> > >  4 files changed, 198 insertions(+), 32 deletions(-)
> > >  create mode 100644 include/trace/events/signal.h
> >
> > Would be nice to have Roland's and Oleg's Acked-by tags in the patches -
> > to show that this is a representative and useful looking set of signal
> > events.
> 
> Sorry, I can't really comment these patches.
> 
> I mean, I do not know which info is useful and which is not. For 
> example, I am a bit surprized we report trace_signal_lose_info() but 
> please do not consider this as if I think we shouldn't. Just I do not 
> know.

well, there we lose information, so it's basically an exception/anomaly 
that a person doing analysis might be interested in.

> OTOH, we do not report if __send_signal() fails just because the 
> legacy signal is already queued. [...]

We could do that (beyond the queued signals full event), but i think 
it's rather common to see signal overlap in the legacy case, right?

> [...] We do not report who sends the signal, [...]

The PID of any task generating an event can be sampled, so that's 
implicit.

> [...] we do not report if it was private or shared. zap_process, 
> complete_signal can "send" SIGKILL via sigaddset, this won't be 
> noticed. But again, it is not that I think this should be reported.
> 
> In short: I think any info may be useful, and these patches can help. 
> But I do not understand what exactly should be reported to userspace.

The principe is this: there's two extremes:

 A- report no event

 B- report every event precisely, that allows all signal state and
    actions to be reconstructed in hindsight.

And there's a continuum between the two extremes. Just a random state 
between A) and B) makes little sense - but certain subsets (say an 
'overview' of major signal events) might make sense from an analysis 
POV.

But the thing is, by my reading of these patches we are pretty close to 
B) right now and the tracepoints still look sane - so we might as well 
implement your suggestions and achieve B)? That's a well-defined target 
to achieve. It would mean we need events of sigmask manipulations as 
well, and handler setting events. Plus the missing events you pointed 
out. (plus other stuff i might have forgotten about)

	Ingo
