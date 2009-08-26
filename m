Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZHZNbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZHZNbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZHZNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:31:36 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60151 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZHZNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DfjKv39DOz1XzxAO/lBWOfov8TtOe9Gaxt3e250Z4Eewiw/BspquHlH6kSsPFbyjfG
         R4Kl88gYO8U6ho7ugeocSiu44QnFk+H+7+O+8lArNfj6CsLgMEgneT9k99tZ9P1WU6rl
         LKHt5Cstn/TjJzexG7UvKOJcGAWSEqcscPHyE=
Date: Wed, 26 Aug 2009 15:30:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826133019.GE6009@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826125943.GA5946@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 02:59:43PM +0200, Heiko Carstens wrote:
> On Wed, Aug 26, 2009 at 02:35:52PM +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 25, 2009 at 06:02:37PM +0200, Hendrik Brueckner wrote:
> > > On Tue, Aug 25, 2009 at 04:15:49PM +0200, Frederic Weisbecker wrote:
> > > > On Tue, Aug 25, 2009 at 02:50:27PM +0200, Hendrik Brueckner wrote:
> > > > > There are at least two scenarios where syscall_get_nr() can return -1:
> > > > > 
> > > > > 1. For example, ptrace stores an invalid syscall number, and thus,
> > > > >    tracing code resets it.
> > > > >    (see do_syscall_trace_enter in arch/s390/kernel/ptrace.c)
> > > > > 
> > > > > 2. The syscall_regfunc() (kernel/tracepoint.c) sets the TIF_SYSCALL_FTRACE
> > > > >    (now: TIF_SYSCALL_TRACEPOINT) flag for all threads which includes
> > > > >    kernel threads.
> > > > >    However, the ftrace selftest triggers a kernel oops when testing syscall
> > > > >    trace points:
> > > > >       - The kernel thread is started as ususal (do_fork()),
> > > > >       - tracing code sets TIF_SYSCALL_FTRACE,
> > > > >       - the ret_from_fork() function is triggered and starts
> > > > > 	ftrace_syscall_exit() with an invalid syscall number.
> > > > 
> > > > 
> > > > 
> > > > I wonder if there is any way to identify such situation...?
> > > For the second case, it might be an option to avoid setting the
> > > TIF_SYSCALL_FTRACE flag for kernel threads.
> > > 
> > > Kernel threads have task_struct->mm set to NULL.
> > > (Thanks to Heiko for that hint ;-)
> > > 
> > > The idea is then to check the mm field in syscall_regfunc() and
> > > set the flag accordingly.
> > > 
> > > However, I think the patch is an optional add-on becase checking
> > > the syscall number is still required for case 1).
> > > 
> > > ---
> > >  kernel/tracepoint.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > --- a/kernel/tracepoint.c
> > > +++ b/kernel/tracepoint.c
> > > @@ -593,7 +593,9 @@ void syscall_regfunc(void)
> > >  	if (!sys_tracepoint_refcount) {
> > >  		read_lock_irqsave(&tasklist_lock, flags);
> > >  		do_each_thread(g, t) {
> > > -			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > > +			/* Skip kernel threads. */
> > > +			if (t->mm)
> > > +				set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > >  		} while_each_thread(g, t);
> > >  		read_unlock_irqrestore(&tasklist_lock, flags);
> > >  	}
> > 
> > Yeah, and as told before, syscalls tracing from kernel thread is
> > an interesting point but we can't do it that way.
> > 
> > I'm queuing this patch for .32, but I need you Signed-off-by to apply it :)
> 
> That won't always work as pointed out in the other example:
> - Process doing sys_init_module then scheduled away
> - User enables syscall tracing -> TIF_SYSCALL_FTRACE gets set
> - init function of the module gets called and is doing kernel_thread()
>   (old API) -> kernel thread inherits TIF_SYSCALL_FTRACE.
> 
> I don't think that's what you want. You might want to clear the flag for
> new processes during fork (only for kernel threads I would guess).
> 
> At least the current patch leaves a hole.


Ah, there are callsites that use kernel_thread() directly?
Does it means that t->mm could be non NULL for such resulting
kernel threads, in that case it would be hard to hook on
do_fork() to check that.

