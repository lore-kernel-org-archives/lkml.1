Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZDDRC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZDDRC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDDRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:02:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57369 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZDDRCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:02:18 -0400
Date: Sat, 4 Apr 2009 10:02:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
	when not tracing
Message-ID: <20090404170214.GE6893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu> <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm> <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 11:49:30AM -0400, Steven Rostedt wrote:
> On Sat, 4 Apr 2009, Tom Zanussi wrote:
> > 
> > Hmm, after reading Paul's replies, it sounds like this approach might be
> > more trouble than it's worth.  Maybe going back to the idea of
> > temporarily stopping/starting tracing would be a better idea, but with a
> > little more heavyweight version of the current 'quick' tracing
> > start/stop (that would prevent entering the tracing functions (and ththe
> > filter_check_discard()).
> 
> Actually, I forgot what the general problem we are avoiding here with the
> RCU locks. Could you explain that again. Just so that I can get a better
> idea without having to read between the lines of the previous messages in 
> this thread.

I would be interested in hearing this as well.

							Thanx, Paul

> > I was thinking it would be something like:
> > 
> > stop_tracing();
> > current_tracer->stop(); /* unregister tracepoints, etc */
> > 
> > remove filter
> > 
> > current_tracer->start(); /* reregister tracepoints, etc */
> > start_tracing();
> 
> This use to be the way start and stop worked, but I'm trying to
> make them more light weight. I've been wanting start/stop to be called
> by start_tracing() and stop_tracing() and those should be able to be 
> called in any context. But registering and unregistering tracepoints calls 
> mutexes, which can not be done in atomic context.
> 
> There are still some tracers that have start/stop using sleeping code, but 
> in the long run I want the tracers start/stop functions to be light.
> 
> 
> > 
> > The struct tracer comments suggest that the stop()/start()
> > ops are meant for pausing, I'd guess for things like this, but some of
> > the tracers don't implement them.
> 
> Yeah, They should, but leaving out the start/stop functions, is just
> the tracers way of saying, I don't need to pause. :-/
> 
> > 
> > For the events in the event tracer, it would be something like:
> > 
> > stop_tracing();
> > call->unregfunc(); /* unregister tracepoint */
> > 
> > remove filter
> > 
> > call->regfunc(); /* reregister tracepoint */
> > start_tracing();
> > 
> > If that makes sense, I can try it that way instead.
> > 
> 
> I'll comment about this if I get that explanation of the problem again ;-)
> 
> -- Steve
> 
