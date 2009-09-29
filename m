Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZI2JoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZI2JoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZI2JoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:44:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44580 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZI2JoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:44:09 -0400
Date: Tue, 29 Sep 2009 10:44:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
Message-ID: <20090929094442.GA6934@console-pimps.org>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org> <20090929092245.GA5057@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929092245.GA5057@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:22:47AM +0200, Frederic Weisbecker wrote:
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

Here is the unpatched version of ftrace_update_pid_func() from
kernel/trace/ftrace.c

Before calling:
       ftrace_trace_function = ftrace_test_stop_func
       __ftrace_trace_Function = real tracing function

static void ftrace_update_pid_func(void)
{
	ftrace_func_t func;

	if (ftrace_trace_function == ftrace_stub)
		return;

	func = ftrace_trace_function;

	if (ftrace_pid_trace) {
		set_ftrace_pid_function(func);
		func = ftrace_pid_func;
	} else {
		if (func == ftrace_pid_func)
			func = ftrace_pid_function;
	}

#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
	ftrace_trace_function = func;
#else
	__ftrace_trace_function = func;
#endif
}

After calling:
      ftrace_trace_function = ftrace_test_stop_func
      __ftrace_trace_function = ftrace_test_stop_func


Then look what happens next time ftrace_test_stop_func() is called via
ftrace_call,

#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
/*
 * For those archs that do not test ftrace_trace_stop in their
 * mcount call site, we need to do it from C.
 */
static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
{
	if (function_trace_stop)
		return;

	__ftrace_trace_function(ip, parent_ip);
}
#endif

Here we're going to recurse infinitely because,
     __ftrace_trace_function = ftrace_test_stop_func

