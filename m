Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXHSUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXHSUcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXHSUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:31:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbXHSUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:31:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
In-Reply-To: Oleg Nesterov's message of  Monday, 20 August 2007 00:10:12 +0400 <20070819201012.GA113@tv-sign.ru>
X-Shopping-List: (1) Tempestuous chimerical prescriptions
   (2) Egregious nougat
   (3) Mutant configurations
Message-Id: <20070819203112.8553A4D058C@magilla.localdomain>
Date: Sun, 19 Aug 2007 13:31:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ? This becomes a busy-wait loop if the leader sleeps, wait_task_inactive()
> doesn't sleep/yield in this case. Not good.

Ah, I see.  Yes, you're right, that will not fly.  (I was thinking of the
apparently forthcoming wait_task_inactive change to avoid yield, but that
will still busy-wait in fact.)

> This means we should put something in exit_notify(), like this patch does.
> It could be simplified a bit, we don't in fact need a negative ->notify_count,
> we can tolerate a false wakeup. We can even skip the "thread_group_leader()"
> check for the same reason.
> 
> (Of course, we can also add wait_queue_head_t to ->signal, but I don't think
>  you have this in mind).

I had in mind unifying this need with what's now done by the notify_count
check that's in __exit_signal.  Aside from those BUG_ON's, I'm not sure
de_thread really cares whether the other non-leader threads are finished
self reaping, or only if they are dead.  Adding some field to signal_struct
for this new mechanism is certainly fine if it goes along with removing a
word or two from task_struct (notify_count, group_exit_task).  (The single
other use overloaded on group_exit_task is for a similar need in the
pre-coredump synchronization.  So maybe that can be done more cleanly too.)
Any new field could be kept to a single pointer; since it's only needed
while one given thread is blocking, it can point to something larger on its
stack if necessary.

While we are considering cleaning up the exec synchronization, there is a
long-standing issue it would be nice to address.  That is, the race of a
group fatal signal with exec.  (I've mentioned this before, but never come
up with an adequate solution.)  As things are, one thread can be processing
a fatal signal while another thread does exec (de_thread).  If de_thread
gets the siglock first and sets SIGNAL_GROUP_EXIT, then the fatal-signal
thread will see an exit already in process and just drop its signal on the
floor.  But, it was not an exit at all, but really an exec.  A fatal signal
from shared_pending should have killed the whole process, but was swallowed.
This is a POSIX violation, and potentially usable in a racy DoS exploit to
let a runaway process keep exec'ing and never get killed (though probably not).

An obvious path to a fix for that is to avoid overloading SIGNAL_GROUP_EXIT
in de_thread.  In coming up with different synchronization method we might
find a way that cleans that up too.


Thanks,
Roland
