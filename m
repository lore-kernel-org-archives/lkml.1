Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbXDKLme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbXDKLme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXDKLme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:42:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:53661 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbXDKLmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:42:33 -0400
Date: Wed, 11 Apr 2007 15:42:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kernel threads invisible to /sbin/init
Message-ID: <20070411114205.GA127@tv-sign.ru>
References: <20070410185133.GA104@tv-sign.ru> <m1wt0jva1i.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt0jva1i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > 1. rename reparent_to_init() to reparent_kthread() and export it
> >
> > 2. use init_pid_ns.child_reaper instead of child_reaper(current)
> >
> > 3. set ->exit_signal = -1, so init can't see us and we don't use
> >    it to reap the task.
> >
> > 4. add reparent_kthread() to kthread() and stopmachine()
> >
> 
> If the goal is to hide from /sbin/init.  We don't need to touch
> kernel/kthread.c or 
> kernel/stop_machine.c
> 
> Their parents are already kernel threads.
> 
> For the kernel thread they all inherit signals with SIGCHLD set to
> SIG_IGN, so there is child auto reaping in that form.  Adding
> the ->exit_signal = -1 would be a bonus but is not required.

Unless a kernel thread does kernel_thread() (not kthread_create) and
exits. In that case the child will be re-parented to init which doesn't
ignore SIGCHLD.

Robin Holt wrote:
>
> wait_task_zombie() is taking many seconds to get through the list.
> For the case of a modprobe, stop_machine creates one thread per cpu
> (remember big number). All are parented to init and their exit will
> cause wait_task_zombie to scan multiple times most of the way through
> this very long list looking for threads which need to be reaped.

initially, "stopmachine" threads were not parented to init.

However, I agree, your patch is better, and solves most problems in more
simple way. Including the above problem, I believe. "stopmachine" likely
does exit_notify() and notices SIG_IGN (inherited from kthreadd_setup())
before "do_stop" does forget_original_parent().

Oleg.

