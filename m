Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZFJS4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZFJS4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZFJS43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:56:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbZFJS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:56:29 -0400
Date: Wed, 10 Jun 2009 14:56:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier@gentoo.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
In-Reply-To: <1244623722-6325-2-git-send-email-vapier@gentoo.org>
Message-ID: <alpine.DEB.2.00.0906101449320.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org> <1244623722-6325-2-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Mike Frysinger wrote:
>  The File System
>  ---------------
>  
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 417d198..be936c9 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -14,9 +14,46 @@ config HAVE_FTRACE_NMI_ENTER
>  
>  config HAVE_FUNCTION_TRACER
>  	bool
> +	help
> +	  Implement support for the _mcount() function (or whatever your
> +	  toolchain names it), and the ftrace_stub function (which only
> +	  does a return).
> +
> +	  The _mcount() function should check the function pointer
> +	  ftrace_trace_function to see if it is set to ftrace_stub.  If
> +	  it is, there is nothing for you to do -- return.  If it isn't,
> +	  then call it the same way the _mcount() function normally calls
> +	  __mcount_internal() -- the first argument is the "frompc" while
> +	  the second argument is the "selfpc" (adjusted to remove the size
> +	  of the embedded _mcount() call).
> +
> +	  For example, if the function foo() calls bar(), when the bar()
> +	  function calls _mcount(), the arguments to the tracer are:
> +	    "frompc" - the address bar() will use to return to foo()
> +	    "selfpc" - the address bar() (with _mcount() size adjustment)

This is too much for Kconfig.

>  
>  config HAVE_FUNCTION_GRAPH_TRACER
>  	bool
> +	help
> +	  Update your _mcount() function to check the function pointers
> +	  ftrace_graph_return (compare to ftrace_stub) and ftrace_graph_entry
> +	  (compare to ftrace_graph_entry_stub).  If either of those are not
> +	  set to the relevant stub function, call the arch-specific function
> +	  ftrace_graph_caller which in turn calls the arch-specific function
> +	  prepare_ftrace_return.
> +
> +	  The arguments to prepare_ftrace_return() are slightly different.
> +	  The first argument will instead be a pointer to the "frompc" --
> +	  typically located in the stack.  This allows the function to
> +	  hijack the return address temporarily to have it point to the
> +	  arch-specific function return_to_handler().  For exact details of
> +	  how to implement prepare_ftrace_return(), consult an existing port.
> +	  It is fairly straight forward C code.
> +
> +	  The return_to_handler() function is simple as well.  Have it call
> +	  the common ftrace_return_to_handler() function.  The return value
> +	  is the original return address, so restore this to the right place
> +	  and return.

This is also too much for Kconfig.

>  
>  config HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	bool
> @@ -25,11 +62,17 @@ config HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	 variable at the mcount call site. Otherwise, this variable
>  	 is tested by the called function.
>  
> +	 It is of course optional for arches, but does improve performance
> +	 a bit as it prevents constant state saving and call overhead when
> +	 the function tracer is actually disabled.
> +

The above would be fine, although I would reword it a little:

 This is optional for archs, but will improve performance, as it
 prevents constant state saving and call overhead when the function tracer
 tracer is active, but has been disabled.

I put in 'is active' because with dynamic function tracing it has no more 
overhead when disabled. We can enable function tracing, but soft disable 
it with a check of a bit.


>  config HAVE_DYNAMIC_FTRACE
>  	bool
>  
>  config HAVE_FTRACE_MCOUNT_RECORD
>  	bool
> +	help
> +	  See scripts/recordmcount.pl for more info.

This is fine.

-- Steve

>  
>  config HAVE_HW_BRANCH_TRACER
>  	bool
> -- 
> 1.6.3.1
> 
> 
