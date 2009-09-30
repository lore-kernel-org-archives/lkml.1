Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZI3Im3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZI3Im3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZI3Im2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:42:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41954 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZI3Im2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:42:28 -0400
Subject: Re: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20090929092245.GA5057@nowhere>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
	 <20090929092245.GA5057@nowhere>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 04:41:15 -0400
Message-Id: <1254300075.7286.2.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-29 at 11:22 +0200, Frederic Weisbecker wrote:
> On Mon, Sep 28, 2009 at 04:43:01PM +0100, Matt Fleming wrote:
> > From: Matt Fleming <matthew.fleming@imgtec.com>
> > 
> > When CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST is enabled
> > __ftrace_trace_function contains the current trace function, not
> > ftrace_trace_function. In ftrace_update_pid_func() we currently
> > incorrectly assign the value of ftrace_trace_function to
> > __ftrace_trace_funcion before returning.
> > 
> > Without this patch it is possible to execute an infinite loop whereby
> > ftrace_test_stop_func() calls __ftrace_trace_function, which was
> > assigned ftrace_test_stop_func() in ftrace_update_pid_func().
> > 
> > Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> > ---
> >  kernel/trace/ftrace.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 25edd5c..d9ba6d9 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -225,7 +225,11 @@ static void ftrace_update_pid_func(void)
> >  	if (ftrace_trace_function == ftrace_stub)
> >  		return;
> >  
> > +#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> >  	func = ftrace_trace_function;
> > +#else
> > +	func = __ftrace_trace_function;
> > +#endif
> 
> 
> 
> I don't understand how it can do that infinite loop.
> It doesn't seem the following can happen:
> 
> func = ftrace_trace_function  //which is ftrace_test_stop_func
> 
> _ftrace_trace_function = func
> 
> Because we can sum up the path like that:
> 
> func = ftrace_trace_function;
> 
> ...
> 
> 
> #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
> 	ftrace_trace_function = func;
> #else
> 	__ftrace_trace_function = func;
> #endif
> 
> So if we are in CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST,
> that doesn't seem to harm, although it seems that what we want is
> 
> func = __ftrace_trace_function
> 
> ...
> 
> __ftrace_trace_function = func
> 
> Because we want to always keep ftrace_test_stop_func as the top level
> wrapper. Which would be what does the above, plus the fact we avoid any
> recursivity.
> 
> But it's possible I'm missing the point...
> 
> Also, Steve, is this an option that is still useful? It's even not
> in Kconfig.
> 

Yeah, Matt found a real bug, and yes it will infinitely recurse. The
thing is that the function can call itself which will continue to do so.

As for the Kconfig, it's something that currently only x86 selects,
because x86 does the test in entry.S.


Matt,

Thanks, I'll pull this in as soon as I get back from Dresden.

-- Steve


