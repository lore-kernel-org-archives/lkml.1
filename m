Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZHRKi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZHRKi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbZHRKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:38:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39998 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZHRKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n9uuJhFffCYqQXxJ8Pbr2g9lVuiqEAzod0a+e4xrOJPhUfwvRBl4D6brKT/Vkvw7Qj
         q3NMQ1dzwmtzqMcYP+OuzzOplII0n7+eTvrmaglcXvIy2IOS7FZPdWv3XaSjpbclWHuU
         MOh/3vUXd5eOF2btwL3xZAwfZQTXGaDSjS3VQ=
Date: Tue, 18 Aug 2009 12:38:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, sched: mark preempt_schedule() notrace
Message-ID: <20090818103853.GB5231@nowhere>
References: <4A8A5FF5.8080609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A5FF5.8080609@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 04:01:57PM +0800, Lai Jiangshan wrote:
> 
> Current preempt_schedule() is not marked notrace. It may be
> infinite recursion in __trace_graph_return().
> 
> preempt_schedule()
>   __trace_graph_return()
>     ftrace_preempt_disable() (!!return false!!)
>     ftrace_preempt_enable()
>       preempt_enable_notrace()
>          preempt_schedule() (need_resched() may be true again)



It would happen in __trace_graph_return() , when preempt_schedule()
has finished its job. It's very unlikely the TIF_NEED_RESCHED is
set just after (because it has just been cleared).
But why not. In that case, preempt_schedule() is called again but it's
not a real tracing recursion.

That seems like a normal behaviour actually.

 
> 
> It hardly happens, but marking preempt_schedule() notrace
> makes it safer.
> 
> One interesting thing is that preempt_schedule() is in
> the blacklist of kprobe subsystem. "__kprobes" implies "notrace".
> But preempt_schedule() cannot be marked __kprobes for it
> has been marked __sched. It is in the blacklist makes me
> consider this: should it be marked "notrace" -- YES.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5184580..2e9e209 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5534,7 +5534,7 @@ out:
>   * off of preempt_enable. Kernel preemptions off return from interrupt
>   * occur there and call schedule directly.
>   */
> -asmlinkage void __sched preempt_schedule(void)
> +asmlinkage void __sched notrace preempt_schedule(void)
>  {
>  	struct thread_info *ti = current_thread_info();
>  
> 
> 
> 
> 
> 
> 
>      
> 

