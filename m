Return-Path: <linux-kernel-owner+w=401wt.eu-S935625AbZLGVc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625AbZLGVc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935616AbZLGVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:32:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55599 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615AbZLGVc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:32:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GvoQLAP1trj9B0PsLhDXUow6Az8X/Kpy9IIUMUBBFtOl9PZV0uAnmibUcMG0pu6si4
         BFfrq1h+MvafteiVNvZrCnLrhxWATWithrwupBrs8NU4atcnYO8kkzuUinnGeqUk+WDC
         fvrDCuJ7jTKctPFFfT1AHfY88cdFscjPKzJDY=
Date: Mon, 7 Dec 2009 22:32:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] tracing: Move a printk out of
	ftrace_raw_reg_event_foo()
Message-ID: <20091207213228.GG5049@nowhere>
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB183.7040202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CB183.7040202@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:40:51PM +0800, Li Zefan wrote:
> Move the printk from each ftrace_raw_reg_event_foo() to
> its caller ftrace_event_enable_disable().
> 
> See how much space this saves:
> 
>    text    data     bss     dec     hex filename
> 5454538 2005772 7103796 14564106         de3b0a vmlinux.o
> 5440766 2005772 7103796 14550334         de053e vmlinux.o
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/ftrace.h        |   16 ++--------------
>  kernel/trace/trace_events.c   |   17 +++++++++++++----
>  kernel/trace/trace_syscalls.c |   10 ++--------
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 84d6f23..4aac981 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -555,13 +555,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
>   *
>   * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
>   * {
> - *	int ret;
> - *
> - *	ret = register_trace_<call>(ftrace_event_<call>);
> - *	if (!ret)
> - *		pr_info("event trace: Could not activate trace point "
> - *			"probe to  <call>");
> - *	return ret;
> + *	return register_trace_<call>(ftrace_event_<call>);
>   * }
>   *
>   * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
> @@ -733,13 +727,7 @@ static void ftrace_raw_event_##call(proto)				\
>  									\
>  static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
>  {									\
> -	int ret;							\
> -									\
> -	ret = register_trace_##call(ftrace_raw_event_##call);		\
> -	if (ret)							\
> -		pr_info("event trace: Could not activate trace point "	\
> -			"probe to " #call "\n");			\
> -	return ret;							\
> +	return register_trace_##call(ftrace_raw_event_##call);		\
>  }									\
>  									\
>  static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9fa6736..f22eaec 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -104,9 +104,11 @@ void trace_destroy_fields(struct ftrace_event_call *call)
>  	}
>  }
>  
> -static void ftrace_event_enable_disable(struct ftrace_event_call *call,
> +static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  					int enable)
>  {
> +	int ret = 0;
> +
>  	switch (enable) {
>  	case 0:
>  		if (call->enabled) {
> @@ -117,12 +119,19 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  		break;
>  	case 1:
>  		if (!call->enabled) {
> +			if (ret) {
> +				pr_info("event trace: Could not enable event "
> +					"%s\n", call->name);
> +				break;
> +			}
>  			call->enabled = 1;
>  			tracing_start_cmdline_record();
> -			call->regfunc(call);
> +			ret = call->regfunc(call);



Heh, I'm pretty sure I will never see this warning ;-)

