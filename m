Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYKZT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYKZT6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKZT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:58:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3055 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKZT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:58:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=MZW6RvReuKeGBcfyFL33vk6e6xbhfI9pkDXla6jHumHxmQYMO/JnA5Z1TtH2Z5ny7
	06gPgt5sPs/3jwTJh4UmQ==
Message-ID: <492DAA24.8040100@google.com>
Date: Wed, 26 Nov 2008 11:57:24 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Ying Han <yinghan@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de>
In-Reply-To: <20081126123246.GB23649@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Nov 25, 2008 at 10:42:47AM -0800, Ying Han wrote:
>>>> The patch flags current->flags to PF_FAULT_MAYRETRY as identify that
>>>> the caller can tolerate the retry in the filemap_fault call patch.
>>>>
>>>> Benchmark is done by mmap in huge file and spaw 64 thread each
>>>> faulting in pages in reverse order, the the result shows 8%
>>>> porformance hit with the patch.
>>> I suspect we also want to see the cases where this change helps?
>> i am working on more benchmark to show performance improvement.
> 
> Can't you share the actual improvement you see inside Google?
> 
> Google must be doing something funky with threads, because both
> this patch and their new malloc allocator apparently were due to
> mmap_sem contention problems, right?

One of the big improvements we see with this patch is the ability to 
read out files in /proc/pid much faster.  Consider the following events:

- an application has a high count of threads sleeping with 
read_lock(mmap_sem) held in the fault path (on the order of hundreds).
- one of the threads in the application then blocks in 
write_lock(mmap_sem) in the mmap()/munmap() paths
- now our monitoring software tries to read some of the /proc/pid files 
and blocks behind the waiting writer due to the fairness of the rwsems. 
  This basically has to wait for all faults ahead of the reader to 
terminate (and let go of the reader lock) and then the writer to have a 
go at mmap_sem.   This can take an extremely long time.

This patch helps a lot in this case as it keeps the writer from waiting 
behind all the waiting readers, so it executes much faster.

> 
> That was before the kernel and glibc got together to fix the stupid
> mmap_sem problem in malloc (shown up in that FreeBSD MySQL thread);
> and before private futexes. I would be interested to know if Google
> still has problems that require this patch...
> 

I'm not very familiar with the 'malloc' problem in glibc.  Was this just 
overhead in heap growth/shrinkage causing problems?
