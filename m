Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbXFNJnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbXFNJnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXFNJnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:43:14 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36819 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXFNJnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:43:13 -0400
Message-ID: <46710DAE.7020604@free.fr>
Date: Thu, 14 Jun 2007 11:43:10 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr> <466FF154.7030905@aitel.hist.no>
In-Reply-To: <466FF154.7030905@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:

> John Sigler wrote:
>
>> Andrea Arcangeli wrote:
>>
>>> On Wed, Jun 13, 2007 at 10:49:29AM +0200, John Sigler wrote:
>>>
>>>> Question 2: how can I tell which process or kernel thread was 
>>>> hogging most of the RAM when the oom-killer kicked in?
>>>
>>> Theoretically the one that was killed first but not for sure in
>>> current mainline hence see below.
>>
>> If I read the logs correctly, oom-killer is "invoked" three times 
>> before it effectively kills a process. Then oom-killer kills myapp, 
>> syslogd, and boa, in that order. Why didn't oom-killer kill anything 
>> the first three times?
>
> My guess:
> Something needs memory but finds there is none to be had
> oom-killer is invoked and targets myapp.
> myapp takes some time to die. Particularly, the memory it uses
> isn't freed up instantly. In the meantime something else
> needs memory and find none. (Another packet received?)

Possibly. In fact, myapp receives a 40 Mbit/s stream.

> The oom-killer is invoked again, this time it targets syslogd.

I went hunting, and found a memory leak in our syslogd. Doh!

> And so on.  The kernel do many things in parallel, running out
> of memory in a multitasking system therefore is a complicated business.
> Especially when process killing takes some time.

I didn't mention that there is no swap on this system.

> Note that you can turn off memory overcommit, your leaky app
> should then get a memory allocation error instead of
> triggering the oom-killer.

Are you referring to these /proc/sys/vm entries?

# cat /proc/sys/vm/overcommit_memory
0
# cat /proc/sys/vm/overcommit_ratio
50

Are you suggesting I set overcommit_memory to 2?

The manual states:

/proc/sys/vm/overcommit_memory

This file contains the kernel virtual memory accounting mode.
Values are:
   0: heuristic overcommit (this is the default)
   1: always overcommit, never check
   2: always check, never overcommit
In mode 0, calls of mmap(2) with MAP_NORESERVE set are not checked, and 
the default check is very weak, leading to the risk of getting a process 
"OOM-killed". Under Linux 2.4 any non-zero value implies mode 1. In mode 
2 (available since Linux 2.6), the total virtual address space on the 
system is limited to (SS + RAM*(r/100)), where SS is the size of the 
swap space, and RAM is the size of the physical memory, and r is the 
contents of the file /proc/sys/vm/overcommit_ratio.

In my case, SS=0 and RAM=256MB.

If I understand correctly, if I set ratio to 50, then processes can only 
address 128MB. I'd be, in effect, reserving 128MB for the kernel, right?

Are there other entries in /proc/sys/vm I should be playing with? :-)

/proc/sys/vm/block_dump
0
/proc/sys/vm/dirty_background_ratio
10
/proc/sys/vm/dirty_expire_centisecs
3000
/proc/sys/vm/dirty_ratio
40
/proc/sys/vm/dirty_writeback_centisecs
500
/proc/sys/vm/drop_caches
0
/proc/sys/vm/laptop_mode
0
/proc/sys/vm/legacy_va_layout
0
/proc/sys/vm/lowmem_reserve_ratio
256
/proc/sys/vm/max_map_count
65536
/proc/sys/vm/min_free_kbytes
2039
/proc/sys/vm/nr_pdflush_threads
2
/proc/sys/vm/overcommit_memory
0
/proc/sys/vm/overcommit_ratio
50
/proc/sys/vm/page-cluster
3
/proc/sys/vm/panic_on_oom
0
/proc/sys/vm/percpu_pagelist_fraction
0
/proc/sys/vm/swappiness
60
/proc/sys/vm/vdso_enabled
1
/proc/sys/vm/vfs_cache_pressure
100

Regards.
