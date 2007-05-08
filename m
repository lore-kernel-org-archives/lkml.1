Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbXEHHfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbXEHHfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 03:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934497AbXEHHfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 03:35:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20450 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492AbXEHHfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 03:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=eZ9tuAOOm7726PI6lKPHwyQxuyLMuzb6md2G0V4dX+WoJiPIPtQ9ptnrqnGxGlbpGjXR2LcQ4Sq8j+E1C21+13EyJk2HbZSVKhTTeA1YhvWcMDfmLAjEWoDFDKfeM9c/qfybalZ+oxum1MSJ5iv1mORaT0fTwR9OhQV0d1ZWsR4=
Date: Tue, 8 May 2007 09:34:49 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Johannes Stezenbach <js@linuxtv.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Esben Nielsen <nielsen.esben@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070507183931.GB3472@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0705080931460.10409@frodo.shire>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705071159530.14011@frodo.shire>
 <alpine.LFD.0.98.0705070921390.3802@woody.linux-foundation.org>
 <20070507183931.GB3472@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 May 2007, Johannes Stezenbach wrote:

> On Mon, May 07, 2007, Linus Torvalds wrote:
>> On Mon, 7 May 2007, Esben Nielsen wrote:
>>>
>>> What is (long)(a-b) ? I have tried to look it up in the C99 standeard but I
>>> can't find it. Maybe it is in the referred LIA-1 standeard, which I can't find
>>> with google.
>
> C99 defines unsigned overflow semantics, but it doesn't say anything
> about signed overflow, thus it's undefined -- and you have a hard
> time finding it out.
>
> However, I have no clue *why* it's undefined and not
> implementation defined. Does someone know?
>
>> I don't worry about non-2's-complement machines (they don't exist, and
>> likely won't exist in the future either).
>
> I think DSPs can do saturated arithmetics (clamp to min/max
> values instead of wrap around). Not that it matters for Linux...
>
>> So I worry about compilers rewriting my code.
>
> gcc has -fwrapv and -ftrapv to change signed integer overflow
> behaviour.
>
> One baffling example where gcc rewrites code is when
> conditionals depend on signed integer overflow:
>
> $ cat xx.c
> #include <assert.h>
>
> int foo(int a)
> {
> 	assert(a + 100 > a);
> 	return a;
> }
>
> int bar(int a)
> {
> 	if (a + 100 > a)
> 		a += 100;
> 	return a;
> }
> $ gcc -Wall -Wextra -fomit-frame-pointer -c xx.c
> $ objdump -dr xx.o
>
> xx.o:     file format elf32-i386
>
> Disassembly of section .text:
>
> 00000000 <foo>:
>   0:   8b 44 24 04             mov    0x4(%esp),%eax
>   4:   c3                      ret
>
> 00000005 <bar>:
>   5:   83 44 24 04 64          addl   $0x64,0x4(%esp)
>   a:   8b 44 24 04             mov    0x4(%esp),%eax
>   e:   c3                      ret
>
>
> The assert and the condition were just dropped
> by gcc -- without any warning.
>
> gcc-4.2 will add -fstrict-overflow and -Wstrict-overflow.
> http://gcc.gnu.org/gcc-4.2/changes.html
>
>
> Johannes
>

This is contrary to C99 standeard annex H2.2 
(http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf):

"An implementation that defines signed integer types as also being modulo need
not detect integer overflow, in which case, only integer divide-by-zero need
be detected."

So if it doesn't properly defines wrapping it has to detect integer 
overflow, right?

gcc does niether with that optimization :-(

Esben
