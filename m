Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZDPCX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZDPCX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZDPCXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:23:16 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:43235 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750924AbZDPCXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:23:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMFAKMv5klMQW1W/2dsb2JhbACBUc9Og30G
Date: Wed, 15 Apr 2009 22:23:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
Message-ID: <20090416022305.GA22378@Krystal>
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:16:28 up 46 days, 22:42,  1 user,  load average: 0.26, 0.40,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:
> 
> > Steven Rostedt wrote:
> > > On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:
> > > 
> > >   
> > > > I'm having a problem with CREATE_TRACE_POINTS being too indiscriminate.
> > > > The
> > > > trouble is that it not only creates tracepoint definitions for the
> > > > intended
> > > > tracepoints, but any other tracepoint definitions which get included
> > > > incidentally.
> > > > 
> > > > For example, I'm seeing my paravirt tracepoints being instantiated in both
> > > > kernel/sched.o and kernel/irq/manage.o as side-effects of the scheduler
> > > > and
> > > > irq tracepoints being instantiated.
> > > > 
> > > > I'm experimenting with a different scheme, wherein a subsystem defines
> > > > CREATE_FOO_TRACE_POINTS in the .c file where it wants to instantiate the
> > > > tracepoints - rather than CREATE_TRACE_POINTS - and its trace/events/foo.h
> > > > does:
> > > > 
> > > >    #ifdef CREATE_FOO_TRACE_POINTS
> > > >    #undef CREATE_FOO_TRACE_POINTS	/* avoid infinite recursion */
> > > >    #include <trace/instantiate_trace.h>
> > > >    #else
> > > >    #include <trace/define_trace.h>
> > > >    #endif
> > > > 
> > > > where instantiate_trace.h is:
> > > > 
> > > >    #define CREATE_TRACE_POINTS
> > > >    #include <trace/define_trace.h>
> > > >    #undef CREATE_TRACE_POINTS
> 
> Have you tried:
> 
> #ifdef CREATE_PVOPS_TRACE_POINTS
> #define CREATE_TRACE_POINTS
> #include <trace/define_trace.h>
> #undef CREATE_TRACE_POINTS
> #endif
> 
> And in your C file do:
> 
> #define CREATE_PVOPS_TRACE_POINTS
> #include <trace/pvops.h>
> 
> ??
> 
> -- Steve

Jeremy brings up an interesting point. Given that we might eventually
include a few tracepoint header files in a given C file, but with the
intent of only "creating" the tracepoint callbacks for few of these, the
global "CREATE_TRACE_POINTS" flag makes little sense and seems like it
will easily lead to link-time errors.

Maybe we could consider requiring something like the following solution :

In the .c file :

#define CREATE_TRACE_POINTS
#include <trace/subsysa.h>
#undef CREATE_TRACE_POINTS

#include <trace/subsysb.h>

Where subsysa has its trace points callbacks created, but subsysb
doesn't. This seems half-way understandable, at least.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
