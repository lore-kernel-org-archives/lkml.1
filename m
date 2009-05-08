Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZEHLfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZEHLfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZEHLfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:35:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZEHLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:35:23 -0400
Date: Fri, 8 May 2009 07:35:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for
 ftrace_set_clr_event()
In-Reply-To: <20090508105013.GA6417@nowhere>
Message-ID: <alpine.DEB.2.00.0905080727290.28378@gandalf.stny.rr.com>
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Frederic Weisbecker wrote:
> >  
> > -static int ftrace_set_clr_event(char *buf, int set)
> > +/*
> > + * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
> > + */
> > +static int __ftrace_set_clr_event(const char *match, const char *sub,
> > +				  const char *event, int set)
> >  {
> >  	struct ftrace_event_call *call;
> > +	int ret;
> > +
> > +	mutex_lock(&event_mutex);
> > +	list_for_each_entry(call, &ftrace_events, list) {
> > +
> > +		if (!call->name || !call->regfunc)
> > +			continue;
> > +
> > +		if (match &&
> > +		    strcmp(match, call->name) != 0 &&
> > +		    strcmp(match, call->system) != 0)
> > +			continue;
> > +
> > +		if (sub && strcmp(sub, call->system) != 0)
> > +			continue;
> > +
> > +		if (event && strcmp(event, call->name) != 0)
> > +			continue;
> 
> 
> Neat: You can simply use !strcmp(...)

Hehe, no he can't. It would be "strcmp(...)" for the true case. This is 
exactly why I prefer to use "strcmp(...) != 0" over "!strcmp(...)". 
Because, like you, I've confused "!strcmp(...)" too many times as "not a 
match" when it in fact means "is a match".

I've made this mistake enough that I've given up on using just "strcmp" or 
"!strcmp". "strcmp() != 0" and "strcmp() == 0" show what you want much 
better.

-- Steve

