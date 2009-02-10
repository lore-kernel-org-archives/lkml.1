Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZBJO0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZBJO0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZBJO03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:26:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbZBJO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:26:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Efz4cU5XeKsJPX7ZHRWacfZBfHTXwOBt6m7+h98FtAiwU7vjehqkXWIXxr5HA7nI/4
         OeLhA/GtzYj1lIGu2BCZNytu4bz7sclsn4w6FXcG0ZSQQ7J2QIm+9vVZdK3bKOELXsOP
         ZjnGPwUGSTd1zNgMqHXqM2KgtDtZtfJfi7N4o=
Date: Tue, 10 Feb 2009 15:26:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210142622.GB5836@nowhere>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210125424.GC12820@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210125424.GC12820@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 10:54:24AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 10, 2009 at 04:43:30AM +0100, Frederic Weisbecker escreveu:
> > Add the missing pair tracing_{start,stop}_record_cmdline() to record well
> > the cmdline associated with pid.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> This is another thing that I think begs for a TRACE_INIT_CMDLINE in
> struct trace->flags so that just before calling ->init we call
> tracing_start_cmdline_record? no?


Right!
But the flags on struct tracer are more likely for private use, they have
a meaning only for the concerned tracer.

I guess it will be something for the global flags, when they will be
per-tracer.

 
> Another thing I noticed is that even we having a ->stop most of the time
> this semantic action is done thru ->reset :-\


Yes, perhaps the tracing of cmdline could be even performed on tracing_stop,
unless... perhaps it's not needed since the sched_switch tracer will be stopped too
anyway.

> 
> - Arnaldo
> 
> >  kernel/trace/trace_sysprof.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
> > index 84ca9d8..9902c15 100644
> > --- a/kernel/trace/trace_sysprof.c
> > +++ b/kernel/trace/trace_sysprof.c
> > @@ -238,6 +238,8 @@ static int stack_trace_init(struct trace_array *tr)
> >  {
> >  	sysprof_trace = tr;
> >  
> > +	tracing_start_cmdline_record();
> > +
> >  	mutex_lock(&sample_timer_lock);
> >  	start_stack_timers();
> >  	tracer_enabled = 1;
> > @@ -247,6 +249,7 @@ static int stack_trace_init(struct trace_array *tr)
> >  
> >  static void stack_trace_reset(struct trace_array *tr)
> >  {
> > +	tracing_stop_cmdline_record();
> >  	stop_stack_trace(tr);
> >  }

