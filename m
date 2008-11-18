Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYKRQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYKRQkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYKRQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:40:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYKRQk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:40:27 -0500
Date: Tue, 18 Nov 2008 17:40:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118164019.GA18620@elte.hu>
References: <20081117084923.GD28786@elte.hu> <4921BA25.3090704@gmail.com> <20081118084755.GK17838@elte.hu> <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com> <20081118145154.GC30358@elte.hu> <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com> <20081118151326.GH30358@elte.hu> <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com> <20081118155045.GJ30358@elte.hu> <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/18 Ingo Molnar <mingo@elte.hu>:
> >
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >>
> >> On Tue, 18 Nov 2008, Ingo Molnar wrote:
> >> > > >
> >> > > > that reminds me: ti->ret_stack[] should be moved to task->ret_stack[].
> >> > > > That way we decouple its size from any kernel stack size limits.
> >> > > > (thread-info resides at one end of the kernel stack, on x86)
> >> > >
> >> > > Yeah, I recommended that to Frederic to save space. But that can be
> >> > > dangerous. Using task instead would be safer with the downside of
> >> > > making the task struct even bigger.
> >> >
> >> > We almost never put new stuff into thread_info - we have the
> >> > lockdep lock stack in the task structure too, for similar reasons.
> >>
> >> Yeah, it was just a recommendation, and perhaps not a good one ;-)
> >>
> >> Frederic, it is better if you move the array from the thread info to
> >> the task struct. It will take up more memory but it is a hell of a
> >> lot safer. The pro here definitely outways the con.
> >
> > if the memory footprint starts mattering we could turn this into a
> > single pointer to an array - and add/remove these arrays (from all
> > tasks currently running) as the tracer is turned on/off.
> >
> >        Ingo
> >
> 
> Ok. So what do you suggest once? Do I begin to move the array from 
> thread info to struct task but by keeping the static array or should 
> I directly use a dynamic allocation and add/remove dynamically?

Would be nice to have the dynamic allocation straight away - the 
tracer looks rather useful but people wont enable it by default for 
sure. This way distros could enable it all by default without worrying 
about the memory overhead.

And with a dynamic array the tracer could even have a tunable 'max 
depth' option [only changeable when the tracer is not active].

So it all looks much nicer to me that way ... if you succeed in coding 
it up that is ;-) Changing all tasks at once is tricky business: you'd 
have to take the tasklist_lock and iterate over every user and kernel 
task - including idle tasks.

	Ingo
