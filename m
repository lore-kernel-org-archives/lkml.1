Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZI2JWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZI2JWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZI2JWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:22:44 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39091 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZI2JWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RRhLV2HBvCh0uDWVXdjKhrJz7jvS/ELpz/hOc7sk0Jfwn5OUZKnwCtO4yJDG9edudA
         GbGOM2WQTk4cuF9sayu5MyGAlIjy9sVQgrVSKt3yxkqzG/iETJTg/iDjsrR9xerqjxeN
         TCcWYC3DBpWSTAKHjv293bzEes1ra5/y5ECb8=
Date: Tue, 29 Sep 2009 11:22:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Matt Fleming <matt@console-pimps.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tracing: Fix infinite loop in ftrace_update_pid_func()
Message-ID: <20090929092245.GA5057@nowhere>
References: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254152581-18347-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:43:01PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
> 
> When CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST is enabled
> __ftrace_trace_function contains the current trace function, not
> ftrace_trace_function. In ftrace_update_pid_func() we currently
> incorrectly assign the value of ftrace_trace_function to
> __ftrace_trace_funcion before returning.
> 
> Without this patch it is possible to execute an infinite loop whereby
> ftrace_test_stop_func() calls __ftrace_trace_function, which was
> assigned ftrace_test_stop_func() in ftrace_update_pid_func().
> 
> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> ---
>  kernel/trace/ftrace.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 25edd5c..d9ba6d9 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -225,7 +225,11 @@ static void ftrace_update_pid_func(void)
>  	if (ftrace_trace_function == ftrace_stub)
>  		return;
>  
> +#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	func = ftrace_trace_function;
> +#else
> +	func = __ftrace_trace_function;
> +#endif



I don't understand how it can do that infinite loop.
It doesn't seem the following can happen:

func = ftrace_trace_function  //which is ftrace_test_stop_func

_ftrace_trace_function = func

Because we can sum up the path like that:

func = ftrace_trace_function;

...


#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
	ftrace_trace_function = func;
#else
	__ftrace_trace_function = func;
#endif

So if we are in CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST,
that doesn't seem to harm, although it seems that what we want is

func = __ftrace_trace_function

...

__ftrace_trace_function = func

Because we want to always keep ftrace_test_stop_func as the top level
wrapper. Which would be what does the above, plus the fact we avoid any
recursivity.

But it's possible I'm missing the point...

Also, Steve, is this an option that is still useful? It's even not
in Kconfig.

