Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZHSRnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZHSRnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZHSRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:43:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:25777 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZHSRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fCet9dqw8D3r0C9uTXXiEOyWkFnGaybYP7kN3921zwYZr6/6rI0vKxGkPgAz57oyWT
         U6IWVi03aXu0Eswl5/uQ39ikvl1KOlYuvphwX1yC/oqKEqydlBpAOMpdP6qwKLw/pc2m
         XbMpUVyLV86f705U89tL6uzxjbuYMsUqXaK6I=
Date: Wed, 19 Aug 2009 19:43:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090819174324.GI4972@nowhere>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com> <20090819161651.GC2649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819161651.GC2649@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 12:16:52PM -0400, Jason Baron wrote:
> On Tue, Aug 18, 2009 at 03:25:59PM -0700, Josh Stone wrote:
> > This converts the syscall_enter/exit tracepoints into TRACE_EVENTs, so
> > you can have generic ftrace events that capture all system calls with
> > arguments and return values.
> > 
> > The existing event_syscall_enter/exit trace_event structs are renamed to
> > event_sys_enter/exit, so they don't conflict with the names generated
> > automatically by ftrace.
> > 
> > Signed-off-by: Josh Stone <jistone@redhat.com>
> > Cc: Jason Baron <jbaron@redhat.com>
> > ---
> >  arch/s390/kernel/ptrace.c       |    3 ++
> >  arch/x86/kernel/ptrace.c        |    8 ++---
> >  include/linux/syscalls.h        |    4 +-
> >  include/trace/events/syscalls.h |   66 +++++++++++++++++++++++++++++++++++++++
> >  include/trace/syscall.h         |   17 +---------
> >  kernel/trace/trace_syscalls.c   |    5 ++-
> >  6 files changed, 79 insertions(+), 24 deletions(-)
> >  create mode 100644 include/trace/events/syscalls.h
> > 
> > diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
> > index 05f57cd..8730fa7 100644
> > --- a/arch/s390/kernel/ptrace.c
> > +++ b/arch/s390/kernel/ptrace.c
> > @@ -51,6 +51,9 @@
> >  #include "compat_ptrace.h"
> >  #endif
> >  
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/syscalls.h>
> > +
> >  enum s390_regset {
> >  	REGSET_GENERAL,
> >  	REGSET_FP,
> 
> this will have to be rebased to remove the new s390 DECLARE_TRACE()
> calls here like x86.
> 
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index 692fc14..530ff6f 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -35,13 +35,11 @@
> >  #include <asm/proto.h>
> >  #include <asm/ds.h>
> >  
> > -#include <trace/syscall.h>
> > -
> > -DEFINE_TRACE_WITH_CALLBACK(syscall_enter, syscall_regfunc, syscall_unregfunc);
> > -DEFINE_TRACE_WITH_CALLBACK(syscall_exit, syscall_regfunc, syscall_unregfunc);
> > -
> >  #include "tls.h"
> >  
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/syscalls.h>
> > +
> >  enum x86_regset {
> >  	REGSET_GENERAL,
> >  	REGSET_FP,
> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > index 87d06c1..19b49fd 100644
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -187,7 +187,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
> >  	  event_enter_##sname = {					\
> >  		.name                   = "sys_enter"#sname,		\
> >  		.system                 = "syscalls",			\
> > -		.event                  = &event_syscall_enter,		\
> > +		.event                  = &event_sys_enter,		\
> >  		.raw_init		= init_enter_##sname,		\
> >  		.show_format		= ftrace_format_syscall,	\
> >  		.regfunc		= reg_event_syscall_enter,	\
> > @@ -223,7 +223,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
> >  	  event_exit_##sname = {					\
> >  		.name                   = "sys_exit"#sname,		\
> >  		.system                 = "syscalls",			\
> > -		.event                  = &event_syscall_exit,		\
> > +		.event                  = &event_sys_exit,		\
> >  		.raw_init		= init_exit_##sname,		\
> >  		.regfunc		= reg_event_syscall_exit,	\
> >  		.unregfunc		= unreg_event_syscall_exit,	\
> > diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> > new file mode 100644
> > index 0000000..75ccc61
> > --- /dev/null
> > +++ b/include/trace/events/syscalls.h
> > @@ -0,0 +1,66 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM syscalls
> > +
> > +#if !defined(_TRACE_EVENTS_SYSCALL_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_EVENTS_SYSCALL_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +#include <asm/ptrace.h>
> > +#include <asm/syscall.h>
> > +
> > +extern void syscall_regfunc(void);
> > +extern void syscall_unregfunc(void);
> > +
> > +
> > +TRACE_EVENT_WITH_CALLBACK(syscall_enter,
> > +
> 
> do we want to call this something like, 'syscall_enter_generic'? to make
> it more clear this is the high level syscall tracepoint. similar for
> exit.


Yeah, that would be indeed less confusing.

