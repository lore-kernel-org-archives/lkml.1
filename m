Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0AMP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0AMP22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794Ab0AMP22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:28:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58275 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0AMP21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:28:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=xpLpJGNBBNoA:10 a=20KFwNOVAAAA:8 a=EXUjecn8mUGx94p5kc8A:9 a=eenoD6BsEvK7y6WCyvkA:7 a=COUooQ2pmkNgvR5ppFbD7ORRq6AA:4 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Date: Wed, 13 Jan 2010 10:28:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 14/26] trace: Convert various locks to raw_spinlock
Message-ID: <20100113152824.GA15301@goodmis.org>
References: <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <20100112033931.GF5243@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112033931.GF5243@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 04:39:32AM +0100, Frederic Weisbecker wrote:
> On Mon, Jan 11, 2010 at 10:26:44PM +0100, John Kacur wrote:
> > Convert locks that cannot sleep in preempt-rt to raw_spinlocks.
> > 
> > See also: 87654a70523a8c5baadcbbc07d80cbae8f912837
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  kernel/trace/ring_buffer.c   |   52 +++++++++++++++++++++---------------------
> >  kernel/trace/trace.c         |   10 ++++----
> >  kernel/trace/trace_irqsoff.c |    6 ++--
> >  3 files changed, 34 insertions(+), 34 deletions(-)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index 2326b04..ffaddc5 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -422,7 +422,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
> >  struct ring_buffer_per_cpu {
> >  	int				cpu;
> >  	struct ring_buffer		*buffer;
> > -	spinlock_t			reader_lock;	/* serialize readers */
> > +	raw_spinlock_t			reader_lock;	/* serialize readers */
> 
> 
> 
> Why this one? This is a reader lock, not taken in any tracing fast path
> places. Why should it never sleep in rt, it's taken by a reader of the ring
> buffer, which doesn't seem to me involved in any critical work.
> 
> I may be wrong though, better wait for Steve to correct me
> if needed.
> 
> In any case, the changelog needs more details about the individual
> purpose of this patch.

At first I would agree, but looking at where the lock is taken, the one place
that worries me is in ftrace_dump(). It can be called with interrupts
disabled, and if so, it will take this lock. If we let this lock convert
to a mutex, then it can cause issues when ftrace_dump() takes the lock with
interrupts disabled.


> 
> 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 0df1b0f..0c6bbcb 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -258,7 +258,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> >  	TRACE_ITER_GRAPH_TIME;
> >  
> >  static int trace_stop_count;
> > -static DEFINE_SPINLOCK(tracing_start_lock);
> > +static DEFINE_RAW_SPINLOCK(tracing_start_lock);
> 
> 
> Same here. I don't understand why this should never sleep in -rt.
> This is not a critical lock. It is taken in rare and not critical
> places, mostly in reader places when we open/release a trace
> file and also in tracing selftests.

This one I don't see as an issue in changing to a mutex in -rt.
So I agree with Frederic on this.


> 
> 
> 
> > diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> > index 2974bc7..60ba58e 100644
> > --- a/kernel/trace/trace_irqsoff.c
> > +++ b/kernel/trace/trace_irqsoff.c
> > @@ -23,7 +23,7 @@ static int				tracer_enabled __read_mostly;
> >  
> >  static DEFINE_PER_CPU(int, tracing_cpu);
> >  
> > -static DEFINE_SPINLOCK(max_trace_lock);
> > +static DEFINE_RAW_SPINLOCK(max_trace_lock);
> 
> 
> But there yeah, it does seem necessary as it is involved
> in irqsoff tracing fastpath.
> 
> This needs a comment though.

Yeah, you can simply say, this lock is taken by the interrupts off latency
tracer and will always be taken with interrupts disabled.

-- Steve

