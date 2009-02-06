Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbZBFCj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbZBFCj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZBFCjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:39:51 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56898 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZBFCju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:39:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LOcpwp69WQiNmyzHbRWJCkxFLlOUkaLpWEEy4UerUceB0mWukTKYPXweLIpUnDEsM3
         zUiqGhjs7EP+gWZ2WFkDUT3Q6ghHllNTE6Vq1pcA3oNQkgJ+bPLAjkTxvxUHthVtOX8/
         rtz5JW/2cAoYjeHI+Yev59t8h9f41v3p6+MsE=
Date: Fri, 6 Feb 2009 03:39:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 2/2] tracing: Introduce
	trace_buffer_{lock_reserve,unlock_commit}
Message-ID: <20090206023944.GA24546@nowhere>
References: <20090205181413.GI17653@ghostprotocols.net> <20090205225835.GB23999@nowhere> <20090206015416.GF9846@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206015416.GF9846@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:54:16PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 05, 2009 at 11:58:37PM +0100, Frederic Weisbecker escreveu:
> > > +void trace_buffer_unlock_commit(struct trace_array *tr,
> > > +				struct ring_buffer_event *event,
> > > +				unsigned long flags, int pc)
> > > +{
> > > +	ring_buffer_unlock_commit(tr->buffer, event);
> > > +
> > > +	ftrace_trace_stack(tr, flags, 6, pc);
> > > +	ftrace_trace_userstack(tr, flags, pc);
> > > +	trace_wake_up();
> > > +}
> > 
> > 
> > I have mitigate feelings about this part. The name of this function could
> > have some sense if _most_ of the tracers were using the stack traces. But that's
> > not the case.
> > 
> > We have now this couple:
> > 
> > _ trace_buffer_lock_reserve() -> handles the ring-buffer reservation, the context info, and the type
> > _ trace_buffer_unlock_commit() -> unlock, commit, wake and... stacktraces?
> > 
> > In my opinion, the latter doesn't follow the logic meaning of the first.
> > And the result is a mixup of (trace_buffer | ring_buffer)(lock/unlock/reserve/commit).
> > 
> > You are sometimes using trace_buffer_lock_reserve followed by ring_buffer_unlock_commit.
> > That looks a bit weird: we are using a high level function followed by its conclusion
> > on the form of the low lovel function.
> > 
> > I think the primary role of this new couple should be to simplify the low level ring buffer
> > bits as it does. But the stack things should stay separated.
> 
> Well, the whole reason for this cset was to provide a way to check for
> things like stacktrace while reducing the number of explicit calls the
> poor driver, oops, ftrace plugin writers had to keep in mind.


I agree, but that forces those who don't need stacktraces to use
a paired trace_buffer_lock_reserve() / ring_buffer_unlock_commit()
The poor newcomers will become dizzy with these different namespaces...
And it's like managing a file with fopen() and then close() ... :-)

 
> So it may well be the case for a better name, but frankly I think that
> this is something better left _hidden_, a magic that the plugin writers
> doesn't have to deal with.

I agree with you, the stacktraces are used by several tracers, and then
it deserves some code factoring.
What I would suggest is to have two different trace_buffer_unlock_commit()

Thinking about the name of these functions, since they are in a higher layer
than the ring buffer which performs some things with locking and buffers, we could
let this latter do his tricky low level work and simply offer some magic functions
with magic names:

_ trace_reserve()
_ trace_commit()
_ trace_commit_stacktrace()

Even if the stack traces layer can be somewhat hidden to the user, we can still
let him decide what he really wants but in an easier way.

Hm?

> 
> But... if they feel lucky and smart, they can just call
> ring_buffer_unlock_commit(tr->buffer, event) and do any other things in
> a open coded way, as was done in other cases where
> trace_buffer_lock_reserve was paired with ring_buffer_unlock_commit.


Right! And with our three above functions, the new magic way can
be completely performed without beeing harassed by some bits from the
...lucky way :-)


Frederic.

