Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXEMMv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXEMMv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbXEMMve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:51:34 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:50812 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbXEMMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GUP7KMKKIGImMtQmlqwfwPENTxLUttJfSWV02jHzKW6KelHj3KISjPT6OVnj1Dkp5+qHG1LXvwe1liwBqmbHfn7RDA2DjKnm7LkkKrQV7+BqG5SMpMvRE4HTHx7CBxWebxpPPJRXiQa7v15zjxewd301L9QQD2iMh4crYcpjpQ4=
Message-ID: <4645559D.4050602@gmail.com>
Date: Sat, 12 May 2007 07:50:21 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru>
In-Reply-To: <20070511145345.GA240@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 05/11, Tejun Heo wrote:
>> Oleg Nesterov wrote:
>>> However, I agree, this smp_wmb() in insert_work() should die. We can
>>> introduce "smp_mb__before_spinlock()" (no-op on x86 at least) to kill it.
>> Yeah, right, we allow cwq pointer to change without holding the lock.
>> Although I still think that is where we should fix the problem.  Taking
>> down CPU is a cold cold path.  We can afford a lot of overhead there.
>> IMHO, if we can do that, it would be far better than memory barrier
>> dance which tends to be difficult to understand and thus prove/maintain
>> correctness.  I'll think about it more.
> 
> Yes I hate this barrier too. That is why changelog explicitly mentions it.
> 
> With some trivial code modifications we can move set_wq_data() from insert_work()
> to __queue_work(), then
> 
> 	void set_wq_data(work, cwq)
> 	{
> 		struct cpu_workqueue_struct *old = get_wq_data(work);
> 
> 		if (likely(cwq == old))
> 			return;
> 
> 		if (old)
> 			spin_lock(old->lock);
> 
> 		atomic_long_set(&work->data, ...);
> 
> 		if (old)
> 			spin_lock(old->lock);
> 	}
> 
> I can't say I like this very much, though. I'd prefer use smp_mb__before_spinlock().
> Probably we can do something else.

Eeek... I don't like the above either.  I've been thinking about the
barriers a bit more and what makes it different from simple locked
enter/leave model.  As our pointer can change without locking,
work->entry, which is always manipulated locked, is used as a mean to
validate the pointer and we need barrier there because the update to
work->entry and work->wq_data aren't atomic - new validity test result
can be read together with old pointer.  Clever && cryptic, I have to
say.  :-)

Fortunately, we have one bit left in the flags and can use it to mark
pointer validity instead of list_empty() test.  flags and wq_data live
in the same atomic_long and thus can be updated together atomically.

* insert_work() sets VALID bit and the cwq pointer using one
atomic_long_set().

* queue_delayed_work_on() sets the cwq pointer but not the VALID bit.

* run_workqueue() clears the cwq pointer and VALID bit while holding
lock before executing the work.

* try_to_grab_pending() checks VALID && pointers equal after grabbing
cwq->lock.

What do you think?  Is there any hole?

Thanks.

-- 
tejun

