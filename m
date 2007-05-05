Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXEEIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXEEIbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXEEIbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 04:31:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbXEEIbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 04:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=G3aTXZD/1WTec0HCR5kgGXhPE0m/h6bdfDyLuqi5mSkdEeNQWb/FGMcALMyai6fO1hPhHi6J0Qu6COKEmwHOIincYcMUPiT5gS+lMCSVN4uW1LAnc+37/Jt2L++heXxmV0gsnIJ9I68IjAIj+3QcIEM0s3pmbcCVW6XYdqOwClo=
Date: Sat, 5 May 2007 10:31:25 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Ingo Molnar <mingo@elte.hu>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070502111742.GA18132@elte.hu>
Message-ID: <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 May 2007, Ingo Molnar wrote:

>
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>> The problem is with comparing a s64 values with (s64)ULONG_MAX, which
>> evaluates to -1. Then we check if exec_delta64 and fair_delta64 are
>> greater than (s64)ULONG_MAX (-1), if so we assign (s64)ULONG_MAX to
>> the respective values.
>
> ah, indeed ...
>
>> The fix is to compare these values against (s64)LONG_MAX and assign
>> (s64)LONG_MAX to exec_delta64 and fair_delta64 if they are greater
>> than (s64)LONG_MAX.
>>
>> Tested on PowerPC, the regression is gone, tasks are load balanced as
>> they were in v7.
>
> thanks, applied!
>
> 	Ingo

I have been wondering why you use usigned for timers anyway. It is also 
like that in hrtimers. Why not use signed and avoid (almost) all worries 
about wrap around issues. The trick is that when all
   a < b
is be replaced by
   a - b < 0
the code will work on all 2-complement machines even if the (signed!) 
integers a and b wrap around.

In both the hrtimer and CFS patch 32 bit timers could be used internally 
on 32 bit architectures to avoid expensive 64 bit integer calculations.
The only thing is: timeouts can not be bigger than 2^31 in the chosen 
units.

I have successfully coded a (much more primitive) hrtimer system for 
another OS on both ARM and PPC using the above trick in my former job. 
On both I used the machine's internal clock as the internal 
representation of time and I only scaled to a struct timespec in the user 
interface.

Esben
