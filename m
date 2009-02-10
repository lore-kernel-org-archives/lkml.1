Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZBJOzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZBJOzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZBJOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:54:54 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:3317 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZBJOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f6cEyZs0NuFmYTQBXwD+z4pJl849deFT3qcu4by+xMj1ggRDe53Z95oRkPZpOgFzRQ
         FFMK7sq/AOjsewb38vKC4LCkW0cDbLajwkNKmNztJKBbtrhLl6xnSqDkZwJiOeIiwCpJ
         MnIrF841DcFSVOFrE5Clapww/58Gd7nUTZ5xc=
Date: Tue, 10 Feb 2009 15:54:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 2/2] tracing/core: use appropriate waiting on trace_pipe
Message-ID: <20090210145449.GF5836@nowhere>
References: <4990fdc0.0af5660a.678f.ffffd47b@mx.google.com> <20090210120205.GA19297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210120205.GA19297@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:02:05PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> >  static int tracing_wait_pipe(struct file *filp)
> >  {
> > +	DEFINE_WAIT(wait);
> >  	struct trace_iterator *iter = filp->private_data;
> >  
> >  	while (trace_empty(iter)) {
> > -
> >  		if ((filp->f_flags & O_NONBLOCK)) {
> >  			return -EAGAIN;
> >  		}
> >  
> > -		/*
> > -		 * This is a make-shift waitqueue. The reason we don't use
> > -		 * an actual wait queue is because:
> > -		 *  1) we only ever have one waiter
> > -		 *  2) the tracing, traces all functions, we don't want
> > -		 *     the overhead of calling wake_up and friends
> > -		 *     (and tracing them too)
> > -		 *     Anyway, this is really very primitive wakeup.
> > -		 */
> > -		set_current_state(TASK_INTERRUPTIBLE);
> > -		iter->tr->waiter = current;
> > -
> >  		mutex_unlock(&trace_types_lock);
> >  
> > -		/* sleep for 100 msecs, and try again. */
> > -		schedule_timeout(HZ/10);
> > +		if (might_hold_runqueue_lock(iter->trace)) {
> > +			/*
> > +			 * This is a make-shift waitqueue. The reason we don't
> > +			 * use an actual wait queue is because:
> > +			 *  1) we only ever have one waiter
> > +			 *  2) the tracing, traces all functions, we don't want
> > +			 *     the overhead of calling wake_up and friends
> > +			 *     (and tracing them too)
> > +			 *     Anyway, this is really very primitive wakeup.
> > +			 */
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			schedule_timeout(HZ / 10);
> 
> Instead of adding this ugly dynamic switch in the middle of tracing_wait_pipe(), i'd 
> suggest to restructure this along the following lines:
> 
> 1) move the new waiting waitqueue based function into default_wait_pipe() function
> 
> 2) add a poll_wait_pipe() function as well that does the old 100 msecs polling 
>    method
> 
> 3) add a iter->wait_pipe() method that is called by tracing_wait_pipe()
> 
> 4) make register_tracer() fill in default_wait_pipe() for plugins that do not 
>    register an explicit ->wait_pipe method.
> 
> That way the 'special', intrusive tracers (like sched and function tracer) can still 
> specify poll_wait_pipe() - while the others will default to the waitqueue based 
> tracing_wait_pipe() method.
> 
> 	Ingo

That's more smart indeed!
I will take advantage of this v2 to add more comments on the struct tracer.

Thanks.

