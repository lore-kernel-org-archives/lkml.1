Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZFHQW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZFHQW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZFHQWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:22:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbZFHQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:22:20 -0400
Date: Mon, 8 Jun 2009 12:22:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various
 fixes
In-Reply-To: <1244477919.13761.9042.camel@twins>
Message-ID: <alpine.DEB.2.00.0906081220040.9522@gandalf.stny.rr.com>
References: <20090603151724.144915858@goodmis.org>  <20090605145219.GA14830@elte.hu> <20090607082257.GA16761@elte.hu>  <alpine.DEB.2.00.0906081135320.9522@gandalf.stny.rr.com> <1244477919.13761.9042.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 8 Jun 2009, Peter Zijlstra wrote:

> On Mon, 2009-06-08 at 11:37 -0400, Steven Rostedt wrote:
> > [ Added Peter ]
> > 
> > On Sun, 7 Jun 2009, Ingo Molnar wrote:
> > > Testing tracer sched_switch: <6>Starting ring buffer hammer
> > > PASSED
> > > Testing tracer sysprof: PASSED
> > > Testing tracer function: PASSED
> > > Testing tracer irqsoff: 
> > > =============================================
> > > PASSED
> > > Testing tracer preemptoff: PASSED
> > > Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
> > > PASSED
> > > Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
> > > ---------------------------------------------
> > > rb_consumer/431 is trying to acquire lock:
> > >  (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
> > > 
> > > but task is already holding lock:
> > >  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
> > > 
> > > other info that might help us debug this:
> > > 1 lock held by rb_consumer/431:
> > >  #0:  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0
> > 
> > Yes this definitely looks like ftrace is tracing the ring buffer benchmark 
> > test.
> > 
> > OK, how do I go about teaching lockdep that this reader lock is not the 
> > same reader lock as the one being taken?
> 
> Something like this will put each ring-buffer user in its own lock
> class.

Thanks a lot Peter. I'll see if I can get this to work and then push it 
off to Ingo to see if it fixes his lockdep bugs.

> 
> Patch utterly uncompiled and broken since hotplug would need some care
> (you could probably store the key pointer in the rb object and reuse it
> on hotplug).

I could also save the key in the ring buffer itself. Each of the per cpu 
reader locks will share the same key, and then when it is created by the 
hotplug, it will use the key of the ring buffer.

-- Steve
