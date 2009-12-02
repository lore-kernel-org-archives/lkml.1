Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZLBXKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZLBXKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbZLBXKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:10:16 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:38645 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134AbZLBXKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:10:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEALGBFktGGNlG/2dsb2JhbACBTtZGhDEE
Date: Wed, 2 Dec 2009 18:10:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
Message-ID: <20091202231019.GB14770@Krystal>
References: <20091202144334.GA30359@elte.hu> <1259765735.12870.42.camel@gandalf.stny.rr.com> <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com> <20091202190135.GA23316@Krystal> <1259781578.12870.78.camel@gandalf.stny.rr.com> <4B16EC06.6010706@redhat.com> <1259794005.12870.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1259794005.12870.102.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:59:25 up 13:50,  3 users,  load average: 0.71, 0.90, 0.83
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2009-12-02 at 17:36 -0500, Masami Hiramatsu wrote:
> 
> > > Or do you (or anyone else) have a better name?
> > 
> > How about renaming DEFINE_EVENT to TRACE_EVENT_CLASS?
> > 
> > DECLARE_EVENT_CLASS(y, ...)	declare an event-class y
> > TRACE_EVENT_CLASS(x, y, ...)	define/declare a trace event x from event-class y
> > TRACE_EVENT(x, ...)		define/declare a trace event x
> > 
> > Thus TRACE_EVENT_* implies that this macro will be expanded
> > to both of definition and declaration.
> > I don't think separating it is good idea from the viewpoint
> > of maintaining code.
> 
> Hmm, what about just:
> 
> TRACE_CLASS - Declares a class
> TRACE_CLASS_EVENT - defines an event for said class
> TRACE_EVENT - Declares a class and defines an event (as is today)

In addition, I wonder if we should rename "CREATE_TRACE_POINTS" to
something more suitable while we are here ? Basically, it will affect
all TRACE_CLASS/TRACE_CLASS_EVENT/TRACE_EVENT from headers included
after it's defined.

It sounds to me that this "CREATE_TRACE_POINTS" is the define that
controls whether the TRACE_* will actually turn into a DECLARE or a
DEFINE. I agree that the standard behavior should be to "DECLARE" stuff,
as it's the, by far, most common case, but maybe

#define TRACE_DEFINE
#include <trace/events/....h>

would be more descriptive than "CREATE_TRACE_POINTS", given it refers to
the well-known "define" semantic ?

So if we happen to have C file which need many headers to be declared
but only some of them to be defined, we could express it as:

#include <trace/events/sched.h>
#include <trace/events/irq.h>
#include <trace/events/timer.h>

#define TRACE_DEFINE
#include <trace/events/irq.h>
#include <trace/events/timer.h>
#undef TRACE_DEFINE

That would imply that any definition of a trace event header should be
preceded by an inclusion of this same header to perform the declaration.
This would clearly separate the declaration from definition.

Does it make sense ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
