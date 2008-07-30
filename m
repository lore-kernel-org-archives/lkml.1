Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYG3Ao4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYG3Ao4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYG3Aop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:44:45 -0400
Received: from gw.goop.org ([64.81.55.164]:34767 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYG3Aon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:44:43 -0400
Message-ID: <488FB976.7080803@goop.org>
Date: Tue, 29 Jul 2008 17:44:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] generic smp function call: add multiple queues for
 scaling
References: <488FA8A5.6060204@goop.org> <20080730002603.GB23938@one.firstfloor.org>
In-Reply-To: <20080730002603.GB23938@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Ah I see the locking is here. Never mind the earlier comment.
>
>   
>> +#define	NQUEUES	CONFIG_GENERIC_SMP_QUEUES
>> +#else
>> +#define	NQUEUES	1
>> +#endif
>> +
>> static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
>> -static LIST_HEAD(call_function_queue);
>> -__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
>> +struct queue {
>> +	struct list_head list;
>> +	spinlock_t lock;
>> +};
>> +
>> +static __cacheline_aligned_in_smp struct queue 
>> call_function_queues[NQUEUES];
>>     
>
> Hmm are you sure this aligns the individual elements and not the whole
> array? 
>   

Hm, that's a point.  I guess the __cacheline_aligned_in_smp should be on 
the struct definition.

>> +static int __init init_smp_function_call(void)
>> +{
>> +	int i;
>> +
>> +	for(i = 0; i < NQUEUES; i++) {
>> +		INIT_LIST_HEAD(&call_function_queues[i].list);
>> +		spin_lock_init(&call_function_queues[i].lock);
>> +	}
>> +
>> +	return 0;
>> +}
>> +early_initcall(init_smp_function_call);
>>     
>
> You can avoid all that init gunk by using the [0 ... NQUEUES] = ..
> gcc extension in the initializer.
>   

Are you sure?  I tried using it, but couldn't work out how.  Remember 
the list head init needs to point to itself, which means it's not 
constant across the array.

    J
