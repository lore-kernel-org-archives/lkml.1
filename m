Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYCYW7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYCYW7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYCYW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:59:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbYCYW7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:59:33 -0400
Message-ID: <47E983D2.8030103@redhat.com>
Date: Tue, 25 Mar 2008 18:59:30 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "J.C. Pizarro" <jcpiza@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>	 <47E97566.5020003@redhat.com> <998d0e4a0803251550k24111763ve5cfe48dc5b0fc84@mail.gmail.com>
In-Reply-To: <998d0e4a0803251550k24111763ve5cfe48dc5b0fc84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Pizarro wrote:
> On 2008/3/25, Chris Snook <csnook@redhat.com> wrote:
>> J.C. Pizarro wrote:
>>  > $ cat /proc/cpuinfo
>>  > processor       : 0
>>  > vendor_id       : AuthenticAMD
>>  > cpu family      : 15
>>  > model           : 47
>>  > model name      : AMD Athlon(tm) 64 Processor 3200+
>>  > ...
>>  > cache size      : 512 KB
>>  > ...
>>  >
>>  > The cache size is currently misinformed. It's not the real size because
>>  > it's 64+64+512 KiB = 640 KiB, not 512 KB.
>>  >
>>  > How can i know what hw-caches use the processors?
>>  > The current kernel doesn't know well what hw-caches uses.
>>  >
>>  > The good proposal is by example (the data below are not real):
>>  > * In old AMD Athlon64:
>>  >
>>  > cache L1        : 64 KiB I + 64 KiB D, 64 B line, direct way, ...
>>  > cache L2        : 512 KiB I+D-shared, exclusive, 128 associative way, ...
>>  > cache L3        : none
>>  >
>>  > * In Intel Core Duo:
>>  > processor       : 0
>>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>>  > cache L2        : 2048 KiB Cores-shared, inclusive, 128 associative way, ...
>>  > cache L3        : none
>>  >
>>  > processor       : 1
>>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>>  > cache L2        : 2048 KiB cores-shared, inclusive, 128 associative way, ...
>>  > cache L3        : none
>>  >
>>  > * In Quad:
>>  > processor       : 0
>>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>>  > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
>>  > associative way, ...
>>  > cache L3        : none
>>  > ...
>>  > processor       : 3
>>  > cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
>>  > cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
>>  > associative way, ...
>>  > cache L3        : none
>>  >
>>  > It above is an example, put your symbols to /proc/cpuinfo in a
>>  > convenient manner.
>>  >
>>  >    Good bye ;)
>>
>>
>> I think you want this:
>>
>>  /sys/devices/system/cpu/cpu0/cache
> 
> Thanks, but there is not easier manner to print the properties of hw-caches
> unless printing recursively this tree /sys/devices/system/cpu/cpu[0-9]+/cache/
> that they are only numbers without symbolic fields.

Then use dmidecode.  It's all in one place, and everyone expects it to be far 
too long to read at a glance.

> There is not manner to know the speed (in MHz) of the L1, L2 and L3 caches.
> 
>>  /proc/cpuinfo is intended to give a general summary of certain properties of the
>>  processor that tend to be particularly interesting, and present them all in one
>>  place.  It is not intended to expose everything the kernel knows about every
>>  processor on the system.
> 
> /proc/cpuinfo doesn't give a general summary because it gives superfluous info.
> 
> I think that it's better to refactorize /proc/cpuinfo still more.
> 
> (
>    ... fields common to all present processors known by the kernel ....
>        [ to warn if the values are differents between cores ]
> )
> (
>    ... specific fields for each processor ... by example:
> 
> processor       : 0
> cpu MHz         : 2000.000     # normal clocked
> bogomips        : 4010.63
> processor       : 1
> cpu MHz         : 500.000     # underclocked for energy saving ...
> bogomips        : 1003.20
> 
> )
> 
> I think that all the cores are equals in almost non-weird systems.
> With this scheme, the cpuinfo's reports will be smaller than before,
> and non-superfluous.

It's precisely that sort of weirdness we want to be able to catch at a glance. 
These days, there is no possible way to make /proc/cpuinfo satisfy everyone and 
still be compact.  That's why we mostly leave it alone and put all the fun stuff 
in /sys, which is much better suited to the ever-increasing complexity of modern 
hardware.

If we refactor /proc/cpuinfo, it will break all sorts of things that use that 
information to get an idea of what the system is running on.  All of the info is 
there in /sys now anyway, so if you want a different format, write your own 
userspace tool to scrape it together.  There's absolutely no need to implement 
this purely cosmetic data formatting in the kernel.

-- Chris
