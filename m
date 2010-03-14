Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab0CNWFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 18:05:17 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61609 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934132Ab0CNWFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 18:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n5XdwHlstGu9FGVYudSybJk3P9aWuc5+WfdzXx22aqP3TP+Y/VZb365rg7ILHAq6/R
         u3Djncr3nsyQaaDcmbcRgPBACT1YJL36DyX8hH99M6KPqA+wM2MiLWv2GoGebh2p5x8e
         lz3n9AmTAJ+hfbUv75681+2hCHcxavlZDPyY8=
MIME-Version: 1.0
In-Reply-To: <20100313025855.495916344@goodmis.org>
References: <20100313025655.104950166@goodmis.org>
	 <20100313025855.495916344@goodmis.org>
Date: Sun, 14 Mar 2010 23:05:08 +0100
X-Google-Sender-Auth: 0a94bf773c35a8bf
Message-ID: <520f0cf11003141505l607f2f3bxa36a9cffd82cab50@mail.gmail.com>
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI 
	context
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 3:57 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> A bug was found with Li Zefan's ftrace_stress_test that caused applications
> to segfault during the test.
>
> Placing a tracing_off() in the segfault code, and examining several
> traces, I found that the following was always the case. The lock tracer
> was enabled (lockdep being required) and userstack was enabled. Testing
> this out, I just enabled the two, but that was not good enough. I needed
> to run something else that could trigger it. Running a load like hackbench
> did not work, but executing a new program would. The following would
> trigger the segfault within seconds:
>
>  # echo 1 > /debug/tracing/options/userstacktrace
>  # echo 1 > /debug/tracing/events/lock/enable
>  # while :; do ls > /dev/null ; done
>
> Enabling the function graph tracer and looking at what was happening
> I finally noticed that all cashes happened just after an NMI.
>
>  1)               |    copy_user_handle_tail() {
>  1)               |      bad_area_nosemaphore() {
>  1)               |        __bad_area_nosemaphore() {
>  1)               |          no_context() {
>  1)               |            fixup_exception() {
>  1)   0.319 us    |              search_exception_tables();
>  1)   0.873 us    |            }
> [...]
>  1)   0.314 us    |  __rcu_read_unlock();
>  1)   0.325 us    |    native_apic_mem_write();
>  1)   0.943 us    |  }
>  1)   0.304 us    |  rcu_nmi_exit();
> [...]
>  1)   0.479 us    |  find_vma();
>  1)               |  bad_area() {
>  1)               |    __bad_area() {
>
> After capturing several traces of failures, all of them happened
> after an NMI. Curious about this, I added a trace_printk() to the NMI
> handler to read the regs->ip to see where the NMI happened. In which I
> found out it was here:
>
> ffffffff8135b660 <page_fault>:
> ffffffff8135b660:       48 83 ec 78             sub    $0x78,%rsp
> ffffffff8135b664:       e8 97 01 00 00          callq  ffffffff8135b800 <error_entry>
>
> What was happening is that the NMI would happen at the place that a page
> fault occurred. It would call rcu_read_lock() which was traced by
> the lock events, and the user_stack_trace would run. This would trigger
> a page fault inside the NMI. I do not see where the CR2 register is
> saved or restored in NMI handling. This means that it would corrupt
> the page fault handling that the NMI interrupted.
>
> The reason the while loop of ls helped trigger the bug, was that
> each execution of ls would cause lots of pages to be faulted in, and
> increase the chances of the race happening.
>
> The simple solution is to not allow user stack traces in NMI context.
> After this patch, I ran the above "ls" test for a couple of hours
> without any issues. Without this patch, the bug would trigger in less
> than a minute.
>
> Cc: stable@kernel.org
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 484337d..e52683f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1284,6 +1284,13 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>        if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
>                return;
>
> +       /*
> +        * NMIs can not handle page faults, even with fix ups.
> +        * The save user stack can (and often does) fault.
> +        */
> +       if (unlikely(in_nmi()))
> +               return;
> +
>        event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
>                                          sizeof(*entry), flags, pc);
>        if (!event)
> --
> 1.7.0
>

That is some awfully cool detective work. Just one question, if it is
so easy to trigger, why did you wrap it in "unlikely"?
