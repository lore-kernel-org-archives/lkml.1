Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbXDQCbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbXDQCbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXDQCbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:31:35 -0400
Received: from chicken.visionpro.com ([63.91.95.13]:14518 "EHLO
	chicken.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754298AbXDQCbf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:31:35 -0400
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2007 22:31:33 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Memory Allocation
Date: Mon, 16 Apr 2007 19:17:06 -0700
Message-ID: <14CFC56C96D8554AA0B8969DB825FEA002C99168@chicken.machinevisionproducts.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Memory Allocation
Thread-Index: AceAln4V9lfW4sMuSHynuk7d563sRA==
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>, "Brian D. McGrew" <brian@visionpro.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening gents!

I need some help in allocating memory and understanding how the system
allocates memory with physical versus virtual page tables.  Please
consider the following snippet of code.  Please, no wisecracks about bad
code; it was written in 30 seconds in haste :-)

#include <iostream>

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

const static u_long kMaxSize = (2048 * 2048 * 256);

void *msg(void *ptr);
static u_long threads_done	= 0;

int
main(int argc, char *argv[])
{
     pthread_t thread1;
     pthread_t thread2;

     char *message1 = "Thread 1";
     char *message2 = "Thread 2";

     int iret1;
     int iret2;

     iret1 = pthread_create(&thread1, NULL, msg, (void *) message1);
     iret2 = pthread_create(&thread2, NULL, msg, (void *) message2);

    //pthread_join(thread1, NULL);
    //pthread_join(thread2, NULL); 

    while (threads_done < 2) {
	std::cout << "Threads complete: " << threads_done << std::endl;
	sleep(3);
    }

    exit(0);
}

void *
msg(void *ptr)
{
    char *message = (char *) ptr;

    //
    // Equal to 1 bank per thread of 256 each 4MP image buffers.  2GB.
    //
    char *buffer = new char[kMaxSize];

    u_long max = kMaxSize;

    //
    // Init each buffer to 'something'.
    //
    for (u_long inx = 0; inx < max; inx++) {
	if (inx % 102400000 == 0) {
	    std::cout << message << ": Index: " << inx << std::endl;
	}

    	buffer[inx] = inx;
    }

    free(buffer);
    threads_done++;
}

My test machine is a Dell Precision 490 with dual 5140 processors and
3GB of RAM.  If I reduced kMaxSize to (2048 * 2048 * 236) is works.
However, I need to allocate an array of char that is (2048 * 2048 * 256)
and maybe even as large at (2048 * 2048 * 512).

Obviously I have enough physical memory in the box to do this.  However,
I suspect that I'm running out of page table entries.  Please, correct
me if I'm wrong; but if I allocate (2048 * 2048 * 236) it work.  When I
increment to 256 or 512 it fails and it is my suspicion that I just
don't have enough more in kernel memory to allocate this much memory in
user space.  

Because of a piece of 3rd party hardware, I'm forced to run the kernel
in the 4GB memory model.  What I need to be able to do is allocate an
array of char (2048 * 2048 * (up to 512)) in user space *** AND *** I
need the addresses that I get back to be contiguous, that's just the way
my 3rd party hardware works.

I'm inclined to believe that this in not specifically a Linux problem
but maybe an architecture problem???  But maybe there is some kind of
work around in the kernel for it???  I'd find it hard to believe that
I'm the first one that ever needed to use this much memory.

I ran this same code on two difference Macs.  One of them a Powerbook G4
with 4GB of RAM and it was successful.  The other was a Macbook Pro with
4GB of RAM and it failed.  Both running OS 10.4.9.  And of course it
runs just lovely on my Sun workstation with Solaris.  Thus, I'm thinking
it's an Intel/X86 issue!

How the heck to I get past this problem in Linux on the X86 plateform???

Thanks,

-brian
brian@visionpro.com
