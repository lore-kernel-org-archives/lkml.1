Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0CERDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:03:36 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47132 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0CERDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V/YC+GRPXx/qbSFPQkL5nIIjvGXyR75tbzlL4lmAF4jooSKrCt4KqsAjBiQ7eeiemS
         XDhQFUmBT6qGL/uufpzWs/Jh/1gYQj6bYXjdih8yiZFU1Lr7V+CxJCoCqTutlpZzeX0m
         xgq1rZbwSofvCduJw3MTEh2pPJ3xr5FU2MIE4=
Date: Fri, 5 Mar 2010 18:03:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
Message-ID: <20100305170331.GB5244@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com> <1267772426-5944-2-git-send-regression-fweisbec@gmail.com> <1267781969.16716.55.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267781969.16716.55.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:39:29AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-05 at 08:00 +0100, Frederic Weisbecker wrote:
> > Each time a trace event triggers, we walk through the entire
> > list of events from the active contexts to find the perf events
> > that match the current one.
> > 
> > This is wasteful. To solve this, we maintain a per cpu list of
> > the active perf events for each running trace events and we
> > directly commit to these.
> 
> Right, so this seems a little trace specific. I once thought about using
> a hash table to do this for all software events. It also keeps it all
> nicely inside perf_event.[ch].


Right. We could have a per cpu type:event_id based hlist that would
cover trace events and other software events.

That would do the trick more generically wrt perf.

Now isn't the problem more in the fact that most of the swevents
should be tracepoints?

This is the case for most of them. Only PERF_COUNT_SW_CPU_CLOCK
and PERF_COUNT_SW_TASK_CLOCK seem to be the exception, and they
manage their own path by calling perf_event_overflow() directly.

And as you guess, turning them into tracepoints would benefit
to everyone. We'll have interesting trace events in fault paths,
we won't have zillions of hooks in the same place (in the context
switch, we have the usual tracepoint plus the perf call).
And eventually the off-case is better optimized, and further
optimizations there (jmp/nop patching/whatever) will propagate
to all tracepoint users.

Finally, we would have only one path to maintain for the swevents.

