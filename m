Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXELNoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXELNoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 09:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbXELNod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 09:44:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:45803 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbXELNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 09:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=be1gRxl9z7SBfKKCYU5ZeSp2kkyGXUOFwTBuXxgmGWyZ5TbqNTfWosucIvfwOHOa7apFJB9adRkAkacgkIyCfESVAs06NyGJUBYwgagaBXEGdyWHOcIfdxpY4/6vhP5chGYFQA6WuJS7/ZZ9Oe4ABo14FUIEy+XZ4Ov3ryMwYXc=
Date: Sat, 12 May 2007 15:44:19 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Esben Nielsen <nielsen.esben@googlemail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
In-Reply-To: <1178964103.6810.55.camel@twins>
Message-ID: <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
References: <20070511131541.992688403@chello.nl>  <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
 <1178964103.6810.55.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Peter Zijlstra wrote:

> On Sat, 2007-05-12 at 11:27 +0200, Esben Nielsen wrote:
>>
>> On Fri, 11 May 2007, Peter Zijlstra wrote:
>>
>>>
>>> I was toying with a scalable rw_mutex and found that it gives ~10% reduction in
>>> system time on ebizzy runs (without the MADV_FREE patch).
>>>
>>
>> You break priority enheritance on user space futexes! :-(
>> The problems is that the futex waiter have to take the mmap_sem. And as
>> your rw_mutex isn't PI enabled you get priority inversions :-(
>
> Do note that rwsems have no PI either.
> PI is not a concern for mainline - yet, I do have ideas here though.
>
>
If PI wasn't a concern for mainline, why is PI futexes merged into the 
mainline?

I notice that the rwsems used now isn't priority inversion safe (thus 
destroyingthe perpose of having PI futexes). We thus already have a bug in 
the mainline.

I suggest making a rw_mutex which does read side PI: A reader boosts the 
writer, but a writer can't boost the readers, since there can be a large 
amount of those.

I don't have time to make such a rw_mutex but I have a simple idea for 
one, where the rt_mutex can be reused.

  struct pi_rw_mutex {
       int count; /*  0   -> unoccupied,
                      >0 -> the number of current readers,
                            Second highest bit: there are a waiting writer
                      -1 -> A writer have it. */
       struct rt_mutex mutex;
  }

Use atomic exchange on count.

When locking:

A writer checks if count <= 0. If so it sets the value to -1 and takes
the mutex. When it gets the mutex it rechecks the count and proceeds.
If count > 0 the writer sets the second highest bit and add itself to
the wait-list in the mutex and sleeps. (The mutex will now be in a state 
where owner==NULL but there are waiters. It must be cheched if the 
rt_mutex code can handle this.)

A reader checks if count >= 0. If so it does count++ and proceeds.
If count < 0 it takes the rtmutex. When it gets the mutex it sets the 
count to 1, unlocks the mutex and proceeds.

When unlocking:

The writer sets count to 0 or 0x8000000 (second highest bit) depending 
on how many waiters the mutex have and unlocks the mutex.

The reader checks if count is 0x80000001. If so it sets count to 0 and 
wakes up the first waiter on the mutex (if there are any). Otherwise it 
just do count--.

Esben
