Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZCYWtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZCYWtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZCYWth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:49:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49459 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZCYWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:49:36 -0400
Date: Wed, 25 Mar 2009 18:49:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing: add handler to trace_stat
In-Reply-To: <20090325220149.GK5932@nowhere>
Message-ID: <alpine.DEB.2.00.0903251846470.5675@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903242329350.22830@gandalf.stny.rr.com> <20090325220149.GK5932@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Frederic Weisbecker wrote:
> >  
> > diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
> > index 202274c..f3546a2 100644
> > --- a/kernel/trace/trace_stat.h
> > +++ b/kernel/trace/trace_stat.h
> > @@ -12,7 +12,7 @@ struct tracer_stat {
> >  	/* The name of your stat file */
> >  	const char		*name;
> >  	/* Iteration over statistic entries */
> > -	void			*(*stat_start)(void);
> > +	void			*(*stat_start)(struct tracer_stat *trace);
> 
> 
> 
> In that case, shoudn't we pass another thing than the struct tracer_stat?
> Because nothing really private can be stored in it. Moreover, most of the
> time the handler is dedicated to this tracer_stat so it is able to have
> an access to it.
> 
> May be we could add a void *private inside struct trace_stat and then pass
> it to stat_start() ?
> 


Very few tracers need a private field so adding one would be a waste for 
them. I just used the old container_of trick.


struct ftrace_profile_stat {
        atomic_t                        disabled;
        struct hlist_head               *hash;
        struct ftrace_profile_page      *pages;
        struct ftrace_profile_page      *start;
        struct tracer_stat              stat;
};

static void *function_stat_start(struct tracer_stat *trace)
{
        struct ftrace_profile_stat *stat =
                container_of(trace, struct ftrace_profile_stat, stat);

[...]

And there you have it. I have everything I need unique to the tracer and 
no need of a private pointer.

-- Steve

