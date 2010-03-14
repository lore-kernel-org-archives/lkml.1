Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0CNK17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:27:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42372 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab0CNK1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gEHnqNclsidmpMojrKvsVHG3cS5gep9PbyDR36Ivln9Dpnh4YDJqn/tczC2wIecJsm
         EQ1MiKBSCLcWGrI6FCEF2ZA5DTElSBaS81O/sJK3ppzFnNMzGgQrdsuodQtB1iYIsvk9
         BECnH/rVBnDKgJe5TLGBIwufpnufRbkbbhRzQ=
Date: Sun, 14 Mar 2010 11:27:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI
	context
Message-ID: <20100314102747.GB5140@nowhere>
References: <20100313025655.104950166@goodmis.org> <20100313025855.495916344@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313025855.495916344@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:57:00PM -0500, Steven Rostedt wrote:
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
>   # echo 1 > /debug/tracing/options/userstacktrace
>   # echo 1 > /debug/tracing/events/lock/enable
>   # while :; do ls > /dev/null ; done
> 
> Enabling the function graph tracer and looking at what was happening
> I finally noticed that all cashes happened just after an NMI.
> 
>  1)               |    copy_user_handle_tail() {
>  1)               |      bad_area_nosemaphore() {
>  1)               |        __bad_area_nosemaphore() {
>  1)               |          no_context() {
>  1)               |            fixup_exception() {
>  1)   0.319 us    |              search_exception_tables();
>  1)   0.873 us    |            }
> [...]
>  1)   0.314 us    |  __rcu_read_unlock();
>  1)   0.325 us    |    native_apic_mem_write();
>  1)   0.943 us    |  }
>  1)   0.304 us    |  rcu_nmi_exit();
> [...]
>  1)   0.479 us    |  find_vma();
>  1)               |  bad_area() {
>  1)               |    __bad_area() {
> 
> After capturing several traces of failures, all of them happened
> after an NMI. Curious about this, I added a trace_printk() to the NMI
> handler to read the regs->ip to see where the NMI happened. In which I
> found out it was here:
> 
> ffffffff8135b660 <page_fault>:
> ffffffff8135b660:       48 83 ec 78             sub    $0x78,%rsp
> ffffffff8135b664:       e8 97 01 00 00          callq  ffffffff8135b800 <error_entry>
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



Wow, that's a race :)

In perf this is dealt with a special copy_from_user_nmi()
(see in arch/x86/kernel/cpu/perf_event.c)

May be save_stack_trace_user() should use that instead
of a __copy_from_user_inatomic() based thing, just to
cover such NMI corner race case.



> ---
>  kernel/trace/trace.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 484337d..e52683f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1284,6 +1284,13 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
>  		return;
>  
> +	/*
> +	 * NMIs can not handle page faults, even with fix ups.
> +	 * The save user stack can (and often does) fault.
> +	 */
> +	if (unlikely(in_nmi()))
> +		return;
> +
>  	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
> -- 
> 1.7.0
> 
> 

