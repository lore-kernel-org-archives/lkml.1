Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYK0MVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYK0MVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYK0MVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:21:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:63681 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYK0MVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sj5oDxmAFBl03fzfHOSJ45+cl49LDvSElaAaO8Q1dMP+I+eef8j1FXrEAtZpFD2pYL
         xBkuy47UHFWZSEJbvQJ514Mv/uzKOxFJXSRasQuqBj7cmqrjJHXW8FZ8iz2GhA0ZY07R
         P4lgn4Z6nXH6hFAyfi9wOBFHtqGzBFy6iCpGc=
Message-ID: <492E90BC.1090208@gmail.com>
Date: Thu, 27 Nov 2008 14:21:16 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Mike Waychison <mikew@google.com>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <492E8708.4060601@gmail.com> <20081127120330.GM28285@wotan.suse.de>
In-Reply-To: <20081127120330.GM28285@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 14:03, Nick Piggin wrote:
> On Thu, Nov 27, 2008 at 01:39:52PM +0200, Török Edwin wrote:
>   
>> On 2008-11-27 11:28, Mike Waychison wrote:
>>     
>>> Correct.  I don't recall the numbers from the pathelogical cases we
>>> were seeing, but iirc, it was on the order of 10s of seconds, likely
>>> exascerbated by slower than usual disks.  I've been digging through my
>>> inbox to find numbers without much success -- we've been using a
>>> variant of this patch since 2.6.11.
>>>
>>> Török however identified mmap taking on the order of several
>>> milliseconds due to this exact problem:
>>>
>>> http://lkml.org/lkml/2008/9/12/185
>>>       
>> Hi,
>>
>> Thanks for the patch. I just tested it on top of 2.6.28-rc6-tip, see
>> /proc/lock_stat output at the end.
>>
>> Running my testcase shows no significant performance difference. What am
>> I doing wrong?
>>     
>  
> Software may just be doing a lot of mmap/munmap activity. threads +
> mmap is never going to be pretty because it is always going to involve
> broadcasting tlb flushes to other cores... Software writers shouldn't
> be scared of using processes (possibly with some shared memory).
>   

It would be interesting to compare the performance of a threaded clamd,
and of a clamd that uses multiple processes.
Distributing tasks will be a bit more tricky, since it would need to use
IPC, instead of mutexes and condition variables.

> Actually, a lot of things get faster (like malloc, or file descriptor
> operations) because locks aren't needed.
>
> Despite common perception, processes are actually much *faster* than
> threads when doing common operations like these. They are slightly slower
> sometimes with things like creation and exit, or context switching, but
> if you're doing huge numbers of those operations, then it is unlikely
> to be a performance critical app... :)
>   

How about distributing tasks to a set of worked threads, is the overhead
of using IPC instead of
mutexes/cond variables acceptable?

> (end rant; sorry, that may not have been helpful to your immediate problem,
> but we need to be realistic in what complexity we are ging to add where in
> the kernel in order to speed things up. And we need to steer userspace
> away from problems that are fundamentally hard and not going to get easier
> with trends -- like virtual address activity with multiple threads)
>   

I understood that mmap() is not scalable, however look  at
http://lkml.org/lkml/2008/9/12/185, even fopen/fdopen does
an (anonymous) mmap internally.
That does not affect performance that much, since the overhead of a
file-backed mmap + pagefaults is higher.
Rewriting libclamav to not use mmap() would take a significant amount of
time, however  I will try to avoid using mmap()
in new code (and prefer pread/read).

Also clamd is a CPU bound application [given fast enough disks ;)] and
having to wait for mmap_sem prevents it from doing "real work".
Most of the time it reads files from /tmp, that should either be in the
page cache, or (in my case) they are always in RAM (I use tmpfs).

So mmaping, and reading from these files does not involve disk I/O, yet
threads working with /tmp files still need to wait
for disk I/O to complete because it has to wait on mmap_sem (held by
another thread).

>
>   
>> ...............................................................................................................................................................................................
>>
>>                          &sem->wait_lock:        122700        
>> 126641           0.42          77.94      125372.37       
>> 1779026        7368894           0.27        1099.42     3085559.16
>>                          ---------------
>>                          &sem->wait_lock           5943         
>> [<ffffffff8043a768>] __up_write+0x28/0x170
>>                          &sem->wait_lock           8615         
>> [<ffffffff805ce3ac>] __down_write_nested+0x1c/0xc0
>>                          &sem->wait_lock          13568         
>> [<ffffffff8043a5a0>] __down_write_trylock+0x20/0x60
>>                          &sem->wait_lock          49377         
>> [<ffffffff8043a600>] __down_read_trylock+0x20/0x60
>>                          ---------------
>>                          &sem->wait_lock           8097         
>> [<ffffffff8043a5a0>] __down_write_trylock+0x20/0x60
>>                          &sem->wait_lock          31540         
>> [<ffffffff8043a768>] __up_write+0x28/0x170
>>                          &sem->wait_lock           5501         
>> [<ffffffff805ce3ac>] __down_write_nested+0x1c/0xc0
>>                          &sem->wait_lock          33342         
>> [<ffffffff8043a600>] __down_read_trylock+0x20/0x60
>>
>>     
>
> Interesting. I have some (ancient) patches to make rwsems more scalable
> under heavy load by reducing contention on this lock. They should really
> have been merged... Not sure how much it would help, but if you're
> interested in testing, I could dust them off.

Sure, I can test patches (preferably against 2.6.28-rc6-tip ).

Best regards,
--Edwin
