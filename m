Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbXDMWJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbXDMWJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXDMWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:09:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55591 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbXDMWJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:09:08 -0400
Date: Fri, 13 Apr 2007 15:08:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kthread_create() more scalable
Message-Id: <20070413150841.a978bf4d.akpm@linux-foundation.org>
In-Reply-To: <m1lkgwndsu.fsf@ebiederm.dsl.xmission.com>
References: <20070413130201.GA170@tv-sign.ru>
	<20070413143104.99a1eeb9.akpm@linux-foundation.org>
	<m1lkgwndsu.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 15:51:29 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 13 Apr 2007 17:02:01 +0400
> > Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >
> >> If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
> >> complete(&create->started) + schedule(). After that it can't be woken because
> >> nobody can see the new task yet. This means:
> >> 
> >> 	- we don't need tasklist_lock for find_task_by_pid().
> >> 
> >> 	- create_kthread() doesn't need to wait for create->started. Instead,
> >> 	  kthread_create() first waits for create->created to get the result of
> >> 	  kernel_thread(), then waits for create->started to synchronize with
> >> 	  kthread().
> >
> > Why don't we need tasklist_lock for find_task_by_pid()?  I'd have though that
> > we'd at least need rcu_read_lock(), and I'm not sure that the implicit
> > understanding of pid-management internals here is a great idea.
> 
> We need rcu_read_lock().  Or else something could permute the pid hash table
> and get us into trouble.
> 

OK, I fixed that up.

The next patch (make-kthread_stop-scalable) removes the find_task_by_pid()
anyway.

Our kthread creation performance will be pretty poor anyway, due to the
need to do two (or more?) context switches.  If we ever need
super-low-latency kernel thread creation (eg, on-demand threads for AIO)
then that code would need to go direct to kernel_thread(), I guess.

