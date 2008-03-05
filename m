Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYCEOzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYCEOzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYCEOzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:55:13 -0500
Received: from smtp2e.orange.fr ([80.12.242.113]:39769 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbYCEOzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:55:12 -0500
X-ME-UUID: 20080305145510193.2F26370000BE@mwinf2e23.orange.fr
Message-ID: <47CEB449.6060204@cosmosbay.com>
Date: Wed, 05 Mar 2008 15:55:05 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, dmantipov@yandex.ru,
       linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
References: <1389671204703217@webmail34.yandex.ru> <20080305.000014.245410231.davem@davemloft.net> <47CE6C41.3090303@cosmosbay.com> <200803060120.38032.nickpiggin@yahoo.com.au>
In-Reply-To: <200803060120.38032.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> On Wednesday 05 March 2008 20:47, Eric Dumazet wrote:
>   
>> David Miller a écrit :
>>     
>>> From: Antipov Dmitry <dmantipov@yandex.ru>
>>> Date: Wed, 05 Mar 2008 10:46:57 +0300
>>>
>>>       
>>>> Despite of this obvious fact, recently I've tried to compare pipe
>>>> performance on Linux and FreeBSD systems. Unfortunately, Linux
>>>> results are poor - ~2x slower than FreeBSD. The detailed description
>>>> of the test case, preparation, environment and results are located
>>>> at http://213.148.29.37/PipeBench, and everyone are pleased to look
>>>> at, reproduce, criticize, etc.
>>>>         
>>> FreeBSD does page flipping into the pipe receiver, so rerun your test
>>> case but have either the sender or the receiver make changes to
>>> their memory buffer in between the read/write calls.
>>>
>>> FreeBSD's scheme is only good for benchmarks, rather then real life.
>>>       
>> page flipping might explain differences for big transferts, but note the
>> difference with small buffers (64, 128, 256, 512 bytes)
>>
>> I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120
>> machine, and we can notice that four cpus are used (but only two threads
>> are running on this benchmark)
>>     
>
> One thing to try is pinning both processes on the same CPU. This
> may be what the FreeBSD scheduler is preferring to do, and it ends
> up being really a tradeoff that helps some workloads and hurts
> others. With a very unscientific test with an old kernel, the
> pipe.c test gets anywhere from about 1.5 to 3 times faster when
> running it as taskset 1 ./pipe
>
>
>   
>> # opreport -l /boot/vmlinux-2.6.24.2 |head -n 30
>> CPU: Core 2, speed 1866.8 MHz (estimated)
>> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
>> unit mask of 0x00 (Unhalted core cycles) count 100000
>> samples  %        symbol name
>> 52137     9.3521  kunmap_atomic
>>     
>
> I wonder if FreeBSD doesn't allocate their pipe buffers from kernel
> addressable memory. We could do this to eliminate the cost completely
> on highmem systems (whether it is a good idea I don't know, normally
> you'd actually do a bit of work between reading or writing from a
> pipe...)
>
>
>   
>> 50983     9.1451  mwait_idle_with_hints
>> 50448     9.0492  system_call
>> 49727     8.9198  task_rq_lock
>> 24531     4.4003  pipe_read
>> 19820     3.5552  pipe_write
>> 16176     2.9016  dnotify_parent
>>     
>
> Just say no to dnotify.
>
>
>   
>> 15455     2.7723  file_update_time
>>     
>
> Dumb question: anyone know why pipe.c calls this?
>
>   
Because pipe writer calls write() syscall -> file_update_time() in kernel
while pipe reader calls read() syscall -> touch_atime() in kernel

inode i_mtime, i_ctime, i_atime and i_mutex fields share same cache 
line, so nothing we can improve to avoid cache line ping pong.





