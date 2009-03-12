Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbZCLNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbZCLNZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZCLNZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:25:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZCLNZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:25:06 -0400
Date: Thu, 12 Mar 2009 09:25:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: keep ring buffer to minimum size till
 used
In-Reply-To: <20090311202637.d8c2343b.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903120923150.3062@gandalf.stny.rr.com>
References: <20090312023720.144716747@goodmis.org> <20090312023936.000182747@goodmis.org> <20090311202637.d8c2343b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Mar 2009, Andrew Morton wrote:

> On Wed, 11 Mar 2009 22:37:21 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: less memory impact on systems not using tracer
> > 
> > When the kernel boots up that has tracing configured, it allocates
> > the default size of the ring buffer. This currently happens to be
> > 1.4Megs per possible CPU. This is quite a bit of wasted memory if
> > the system is never using the tracer.
> > 
> > The current solution is to keep the ring buffers to a minimum size
> > until the user uses them. Once a tracer is piped into the current_tracer
> > the ring buffer will be expanded to the default size. If the user
> > changes the size of the ring buffer, it will take the size given
> > by the user immediately.
> > 
> > If the user adds a "ftrace=" to the kernel command line, then the ring
> > buffers will be set to the default size on initialization.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/trace.c |   79 +++++++++++++++++++++++++++++++++++++------------
> >  1 files changed, 59 insertions(+), 20 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 4c97947..0c1dc18 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -45,6 +45,12 @@ unsigned long __read_mostly	tracing_max_latency;
> >  unsigned long __read_mostly	tracing_thresh;
> >  
> >  /*
> > + * On boot up, the ring buffer is set to the minimum size, so that
> > + * we do not waste memory on systems that are not using tracing.
> > + */
> > +static int ring_buffer_expanded;
> > +
> > +/*
> >   * We need to change this state when a selftest is running.
> >   * A selftest will lurk into the ring-buffer to count the
> >   * entries inserted during the selftest although some concurrent
> > @@ -128,6 +134,8 @@ static int __init set_ftrace(char *str)
> >  {
> >  	strncpy(bootup_tracer_buf, str, BOOTUP_TRACER_SIZE);
> >  	default_bootup_tracer = bootup_tracer_buf;
> > +	/* We are using ftrace early, expand it */
> > +	ring_buffer_expanded = 1;
> >  	return 1;
> >  }
> >  __setup("ftrace=", set_ftrace);
> > @@ -2315,6 +2323,40 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
> >  	return t->init(tr);
> >  }
> >  
> > +static int tracing_resize_ring_buffer(unsigned long size)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * If kernel or user changes the size of the ring buffer
> > +	 * it get completed.
> > +	 */
> 
> That comment needs help.

Hmm, I wonder what kind of drugs I was on when I wrote that ;-)
Seriously, I think that was a cut and paste error. Looks like I some
how killed a line :-/

> 
> > +	ring_buffer_expanded = 1;
> > +
> > +	ret = ring_buffer_resize(global_trace.buffer, size);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = ring_buffer_resize(max_tr.buffer, size);
> > +	if (ret < 0) {
> > +		int r;
> > +
> > +		r = ring_buffer_resize(global_trace.buffer,
> > +				       global_trace.entries);
> > +		if (r < 0) {
> > +			/* AARGH! We are left with different
> > +			 * size max buffer!!!! */
> 
> So does that one, but at least it's understandable ;)
> 
> > +			WARN_ON(1);
> > +			tracing_disabled = 1;
> > +		}
> > +		return ret;
> > +	}
> > +
> > +	global_trace.entries = size;
> > +
> > +	return ret;
> > +}
> > +
> >  struct trace_option_dentry;
> >  
> >  static struct trace_option_dentry *
> > @@ -2330,6 +2372,13 @@ static int tracing_set_tracer(const char *buf)
> >  	struct tracer *t;
> >  	int ret = 0;
> >  
> > +	if (!ring_buffer_expanded) {
> > +		ret = tracing_resize_ring_buffer(trace_buf_size);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret = 0;
> > +	}
> 
> This would look a bit less racy were it to happen inside the lock.

Agreed.

Thanks, I'll go make the updates.

-- Steve

> 
> >  	mutex_lock(&trace_types_lock);
> >  	for (t = trace_types; t; t = t->next) {
> >  		if (strcmp(t->name, buf) == 0)
> 
> 
