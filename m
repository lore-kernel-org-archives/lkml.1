Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZIYIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZIYIQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZIYIQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:16:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZIYIQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:16:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Heffner <mikeh@fesnel.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: HR timers prevent an itimer from generating EINTR?
In-Reply-To: Oleg Nesterov's message of  Friday, 25 September 2009 04:48:48 +0200 <20090925024848.GA20855@redhat.com>
References: <4AA1860B.4030409@fesnel.com>
	<20090924160946.f54aa215.akpm@linux-foundation.org>
	<20090925024848.GA20855@redhat.com>
X-Windows: power tools for power losers.
Message-Id: <20090925081532.23624140A0@magilla.sf.frob.com>
Date: Fri, 25 Sep 2009 01:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg is correct.  As he's explained, what we expect to be likely in your
scenario is that the SA_RESTART signal has already "prevented the syscall
from happening" by rolling it back at the time the non-SA_RESTART signal
happens, so there is no syscall to get EINTR.  Then it goes ahead and
starts the syscall, after both signals have come and gone.

It's really the same case as if you'd suspended the program with ^Z between
setting the timer and making the flock call and then resumed it more than
three seconds later.  Or just an obscenely long scheduling delay from
higher priority tasks.  Or if you'd been stepping it in the debugger and
took that long to hit return that many times.  Or if that printf/fflush had
blocked in write because the pipe/pty/socket buffers were all full along
the path to your terminal and it took three seconds for the network to
unclog, or whatever it was.

It's true that you can observe the difference between those cases and the
syscall restart case, if e.g. the syscall clearly had begun to happen
because you'd already blocked for most of a second and could tell that was
so somehow.  But that thread itself can't really tell, and you don't get
any guarantee that because you somehow externally think the syscall had
been started, your thread won't semantically be said to be in user mode
sitting at the syscall instruction but not having executed it yet.  So
indeed that's what we'll say when after that the SA_RESTART signal hits.

You really can't get the kind of guaranteed-raceless interruption you are
expecting using signals with arbitrary calls in POSIX.  Only with a few
that specifically take a blocked signal set to install inside the syscall
before they block, like ppoll/pselect.  You may be looking for the model
that pthread_cancel gives you (unfortunately it requires you to use a
separate thread and to have it entirely cancelled to effect an interrupt).
fcntl (flock) is a cancellation point, meaning a prior pthread_cancel has
the "sticky" effect you want even in "deferred cancel" mode.


Thanks,
Roland

