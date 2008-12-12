Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYLLQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYLLQtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbYLLQss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:48:48 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:37638 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbYLLQso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:48:44 -0500
Message-ID: <494295C6.2020906@cosmosbay.com>
Date: Fri, 12 Dec 2008 17:48:06 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com> <494196DD.5070600@cosmosbay.com> <200707241113.46834.nickpiggin@yahoo.com.au> <4941EC65.5040903@cosmosbay.com>
In-Reply-To: <4941EC65.5040903@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 12 Dec 2008 17:48:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Nick Piggin a écrit :
>> On Friday 12 December 2008 09:40, Eric Dumazet wrote:
>>> From: Christoph Lameter <cl@linux-foundation.org>
>>>
>>> [PATCH] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU
>>>
>>> Currently we schedule RCU frees for each file we free separately. That has
>>> several drawbacks against the earlier file handling (in 2.6.5 f.e.), which
>>> did not require RCU callbacks:
>>>
>>> 1. Excessive number of RCU callbacks can be generated causing long RCU
>>>   queues that in turn cause long latencies. We hit SLUB page allocation
>>>   more often than necessary.
>>>
>>> 2. The cache hot object is not preserved between free and realloc. A close
>>>   followed by another open is very fast with the RCUless approach because
>>>   the last freed object is returned by the slab allocator that is
>>>   still cache hot. RCU free means that the object is not immediately
>>>   available again. The new object is cache cold and therefore open/close
>>>   performance tests show a significant degradation with the RCU
>>>   implementation.
>>>
>>> One solution to this problem is to move the RCU freeing into the Slab
>>> allocator by specifying SLAB_DESTROY_BY_RCU as an option at slab creation
>>> time. The slab allocator will do RCU frees only when it is necessary
>>> to dispose of slabs of objects (rare). So with that approach we can cut
>>> out the RCU overhead significantly.
>>>
>>> However, the slab allocator may return the object for another use even
>>> before the RCU period has expired under SLAB_DESTROY_BY_RCU. This means
>>> there is the (unlikely) possibility that the object is going to be
>>> switched under us in sections protected by rcu_read_lock() and
>>> rcu_read_unlock(). So we need to verify that we have acquired the correct
>>> object after establishing a stable object reference (incrementing the
>>> refcounter does that).
>>>
>>>
>>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> ---
>>>  Documentation/filesystems/files.txt |   21 ++++++++++++++--
>>>  fs/file_table.c                     |   33 ++++++++++++++++++--------
>>>  include/linux/fs.h                  |    5 ---
>>>  3 files changed, 42 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/files.txt
>>> b/Documentation/filesystems/files.txt index ac2facc..6916baa 100644
>>> --- a/Documentation/filesystems/files.txt
>>> +++ b/Documentation/filesystems/files.txt
>>> @@ -78,13 +78,28 @@ the fdtable structure -
>>>     that look-up may race with the last put() operation on the
>>>     file structure. This is avoided using atomic_long_inc_not_zero()
>>>     on ->f_count :
>>> +   As file structures are allocated with SLAB_DESTROY_BY_RCU,
>>> +   they can also be freed before a RCU grace period, and reused,
>>> +   but still as a struct file.
>>> +   It is necessary to check again after getting
>>> +   a stable reference (ie after atomic_long_inc_not_zero()),
>>> +   that fcheck_files(files, fd) points to the same file.
>>>
>>>  	rcu_read_lock();
>>>  	file = fcheck_files(files, fd);
>>>  	if (file) {
>>> -		if (atomic_long_inc_not_zero(&file->f_count))
>>> +		if (atomic_long_inc_not_zero(&file->f_count)) {
>>>  			*fput_needed = 1;
>>> -		else
>>> +			/*
>>> +			 * Now we have a stable reference to an object.
>>> +			 * Check if other threads freed file and reallocated it.
>>> +			 */
>>> +			if (file != fcheck_files(files, fd)) {
>>> +				*fput_needed = 0;
>>> +				put_filp(file);
>>> +				file = NULL;
>>> +			}
>>> +		} else
>>>  		/* Didn't get the reference, someone's freed */
>>>  			file = NULL;
>>>  	}
>>> @@ -95,6 +110,8 @@ the fdtable structure -
>>>     atomic_long_inc_not_zero() detects if refcounts is already zero or
>>>     goes to zero during increment. If it does, we fail
>>>     fget()/fget_light().
>>> +   The second call to fcheck_files(files, fd) checks that this filp
>>> +   was not freed, then reused by an other thread.
>>>
>>>  6. Since both fdtable and file structures can be looked up
>>>     lock-free, they must be installed using rcu_assign_pointer()
>>> diff --git a/fs/file_table.c b/fs/file_table.c
>>> index a46e880..3e9259d 100644
>>> --- a/fs/file_table.c
>>> +++ b/fs/file_table.c
>>> @@ -37,17 +37,11 @@ static struct kmem_cache *filp_cachep __read_mostly;
>>>
>>>  static struct percpu_counter nr_files __cacheline_aligned_in_smp;
>>>
>>> -static inline void file_free_rcu(struct rcu_head *head)
>>> -{
>>> -	struct file *f =  container_of(head, struct file, f_u.fu_rcuhead);
>>> -	kmem_cache_free(filp_cachep, f);
>>> -}
>>> -
>>>  static inline void file_free(struct file *f)
>>>  {
>>>  	percpu_counter_dec(&nr_files);
>>>  	file_check_state(f);
>>> -	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
>>> +	kmem_cache_free(filp_cachep, f);
>>>  }
>>>
>>>  /*
>>> @@ -306,6 +300,14 @@ struct file *fget(unsigned int fd)
>>>  			rcu_read_unlock();
>>>  			return NULL;
>>>  		}
>>> +		/*
>>> +		 * Now we have a stable reference to an object.
>>> +		 * Check if other threads freed file and re-allocated it.
>>> +		 */
>>> +		if (unlikely(file != fcheck_files(files, fd))) {
>>> +			put_filp(file);
>>> +			file = NULL;
>>> +		}
>> This is a non-trivial change, because that put_filp may drop the last
>> reference to the file. So now we have the case where we free the file
>> from a context in which it had never been allocated.
> 
> If we got at this point, we :
> 
> Found a non NULL pointer in our fd table.
> Then, another thread came, closed the file while we not yet added our reference.
> This file was freed (kmem_cache_free(filp_cachep, file))
> This file was reused and inserted on another thread fd table.
> We added our reference on refcount.
> We checked if this file is still ours (in our fd tab).
> We found this file is not anymore the file we wanted.
> Calling put_filp() here is our only choice to safely remove the reference on
> a truly allocated file. At this point the file is
> a truly allocated file but not anymore ours.
> Unfortunatly we added a reference on it : we must release it.
> If the other thread already called put_filp() because it wanted to close its new file,
> we must see f_refcnt going to zero, and we must call __fput(), to perform
> all the relevant file cleanup ourself.

Reading again this mail I realise we call put_filp(file), while this should
be fput(file) or put_filp(file), we dont know.

Damned, this patch is wrong as is.

Christoph, Paul, do you see the problem ?

In fget()/fget_light() we dont know if the other thread (the one who re-allocated the file,
and tried to close it while we got a reference on file) had to call put_filp() or fput()
to release its own reference. So we call atomic_long_dec_and_test() and cannot
take the appropriate action (calling the full __fput() version or the small one,
that some systems use to 'close' an not really opened file.

void put_filp(struct file *file)
{
        if (atomic_long_dec_and_test(&file->f_count)) {
                security_file_free(file);
                file_kill(file);
                file_free(file);
        }
}

void fput(struct file *file)
{
        if (atomic_long_dec_and_test(&file->f_count))
                __fput(file);
}

I believe put_filp() is only called on slowpath (error cases).

Should we just zap it and always call fput() ?



