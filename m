Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZLARkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZLARkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:40:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZLARkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:40:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:39843 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZLARkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iQmAivc+UCYO2GiVem3VREx3tWWo60nmGeI0aM964+2AoanNje5cRMHPu8pM2iLysu
         KS69GyyePnSc5pHj0QAooivvOFUHTs9J0qhTCGxL41q7B/m18T/VyBaHJraF/33IUeT7
         HCr3ojroKjdMDoTXHGu4hz8wJdY462BaE9glk=
Date: Tue, 1 Dec 2009 18:40:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] trace_syscalls: Remove unused
	event_syscall_enter and event_syscall_exit
Message-ID: <20091201174002.GA5080@nowhere>
References: <4B14D278.4090209@cn.fujitsu.com> <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 04:42:35PM +0000, tip-bot for Lai Jiangshan wrote:
> Commit-ID:  bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
> Gitweb:     http://git.kernel.org/tip/bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Tue, 1 Dec 2009 16:23:20 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 1 Dec 2009 17:33:28 +0100
> 
> trace_syscalls: Remove unused event_syscall_enter and event_syscall_exit
> 
> fix event_enter_##sname->event
> fix event_exit_##sname->event
> 
> remove unused event_syscall_enter and event_syscall_exit
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Jason Baron <jbaron@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <4B14D278.4090209@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---



I'm confused.
Each syscall has a enter_syscall_print_##sname,
all of them are identical (they all map to print_syscall_enter())

OTOH we have event_syscall_enter, which is exactly
the same than enter_syscall_print_##sname.

But we are using a strange mix of them: we do that on
init: register_ftrace_event(&enter_syscall_print_##sname)
but we use event_syscall_enter as the "event" field
of the trace_event. It means that we unregister the wrong
event when we remove a module.

Thanks for fixing this!
But I think you fixed it the wrong way.

Why do we need a copy of this event_syscall_enter
for each syscall event?
Can't we actually drop enter_syscall_print_##sname
and always use event_syscall_enter instead?

The same applies to exit syscall events.

Thanks.




>  include/linux/syscalls.h      |    4 ++--
>  include/trace/syscall.h       |    2 --
>  kernel/trace/trace_syscalls.c |    8 --------
>  3 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index b50974a..2f7c539 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -178,7 +178,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
>  	  event_enter_##sname = {					\
>  		.name                   = "sys_enter"#sname,		\
>  		.system                 = "syscalls",			\
> -		.event                  = &event_syscall_enter,		\
> +		.event                  = &enter_syscall_print_##sname,	\
>  		.raw_init		= init_enter_##sname,		\
>  		.show_format		= syscall_enter_format,		\
>  		.define_fields		= syscall_enter_define_fields,	\
> @@ -214,7 +214,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
>  	  event_exit_##sname = {					\
>  		.name                   = "sys_exit"#sname,		\
>  		.system                 = "syscalls",			\
> -		.event                  = &event_syscall_exit,		\
> +		.event                  = &exit_syscall_print_##sname,	\
>  		.raw_init		= init_exit_##sname,		\
>  		.show_format		= syscall_exit_format,		\
>  		.define_fields		= syscall_exit_define_fields,	\
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 51ee17d..5f8827c 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -37,8 +37,6 @@ extern unsigned long arch_syscall_addr(int nr);
>  extern int syscall_name_to_nr(char *name);
>  void set_syscall_enter_id(int num, int id);
>  void set_syscall_exit_id(int num, int id);
> -extern struct trace_event event_syscall_enter;
> -extern struct trace_event event_syscall_exit;
>  
>  extern int syscall_enter_format(struct ftrace_event_call *call,
>  				struct trace_seq *s);
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 63aa807..00d6e17 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -444,14 +444,6 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> -struct trace_event event_syscall_enter = {
> -	.trace			= print_syscall_enter,
> -};
> -
> -struct trace_event event_syscall_exit = {
> -	.trace			= print_syscall_exit,
> -};
> -
>  int __init init_ftrace_syscalls(void)
>  {
>  	struct syscall_metadata *meta;

