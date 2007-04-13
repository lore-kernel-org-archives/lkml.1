Return-Path: <linux-kernel-owner+w=401wt.eu-S1030872AbXDMXH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872AbXDMXH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDMXH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:07:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53567 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030874AbXDMXHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:07:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kthread_create() more scalable
References: <20070413130201.GA170@tv-sign.ru>
	<20070413143104.99a1eeb9.akpm@linux-foundation.org>
	<m1lkgwndsu.fsf@ebiederm.dsl.xmission.com>
	<20070413150841.a978bf4d.akpm@linux-foundation.org>
Date: Fri, 13 Apr 2007 17:06:20 -0600
In-Reply-To: <20070413150841.a978bf4d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 13 Apr 2007 15:08:41 -0700")
Message-ID: <m1hcrjoowj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> OK, I fixed that up.
>
> The next patch (make-kthread_stop-scalable) removes the find_task_by_pid()
> anyway.

Ok. Neat.  I still need to review these a little more I have a different
set of criteria, but it is interesting work..

> Our kthread creation performance will be pretty poor anyway, due to the
> need to do two (or more?) context switches.  If we ever need
> super-low-latency kernel thread creation (eg, on-demand threads for AIO)
> then that code would need to go direct to kernel_thread(), I guess.

Sure.  AIO is a little bit of a different beast as it is IO for user space.

If low latency is important for starting kernel threads the right
answer would be to dig into the code and have a version rewrite
kernel_thread so that we copied a reference process instead of the
current.

Right now my practical target is killing all of the kernel threads
started with kernel_thread that then call daemonize.  So we can remove
daemonize, as it is a serious maintenance hazard.  kthread needs just
a little bit more work to support that.

Eric
