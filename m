Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbXEQJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbXEQJhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbXEQJhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:37:12 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:18856 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEQJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fxOXBvLVDhqmjpLgh+MrCy1aSTDc2Bq2gmQRyMVk1NYVI9qSuXdxY2ILWsXldg2V2sVir+FS5/sgvCsCBnCiXcjD5rAzo4VQ+Fdai8u8/hyCWTyR8ykqgiMGXKvO+vzB1SM14vFQ/gJVMsnaWE3gWtiZ8T5bbnfP4UQGXkFXMjg=
Message-ID: <464C221B.9080004@gmail.com>
Date: Thu, 17 May 2007 11:36:27 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru>
In-Reply-To: <20070516185203.GB81@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

Oleg Nesterov wrote:
> Hello Tejun,
> 
> On 05/16, Tejun Heo wrote:
>>>> lock is read arrier, unlock is write barrier.
>> Let's say there's a shared data structure protected by a spinlock and
>> two threads are accessing it.
>>
>> 1. thr1 locks spin
>> 2. thr1 updates data structure
>> 3. thr1 unlocks spin
>> 4. thr2 locks spin
>> 5. thr2 accesses data structure
>> 6. thr2 unlocks spin
>>
>> If spin_unlock is not a write barrier and spin_lock is not a read
>> barrier, nothing guarantees memory accesses from step#5 will see the
>> changes made in step#2.  Memory fetch can occur during updates in step#2
>> or even before that.
> 
> Ah, but this is something different. Both lock/unlock are full barriers,
> but they protect only one direction. A memory op must not leak out of the
> critical section, but it may leak in.
> 
> 	A = B;		// 1
> 	lock();		// 2
> 	C = D;		// 3
> 
> this can be re-ordered to
> 
> 	lock();		// 2
> 	C = D;		// 3
> 	A = B;		// 1
> 
> but 2 and 3 must not be re-ordered.

OIC.  Right, barriers with directionality would do that.

> To be sure, I contacted Paul E. McKenney privately, and his reply is
> 
> 	> No.  See for example IA64 in file include/asm-ia64/spinlock.h,
> 	> line 34 for spin_lock() and line 92 for spin_unlock().  The
> 	> spin_lock() case uses a ,acq completer, which will allow preceding
> 	> reads to be reordered into the critical section.  The spin_unlock()
> 	> uses the ,rel completer, which will allow subsequent writes to be
> 	> reordered into the critical section.  The locking primitives are
> 	> guaranteed to keep accesses bound within the critical section, but
> 	> are free to let outside accesses be reordered into the critical
> 	> section.
> 	>
> 	> Download the Itanium Volume 2 manual:
> 	>
> 	>         http://developer.intel.com/design/itanium/manuals/245318.htm
> 	>
> 	> Table 2.3 on page 2:489 (physical page 509) shows an example of how
> 	> the rel and acq completers work.

And, there actually is such a beast.  Thanks for the enlightenment.
Care to document these?

>>> Could you also look at
>>> 	http://marc.info/?t=116275561700001&r=1
>>>
>>> and, in particular,
>>> 	http://marc.info/?l=linux-kernel&m=116281136122456
>> This is because spin_lock() isn't a write barrier, right?  I totally
>> agree with you there.
> 
> Yes, but in fact I think wake_up() needs a full mb() semantics (which we
> don't have _in theory_), because try_to_wake_up() first checks task->state
> and does nothing if it is TASK_RUNNING.
> 
> That is why I think that smp_mb__before_spinlock() may be useful not only
> for workqueue.c

Yeap, I agree.

-- 
tejun
