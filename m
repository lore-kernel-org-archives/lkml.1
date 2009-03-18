Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZCRGHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZCRGHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZCRGGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:06:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:39156 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZCRGGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZB54YF6mSnG5VJ0KFXmz9wdpeBun/8S0DfCXngrxyeRWKv9mXEgHLb8FNfRtV5acno
         Rgyshf/eZazI2gIdMWtuYlq9TTthTpUORIP8hy1p3t+W+dtEp+puA6Wpi7W4KjGvRDwm
         KLgSAz3miYL36BMVamKtBQVZDW8bu3FGv9ULk=
Subject: Re: [RFC][PATCH 3/4] tracing: add per-event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0903172131340.10610@gandalf.stny.rr.com>
References: <1237271031.8033.151.camel@charm-linux>
	 <alpine.DEB.2.00.0903172131340.10610@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 01:06:50 -0500
Message-Id: <1237356410.7922.11.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-03-17 at 21:37 -0400, Steven Rostedt wrote:
> 
> 
> On Tue, 17 Mar 2009, Tom Zanussi wrote:
> > diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> > index 30627d8..d556274 100644
> > --- a/kernel/trace/trace_events_stage_3.h
> > +++ b/kernel/trace/trace_events_stage_3.h
> > @@ -154,6 +154,7 @@ static struct ftrace_event_call event_##call;				\
> >  									\
> >  static void ftrace_raw_event_##call(proto)				\
> >  {									\
> > +	struct ftrace_event_call *call = &event_##call;			\
> >  	struct ring_buffer_event *event;				\
> >  	struct ftrace_raw_##call *entry;				\
> >  	unsigned long irq_flags;					\
> > @@ -172,6 +173,9 @@ static void ftrace_raw_event_##call(proto)				\
> >  	assign;								\
> >  									\
> >  	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
> 
> I have a concern hear about races.  Once the commit happens, there's 
> nothing protecting us from being preempted. The reader could in fact come 
> in and consume the commit, and a new write may happen, and this discard 
> will corrupt the data in the buffer. Also in overwrite mode, the writer 
> itself can over write this.
> 
> Would you be able to move the above unlock_commit after this.
> I'll make the necessary changes in the commit to check for discarded data.
> 

Yeah, I had meant to do that, but was having enough trouble with the
ring-buffer stuff that I wanted to avoid wondering what might happen if
I discarded an uncommitted event at that point.

I'll make that change in the next version.

Tom

> Thanks,
> 
> -- Steve
> 
> 
> 
> > +									
> \ > +	if (call->preds && !filter_match_preds(call, entry))		\
> > +		rb_event_discard(event);				\
> >  }									\
> >  									\
> >  static int ftrace_raw_reg_event_##call(void)				\
> > -- 
> > 1.5.6.3
> > 
> > 
> > 
> > 
> > 
> > 
> > 

