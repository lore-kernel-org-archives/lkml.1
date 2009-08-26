Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbZHZMgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbZHZMgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZHZMgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:36:01 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48175 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbZHZMf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TPcdTp5D+n+5bYYCxsJDJyYGoHJr6fiouJF6TikRBn74AiYEyLPyuQElSLvfpoJB6r
         ncb0iPHxH9HXZgXOfle8GvSgBlTkiXy8z3QQ5u64ZlMfPHRytABSHjJBwooR47CzoC5q
         Fzy/h8iihXaT/jhfbnOcJb5u7cHRASTrKUTO4=
Date: Wed, 26 Aug 2009 14:35:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826123550.GD6009@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825160237.GG4639@cetus.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 06:02:37PM +0200, Hendrik Brueckner wrote:
> On Tue, Aug 25, 2009 at 04:15:49PM +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > > There are at least two scenarios where syscall_get_nr() can return -1:
> > > 
> > > 1. For example, ptrace stores an invalid syscall number, and thus,
> > >    tracing code resets it.
> > >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > > 
> > > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> > >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> > >    kernel threads.
> > >    However, the ftrace selftest triggers a kernel oops when testing syscall
> > >    trace points:
> > >       - The kernel thread is started as ususal (do_fork()),
> > >       - tracing code sets TIF_SYSCALL_FTRACE,
> > >       - the ret_from_fork() function is triggered and starts
> > > 	ftrace_syscall_exit() with an invalid syscall number.
> > 
> > 
> > 
> > I wonder if there is any way to identify such situation...?
> For the second case, it might be an option to avoid setting the
> TIF_SYSCALL_FTRACE flag for kernel threads.
> 
> Kernel threads have task_struct->mm set to NULL.
> (Thanks to Heiko for that hint ;-)
> 
> The idea is then to check the mm field in syscall_regfunc() and
> set the flag accordingly.
> 
> However, I think the patch is an optional add-on becase checking
> the syscall number is still required for case 1).
> 
> ---
>  kernel/tracepoint.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -593,7 +593,9 @@ void syscall_regfunc(void)
>  	if (!sys_tracepoint_refcount) {
>  		read_lock_irqsave(&tasklist_lock, flags);
>  		do_each_thread(g, t) {
> -			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> +			/* Skip kernel threads. */
> +			if (t->mm)
> +				set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
>  		} while_each_thread(g, t);
>  		read_unlock_irqrestore(&tasklist_lock, flags);
>  	}
> 


Yeah, and as told before, syscalls tracing from kernel thread is
an interesting point but we can't do it that way.

I'm queuing this patch for .32, but I need you Signed-off-by to apply it :)

Thanks.

