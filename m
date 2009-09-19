Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZISSoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZISSoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZISSoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:44:06 -0400
Received: from nbd.name ([88.198.39.176]:45375 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZISSoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:44:05 -0400
Message-ID: <4AB52667.6020608@openwrt.org>
Date: Sat, 19 Sep 2009 20:43:51 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <200909081645.18505.mb@bu3sch.de> <20090918112454.GE9930@elte.hu> <4AB39D3A.3000204@openwrt.org> <20090919180124.GK5366@elte.hu>
In-Reply-To: <20090919180124.GK5366@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Felix Fietkau <nbd@openwrt.org> wrote:
> 
>> Ingo Molnar wrote:
>> > Well that's a really memory constrained MIPS device with like 16 MB of 
>> > RAM or so? So having effects from small things like changing details in 
>> > a kernel image is entirely plausible.
>>
>> Normally changing small details doesn't have much of an effect. While 
>> 16 MB is indeed not that much, we do usually have around 8 MB free 
>> with a full user space running. Changes to other subsystems normally 
>> produce consistent and repeatable differences that seem entirely 
>> unrelated to memory use, so any measurable difference related to 
>> scheduler changes is unlikely to be related to the low amount of RAM. 
>> By the way, we do frequently also test the same software with devices 
>> that have more RAM, e.g. 32 or 64 MB and it usually behaves in a very 
>> similar way.
> 
> Well, Michael Buesch posted vmstat results, and they show what i have 
> found with my x86 simulated reproducer as well (these are Michael's 
> numbers):
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  1  0	   0  15892   1684   5868    0    0     0     0  268    6 31 69  0  0
>  1  0	   0  15892   1684   5868    0    0     0     0  266    2 34 66  0  0
>  1  0	   0  15892   1684   5868    0    0     0     0  266    6 33 67  0  0
>  1  0	   0  15892   1684   5868    0    0     0     0  267    4 37 63  0  0
>  1  0	   0  15892   1684   5868    0    0     0     0  267    6 34 66  0  0
> 
> on average 4 context switches _per second_. The scheduler is not a 
> factor on this box.
> 
> Furthermore:
> 
>  | I'm currently unable to test BFS, because the device throws strange 
>  | flash errors. Maybe the flash is broken :(
> 
> So maybe those flash errors somehow impacted the measurements as well?
I did some tests with BFS v230 vs CFS on Linux 2.6.30 on a different
MIPS device (Atheros AR2317) with 180 MHz and 16 MB RAM. When running
iperf tests, I consistently get the following results when running the
transfer from the device to my laptop:

CFS: [  5]  0.0-60.0 sec    107 MBytes  15.0 Mbits/sec
BFS: [  5]  0.0-60.0 sec    119 MBytes  16.6 Mbits/sec

The transfer speed from my laptop to the device are the same with BFS
and CFS. I repeated the tests a few times just to be sure, and I will
check vmstat later.
The difference here cannot be flash related, as I ran a kernel image
with the whole userland contained in initramfs. No on-flash filesystem
was mounted or accessed.

- Felix
