Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXDQHGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXDQHGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXDQHGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:06:41 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:52293 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXDQHGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:06:40 -0400
Message-ID: <462471F6.6020800@cosmosbay.com>
Date: Tue, 17 Apr 2007 09:06:30 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Brian D. McGrew" <brian@visionpro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Memory Allocation
References: <14CFC56C96D8554AA0B8969DB825FEA002C99168@chicken.machinevisionproducts.com>
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA002C99168@chicken.machinevisionproducts.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 17 Apr 2007 09:06:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian D. McGrew a écrit :
> Good evening gents!
> 
> I need some help in allocating memory and understanding how the system
> allocates memory with physical versus virtual page tables.  Please
> consider the following snippet of code.  Please, no wisecracks about bad
> code; it was written in 30 seconds in haste :-)
> 
> #include <iostream>
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <pthread.h>
> 
> const static u_long kMaxSize = (2048 * 2048 * 256);
> 
> void *msg(void *ptr);
> static u_long threads_done	= 0;
> 
> int
> main(int argc, char *argv[])
> {
>      pthread_t thread1;
>      pthread_t thread2;
> 
>      char *message1 = "Thread 1";
>      char *message2 = "Thread 2";
> 
>      int iret1;
>      int iret2;
> 
>      iret1 = pthread_create(&thread1, NULL, msg, (void *) message1);
>      iret2 = pthread_create(&thread2, NULL, msg, (void *) message2);
> 
>     //pthread_join(thread1, NULL);
>     //pthread_join(thread2, NULL); 
> 
>     while (threads_done < 2) {
> 	std::cout << "Threads complete: " << threads_done << std::endl;
> 	sleep(3);
>     }
> 
>     exit(0);
> }
> 
> void *
> msg(void *ptr)
> {
>     char *message = (char *) ptr;
> 
>     //
>     // Equal to 1 bank per thread of 256 each 4MP image buffers.  2GB.
>     //
>     char *buffer = new char[kMaxSize];
> 
>     u_long max = kMaxSize;
> 
>     //
>     // Init each buffer to 'something'.
>     //
>     for (u_long inx = 0; inx < max; inx++) {
> 	if (inx % 102400000 == 0) {
> 	    std::cout << message << ": Index: " << inx << std::endl;
> 	}
> 
>     	buffer[inx] = inx;
>     }
> 
>     free(buffer);
>     threads_done++;
> }
> 
> My test machine is a Dell Precision 490 with dual 5140 processors and
> 3GB of RAM.  If I reduced kMaxSize to (2048 * 2048 * 236) is works.
> However, I need to allocate an array of char that is (2048 * 2048 * 256)
> and maybe even as large at (2048 * 2048 * 512).
> 
> Obviously I have enough physical memory in the box to do this.  However,
> I suspect that I'm running out of page table entries.  Please, correct
> me if I'm wrong; but if I allocate (2048 * 2048 * 236) it work.  When I
> increment to 256 or 512 it fails and it is my suspicion that I just
> don't have enough more in kernel memory to allocate this much memory in
> user space.  
> 
> Because of a piece of 3rd party hardware, I'm forced to run the kernel
> in the 4GB memory model.  What I need to be able to do is allocate an
> array of char (2048 * 2048 * (up to 512)) in user space *** AND *** I
> need the addresses that I get back to be contiguous, that's just the way
> my 3rd party hardware works.
> 
> I'm inclined to believe that this in not specifically a Linux problem
> but maybe an architecture problem???  But maybe there is some kind of
> work around in the kernel for it???  I'd find it hard to believe that
> I'm the first one that ever needed to use this much memory.
> 
> I ran this same code on two difference Macs.  One of them a Powerbook G4
> with 4GB of RAM and it was successful.  The other was a Macbook Pro with
> 4GB of RAM and it failed.  Both running OS 10.4.9.  And of course it
> runs just lovely on my Sun workstation with Solaris.  Thus, I'm thinking
> it's an Intel/X86 issue!
> 
> How the heck to I get past this problem in Linux on the X86 plateform???
> 
> Thanks,

Hi Brian

Add this line at the begining of your msg() function :

char cmd[128];
sprintf(cmd, "cat /proc/%d/maps", getpid());
system(cmd);

You'll see :

08048000-08049000 r-xp 00000000 08:07 23         /tmp/test1
08049000-0804a000 rw-p 00000000 08:07 23         /tmp/test1
0804a000-0806b000 rw-p 0804a000 00:00 0
40000000-40015000 r-xp 00000000 08:02 31309      /lib/ld-2.3.6.so
40015000-40017000 rw-p 00014000 08:02 31309      /lib/ld-2.3.6.so
40017000-40019000 rw-p 40017000 00:00 0
4001d000-4002b000 r-xp 00000000 08:02 31349      /lib/tls/libpthread-2.3.6.so
4002b000-4002d000 rw-p 0000d000 08:02 31349      /lib/tls/libpthread-2.3.6.so
4002d000-4002f000 rw-p 4002d000 00:00 0
4002f000-40109000 r-xp 00000000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
40109000-4010c000 r--p 000d9000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
4010c000-4010e000 rw-p 000dc000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
4010e000-40114000 rw-p 4010e000 00:00 0
40114000-40137000 r-xp 00000000 08:02 31339      /lib/tls/libm-2.3.6.so
40137000-40139000 rw-p 00022000 08:02 31339      /lib/tls/libm-2.3.6.so
40139000-40143000 r-xp 00000000 08:02 31871      /lib/libgcc_s.so.1
40143000-40144000 rw-p 00009000 08:02 31871      /lib/libgcc_s.so.1
40144000-4026c000 r-xp 00000000 08:02 31335      /lib/tls/libc-2.3.6.so
4026c000-40271000 r--p 00127000 08:02 31335      /lib/tls/libc-2.3.6.so
40271000-40273000 rw-p 0012c000 08:02 31335      /lib/tls/libc-2.3.6.so
40273000-40278000 rw-p 40273000 00:00 0
40278000-40279000 ---p 40278000 00:00 0
40279000-40a78000 rw-p 40279000 00:00 0
bffff000-c0000000 rw-p bffff000 00:00 0
ffffe000-fffff000 ---p 00000000 00:00 0
Thread 1: Index: 0
08048000-08049000 r-xp 00000000 08:07 23         /tmp/test1
08049000-0804a000 rw-p 00000000 08:07 23         /tmp/test1
0804a000-0806b000 rw-p 0804a000 00:00 0
40000000-40015000 r-xp 00000000 08:02 31309      /lib/ld-2.3.6.so
40015000-40017000 rw-p 00014000 08:02 31309      /lib/ld-2.3.6.so
40017000-40019000 rw-p 40017000 00:00 0
4001d000-4002b000 r-xp 00000000 08:02 31349      /lib/tls/libpthread-2.3.6.so
4002b000-4002d000 rw-p 0000d000 08:02 31349      /lib/tls/libpthread-2.3.6.so
4002d000-4002f000 rw-p 4002d000 00:00 0
4002f000-40109000 r-xp 00000000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
40109000-4010c000 r--p 000d9000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
4010c000-4010e000 rw-p 000dc000 08:05 128152     /usr/lib/libstdc++.so.6.0.8
4010e000-40114000 rw-p 4010e000 00:00 0
40114000-40137000 r-xp 00000000 08:02 31339      /lib/tls/libm-2.3.6.so
40137000-40139000 rw-p 00022000 08:02 31339      /lib/tls/libm-2.3.6.so
40139000-40143000 r-xp 00000000 08:02 31871      /lib/libgcc_s.so.1
40143000-40144000 rw-p 00009000 08:02 31871      /lib/libgcc_s.so.1
40144000-4026c000 r-xp 00000000 08:02 31335      /lib/tls/libc-2.3.6.so
4026c000-40271000 r--p 00127000 08:02 31335      /lib/tls/libc-2.3.6.so
40271000-40273000 rw-p 0012c000 08:02 31335      /lib/tls/libc-2.3.6.so
40273000-40278000 rw-p 40273000 00:00 0
40278000-40279000 ---p 40278000 00:00 0
40279000-80a7a000 rw-p 40279000 00:00 0
80a7a000-80a7b000 ---p 80a7a000 00:00 0
80a7b000-8127a000 rw-p 80a7b000 00:00 0
bffff000-c0000000 rw-p bffff000 00:00 0
ffffe000-fffff000 ---p 00000000 00:00 0
terminate called after throwing an instance of 'std::bad_alloc'
   what():  St9bad_alloc
Aborted



The problem is about the dynamic libraries and thread stacks, that might be 
mapped in 0x40000000 zone. So your program cannot allocate a 2GB zone, because 
available zone for user program is 3GB, from 0x00000000 to 0xC0000000, but not 
contiguous.


Now if you compile your program with static libraries, it's a litle bit better :

g++ -o test1 -static test1.c -lpthread
# ./test1
Threads complete: 0
08048000-08137000 r-xp 00000000 08:07 23         /tmp/test1
08137000-08139000 rw-p 000ee000 08:07 23         /tmp/test1
08139000-081a4000 rw-p 08139000 00:00 0
40000000-40001000 ---p 40000000 00:00 0
40001000-40800000 rwxp 40001000 00:00 0
40800000-40801000 ---p 40800000 00:00 0
40801000-41000000 rwxp 40801000 00:00 0
41000000-41001000 rw-p 41000000 00:00 0
bffff000-c0000000 rw-p bffff000 00:00 0
ffffe000-fffff000 ---p 00000000 00:00 0
Thread 1: Index: 0
08048000-08137000 r-xp 00000000 08:07 23         /tmp/test1
08137000-08139000 rw-p 000ee000 08:07 23         /tmp/test1
08139000-081a4000 rw-p 08139000 00:00 0
40000000-40001000 ---p 40000000 00:00 0
40001000-40800000 rwxp 40001000 00:00 0
40800000-40801000 ---p 40800000 00:00 0
40801000-41000000 rwxp 40801000 00:00 0
41000000-81002000 rw-p 41000000 00:00 0
bffff000-c0000000 rw-p bffff000 00:00 0
ffffe000-fffff000 ---p 00000000 00:00 0
terminate called after throwing an instance of 'std::bad_alloc'
   what():  St9bad_alloc
Killed

Still some mappings (thread stacks) are bitting you.

If you want to use so much memory on a 32bit kernel, you might tune your 
program to :

- Avoid dynamic libraries
- allocate thread stacks yourself, so that they wont be in the midle of your 
address space (using malloc() zone, in the 08139000-08xxxxxx range)
...
- Use a smarter kernel that can map in the other way (from the top to the 
down) (check /proc/sys/vm/legacy_va_layout )

Of course, switching to a 64bit kernel just make this problem not existant :)
