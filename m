Return-Path: <linux-kernel-owner+w=401wt.eu-S934571AbXGZRqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbXGZRqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765622AbXGZRqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:46:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41023 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829AbXGZRqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:46:02 -0400
Message-ID: <46A8DDD4.9090600@us.ibm.com>
Date: Thu, 26 Jul 2007 10:45:56 -0700
From: "David J. Wilder" <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Ankita Garg <ankita@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, zanussi@linux.vnet.ibm.com
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726073520.GA12206@elte.hu> <20070726074957.GA19398@in.ibm.com> <20070726075353.GA19885@elte.hu> <20070726095948.GB19398@in.ibm.com> <20070726110504.GB7673@elte.hu> <20070726130632.GB28556@Krystal>
In-Reply-To: <20070726130632.GB28556@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess they might have to switch to such an asynchronous delivery
> system if they want to do this properly. Simply put, your polling
> solution is exactly what I do, but I check a flag set by the writer
> instead of waking up the readers unconditionally.
>
> Mathieu
>   

Ingo's solution could call waitqueue_active() inside wakeup_readers() to 
determine if there are waiters. Right?

>   
>> 	Ingo
>>
>> ------------------------------------->
>> Subject: relay: fix timer madness
>> From: Ingo Molnar <mingo@elte.hu>
>>
>> remove timer calls (!!!) from deep within the tracing infrastructure.
>> This was totally bogus code that can cause lockups and worse.
>> Poll the buffer every 2 jiffies for now.
>>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  kernel/relay.c |   14 +++++---------
>>  1 file changed, 5 insertions(+), 9 deletions(-)
>>
>> Index: linux-rt-rebase.q/kernel/relay.c
>> ===================================================================
>> --- linux-rt-rebase.q.orig/kernel/relay.c
>> +++ linux-rt-rebase.q/kernel/relay.c
>> @@ -319,6 +319,10 @@ static void wakeup_readers(unsigned long
>>  {
>>  	struct rchan_buf *buf = (struct rchan_buf *)data;
>>  	wake_up_interruptible(&buf->read_wait);
>> +	/*
>> +	 * Stupid polling for now:
>> +	 */
>> +	mod_timer(&buf->timer, jiffies + 1);
>>  }
>>  
>>  /**
>> @@ -336,6 +340,7 @@ static void __relay_reset(struct rchan_b
>>  		init_waitqueue_head(&buf->read_wait);
>>  		kref_init(&buf->kref);
>>  		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
>> +		mod_timer(&buf->timer, jiffies + 1);
>>  	} else
>>  		del_timer_sync(&buf->timer);
>>  
>> @@ -604,15 +609,6 @@ size_t relay_switch_subbuf(struct rchan_
>>  		buf->subbufs_produced++;
>>  		buf->dentry->d_inode->i_size += buf->chan->subbuf_size -
>>  			buf->padding[old_subbuf];
>> -		smp_mb();
>> -		if (waitqueue_active(&buf->read_wait))
>> -			/*
>> -			 * Calling wake_up_interruptible() from here
>> -			 * will deadlock if we happen to be logging
>> -			 * from the scheduler (trying to re-grab
>> -			 * rq->lock), so defer it.
>> -			 */
>> -			__mod_timer(&buf->timer, jiffies + 1);
>>  	}
>>  
>>  	old = buf->data;
>>     
>
>   

