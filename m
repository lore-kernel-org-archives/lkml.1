Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZLCOYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZLCOYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZLCOYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:24:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZLCOYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:24:03 -0500
Subject: Re: trace/events: DECLARE vs DEFINE semantic
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091203140942.GB24905@Krystal>
References: <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
	 <1259781578.12870.78.camel@gandalf.stny.rr.com>
	 <4B16EC06.6010706@redhat.com>
	 <1259794005.12870.102.camel@gandalf.stny.rr.com>
	 <20091202231019.GB14770@Krystal> <4B1737E2.6010502@redhat.com>
	 <1259813228.12870.108.camel@gandalf.stny.rr.com>
	 <4B17C25A.8090703@redhat.com>
	 <1259848493.12870.114.camel@gandalf.stny.rr.com>
	 <20091203140942.GB24905@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 03 Dec 2009 09:24:08 -0500
Message-Id: <1259850248.12870.132.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 09:09 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Thu, 2009-12-03 at 08:51 -0500, Masami Hiramatsu wrote:
> > 
> > > > Basically, we should have a:
> > > > 
> > > > kernel/sched_trace.c that includes the include/trace/events/sched.h and
> > > > does the define.
> > > > 
> > > > And the same goes for other trace points.
> > > 
> > > Hmm, I'd rather like to move it into kernel/events/ or something new
> > > sub directory, since those files will have just two lines (define and
> > > include).
> > 
> > I'm fine with a kernel/events dir.
> 
> Yep, sounds fine.
> 
> Maybe we could have separate files for:
> 
> a) event definitions
> b) class definitions

Um, because we don't add classes nor definitions for that matter in C
files. These files will just have:

#define CREATE_TRACE_POINT
#include <trace/event/x.h>
#include <trace/event/y.h>
[...]


> 
> ?
> 
> > 
> > > 
> > > >> e.g.
> > > >>
> > > >> @kernel/tracepoint.c
> > > >>  ...
> > > >>  #define CREATE_TRACE_POINTS
> > > >>  #include <trace/events/sched.h>
> > > >>  #include <trace/events/...>
> > > > 
> > > > We could do this for all that is defined in the include/trace/events.
> > > > 
> > > >>  ...
> > > >>
> > > >> @kernel/sched.c
> > > >>  ...
> > > >>  #include <trace/events/sched.h>	/* Just include events header */
> > > >>  ...
> > > >>
> > > >> @fs/ext4/super.c (no change, since it can be module)
> > > >>  ...
> > > >>  #define CREATE_TRACE_POINTS
> > > >>  #include <trace/events/ext4.h>
> > > > 
> > > > Perhaps we should move out anything in include/trace/events that is also
> > > > a module into its sub system?
> > > 
> > > Would you mean putting those headers in sub-system's directory?
> > > (e.g. fs/ext4/)
> > > In that case, a problem will happen when user want to hook those
> > > tracepoint from their module, because it is hard to find those
> > > local headers.
> > 
> > Why? Modules usually do have their own headers in their sub system.
> > 
> > OK, if a module keeps their headers global (include/linux) then sure
> > they can keep their tracepoint header in include/trace/events. But I
> > still think that the module CREATE_TRACE_POINTS code should be kept with
> > the module code itself (but in a small separate file).
> 
> I agree with Steven here: modules should come with their own trace event
> definitions, and if the trace classes they use are not available in the
> standard kernel, they should come with these trace classes definitions
> too.
> 
> A small *_trace.c file linked along with the module looks fine by me.
> 
> And please, try to re-used the already existing symbol dependency
> management already present in the kernel to deal with module dependency
> on class and dependency such as:
> 
>   module-a.ko
>     defines trace class
>   module-b.ko
>   module-c.ko
> 
>     module-b and module-c define events which depend on the trace class.
> 
> If you make the event definition depend on a symbol defined in module-a,
> everything should work flawlessly. It also works if the class is defined
> in the core kernel.

I think the issue is where to find the headers.

But this does bring up another point. I don't think I designed the class
macro to be used by events in other headers. Looking at the code, since
all the shared functions are "static" it wont work.

I guess I can modify it to be global, and also export them as GPL.

-- Steve


-- Steve


