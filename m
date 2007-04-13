Return-Path: <linux-kernel-owner+w=401wt.eu-S1030891AbXDMXgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030891AbXDMXgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030895AbXDMXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:36:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37655 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030891AbXDMXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:36:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kthread_create() more scalable
References: <20070413130201.GA170@tv-sign.ru>
Date: Fri, 13 Apr 2007 17:34:46 -0600
In-Reply-To: <20070413130201.GA170@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 13 Apr 2007 17:02:01 +0400")
Message-ID: <m18xcvonl5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
> complete(&create->started) + schedule(). After that it can't be woken because
> nobody can see the new task yet. This means:
>
> 	- we don't need tasklist_lock for find_task_by_pid().

Well we do need rcu_read_lock();
But if we are going to wait until the thread has run we can just pass
back current.

> 	- create_kthread() doesn't need to wait for create->started. Instead,
> 	  kthread_create() first waits for create->created to get the result of
> 	  kernel_thread(), then waits for create->started to synchronize with
> 	  kthread().

We can do even better.  We only need a single completion. 
If it was an error create_create can complete it.
Otherwise kthread() can complete it.

Patch in a bit as soon as I finish testing...


Eric
