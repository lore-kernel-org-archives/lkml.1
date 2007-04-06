Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXDFFxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXDFFxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 01:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXDFFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 01:53:48 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33834 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbXDFFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 01:53:46 -0400
Message-ID: <4615E044.6080205@cosmosbay.com>
Date: Fri, 06 Apr 2007 07:53:08 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com> <20070405194942.1414c030.dada1@cosmosbay.com> <4615A009.808@yahoo.com.au>
In-Reply-To: <4615A009.808@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 06 Apr 2007 07:53:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> Hi Eric,
> 
> Thanks for doing this... It's looking good, I just have some minor
> comments:

Hi Nick, thanks for reviewing.

> 
> Eric Dumazet wrote:
>>   */
>> -int get_futex_key(void __user *uaddr, union futex_key *key)
>> +int get_futex_key(void __user *uaddr, union futex_key *key,
>> +    struct rw_semaphore *shared)
> 
> Can we pass in something other than the rw_semaphore here? Seeing as
> it only actually gets used as a flag, it might be nicer just to pass
> a 0 or 1? And all through the call stack...
> 
> Did the whole thing just turn out neater when you passed the rwsem?
> We always know to use current->mm->mmap_sem, so it doesn't seem like
> a boolean flag would hurt?

That's a good question

current->mm->mmap_sem being calculated once is a win in itself, because 
current access is not cheap.
It also does the memory access to go through part of the chain in advance, 
before its use. It does a prefetch() equivalent for free : If current->mm is 
not in CPU cache, CPU wont stall because next instructions dont depend on it.

This means less CPU stall in case current->mm is not in CPU cache. Thats 
difficult to benchmark it, but you can trust me.

A flag means :

if (flag)
     up_read(&current->mm->mmap_sem)

This generates quite a bad code.

if (ptr)
    up_read(ptr)

generates *much* better code.

So this is a cleanup and a runtime optimization.

I dit a similar optimization on commit 163da958ba5282cbf85e8b3dc08e4f51f8b01c5e

I invite you to check it :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=163da958ba5282cbf85e8b3dc08e4f51f8b01c5e



> 
>>  {
>>      unsigned long address = (unsigned long)uaddr;
>>      struct mm_struct *mm = current->mm;
>> @@ -218,6 +224,22 @@ int get_futex_key(void __user *uaddr, un
>>      address -= key->both.offset;
>>  
>>      /*
>> +     * PROCESS_PRIVATE futexes are fast.
>> +     * As the mm cannot disappear under us and the 'key' only needs
>> +     * virtual address, we dont even have to find the underlying vma.
>> +     * Note : We do have to check 'address' is a valid user address,
>> +     *        but access_ok() should be faster than find_vma()
>> +     * Note : At this point, address points to the start of page,
>> +     *        not the real futex address, this is ok.
>> +     */
>> +    if (!shared) {
>> +        if (!access_ok(VERIFY_WRITE, address, sizeof(int)))
>> +            return -EFAULT;
> 
> Shouldn't that be sizeof(long) to handle 64 bit futexes? Or strictly, it
> should depend on the size of the operation. Maybe the access_ok check
> should go outside get_futex_key?

If you check again, you'll see that address points to the start of the PAGE, 
not the real u32/u64 futex address. This checks the PAGE. We can use char, 
short, int, long, or char[PAGE_SIZE] as long as we know a futex cannot span 
two pages.


>>       */
>>      key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
>> -    key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
>> +    key->both.offset += FUT_OFF_INODE; /* inode-based key. */
>>      if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
>>          key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
>>                       + vma->vm_pgoff);
> 
> I like |= for adding flags, it seems less ambiguous. But I guess that's
> a matter of opinion. Hugh seems to like +=, and I can't argue with him
> about style issues ;)


Previous code was doing offset++ wich means offset += 1;
I didnt want to hurt Hugh :)

>>  EXPORT_SYMBOL_GPL(drop_futex_key_refs);
> 
> I wonder if it would be worthwhile inlining and likley()ing the
> private fastpath? Might make it pretty compact... I guess that's
> something to worry about after glibc gets support.

Yes, in a future patch, in about one year :)

>> +
>> +    if (!(vma = find_vma(mm, address)) ||
>> +        vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
>> +        ret = -EFAULT;
>> +
>> +    else
>> +        switch (handle_mm_fault(mm, vma, address, 1)) {
>> +        case VM_FAULT_MINOR:
>> +            current->min_flt++;
>> +            break;
>> +        case VM_FAULT_MAJOR:
>> +            current->maj_flt++;
>> +            break;
>> +        default:
>> +            ret = -EFAULT;
>> +        }
>> +    if (!shared)
>> +        up_read(&mm->mmap_sem);
>> +    return ret;
>>  }
>>  
>>  /*
> 
> You've got an extra space after the if (maybe for clarity?). In this
> situation I prefer putting braces around both the if and the else, and
> if you get rid of that blank line, it doesn't cost you anything more ;)

Oh well...

> 
>> @@ -1598,6 +1656,8 @@ static int futex_wait(unsigned long __us
>>          restart->arg1 = val;
>>          restart->arg2 = (unsigned long)abs_time;
>>          restart->arg3 = (unsigned long)futex64;
>> +        if (shared)
>> +            restart->arg3 |= 2;
> 
> Could you make this into a proper flags argument and use #define 
> CONSTANTs for it?

Yes, but I'm not sure it will improve readability.

> 
>> @@ -2377,23 +2455,24 @@ sys_futex64(u64 __user *uaddr, int op, u
>>      struct timespec ts;
>>      ktime_t t, *tp = NULL;
>>      u64 val2 = 0;
>> +    int opm = op & FUTEX_CMD_MASK;
> 
> What's opm stand for?

I guess 'm' stands for 'mask' or 'masked' ?

Thank you
