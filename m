Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZDCQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZDCQiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZDCQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:38:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbZDCQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:38:04 -0400
Date: Fri, 3 Apr 2009 18:37:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090403163755.GA3047@elte.hu>
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <20090403162642.GB6968@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403162642.GB6968@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Fri, Apr 03, 2009 at 03:59:56PM +0200, Ingo Molnar wrote:
> > 
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > On Wed, 2009-04-01 at 14:24 +0200, Ingo Molnar wrote:
> > > > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > > > 
> > > > > This patch adds code allowing the event filter to be set only if 
> > > > > there's no active tracing going on.
> > > > 
> > > > > --- a/kernel/trace/trace_events.c
> > > > > +++ b/kernel/trace/trace_events.c
> > > > > @@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > > >  	struct filter_pred *pred;
> > > > >  	int err;
> > > > >  
> > > > > +	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
> > > > > +		return -EBUSY;
> > > > 
> > > > hm, but it would be the normal use-case to set filters on the fly. 
> > > > To experiment around with them and shape them until the output is 
> > > > just right. Having to turn the tracer on/off during that seems quite 
> > > > counterproductive to that use-case.
> > > > 
> > > 
> > > I didn't see anything that could be used to temporarily disable 
> > > tracing (tracing_stop() and tracing_start() are 'quick' versions 
> > > that mostly just disable recording), so did it this way to avoid 
> > > adding any overhead to the filter-checking code.
> > > 
> > > But anyway, I'll post a new patch shortly that uses rcu and does 
> > > allow the filters to be set on the fly.
> > 
> > that's a very intelligent way to do it!
> > 
> > There's a theoretical problem though: what if we put a filtered 
> > tracepoint into the RCU code? Especially if that tracepoint is in 
> > the common function-tracer callback affecting all kernel functions. 
> > I've Cc:-ed Paul. I think the quiescent state logic should handle 
> > this just fine, but i'm not 100% sure.
> 
> Disclaimer: I don't claim to fully understand the code.  I do not see any
> problems tracing the quiescent-state logic.  However, it appears to me
> that you don't get to set tracepoints in the idle loop for rcuclassic,
> rcutree, and rcutiny.
> 
> My kneejerk reaction is "why would anyone want to trace the idle 
> loop?"

heh :-)

Idle enter/exit events are useful to tune power use for example. The 
more events we have there, the more we prevent the CPU from slowly 
going into deep sleep mode.

	Ingo
