Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZFYKwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZFYKwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFYKvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:51:53 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:56237 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFYKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:51:53 -0400
Message-ID: <4A4356A0.20606@gmail.com>
Date: Thu, 25 Jun 2009 12:51:12 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com
Subject: Re: [RFC] tcp: race in receive part
References: <20090618102727.GC3782@jolsa.lab.eng.brq.redhat.com> <4A3A49F2.6060705@gmail.com> <20090623091257.GA4850@jolsa.lab.eng.brq.redhat.com> <4A40AF2A.3050509@gmail.com> <20090624102038.GA5409@jolsa.lab.eng.brq.redhat.com> <4A42082D.9060402@gmail.com> <20090624162112.GB5409@jolsa.lab.eng.brq.redhat.com> <20090624163024.GA29337@redhat.com> <20090624164102.GB29337@redhat.com>
In-Reply-To: <20090624164102.GB29337@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 25 Jun 2009 12:51:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov a écrit :
> On 06/24, Oleg Nesterov wrote:
>> On 06/24, Jiri Olsa wrote:
>>> +/* The read_lock() on x86 is a full memory barrier. */
>>> +#define smp_mb__after_read_lock() barrier()
>> Just curious, why do we need barrier() ?
>>
>> I must admit, personally I dislike _read_lock part. Because I think we
>> need a "more generic" smp_mb__{before,after}_lock() or whatever which
>> work for spin_lock/read_lock/write_lock.
>>
>> In that case it can have more users. Btw, in fs/select.c too, see
>> __pollwake().
>>
>> And surprise,
>>
>>> --- a/fs/select.c
>>> +++ b/fs/select.c
>>> @@ -219,6 +219,10 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
>>>  	init_waitqueue_func_entry(&entry->wait, pollwake);
>>>  	entry->wait.private = pwq;
>>>  	add_wait_queue(wait_address, &entry->wait);
>>> +
>>> +	/* This memory barrier is paired with the smp_mb__after_read_lock
>>> +	 * in the sk_has_sleeper. */
>>> +	smp_mb();
>> This could be smp_mb__after_lock() too.
> 
> Cough. this needs mb__after_UNlock(), sorry.
> 

Yes, and this time you need separate smp_mb__after_spin_unlock(),
as rwlocks and spinlocks dont have same unlock implementation.

(spin_unlock dont have memory barrier on x86, while read_write_unlock do have a barrier)

As it wont give us a benefit on x86 but code obfuscation, I suspect we can leave this for now :)

