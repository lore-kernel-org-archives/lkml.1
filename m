Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXDFQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXDFQn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXDFQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:43:29 -0400
Received: from mail.screens.ru ([213.234.233.54]:50969 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbXDFQn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:43:28 -0400
Date: Fri, 6 Apr 2007 19:47:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Chris Snook <csnook@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406154750.GA541@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> >> At first glance your patch looks reasonable.
> >> 
> >> Unfortunately it only applies to the rare thread that calls daemonize,
> >> and not also to kernel/kthread/kthread() which means it will miss many of
> >> our current kernel threads.
> >
> > Note that a thread created by kthread_create() has ->parent == "[kthread]",
> > not /sbin/init (unless it was created before core_initcall). So I don't really
> > understand how stop_machine() creates the threads parented to init.
> 
> Duh.  I was looking for that detail but the code was sufficiently
> abstracted that I missed it skimming through.  Now I see it thanks.
> That at least explains how a handful of threads created with
> kthread_create have init as their parent.

Oops. I misread stop_machine(), it does kernel_thread(), not kthread_create().
So "stopmachine" threads are all re-parented to init when the caller exits.
I think it makes sense to set ->exit_state = -1 in stopmachine(), regadless
of any other changes.

> My gut feel says it makes sense to change reparent_to_init to 
> reparent_to_kthread.  Which will get the all of the kernel daemons
> under a single parent.  Further I think it makes sense to see if
> we can start kthread earlier. Having kthread have pid == 2 would be
> nice.  That way we can kill the conditional that is only used during
> early initialization (make the code simpler and more predictable).

Yes. But we can't create helper_wq ([kthread]) before init_workqueues().
We can call helper_init() from init_workqueues() before creating "events"
though.

Oleg.

