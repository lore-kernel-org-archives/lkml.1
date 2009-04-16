Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZDPRUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZDPRUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDPRU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:20:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:47137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZDPRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:20:28 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>
	 <alpine.DEB.2.00.0904161259460.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 19:20:07 +0200
Message-Id: <1239902407.23397.3197.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 13:03 -0400, Steven Rostedt wrote:
> On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> 
> > On Thu, 2009-04-16 at 12:15 -0400, Steven Rostedt wrote:
> > > plain text document attachment
> > > (0002-tracing-events-lockdep-move-tracepoints-within-recu.patch)
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > With the current location of the tracepoints in lockdep, the system
> > > can hard lockup in minutes when the tracepoints are enabled.
> > > 
> > > Moving the tracepoints outside inside the lockdep protection solves
> > > the issue.
> > 
> > NAK
> > 
> > the idea is to eventually move lockdep on top of the tracepoints. The
> > tracer should grow to be more robust and handle recursion itself.
> > 
> > Its likely a case of the tracer using a spinlock or mutex in the
> > tracepoint code. When I did the tracepoints I converted one such to a
> > raw_spinlock_t in the trace_print code.
> 
> Note, that the ring buffer and events are made to be recursive. That is, 
> it allows one event to trace within another event.

But surely not in the same context. You could do a 4 level recursion
protection like I did in perf-counter, not allowing recursion in:

 nmi, irq, softirq, process - context.

That allows you to trace an irq while you're tracing something in
process context, etc.. But not allow recursion on the same level.

>  If the tracepoint is 
> triggered by something within the trace point handler, then we are 
> screwed. That needs to be fixed.

Exactly the thing you want to detect and warn about, preferably with a
nice stack trace.

> I have not seen what is triggering back into locking. The ring buffer and 
> what I can see by the event code, does not grab any locks besides raw 
> ones.

Well, it used to all work, so something snuck in.

