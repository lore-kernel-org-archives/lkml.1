Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZAWKIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZAWKIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZAWKHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:07:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:43619 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZAWKHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pdx1ItZX0dBaSNELa6oxDSyjeNEUUMu81D7qLRMs3OIPIDibpWDgpx6zTTrK/CYs71
         hHC6Cn7//hD7CSEUCJi94jTpYLqywOA2XOONXJuVe4H8wfeMQu+ouJcRrS1c9Titdknz
         76ovxTwkLLhJRv+VecQ+arl7JL7WAakNtVlvk=
MIME-Version: 1.0
In-Reply-To: <20090123004702.GA18362@redhat.com>
References: <20090117215110.GA3300@redhat.com>
	 <20090118013802.GA12214@cmpxchg.org>
	 <20090118023211.GA14539@redhat.com>
	 <20090120203131.GA20985@cmpxchg.org>
	 <20090121143602.GA16584@redhat.com>
	 <20090121213813.GB23270@cmpxchg.org>
	 <20090122202550.GA5726@redhat.com>
	 <b647ffbd0901221626o5e654682t147625fa3e19976f@mail.gmail.com>
	 <20090123004702.GA18362@redhat.com>
Date: Fri, 23 Jan 2009 11:07:48 +0100
Message-ID: <b647ffbd0901230207u642e24cdg98700aa68ed1aa33@mail.gmail.com>
Subject: Re: [RFC v4] wait: prevent waiter starvation in __wait_on_bit_lock
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/23 Oleg Nesterov <oleg@redhat.com>:
> On 01/23, Dmitry Adamushko wrote:
>>
>> 2009/1/22 Oleg Nesterov <oleg@redhat.com>:
>> >
>> > I think this is correct, and (unfortunately ;) you are right:
>> > we need rmb() even after finish_wait().
>>
>> Hum, I think it's actually not necessary in this particular case when
>> (1) "the next contender is us" and (2) we are in the "ret != 0" path
>> so that the only thing we really care about -- if we were exclusivly
>> woken up, then wake up somebody else [*].
>>
>> "the next contender is us" implies that we were still on the 'wq'
>> queue when __wake_up_bit() -> __wake_up() has been called, meaning
>> that wq->lock has also been taken (in __wake_up()).
>>
>> Now, on our side, we are definitely on the 'wq' queue before calling
>> finish_wait(), meaning that we also take the wq->lock.
>>
>> In short, wq->lock is a sync. mechanism in this case. The scheme is as follows:
>>
>> our side:
>>
>> [ finish_wait() ]
>>
>> lock(wq->lock);
>
> But we can skip lock(wq->lock), afaics.
>
> Without rmb(), test_bit() can be re-ordered with list_empty_careful()
> in finish_wait() and even with __set_task_state(TASK_RUNNING).

But taking into account the constraints of this special case, namely
(1), we can't skip lock(wq->lock).

(1) "the next contender is us"

In this particular situation, we are only interested in the case when
we were woken up by __wake_up_bit().

that means we are _on_ the 'wq' list when we do finish_wait() -> we do
take the 'wq->lock'.

Moreover, imagine the following case (roughly similar to finish_wait()):

if (LOAD(a) == 1) {
    // do something here
    mb();
}

LOAD(b);

Can LOAD(b) be reordered with LOAD(a)?

I'd imagine that it can be done with CPUs that do execute 2 branch
paths in advance but then LOAD(b) must be re-loaded if (a == 1) and we
hit mb().


>
> Oleg.
>

-- 
Best regards,
Dmitry Adamushko
