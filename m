Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbYKFU2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbYKFU2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYKFU2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:28:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYKFU2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:28:44 -0500
Message-ID: <49135375.3020108@redhat.com>
Date: Thu, 06 Nov 2008 15:28:37 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: next-20081106: today's ftrace episode
References: <20081106173645.e7e79071.sfr@canb.auug.org.au> <20081106194432.GA17188@x200.localdomain> <49134D8E.1070407@redhat.com> <20081106201559.GA17602@x200.localdomain>
In-Reply-To: <20081106201559.GA17602@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
>
>> basically all that would be needed in that file is this:
>>
>> #ifdef CONFIG_DYNAMIC_FTRACE
>>    extern void ftrace_nmi_enter(void);
>>    extern void ftrace_nmi_exit(void);
>> #else
>>    static inline void ftrace_nmi_enter(void) { }
>>    static inline void ftrace_nmi_exit(void) { }
>> #endif /* CONFIG_DYNAMIC_FTRACE */
>>     
>
> Oh, this is only for that.
>
> Here is patch that allows m68k to compile, I've came up with.
>   

That is quite a bit of change. I'm nervous about that because it might 
break some different combinations of configs.

I'll write up a patch that does what I propose. It has a much smaller 
impact.

-- Steve


> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -1,14 +1,12 @@
>  #ifndef _LINUX_FTRACE_H
>  #define _LINUX_FTRACE_H
>  
> +#include <linux/kallsyms.h>
> +#ifdef CONFIG_FUNCTION_TRACER
>  #include <linux/linkage.h>
> -#include <linux/fs.h>
>  #include <linux/ktime.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> -#include <linux/kallsyms.h>
> -
> -#ifdef CONFIG_FUNCTION_TRACER
>  
>  extern int ftrace_enabled;
>  extern int
> @@ -236,7 +234,7 @@ static inline void
>  ftrace_init_module(unsigned long *start, unsigned long *end) { }
>  #endif
>  
> -
> +#ifdef CONFIG_BOOT_TRACER
>  struct boot_trace {
>  	pid_t			caller;
>  	char			func[KSYM_NAME_LEN];
> @@ -246,12 +244,10 @@ struct boot_trace {
>  	ktime_t			rettime;
>  };
>  
> -#ifdef CONFIG_BOOT_TRACER
>  extern void trace_boot(struct boot_trace *it, initcall_t fn);
>  extern void start_boot_trace(void);
>  extern void stop_boot_trace(void);
>  #else
> -static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
>  static inline void start_boot_trace(void) { }
>  static inline void stop_boot_trace(void) { }
>  #endif
> --- a/init/main.c
> +++ b/init/main.c
> @@ -728,6 +728,7 @@ core_param(initcall_debug, initcall_debug, bool, 0644);
>  
>  int do_one_initcall(initcall_t fn)
>  {
> +#ifdef CONFIG_BOOT_TRACER
>  	int count = preempt_count();
>  	ktime_t delta;
>  	char msgbuf[64];
> @@ -768,6 +769,9 @@ int do_one_initcall(initcall_t fn)
>  	}
>  
>  	return it.result;
> +#else
> +	return fn();
> +#endif
>  }
>  
>  
>   

