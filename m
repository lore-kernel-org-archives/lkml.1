Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbXKOGeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbXKOGeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXKOGaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:30:17 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49228 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbXKOGaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:30:15 -0500
Message-ID: <473BE75B.9070701@cosmosbay.com>
Date: Thu, 15 Nov 2007 07:29:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Russell Leighton <russ@elegant-software.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
In-Reply-To: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 15 Nov 2007 07:29:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell Leighton a écrit :
> 
> Bryan Cantrill of Sun (ala DTrace) has a notion of perfect code:
> 
>     http://blogs.sun.com/bmc/entry/on_i_dreaming_in_code
> 
> He also has some examples (from bottom comment section of above):
> 
>>
>>
>> Can you list a small number of examples of "software perfection"?
>>
>> Posted by Russell Leighton on November 14, 2007 at 04:02 AM PST #
>>
>> Russell,
>>
>> My canonical small example of perfection in Solaris would be Jeff 
>> Bonwick's mod-by-a-billion code in hrt2ts():
>>
>> http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/os/timers.c#875 
>>
>>
>> Solaris of course has lots of bigger, more complicated examples. Now 
>> on the one hand, one wants to refrain from pointing to thousands of 
>> lines of code and saying that there are no bugs therein, but on the 
>> other, there are many subsystems that have been in place and in heavy 
>> use for years without defect or modification. At the risk of being 
>> egocentric, the cyclic subsystem (which is executed at least 100 times 
>> per second on every Solaris system) had its last substantial fix over 
>> six years ago, and its last fix of any flavor over three years ago:
>>
>> http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/os/cyclic.c 
>>
>>
>> Modesty (and the lack, of course, of a proof of its correctness) 
>> prevents me from calling the cyclic subsystem perfect -- but such as 
>> unknown defects remain, there are damn few of them, and we can say 
>> that they must be a result of highly usual (or at least, heretofore 
>> unseen) circumstances.
>>
>> A non-Solaris example -- and one that I've been known to use as the 
>> canonical example of the persistence of software -- is Super Mario 
>> Kart. This is a game that was developed (to its completion) fifteen 
>> years ago for the Super Nintendo console. Source code, to the best of 
>> my knowledge, is not publicly available and may indeed be lost -- but 
>> the binaries persist and (if my coworkers are any indication) remain 
>> in active use. Given the longevity of, say, Homer's Odyssey, there is 
>> reason to believe that Super Mario Kart will survive in perpetuity -- 
>> that thousands of years from now, twenty-somethings somewhere will be 
>> using the software exactly as it is used today. Is this perfection? 
>> Perhaps not -- but it also might not be discernible from perfection...
>>
>> Posted by Bryan Cantrill on November 14, 2007 at 07:51 AM PST #
> 
> Does Linux have any such examples true software perfection?
> 

I dont know, (what a strange idea is it anyway ?) but reading two Solaris 
functions just gave me the example of non true software perfection.

http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/os/timers.c#1106

I would say this code was OK 10 years ago.

Now that a processor (say an Opteron in 64 bits mode, used on SUN hardware), 
can perform a multiply in few cycles, ts2hrt() could use a normal multiply and 
an addition.

Processors are improving, compilers are improving, memory sizes are 
increasing, source code (and algorithms) should be changed accordingly.

(gcc for example already knows the reciprocal division trick and so can 
compile this :

hrt2ts_div(hrtime_t hrt, timestruc_t *tsp)
{
     tsp->tv_nsec = do_div(hrt, NANOSEC);
     tsp->tv_sec = hrt;
}

to :

         movq    %rdi, %rdx
         movabsq $19342813113834067, %rax
         shrq    $9, %rdx
         mulq    %rdx
         shrq    $11, %rdx
         imulq   $1000000000, %rdx, %rax
         movq    %rdx, (%rsi)
         subq    %rax, %rdi
         movl    %edi, 8(%rsi)

while

hrtime_t
ts2hrt(const timestruc_t *tsp)
{
return tsp->tv_sec * NANOSEC + tsp->tv_nsec;
}

can be inlined as it is trivial (and much faster than Solaris version)

         movq    (%rdi), %rdx
         mov     8(%rdi), %eax
         imulq   $1000000000, %rdx, %rdx
         addq    %rdx, %rax

