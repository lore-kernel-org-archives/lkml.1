Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZESWUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZESWUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZESWUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:20:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36482 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZESWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:20:38 -0400
Message-ID: <4A1330B4.70808@us.ibm.com>
Date: Tue, 19 May 2009 15:20:36 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] core kernel fixes
References: <20090518142301.GA22765@elte.hu> <alpine.LFD.2.01.0905180840420.3301@localhost.localdomain> <alpine.LFD.2.00.0905181801250.3516@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905181801250.3516@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Linus,
> 
> On Mon, 18 May 2009, Linus Torvalds wrote:
>> On Mon, 18 May 2009, Ingo Molnar wrote:
>>> Thomas Gleixner (1):
>>>       futex: futex mapping needs to be writable
>> I do not believe this is right.
> 
> You are right to believe that :)
> 
>> Just a few lines later, we have:
>>
>>          * NOTE: When userspace waits on a MAP_SHARED mapping, even if
>>          * it's a read-only handle, it's expected that futexes attach to   
>>          * the object not the particular process.
>>
>> note how we are _supposed_ to be able to wait for something that is 
>> read-only. As such, asking for a writable page is bogus.
> 
> We write access the user space address in various places in the futex
> functions, so we really need a writeable mapping for a bunch of the
> futex ops. 
> 
> We have an explicit check for the private futexes a few lines up.
> 
>       if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
> 
> There are some of the futex ops which can be done with a RO mapping
> though. I'm not sure if it makes much sense as user space (at least
> glibc) always writes the variable and/or the surrounding members in
> the user space data structures, but for now we should leave it RO for
> the ones which do not modify the user value.
> 
>> I'm not going to pull this. I can well imagine that there was a real bug, 
>> but this is _not_ the real fix.
>>
>> The commentary is also TOTAL CRAP as far as I can tell. It starts out 
>> with:
>>
>>     commit 734b05b10e51d4ba38c8fc3ee02e846aab09eedf (futex: use
>>     fast_gup()) calls get_user_pages_fast() with the write argument set to
>>     0. This went unnoticed [...]
>>
>> and that is pure and utter SHIT. The fact is, the write argument was 
>> ALWAYS zero, and commit 734b05b10e51d4ba38c8fc3ee02e846aab09eedf has 
>> nothing to do with anything what-so-ever, and nothing went unnoticed 
>> anywhere.
> 
> Sorry, I misread the GUP commit.
> 
>> The real bug was apparently just commit e4dc5b7a3 ("clean up").
> 
> So we always had that write=0 mapping. And we did not notice that we
> always faulted in the futex functions which modify the user space
> variable simply because the fault was fixed up in the private futex
> fault handling code. The removal of that code led to the problem which
> we have right now.
> 
> Correct fix below.
> 
> Thanks,
> 
> 	tglx
> ------>
> futex: setup writeable mapping for futex ops which modify user space data
> 
> The futex code installs a read only mapping via get_user_pages_fast()
> even if the futex op function has to modify user space data. The
> eventual fault was fixed up by futex_handle_fault() which walked the
> VMA with mmap_sem held.
> 
> After the cleanup patches which removed the mmap_sem dependency of the
> futex code commit 4dc5b7a36a49eff97050894cf1b3a9a02523717 (futex:
> clean up fault logic) removed the private VMA walk logic from the
> futex code. This change results in a stale RO mapping which is not
> fixed up.
> 
> Instead of reintroducing the previous fault logic we set up the
> mapping in get_user_pages_fast() read/write for all operations which
> modify user space data. Also handle private futexes in the same way
> and make the current unconditional access_ok(VERIFY_WRITE) depend on
> the futex op.
> 
> Reported-by: Andreas Schwab <schwab@linux-m68k.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

This looks to be an elegant fix to me and maintains the fault logic 
cleanup that actually caused the stale RO mapping issue mentioned above. 
  My only comment would be that it further obsoletes some commentary in 
functions like futex_lock_pi() about how fault handling is done.  I'll 
just add this to my list of futex commentary to fix!

Acked-by: Darren Hart <dvhltc@us.ibm.com>

> CC: stable@kernel.org
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index eef8cd2..3d7519d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -193,6 +193,7 @@ static void drop_futex_key_refs(union futex_key *key)
>   * @uaddr: virtual address of the futex
>   * @fshared: 0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
>   * @key: address where result is stored.
> + * @rw: mapping needs to be read/write (values: VERIFY_READ, VERIFY_WRITE)
>   *
>   * Returns a negative error code or 0
>   * The key words are stored in *key on success.
> @@ -203,7 +204,8 @@ static void drop_futex_key_refs(union futex_key *key)
>   *
>   * lock_page() might sleep, the caller should not hold a spinlock.
>   */
> -static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> +static int
> +get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
> @@ -226,7 +228,7 @@ static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  	 *        but access_ok() should be faster than find_vma()
>  	 */
>  	if (!fshared) {
> -		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
> +		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
>  			return -EFAULT;
>  		key->private.mm = mm;
>  		key->private.address = address;
> @@ -235,7 +237,7 @@ static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  	}
> 
>  again:
> -	err = get_user_pages_fast(address, 1, 0, &page);
> +	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
>  	if (err < 0)
>  		return err;
> 
> @@ -677,7 +679,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
>  	if (!bitset)
>  		return -EINVAL;
> 
> -	ret = get_futex_key(uaddr, fshared, &key);
> +	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> @@ -723,10 +725,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
>  	int ret, op_ret;
> 
>  retry:
> -	ret = get_futex_key(uaddr1, fshared, &key1);
> +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2);
> +	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
> 
> @@ -814,10 +816,10 @@ static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
>  	int ret, drop_count = 0;
> 
>  retry:
> -	ret = get_futex_key(uaddr1, fshared, &key1);
> +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2);
> +	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
> 
> @@ -1140,7 +1142,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
>  	q.bitset = bitset;
>  retry:
>  	q.key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q.key);
> +	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> @@ -1330,7 +1332,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
>  	q.pi_state = NULL;
>  retry:
>  	q.key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q.key);
> +	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> @@ -1594,7 +1596,7 @@ retry:
>  	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
>  		return -EPERM;
> 
> -	ret = get_futex_key(uaddr, fshared, &key);
> +	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
