Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZJUHet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZJUHet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZJUHet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbZJUHes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:34:48 -0400
Date: Wed, 21 Oct 2009 09:34:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly skip
	records
Message-ID: <20091021073442.GA2343@jolsa.lab.eng.brq.redhat.com>
References: <1256054439-24386-1-git-send-email-jolsa@redhat.com> <20091020171147.GA4906@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020171147.GA4906@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 07:11:54PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 20, 2009 at 06:00:39PM +0200, Jiri Olsa wrote:
> > Hi,
> > 
> > there's a case where the graph tracer might get confused and displays
> > "{}" brackets in a wrong way.
> > 
> > Sorry for long description, but I found no better way to 
> > describe the issue.. ;)
> > 
> 
> 
> I rather consider this changelog as nicely decribing the issue.
> 
>  
> > It works ok but for one case. 
> > 
> > If the "func2()" trace does not make it to the seq_file read buffer, it needs
> > to be processed again in the next read.  And here comes the issue: 
> > the next read will see following pointers setup for func2 processing:
> > 
> >             func1 ENTRY
> > current ->  func2 ENTRY 
> >             func2 RETURN
> >    next ->  func1 RETURN
> > 
> > which will turn to displaying the func2 entry like: "func2() {", since the
> > next entry is not RETURN of the same type.  Generaly it is whatever entry 
> > that follows, but definitelly not the RETURN entry of the same function.
> 
> 
> 
> I see... So that happens when the previous seq write failed, we already have
> consume func2 RETURN and because we returned TRACE_PARTIAL_LINE, we reprocess
> func2 ENTRY, but the next entry pointer have moved ahead already...
> 
> Nice catch!
> 
>  
> > Following patch fixes the issue by skipping the entry in the last moment,
> > bypassing the issue to happen during the sequential reads.
> >
> > wbr,
> > jirka
> > 
> > 
> > NOTE:
> > 
> > AFAIK patch does not affect "trace_pipe" handling, since the change is
> > on the ring_buffer_iter level. However the "trace_pipe" suffers from
> > the same issue -> when the read buffer is filled up, the current trace
> > entry is not copied to it. Following read will continue with next entry.
> > It might be harder to fix this, since "trace_pipe" in order to see next
> > record has to eat the current one... 
> > 
> > I'll look at possible solution, but any ideas are welcome.. :)
> > 
> > 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  include/linux/ftrace_event.h         |    1 +
> >  kernel/trace/trace.c                 |   29 +++++++++++++++++++++++++++++
> >  kernel/trace/trace_functions_graph.c |    2 +-
> >  3 files changed, 31 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index d117704..7b07ad2 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -53,6 +53,7 @@ struct trace_iterator {
> >  	struct mutex		mutex;
> >  	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
> >  	unsigned long		iter_flags;
> > +	bool			skip_entry;
> 
> 
> Instead of adding this new field to struct trace_iterator,
> why not creating a new return value like TRACE_TYPE_HANDLED
> but that would consume two entries instead of one?
> 
> May be TRACE_TYPE_HANDLED_2? (sorry I suck in naming).
> 
> TRACE_TYPE_HANDLED_PAIR?
> TRACE_TYPE_HANDLED_COUPLE?
> 

I think we need to hold the state of crossing 2 entries, since the
issue happens when the seq_write fails, so there will be next read
operation, which needs to know what to do.

jirka
