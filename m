Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZIPCtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZIPCtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZIPCtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:49:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:45995 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZIPCtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:49:35 -0400
Date: Tue, 15 Sep 2009 19:49:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: Tricks to speed up kernel builds
In-Reply-To: <200909152035.50814.tfjellstrom@shaw.ca>
Message-ID: <alpine.DEB.2.00.0909151938050.1361@asgard.lang.hm>
References: <4AAF4ECD.5010401@pardus.org.tr> <200909152035.50814.tfjellstrom@shaw.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Thomas Fjellstrom wrote:

> On Tue September 15 2009, Ozan ?a?layan wrote:
>> Hi,
>>
>> I'd googled a lot about the $subject but couldn't find any detailed
>> guide about it. So, the followings are what I understand from what I've
>> found:
>>
>> 1. Build inside a tmpfs to avoid I/O bottlenecks,

if you have the ram the system will use it to cache the data, avoiding the 
I/O bottlenecks.

the first time you compile you have to wait for the source to be read into 
ram, but you would have to copy the source to the tmpfs anyway

>> 2. Use ccache,
>> 3. Switch governor to performance if supported,
>> 4. Pass -j to gnu make to parallelize the build process,
>> 5. Don't build debug symbols a.k.a set CONFIG_DEBUG_INFO=n
>> 6. There are a bunch of sched patches in tip which apparently improves
>> things during kbuild
>> 7. Distribute the work into the local network using icecream, distcc.
>>
>> For the -j part, how many jobs should we pass to it? I've seen people
>> passing
>>
>> - NR_of_cores+1
>> - NR_of_cores x 2 (I think that this is useful when there's 2 threads of
>> execution per core like HyperThreading?)

this is not due to hyperthreading.

if you do not have the data cached in ram from a prior build, individual 
compile threads will stall waiting for the source to be read from disk. by 
having more threads than you have cores you can have some stalled waiting 
for data while others run and use the cpu cycles.

exactly how much benfit you get, and where things taper off is very 
dependant on your system (how fast is your I/O, how effectivly does it 
handle parallel requests)

it's probably higher than NR_of_cores +1, but if you have a 8-core or 16 
core box it's probably less than NR_of_cores x 2 (unless you have a 
storage subsystem that works well in parallel, say something like a 8 or 
16 disk raid array)

>> - 64, 128, etc. regardless of the number of cores (Is it really useful
>> regardless of the CPU)

this will overload your system with lots of processes competing for the 
CPU. it's a good stress test of the system, but inefficiant in processor 
utilization due to the fact that each time a new thread takes the CPU the 
cache has been wiped out by other threads.

>> The curious question is *what build times can you get* with your typical
>> systems using your speedup tricks (quad core, dual core, etc.) ? What
>> are other tricks that I can use to even more speed up the build?
>>
>> Do you really use icecream/distcc on your daily test builds?

most people don't, some people do. some people have systems that can build 
the kernel in a handful of seconds (I think the record was 7.5 seconds 
several years ago) if it is in the memory disk cache and don't need to. 
others build on architecures that don't have systems that fast and use 
distcc all the time to get acceptable speed

since many virtualization options will not let a guest OS use more than 
one real CPU at a time, people who build in virtual systems commonly use 
this sort of thing to use all the real cores on their system (same as the 
-j option above)

Linus has been heard to complain that it takes longer to boot a system 
with a new kernel than to compile it (this was on an enterprise-class 
system that took a long time for the bios/raid/etc initialization)


>> How about nicing/ionicing make on an idle system? Will it make any
>> difference?

if there is nothing to compete with the kernel build, these don't help.

David Lang

> I've only done a few compiles recently, and I only really use icecream and
> make -jX to speed up compile times.
>
> I have a 4 node icecc cluster, three quad cores (one limited to 2 cores), and
> one dual core (limited to a single core), which gives 11 total cores I can
> distribute to, and I usually pass: make -j12
>
> Any higher and I don't really see any speedups, any lower, same difference.
>
> My last kernel compile (2.6.31-git4) took about 9 minutes.
>
>> Thanks a lot
>> Ozan Caglayan
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>
