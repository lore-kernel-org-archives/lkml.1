Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZH0P5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZH0P5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZH0P5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:57:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZH0P5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:57:34 -0400
Date: Thu, 27 Aug 2009 11:57:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
In-Reply-To: <1251354307.18584.40.camel@twins>
Message-ID: <alpine.DEB.2.00.0908271156300.11745@gandalf.stny.rr.com>
References: <1251197235.7538.1142.camel@twins>  <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com>  <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins>  <4A94DFF4.5030301@cn.fujitsu.com>  <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
  <20090826164624.GA21456@Krystal>  <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com>  <20090826180114.GA29130@Krystal> <20090826181758.GA30248@Krystal>  <alpine.DEB.2.00.0908261544590.11291@gandalf.stny.rr.com> <1251354307.18584.40.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Peter Zijlstra wrote:

> On Wed, 2009-08-26 at 15:48 -0400, Steven Rostedt wrote:
> >  									\
> > @@ -399,16 +413,20 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
> >  {									\
> >  	int ret = 0;							\
> >  									\
> > -	if (!atomic_inc_return(&event_call->profile_count))		\
> > +	if (!atomic_inc_return(&event_call->profile_count)) {		\
> > +		event_trace_up_ref();					\
> >  		ret = register_trace_##call(ftrace_profile_##call);	\
> > +	}								\
> >  									\
> >  	return ret;							\
> >  }									\
> >  									\
> >  static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
> >  {									\
> > -	if (atomic_add_negative(-1, &event_call->profile_count))	\
> > +	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
> >  		unregister_trace_##call(ftrace_profile_##call);		\
> > +		event_trace_down_ref();					\
> > +	}								\
> >  }
> 
> Ha, almost, make that {un,}register_ftrace_##call() and stick the module
> gunk in there, and I'm ok.

Peter, that {un,}register_tace_##call is the tracepoint code. The 
DEFINE_TRACE creates those functions. This is the lowest level we can go 
in the ftrace.h file.

-- Steve

