Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZCIRX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZCIRX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZCIRXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:23:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZCIRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:23:16 -0400
Date: Mon, 9 Mar 2009 13:23:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/printk] tracing: optimize trace_printk()
In-Reply-To: <tip-7bffc23e56e92c14b787bf4d95249a32085bfed5@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0903091322050.2203@gandalf.stny.rr.com>
References: <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <tip-7bffc23e56e92c14b787bf4d95249a32085bfed5@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Mar 2009, Ingo Molnar wrote:
> 
> tracing: optimize trace_printk()
> 
> Impact: micro-optimization
> 
> trace_printk() does this unconditionally:
> 
> 	trace_printk_fmt = fmt;
> 
> Where trace_printk_fmt is an entry into a global array. This is
> very SMP-unfriendly.
> 
> So only write it once per bootup.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> LKML-Reference: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/kernel.h |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 4e726b9..7742798 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -454,7 +454,10 @@ do {									\
>  do {									\
>  	static const char *trace_printk_fmt				\
>  	__attribute__((section("__trace_printk_fmt")));			\
> -	trace_printk_fmt = fmt;					\
> +									\
> +	if (!trace_printk_fmt)						\
> +		trace_printk_fmt = fmt;					\
> +									\

But this is a static init. That is, it is done at initialization and not
every time.

The change actually slows down the system.

>  	__trace_printk_check_format(fmt, ##args);			\
>  	__trace_printk(_THIS_IP_, trace_printk_fmt, ##args);		\
>  } while (0)
> @@ -467,7 +470,10 @@ __trace_printk(unsigned long ip, const char *fmt, ...)
>  do {									\
>  	static const char *trace_printk_fmt				\
>  	__attribute__((section("__trace_printk_fmt")));			\
> -	trace_printk_fmt = fmt;					\
> +									\
> +	if (!trace_printk_fmt)						\
> +		trace_printk_fmt = fmt;					\
> +									\

Same here.

-- Steve

>  	__ftrace_vprintk(_THIS_IP_, trace_printk_fmt, vargs);		\
>  } while (0)
>  
> 
