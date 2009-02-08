Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZBHNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZBHNEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZBHNEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:04:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:38120 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZBHNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Axe7F1A5y31rx4A1XsXRG17ix7CG3joJjDOcFEFYbUCiyuTFfDBIwajhnwtAUf4I0w
         Pi4ErG6scxyZRAjUc544ZdPh0wLp5wbAvHgSiAQJa0KbJjH87lhwS7P2qmE1JHv2KF/E
         cacVMWmM5ztGwlxaHuyaH6chR0Nsx1ORIyWRQ=
Date: Sun, 8 Feb 2009 14:04:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 2/2] tracing: Introduce
	trace_buffer_{lock_reserve,unlock_commit}
Message-ID: <20090208130437.GB6130@nowhere>
References: <20090205181413.GI17653@ghostprotocols.net> <20090205225835.GB23999@nowhere> <20090206015416.GF9846@ghostprotocols.net> <20090206023944.GA24546@nowhere> <20090206031015.GH9846@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206031015.GH9846@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 01:10:15AM -0200, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 06, 2009 at 03:39:45AM +0100, Frederic Weisbecker escreveu:
> > On Thu, Feb 05, 2009 at 11:54:16PM -0200, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Feb 05, 2009 at 11:58:37PM +0100, Frederic Weisbecker escreveu:
> > > > > +void trace_buffer_unlock_commit(struct trace_array *tr,
> > > > > +				struct ring_buffer_event *event,
> > > > > +				unsigned long flags, int pc)
> > > > > +{
> > > > > +	ring_buffer_unlock_commit(tr->buffer, event);
> > > > > +
> > > > > +	ftrace_trace_stack(tr, flags, 6, pc);
> > > > > +	ftrace_trace_userstack(tr, flags, pc);
> > > > > +	trace_wake_up();
> > > > > +}
> > > > 
> > > > 
> > > > I have mitigate feelings about this part. The name of this function could
> > > > have some sense if _most_ of the tracers were using the stack traces. But that's
> > > > not the case.
> > > > 
> > > > We have now this couple:
> > > > 
> > > > _ trace_buffer_lock_reserve() -> handles the ring-buffer reservation, the context info, and the type
> > > > _ trace_buffer_unlock_commit() -> unlock, commit, wake and... stacktraces?
> > > > 
> > > > In my opinion, the latter doesn't follow the logic meaning of the first.
> > > > And the result is a mixup of (trace_buffer | ring_buffer)(lock/unlock/reserve/commit).
> > > > 
> > > > You are sometimes using trace_buffer_lock_reserve followed by ring_buffer_unlock_commit.
> > > > That looks a bit weird: we are using a high level function followed by its conclusion
> > > > on the form of the low lovel function.
> > > > 
> > > > I think the primary role of this new couple should be to simplify the low level ring buffer
> > > > bits as it does. But the stack things should stay separated.
> > > 
> > > Well, the whole reason for this cset was to provide a way to check for
> > > things like stacktrace while reducing the number of explicit calls the
> > > poor driver, oops, ftrace plugin writers had to keep in mind.
> > 
> > 
> > I agree, but that forces those who don't need stacktraces to use
> > a paired trace_buffer_lock_reserve() / ring_buffer_unlock_commit()
> > The poor newcomers will become dizzy with these different namespaces...
> > And it's like managing a file with fopen() and then close() ... :-)
> > 
> >  
> > > So it may well be the case for a better name, but frankly I think that
> > > this is something better left _hidden_, a magic that the plugin writers
> > > doesn't have to deal with.
> > 
> > I agree with you, the stacktraces are used by several tracers, and then
> > it deserves some code factoring.
> > What I would suggest is to have two different trace_buffer_unlock_commit()
> > 
> > Thinking about the name of these functions, since they are in a higher layer
> > than the ring buffer which performs some things with locking and buffers, we could
> > let this latter do his tricky low level work and simply offer some magic functions
> > with magic names:
> > 
> > _ trace_reserve()
> > _ trace_commit()
> > _ trace_commit_stacktrace()
> 
> The point I was trying to make is that the magic is not just
> stacktraces, it may well be some other whizbangfoobar that I don't know
> right now.
> 
> So perhaps, we indeed need some per tracer flags where the driver writer
> can state which kind of magic it _doesn't_ want performed.
>  
> The default would be: magic is in the air... I.e. do whatever magic you
> may find interesting, as I can't foretell.
> 
> - Arnaldo


Ok, yes by making the flags per tracer, it will goes well.
Just one thing, the insertion of an event is sometimes a hot path
like with the functions tracer. And such facility adds some unused function calls
and branch checking.
But on such cases, we can use directly the ring buffer functions :-)

Frederic.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

