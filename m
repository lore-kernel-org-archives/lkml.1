Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZEHLr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZEHLr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZEHLrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:47:48 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43349 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZEHLrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uQVsqvbGH8LtvBAHtTPMUa+m+Z+X4Vd7Bkey+jtKxkwzjhysfFy8jLKi4CaJg3R77S
         bHu83JJNTemF0bK/MEVYEIdUj9EEfNNceRIWffd1dl2muYydPMFdrs20kcdlDvqCianI
         +IUMdOD60atkYocemytRRXBwOkrsNYRToveEU=
Date: Fri, 8 May 2009 13:47:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
Message-ID: <20090508114744.GF6417@nowhere>
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere> <alpine.DEB.2.00.0905080727290.28378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905080727290.28378@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 07:35:22AM -0400, Steven Rostedt wrote:
> 
> On Fri, 8 May 2009, Frederic Weisbecker wrote:
> > >  
> > > -static int ftrace_set_clr_event(char *buf, int set)
> > > +/*
> > > + * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
> > > + */
> > > +static int __ftrace_set_clr_event(const char *match, const char *sub,
> > > +				  const char *event, int set)
> > >  {
> > >  	struct ftrace_event_call *call;
> > > +	int ret;
> > > +
> > > +	mutex_lock(&event_mutex);
> > > +	list_for_each_entry(call, &ftrace_events, list) {
> > > +
> > > +		if (!call->name || !call->regfunc)
> > > +			continue;
> > > +
> > > +		if (match &&
> > > +		    strcmp(match, call->name) != 0 &&
> > > +		    strcmp(match, call->system) != 0)
> > > +			continue;
> > > +
> > > +		if (sub && strcmp(sub, call->system) != 0)
> > > +			continue;
> > > +
> > > +		if (event && strcmp(event, call->name) != 0)
> > > +			continue;
> > 
> > 
> > Neat: You can simply use !strcmp(...)
> 
> Hehe, no he can't. It would be "strcmp(...)" for the true case. This is 
> exactly why I prefer to use "strcmp(...) != 0" over "!strcmp(...)". 
> Because, like you, I've confused "!strcmp(...)" too many times as "not a 
> match" when it in fact means "is a match".
> 
> I've made this mistake enough that I've given up on using just "strcmp" or 
> "!strcmp". "strcmp() != 0" and "strcmp() == 0" show what you want much 
> better.
> 

You're right. It provides a good disambiguation.
The C philosophy has this 0 == SUCCESS convention which doesn't match
the human brain logic that expect 0 is a false and 1 is a true....

I guess that's because "!" provides quick checks about non-failures
and detailed errors can then fit in custom values. But still, I guess
we all stuck in this scheme, at least in a last remaining nerve cell
which says "hell, but look! wtf...", though this poor neurone ends
up being punched and kicked by the rest of the brain folks...


Frederic.

