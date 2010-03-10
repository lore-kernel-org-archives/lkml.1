Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0CJTfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:35:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:34589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0CJTfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:35:17 -0500
Subject: Re: [RFC PATCH] perf: Store relevant events in a hlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100308183545.GA5038@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com>
	 <1267772426-5944-2-git-send-regression-fweisbec@gmail.com>
	 <1267781969.16716.55.camel@laptop>  <20100308183545.GA5038@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 20:34:52 +0100
Message-ID: <1268249692.5279.138.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 19:35 +0100, Frederic Weisbecker wrote:
> On Fri, Mar 05, 2010 at 10:39:29AM +0100, Peter Zijlstra wrote:
> > On Fri, 2010-03-05 at 08:00 +0100, Frederic Weisbecker wrote:
> > > Each time a trace event triggers, we walk through the entire
> > > list of events from the active contexts to find the perf events
> > > that match the current one.
> > > 
> > > This is wasteful. To solve this, we maintain a per cpu list of
> > > the active perf events for each running trace events and we
> > > directly commit to these.
> > 
> > Right, so this seems a little trace specific. I once thought about using
> > a hash table to do this for all software events. It also keeps it all
> > nicely inside perf_event.[ch].
> 
> 
> What do you think about this version?
> It builds but crashes on runtime and doesn't handle
> cpu hotplug yet. Before spending more time in debugging/fixing,
> I'd like to know your opinion about the general architecture.
> 
> Thanks.
> 
> ---
> From c389b296a87bd38cfd28da3124508eb1e5a5d553 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 8 Mar 2010 19:04:02 +0100
> Subject: [PATCH] perf: Store relevant events in a hlist
> 
> When a software/tracepoint event triggers, we walk through the
> entire current cpu and task context's events lists to retrieve
> those that are concerned.
> 
> This is wasteful. This patch proposes a hashlist to walk through
> the relevant events only. The hash is calculated using the id of
> the event (could be further optimized using the type of the event
> too). Each hash map a list of distinct type:id that match the hash.
> To these type:id nodes, we affect a list of the active events
> matching the type:id.
> 
> -----------------------
> Hash 1 | Hash 2 | ....
> ----------------------
>   |
>  swevent type:id node
>   |       |
>   |       ------- event 1 ---- event 2 ---- ....
>   |
>  swevent type:id node
>           |
>           --------[...]
> 
> The hashlist is per cpu (attached to perf_cpu_context) and the
> events in the lists gather those that are active in the cpu and
> task context. No more per events checks are needed to guess if
> the events are "counting" or "matching".

I'm not quite sure why you need the node thing, you already have a
hash-bucket to iterate, simply stick all events into the one bucket and
walk through it with a filter and process all events that match.

As to all those for_each_online_cpu() thingies, it might make sense to
also have a global hash-table for events active on all cpus,... hmm was
that the reason for the node thing, one event cannot be in multiple
buckets?
