Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZLHHnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZLHHnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZLHHnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:43:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34085 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZLHHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BibYs4T9AAJnE1VjzMK+gRGIGO/IPi4LJNbaCtYVBXfQKj+lhnovxMGHl0RI/AVAR9
         NgzxDJgTNP/ev7XAwLHnFucIClIt+W3xViBitEHzFXTVH0M8Um2IsknQbgLbC8aIUInA
         ZHYCBvOdrZnsgEhe4ldQ596Fa5YQczQ7keYW8=
Date: Tue, 8 Dec 2009 08:43:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/13] tracing: Move a printk out of
	ftrace_raw_reg_event_foo()
Message-ID: <20091208074342.GB4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC4AC.802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DC4AC.802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:14:52AM +0800, Li Zefan wrote:
> Move the printk from each ftrace_raw_reg_event_foo() to
> its caller ftrace_event_enable_disable().
> 
> See how much space this saves:
> 
>    text    data     bss     dec     hex filename
> 5345151 1961864 7103260 14410275         dbe223 vmlinux.o.old
> 5331487 1961864 7103260 14396611         dbacc3 vmlinux.o
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/trace/ftrace.h        |   16 ++--------------
>  kernel/trace/trace_events.c   |   17 +++++++++++++----
>  kernel/trace/trace_syscalls.c |   10 ++--------
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index f978376..0c21af8 100644
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
> @@ -710,13 +704,7 @@ static void ftrace_raw_event_##call(proto)				\
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
> index 97b0b3a..bf2f1b9 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -118,9 +118,11 @@ int trace_event_raw_init(struct ftrace_event_call *call)
>  }
>  EXPORT_SYMBOL_GPL(trace_event_raw_init);
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
> @@ -131,12 +133,19 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
>  		break;
>  	case 1:
>  		if (!call->enabled) {
> +			ret = call->regfunc(call);
> +			if (ret) {
> +				pr_info("event trace: Could not enable event "
> +					"%s\n", call->name);
> +				break;
> +			}
>  			call->enabled = 1;
>  			tracing_start_cmdline_record();
> -			call->regfunc(call);



That seems to open a tiny window during which we'll lose
some pid -> comm resolution records.

We should probably keep the previous call order.

Other than that:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

