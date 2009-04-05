Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbZDEHes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbZDEHes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbZDEHej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:34:39 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:51777 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbZDEHei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ioZF5Rx/pwgR90TuQS8g8FkaBx8+T9d9lYhP7Y7krJFu1ycTgSobnr+1Tip6uVSZe4
         qYeWxnE9GxLkxU5mx0uzD54jhxEQ7FpwsQnCoHagCPaNSSDBwE1qbBB1EJXQ6DZCIjut
         RJ0676ZC65Gd0+n8gi22eDrFSf8tDzbyF6h2w=
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
 when not tracing
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
In-Reply-To: <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com>
References: <1238390546.6368.65.camel@bookworm>
	 <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm>
	 <20090403135956.GD8875@elte.hu>
	 <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com>
	 <1238830355.22495.55.camel@bookworm>
	 <alpine.DEB.2.00.0904041143480.32083@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 02:34:25 -0500
Message-Id: <1238916865.7989.212.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 11:49 -0400, Steven Rostedt wrote:
> On Sat, 4 Apr 2009, Tom Zanussi wrote:
> > 
> > Hmm, after reading Paul's replies, it sounds like this approach might be
> > more trouble than it's worth.  Maybe going back to the idea of
> > temporarily stopping/starting tracing would be a better idea, but with a
> > little more heavyweight version of the current 'quick' tracing
> > start/stop (that would prevent entering the tracing functions (and ththe
> > filter_check_discard()).
> 
> 
> Actually, I forgot what the general problem we are avoiding here with the
> RCU locks. Could you explain that again. Just so that I can get a better
> idea without having to read between the lines of the previous messages in 
> this thread.
> 

Basically the problem is that the tracing functions call
filter_match_preds(call,...) where call->preds is an array of predicates
that get checked to determine whether the current event matches or not.
When an existing filter is deleted (or an old one replaced), the
call->preds array is freed and set to NULL (which happens only via a
write to the 'filter' debugfs file).  So without any protection, while
one cpu is freeing the preds array, the others may still be using it,
and if so, it will crash the box.  You can easily see the problem with
e.g. the function tracer:

# echo function > /debug/tracing/current_tracer

Function tracing is now live

# echo 'common_pid == 0' > /debug/tracing/events/ftrace/function/filter

No problem, no preds are freed the first time

# echo 0 > /debug/tracing/events/ftrace/function/filter

Crash.

My first patch took the safe route and completely disallowed filters
from being set when any tracing was live i.e. you had to for example
echo 0 > tracing_enabled or echo 0 > enable for a particular event, etc.

This wasn't great for usability, though - it would be much nicer to be
able to remove or set new filters on the fly, while tracing is active,
which rcu seemed perfect for - the preds wouldn't actually be destroyed
until all the current users were finished with them.  My second patch
implemented that and it seemed to nicely fix the problem, but it
apparently can cause other problems...

So assuming we can't use rcu for this, it would be nice to have a way to
'pause' tracing so the current filter can be removed i.e. some version
of stop_trace()/start_trace() that make sure nothing is still executing
or can enter filter_match_preds() while the current call->preds is being
destroyed.  Seems like it would be straightforward to implement for the
event tracer, since each event maps to a tracepoint that could be
temporarily unregistered/reregistered, but maybe not so easy for the
ftrace tracers...

Tom

> 
> > 
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

