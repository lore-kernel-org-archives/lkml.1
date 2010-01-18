Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340Ab0AROqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0AROqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862Ab0AROqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:46:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15424 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0AROqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UKvwzo8Db79gG0nvsthWmYYpdzsry3rsH3hOyQZWZncHNdMPbL6Pbb65xJ/tn4l0b+
         GvKNQllgpZurj6xMDTGaDMHiIBBunSS7HxQxz3CeuoRixVzzxfkWLogA8SS/hvLF+7Q5
         mQiQ7ULCiWpmwyjdY791iFShzXNqLI1FEVrRg=
Date: Mon, 18 Jan 2010 15:45:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH]  perf_events: improve x86 event scheduling (v5)
Message-ID: <20100118144556.GE10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com> <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop> <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263825158.4283.590.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:32:38PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 15:20 +0100, Frederic Weisbecker wrote:
> > 
> > 
> > Well in appearance, things go through one pass.
> > 
> > But actually not, there is a first iteration that collects
> > the events (walking trhough the group list, filtering soft events),
> > a second iteration that check the constraints and schedule (but
> > not apply) the events.
> > 
> > And thereafter we schedule soft events (and revert the whole if
> > needed).
> > 
> > This is a one pass from group_sched_in() POV but at the cost
> > of reimplementating what the core does wrt soft events and iterations.
> > And not only is it reinventing the wheel, it also produces more
> > iterations than we need.
> > 
> > If we were using the common pmu->enable() from group/event_sched_in(),
> > that would build the collection, with only one iteration through the
> > group list (instead of one to collect, and one for the software
> > events).
> > 
> > And the constraints can be validated in a second explicit iteration
> > through hw_check_constraint(), like it's currently done explicitly
> > from hw_perf_group_sched_in() that calls x86_schedule_event().
> 
> Thing is, we cannot do that, because we currently require ->enable() to
> report schedulability. Now we could add an argument to ->enable, or add
> callbacks like I suggested to convey that state.


Hmm, but the schedulability status can be overriden in this case by
the callbacks you mentioned. The thing is I'm not sure how you
mean to use these. Is it like I did in the previous mockup, by
calling hw_perf_group_sched_in_begin() in the beginning of a group
scheduling and hw_perf_group_sched_in_end() in the end?

 
> > The fact is we have with this patch a _lot_ of iterations each
> > time x86 get scheduled. This is really a lot for a fast path.
> > But considering the dynamic cpu events / task events series
> > we can have, I don't see other alternatives.
> 
> Luckily it tries to use a previous configuration, so in practise the
> schedule phase is real quick amortized O(1) as long as we don't change
> the set.



Yeah.


 
> > Do you mean this:
> > 
> > hw_perf_group_sched_in_begin(&x86_pmu);
> > 
> > for_each_event(event, group) {
> >         event->enable();        //do the collection here
> > }
> > 
> > 
> > if (hw_perf_group_sched_in_end(&x86_pmu)) {
> >         rollback...
> > }
> > 
> > That requires to know in advance if we have hardware pmu
> > in the list though (can be a flag in the group).
> 
> Good point, but your proposed hw_check_constraint() call needs to know
> the exact same.


True. Whatever model we use anyway, both implement the same idea.

