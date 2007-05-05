Return-Path: <linux-kernel-owner+w=401wt.eu-S1423102AbXEEFru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423102AbXEEFru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 01:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423125AbXEEFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 01:47:50 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:59025 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423102AbXEEFrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 01:47:49 -0400
Message-ID: <463C1A66.3080806@cosmosbay.com>
Date: Sat, 05 May 2007 07:47:18 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br> <463C04C6.7000205@cosmosbay.com> <alpine.LFD.0.98.0705042131040.3819@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705042131040.3819@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 05 May 2007 07:47:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Sat, 5 May 2007, Eric Dumazet wrote:
>> But... what happens if the thread that was chosen exits from the loop in
>> ep_poll() with res = -EINTR (because of signal_pending(current))
> 
> Not a problem.
> 
> What happens is that an exclusive wake-up stops on the first entry in the 
> wait-queue that it actually *wakes*up*, but if some task has just marked 
> itself as being TASK_UNINTERRUPTIBLE, but is still on the run-queue, it 
> will just be marked TASK_RUNNING and that in itself isn't enough to cause 
> the "exclusive" test to trigger.
> 
> The code in sched.c is subtle, but worth understanding if you care about 
> these things. You should look at:
> 
>  - try_to_wake_up() - this is the default wakeup function (and the one 
>    that should work correctly - I'm not going to guarantee that any of the 
>    other specialty-wakeup-functions do so)
> 
>    The return value is the important thing. Returning non-zero is 
>    "success", and implies that we actually activated it.
> 
>    See the "goto out_running" case for the case where the process was 
>    still actually on the run-queues, and we just ended up setting 
>    "p->state = TASK_RUNNING" - we still return 0, and the "exclusive" 
>    logic will not trigger.
> 
>  - __wake_up_common: this is the thing that _calls_ the above, and which 
>    cares about the return value above. It does
> 
> 	if (curr->func(curr, mode, sync, key) &&
> 		(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
> 
> 
>    ie it only decrements (and triggers) the nr_exclusive thing when the 
>    wakeup-function returned non-zero (and when the waitqueue entry was 
>    marked exclusive, of course).
> 
> So what does all this subtlety *mean*?
> 
> Walk through it. It means that it is safe to do the
> 
> 	if (signal_pending())
> 		return -EINTR;
> 
> kind of thing, because *when* you do this, you obviously are always on the 
> run-queue (otherwise the process wouldn't be running, and couldn't be 
> doing the test). So if there is somebody else waking you up right then and 
> there, they'll never count your wakeup as an exclusive one, and they will 
> wake up at least one other real exclusive waiter.
> 
> (IOW, you get a very very small probability of a very very small 
> "thundering herd" - obviously it won't be "thundering" any more, it will 
> be more of a "whispering herdlet").
> 
> The Linux kernel sleep/wakeup thing is really quite nifty and smart. And 
> very few people realize just *how* nifty and elegant (and efficient) it 
> is. Hopefully a few more people appreciate its beauty and subtlety now ;)
> 

Thank you Linus for these detailed explanations.

I think I was frightened not by the wakeup logic, but by the possibility in 
SMP that a signal could be delivered to the thread just after it has been 
selected.

Looking again at ep_poll(), I see  :

			set_current_state(TASK_INTERRUPTIBLE);
[*]                     if (!list_empty(&ep->rdllist) || !jtimeout)
                                 break;
                         if (signal_pending(current)) {
                                 res = -EINTR;
                                 break;
                         }

So the test against signal_pending() is not done if an event is present in 
ready list : It should be delivered even if a signal is pending. I missed this 
bit ealier...



