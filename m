Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZDPDJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZDPDJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZDPDJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:09:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZDPDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:09:17 -0400
Date: Wed, 15 Apr 2009 23:09:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
In-Reply-To: <49E69CED.9050706@goop.org>
Message-ID: <alpine.DEB.2.00.0904152302530.4459@gandalf.stny.rr.com>
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org> <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com> <20090416022305.GA22378@Krystal> <49E69CED.9050706@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:

> Mathieu Desnoyers wrote:
> > Jeremy brings up an interesting point. Given that we might eventually
> > include a few tracepoint header files in a given C file, but with the
> > intent of only "creating" the tracepoint callbacks for few of these, the
> > global "CREATE_TRACE_POINTS" flag makes little sense and seems like it
> > will easily lead to link-time errors.
> >   
> 
> Yes, that's what I'm seeing.
> 
> > Maybe we could consider requiring something like the following solution :
> > 
> > In the .c file :
> > 
> > #define CREATE_TRACE_POINTS
> > #include <trace/subsysa.h>
> > #undef CREATE_TRACE_POINTS
> > 
> > #include <trace/subsysb.h>
> > 
> > Where subsysa has its trace points callbacks created, but subsysb
> > doesn't. This seems half-way understandable, at least.
> 
> But what if trace/subsysa.h includes some other headers to define some types
> it needs, which in turn ends up incidentally including trace/subsysc.h (either
> directly, or indirectly via any number of other headers?  Then it will end up
> instantiating tracepoints for subsysa and subsysc.  The only way to avoid it
> would be to impose an absolutely strict separation of type/constant definition
> headers from function/tracepoint ones.

I hate to do this because it adds some more work to the developer adding a 
new trace point header, but we could just remove the CREATE_TRACE_POINTS 
and do in the trace/events/*.h headers:

#ifdef CREATE_FOO_TRACE_POINTS
#include <trace/define_trace.h>
#endif

in all tracepoint headers. I originally had it this way with just the 
CREATE_TRACE_POINTS, but Christoph Hellwig and Mathieu both suggested 
putting that into define_trace.h.  It seems so much cleaner to keep it in 
define_trace.h, but if it is causing too many headaches, it may not be 
worth it :-/

-- Steve

