Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbZCOQRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbZCOQRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZCOQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:17:43 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33845 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZCOQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GzwpWc8bEZQbOrBKoAhPu20Tu4zqvkt6eNDXjVylQUkTdP9nToYTLc9bK3RlHgaN0g
         EQyYW9i17QNdKJKRGkISQ4rN0byLaUr6pgHoWbTCfVHBvQ4FyON0/8U4X9wJpcYviCgf
         urVz9QpV1YekzJXZMYRWxhHf8rmOvyNriV910=
Date: Sun, 15 Mar 2009 17:17:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 1/2 v2] tracing/syscalls: core infrastructure for
	syscalls tracing
Message-ID: <20090315161735.GF5105@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-2-git-send-email-fweisbec@gmail.com> <20090314205105.b67bdb6a.akpm@linux-foundation.org> <20090315045904.GA20949@elte.hu> <20090315010239.d4a8b3ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315010239.d4a8b3ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 01:02:39AM -0700, Andrew Morton wrote:
> On Sun, 15 Mar 2009 05:59:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Fri, 13 Mar 2009 15:42:11 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > +void start_ftrace_syscalls(void)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	struct task_struct *g, *t;
> > > > +
> > > > +	if (atomic_inc_return(&refcount) != 1)
> > > > +		goto out;
> > > > +
> > > > +	arch_init_ftrace_syscalls();
> > > > +	read_lock_irqsave(&tasklist_lock, flags);
> > > > +
> > > > +	do_each_thread(g, t) {
> > > > +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > > > +	} while_each_thread(g, t);
> > > > +
> > > > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > > > +out:
> > > > +	atomic_dec(&refcount);
> > > > +}
> > > > +
> > > > +void stop_ftrace_syscalls(void)
> > > > +{
> > > > +	unsigned long flags;
> > > > +	struct task_struct *g, *t;
> > > > +
> > > > +	if (atomic_dec_return(&refcount))
> > > > +		goto out;
> > > > +
> > > > +	read_lock_irqsave(&tasklist_lock, flags);
> > > > +
> > > > +	do_each_thread(g, t) {
> > > > +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > > > +	} while_each_thread(g, t);
> > > > +
> > > > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > > > +out:
> > > > +	atomic_inc(&refcount);
> > > > +}
> > > 
> > > What is this `refcount' thing trying to do?  afacit it does 
> > > not prevent the two loops from running concurrently and making 
> > > a mess.
> > > 
> > > If it _is_ trying to prevent that from happening, then why not 
> > > use plain old mutex_lock()?
> > 
> > yeah - already commented about that to Frederic over IRC. A 
> > plain flag, checked inside the tasklist lock is more than 
> > enough.
> > 
> 
> That would require write_lock().


Hm, I made a mistake in this code.
What I wanted to do is to allow several tracing callsites to ask
for syscalls tracing and to only disable it when the last user releases
it (and avoid the iterate the tasklist one more time while the flag
is already set).

So I shouldn't increment it back when there is already one user,
I should only exit without doing anything.

But I still need a lock to prevent from concurrent clear/set flag
on the tasks when the last user is disabling syscall tracing and a new one
requests it.

I need a mutex here. I'm preparing it.

Thanks.

