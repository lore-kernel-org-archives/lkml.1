Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZICQNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZICQNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZICQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:13:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZICQNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:13:50 -0400
Date: Thu, 3 Sep 2009 18:13:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] perf tools: Complete support for dynamic strings
Message-ID: <20090903161333.GA30908@elte.hu>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com> <1251693921-6579-4-git-send-email-fweisbec@gmail.com> <20090831081133.GA15619@elte.hu> <20090831165924.GA6048@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831165924.GA6048@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Aug 31, 2009 at 10:11:33AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Complete support for __str_loc type strings of ftrace events which
> > > have dynamic offsets values set for each of them inside their sammples.
> > > 
> > > Before:
> > >         geany-5759  [000]     0.000000: lock_release: name
> > >         geany-5759  [000]     0.000000: lock_release: name
> > >         geany-5759  [000]     0.000000: lock_release: name
> > >   kondemand/0-362   [000]     0.000000: lock_release: name
> > >       pdflush-421   [000]     0.000000: lock_release: name
> > > 
> > > After:
> > >         geany-5759  [000]     0.000000: lock_release: &u->lock
> > >         geany-5759  [000]     0.000000: lock_release: key
> > >         geany-5759  [000]     0.000000: lock_release: &group->notification_mutex
> > >   kondemand/0-362   [000]     0.000000: lock_release: &rq->lock
> > >       pdflush-421   [000]     0.000000: lock_release: &rq->lock
> > 
> > I've applied all five patches, thanks Frederic!
> > 
> > Also, i think this makes perf trace quite functional already so i 
> > merged that topic (and these commits) into tracing/core, for v2.6.32 
> > merging.
> 
> 
> 
> Ok.
> 
> 
>  
> > One thing that i noticed which is still quite quirky are the 
> > parameters to perf record. (needing -R and the :r postfix to events) 
> > Could something more intuitive be done here?
> 
> 
> I hope. It's not that easy, at least for me, to find something intuitive
> there.
> 
> I've thought about
> 
>   -e *sys:event  (because the * suggests a deref that takes the content)
>                  But that's a bit convoluted. And moreover we may want
>                  to support basic regex later for event selection.
> 
> If someone has an idea, please tell me.
> 
> Another thing. We could, by default display a small comment while
> selecting an event without its content:
> 
> "Opening counter sys:event. Type -R if you want raw sampling."
> 
> The user could shut that up with a -q option.

The confusion comes from the multi-purpose nature of 'perf record'. 
It is not clear from that workflow whether the resulting perf.data 
will be for trace reporting or for profiling/call-graph analysis.

I think we could solve some of this confusion by always gathering 
the most information we can - and allow the user to trim down the 
data if he wants to.

I.e. PERF_SAMPLE_RAW should be implicit if tracepoints are 
specified.

An additional measure would be to simplify the tracing workflow: a 
simple 'perf trace -e sched:switch /bin/ls' should really do 
implicit recording and should report the trace after that.

	Ingo
