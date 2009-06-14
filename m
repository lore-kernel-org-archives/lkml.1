Return-Path: <linux-kernel-owner+w=401wt.eu-S1761150AbZFNPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150AbZFNPK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZFNPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:10:19 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:64016 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZFNPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=AsOsLWX08foyuEBEil8l2WO01aBU+jj7mE5jy/NxuQXUzb7x6Y3ot0vgri9ZNPGUcf
         Pypz/KZk7QZs90P4NJFP3DApIjLBzwS34fdVT5Hxu1AWdhmvA6AkXV7BjmpNzgIuTXGz
         8yd9QSwnDC8yw10hYBCrqZRaDRAeIP7psEu04=
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph
 needs
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1244667129-27630-1-git-send-email-vapier@gentoo.org>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org>
	 <1244667129-27630-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sun, 14 Jun 2009 23:10:05 +0800
Message-Id: <1244992206.31584.59.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 16:52 -0400, Mike Frysinger wrote:
> While implementing ftracer and ftracer graph support, I found the exact
> arch implementation details to be a bit lacking (and my x86 foo ain't
> great).  So after pounding out support for the Blackfin arch, start
> documenting the requirements/details.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v2
> 	- move to Documentation/ and add a lot more details
> 
> note: yes, i think every kconfig option that is documented should point to
> the relevant text file as this helps in the case of people who use kconfig's
> search function to look for things
> 
>  Documentation/trace/ftrace-implementation.txt |  223 +++++++++++++++++++++++++
>  Documentation/trace/ftrace.txt                |    6 +
>  kernel/trace/Kconfig                          |   16 ++-
>  3 files changed, 242 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/trace/ftrace-implementation.txt
> 
> diff --git a/Documentation/trace/ftrace-implementation.txt b/Documentation/trace/ftrace-implementation.txt
> new file mode 100644
> index 0000000..cba63b9
> --- /dev/null
> +++ b/Documentation/trace/ftrace-implementation.txt
> @@ -0,0 +1,223 @@
> +		ftrace guts
> +		===========
> +
> +Introduction
> +------------
> +
> +Here we will cover the architecture pieces that the common ftrace code relies
> +on for proper functioning.  Things are broken down into increasing complexity
> +so that you can start at the top and get at least basic functionality.
> +
> +Note that this focuses on architecture implementation details only.  If you
> +want more explanation of a feature in terms of common code, review the common
> +ftrace.txt file.
> +
> +
> +Prerequisites
> +-------------
> +
> +Ftrace relies on these features being implemented:
> + STACKTRACE_SUPPORT - implement save_stack_trace()
> + TRACE_IRQFLAGS_SUPPORT - implement include/asm/irqflags.h
> +
> +
> +HAVE_FUNCTION_GRAPH_TRACER
> +--------------------------
> +
> +You will need to implement the mcount and the ftrace_stub functions.
> +
> +The exact mcount symbol name will depend on your toolchain.  Some call it
> +"mcount", "_mcount", or even "__mcount".  You can probably figure it out by
> +running something like:
> +	$ echo 'm(){}' | gcc -x c -S -o - - -pg | grep mcount
> +	        call    mcount
> +
> +Keep in mind that the ABI that is in effect inside of the mcount function is
> +*highly* architecture/toolchain specific.  We cannot help you in this regard,
> +sorry.  Dig up some old documentation and/or find someone more familiar than
> +you to bang ideas off of.  Typically, register usage/clobbering is a major
> +problem here.  You might also want to look at how glibc has implemented the
> +mcount function for your architecture.  It might be (semi-)relevant.
> +
> +The mcount function should check the function pointer ftrace_trace_function
> +to see if it is set to ftrace_stub.  If it is, there is nothing for you to do,
> +so return immediately.  If it isn't, then call that function in the same way
> +the mcount function normally calls __mcount_internal -- the first argument is
> +the "frompc" while the second argument is the "selfpc" (adjusted to remove the
> +size of the mcount call that is embedded in the function).
> +
> +For example, if the function foo() calls bar(), when the bar() function calls
> +mcount(), the arguments mcount() will pass to the tracer are:
> +	"frompc" - the address bar() will use to return to foo()
> +	"selfpc" - the address bar() (with _mcount() size adjustment)
> +
> +Also keep in mind that this mcount function will be called *a lot*, so
> +optimizing for the default case of no tracer will help the smooth running of
> +your system when tracing is disabled.  So the start of the mcount function is
> +typically the bare min with checking things before returning.  That also means
> +the code flow should usually kept linear (i.e. no branching in the nop case).
> +This is of course an optimization and not a hard requirement.
> +
> +Here is some pseudo code that should help (these functions should actually be
> +implemented in assembly):
> +
> +void ftrace_stub(void)
> +{
> +	return;
> +}
> +
> +void mcount(void)
> +{
> +	/* save any bare state needed in order to do initial checking */
> +
> +	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
> +	if (ftrace_trace_function != ftrace_stub)
> +		goto do_trace;
> +
> +	/* restore any bare state */
> +
> +	return;
> +
> +do_trace:
> +
> +	/* save all state needed by the ABI */
> +
> +	unsigned long frompc = ...;
> +	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
> +	ftrace_trace_function(frompc, selfpc);
> +
> +	/* restore all state needed by the ABI */
> +}
> +
> +
> +HAVE_FUNCTION_TRACE_MCOUNT_TEST
> +-------------------------------
> +
> +This is an optional optimization for the normal case when tracing is turned off
> +in the system.  If you do not enable this Kconfig option, the common ftrace
> +code will take care of doing the checking for you.
> +
> +To support this feature, you only need to check the function_trace_stop
> +variable in the mcount function.  If it is non-zero, there is no tracing to be
> +done at all, so you can return.
> +
> +This additional pseudo code would simply be:
> +void mcount(void)
> +{
> +	/* save any bare state needed in order to do initial checking */
> +
> ++	if (function_trace_stop)
> ++		return;
> +
> +	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
> +	if (ftrace_trace_function != ftrace_stub)
> +...
> +
> +
> +HAVE_FUNCTION_GRAPH_TRACER
> +--------------------------
> +
> +Deep breath ... time to do some real work.  Here you will need to update the
> +mcount function to check ftrace graph function pointers, as well as implement
> +some functions to save (hijack) and restore the return address.
> +
> +The mcount function should check the function pointers ftrace_graph_return
> +(compare to ftrace_stub) and ftrace_graph_entry (compare to
> +ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
> +function, call the arch-specific function ftrace_graph_caller which in turn
> +calls the arch-specific function prepare_ftrace_return.  Neither of these
> +function names are strictly required, but you should use them anyways to stay
> +consistent across the architecture ports -- easier to compare & contrast
> +things.
> +
> +The arguments to prepare_ftrace_return are slightly different than what are
> +passed to ftrace_trace_function.  The second argument "selfpc" is the same,
> +but the first argument should be a pointer to the "frompc".  Typically this is
> +located on the stack.  This allows the function to hijack the return address
> +temporarily to have it point to the arch-specific function return_to_handler.
> +That function will simply call the common ftrace_return_to_handler function and
> +that will return the original return address with which, you can return to the
> +original call site.
> +
> +Here is the updated mcount pseudo code:
> +void mcount(void)
> +{
> +...
> +	if (ftrace_trace_function != ftrace_stub)
> +		goto do_trace;
> +
> ++#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> ++	extern void (*ftrace_graph_return)(...);
> ++	extern void (*ftrace_graph_entry)(...);
> ++	if (ftrace_graph_return != ftrace_stub ||
> ++	    ftrace_graph_entry != ftrace_graph_entry_stub)
> ++		ftrace_graph_caller();
> ++#endif
> +
> +	/* restore any bare state */
> +...
> +
> +Here is the pseudo code for the new ftrace_graph_caller assembly function:
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +void ftrace_graph_caller(void)
> +{
> +	/* save all state needed by the ABI */
> +
> +	unsigned long *frompc = &...;
> +	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
> +	prepare_ftrace_return(frompc, selfpc);
> +
> +	/* restore all state needed by the ABI */
> +}
> +#endif
> +
> +For information on how to implement prepare_ftrace_return(), simply look at
> +the x86 version.  The only architecture-specific piece in it is the setup of
> +the fault recovery table (the asm(...) code).  The rest should be the same
> +across architectures.
> +

In reality, the prepare_ftrace_return() can have the same arguments as
ftrace_trace_function(), and the fault recovery table is not needed.

in my mips-specific implementation(in the stage of -v2, i will send -v3
later), i removed the fault recovery table directly and implemented it
in the following method:

as i know, prepare_ftrace_return() is used to check whether the calling
function expect to trace, if yes, return the 'hook' function
&return_to_handler, otherwise, return back to the parent_ip directly.
so, here, i think there is no need to transfer the data via address, but
just using the same arguments like ftrace_trace_function does.

unsigned long
prepare_ftrace_return(unsgined long ip, unsigned long parent_ip) 
{ 
    [...]
    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
	return parent_ip;

    if (ftrace_graph_entry(&trace))
	return (unsigned long)&return_to_handler;

    [...]

    return parent_ip;
}

if using the above method, the fault recovery table is not needed again.

am i wrong? if this method is okay, so, this document should not only
refer to the x86's implementation detail, but focus on the basic
principle of prepare_ftrace_return().

thanks!
Wu Zhangjin

> +Here is the pseudo code for the new return_to_handler assembly function.  Note
> +that the ABI that applies here is different from what applies to the mcount
> +code.  Here you are returning from a function, so you might be able to skimp
> +on things saved/restored.
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +void return_to_handler(void)
> +{
> +	/* save all state needed by the ABI */
> +
> +	void (*original_return_point)(void) = ftrace_return_to_handler();
> +
> +	/* restore all state needed by the ABI */
> +
> +	/* this is usually either a return or a jump */
> +	original_return_point();
> +}
> +#endif
> +
> +
> +HAVE_FTRACE_NMI_ENTER
> +---------------------
> +
> +If you can't trace NMI functions, then skip this option.
> +
> +<details to be filled>
> +
> +
> +HAVE_FTRACE_SYSCALLS
> +---------------------
> +
> +<details to be filled>
> +
> +
> +HAVE_FTRACE_MCOUNT_RECORD
> +-------------------------
> +
> +See scripts/recordmcount.pl for more info.
> +
> +<details to be filled>
> +
> +
> +HAVE_DYNAMIC_FTRACE
> +---------------------
> +
> +<details to be filled>
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 5ad2ded..b0f948f 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -27,6 +27,12 @@ disabled, and more (ftrace allows for tracer plugins, which
>  means that the list of tracers can always grow).
>  
> 
> +Implementation Details
> +----------------------
> +
> +See ftrace-implementation.txt for details for arch porters and such.
> +
> +
>  The File System
>  ---------------
>  
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 417d198..8cbff89 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -11,31 +11,41 @@ config NOP_TRACER
>  
>  config HAVE_FTRACE_NMI_ENTER
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_FUNCTION_TRACER
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_FUNCTION_GRAPH_TRACER
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	bool
>  	help
> -	 This gets selected when the arch tests the function_trace_stop
> -	 variable at the mcount call site. Otherwise, this variable
> -	 is tested by the called function.
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_DYNAMIC_FTRACE
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_FTRACE_MCOUNT_RECORD
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config HAVE_HW_BRANCH_TRACER
>  	bool
>  
>  config HAVE_FTRACE_SYSCALLS
>  	bool
> +	help
> +	  See Documentation/trace/ftrace-implementation.txt
>  
>  config TRACER_MAX_TRACE
>  	bool

