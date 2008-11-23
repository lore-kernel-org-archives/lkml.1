Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbYKWQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbYKWQfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYKWQfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:35:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYKWQfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:35:10 -0500
Date: Sun, 23 Nov 2008 11:35:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com
Subject: Re: Mmiotrace regression in 2.6.28-rc6
In-Reply-To: <20081123154148.04e0851a@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 23 Nov 2008, Pekka Paalanen wrote:

> Hi Steve,
> 
> now that the NULL deref bug in ring buffer resize is gone, I found
> another regression.
> 
> It seems I am not getting any "buffer overflow" messages anymore.
> 
> Oh bummer, looks like I completely missed this one:
> (hope it's not in any .27 kernel)
> 
> 
> commit 3928a8a2d98081d1bc3c0a84a2d70e29b90ecf1c
> Author: Steven Rostedt <rostedt@goodmis.org>
> Date:   Mon Sep 29 23:02:41 2008 -0400
> 
>     ftrace: make work with new ring buffer
>     
>     This patch ports ftrace over to the new ring buffer.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> <...>
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index a108c32..bdbf09d 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> <...>
> @@ -130,10 +130,14 @@ static unsigned long count_overruns(struct trace_iterator *iter)
>  {
>         int cpu;
>         unsigned long cnt = 0;
> +/* FIXME: */
> +#if 0
>         for_each_online_cpu(cpu) {
>                 cnt += iter->overrun[cpu];
>                 iter->overrun[cpu] = 0;
>         }
> +#endif

Hi Pekka,

Use ring_buffer_overruns(iter->tr->buffer).  See print_trace_hader in 
kernel/trace/trace.c for more info.


-- Steve


> +       (void)cpu;
>         return cnt;
>  }
> 
> Steve, how am I going to fix this?
> I think it's quite crucial to know when the dump is incomplete.
> 
> 
> There's also another issue, but I am not sure how to reproduce it.
> The symptom is, that
> echo whatever > /debug/tracing/trace_marker
> gets stuck in a loop, bash eats 100% CPU: 10% user, 90% system.
> I got that twice today, like this: after a fresh boot echoing 64, 200,
> 70 to trace_entries, switching between nop and mmiotrace tracers,
> echoing 0 or 1 to tracing_enabled, and running the testmmiotrace
> module. At some point the user marker got stuck.
> 
> But then I tried to do that a third time by repeating some usage
> patterns I thought might trigger it, but it didn't happen.
> 
> On the positive side, the basic test using testmmiotrace.ko
> with the basic setup produces the correct output.
> 
> 
> Thanks.
> 
> -- 
> Pekka Paalanen
> http://www.iki.fi/pq/
> 
> 
