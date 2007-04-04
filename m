Return-Path: <linux-kernel-owner+w=401wt.eu-S966311AbXDDFmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311AbXDDFmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966314AbXDDFmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:42:32 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:50324 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966312AbXDDFmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:42:31 -0400
Message-ID: <46133A8B.50203@cosmosbay.com>
Date: Wed, 04 Apr 2007 07:41:31 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <4612DCC6.7000504@cosmosbay.com> <46130BC8.9050905@yahoo.com.au>
In-Reply-To: <46130BC8.9050905@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 04 Apr 2007 07:41:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> Eric Dumazet wrote:
>>
>> I do think such workloads might benefit from a vma_cache not shared by 
>> all threads but private to each thread. A sequence could invalidate 
>> the cache(s).
>>
>> ie instead of a mm->mmap_cache, having a mm->sequence, and each thread 
>> having a current->mmap_cache and current->mm_sequence
> 
> I have a patchset to do exactly this, btw.

Could you repost it please ?

I guess a seqlock could avoid some cache line bouncing on mmap_sem for some 
kind of operations. I wonder if it could speed up do_page_fault() ???

> 
> Anyway what is the status of the private futex work. I don't think that
> is very intrusive or complicated, so it should get merged ASAP (so then
> at least we have the interface there).
> 

It seems nobody but you and me cared.

BTW I am surprised of Ulrich bugging linux on MADV_KERNEL_CAN_DROP, while 
glibc still does :

FILE *F = fopen("/etc/passwd", "r");
fget(line, sizeof(line), F);
fclose(F);

->

open("/etc/passwd", O_RDONLY)           = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1505, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 
0x2b67097f0000
read(3, "root:x:0:0:root:/root:/bin/bash\n"..., 4096) = 1505
close(3)                                = 0
munmap(0x2b67097f0000, 4096)            = 0


using mmap()/munmap() to allocate one 4096 bytes area is certainly overkill. 
mmap_sem is apparently the thing we must hit forever.

Maybe nobody but me still uses fopen()/fclose() after all ?

