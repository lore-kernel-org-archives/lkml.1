Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZCELXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZCELXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZCELXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:23:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:16723 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbZCELX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mP5xB/u8n5clT0klD/F9E0mmp+/n78takeUe9CD2Wtlat+xKj9x3N6rAEDRj5PHek+
         lzMIDH+0CHz7QodideBnJAmnibgWDdPsW3IfgjW1mRUu4mibxI0P9Cgm3dUWwdss7vFt
         /hYI53fTYyeUb06Mju4AI8VZdwf+VVxWGdsGA=
Date: Thu, 5 Mar 2009 12:23:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305112322.GH5359@nowhere>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com> <20090305110433.GH32407@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305110433.GH32407@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:04:33PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: decrease hangs risks with the graph tracer on slow systems
> > 
> > Since the function graph tracer can spend too much time on 
> > timer interrupts, it's better now to use the more lightweight 
> > local clock. Anyway, the function graph traces are more 
> > reliable on a per cpu trace.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  arch/x86/kernel/ftrace.c             |    2 +-
> >  kernel/trace/trace_functions_graph.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 3925ec0..40960c2 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -436,7 +436,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> >  		return;
> >  	}
> >  
> > -	calltime = cpu_clock(raw_smp_processor_id());
> > +	calltime = sched_clock();
> 
> I changed this to trace_clock_local() :-)
> 
> (btw, we should turn trace_clock_local() into an inline 
> function)


Ok.
 
> There will be one problem though: function trace elapsed time 
> measurements across idle. Those are not correctly measured by 
> the local clock.

Oh, why? If I'm not wrong it uses sched_clock() which uses tsc on x86.
And this register always goes forward at the same rate. Unless some
Cpu decrease their frequency while beeing idle for some time and then
become unreliable?

> 	Ingo

