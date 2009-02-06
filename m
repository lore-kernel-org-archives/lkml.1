Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZBFByl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZBFByl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBFByd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:54:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBFByc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:54:32 -0500
Date: Thu, 5 Feb 2009 23:54:16 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 2/2] tracing: Introduce
	trace_buffer_{lock_reserve,unlock_commit}
Message-ID: <20090206015416.GF9846@ghostprotocols.net>
References: <20090205181413.GI17653@ghostprotocols.net> <20090205225835.GB23999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205225835.GB23999@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 05, 2009 at 11:58:37PM +0100, Frederic Weisbecker escreveu:
> > +void trace_buffer_unlock_commit(struct trace_array *tr,
> > +				struct ring_buffer_event *event,
> > +				unsigned long flags, int pc)
> > +{
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> > +
> > +	ftrace_trace_stack(tr, flags, 6, pc);
> > +	ftrace_trace_userstack(tr, flags, pc);
> > +	trace_wake_up();
> > +}
> 
> 
> I have mitigate feelings about this part. The name of this function could
> have some sense if _most_ of the tracers were using the stack traces. But that's
> not the case.
> 
> We have now this couple:
> 
> _ trace_buffer_lock_reserve() -> handles the ring-buffer reservation, the context info, and the type
> _ trace_buffer_unlock_commit() -> unlock, commit, wake and... stacktraces?
> 
> In my opinion, the latter doesn't follow the logic meaning of the first.
> And the result is a mixup of (trace_buffer | ring_buffer)(lock/unlock/reserve/commit).
> 
> You are sometimes using trace_buffer_lock_reserve followed by ring_buffer_unlock_commit.
> That looks a bit weird: we are using a high level function followed by its conclusion
> on the form of the low lovel function.
> 
> I think the primary role of this new couple should be to simplify the low level ring buffer
> bits as it does. But the stack things should stay separated.

Well, the whole reason for this cset was to provide a way to check for
things like stacktrace while reducing the number of explicit calls the
poor driver, oops, ftrace plugin writers had to keep in mind.

So it may well be the case for a better name, but frankly I think that
this is something better left _hidden_, a magic that the plugin writers
doesn't have to deal with.

But... if they feel lucky and smart, they can just call
ring_buffer_unlock_commit(tr->buffer, event) and do any other things in
a open coded way, as was done in other cases where
trace_buffer_lock_reserve was paired with ring_buffer_unlock_commit.

- Arnaldo
