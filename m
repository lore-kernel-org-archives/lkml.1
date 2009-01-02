Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZABWNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZABWNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZABWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:13:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZABWNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:13:25 -0500
Date: Fri, 2 Jan 2009 23:13:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rusty Russell <rusty@au1.ibm.com>
Subject: Re: [PATCH 2/2] futex: correct futex_requeue futex key ref
	counting in requeue loop
Message-ID: <20090102221310.GE17240@elte.hu>
References: <20081229185238.10342.75651.stgit@Aeon> <20081229185402.10342.77396.stgit@Aeon> <495AB065.3080707@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495AB065.3080707@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhltc@us.ibm.com> wrote:

> Darren Hart wrote:
>> The requeue loop takes multiple references to key2, but the corresponding
>> put loop decrements the refs for key1.  This patch corrects the accounting.
>>
>> Build and boot tested on an x86_64 system.
>>
>> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Rusty Russell <rusty@au1.ibm.com>
>> ---
>>
>>  kernel/futex.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index cf363ce..3b66d91 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -919,7 +919,7 @@ out_unlock:
>>
>>  	/* drop_futex_key_refs() must be called outside the spinlocks. */
>>  	while (--drop_count >= 0)
>> -		drop_futex_key_refs(&key1);
>> +		drop_futex_key_refs(&key2);
>>
>>  	put_futex_key(fshared, &key2);
>>  out_put_key1:
>>
>
> Ugh, so I'm having second thoughts about this patch.  I believe what is  
> happening here is that the requeue loop requeues each waiter from one  
> futex (key1) to another (key2).  It rightly takes a reference to the  
> futex at key2 and then decrements the references to key1 by drop_count  
> (since the waiters now reference key2, not key1).  The newly taken key2  
> references will be dropped in futex_wait() when each waiter is woken up  
> and takes the futex.
>
> I apologize for the confusion on this.  Thanks for suggesting I send  
> this patch out independently from the rest Peter ;-)
>
> If we can come to a consensus on this, I suggest pulling this patch from  
> tip/core/futexes.

ok, i zapped it. The patches remaining are:

90621c4: futex: catch certain assymetric (get|put)_futex_key calls
42d35d4: futex: make futex_(get|put)_key() calls symmetric

	Ingo
