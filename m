Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXDKHDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXDKHDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXDKHDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:03:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXDKHDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:03:51 -0400
Date: Wed, 11 Apr 2007 00:03:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-Id: <20070411000316.52f2551e.akpm@linux-foundation.org>
In-Reply-To: <m13b37v517.fsf@ebiederm.dsl.xmission.com>
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 23:44:36 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Currently there is a circular reference between work queue initialization
> and kthread initialization.   This prevents the kernel thread
> infrastructure from initializing until after work queues have been
> initialized.
> 
> For kernel threads we want something that is as close as possible to the
> init_task and is not contaminated by user processes.  The later we start
> our kthreadd that forks the rest of the kernel threads the harder this is
> to do and the more of a mess we have to clean up because the defaults have
> changed on us.
> 
> So this patch modifies the kthread support to not use work queues but to
> instead use a simple list of structures, and to have kthreadd start from
> init_task immediately after our kernel thread that execs /sbin/init.
> 
> By being a true child of init_task we only have to change those process
> settings that we want to have different from init_task, such as our
> process name, blocking all signals and setting SIGCHLD to SIG_IGN
> so that all of our children are reaped automatically.
> 
> By being a tre child of init_task we also naturally get our ppid set to 0
> and do not wind up as a child of PID == 1.  Ensuring that kernel threads
> will not slow down the functioning of the wait family of functions.

argh.  Your description freely confuddles the terms "kernel thread" and
"kthread".  Can we not do that?  Henceforth the term "kernel thread" refers
to something which was started with kernel_thread() and "kthread" refers to
something which was created by kthread_create(), OK?

Your patch gets midly tangled up with Oleg's recent

reduce-reparent_to_init.patch
make-kernel-threads-invisible-to-sbin-init.patch
reparent-kernel-threads-to-swapper.patch

but they seemed fairly unpopular anyway so I'll drop 'em.

Your wait_event() will contribute to load average, I expect.  We get mail. 
I converted it to wait_event_interruptible().

I guess using PF_NOFREEZE rather than try_to_freeze() is OK, but one
wonders what thinking led to that?

Often when we have a singleton thread like this it is neater to use
wake_up_process() directly on it, rather than creating a rather pointless
waitqueue_head for it.  I started looking into that but it would have taken
more than 30 seconds.

