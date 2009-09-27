Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZI0XXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZI0XXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 19:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZI0XXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 19:23:44 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:33970 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZI0XXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 19:23:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEANuKv0pMROOX/2dsb2JhbACBUNBWhB4FgVhz
Date: Sun, 27 Sep 2009 19:23:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090927232345.GA5831@Krystal>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090924212013.d27226c4.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:08:17 up 40 days,  9:57,  4 users,  load average: 0.38, 0.41,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 24 Sep 2009 09:26:28 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Immediate values are used as read mostly variables that are rarely updated. They
> > use code patching to modify the values inscribed in the instruction stream. It
> > provides a way to save precious cache lines that would otherwise have to be used
> > by these variables.
> 
> What a hare-brained concept.
> 

Hi Andrew,

Improving performance by specializing the implementation has been
studied thoroughly by many in the past, especially for JIT compilers.
What I am proposing here is merely a very specific use of the concept,
applied to read-often variables.

> > * Why should this be merged *
> > 
> > It improves performances on heavy memory I/O workloads.
> > 
> > An interesting result shows the potential this infrastructure has by
> > showing the slowdown a simple system call such as getppid() suffers when it is
> > used under heavy user-space cache trashing:
> > 
> > Random walk L1 and L2 trashing surrounding a getppid() call:
> > (note: in this test, do_syscal_trace was taken at each system call, see
> > Documentation/immediate.txt in these patches for details)
> > - No memory pressure :   getppid() takes  1573 cycles
> > - With memory pressure : getppid() takes 15589 cycles
> 
> Our ideas of what constitutes an "interesting result" differ.
> 
> Do you have any data which indicates that this thing is of any real
> benefit to anyone for anything?

Yep. See the benchmarks I just ran below.

Immediate Values Benchmarks

Kernel 2.6.31-tip
8-core Xeon, 2.0Ghz, E5405
gcc version 4.3.2 (Debian 4.3.2-1.1) 

Test workload: build the Linux kernel tree, cache-hot, make -j10

Executive result summary:

In these tests, each system call has an added workload, which is to read a fixed
number of integers from randomly chosen cache lines within an array and perform
a branch. The implementation is added to ptrace.c. The baseline is an unmodified
kernel.

* Baseline:				sys	0m57.63s

* 4096 integer reads, random locations	sys	2m21.781s
* 4096 integer reads, immediate values	sys	1m44.695s

* 128 integer reads, random locations	sys	0m59.348s
* 128 integer reads, immediate values	sys	0m58.640s

* 32 integer reads, random locations	sys	0m58.68s
* 32 integer reads, immediate values	sys	0m57.60s

These numbers show that by turning read-often data accesses into immediate
values, we can speed up the kernel.

Binary size results:

* 4096 integer reads, random locations
  text     data     bss     dec     hex filename
  66079     648  262156  328883   504b3 arch/x86/kernel/ptrace.o

* 4096 integer reads, immediate values
   text	   data	    bss	    dec	    hex	filename
  66079	  74412	 262156	 402647	  624d7	arch/x86/kernel/ptrace.o

As we notice, the size of text is the same, same for bss, but the data size
increases with immediate values. The section headers confirms that this extra
data is put in the __imv section, which is only accessed when immediate value
updates are performed.

So the tradeoff is: immediate values use more cache-cold space to increase
speed.

Therefore, if we can turn a significant amount of fast-path read-often variables
into immediate values, this should lead to a performance gain. Also,
given we can expect the fastpath cache-line footprint to grow with the
next kernel releases (this has been a trend I've seen a lot of people
complaining about), immediate values should help minimizing this by
removing the d-cache hit from such read-often variables, leaving a
i-cache hit within a mostly sequential instruction stream.

A quick look at the vmlinux section headers:

vmlinux:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
 13 .data.read_mostly 00002df0  ffffffff80859440  0000000000859440  00859440  2**6
                  CONTENTS, ALLOC, LOAD, DATA

Shows that we have about 11.48kB of read mostly data in the kernel image
which could be turned into immediate values. This is without counting
the modules. If only a portion of this data is not only read mostly, but
also read often, then we will see a clear performance improvement.

Thanks,

Mathieu


Detailed test results follow.
----------------------------------------

* Baseline:

# size of kernel original ptrace.o

   text	   data	    bss	    dec	    hex	filename
  12863	    648	      8	  13519	   34cf	arch/x86/kernel/ptrace.o

# time make -j10

real	1m25.358s
user	9m7.506s
sys	0m57.856s

real	1m21.580s
user	9m7.362s
sys	0m57.212s

real	1m21.361s
user	9m6.358s
sys	0m57.824s


* 4096 cache lines read per system call (random cache lines)
  (CONFIG_IMMEDIATE=n)

# size of modified ptrace.o

  text	   data	    bss	    dec	    hex	filename
  66079	    648	 262156	 328883	  504b3	arch/x86/kernel/ptrace.o

# section headers

arch/x86/kernel/ptrace.o:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000f4e8  0000000000000000  0000000000000000  00000040  2**4
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         000000a8  0000000000000000  0000000000000000  0000f540  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  2 .bss          0004000c  0000000000000000  0000000000000000  0000f600  2**5
                  ALLOC
  3 .rodata       00000988  0000000000000000  0000000000000000  0000f600  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  4 .fixup        0000005b  0000000000000000  0000000000000000  0000ff88  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  5 __ex_table    00000090  0000000000000000  0000000000000000  0000ffe8  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  6 .smp_locks    00000028  0000000000000000  0000000000000000  00010078  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  7 .rodata.str1.8 000001f2  0000000000000000  0000000000000000  000100a0  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  8 .rodata.str1.1 00000097  0000000000000000  0000000000000000  00010292  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 __tracepoints 00000080  0000000000000000  0000000000000000  00010340  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
 10 _ftrace_events 00000160  0000000000000000  0000000000000000  000103c0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
 11 __tracepoints_strings 00000013  0000000000000000  0000000000000000  00010520  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 12 .comment      0000001f  0000000000000000  0000000000000000  00010533  2**0
                  CONTENTS, READONLY
 13 .note.GNU-stack 00000000  0000000000000000  0000000000000000  00010552  2**0
                  CONTENTS, READONLY

# pattern

     820:       83 3d 00 00 00 00 01    cmpl   $0x1,0x0(%rip)        # 827 <test_pollute_cache+0x7>
     827:       0f 84 cb cf 00 00       je     d7f8 <test_pollute_cache+0xcfd8>

# time make -j10

real	1m36.075s
user	9m15.163s
sys	2m21.781s


* 4096 imv read per system call
  (CONFIG_IMMEDIATE=y)

# size of modified ptrace.o

   text	   data	    bss	    dec	    hex	filename
  66079	  74412	 262156	 402647	  624d7	arch/x86/kernel/ptrace.o

    (note: data is larger due to __imv table, which is used only for updates)

# section headers

arch/x86/kernel/ptrace.o:     file format elf64-x86-64

Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         0000f4e8  0000000000000000  0000000000000000  00000040  2**4
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         000000a8  0000000000000000  0000000000000000  0000f540  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  2 .bss          0004000c  0000000000000000  0000000000000000  0000f600  2**5
                  ALLOC
  3 .rodata       00000988  0000000000000000  0000000000000000  0000f600  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  4 .fixup        0000005b  0000000000000000  0000000000000000  0000ff88  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  5 __ex_table    00000090  0000000000000000  0000000000000000  0000ffe8  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  6 .smp_locks    00000028  0000000000000000  0000000000000000  00010078  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
  7 __discard     00005004  0000000000000000  0000000000000000  000100a0  2**0
                  CONTENTS, READONLY
  8 __imv         00012024  0000000000000000  0000000000000000  000150a4  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
  9 .rodata.str1.8 000001f2  0000000000000000  0000000000000000  000270c8  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 10 .rodata.str1.1 00000097  0000000000000000  0000000000000000  000272ba  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 11 __tracepoints 00000080  0000000000000000  0000000000000000  00027360  2**5
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
 12 _ftrace_events 00000160  0000000000000000  0000000000000000  000273e0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, DATA
 13 __tracepoints_strings 00000013  0000000000000000  0000000000000000  00027540  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 14 .comment      0000001f  0000000000000000  0000000000000000  00027553  2**0
                  CONTENTS, READONLY
 15 .note.GNU-stack 00000000  0000000000000000  0000000000000000  00027572  2**0
                  CONTENTS, READONLY

# pattern

     820:       b8 00 00 00 00          mov    $0x0,%eax
     825:       ff c8                   dec    %eax
     827:       0f 84 d3 cf 00 00       je     d800 <test_pollute_cache+0xcfe0>

# time make -j10

real	1m30.688s
user	9m7.770s
sys	1m44.695s


* 128 cache lines read per system call (random cache lines)
  (CONFIG_IMMEDIATE=n)

# time make -j10

real	1m27.801s
user	9m12.447s
sys	0m59.348s


* 128 imv read per system call
  (CONFIG_IMMEDIATE=y)

# time make -j10

real	1m22.454s
user	9m5.822s
sys	0m58.640s


* 32 cache lines read per system call (random cache lines)
  (CONFIG_IMMEDIATE=n)

# time make -j10

real	1m21.539s
user	9m6.946s
sys	0m57.888s

real	1m26.789s
user	9m11.606s
sys	0m59.392s

real	1m29.461s
user	9m12.195s
sys	0m58.768s

avg sys:	58.68s


* 32 imv read per system call
  (CONFIG_IMMEDIATE=y)

# time make -j10

real	1m21.844s
user	9m7.278s
sys	0m57.648s

real	1m22.123s
user	9m6.850s
sys	0m56.848s

real	1m24.589s
user	9m5.674s
sys	0m58.328s

avg sys:	57.60s



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
