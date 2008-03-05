Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYCEQp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYCEQp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYCEQpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:45:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44519 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYCEQpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:45:10 -0500
Date: Wed, 5 Mar 2008 19:48:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
Message-ID: <20080305164846.GA6723@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru> <20080304122654.7313227010A@magilla.localdomain> <20080304155113.GC564@tv-sign.ru> <20080305011117.60EAA27010A@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305011117.60EAA27010A@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Roland McGrath wrote:
>
> > However, SIGNAL_STOP_STOPPED doesn't relaible with ptrace. I mean, ptracer
> > doesn't clear SIGNAL_STOP_STOPPED. This is btw one of the problems which
> > complicates fixing do_wait(WSTOPPED).
> 
> We can clean that up too if you'd like to bring up the details.

Sorry! I was unclear.

Multiple reasons. Just for example,

	1:~$ strace -o /dev/null perl -e 'kill SIGSTOP,$$; for (;;) {}' &
	[1] 6714
	1:~$ kill -9 $!
	[1]+  Killed                  strace -o /dev/null perl -e 'kill SIGSTOP,$$; for (;;) {}'
	1:~$ grep State: /proc/`pidof perl`/status
	State:  R (running)

but its signal->flags = SIGNAL_STOP_STOPPED.

Please note that unless SIGCONT comes it will exit() with SIGNAL_STOP_STOPPED
set too, this complicates fixing do_wait(WSTOPPED). We can shadow this problem
though, do_wait() can first check TASK_ZOMBIE, and only then SIGNAL_STOP_STOPPED.
I am going to try to cook some patches soon.

> > As for SIGNAL_STOP_STOPPING... I am dreaming to find the way to eliminate
> > this lock-drop in get_signal_to_deliver(). Not sure this is possible, but
> > it is so nasty. For example, SIGNAL_STOP_DEQUEUED is racy, and I don't know
> > how to fix this. The patch we discussed some time ago doesn't really work
> > because dequeue_signal() drops the lock too. The latter is fixable afaics,
> > but needs very ugly changes.
>
> It all certainly deserves more careful thought.

Yes. Somehow the conception of orphaned pgrp doesn't fit in my brain, but I'd
like to at least try to think about this...

Oleg.

