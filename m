Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYEJUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYEJUpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbYEJUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:45:36 -0400
Received: from gw.goop.org ([64.81.55.164]:43620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYEJUpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:45:34 -0400
Message-ID: <4826095F.3070501@goop.org>
Date: Sat, 10 May 2008 21:45:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org> <4825D8B4.3060600@goop.org> <20080510174841.GC31954@one.firstfloor.org>
In-Reply-To: <20080510174841.GC31954@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080208060907080409070609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080208060907080409070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
>> It tracks changes to the stack pointer, and any memory below it is 
>> considered uninitialized.  But, yes, if you mean that if you use the 
>>     
>
> But it does not invalidate anything below the stack pointer as soon
> as it changes right ?
>   

Yeah, as soon as the stack pointer changes, everything below it is 
invalidated (except if the stack-pointer change was actually determined 
to be a stack switch).

>> variable (or slot) once in a function, then again later, it will still 
>> be considered initialized.  But that's no different from any other memory.
>>     
>
> What I meant is e.g. 
>
> 	f1();
> 	f2();
>
> both f1 and f2 use the same stack memory, but f2 uses it uninitialized,
> then I think valgrind would still think it is initialized in f2 from the
> execution of f1. It would only detect such things in f1 (assuming there
> were no other users of the stack before that)
>   

No, it won't.  If the stack pointer goes up then down between f1 and f2, 
then f2 will get fresh values.

The big thing Valgrind hasn't traditionally helped with is overruns of 
on-stack arrays.  You may be thinking of that.

> In theory it could throw away all stack related uninitizedness on each
> SP change, but that would be likely prohibitively expensive and also
> it might be hard to know the exact boundaries of the stack.
>   

No, its not all that expensive compared the overall cost of valgrind and 
the amount of diagnostic power it provides.  Determining stack 
boundaries has always been a bit fraught.  Typically a stack switch has 
been determined heuristically by looking for a "large" change in stack 
pointer, but there's a callback to specifically mark a range of memory 
as a stack, so that movements into and out of a stack can be determined 
as a switch (added specifically to deal with small densely packed stacks 
in uml).

> BTW on running a test program here it doesn't seem to detect any uninitialized
> stack frames here with 3.2.3. Test program is http://halobates.de/t10.c 
> (should be compiled without optimization) 
>   

Hm, I'd expect it to.  Oh, your test program doesn't use the value.  
Valgrind doesn't complain about uninitialized values unless they 
actually affect execution (ie, a conditional depends on one, you use it 
as an address for a dereference, or pass it to a syscall).

The attached version emits errors as I'd expect:

$ valgrind t10
==30474== Memcheck, a memory error detector.
==30474== Copyright (C) 2002-2007, and GNU GPL'd, by Julian Seward et al.
==30474== Using LibVEX rev 1804, a library for dynamic binary translation.
==30474== Copyright (C) 2004-2007, and GNU GPL'd, by OpenWorks LLP.
==30474== Using valgrind-3.3.0, a dynamic binary instrumentation framework.
==30474== Copyright (C) 2000-2007, and GNU GPL'd, by Julian Seward et al.
==30474== For more details, rerun with: -v
==30474== 
f1 set y to 1
==30474== Conditional jump or move depends on uninitialised value(s)
==30474==    at 0x8048420: test (t10.c:22)
==30474==    by 0x8048451: main (t10.c:29)
==30474== 
==30474== Use of uninitialised value of size 4
==30474==    at 0xB5C5B6: _itoa_word (in /lib/libc-2.8.so)
==30474==    by 0xB5FF90: vfprintf (in /lib/libc-2.8.so)
==30474==    by 0xB6769F: printf (in /lib/libc-2.8.so)
==30474==    by 0x8048436: test (t10.c:23)
==30474==    by 0x8048451: main (t10.c:29)
==30474== 
==30474== Conditional jump or move depends on uninitialised value(s)
==30474==    at 0xB5C5BE: _itoa_word (in /lib/libc-2.8.so)
==30474==    by 0xB5FF90: vfprintf (in /lib/libc-2.8.so)
==30474==    by 0xB6769F: printf (in /lib/libc-2.8.so)
==30474==    by 0x8048436: test (t10.c:23)
==30474==    by 0x8048451: main (t10.c:29)
==30474== 
==30474== Conditional jump or move depends on uninitialised value(s)
==30474==    at 0xB5EADE: vfprintf (in /lib/libc-2.8.so)
==30474==    by 0xB6769F: printf (in /lib/libc-2.8.so)
==30474==    by 0x8048436: test (t10.c:23)
==30474==    by 0x8048451: main (t10.c:29)
==30474== 
==30474== Conditional jump or move depends on uninitialised value(s)
==30474==    at 0xB60828: vfprintf (in /lib/libc-2.8.so)
==30474==    by 0xB6769F: printf (in /lib/libc-2.8.so)
==30474==    by 0x8048436: test (t10.c:23)
==30474==    by 0x8048451: main (t10.c:29)
==30474== 
==30474== Conditional jump or move depends on uninitialised value(s)
==30474==    at 0xB5EB88: vfprintf (in /lib/libc-2.8.so)
==30474==    by 0xB6769F: printf (in /lib/libc-2.8.so)
==30474==    by 0x8048436: test (t10.c:23)
==30474==    by 0x8048451: main (t10.c:29)
f2 set y to 13123572
==30474== 
==30474== ERROR SUMMARY: 20 errors from 6 contexts (suppressed: 13 from 1)
==30474== malloc/free: in use at exit: 0 bytes in 0 blocks.
==30474== malloc/free: 0 allocs, 0 frees, 0 bytes allocated.
==30474== For counts of detected errors, rerun with: -v
==30474== All heap blocks were freed -- no leaks are possible.



    J

--------------080208060907080409070609
Content-Type: text/x-csrc;
 name="t10.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="t10.c"

#include <stdio.h>
int y;

void f1(void)
{	
	int x = 1;
	y = x;
}

void f2(void)
{	
	int x;
	y = x;
}

void test()
{
	f1();
	if (y)
		printf("f1 set y to %d\n", y);
	f2();
	if (y)
		printf("f2 set y to %d\n", y);
}

main()
{
	char buf[16 * 1024];
	test();
}

--------------080208060907080409070609--
