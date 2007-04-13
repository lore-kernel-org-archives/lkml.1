Return-Path: <linux-kernel-owner+w=401wt.eu-S1030858AbXDMVww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858AbXDMVww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXDMVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:52:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38016 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030858AbXDMVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:52:51 -0400
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
Date: Fri, 13 Apr 2007 15:51:29 -0600
In-Reply-To: <20070413143104.99a1eeb9.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 13 Apr 2007 14:31:04 -0700")
Message-ID: <m1lkgwndsu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 13 Apr 2007 17:02:01 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
>
>> If kernel_thread(kthread) succeeds, kthread() can not fail on its path to
>> complete(&create->started) + schedule(). After that it can't be woken because
>> nobody can see the new task yet. This means:
>> 
>> 	- we don't need tasklist_lock for find_task_by_pid().
>> 
>> 	- create_kthread() doesn't need to wait for create->started. Instead,
>> 	  kthread_create() first waits for create->created to get the result of
>> 	  kernel_thread(), then waits for create->started to synchronize with
>> 	  kthread().
>
> Why don't we need tasklist_lock for find_task_by_pid()?  I'd have though that
> we'd at least need rcu_read_lock(), and I'm not sure that the implicit
> understanding of pid-management internals here is a great idea.

We need rcu_read_lock().  Or else something could permute the pid hash table
and get us into trouble.

Eric





