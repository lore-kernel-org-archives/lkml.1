Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZFSVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZFSVvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZFSVvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:51:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZFSVvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:51:15 -0400
Date: Fri, 19 Jun 2009 17:49:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 6/7] add syscall tracepoints
Message-ID: <20090619214907.GC3260@redhat.com>
References: <cover.1244837725.git.jbaron@redhat.com> <a092c3d0e03e64ef8b2b6d5ed9f5b6e3c07cf2d8.1244837725.git.jbaron@redhat.com> <20090619022825.GD7903@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619022825.GD7903@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 04:28:26AM +0200, Frederic Weisbecker wrote:
> On Fri, Jun 12, 2009 at 05:25:04PM -0400, Jason Baron wrote:
> > Allow the return value of raw_init() to bail us out of creating a trace event
> > file.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  kernel/trace/trace_events.c |   29 +++++++++++++++++++----------
> >  1 files changed, 19 insertions(+), 10 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 9e91c4a..c0da5e2 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -907,15 +907,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
> >  	if (strcmp(call->system, TRACE_SYSTEM) != 0)
> >  		d_events = event_subsystem_dir(call->system, d_events);
> >  
> > -	if (call->raw_init) {
> > -		ret = call->raw_init();
> > -		if (ret < 0) {
> > -			pr_warning("Could not initialize trace point"
> > -				   " events/%s\n", call->name);
> > -			return ret;
> > -		}
> > -	}
> > -
> >  	call->dir = debugfs_create_dir(call->name, d_events);
> >  	if (!call->dir) {
> >  		pr_warning("Could not create debugfs "
> > @@ -1014,6 +1005,7 @@ static void trace_module_add_events(struct module *mod)
> >  	struct ftrace_module_file_ops *file_ops = NULL;
> >  	struct ftrace_event_call *call, *start, *end;
> >  	struct dentry *d_events;
> > +	int ret;
> >  
> >  	start = mod->trace_events;
> >  	end = mod->trace_events + mod->num_trace_events;
> > @@ -1029,7 +1021,15 @@ static void trace_module_add_events(struct module *mod)
> >  		/* The linker may leave blanks */
> >  		if (!call->name)
> >  			continue;
> > -
> > +		if (call->raw_init) {
> > +			ret = call->raw_init();
> > +			if (ret < 0) {
> > +				if (ret != -ENOSYS)
> 
> 
> 
> I see you've set it up in case syscall_to_nr doesn't find the
> matching metadata.
> 
> How is it possible? The traced syscalls, ie those which are defined through
> DEFINE_SYSCALLx(), should be all in the arch syscall table. Or may be I'm
> missing something?
> 

yes, I've been wondering about the same thing...I think the answer is
that DEFINE_SYSCALLx() is used to define some of the 'compat' layer ia32
syscalls. Thus, they show up as events to register but they are not in
the syscall table. I'm not sure if its easy to handle these at compile
time, but in any case that is where this case is coming from...

I've also notice that I forgot to define the meta data for
SYSCALL_DEFINE0 case...

thanks,

-Jason
