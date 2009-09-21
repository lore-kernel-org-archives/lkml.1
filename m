Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZIUR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZIUR67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZIUR64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:58:56 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47485 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZIUR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OY+gZ728jW/JN4YuNTY4nOrAM2qeJdFe72r0DnruUJTh4/KXhkOYdV1r2ce5v7/FNM
         +vC6y4iL6HyvLeB6vuoKYu+RqBA7r8vjW/jOV7L8Tz/93B+EjHWfqDz+Pd8quk5qY1am
         MBbwF9EB5C9cp34A65L8VLvsedwbH+cfw4t4U=
Date: Mon, 21 Sep 2009 19:58:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: TRACE_EVENT_ABI ?
Message-ID: <20090921175851.GA5018@nowhere>
References: <20090921093652.0722d745@infradead.org> <alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com> <20090921152853.2f8c0597@infradead.org> <1253551567.2630.26.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253551567.2630.26.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 12:46:07PM -0400, Steven Rostedt wrote:
> On Mon, 2009-09-21 at 15:28 +0200, Arjan van de Ven wrote:
> > On Mon, 21 Sep 2009 09:26:41 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > [ Resending due to wrong SMTP server ]
> > > 
> > > 
> > > On Mon, 21 Sep 2009, Arjan van de Ven wrote:
> > > 
> > > > Hi,
> > > > 
> > > > Ingo suggested to make a TRACE_EVENT_ABI, which is equivalent in
> > > > implementation to TRACE_EVENT, except that it signals a stable
> > > > interface.
> > > > 
> > > > In trying to implement this I'm running into a wall where
> > > > TRACE_EVENT keeps being defined in many different ways all over the
> > > > place, making this a really nasty hack to make it just an alias.
> > > > 
> > > > Do you have any clever ideas on how to make this an alias without
> > > > fouling up the whole tracing system?
> > > > 
> > > 
> > > I don't know what you've done so far, but can't you simply in
> > > tracepoint.h define:
> > > 
> > > #define TRACE_EVENT_API(a,b,c,d,e) TRACE_EVENT(a,b,c,d,e)
> > 
> > unfortunately, due to the preprocessor trickery around TRACE_EVENT this
> > completely barfs.
> 
> I forgot to tell you about PARAMS.
> 
> This patch compiled for me;



Oh! PARAMS!

I've needed something to "contain" cpp args by the past so that they
are not substituted too early, which is needed while relaying cpp args
from a macro to another. I needed this to fix TRACE_EVENT_FN: it barfed
for the exact same reason.

So I've created __cpparg(), which I'm just discovering, does the exact
same thing than PARAM... :-/

I'm going to s/__cpparg/PARAM for the consistency.


 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 63a3f7a..9a983d6 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -280,6 +280,10 @@ static inline void tracepoint_synchronize_unregister(void)
>   * TRACE_EVENT_FN to perform any (un)registration work.
>   */
>  
> +#define TRACE_EVENT_API(name, proto, args, tstruct, assign, print)	\
> +	TRACE_EVENT(name, PARAMS(proto), PARAMS(args),			\
> +		    PARAMS(tstruct), PARAMS(assign), PARAMS(print))
> +
>  #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
>  #define TRACE_EVENT_FN(name, proto, args, struct,		\
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index b48f1ad..0ee1eb6 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -149,7 +149,7 @@ TRACE_EVENT(sched_wakeup_new,
>   * (NOTE: the 'rq' argument is not used by generic trace events,
>   *        but used by the latency tracer plugin. )
>   */
> -TRACE_EVENT(sched_switch,
> +TRACE_EVENT_API(sched_switch,
>  
>  	TP_PROTO(struct rq *rq, struct task_struct *prev,
>  		 struct task_struct *next),
> 
> 

