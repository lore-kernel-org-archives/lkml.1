Return-Path: <linux-kernel-owner+w=401wt.eu-S2992485AbXDCXBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992485AbXDCXBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992483AbXDCXBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:01:54 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48789 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992485AbXDCXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:01:53 -0400
Message-ID: <4612DCC6.7000504@cosmosbay.com>
Date: Wed, 04 Apr 2007 01:01:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org>
In-Reply-To: <20070403144948.fe8eede6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 01:01:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Tue, 3 Apr 2007 16:29:37 -0400
> Jakub Jelinek <jakub@redhat.com> wrote:
> 
>> On Tue, Apr 03, 2007 at 01:17:09PM -0700, Ulrich Drepper wrote:
>>> Andrew Morton wrote:
>>>> Ulrich, could you suggest a little test app which would demonstrate this
>>>> behaviour?
>>> It's not really reliably possible to demonstrate this with a small
>>> program using malloc.  You'd need something like this mysql test case
>>> which Rik said is not hard to run by yourself.
>>>
>>> If somebody adds a kernel interface I can easily produce a glibc patch
>>> so that the test can be run in the new environment.
>>>
>>> But it's of course easy enough to simulate the specific problem in a
>>> micro benchmark.  If you want that let me know.
>> I think something like following testcase which simulates what free
>> and malloc do when trimming/growing a non-main arena.
>>
>> My guess is that all the page zeroing is pretty expensive as well and
>> takes significant time, but I haven't profiled it.
>>
>> #include <pthread.h>
>> #include <stdlib.h>
>> #include <sys/mman.h>
>> #include <unistd.h>
>>
>> void *
>> tf (void *arg)
>> {
>>   (void) arg;
>>   size_t ps = sysconf (_SC_PAGE_SIZE);
>>   void *p = mmap (NULL, 128 * ps, PROT_READ | PROT_WRITE,
>>                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>   if (p == MAP_FAILED)
>>     exit (1);
>>   int i;
>>   for (i = 0; i < 100000; i++)
>>     {
>>       /* Pretend to use the buffer.  */
>>       char *q, *r = (char *) p + 128 * ps;
>>       size_t s;
>>       for (q = (char *) p; q < r; q += ps)
>>         *q = 1;
>>       for (s = 0, q = (char *) p; q < r; q += ps)
>>         s += *q;
>>       /* Free it.  Replace this mmap with
>>          madvise (p, 128 * ps, MADV_THROWAWAY) when implemented.  */
>>       if (mmap (p, 128 * ps, PROT_NONE,
>>                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) != p)
>>         exit (2);
>>       /* And immediately malloc again.  This would then be deleted.  */
>>       if (mprotect (p, 128 * ps, PROT_READ | PROT_WRITE))
>>         exit (3);
>>     }
>>   return NULL;
>> }
>>
>> int
>> main (void)
>> {
>>   pthread_t th[32];
>>   int i;
>>   for (i = 0; i < 32; i++)
>>     if (pthread_create (&th[i], NULL, tf, NULL))
>>       exit (4);
>>   for (i = 0; i < 32; i++)
>>     pthread_join (th[i], NULL);
>>   return 0;
>> }
>>
> 
> whee.  135,000 context switches/sec on a slow 2-way.  mmap_sem, most
> likely.  That is ungood.
> 
> Did anyone monitor the context switch rate with the mysql test?
> 
> Interestingly, your test app (with s/100000/1000) runs to completion in 13
> seocnd on the slow 2-way.  On a fast 8-way, it took 52 seconds and
> sustained 40,000 context switches/sec.  That's a bit unexpected.
> 
> Both machines show ~8% idle time, too :(

Yes... then add to this some futex work, and you get the picture.

I do think such workloads might benefit from a vma_cache not shared by all 
threads but private to each thread. A sequence could invalidate the cache(s).

ie instead of a mm->mmap_cache, having a mm->sequence, and each thread having 
a current->mmap_cache and current->mm_sequence

