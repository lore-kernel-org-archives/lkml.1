Return-Path: <linux-kernel-owner+w=401wt.eu-S935176AbZDCQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbZDCQ1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765339AbZDCQ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:26:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44735 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936403AbZDCQ0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:26:47 -0400
Date: Fri, 3 Apr 2009 09:26:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090403162642.GB6968@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403135956.GD8875@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 03:59:56PM +0200, Ingo Molnar wrote:
> 
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > On Wed, 2009-04-01 at 14:24 +0200, Ingo Molnar wrote:
> > > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > > 
> > > > This patch adds code allowing the event filter to be set only if 
> > > > there's no active tracing going on.
> > > 
> > > > --- a/kernel/trace/trace_events.c
> > > > +++ b/kernel/trace/trace_events.c
> > > > @@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > >  	struct filter_pred *pred;
> > > >  	int err;
> > > >  
> > > > +	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
> > > > +		return -EBUSY;
> > > 
> > > hm, but it would be the normal use-case to set filters on the fly. 
> > > To experiment around with them and shape them until the output is 
> > > just right. Having to turn the tracer on/off during that seems quite 
> > > counterproductive to that use-case.
> > > 
> > 
> > I didn't see anything that could be used to temporarily disable 
> > tracing (tracing_stop() and tracing_start() are 'quick' versions 
> > that mostly just disable recording), so did it this way to avoid 
> > adding any overhead to the filter-checking code.
> > 
> > But anyway, I'll post a new patch shortly that uses rcu and does 
> > allow the filters to be set on the fly.
> 
> that's a very intelligent way to do it!
> 
> There's a theoretical problem though: what if we put a filtered 
> tracepoint into the RCU code? Especially if that tracepoint is in 
> the common function-tracer callback affecting all kernel functions. 
> I've Cc:-ed Paul. I think the quiescent state logic should handle 
> this just fine, but i'm not 100% sure.

Disclaimer: I don't claim to fully understand the code.  I do not see any
problems tracing the quiescent-state logic.  However, it appears to me
that you don't get to set tracepoints in the idle loop for rcuclassic,
rcutree, and rcutiny.

My kneejerk reaction is "why would anyone want to trace the idle loop?"

							Thanx, Paul
