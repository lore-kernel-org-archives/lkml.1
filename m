Return-Path: <linux-kernel-owner+w=401wt.eu-S1766634AbXDFBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766634AbXDFBTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767472AbXDFBTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:19:18 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24195 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1766634AbXDFBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:19:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=srr4+CLAmeMIZkA7UL4ifEULeR+dpuwF0ug9PeA/ffemnvYJZYvMSfoN9vlbt0sUk3yzARXcP6dQkQzX33d3xSsCSDvpdMUGHnuU9qZhGCNBGPtFjOtfq3VDnOzKCNU0pCjfgiLDBb6AHvcaPXyIXnB4p3sEn4egPe6m7qO/NCU=  ;
X-YMail-OSG: mwF.aLkVM1nsppVd_tCMywJraa5dMSetv.QUKUwvhq1.Mfm0r7KL1UUE72xizC7KSeRmLBkEUA--
Message-ID: <4615A009.808@yahoo.com.au>
Date: Fri, 06 Apr 2007 11:19:05 +1000
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
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com> <20070405194942.1414c030.dada1@cosmosbay.com>
In-Reply-To: <20070405194942.1414c030.dada1@cosmosbay.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thanks for doing this... It's looking good, I just have some minor
comments:

Eric Dumazet wrote:

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

> --- linux-2.6.21-rc5-mm4/kernel/futex.c
> +++ linux-2.6.21-rc5-mm4-ed/kernel/futex.c
> @@ -16,6 +16,9 @@
>   *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
>   *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
>   *
> + *  PRIVATE futexes by Eric Dumazet
> + *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
> + *
>   *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
>   *  enough at me, Linus for the original (flawed) idea, Matthew
>   *  Kirkwood for proof-of-concept implementation.
> @@ -199,9 +202,12 @@ static inline int match_futex(union fute
>   * Returns: 0, or negative error code.
>   * The key words are stored in *key on success.
>   *
> - * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
> + * shared is NULL for PROCESS_PRIVATE futexes
> + * For other futexes, it points to &current->mm->mmap_sem and
> + * caller must have taken the reader lock. but NOT any spinlocks.
>   */
> -int get_futex_key(void __user *uaddr, union futex_key *key)
> +int get_futex_key(void __user *uaddr, union futex_key *key,
> +	struct rw_semaphore *shared)

Can we pass in something other than the rw_semaphore here? Seeing as
it only actually gets used as a flag, it might be nicer just to pass
a 0 or 1? And all through the call stack...

Did the whole thing just turn out neater when you passed the rwsem?
We always know to use current->mm->mmap_sem, so it doesn't seem like
a boolean flag would hurt?

>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
> @@ -218,6 +224,22 @@ int get_futex_key(void __user *uaddr, un
>  	address -= key->both.offset;
>  
>  	/*
> +	 * PROCESS_PRIVATE futexes are fast.
> +	 * As the mm cannot disappear under us and the 'key' only needs
> +	 * virtual address, we dont even have to find the underlying vma.
> +	 * Note : We do have to check 'address' is a valid user address,
> +	 *        but access_ok() should be faster than find_vma()
> +	 * Note : At this point, address points to the start of page,
> +	 *        not the real futex address, this is ok.
> +	 */
> +	if (!shared) {
> +		if (!access_ok(VERIFY_WRITE, address, sizeof(int)))
> +			return -EFAULT;

Shouldn't that be sizeof(long) to handle 64 bit futexes? Or strictly, it
should depend on the size of the operation. Maybe the access_ok check
should go outside get_futex_key?


> +		key->private.mm = mm;
> +		key->private.address = address;
> +		return 0;
> +	}
> +	/*
>  	 * The futex is hashed differently depending on whether
>  	 * it's in a shared or private mapping.  So check vma first.
>  	 */
> @@ -244,6 +266,7 @@ int get_futex_key(void __user *uaddr, un
>  	 * mappings of _writable_ handles.
>  	 */
>  	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
> +		key->both.offset += FUT_OFF_MMSHARED; /* reference taken on mm */
>  		key->private.mm = mm;
>  		key->private.address = address;
>  		return 0;
> @@ -253,7 +276,7 @@ int get_futex_key(void __user *uaddr, un
>  	 * Linear file mappings are also simple.
>  	 */
>  	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
> -	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
> +	key->both.offset += FUT_OFF_INODE; /* inode-based key. */
>  	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
>  		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
>  				     + vma->vm_pgoff);

I like |= for adding flags, it seems less ambiguous. But I guess that's
a matter of opinion. Hugh seems to like +=, and I can't argue with him
about style issues ;)

> @@ -281,17 +304,19 @@ EXPORT_SYMBOL_GPL(get_futex_key);
>   * Take a reference to the resource addressed by a key.
>   * Can be called while holding spinlocks.
>   *
> - * NOTE: mmap_sem MUST be held between get_futex_key() and calling this
> - * function, if it is called at all.  mmap_sem keeps key->shared.inode valid.
>   */
>  inline void get_futex_key_refs(union futex_key *key)
>  {
> -	if (key->both.ptr != 0) {
> -		if (key->both.offset & 1)
> +	if (key->both.ptr == 0)
> +		return;
> +	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
> +		case FUT_OFF_INODE:
>  			atomic_inc(&key->shared.inode->i_count);
> -		else
> +			break;
> +		case FUT_OFF_MMSHARED:
>  			atomic_inc(&key->private.mm->mm_count);
> -	}
> +			break;
> +  	}
>  }
>  EXPORT_SYMBOL_GPL(get_futex_key_refs);
>  
> @@ -301,11 +326,15 @@ EXPORT_SYMBOL_GPL(get_futex_key_refs);
>   */
>  void drop_futex_key_refs(union futex_key *key)
>  {
> -	if (key->both.ptr != 0) {
> -		if (key->both.offset & 1)
> +	if (key->both.ptr == 0)
> +		return;
> +	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
> +		case FUT_OFF_INODE:
>  			iput(key->shared.inode);
> -		else
> +			break;
> +		case FUT_OFF_MMSHARED:
>  			mmdrop(key->private.mm);
> +			break;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(drop_futex_key_refs);

I wonder if it would be worthwhile inlining and likley()ing the
private fastpath? Might make it pretty compact... I guess that's
something to worry about after glibc gets support.

> @@ -339,28 +368,40 @@ get_futex_value_locked(unsigned long *de
>  }
>  
>  /*
> - * Fault handling. Called with current->mm->mmap_sem held.
> + * Fault handling.
> + * if shared is non NULL, current->mm->mmap_sem is already held
>   */
> -static int futex_handle_fault(unsigned long address, int attempt)
> +static int futex_handle_fault(unsigned long address, int attempt,
> +	struct rw_semaphore *shared)
>  {
>  	struct vm_area_struct * vma;
>  	struct mm_struct *mm = current->mm;
> +	int ret = 0;
>  
> -	if (attempt > 2 || !(vma = find_vma(mm, address)) ||
> -	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
> +	if (attempt > 2)
>  		return -EFAULT;
>  
> -	switch (handle_mm_fault(mm, vma, address, 1)) {
> -	case VM_FAULT_MINOR:
> -		current->min_flt++;
> -		break;
> -	case VM_FAULT_MAJOR:
> -		current->maj_flt++;
> -		break;
> -	default:
> -		return -EFAULT;
> -	}
> -	return 0;
> +	if (!shared)
> +		down_read(&mm->mmap_sem);
> +
> +	if (!(vma = find_vma(mm, address)) ||
> +	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
> +		ret = -EFAULT;
> +
> +	else
> +		switch (handle_mm_fault(mm, vma, address, 1)) {
> +		case VM_FAULT_MINOR:
> +			current->min_flt++;
> +			break;
> +		case VM_FAULT_MAJOR:
> +			current->maj_flt++;
> +			break;
> +		default:
> +			ret = -EFAULT;
> +		}
> +	if (!shared)
> +		up_read(&mm->mmap_sem);
> +	return ret;
>  }
>  
>  /*

You've got an extra space after the if (maybe for clarity?). In this
situation I prefer putting braces around both the if and the else, and
if you get rid of that blank line, it doesn't cost you anything more ;)

> @@ -1598,6 +1656,8 @@ static int futex_wait(unsigned long __us
>  		restart->arg1 = val;
>  		restart->arg2 = (unsigned long)abs_time;
>  		restart->arg3 = (unsigned long)futex64;
> +		if (shared)
> +			restart->arg3 |= 2;

Could you make this into a proper flags argument and use #define CONSTANTs for it?

> @@ -2377,23 +2455,24 @@ sys_futex64(u64 __user *uaddr, int op, u
>  	struct timespec ts;
>  	ktime_t t, *tp = NULL;
>  	u64 val2 = 0;
> +	int opm = op & FUTEX_CMD_MASK;

What's opm stand for?

>  
> -	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
> +	if (utime && (opm == FUTEX_WAIT || opm == FUTEX_LOCK_PI)) {


-- 
SUSE Labs, Novell Inc.
