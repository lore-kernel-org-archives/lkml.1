Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZDDPto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZDDPto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZDDPtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:49:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZDDPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:49:33 -0400
Date: Sat, 4 Apr 2009 11:49:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
In-Reply-To: <1238830355.22495.55.camel@bookworm>
Message-ID: <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com>
References: <1238390546.6368.65.camel@bookworm>  <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm>  <20090403135956.GD8875@elte.hu>  <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com> <1238830355.22495.55.camel@bookworm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 4 Apr 2009, Tom Zanussi wrote:
> 
> Hmm, after reading Paul's replies, it sounds like this approach might be
> more trouble than it's worth.  Maybe going back to the idea of
> temporarily stopping/starting tracing would be a better idea, but with a
> little more heavyweight version of the current 'quick' tracing
> start/stop (that would prevent entering the tracing functions (and ththe
> filter_check_discard()).


Actually, I forgot what the general problem we are avoiding here with the
RCU locks. Could you explain that again. Just so that I can get a better
idea without having to read between the lines of the previous messages in 
this thread.


> 
> I was thinking it would be something like:
> 
> stop_tracing();
> current_tracer->stop(); /* unregister tracepoints, etc */
> 
> remove filter
> 
> current_tracer->start(); /* reregister tracepoints, etc */
> start_tracing();

This use to be the way start and stop worked, but I'm trying to
make them more light weight. I've been wanting start/stop to be called
by start_tracing() and stop_tracing() and those should be able to be 
called in any context. But registering and unregistering tracepoints calls 
mutexes, which can not be done in atomic context.

There are still some tracers that have start/stop using sleeping code, but 
in the long run I want the tracers start/stop functions to be light.


> 
> The struct tracer comments suggest that the stop()/start()
> ops are meant for pausing, I'd guess for things like this, but some of
> the tracers don't implement them.

Yeah, They should, but leaving out the start/stop functions, is just
the tracers way of saying, I don't need to pause. :-/

> 
> For the events in the event tracer, it would be something like:
> 
> stop_tracing();
> call->unregfunc(); /* unregister tracepoint */
> 
> remove filter
> 
> call->regfunc(); /* reregister tracepoint */
> start_tracing();
> 
> If that makes sense, I can try it that way instead.
> 

I'll comment about this if I get that explanation of the problem again ;-)

-- Steve

