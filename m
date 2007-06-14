Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbXFNNJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbXFNNJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXFNNJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:09:23 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:35865 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751347AbXFNNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:09:17 -0400
Message-ID: <46713B0F.2000805@aitel.hist.no>
Date: Thu, 14 Jun 2007 14:56:47 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr> <466FF154.7030905@aitel.hist.no> <46710DAE.7020604@free.fr>
In-Reply-To: <46710DAE.7020604@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:
>>
>> My guess:
>> Something needs memory but finds there is none to be had
>> oom-killer is invoked and targets myapp.
>> myapp takes some time to die. Particularly, the memory it uses
>> isn't freed up instantly. In the meantime something else
>> needs memory and find none. (Another packet received?)
>
> Possibly. In fact, myapp receives a 40 Mbit/s stream.
>
>> The oom-killer is invoked again, this time it targets syslogd.
>
> I went hunting, and found a memory leak in our syslogd. Doh!
Good for you! :-) If this is standard syslogd, please send a patch
to the maintainer.
>
>> And so on.  The kernel do many things in parallel, running out
>> of memory in a multitasking system therefore is a complicated business.
>> Especially when process killing takes some time.
>
> I didn't mention that there is no swap on this system.
It doesn't matter that much.  With swap, you get a slowdown
as memory is used up, and eventually oom-kill when swap too runs out.
With swap, you run at full speed until you hit the wall.

Swapping is nice on a desktop machine, because:
* Light swapping is not a problem, so you can do work that
   would otherwise be impossible
* Heavy swapping is noticeable, so you close some apps in a
   civilized manner, instead of having the oom-killer
   surprising you.

This may or may not apply to your RT setup. 

>> Note that you can turn off memory overcommit, your leaky app
>> should then get a memory allocation error instead of
>> triggering the oom-killer.
>
> Are you referring to these /proc/sys/vm entries?
>
> # cat /proc/sys/vm/overcommit_memory
> 0
> # cat /proc/sys/vm/overcommit_ratio
> 50
>
> Are you suggesting I set overcommit_memory to 2?
Yes.  You can never trust the oom-killer to do the "right thing"
in all circumstances - as you discovered. It can probably be improved on,
but there will be corner cases anyway.
When you use overcommit, the oom-killer is the alternative to having
the machine halt when it can't keep the promise of more memory.
> The manual states:
>
> /proc/sys/vm/overcommit_memory
>
> This file contains the kernel virtual memory accounting mode.
> Values are:
>   0: heuristic overcommit (this is the default)
>   1: always overcommit, never check
>   2: always check, never overcommit
> In mode 0, calls of mmap(2) with MAP_NORESERVE set are not checked, 
> and the default check is very weak, leading to the risk of getting a 
> process "OOM-killed". Under Linux 2.4 any non-zero value implies mode 
> 1. In mode 2 (available since Linux 2.6), the total virtual address 
> space on the system is limited to (SS + RAM*(r/100)), where SS is the 
> size of the swap space, and RAM is the size of the physical memory, 
> and r is the contents of the file /proc/sys/vm/overcommit_ratio.
>
> In my case, SS=0 and RAM=256MB.
>
> If I understand correctly, if I set ratio to 50, then processes can 
> only address 128MB. I'd be, in effect, reserving 128MB for the kernel, 
> right?
>
I think so. You might want to modify "r" depending on how much your kernel
actually uses.

Note that not overcommitting tends to run out of memory very fast,
because of the way fork() is used. When a program forks,
it becomes two processes that initially shares all memory.
That means they don't use more memory after the fork().

But the memory will be spent as soon as one process changes
its memory, for the change is not supposed to be seen in
the other process. Without overcommit then, the kernel will
allow the fork() only if there is enough memory left to
copy the entire process being forked.  This is often
unnecessary in practice - if you have several shells running then
they share lots of memory that they never actually will need
to duplicate.  Overcommit is therefore popular, it lets
you run much more software as long as it behaves this way.

Another solution: Set memory_overcommit to 2. And get some swap.
The swap will never actually be _used_, unless you get so many
allocations that the oom-killer would have stepped in without swap.

You can then monitor swapping.  If anything is written to swap,
then you're using too much memory and should investigate.
For production, this is usually better than cleaning up after
the oom-killer busted some random processes.


Helge Hafting
