Return-Path: <linux-kernel-owner+w=401wt.eu-S1767990AbXEEEpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767990AbXEEEpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 00:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767992AbXEEEpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 00:45:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767990AbXEEEpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 00:45:44 -0400
Date: Fri, 4 May 2007 21:44:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
In-Reply-To: <463C04C6.7000205@cosmosbay.com>
Message-ID: <alpine.LFD.0.98.0705042131040.3819@woody.linux-foundation.org>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
 <463C04C6.7000205@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 May 2007, Eric Dumazet wrote:
> 
> But... what happens if the thread that was chosen exits from the loop in
> ep_poll() with res = -EINTR (because of signal_pending(current))

Not a problem.

What happens is that an exclusive wake-up stops on the first entry in the 
wait-queue that it actually *wakes*up*, but if some task has just marked 
itself as being TASK_UNINTERRUPTIBLE, but is still on the run-queue, it 
will just be marked TASK_RUNNING and that in itself isn't enough to cause 
the "exclusive" test to trigger.

The code in sched.c is subtle, but worth understanding if you care about 
these things. You should look at:

 - try_to_wake_up() - this is the default wakeup function (and the one 
   that should work correctly - I'm not going to guarantee that any of the 
   other specialty-wakeup-functions do so)

   The return value is the important thing. Returning non-zero is 
   "success", and implies that we actually activated it.

   See the "goto out_running" case for the case where the process was 
   still actually on the run-queues, and we just ended up setting 
   "p->state = TASK_RUNNING" - we still return 0, and the "exclusive" 
   logic will not trigger.

 - __wake_up_common: this is the thing that _calls_ the above, and which 
   cares about the return value above. It does

	if (curr->func(curr, mode, sync, key) &&
		(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)


   ie it only decrements (and triggers) the nr_exclusive thing when the 
   wakeup-function returned non-zero (and when the waitqueue entry was 
   marked exclusive, of course).

So what does all this subtlety *mean*?

Walk through it. It means that it is safe to do the

	if (signal_pending())
		return -EINTR;

kind of thing, because *when* you do this, you obviously are always on the 
run-queue (otherwise the process wouldn't be running, and couldn't be 
doing the test). So if there is somebody else waking you up right then and 
there, they'll never count your wakeup as an exclusive one, and they will 
wake up at least one other real exclusive waiter.

(IOW, you get a very very small probability of a very very small 
"thundering herd" - obviously it won't be "thundering" any more, it will 
be more of a "whispering herdlet").

The Linux kernel sleep/wakeup thing is really quite nifty and smart. And 
very few people realize just *how* nifty and elegant (and efficient) it 
is. Hopefully a few more people appreciate its beauty and subtlety now ;)

		Linus
