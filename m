Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXEOI1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXEOI1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbXEOI1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:27:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:63033 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbXEOI1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fS6fdGjzSeDC2a4+WUTrl852OVsacvbqWrYy4IhQ2wRqTDlJXaa/QvbmFJDM/XLZRtoI/n4dKLA7YOuNEcs5dcuxzFqxV5fEFIz//GKm6KnZtId74NLqd50yzEFSYjEuCjqxTemMyT5utGxbsmCmseea5G8jlA4hHeEF3BIR6NM=
Message-ID: <46496EC1.3090109@gmail.com>
Date: Tue, 15 May 2007 10:26:41 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru>
In-Reply-To: <20070514194446.GA159@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
>> Yeap, I've used the term 'clearing' as more of a logical term - making
>> the pointer invalid, but is there any reason why we can't clear the
>> pointer itself?
> 
> Because this breaks cancel_work_sync(work), it needs get_wq_data(work) for
> wait_on_work(work).

Right.  That's the other user of cached work->wq_data pointer.

> So, try_to_grab_pending() should check "VALID && pointers equal" atomically.
> We can't do "if (VALID && cwq == get_wq_data(work))". We should do something
> like this
> 
> 	(((long)cwq) | VALID | PENDING) == atomic_long_read(&work->data)
> 
> Yes? I need to think more about this.

I don't think the test for PENDING should be atomic too.  cwq pointer
and VALID is one package.  PENDING lives its own life as a atomic bit
switch.

>> I didn't really get the smp_mb__before_spinlock() thing.  How are you
>> planning to use it?  spinlock() is already a read barrier.  What do you
>> gain by making it also a write barrier?
> 
> As I said, we can shift set_wq_data() from insert_work() to __queue_work(),

OIC.

> this needs very minor changes.
> 
> BTW, in _theory_, spinlock() is not a read barrier, yes?

It actually is.

> From Documentation/memory-barriers.txt
> 
>      Memory operations that occur before a LOCK operation may appear to happen
>      after it completes.

Which means that spin_lock() isn't a write barrier.  lock is read
barrier, unlock is write barrier.  Otherwise, locking doesn't make much
sense.  If we're going the barrier way, I think we're better off with
explicit smp_wmb().  It's only barrier() on x86/64.

Thanks.

-- 
tejun
