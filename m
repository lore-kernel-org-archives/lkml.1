Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZGGCPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZGGCPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 22:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZGGCPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 22:15:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZGGCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 22:15:11 -0400
Date: Mon, 6 Jul 2009 22:15:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] ftrace: Add duration filtering to function graph
 tracer
In-Reply-To: <4A52A74D.8000005@am.sony.com>
Message-ID: <alpine.DEB.2.00.0907062212370.8813@gandalf.stny.rr.com>
References: <4A528769.5020200@am.sony.com> <alpine.DEB.2.00.0907062017510.8813@gandalf.stny.rr.com> <4A52A74D.8000005@am.sony.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 6 Jul 2009, Tim Bird wrote:

> Steven Rostedt wrote:
> > On Mon, 6 Jul 2009, Tim Bird wrote:
> > 
> >> Add duration filtering to the function graph tracer.
> >>
> >> The duration filter value is set in the 'tracing_thresh'
> >> pseudo-file.  Values are in microseconds (as is customary
> >> for that file).
> >>
> >> This adds ring_buffer_peek_previous(), used to help
> >> remove the function entry event from the trace log,
> >> where this is possible.
> >>
> >> To use:
> >>  $ cd <debugfs tracing directory>
> >>  $ echo 100 >tracing_thresh
> >>  $ echo function_graph >current_tracer
> >>  $ cat trace
> > 
> > I see what you are trying to do, but this can be really dangerous. 
> > Remember, the ring buffer is now lockless. This could probably cause some 
> > problems with various races.
> 
> That's something I'm worried about.
> 
> Note that this patch only uses ring_buffer_peek_previous (which doesn't
> alter anything in the log), and ring_buffer_event_discard(), which should
> be atomic on "blotting out" the entry.  Obviously, a change of page
> contents between the two would make things interesting, but since
> this is in the committed area of a page, that seems really unlikely.
> 
> However, the truly dangerous stuff is in updating the commit pointer.
> (ring_buffer_rewind_tail in patch 2/2).
> 
> As near as I can tell, that should be safe when a reader is not
> going at the same time as a writer.  In my use cases, I don't let
> readers and writers go at the same time (that is, the trace is always
> stopped when I'm dumping it.)  I'm not sure if this is an acceptable
> condition to put on use of this feature or not, but it it was found
> to guarantee safeness, it could be enforced via the user interface.

There's no guarantee that readers will not be going at the same time
as writers. I tried hard to allow the ring buffer to accept a reader on
another CPU while writers were happening. A writer may even preempt a 
reader on the same CPU.

> 
> > If you want a duration field in the function graph tracer, perhaps only do 
> > the recording on the exit side. That may be tricky since you would also 
> > need to keep the stack order as well.
> 
> This might work.
> 
> For a single process, I have calling order in ret_stack.  I also have calltime,
> which should be granular enough to disentangle the call starts for functions
> from different processes.  It might need a post-trace reprocessor to fix up
> the results, though.
> 
> > Perhaps implement an auxiliary ring buffer?
> This is a possibility.  Are you thinking of something like double-buffering
> the events?
> 
> Another thing I thought of was to not commit the entry event until function
> exit.  I'm not sure the ring buffer supports having an entry outstanding for
> long periods of time, though. This would, I believe, hold readers at the entries for
> the last 'completed' functions, which might solve reader/writer races.

Heh, I doubt that would be acceptable. The problem is that between reserve 
and commit, we disable preemption. Thus every function (even the scheduler 
itself) would have preemption disabled ;-)

-- Steve


> 
> I should add, that although this stuff looks dangerous, it's working pretty
> well for me here.  As a debug tool, I could tolerate the occasional hang.
> I'm not seeing any so far, but to be honest I haven't really pounded hard
> on it yet.

> 
> =============================
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =============================
> 
> 
