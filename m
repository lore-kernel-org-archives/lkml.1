Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbXEPL03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbXEPL03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbXEPL0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:26:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:39462 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXEPL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iMwfNTGxVdnDdYAuXH3QWaDSYU8cSwr3A4cZ6zYj167fzwkqAGsTOtfSRMw9gv2N7KHwls48mFxJnn3N8Q78dBJAUG8CrdFYx482KEkjePCQhMC5qYDlxKUngSCb4k4GC58GJQcryrMgxgcNLhFWHu5Lzmu5r2QmWMpi6ZJHjAk=
Message-ID: <464AEA47.7030600@gmail.com>
Date: Wed, 16 May 2007 13:25:59 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru>
In-Reply-To: <20070515220024.GA615@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

Oleg Nesterov wrote:
>>> Yes? I need to think more about this.
>> I don't think the test for PENDING should be atomic too.  cwq pointer
>> and VALID is one package.  PENDING lives its own life as a atomic bit
>> switch.
> 
> Yes sure, it should not be atomic. But (VALID && !PENDING) == BUG, so we
> can't just "kill" PENDING form the check above.

We can also mask it out, which is about the same as what we're currently
doing.  :-)

>>>      Memory operations that occur before a LOCK operation may appear to happen
>>>      after it completes.
>> Which means that spin_lock() isn't a write barrier.
> 
> yes, it is not very clear which "Memory operations" memory-barriers.txt
> describes.
> 
>>                                                       lock is read
>> barrier, unlock is write barrier.
> 
> (To avoid a possible confusion: I am not arguing, I am trying to understand,
>  and please also note "in _theory_" above)
> 
> Is it so? Shoudn't we document this if it is true?
> 
>>                                    Otherwise, locking doesn't make much
>> sense.
> 
> Why? Could you please give a code example we have which relies on this?

Let's say there's a shared data structure protected by a spinlock and
two threads are accessing it.

1. thr1 locks spin
2. thr1 updates data structure
3. thr1 unlocks spin
4. thr2 locks spin
5. thr2 accesses data structure
6. thr2 unlocks spin

If spin_unlock is not a write barrier and spin_lock is not a read
barrier, nothing guarantees memory accesses from step#5 will see the
changes made in step#2.  Memory fetch can occur during updates in step#2
or even before that.

In _theory_, if you have, say, partial/blocked memory barrier thing
which acts as a barrier to certain range of memory accesses, in this
case memory accesses made while holding spinlock, they don't have to be
real memory barriers but AFAIK there isn't any.  I don't think it's
practical to worry about such thing at this point.  It's way too
theoretical.  But, yes, it sure needs documentation.

>>     If we're going the barrier way, I think we're better off with
>> explicit smp_wmb().  It's only barrier() on x86/64.
> 
> Yes. But note that we don't have any reason to do set_wq_data() under
> cwq->lock (this is also true for wake_up(->more_work) btw), so it makes
> sense to do this change anyway. And "wmb + spin_lock" looks a bit strange,
> I _suspect_ spin_lock() means a full barrier on most platforms.
> 
> Could you also look at
> 	http://marc.info/?t=116275561700001&r=1
> 
> and, in particular,
> 	http://marc.info/?l=linux-kernel&m=116281136122456

This is because spin_lock() isn't a write barrier, right?  I totally
agree with you there.

Thanks.

-- 
tejun
