Return-Path: <linux-kernel-owner+w=401wt.eu-S1761800AbXH3A5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761800AbXH3A5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXH3A5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:57:17 -0400
Received: from h151.mvista.com ([63.81.120.158]:40137 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXH3A5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:57:16 -0400
Subject: Re: [PATCH 1/2] Adds full stack to critical-section tracing
From: Daniel Walker <dwalker@mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070810141413.12966.13475.stgit@lsg>
References: <20070810140745.12966.8464.stgit@lsg>
	 <20070810141413.12966.13475.stgit@lsg>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 17:48:12 -0700
Message-Id: <1188434892.26038.23.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 08:14 -0600, Gregory Haskins wrote:
> ---
> 
>  include/linux/sched.h  |    7 +++++--
>  kernel/latency_trace.c |   18 +++++++++++-------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8ebb43c..233d26c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1306,10 +1306,13 @@ struct task_struct {
>  #endif
>  
>  #define MAX_PREEMPT_TRACE 25
> +#define MAX_PREEMPT_TRACE_DEPTH 5
>  
>  #ifdef CONFIG_PREEMPT_TRACE
> -	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
> -	unsigned long preempt_trace_parent_eip[MAX_PREEMPT_TRACE];
> +	struct {
> +		struct stack_trace trace;
> +		unsigned long      data[MAX_PREEMPT_TRACE_DEPTH];
> +	} preempt_trace[MAX_PREEMPT_TRACE];

These changes need some fixing .. The "struct stack_trace"
infrastructure is based on CONFIG_STACKTRACE , so at least you would
want to ifdef your changes on that config options ..

I modified you patch to include the ifdefs,

ftp://source.mvista.com/pub/dwalker/misc/debug-preempt-5-levels-of-stack-frames.patch

The other problem I noticed is that the save_stack_trace(trace); seems
kind of heavy weight to be calling from inside add_preempt_count. If
your only going to a depth of 5 you could potentially use there macros,

#ifdef CONFIG_FRAME_POINTER
# ifndef CONFIG_ARM
#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
# else

Daniel

