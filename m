Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXDFLui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXDFLui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 07:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767595AbXDFLui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 07:50:38 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:34519 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752683AbXDFLuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 07:50:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=d6QIlHRScgvPxqaOzHCwbDDSVgOL3Zn8EtisQRynZ8UOe5FEMAtVVolIribHz0pHBDbqEGL6Uolz0sssOqO5NLaSsBzhVOLrFiPdQKjGYwVRtjw9y8QYWR9uqg77xnMGvuQX/3SheAQxA7XfZRhoFH/Z0nt2fCd4s/tuNIHNj94=  ;
X-YMail-OSG: _EOFrQIVM1mKvEZQGO25hELdmsb3jErCkDwK8zkpO91rWXbTVMjSsb6UKn.gwcoLgulVjgA_CA--
Message-ID: <461633F8.90607@yahoo.com.au>
Date: Fri, 06 Apr 2007 21:50:16 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com> <20070405194942.1414c030.dada1@cosmosbay.com> <4615A009.808@yahoo.com.au> <4615E044.6080205@cosmosbay.com>
In-Reply-To: <4615E044.6080205@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Nick Piggin a écrit :

>> Did the whole thing just turn out neater when you passed the rwsem?
>> We always know to use current->mm->mmap_sem, so it doesn't seem like
>> a boolean flag would hurt?
> 
> 
> That's a good question
> 
> current->mm->mmap_sem being calculated once is a win in itself, because 
> current access is not cheap.
> It also does the memory access to go through part of the chain in 
> advance, before its use. It does a prefetch() equivalent for free : If 
> current->mm is not in CPU cache, CPU wont stall because next 
> instructions dont depend on it.

Fair enough. Current access I think should be cheap though (it is
effectively a constant), but I guess it is still improvement.

>> Shouldn't that be sizeof(long) to handle 64 bit futexes? Or strictly, it
>> should depend on the size of the operation. Maybe the access_ok check
>> should go outside get_futex_key?
> 
> 
> If you check again, you'll see that address points to the start of the 
> PAGE, not the real u32/u64 futex address. This checks the PAGE. We can 
> use char, short, int, long, or char[PAGE_SIZE] as long as we know a 
> futex cannot span two pages.

Ah, that works.

>>>       */
>>>      key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
>>> -    key->both.offset++; /* Bit 0 of offset indicates inode-based 
>>> key. */
>>> +    key->both.offset += FUT_OFF_INODE; /* inode-based key. */
>>>      if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
>>>          key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
>>>                       + vma->vm_pgoff);
>>
>>
>> I like |= for adding flags, it seems less ambiguous. But I guess that's
>> a matter of opinion. Hugh seems to like +=, and I can't argue with him
>> about style issues ;)
> 
> 
> 
> Previous code was doing offset++ wich means offset += 1;

But it doesn't mean you have to ;)

>>> @@ -1598,6 +1656,8 @@ static int futex_wait(unsigned long __us
>>>          restart->arg1 = val;
>>>          restart->arg2 = (unsigned long)abs_time;
>>>          restart->arg3 = (unsigned long)futex64;
>>> +        if (shared)
>>> +            restart->arg3 |= 2;
>>
>>
>> Could you make this into a proper flags argument and use #define 
>> CONSTANTs for it?
> 
> 
> Yes, but I'm not sure it will improve readability.

Well that bit of code alone is obviously unreadable.

restart->arg3 = 0;
if (futex64)
     restart->arg3 |= FUTEX_64;
if (shared)
     restart->arg3 |= FUTEX_SHARED;

Maybe a matter of taste.

> 
>>
>>> @@ -2377,23 +2455,24 @@ sys_futex64(u64 __user *uaddr, int op, u
>>>      struct timespec ts;
>>>      ktime_t t, *tp = NULL;
>>>      u64 val2 = 0;
>>> +    int opm = op & FUTEX_CMD_MASK;
>>
>>
>> What's opm stand for?
> 
> 
> I guess 'm' stands for 'mask' or 'masked' ?

Why not call it cmd? (ie. what it is, rather than what you have done
to derive it).

-- 
SUSE Labs, Novell Inc.
