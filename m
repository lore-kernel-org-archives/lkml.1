Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYADLv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYADLv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYADLvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:51:49 -0500
Received: from hu-out-0506.google.com ([72.14.214.228]:53505 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYADLvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pZBbMahOo7efAS/p5uR3Dbefw83LGaEb2kZZvBQyjh+kOtpCfAT9jnMAoGjZQqzzPlMVlFliTxwV6xOPaYjohVPy/oLc0rfCjjGzwt9NTZ6/g0Pk0vvm7AHCnxfSoeJV67rla0Q4/iNVtFyGwuUwgcqB9CarntETmWkuGHYfkYs=
Message-ID: <477E1DC3.5020803@gmail.com>
Date: Fri, 04 Jan 2008 13:51:31 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20071230)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Improve hackbench
References: <1199426786.3298.64.camel@ymzhang> <20080104081043.GA23046@elte.hu>
In-Reply-To: <20080104081043.GA23046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
>
>   
>> hackbench is to test Linux scheduler. The original program is at 
>> http://devresources.linux-foundation.org/craiger/hackbench/src/hackbench.c 
>> Based on this multi-process version, a nice person created a 
>> multi-thread version. Pls. see 
>> http://www.bullopensource.org/posix/pi-futex/hackbench_pth.c
>>     
>
> great. I've uploaded your unified & improved version to:
>
>   http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
>
> (i made some small changes - two warning fixes on gcc 4.2 and a default 
> of 10 groups when hackbench is called without parameters, plus a 
> printout.)
>   

On x86-64 there's a bug [*], that causes hackbench to segfault when
compiled with optimizations:
in reap_worker():
    int status;
...
    pthread_join(id, (void **)(void *)&status);

That is not correct, sizeof(void*) > sizeof(int) on x86-64.
Something gets overwritten on the stack, I tried with gcc
-fstack-protector, but it doesn't detect it !?
After applying the patch, it no longer segfaults.

This patch fixes it:
--- hackbench.c 2008-01-04 10:08:26.000000000 +0200
+++ ../hackbench.c      2008-01-04 13:45:22.000000000 +0200
@@ -241,8 +241,10 @@
                wait(&status);
                if (!WIFEXITED(status))
                        exit(1);
-       } else
-               pthread_join(id, (void **)(void *)&status);
+       } else {
+               void* status;
+               pthread_join(id, (void **)&status);
+       }
 }

 /* One group of senders and receivers */

----------------


I also notice that the thread version is slower, than process version:

$ ./hackbench 5 thread
Running with 5*40 (== 200) tasks.
Time: 0.413
$ ./hackbench 5 thread
Running with 5*40 (== 200) tasks.
Time: 0.423
$ ./hackbench 5 thread 20
Running with 5*40 (== 200) tasks.
Time: 0.093
$ ./hackbench 5 thread 200
Running with 5*40 (== 200) tasks.
Time: 0.827
$ ./hackbench 5 thread 2000
Running with 5*40 (== 200) tasks.
Time: 8.409
$ ./hackbench 5 process 2000
Running with 5*40 (== 200) tasks.
Time: 7.669
$ ./hackbench -pipe 5  process 2000
Running with 5*40 (== 200) tasks.
Time: 3.416
$ ./hackbench -pipe 5  thread 2000
Running with 5*40 (== 200) tasks.
Time: 4.320

[*]
$ uname -a
Linux lightspeed2 2.6.24-rc6-ge697789d #3 Wed Jan 2 11:15:05 EET 2008
x86_64 GNU/Linux
$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v
--enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr
--enable-shared --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --enable-nls
--with-gxx-include-dir=/usr/include/c++/4.2 --program-suffix=-4.2
--enable-clocale=gnu --enable-libstdcxx-debug --enable-mpfr
--enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4)
$ wget http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
--13:40:53--  http://redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
           => `hackbench.c'
Resolving redhat.com... 209.132.177.50
Connecting to redhat.com|209.132.177.50|:80... connected.
HTTP request sent, awaiting response... 302 Found
Location: http://www.redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
[following]
--13:40:54--  http://www.redhat.com/~mingo/cfs-scheduler/tools/hackbench.c
           => `hackbench.c'
Resolving www.redhat.com... 209.132.177.50
Connecting to www.redhat.com|209.132.177.50|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
[following]
--13:40:54--  http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
           => `hackbench.c'
Resolving people.redhat.com... 66.187.233.237
Connecting to people.redhat.com|66.187.233.237|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 8,455 (8.3K) [text/plain]

100%[====================================================================================================================>]
8,455         --.--K/s

13:40:55 (61.93 KB/s) - `hackbench.c' saved [8455/8455]

$ gcc  -O2 -g -Wall -o hackbench hackbench.c -lpthread
hackbench.c:32:66: warning: missing terminating ' character
$ ./hackbench 1 thread
Running with 1*40 (== 40) tasks.
Segmentation fault

$ valgrind --trace-children=yes ./hackbench 1 thread
==27332== Memcheck, a memory error detector.
==27332== Copyright (C) 2002-2007, and GNU GPL'd, by Julian Seward et al.
==27332== Using LibVEX rev 1804, a library for dynamic binary translation.
==27332== Copyright (C) 2004-2007, and GNU GPL'd, by OpenWorks LLP.
==27332== Using valgrind-3.3.0-Debian, a dynamic binary instrumentation
framework.
==27332== Copyright (C) 2000-2007, and GNU GPL'd, by Julian Seward et al.
==27332== For more details, rerun with: -v
==27332==
Running with 1*40 (== 40) tasks.
==27332== Thread 2:
==27332== Syscall param write(buf) points to uninitialised byte(s)
==27332==    at 0x4C1854B: (within /usr/lib/debug/libpthread-2.7.so)
==27332==    by 0x400C34: ready (hackbench.c:138)
==27332==    by 0x400C97: receiver (hackbench.c:182)
==27332==    by 0x4C113F6: start_thread (pthread_create.c:297)
==27332==    by 0x4EFD91C: clone (in /usr/lib/debug/libc-2.7.so)
==27332==  Address 0x558a09f is on thread 2's stack
==27332==
==27332== Thread 22:
==27332== Syscall param write(buf) points to uninitialised byte(s)
==27332==    at 0x4C1854B: (within /usr/lib/debug/libpthread-2.7.so)
==27332==    by 0x400C34: ready (hackbench.c:138)
==27332==    by 0x400D33: sender (hackbench.c:152)
==27332==    by 0x4C113F6: start_thread (pthread_create.c:297)
==27332==    by 0x4EFD91C: clone (in /usr/lib/debug/libc-2.7.so)
==27332==  Address 0x55da07f is on thread 22's stack
==27332==
==27332== Thread 40:
==27332== Syscall param write(buf) points to uninitialised byte(s)
==27332==    at 0x4C1854B: (within /usr/lib/debug/libpthread-2.7.so)
==27332==    by 0x400D6E: sender (hackbench.c:160)
==27332==    by 0x4C113F6: start_thread (pthread_create.c:297)
==27332==    by 0x4EFD91C: clone (in /usr/lib/debug/libc-2.7.so)
==27332==  Address 0x56220a0 is on thread 40's stack
==27332==
==27332== Thread 1:
==27332== Jump to the invalid address stated on the next line
==27332==    at 0x0: ???
==27332==    by 0x518702F: ???
==27332==    by 0xFFFFFFFF: ???
==27332==    by 0x518702F: ???
==27332==    by 0x2800000000: ???
==27332==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
==27332==
==27332== Process terminating with default action of signal 11 (SIGSEGV)
==27332==  Bad permissions for mapped region at address 0x0
==27332==    at 0x0: ???
==27332==    by 0x518702F: ???
==27332==    by 0xFFFFFFFF: ???
==27332==    by 0x518702F: ???
==27332==    by 0x2800000000: ???
==27332==
==27332== ERROR SUMMARY: 40041 errors from 4 contexts (suppressed: 8 from 1)
==27332== malloc/free: in use at exit: 11,420 bytes in 61 blocks.
==27332== malloc/free: 62 allocs, 1 frees, 11,692 bytes allocated.
==27332== For counts of detected errors, rerun with: -v
==27332== searching for pointers to 61 not-freed blocks.
==27332== checked 560,688 bytes.
==27332==
==27332== LEAK SUMMARY:
==27332==    definitely lost: 20 bytes in 1 blocks.
==27332==      possibly lost: 10,608 bytes in 39 blocks.
==27332==    still reachable: 792 bytes in 21 blocks.
==27332==         suppressed: 0 bytes in 0 blocks.
==27332== Rerun with --leak-check=full to see details of leaked memory.
Segmentation fault



Best regards,
--Edwin
